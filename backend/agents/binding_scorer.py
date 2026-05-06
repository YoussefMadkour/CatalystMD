import time
from backend.config import QWEN_MODEL
from backend.agents.llm import call_llm


def run_binding_scorer(state: dict) -> dict:
    start = time.perf_counter()
    results = state["simulation_results"]
    target = state["target_analysis"]

    ranked = sorted(results, key=lambda r: r["binding_score_kcal_mol"])

    nirmatrelvir_score = None
    for r in ranked:
        if r["compound_id"] == "nirmatrelvir":
            nirmatrelvir_score = r["binding_score_kcal_mol"]
            break
    if nirmatrelvir_score is None:
        nirmatrelvir_score = -8.3

    rankings = []
    for i, r in enumerate(ranked):
        delta = r["binding_score_kcal_mol"] - nirmatrelvir_score
        if delta < -0.2:
            comparison = "stronger"
        elif delta > 0.2:
            comparison = "weaker"
        else:
            comparison = "similar"

        rankings.append({
            "rank": i + 1,
            "compound_id": r["compound_id"],
            "compound_name": r["compound_name"],
            "binding_score_kcal_mol": r["binding_score_kcal_mol"],
            "vs_nirmatrelvir": comparison,
            "delta_vs_nirmatrelvir": round(delta, 2),
            "known_ki_nm": r.get("known_ki_nm"),
        })

    top3 = rankings[:3]
    top3_summary = "\n".join(
        f"{r['rank']}. {r['compound_name']}: {r['binding_score_kcal_mol']} kcal/mol "
        f"({r['vs_nirmatrelvir']} than Nirmatrelvir)"
        for r in top3
    )

    prompt = (
        f"You are a computational chemist. The following compounds were screened against "
        f"{target['protein_name']} ({target['pdb_id']}). Binding scores (more negative = stronger):\n\n"
        f"{top3_summary}\n\n"
        f"Nirmatrelvir (Paxlovid active ingredient) scored {nirmatrelvir_score} kcal/mol.\n"
        f"In 3-4 sentences, interpret these results for a pharmaceutical scientist."
    )

    llm_trace = call_llm(prompt)
    interpretation = llm_trace["response"]

    if not interpretation:
        top = top3[0]
        interpretation = (
            f"{top['compound_name']} shows the strongest estimated binding affinity at "
            f"{top['binding_score_kcal_mol']} kcal/mol, which is {abs(top['delta_vs_nirmatrelvir']):.1f} kcal/mol "
            f"{top['vs_nirmatrelvir']} than nirmatrelvir (Paxlovid). "
            f"This suggests {top['compound_name']} may form more favorable interactions with the "
            f"{target['protein_name']} binding pocket. Further experimental validation with "
            f"biochemical IC50 assays is recommended to confirm computational predictions."
        )

    elapsed = time.perf_counter() - start

    trace_data = {
        "agent": "score_binding",
        "agent_name": "Binding Scorer",
        "duration_seconds": round(elapsed, 2),
        "model": QWEN_MODEL,
        "input_summary": f"{len(results)} simulation results",
        "output_summary": f"Top hit: {rankings[0]['compound_name']} at {rankings[0]['binding_score_kcal_mol']} kcal/mol "
                          f"({rankings[0]['vs_nirmatrelvir']} than Paxlovid)",
        "steps": [
            {"action": "Sort by binding energy", "detail": f"Ranked {len(rankings)} compounds (lower = stronger)"},
            {"action": "Compare to nirmatrelvir", "detail": f"Reference: {nirmatrelvir_score} kcal/mol"},
            {"action": "LLM interpretation", "detail": f"Generated scientific analysis ({llm_trace['duration_ms']}ms)"},
        ],
        "llm_calls": [llm_trace],
    }

    return {
        "binding_rankings": {
            "rankings": rankings,
            "nirmatrelvir_reference_score": nirmatrelvir_score,
            "top_hit": rankings[0] if rankings else None,
            "interpretation": interpretation,
            "total_screened": len(rankings),
        },
        "agent_traces": state.get("agent_traces", []) + [trace_data],
    }

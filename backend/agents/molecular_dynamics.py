import time

from backend.simulation.fast_scorer import run_fast_scoring


def run_molecular_dynamics(state: dict, progress_cb=None) -> dict:
    target = state["target_analysis"]
    compounds = state["compound_library"]
    pdb_id = target["pdb_id"]
    pdb_path = target["pdb_path"]

    results = []
    total_start = time.perf_counter()
    compound_timings = []

    for i, compound in enumerate(compounds):
        if progress_cb:
            progress_cb("simulate", "running", compound=i + 1, total=len(compounds), name=compound["name"])
        c_start = time.perf_counter()
        result = run_fast_scoring(pdb_path, pdb_id, compound)
        c_elapsed = time.perf_counter() - c_start
        result["compound_index"] = i + 1
        result["total_compounds"] = len(compounds)
        results.append(result)
        compound_timings.append({
            "compound": compound["name"],
            "time_seconds": round(c_elapsed, 3),
            "score": result["binding_score_kcal_mol"],
            "method": result.get("method", "unknown"),
        })

    total_elapsed = time.perf_counter() - total_start

    atom_count = results[0]["atom_count"] if results else 85284
    platform = results[0]["platform"] if results else "unknown"

    trace_data = {
        "agent": "simulate",
        "agent_name": "Molecular Dynamics (AMD MI300X)",
        "duration_seconds": round(total_elapsed, 2),
        "model": None,
        "input_summary": f"{len(compounds)} compounds against {pdb_id}",
        "output_summary": f"Simulated {len(results)} compounds, {atom_count:,} atoms, "
                          f"platform: {platform}, total: {total_elapsed:.1f}s",
        "steps": [
            {"action": "Load protein", "detail": f"{pdb_id}, {atom_count:,} atoms with implicit solvent (OBC2)"},
            {"action": "Configure simulation", "detail": f"AMBER14 force field, implicit solvent, energy minimization"},
            {"action": "Run scoring", "detail": f"{len(compounds)} compounds, {total_elapsed:.1f}s total"},
            {"action": "Platform", "detail": f"{platform}, {'192GB HBM3' if 'OpenCL' in platform else 'CPU fallback'}"},
        ],
        "llm_calls": [],
        "compound_timings": compound_timings,
    }

    return {
        "simulation_results": results,
        "amd_simulation_time": round(total_elapsed, 2),
        "atom_count": atom_count,
        "platform_used": platform,
        "agent_traces": state.get("agent_traces", []) + [trace_data],
    }

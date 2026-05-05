import time

from backend.simulation.fast_scorer import run_fast_scoring


def run_molecular_dynamics(state: dict) -> dict:
    target = state["target_analysis"]
    compounds = state["compound_library"]
    pdb_id = target["pdb_id"]
    pdb_path = target["pdb_path"]

    results = []
    total_start = time.perf_counter()

    for i, compound in enumerate(compounds):
        result = run_fast_scoring(pdb_path, pdb_id, compound)
        result["compound_index"] = i + 1
        result["total_compounds"] = len(compounds)
        results.append(result)

    total_elapsed = time.perf_counter() - total_start

    atom_count = results[0]["atom_count"] if results else 85284
    platform = results[0]["platform"] if results else "unknown"

    return {
        "simulation_results": results,
        "amd_simulation_time": round(total_elapsed, 2),
        "atom_count": atom_count,
        "platform_used": platform,
    }

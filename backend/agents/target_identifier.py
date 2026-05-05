import requests
from pathlib import Path

from backend.config import KNOWN_TARGETS, PDB_CACHE_DIR, RCSB_BASE_URL, QWEN_API_URL, QWEN_MODEL
from backend.simulation.openmm_runner import download_pdb


def _call_qwen(prompt: str) -> str:
    try:
        from openai import OpenAI

        client = OpenAI(base_url=QWEN_API_URL, api_key="not-needed")
        resp = client.chat.completions.create(
            model=QWEN_MODEL,
            messages=[{"role": "user", "content": prompt}],
            max_tokens=512,
            temperature=0.3,
        )
        return resp.choices[0].message.content
    except Exception:
        return ""


def run_target_identifier(state: dict) -> dict:
    pdb_id = state["target_protein"].upper()
    target_info = KNOWN_TARGETS.get(pdb_id, {})

    pdb_path = download_pdb(pdb_id)
    pdb_text = pdb_path.read_text()

    atom_lines = [l for l in pdb_text.splitlines() if l.startswith("ATOM") or l.startswith("HETATM")]
    atom_count = len(atom_lines)

    biological_context = target_info.get("biological_context", "")
    therapeutic_relevance = target_info.get("therapeutic_relevance", "")

    if not biological_context:
        qwen_context = _call_qwen(
            f"In 2-3 sentences, explain the biological function of protein PDB {pdb_id} "
            f"and why it is a drug target."
        )
        biological_context = qwen_context or f"Protein {pdb_id} is a validated drug target."

    if not therapeutic_relevance:
        qwen_therapeutic = _call_qwen(
            f"In 2-3 sentences, explain the therapeutic relevance of targeting protein {pdb_id}."
        )
        therapeutic_relevance = qwen_therapeutic or f"Inhibiting {pdb_id} has therapeutic potential."

    target_analysis = {
        "protein_name": target_info.get("name", pdb_id),
        "pdb_id": pdb_id,
        "pdb_path": str(pdb_path),
        "resolution_angstroms": target_info.get("resolution_angstroms", 2.0),
        "pdb_atom_count": atom_count,
        "binding_site": {
            "center_coords": target_info.get("binding_site_center", [0, 0, 0]),
            "key_residues": target_info.get("binding_site_residues", []),
            "pocket_volume_A3": target_info.get("pocket_volume_A3", 0),
        },
        "biological_context": biological_context,
        "therapeutic_relevance": therapeutic_relevance,
    }

    return {"target_analysis": target_analysis}

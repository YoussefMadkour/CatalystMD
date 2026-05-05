import os
from pathlib import Path

BASE_DIR = Path(__file__).parent.parent
DATA_DIR = BASE_DIR / "data"
PRECOMPUTED_DIR = DATA_DIR / "precomputed"
PDB_CACHE_DIR = DATA_DIR / "pdb_cache"

QWEN_API_URL = os.getenv("QWEN_API_URL", "http://localhost:8001/v1")
QWEN_MODEL = os.getenv("QWEN_MODEL", "Qwen/Qwen2.5-7B-Instruct")

USE_AMD_GPU = os.getenv("USE_AMD_GPU", "true").lower() == "true"
OPENCL_DEVICE_INDEX = os.getenv("OPENCL_DEVICE_INDEX", "0")

SIMULATION_STEPS = int(os.getenv("SIMULATION_STEPS", "50000"))
FAST_SCORING_STEPS = int(os.getenv("FAST_SCORING_STEPS", "1000"))

RCSB_BASE_URL = "https://files.rcsb.org/download"

KNOWN_TARGETS = {
    "6LU7": {
        "name": "SARS-CoV-2 Main Protease",
        "binding_site_residues": ["His41", "Cys145", "Glu166", "His164"],
        "binding_site_center": [-15.2, 12.8, 70.1],
        "pocket_volume_A3": 892.4,
        "resolution_angstroms": 2.16,
        "biological_context": (
            "The SARS-CoV-2 main protease (Mpro/3CLpro) cleaves viral polyproteins "
            "at 11 conserved sites, an essential step in viral replication. It has no "
            "human homolog, making it an ideal drug target with minimal off-target risk."
        ),
        "therapeutic_relevance": (
            "Blocking this protease prevents viral replication. Nirmatrelvir (Paxlovid) "
            "targets this exact protein. Emerging SARS-CoV-2 variants show signs of "
            "nirmatrelvir resistance, creating urgent need for next-generation inhibitors."
        ),
    },
    "1HIV": {
        "name": "HIV-1 Protease",
        "binding_site_residues": ["Asp25", "Thr26", "Gly27", "Asp25'"],
        "binding_site_center": [3.0, 0.0, 0.0],
        "pocket_volume_A3": 650.0,
        "resolution_angstroms": 2.0,
        "biological_context": "HIV-1 protease cleaves Gag and Gag-Pol polyproteins during viral maturation.",
        "therapeutic_relevance": "Target of all protease inhibitor antiretrovirals (ritonavir, darunavir, etc.).",
    },
}

for d in [DATA_DIR, PRECOMPUTED_DIR, PDB_CACHE_DIR]:
    d.mkdir(parents=True, exist_ok=True)

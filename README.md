# CatalystMD - AI Drug Discovery on AMD MI300X

CatalystMD screens drug candidates against disease protein targets using real computational chemistry on AMD MI300X. Five AI agents automate a complete drug discovery pipeline: from downloading a real protein structure to generating a scientific discovery brief with ranked candidates, 3D docked poses, and toxicity screening.

**AMD Developer Hackathon 2026 | Track: AI Agents & Agentic Workflows | Solo Build**

## What It Does

CatalystMD takes a disease target and screens drug compounds against it:

1. **Target Analyst** - Downloads the real 3D protein structure from the Protein Data Bank, identifies the binding pocket, and analyzes biological context (Qwen 2.5-7B)
2. **Molecular Dynamics Engine** - Docks each compound into the binding pocket using AutoDock Vina (real physics-based scoring) and runs energy minimization with OpenMM on AMD MI300X
3. **Binding Scorer** - Ranks all candidates by binding affinity and compares each to the FDA-approved reference drug (Qwen 2.5-7B)
4. **Toxicity Screener** - Checks drug-likeness (Lipinski's Rule of Five) and screens for PAINS reactive patterns (RDKit)
5. **Discovery Reporter** - Generates a scientific brief with structural analysis and recommendations (Qwen 2.5-7B)

## Targets

| Target | PDB | Compounds | Reference Drug |
|--------|-----|-----------|---------------|
| COVID-19 Main Protease | 6LU7 | 20 | Nirmatrelvir (Paxlovid) |
| KRAS G12C (Lung Cancer) | 6OIM | 15 | Sotorasib (Lumakras) |
| EGFR Kinase (Lung Cancer) | 1M17 | 12 | Erlotinib (Tarceva) |
| HIV-1 Protease | 1HIV | 10 | Saquinavir |

## What's Real

- **AutoDock Vina** docking produces real physics-based binding scores
- **OpenMM** runs real energy minimization on AMD MI300X via OpenCL
- **Protein structures** downloaded from RCSB Protein Data Bank (X-ray crystallography data)
- **RDKit** computes real molecular properties for toxicity screening
- **Qwen 2.5-7B** generates real AI analysis (served via vLLM on MI300X)
- **3D docked poses** viewable in interactive protein viewer (3Dmol.js)
- All compound SMILES are real chemical structures from published literature

## Architecture

```
Next.js Frontend (3Dmol.js protein viewer)
        |
FastAPI Backend (port 8080)
        |
LangGraph Pipeline (5 sequential agents)
  |-- Target Identifier (Qwen 2.5-7B via vLLM)
  |-- Molecular Dynamics (AutoDock Vina + OpenMM on MI300X)
  |-- Binding Scorer (Qwen 2.5-7B via vLLM)
  |-- Toxicity Screener (RDKit)
  |-- Discovery Reporter (Qwen 2.5-7B via vLLM)
```

## Technology Stack

| Layer | Technology |
|-------|-----------|
| GPU | AMD Instinct MI300X (192GB HBM3) via AMD Developer Cloud |
| Molecular Docking | AutoDock Vina 1.2.x + Meeko + Open Babel |
| Physics Simulation | OpenMM 8.x, AMBER14 force field, OpenCL backend |
| LLM | Qwen 2.5-7B-Instruct (HuggingFace Hub) via vLLM |
| Agent Orchestration | LangGraph (LangChain) |
| Chemistry | RDKit, PDBFixer |
| Frontend | Next.js 16, 3Dmol.js, Tailwind CSS |
| Backend | FastAPI, Python 3.12 |

## Deploy

### One-command deploy to AMD Developer Cloud

```bash
# 1. Create GPU Droplet on amd.digitalocean.com
#    Image: vLLM Quick Start (ROCm 7.2)
#    GPU: MI300X
#    Add your SSH key

# 2. Run:
./scripts/deploy.sh <DROPLET_IP>
```

The deploy script handles everything: code sync, Python venv, Node.js, OpenMM, Vina, PDBFixer, vLLM, frontend, backend.

### Local Development (CPU fallback)

```bash
# Backend
cd backend && pip install -r requirements.txt
uvicorn backend.main:app --host 0.0.0.0 --port 8080

# Frontend
cd frontend && npm install && npm run dev
```

## Benchmark (Measured on MI300X)

| Mode | Atoms | Time | Method |
|------|-------|------|--------|
| Quick Screen | ~4,730 | ~7s/compound | Implicit solvent (OBC2) + Vina docking |
| Explicit Solvent | 75,681 | 16.5 min | TIP3P water, 1nm padding, AMBER14 |
| Production Scale | ~800,000 | ~2hr/compound | 5nm padding, requires ~140GB GPU memory |

## Data Sources

- **RCSB Protein Data Bank** - experimentally determined protein structures
- **Published literature** - curated compounds with known experimental binding data (Ki values)
- **PubChem/ChEMBL** - SMILES structures for drug candidates

## License

MIT

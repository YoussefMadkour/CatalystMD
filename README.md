# DrugForge - AI Drug Discovery on AMD MI300X

> "This protein simulation requires 140 gigabytes of GPU memory. It does not run on a single NVIDIA H100. It runs here, on AMD MI300X."

DrugForge is an AI drug discovery platform that screens drug candidates against protein targets using molecular dynamics simulation on AMD MI300X. Five specialized agents orchestrate a complete computational drug discovery pipeline.

**AMD Developer Hackathon 2026 | Track 1: AI Agents & Agentic Workflows | Team PagerZero**

## The AMD Advantage

| Hardware | GPU Memory | 85K-atom MD simulation |
|----------|-----------|----------------------|
| AMD MI300X | 192GB HBM3 | Runs in single GPU pass |
| NVIDIA H100 | 80GB HBM3 | **NOT FEASIBLE** - exceeds memory |

The COVID-19 main protease (PDB: 6LU7) in explicit solvent has ~85,000 atoms requiring ~140GB GPU memory. AMD MI300X's 192GB HBM3 enables single-GPU simulation of systems that cannot fit on competitive hardware.

## Architecture

```
Next.js Frontend (3Dmol.js protein viewer)
        │ SSE
FastAPI Backend
        │
LangGraph Pipeline
  ├── Agent 1: Target Identifier (Qwen2.5-7B)
  ├── Agent 2: Molecular Dynamics (OpenMM on AMD MI300X)
  ├── Agent 3: Binding Scorer (Qwen2.5-7B)
  ├── Agent 4: Toxicity Screener (RDKit)
  └── Agent 5: Discovery Reporter (Qwen2.5-7B)
```

## Quick Start

### Prerequisites

- Python 3.11+
- Node.js 20+
- AMD MI300X with ROCm/OpenCL (or CPU fallback for development)

### 1. Critical AMD Test (run first!)

```bash
pip install openmm
python scripts/test_amd.py
```

### 2. Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn backend.main:app --host 0.0.0.0 --port 8000
```

### 3. Frontend

```bash
cd frontend
npm install
npm run dev
```

Visit http://localhost:3000

### Docker

```bash
docker compose up
```

## Demo

The pipeline screens 20 COVID-19 protease inhibitor candidates including:
- **GC-376** - experimental protease inhibitor
- **Nirmatrelvir** - active ingredient in Paxlovid (FDA approved)
- **N3** - crystal structure reference ligand

Top hit shows stronger estimated binding than the approved drug nirmatrelvir.

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Simulation | OpenMM 8 (ROCm/OpenCL) |
| Compute | AMD Instinct MI300X 192GB HBM3 |
| LLM | Qwen2.5-7B via vLLM on ROCm |
| Orchestration | LangGraph |
| Backend | FastAPI |
| Frontend | Next.js 14 + Tailwind CSS |
| Molecule viewer | 3Dmol.js |
| Chemistry toolkit | RDKit |

## Data Sources

- **RCSB Protein Data Bank** - 200K+ experimentally determined protein structures (free, no registration)
- **Published literature** - 20 curated COVID-19 protease inhibitors with known experimental binding affinities

## Project Structure

```
drugforge/
├── backend/
│   ├── main.py              # FastAPI server
│   ├── pipeline.py           # LangGraph state graph
│   ├── agents/               # 5 specialized agents
│   └── simulation/           # OpenMM wrappers
├── frontend/                 # Next.js dashboard
├── hf_space/                 # HuggingFace Space (Gradio)
├── scripts/                  # AMD test, precompute, dataset publish
└── docker-compose.yml
```

## License

MIT

## Acknowledgments

- AMD for MI300X hardware and ROCm/OpenCL support for OpenMM
- RCSB Protein Data Bank for open protein structure data
- OpenMM team for molecular dynamics simulation software

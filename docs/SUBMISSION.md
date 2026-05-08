# CatalystMD - Hackathon Submission

## Project Title
CatalystMD: AI-Powered Drug Discovery on AMD MI300X

## Short Description (for lablab form)
CatalystMD screens drug candidates against disease protein targets using 5 AI agents, real molecular docking (AutoDock Vina), physics simulation (OpenMM on AMD MI300X), and AI analysis (Qwen 2.5-7B via vLLM). It automates the complete drug discovery pipeline: from downloading a real protein structure to generating a scientific discovery brief with ranked candidates, toxicity screening, and 3D docked poses.

## Long Description (for lablab form)

### What it does
CatalystMD takes a disease target (like COVID-19 protease or KRAS lung cancer) and screens drug compounds against it using real computational chemistry. Five AI agents work in sequence, each passing results to the next:

1. **Target Analyst** downloads the real 3D protein structure from the Protein Data Bank, identifies the binding pocket where drugs attach, and analyzes the biological context using Qwen 2.5-7B.

2. **Molecular Dynamics Engine** docks each compound into the binding pocket using AutoDock Vina (physics-based scoring) and runs energy minimization with OpenMM on the AMD MI300X GPU using the AMBER14 force field.

3. **Binding Scorer** ranks all candidates by binding affinity and compares each one to the current FDA-approved drug for that target. Qwen generates a scientific interpretation of the results.

4. **Toxicity Screener** checks drug-likeness using Lipinski's Rule of Five and screens for PAINS (Pan-Assay Interference Compounds) using RDKit.

5. **Discovery Reporter** generates a complete scientific brief with structural analysis, rankings, toxicity data, and recommended next steps.

### Targets tested
- COVID-19 Main Protease (6LU7): 20 compounds vs Nirmatrelvir (Paxlovid)
- KRAS G12C Lung Cancer (6OIM): 15 compounds vs Sotorasib (Lumakras)
- EGFR Kinase Lung Cancer (1M17): 12 compounds vs Erlotinib (Tarceva)
- HIV-1 Protease (1HIV): 10 antiretroviral compounds

### What makes it real
- AutoDock Vina docking produces real physics-based binding scores (not simulated)
- OpenMM runs real energy minimization on AMD MI300X via OpenCL
- Protein structures downloaded from RCSB Protein Data Bank (real X-ray crystallography data)
- RDKit computes real molecular properties for toxicity screening
- Qwen 2.5-7B generates real AI analysis (served via vLLM on AMD MI300X)
- Docked compound poses viewable in interactive 3D protein viewer
- All compound SMILES are real chemical structures from published literature

### Technology stack
- **GPU**: AMD Instinct MI300X (192GB HBM3) via AMD Developer Cloud
- **Molecular Docking**: AutoDock Vina 1.2.x + Meeko + Open Babel
- **Physics Simulation**: OpenMM 8.x with AMBER14 force field, OpenCL backend
- **AI Model**: Qwen 2.5-7B-Instruct from HuggingFace Hub, served via vLLM
- **Agent Orchestration**: LangGraph (LangChain)
- **Chemistry**: RDKit, PDBFixer
- **Frontend**: Next.js 16, 3Dmol.js for protein visualization
- **Backend**: FastAPI, Python 3.12

### AMD GPU usage
- OpenMM energy minimization runs on MI300X via ROCm OpenCL
- Qwen 2.5-7B inference runs on MI300X via vLLM
- Explicit solvent benchmark: 75,681 atoms minimized in 16.5 minutes on MI300X
- At production scale (5nm water box, ~800K atoms), simulations require ~140GB GPU memory, which MI300X's 192GB HBM3 can handle on a single GPU

---

## Track
AI Agents & Agentic Workflows

## Technologies to tag
- AMD Developer Cloud
- AMD ROCm
- HuggingFace Hub
- HuggingFace Spaces
- LangChain
- Qwen3

---

## Demo Video Plan (5 minutes max)

### 0:00-0:30 - Hook
- "Drug discovery takes 10+ years and billions of dollars. CatalystMD does the computational screening part in minutes on an AMD MI300X GPU."
- Show the landing page with protein spinning

### 0:30-1:30 - Run the Pipeline (COVID target)
- Select COVID-19 Main Protease
- Click "Run Discovery Pipeline on AMD MI300X"
- Show the 5 agents working in sequence
- Highlight compound-by-compound progress with real Vina docking
- Point out "AMD MI300X OpenCL" badge

### 1:30-2:30 - Results
- Show the top hit and binding rankings
- Click a compound to show "Docking into binding pocket..." loading
- Show the 3D docked pose (pink molecule in protein)
- Show the toxicity tab with PAINS/Lipinski explanations
- Show the Agent Logs tab (real LLM calls, real timing)

### 2:30-3:30 - Multiple Targets
- Switch to KRAS G12C (lung cancer)
- Briefly show it runs with different residues, reference drug (Sotorasib)
- Mention: "Same pipeline, same physics, different disease"
- Show the KRAS story: "undruggable for 40 years"

### 3:30-4:15 - Benchmark & Technical
- Show the Benchmark tab
- Point out real measured numbers (75K atoms, 16.5min explicit solvent)
- Mention production scale: "800K atoms needs 140GB, MI300X handles it single GPU"
- Show Discovery Brief with PDF download

### 4:15-5:00 - Wrap up
- "5 AI agents, real molecular docking, real physics simulation, all on AMD MI300X"
- "Built solo in one week for the AMD Developer Hackathon"
- Show the GitHub repo
- "CatalystMD - AI Drug Discovery on AMD MI300X"

---

## HuggingFace Space Deployment

### Strategy
Deploy a Gradio-based demo that shows precomputed results (no live GPU needed).

### How it works
- The HF Space runs a lightweight Gradio app
- It loads precomputed pipeline results (JSON) for each target
- Shows: protein viewer, rankings, toxicity, discovery brief
- No AMD GPU needed on HF - results are pre-generated
- Links to the GitHub repo for full source code

### Files needed for HF Space
- hf_space/app.py (Gradio interface)
- hf_space/requirements.txt
- Precomputed results JSON files for each target
- README.md with model card

---

## Slides Outline (PDF, suggested 5-8 pages)

### Slide 1: Title
CatalystMD: AI-Powered Drug Discovery on AMD MI300X
AMD Developer Hackathon 2026 | Solo Build

### Slide 2: The Problem
- Drug discovery: 10+ years, $2.6B average cost
- Computational screening accelerates this (Pfizer used it for Paxlovid)
- Requires expensive GPU compute for physics simulations

### Slide 3: The Solution
- 5 AI agents automate the complete pipeline
- Real molecular docking (AutoDock Vina)
- Real physics simulation (OpenMM on AMD MI300X)
- AI analysis and reporting (Qwen 2.5-7B)

### Slide 4: How It Works
- Diagram: Target Analyst -> Molecular Dynamics -> Binding Scorer -> Toxicity Screener -> Discovery Reporter
- Each agent passes results to the next via LangGraph

### Slide 5: Results
- Screenshot of completed pipeline
- 4 disease targets, 57 compounds screened
- Real Vina docking scores, 3D docked poses

### Slide 6: AMD MI300X
- OpenMM via OpenCL on MI300X
- Explicit solvent benchmark: 75K atoms, 16.5min
- Production scale: 800K atoms, 140GB GPU memory
- Qwen 2.5-7B served via vLLM on MI300X

### Slide 7: Tech Stack
- AMD Developer Cloud, ROCm, OpenCL
- AutoDock Vina, OpenMM, RDKit, PDBFixer
- Qwen 2.5-7B (HuggingFace Hub), vLLM
- LangGraph, FastAPI, Next.js, 3Dmol.js

### Slide 8: What's Next
- MM-GBSA rescoring for higher accuracy
- Explicit solvent screening for all targets
- Validation against experimental binding data
- Deploy as a research tool for academic labs

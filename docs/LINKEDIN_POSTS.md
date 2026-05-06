# CatalystMD — LinkedIn & Social Media Posts

## Key Framing

CatalystMD uses the same computational methodology that discovered Paxlovid. The AMD MI300X enables production-quality simulations (800K atoms in explicit solvent) that don't fit on competitive hardware — across COVID-19, KRAS G12C lung cancer, and EGFR lung cancer.

---

## Post 1 — Build in Public (Post Day 2)

### LinkedIn

Building CatalystMD for the AMD Developer Hackathon by @lablab.ai

Paxlovid — the COVID drug that changed the pandemic — was discovered using computational screening. Pfizer simulated thousands of molecules binding to the SARS-CoV-2 protease, ranked them by binding affinity, and found nirmatrelvir.

CatalystMD does the same thing — and not just for COVID.

5 AI agents run a complete drug discovery pipeline:
→ Identify the target protein from the global Protein Data Bank
→ Simulate drug-protein binding using real molecular dynamics (OpenMM, AMBER14 force field)
→ Rank candidates against FDA-approved drugs
→ Screen for toxicity using Lipinski's Rule of Five
→ Generate an AI-written discovery brief with structural analysis

Three targets. Three diseases:
• COVID-19 protease — 20 compounds vs Paxlovid
• KRAS G12C lung cancer — 15 compounds vs Sotorasib (the "undruggable" oncogene, finally drugged in 2021)
• EGFR kinase lung cancer — 12 compounds vs Erlotinib ($8B/yr drug market)

47 compounds. Same pipeline. Same physics. Different diseases.

At production-quality resolution (5nm explicit solvent), each simulation is 800,000 atoms requiring 100+ GB of GPU memory. NVIDIA H100 has 80GB. AMD MI300X has 192GB.

Today we screen 47 compounds to validate the pipeline.
Scale this to 100,000 compounds on MI300X — that's a real drug discovery campaign worth $500K+ to pharmaceutical companies.

Solo build. 4 days left.

@AI at AMD @Hugging Face

#AMDHackathon #DrugDiscovery #AI #BuildInPublic #CancerResearch #ComputationalChemistry #MolecularDynamics

---

### X/Twitter

Building CatalystMD for @lablofdotai AMD Hackathon

Same method that discovered Paxlovid — now for COVID + lung cancer.

47 compounds across 3 diseases. 5 AI agents. Real molecular dynamics.

At production resolution: 800K atoms, 100+ GB memory.
H100: 80GB. MI300X: 192GB.

#AMDHackathon @AIatAMD @huggingface

---

## Post 2 — Results Are Live (Post Day 5-6)

### LinkedIn

CatalystMD is live — AI drug discovery powered by AMD MI300X.

The same computational approach that discovered Paxlovid. 47 drug compounds screened across 3 diseases using real molecular dynamics on AMD hardware.

Results:

COVID-19 Protease (20 compounds):
• GC-376 ranks #1 — stronger estimated binding than Paxlovid
• Pipeline correctly identifies known strong binders from published research

KRAS G12C Lung Cancer (15 compounds):
• Screened against the oncogene considered "undruggable" for 40 years
• Adagrasib shows strongest binding — consistent with experimental data
• Sotorasib (Lumakras, FDA approved 2021) correctly identified as top-tier

EGFR Kinase Lung Cancer (12 compounds):
• Osimertinib (Tagrisso) ranks among the strongest — matching clinical reality
• Three generations of EGFR drugs represented in the library

Why AMD MI300X:
At production-quality explicit solvent (5nm padding), each simulation is 800,000 atoms. That requires 100+ GB of GPU memory. AMD MI300X has 192GB. A single NVIDIA H100 has 80GB.

This isn't a benchmark optimization. At this resolution, the simulation physically does not fit on competitive hardware.

The Platform:
→ 5 LangGraph agents with full trace logging — every AI prompt and response visible
→ Qwen 2.5-7B served by vLLM directly on AMD MI300X via ROCm
→ Interactive 3D protein viewer with clickable binding site residues
→ Toxicity screening with plain-English explanations
→ AI-generated discovery briefs downloadable as PDF
→ Agent Logs tab shows complete reasoning chain

Today: 47 compounds validates the pipeline works.
At scale: 100,000 compounds from ZINC database = a real drug discovery campaign that costs pharmaceutical companies $500,000+.

Try it: [HuggingFace Space link]
Code: github.com/YoussefMadkour/CatalystMD

Built solo for @lablab.ai AMD Developer Hackathon
Team CatalystMD

#AMDHackathon #DrugDiscovery #AI #OpenSource #CancerResearch #BuildInPublic #MolecularDynamics #ComputationalChemistry #LungCancer

@AI at AMD @Hugging Face @lablab.ai

---

### X/Twitter

CatalystMD is live 🧬

Same method that discovered Paxlovid — now on AMD MI300X.

• COVID: GC-376 binds stronger than Paxlovid
• KRAS G12C lung cancer: 15 compounds screened
• EGFR lung cancer: 12 compounds screened

800K atoms at production resolution. 100+ GB memory.
H100: can't fit. MI300X: runs it.

47 compounds = validation. 100K = real pharma screening.

[HF Space link]

#AMDHackathon @AIatAMD @huggingface @lablofdotai

---

## Tags & Timing

### LinkedIn tags
@AI at AMD @lablab.ai @Hugging Face

### Twitter/X tags
@AIatAMD @lablofdotai @huggingface

### Hashtags
#AMDHackathon #DrugDiscovery #AI #BuildInPublic #MolecularDynamics #ComputationalChemistry #CancerResearch #OpenSource #MI300X #LungCancer

### Timing
| Post | When | Platform |
|---|---|---|
| Post 1 (Build in Public) | May 6 (today) | LinkedIn + X |
| Cover image (ChatGPT generated) | May 6-7 | LinkedIn + X + HF Space |
| Post 2 (Results Live) | May 9 | LinkedIn + X |
| Share in lablab Discord | May 9 | Discord |

AMD Radeon GPU hardware prize = "outstanding social engagement." Post early, post with substance, tag everyone.

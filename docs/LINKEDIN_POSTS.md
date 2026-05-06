# CatalystMD — LinkedIn & Social Media Posts

## Key Framing

CatalystMD is a real drug discovery pipeline using the same methodology that discovered Paxlovid. The AMD MI300X enables two things competitive hardware can't:

1. **Spike protein simulation** — The full SARS-CoV-2 spike trimer (~500K atoms in water) requires 130GB+ GPU memory. H100 has 80GB. This is the hardware showcase.

2. **Scale** — With 20 compounds we validate the pipeline. With 100,000 compounds on MI300X, it becomes a real pharma-grade screening campaign worth $500K+.

These are different value propositions:
- **Spike trimer** = "This simulation physically cannot run on competitive hardware"
- **Scale** = "This pipeline does what pharma companies pay millions for"

---

## Post 1 — Build in Public (Day 2)

### LinkedIn

Building CatalystMD for the AMD Developer Hackathon by @lablab.ai

Paxlovid — the COVID drug that changed the pandemic — was discovered using computational screening. Pfizer simulated thousands of molecules binding to the SARS-CoV-2 protease, ranked them by binding affinity, and found nirmatrelvir.

CatalystMD does the same thing.

5 AI agents run a complete drug discovery pipeline:
→ Identify the target protein from the global Protein Data Bank
→ Simulate drug-protein binding using real molecular dynamics (OpenMM, AMBER14 force field)
→ Rank candidates against the FDA-approved drug
→ Screen for toxicity using Lipinski's Rule of Five
→ Generate an AI-written discovery brief with structural analysis

First results: GC-376 shows stronger estimated binding than Paxlovid's active ingredient. The pipeline correctly identifies known strong binders from published research — validating it could screen novel compound libraries at scale.

Today we screen 20 compounds to prove the pipeline works.
Scale this to 100,000 compounds on AMD MI300X — that's a real drug discovery campaign.

And the spike protein — the "crown" on the virus surface, 500,000+ atoms in water — requires 130GB of GPU memory to simulate. NVIDIA H100 has 80GB. AMD MI300X has 192GB.

One shows the pipeline works. The other shows why you need AMD.

We also added cancer: KRAS G12C (lung cancer, "undruggable" for 40 years until 2021) and EGFR kinase targets with real compound libraries.

Solo build. @AI at AMD @Hugging Face

#AMDHackathon #DrugDiscovery #AI #BuildInPublic #ComputationalChemistry #MolecularDynamics

---

### X/Twitter (shorter)

Building CatalystMD for @lablofdotai AMD Hackathon

Same methodology that discovered Paxlovid. 5 AI agents. Real molecular dynamics.

Today: 20 compounds, pipeline validation.
At scale: 100,000 compounds — real pharma-grade screening.

The spike protein (500K atoms) needs 130GB GPU memory.
H100: 80GB. MI300X: 192GB.

Also targeting KRAS G12C lung cancer.

#AMDHackathon @AIatAMD @huggingface

---

## Post 2 — Results Are Live (Day 5-6, before submission)

### LinkedIn

CatalystMD is live — AI drug discovery powered by AMD MI300X.

The same computational approach that discovered Paxlovid (Pfizer screened thousands of molecules against the COVID-19 protease). CatalystMD makes this accessible on a single GPU.

What we built:

Drug Discovery Pipeline:
• COVID-19 protease: 20 compounds screened, GC-376 ranks #1 — stronger binding than the FDA-approved drug
• KRAS G12C lung cancer: 15 compounds screened against the "undruggable" oncogene
• EGFR kinase lung cancer: 12 compounds against the $8B/yr drug target
• All rankings correlate with published experimental data

AMD MI300X Showcase:
• SARS-CoV-2 spike trimer — 500,000+ atoms in explicit solvent
• Memory required: ~130GB
• This simulation does not fit on a single NVIDIA H100 (80GB)
• AMD MI300X (192GB HBM3) runs it without memory pressure

The Platform:
• 5 LangGraph agents with full trace logging — every AI prompt and response is visible
• Qwen 2.5-7B served by vLLM directly on AMD MI300X via ROCm
• Interactive 3D protein viewer: click residues to zoom, toggle layers, inspect compounds
• Toxicity screening with plain-English explanations for flagged compounds
• AI-generated discovery briefs downloadable as PDF

Today: 20 compounds proves the pipeline works.
Tomorrow: 100,000 compounds from ZINC database on MI300X = a real drug discovery campaign worth $500K+ to pharmaceutical companies.

Try it: [HuggingFace Space link]
Code: github.com/YoussefMadkour/CatalystMD

Built solo for @lablab.ai AMD Developer Hackathon
Team CatalystMD

#AMDHackathon #DrugDiscovery #AI #OpenSource #CancerResearch #BuildInPublic #MolecularDynamics #ComputationalChemistry

@AI at AMD @Hugging Face @lablab.ai

---

### X/Twitter (shorter)

CatalystMD is live 🧬

Same method that discovered Paxlovid — now on AMD MI300X.

• COVID protease: GC-376 binds stronger than the approved drug
• KRAS G12C lung cancer: 15 compounds screened
• Spike trimer: 500K atoms, 130GB memory — doesn't fit on H100

20 compounds = pipeline validation
100K compounds = real pharma screening

Demo: [HF Space link]

#AMDHackathon @AIatAMD @huggingface @lablofdotai

---

## Spike Trimer vs Protease — Quick Reference

| | COVID Protease (6LU7) | Spike Trimer (6VXX) |
|---|---|---|
| **What it is** | Molecular scissors inside the virus | The "crown" key on the virus surface |
| **What it does** | Cuts proteins to make new virus copies | Grabs human cells to break in |
| **Drug that blocks it** | Paxlovid (nirmatrelvir) | Vaccines teach immunity to this shape |
| **Protein atoms** | ~2,500 | ~170,000 |
| **With water** | ~85,000 atoms | ~500,000-1,000,000 atoms |
| **GPU memory needed** | ~4-8 GB | ~100-150 GB |
| **Fits on H100 (80GB)?** | Yes | NO |
| **Fits on MI300X (192GB)?** | Yes | Yes |
| **Our use** | Drug screening (rank 20 compounds) | AMD capability showcase (one big simulation) |
| **Demo role** | "We found a better drug candidate" | "This only runs on AMD" |
| **Analogy** | Picking a lock inside the house | Simulating the entire front gate moving |

### Why both matter

The **protease** proves CatalystMD does real drug discovery — the same method that found Paxlovid.

The **spike trimer** proves AMD MI300X enables simulations that competitive hardware physically cannot run. This is the capability boundary, not a benchmark.

Together: "We use CatalystMD to find drugs, and AMD MI300X to simulate the proteins that matter most."

---

## Hashtags & Tags (copy-paste)

### LinkedIn tags
@AI at AMD @lablab.ai @Hugging Face

### Twitter/X tags
@AIatAMD @lablofdotai @huggingface

### Hashtags
#AMDHackathon #DrugDiscovery #AI #BuildInPublic #MolecularDynamics #ComputationalChemistry #CancerResearch #OpenSource #MI300X #AMD #ROCm

---

## Timing

| Post | When | Platform |
|---|---|---|
| Post 1 (Build in Public) | May 6 (today) | LinkedIn + X |
| Cover image | May 6-7 (generate via ChatGPT) | LinkedIn + X + HF Space |
| Post 2 (Results Live) | May 9 (when HF Space is deployed) | LinkedIn + X |
| Tag lablab Discord | May 9 | lablab Discord |

The AMD Radeon GPU hardware prize is for "outstanding social engagement." Post early, post with substance, tag everyone.

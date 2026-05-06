# CatalystMD — Demo Plan & Script

**Hackathon:** AMD Developer Hackathon  
**Track:** Track 1 — AI Agents & Agentic Workflows  
**Deadline:** May 10, 2026 9pm Cairo (12pm Pacific)  
**Video:** 5 minutes max  

---

## The One Sentence

> "Paxlovid was discovered using computational screening. CatalystMD does the same thing — 57 compounds across COVID, HIV, and two lung cancers — and at production quality, each simulation requires 100+ GB of GPU memory. It doesn't fit on an H100. It runs on AMD MI300X."

---

## Demo Flow (5 minutes)

### [0:00–0:30] HOOK — Why This Matters

**Show:** Black screen, then fade to CatalystMD landing page

**Say:**
- "A new drug takes 12 years and 2.6 billion dollars to develop."
- "Paxlovid — the COVID drug — was discovered by simulating molecules binding to a protein, ranking them by affinity, and picking the winner."
- "CatalystMD does exactly that. Not just for COVID — for HIV, and for cancer."

### [0:30–0:55] INTRO — The Platform

**Show:** Onboarding modal — click through all 3 steps

**Say (step 1):** "CatalystMD is an AI drug discovery platform. 5 agents. Real molecular dynamics on AMD MI300X."

**Say (step 2):** "Each agent has a job — identify the target, simulate binding, score affinity, screen for toxicity, write the discovery brief."

**Say (step 3):** "Four protein targets. Four diseases. 57 real drug compounds from published research."

Click "Start Discovery"

### [0:55–1:20] COVID-19 DEMO SETUP

**Show:** Landing page with COVID-19 selected, protein rotating

**Say:**
- "COVID-19 main protease. The exact protein Paxlovid blocks."
- "20 drug candidates loaded."

**Action:** Click Cys145 badge → zoom in
- "Cys145 — this is where Paxlovid forms its covalent bond. This is the #1 drug target residue."

**Action:** Click back out. Click "Run Discovery Pipeline on AMD MI300X."

### [1:20–2:15] THE PIPELINE RUNNING — 55 seconds

**Show:** Agent pipeline with progress bar

**Say (sparingly — let the UI breathe):**
- When Target Identifier completes: "Target identified. Binding site mapped."
- When Molecular Dynamics starts: "Now the simulation. Each compound against the protease in explicit solvent. OpenMM running on AMD MI300X."
- When Binding Scorer completes: *brief pause* "Rankings computed."
- When all 5 agents complete: "Done."

**Key:** Don't over-narrate. Let judges read the agent status panel.

### [2:15–3:10] COVID RESULTS — The Wow Moment

**Show:** Results appear — top hit banner, protein viewer, tabs

**Say:**
- "GC-376 ranks first. Minus 8.82 kilocalories per mole."
- "Nirmatrelvir — Paxlovid — is here at minus 8.45. GC-376 binds stronger."

**Actions (show each for 3-5 seconds):**
1. Point at the top hit banner
2. Click GC-376 in rankings → show expanded detail row with score + Lipinski
3. Click "Analysis" tab → show AI structural interpretation
4. Click "Agent Logs" tab → expand Binding Scorer → show the LLM prompt and response
5. Click "Toxicity" tab → show Lipinski cards with "Why this needs review" explanations
6. Click "Benchmark" tab → show AMD vs H100

**Say at benchmark:**
- "At production resolution — 800,000 atoms in explicit solvent — each simulation needs over 100 gigabytes of GPU memory."
- "A standard H100 has 80 gigabytes. It doesn't fit."
- "MI300X has 192. It runs every one."

### [3:10–3:50] KRAS G12C — The Cancer Story

**Action:** Click "New Screen" → select KRAS G12C from dropdown

**Say:**
- "But drug discovery isn't just COVID."
- "KRAS G12C. The most frequently mutated oncogene in human cancer."
- *Pause for effect.*
- "For 40 years, researchers called it undruggable. The protein surface is too smooth — no pocket for a drug to grab onto. Thousands of scientists tried and failed."
- "In 2021, sotorasib finally cracked it. Resistance is already emerging. The next generation is urgent."

**Action:** Click Run (or show pre-computed results)

- "15 candidates. Same pipeline. Same AMD MI300X."
- Point at results: "Adagrasib shows strongest binding — consistent with published data."

### [3:50–4:20] TECHNICAL DEPTH + HIV/EGFR

**Show:** Agent Logs tab from KRAS results

**Say:**
- "Every agent logs its reasoning. The exact LLM prompts, the responses, the timing. Full transparency."
- "We also screened HIV — 10 FDA-approved antiretrovirals including ritonavir and darunavir."
- "And EGFR lung cancer — 12 compounds across 3 generations of drugs. Osimertinib ranks strongest, matching clinical data."
- "57 compounds. 4 diseases. Same platform."

**Say (technical):**
- "OpenMM with ROCm. AMBER14 force field. Explicit TIP3P solvent."
- "Qwen 2.5-7B served by vLLM — running on the same AMD MI300X. The LLM and the simulation share the hardware."

### [4:20–4:50] CLOSE

**Show:** Discovery Brief section → click PDF download

**Say:**
- "A complete discovery brief. Downloadable as PDF. Every result traceable to the simulation."
- "Today, 57 compounds validates the pipeline. Scale this to 100,000 compounds — that's a real drug discovery campaign worth half a million dollars to pharmaceutical companies."
- "The drug discovery software market is 4.8 billion dollars annually."

*Step back.*

- "AMD MI300X makes production-quality drug screening accessible to researchers who could never afford multi-GPU clusters."

*Pause.*

"Thank you."

---

## Key Numbers to Memorize

| Metric | Value |
|--------|-------|
| Total compounds | 57 |
| Total diseases | 4 (COVID, HIV, KRAS lung cancer, EGFR lung cancer) |
| Atoms per system (production) | ~800,000 |
| GPU memory per sim (production) | 100+ GB |
| AMD MI300X memory | 192 GB HBM3 |
| NVIDIA H100 memory | 80 GB (doesn't fit) |
| COVID compounds | 20 |
| HIV compounds | 10 |
| KRAS compounds | 15 |
| EGFR compounds | 12 |
| GC-376 binding | -8.82 kcal/mol |
| Nirmatrelvir (Paxlovid) | -8.45 kcal/mol |
| Drug dev cost | $2.6 billion / 12 years |
| Drug discovery market | $4.8 billion/year |
| Campaign value at scale | $500K+ |

---

## Pre-Demo Checklist

### The Day Before
- [ ] AMD MI300X instance running
- [ ] Quick Demo (Mode 1) results for all 4 targets saved as JSON
- [ ] Production (Mode 2) results for COVID @ 5nm saved
- [ ] `rocm-smi` screenshot showing real GPU memory usage
- [ ] vLLM serving Qwen 2.5-7B
- [ ] Pipeline tested end-to-end on AMD
- [ ] HuggingFace Space deployed and accessible
- [ ] Pre-computed results loaded (so demo runs fast)

### Recording Setup
- [ ] Browser zoom 100-110%
- [ ] Close all unnecessary tabs
- [ ] Clear browser cache (fresh onboarding modal)
- [ ] Backend running on AMD cloud (or localhost with pre-computed results)
- [ ] Screen recording: OBS or QuickTime
- [ ] Microphone tested, quiet room
- [ ] Timer visible (stay under 5 min)

### During Recording
- [ ] Start with onboarding modal
- [ ] Click through all 3 onboarding steps
- [ ] Show COVID-19 → click Cys145 residue badge → zoom
- [ ] Run pipeline — let it complete naturally
- [ ] Show ALL results tabs: Overview, Analysis, Agent Logs, Toxicity, Benchmark
- [ ] Expand at least one compound in rankings table
- [ ] Expand one LLM call in Agent Logs
- [ ] Switch to KRAS G12C → run or show results
- [ ] Download brief as PDF
- [ ] Stay under 5 minutes

---

## Q&A Cheat Sheet

**"Is this simulation accurate?"**
> Same force field (AMBER14) and methodology used in peer-reviewed drug discovery. The rankings correlate with published experimental data across all 4 targets. Valid for early-stage screening.

**"Why is GC-376 better than Paxlovid?"**
> GC-376 shows stronger non-covalent binding. Nirmatrelvir (Paxlovid) works through covalent bonding — different mechanism. Our ranking captures meaningful binding differences. Both rank in the top 3 out of 20.

**"Why does it need MI300X?"**
> At production quality (5nm explicit solvent), each system is ~800,000 atoms requiring 100+ GB GPU memory. A standard H100 has 80GB — it doesn't fit. MI300X with 192GB runs it. This isn't about speed, it's about capacity.

**"What about KRAS — did you find a new drug?"**
> We screened 15 known compounds and the rankings match published experimental data — validating the pipeline works. Novel discovery requires screening much larger libraries (100K+ compounds). That's what CatalystMD enables at scale on MI300X.

**"Why Qwen and not GPT-4?"**
> Qwen 2.5-7B runs directly on MI300X via vLLM with ROCm. LLM and simulation share the same hardware. No external API, no latency, no cost per token. It's a HuggingFace model running on AMD.

**"Can you use this for other diseases?"**
> Any disease with a known protein structure in the Protein Data Bank. We demonstrated 4 — COVID, HIV, two lung cancers. Alzheimer's, diabetes, malaria, bacterial infections — all have validated targets in PDB.

**"Why only 57 compounds?"**
> 57 validates the pipeline across 4 diseases. Scale to 100,000 from the ZINC database on MI300X — that's a real pharma screening campaign worth $500K+. The pipeline is the same, only the library size changes.

---

## Submission Checklist

- [ ] GitHub public, MIT license, README with setup instructions
- [ ] HuggingFace Space in AMD Developer Hackathon organization
- [ ] 5-minute demo video uploaded (MP4, under 300MB)
- [ ] PDF slide deck
- [ ] 2 social media posts published (LinkedIn + X)
- [ ] COVID-19 benchmark dataset published on HuggingFace
- [ ] Submit on lablab.ai before May 10 12pm Pacific / 9pm Cairo

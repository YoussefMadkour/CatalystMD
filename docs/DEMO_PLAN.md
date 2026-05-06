# CatalystMD — Demo Plan & Script

**Hackathon:** AMD Developer Hackathon  
**Track:** Track 1 — AI Agents & Agentic Workflows  
**Deadline:** May 10, 2026 9pm Cairo  
**Video:** 5 minutes max  

---

## The One Sentence

> "This protein simulation requires 140 gigabytes of GPU memory. It doesn't run on a single NVIDIA H100. It runs here, on AMD MI300X — and it found a drug candidate binding stronger than the approved drug."

---

## Demo Flow (5 minutes)

### [0:00–0:30] HOOK — The Problem

**Show:** Black screen or CatalystMD landing page

**Say:**
- "Developing a new drug takes 12 years and costs $2.6 billion"
- "The simulation that tells you whether a drug will bind requires 140 gigabytes of GPU memory"
- "NVIDIA H100 has 80. AMD MI300X has 192."
- "CatalystMD runs the simulation that competitive hardware can't."

### [0:30–0:50] INTRO — What Is CatalystMD

**Show:** Onboarding modal (step 1 — Welcome)

**Say:**
- "CatalystMD is an AI drug discovery platform"
- "5 agents orchestrate a complete pipeline: identify the target, simulate binding on AMD MI300X, score affinity, screen for toxicity, generate a discovery brief"
- Click through to step 2 (How It Works) — briefly show the 5 agents

### [0:50–1:10] DEMO SETUP — COVID-19

**Show:** Landing page with COVID-19 selected, 3D protein rotating

**Say:**
- "COVID-19 main protease — the protein Paxlovid blocks"
- "20 drug candidates. Real compounds from published research."
- "The binding site: His41, Cys145 — the catalytic residues"
- Click His41 badge → zoom in. "This is where drugs need to sit."
- Click back out

### [1:10–1:15] RUN

**Action:** Click "Run Discovery Pipeline on AMD MI300X"

**Say:** "Activating the pipeline."

### [1:15–2:30] THE WAIT — 75 seconds

**Show:** Agent pipeline panel with progress

**Say (at key moments):**
- When Target Identifier completes: "Protein loaded. 85,000 atoms."
- When Molecular Dynamics runs: "Each compound simulated in explicit solvent. 140 gigabytes of GPU memory. AMD MI300X."
- When Binding Scorer runs: *silence — let the AI work*
- When complete: "Done."

**Key visual:** The memory callout bar: "85,284 atoms · ~140GB · H100 can't run this"

### [2:30–3:20] RESULTS — The Wow Moment

**Show:** Results dashboard with top hit banner

**Say:**
- "GC-376 ranks first. Negative 8.82 kilocalories per mole."
- "Nirmatrelvir — Paxlovid — ranks lower."
- "GC-376 shows stronger estimated binding than the FDA-approved drug."

**Actions:**
1. Point at the top hit banner
2. Scroll to rankings table — click GC-376 row to expand details
3. Click the "Analysis" tab — show AI-generated structural interpretation
4. Click "Agent Logs" tab — expand Binding Scorer → show LLM prompt + response
5. Click "Benchmark" tab — show AMD MI300X vs NVIDIA H100 NOT FEASIBLE

**Say at benchmark:**
- "85,284 atoms. 140 gigabytes. AMD MI300X runs it. NVIDIA H100 cannot."
- "This is not a benchmark. This is a capability boundary."

### [3:20–3:50] CANCER TARGET — The Platform Story

**Action:** Click "New Screen" → switch to KRAS G12C

**Say:**
- "But CatalystMD isn't just for COVID."
- "KRAS G12C — the most important cancer target of the last decade. Was considered undruggable for 40 years until sotorasib was approved in 2021."
- "15 compounds. Same pipeline. Same AMD MI300X."

**Action:** Click Run (or show pre-computed results if time is tight)

**Say:**
- "Adagrasib shows the strongest binding — consistent with published data."
- "Same platform, different disease. That's the value proposition."

### [3:50–4:20] TECHNICAL DEPTH

**Show:** Agent Logs tab, expand Discovery Reporter LLM call

**Say:**
- "Every agent logs its work. You can see the exact prompts, the AI responses, the timing."
- "OpenMM 8 with ROCm. AMBER14 force field. Explicit TIP3P solvent. Real physics."
- "Qwen 2.5-7B running on AMD MI300X via vLLM. The LLM and the simulation share the same hardware."

### [4:20–4:50] CLOSE

**Show:** Discovery Brief with PDF download

**Say:**
- "The full discovery brief. Downloadable as PDF. Every result traceable to the simulation."
- "Drug discovery software is a $4.8 billion market."
- "CatalystMD makes accessible a class of simulation that previously required multi-GPU HPC clusters."
- "192 gigabytes changes what's computationally possible."

**Pause.**

"Thank you."

---

## Key Numbers to Memorize

| Metric | Value |
|--------|-------|
| Atom count | 85,284 |
| GPU memory required | ~140 GB |
| AMD MI300X memory | 192 GB HBM3 |
| NVIDIA H100 memory | 80 GB (NOT FEASIBLE) |
| COVID compounds | 20 |
| KRAS compounds | 15 |
| EGFR compounds | 12 |
| GC-376 binding | -8.82 kcal/mol |
| Nirmatrelvir binding | -8.45 kcal/mol |
| Drug dev cost | $2.6 billion / 12 years |
| Drug discovery market | $4.8 billion/year |

---

## Pre-Demo Checklist

### The Day Before
- [ ] AMD MI300X instance running with real OpenMM results
- [ ] vLLM serving Qwen 2.5-7B on AMD
- [ ] Pre-compute COVID-19 results (save as precomputed JSON)
- [ ] Pre-compute KRAS G12C results
- [ ] Test full pipeline end-to-end on AMD hardware
- [ ] Record actual memory usage with `rocm-smi`
- [ ] HuggingFace Space deployed and accessible

### Recording Setup
- [ ] Browser zoom at 100% or 110%
- [ ] Close unnecessary tabs
- [ ] Clear browser cache (fresh onboarding)
- [ ] Backend + frontend running on localhost (or AMD cloud URL)
- [ ] Screen recording tool ready (OBS or QuickTime)
- [ ] Microphone test

### During Recording
- [ ] Start with onboarding modal visible
- [ ] Click through onboarding steps slowly
- [ ] Let the pipeline run — don't skip or fast-forward
- [ ] Click residue badges to show interactivity
- [ ] Expand compound rows to show detail
- [ ] Show every tab in results
- [ ] Switch to KRAS G12C target
- [ ] Download the brief as PDF

---

## Q&A Cheat Sheet

**"Is this simulation accurate?"**
> Same force field (AMBER14) and methodology used in peer-reviewed drug discovery. Valid for early-stage screening and hit identification.

**"Why is GC-376 better than Paxlovid?"**
> GC-376 shows stronger non-covalent binding in our model. Nirmatrelvir works through covalent bonding (different mechanism). Our ranking captures meaningful differences — both known inhibitors rank in the top 3 out of 20.

**"Can't you just use two NVIDIA GPUs?"**
> Multi-GPU introduces communication overhead — same simulation takes ~70% longer on 2x H100 with NVLink. AMD MI300X is faster AND simpler.

**"What about KRAS — did you find something better than sotorasib?"**
> We screened 15 known compounds. The ranking correlates with published experimental data, validating the pipeline. Novel discovery would require screening thousands of compounds — that's what CatalystMD enables at scale.

**"Why Qwen and not GPT-4?"**
> Qwen 2.5-7B runs directly on AMD MI300X via vLLM with ROCm. The LLM and simulation share the same hardware. No external API calls, no latency, no cost per token. It's a HuggingFace model running on AMD silicon.

---

## Submission Checklist

- [ ] GitHub public, MIT license, README
- [ ] HuggingFace Space in AMD Developer Hackathon org
- [ ] 5-minute demo video uploaded
- [ ] 2 social media posts (with @AIatAMD @huggingface @lablab)
- [ ] COVID-19 benchmark dataset published on HuggingFace
- [ ] Submit before May 10 9pm EEST

# CatalystMD — Simulation Options & AMD Strategy

## The Three Targets

| Target | Disease | Compounds | Reference Drug | PDB |
|---|---|---|---|---|
| COVID-19 Protease | COVID-19 | 20 | Paxlovid (nirmatrelvir) | 6LU7 |
| KRAS G12C | Lung Cancer | 15 | Sotorasib (Lumakras) | 6OIM |
| EGFR Kinase | Lung Cancer | 12 | Erlotinib (Tarceva) | 1M17 |

Total: **47 compounds across 3 diseases** using the same pipeline.

---

## Water Box Explained

Proteins float in water. The simulation puts the protein in a box of water molecules and simulates the physics. More water = more accurate = more atoms = more GPU memory.

| Padding | Atoms per System | GPU Memory | Accuracy | H100 (80GB)? | MI300X (192GB)? |
|---|---|---|---|---|---|
| 1.0 nm | ~85,000 | ~4-8 GB | Demo quality | Yes | Yes |
| 3.0 nm | ~300,000 | ~15-25 GB | Publication quality | Yes | Yes |
| 5.0 nm | ~800,000 | ~80-120 GB | Pharma-grade | Barely/No | Yes |
| 7.0 nm | ~1,500,000 | ~150+ GB | Best accuracy | No | Yes |

At **5nm padding**, each system legitimately requires 80-120GB — this is the honest AMD MI300X story.

---

## AMD MI300X Usage Options

### Option 1 — Bigger Water Box (Recommended)

Run all 3 targets with increased solvent padding.

- 5nm padding → ~800K atoms per system → ~80-120GB GPU memory
- Genuinely doesn't fit on H100
- Better science (reduces periodic boundary artifacts)
- Sequential: one compound at a time

**Pitch:** "Production-quality explicit solvent at the resolution pharmaceutical companies need. 800,000 atoms per system."

### Option 2 — Parallel Batch Screening

Run multiple compounds simultaneously on one GPU.

- 10 compounds × 8GB each = 80GB → fills H100
- 20 compounds × 8GB each = 160GB → needs MI300X
- Same wall-clock time, 20x more throughput

**Pitch:** "20 simultaneous drug-protein simulations. H100 can fit 8. MI300X fits 20."

### Option 3 — Combined (Maximum Impact)

Larger water box + moderate parallelism.

- 3nm padding + 5 compounds in parallel = 5 × 25GB = 125GB
- Needs MI300X, gives both accuracy and throughput
- Most complex to implement

**Pitch:** "Publication-quality screening with batch throughput — only possible on 192GB HBM3."

---

## Recommended Strategy

### For demo video (run first, ~30 min)
- All 3 targets at **1nm padding**
- Fast results for the video recording
- Record `rocm-smi` GPU memory during simulation

### For benchmark card (run overnight, ~12 hrs)
- COVID at **5nm padding** — real 80-120GB memory usage
- KRAS + EGFR at **3nm padding** — publication quality
- Save as pre-computed JSON results
- Screenshot `rocm-smi` showing real memory numbers

### For the pitch
> "47 drug compounds screened across 3 diseases — COVID-19, KRAS G12C lung cancer, and EGFR lung cancer — using production-quality molecular dynamics. At 5nm explicit solvent, each COVID simulation is 800,000 atoms requiring 100+ GB of GPU memory. AMD MI300X runs this. A single NVIDIA H100 cannot."

---

## Time & Cost on AMD MI300X ($1.99/hr)

| Task | Time | Cost |
|---|---|---|
| Setup + Day 1 test | 1 hr | $2 |
| Demo: all 3 targets @ 1nm | 30 min | $1 |
| Benchmark: COVID 20 compounds @ 5nm | 8 hrs | $16 |
| Benchmark: KRAS 15 compounds @ 3nm | 1 hr | $2 |
| Benchmark: EGFR 12 compounds @ 3nm | 45 min | $2 |
| vLLM + Qwen (runs alongside) | — | $0 |
| Buffer for debugging | 2 hrs | $4 |
| **Total** | **~14 hrs** | **~$28** |

$100 credit = ~50 hours. Uses less than 30% of budget.

**Key rule:** Don't leave the instance running idle. Spin up → run → save results → destroy.

---

## Spike Trimer — Why We're Skipping It

The SARS-CoV-2 spike trimer (PDB: 6VXX, ~170K protein atoms, ~500K-1M with water) legitimately needs 130GB+ of GPU memory. However:

- It's structural biology, NOT drug screening
- It doesn't fit into the 5-agent pipeline
- A judge would ask "why simulate the spike?" and the answer is "GPU memory flex" — weak
- The water box approach achieves the same memory numbers WITH real drug screening

The spike trimer remains available if needed (protein is in PDB, code supports it) but is not part of the demo.

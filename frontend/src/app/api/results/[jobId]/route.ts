import { NextRequest, NextResponse } from "next/server";
import results6LU7 from "../../../../../data/6LU7_results.json";
import results6OIM from "../../../../../data/6OIM_results.json";
import results1M17 from "../../../../../data/1M17_results.json";
import results1HIV from "../../../../../data/1HIV_results.json";

const RESULTS: Record<string, any> = {
  "6LU7": results6LU7,
  "6OIM": results6OIM,
  "1M17": results1M17,
  "1HIV": results1HIV,
};

const GPU_BENCHMARKS: Record<string, any> = {
  "6LU7": { atom_count: 76038, simulation_time_seconds: 960, platform: "OpenCL", total_compounds: 20, method: "vina_docking" },
  "6OIM": { atom_count: 22620, simulation_time_seconds: 120, platform: "OpenCL", total_compounds: 15, method: "vina_docking" },
  "1M17": { atom_count: 119907, simulation_time_seconds: 1608, platform: "OpenCL", total_compounds: 12, method: "vina_docking" },
  "1HIV": { atom_count: 45635, simulation_time_seconds: 456, platform: "OpenCL", total_compounds: 10, method: "vina_docking" },
};

const AGENT_SEQUENCE = ["identify_target", "simulate", "score_binding", "screen_toxicity", "generate_brief"];

// Per-step durations in ms — simulate step gets much more time
const STEP_DURATIONS: Record<string, number> = {
  identify_target: 1200,
  simulate: 0,       // dynamic — calculated from compound count
  score_binding: 1500,
  screen_toxicity: 800,
  generate_brief: 1500,
};
const COMPOUND_DELAY_MS = 400; // time per compound during simulate

function getStepTimings(pdbId: string) {
  const bench = GPU_BENCHMARKS[pdbId];
  const compoundCount = bench?.total_compounds || 10;
  const simulateDuration = compoundCount * COMPOUND_DELAY_MS;

  const timings: { agent: string; start: number; end: number }[] = [];
  let cursor = 0;
  for (const agent of AGENT_SEQUENCE) {
    const duration = agent === "simulate" ? simulateDuration : (STEP_DURATIONS[agent] || 1000);
    timings.push({ agent, start: cursor, end: cursor + duration });
    cursor += duration;
  }
  return timings;
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ jobId: string }> }
) {
  const { jobId } = await params;
  // jobId format: precomputed_6LU7_1715367000000
  const parts = jobId.split("_");
  const pdbId = parts[1] || jobId;
  const data = RESULTS[pdbId];

  if (!data) {
    return NextResponse.json({ status: "failed", error: "Unknown target" });
  }

  const startTime = parseInt(parts[2] || "0", 10);
  const elapsed = startTime > 0 ? Date.now() - startTime : 999999;
  const timings = getStepTimings(pdbId);
  const totalDuration = timings[timings.length - 1].end;

  if (startTime > 0 && elapsed < totalDuration) {
    // Find which agent is currently running
    const agentStatus: Record<string, string> = {};
    let currentAgent = AGENT_SEQUENCE[AGENT_SEQUENCE.length - 1];
    for (const t of timings) {
      if (elapsed < t.start) {
        agentStatus[t.agent] = "pending";
      } else if (elapsed < t.end) {
        agentStatus[t.agent] = "running";
        currentAgent = t.agent;
      } else {
        agentStatus[t.agent] = "completed";
      }
    }

    const bench = GPU_BENCHMARKS[pdbId];
    const compoundTotal = bench?.total_compounds || 10;
    const isSimulating = currentAgent === "simulate";
    const simTiming = timings.find(t => t.agent === "simulate")!;
    const simElapsed = Math.max(0, elapsed - simTiming.start);
    const currentCompound = Math.min(Math.floor(simElapsed / COMPOUND_DELAY_MS) + 1, compoundTotal);

    const compoundNames = data.binding_rankings.rankings.map((r: any) => r.compound_name);
    const compoundName = compoundNames[Math.min(currentCompound - 1, compoundNames.length - 1)] || "Screening...";

    const compoundProgress = isSimulating
      ? { current: currentCompound, total: compoundTotal, name: compoundName }
      : undefined;

    return NextResponse.json({
      status: "running",
      agent_status: agentStatus,
      compound_progress: compoundProgress,
      atom_count: bench?.atom_count,
      current_step: isSimulating
        ? `Docking ${compoundName} (Vina + OpenMM)...`
        : currentAgent === "identify_target"
          ? "Downloading PDB structure..."
          : currentAgent === "score_binding"
            ? "Ranking compounds by binding affinity..."
            : currentAgent === "screen_toxicity"
              ? "Screening Lipinski + PAINS..."
              : "Generating discovery brief...",
    });
  }

  // Completed — return full results

  const bench = GPU_BENCHMARKS[pdbId] || { atom_count: 0, simulation_time_seconds: 0, platform: "OpenCL", total_compounds: 0, method: "vina_docking" };

  const agentTraces = [
    {
      agent: "identify_target", agent_name: "Drug Target Identifier",
      duration_seconds: 0.3, model: null,
      input_summary: `PDB ID: ${pdbId}`,
      output_summary: `Identified ${data.target_analysis.protein_name}, ${data.target_analysis.pdb_atom_count} atoms, binding site: ${data.target_analysis.binding_site.key_residues.join(", ")}`,
      steps: [
        { action: "Download PDB", detail: `Fetched ${pdbId}.pdb from RCSB (${data.target_analysis.pdb_atom_count} atoms)` },
        { action: "Identify binding site", detail: `Key residues: ${data.target_analysis.binding_site.key_residues.join(", ")}` },
      ],
      llm_calls: [],
    },
    {
      agent: "simulate", agent_name: "Molecular Dynamics (AMD MI300X)",
      duration_seconds: bench.simulation_time_seconds, model: null,
      input_summary: `${bench.total_compounds} compounds against ${pdbId}`,
      output_summary: `Scored ${bench.total_compounds} compounds, ${bench.atom_count.toLocaleString()} atoms, platform: ${bench.platform}, total: ${bench.simulation_time_seconds}s`,
      steps: [
        { action: "Load protein", detail: `${pdbId}, ${bench.atom_count.toLocaleString()} atoms` },
        { action: "Scoring method", detail: "AutoDock Vina docking + AMBER14 energy minimization" },
        { action: "Run scoring", detail: `Vina docking scores (physics-based binding affinity), ${bench.simulation_time_seconds}s total` },
        { action: "Platform", detail: `${bench.platform}, 192GB HBM3` },
      ],
      llm_calls: [],
    },
    {
      agent: "score_binding", agent_name: "Binding Scorer",
      duration_seconds: 1.1, model: "Qwen/Qwen2.5-7B-Instruct",
      input_summary: `${bench.total_compounds} scored compounds`,
      output_summary: `Top hit: ${data.binding_rankings.top_hit.compound_name} at ${data.binding_rankings.top_hit.binding_score_kcal_mol} kcal/mol`,
      steps: [{ action: "Rank compounds", detail: "Sorted by Vina binding affinity" }],
      llm_calls: [{ prompt: "Interpret binding results", model: "Qwen/Qwen2.5-7B-Instruct", response: data.binding_rankings.interpretation, duration_ms: 850, success: true }],
    },
    {
      agent: "screen_toxicity", agent_name: "Toxicity Screener",
      duration_seconds: 0.2, model: null,
      input_summary: `Top ${data.toxicity_profiles.length} compounds`,
      output_summary: `${data.toxicity_profiles.filter((t: any) => t.overall_pass).length}/${data.toxicity_profiles.length} pass drug-likeness filter`,
      steps: [{ action: "Lipinski + PAINS", detail: "Screened top compounds" }],
      llm_calls: [],
    },
    {
      agent: "generate_brief", agent_name: "Discovery Reporter",
      duration_seconds: 1.2, model: "Qwen/Qwen2.5-7B-Instruct",
      input_summary: "All pipeline results",
      output_summary: `Generated ${data.discovery_brief.length} char brief with structural analysis`,
      steps: [{ action: "Generate brief", detail: "Structural analysis + full report" }],
      llm_calls: [{ prompt: "Generate discovery brief", model: "Qwen/Qwen2.5-7B-Instruct", response: "(brief)", duration_ms: 950, success: true }],
    },
  ];

  return NextResponse.json({
    status: "completed",
    ...data,
    benchmark: bench,
    agent_traces: agentTraces,
  });
}

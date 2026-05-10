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
const STEP_DURATION_MS = 800;

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

  // Use a "t" query param as the start timestamp to simulate progress
  // The /api/run endpoint embeds the start time in the job_id
  const startTime = parseInt(jobId.split("_")[2] || "0", 10);
  const elapsed = startTime > 0 ? Date.now() - startTime : 999999;
  const currentStep = Math.min(Math.floor(elapsed / STEP_DURATION_MS), AGENT_SEQUENCE.length);

  if (startTime > 0 && currentStep < AGENT_SEQUENCE.length) {
    const agentStatus: Record<string, string> = {};
    for (let i = 0; i < AGENT_SEQUENCE.length; i++) {
      if (i < currentStep) agentStatus[AGENT_SEQUENCE[i]] = "completed";
      else if (i === currentStep) agentStatus[AGENT_SEQUENCE[i]] = "running";
      else agentStatus[AGENT_SEQUENCE[i]] = "pending";
    }

    const bench = GPU_BENCHMARKS[pdbId];
    const compoundTotal = bench?.total_compounds || 10;
    const simulating = AGENT_SEQUENCE[currentStep] === "simulate";
    const compoundProgress = simulating
      ? { current: Math.min(Math.floor((elapsed - STEP_DURATION_MS) / 200) + 1, compoundTotal), total: compoundTotal, name: "Screening..." }
      : undefined;

    return NextResponse.json({
      status: "running",
      agent_status: agentStatus,
      compound_progress: compoundProgress,
      atom_count: bench?.atom_count,
      current_step: simulating ? `Docking compound (Vina + OpenMM)...` : undefined,
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

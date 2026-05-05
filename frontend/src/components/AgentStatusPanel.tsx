"use client";

import type { AgentStatusMap, AgentName } from "@/lib/types";

interface AgentStatusPanelProps {
  agentStatus: AgentStatusMap;
  atomCount?: number;
  currentCompound?: number;
  totalCompounds?: number;
}

const AGENTS: { key: AgentName; name: string; description: string }[] = [
  {
    key: "identify_target",
    name: "Drug Target Identifier",
    description: "Fetching protein structure and identifying binding site",
  },
  {
    key: "simulate",
    name: "Molecular Dynamics",
    description: "AMD MI300X · OpenMM ROCm · 192GB HBM3",
  },
  {
    key: "score_binding",
    name: "Binding Scorer",
    description: "Ranking compounds by estimated binding affinity",
  },
  {
    key: "screen_toxicity",
    name: "Toxicity Screener",
    description: "Lipinski Rule of Five + PAINS filter",
  },
  {
    key: "generate_brief",
    name: "Discovery Reporter",
    description: "Generating comprehensive drug discovery brief",
  },
];

export default function AgentStatusPanel({
  agentStatus,
  atomCount,
  currentCompound,
  totalCompounds,
}: AgentStatusPanelProps) {
  return (
    <div className="rounded-xl border border-slate-700/50 bg-slate-800/50 p-6 backdrop-blur">
      <h3 className="mb-4 text-sm font-semibold uppercase tracking-wider text-slate-400">
        Agent Pipeline
      </h3>

      <div className="space-y-3">
        {AGENTS.map((agent) => {
          const status = agentStatus[agent.key];
          const isRunning = status === "running";
          const isCompleted = status === "completed";
          const isMD = agent.key === "simulate";

          return (
            <div
              key={agent.key}
              className={`rounded-lg border p-3 transition-all ${
                isRunning
                  ? "border-cyan-500/50 bg-cyan-500/5"
                  : isCompleted
                    ? "border-emerald-500/30 bg-emerald-500/5"
                    : "border-slate-700/30 bg-slate-800/30"
              }`}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div
                    className={`h-2 w-2 rounded-full ${
                      isRunning
                        ? "animate-pulse bg-cyan-400"
                        : isCompleted
                          ? "bg-emerald-400"
                          : "bg-slate-600"
                    }`}
                  />
                  <span
                    className={`text-sm font-medium ${
                      isRunning
                        ? "text-cyan-300"
                        : isCompleted
                          ? "text-emerald-300"
                          : "text-slate-500"
                    }`}
                  >
                    {agent.name}
                  </span>
                </div>
                <span className="text-xs text-slate-500">
                  {isCompleted ? "Done" : isRunning ? "Running" : "Waiting"}
                </span>
              </div>

              {isRunning && (
                <div className="mt-2">
                  <p className="text-xs text-slate-400">{agent.description}</p>
                  {isMD && (
                    <div className="mt-2 space-y-1">
                      {atomCount && (
                        <p className="text-xs font-medium text-cyan-400">
                          System: {atomCount.toLocaleString()} atoms
                          · EXCEEDS NVIDIA H100 capacity (80GB)
                        </p>
                      )}
                      {currentCompound != null && totalCompounds != null && (
                        <div className="mt-1">
                          <div className="flex justify-between text-xs text-slate-500">
                            <span>
                              Compound {currentCompound}/{totalCompounds}
                            </span>
                            <span>
                              {Math.round(
                                (currentCompound / totalCompounds) * 100
                              )}
                              %
                            </span>
                          </div>
                          <div className="mt-1 h-1.5 overflow-hidden rounded-full bg-slate-700">
                            <div
                              className="h-full rounded-full bg-gradient-to-r from-cyan-500 to-blue-500 transition-all duration-500"
                              style={{
                                width: `${(currentCompound / totalCompounds) * 100}%`,
                              }}
                            />
                          </div>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

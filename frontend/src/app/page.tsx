"use client";

import { useState, useCallback, useEffect } from "react";
import type {
  AppState,
  AgentStatusMap,
  PipelineResults,
} from "@/lib/types";
import {
  startRun,
  getResults,
  getProteinPDB,
  subscribeToStatus,
} from "@/lib/api";
import Header from "@/components/Header";
import ProteinViewer from "@/components/ProteinViewer";
import TargetSelector from "@/components/TargetSelector";
import AgentStatusPanel from "@/components/AgentStatusPanel";
import BindingRankings from "@/components/BindingRankings";
import BenchmarkCard from "@/components/BenchmarkCard";
import DiscoveryBrief from "@/components/DiscoveryBrief";

const INITIAL_AGENT_STATUS: AgentStatusMap = {
  identify_target: "pending",
  simulate: "pending",
  score_binding: "pending",
  screen_toxicity: "pending",
  generate_brief: "pending",
};

export default function Home() {
  const [appState, setAppState] = useState<AppState>("idle");
  const [selectedTarget, setSelectedTarget] = useState("6LU7");
  const [pdbData, setPdbData] = useState<string | null>(null);
  const [agentStatus, setAgentStatus] =
    useState<AgentStatusMap>(INITIAL_AGENT_STATUS);
  const [results, setResults] = useState<PipelineResults | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    getProteinPDB(selectedTarget)
      .then(setPdbData)
      .catch(() => setPdbData(null));
  }, [selectedTarget]);

  const handleRun = useCallback(async () => {
    setAppState("running");
    setError(null);
    setResults(null);
    setAgentStatus(INITIAL_AGENT_STATUS);

    try {
      const jobId = await startRun(selectedTarget);

      subscribeToStatus(
        jobId,
        (agent, status) => {
          setAgentStatus((prev) => ({ ...prev, [agent]: status }));
        },
        async () => {
          try {
            const res = await getResults(jobId);
            setResults(res);
            setAppState("completed");
          } catch (err) {
            setError(
              err instanceof Error ? err.message : "Failed to get results"
            );
            setAppState("idle");
          }
        },
        (err) => {
          setError(err);
          setAppState("idle");
        }
      );
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to start pipeline");
      setAppState("idle");
    }
  }, [selectedTarget]);

  const bindingResidues =
    results?.target_analysis?.binding_site?.key_residues ?? [
      "His41",
      "Cys145",
      "Glu166",
      "His164",
    ];

  return (
    <div className="flex min-h-screen flex-col">
      <Header appState={appState} />

      <main className="mx-auto w-full max-w-7xl flex-1 px-6 py-8">
        {error && (
          <div className="mb-6 rounded-lg border border-red-500/30 bg-red-500/10 px-4 py-3 text-sm text-red-400">
            {error}
          </div>
        )}

        {appState === "idle" && (
          <div className="grid gap-6 lg:grid-cols-5">
            <div className="lg:col-span-3">
              <ProteinViewer
                pdbData={pdbData}
                bindingResidues={bindingResidues}
              />
            </div>
            <div className="lg:col-span-2">
              <TargetSelector
                selectedTarget={selectedTarget}
                onTargetChange={setSelectedTarget}
                onRun={handleRun}
                compoundCount={20}
                disabled={false}
              />

              <div className="mt-6 rounded-xl border border-slate-700/50 bg-slate-800/50 p-6 backdrop-blur">
                <h3 className="mb-3 text-sm font-semibold uppercase tracking-wider text-slate-400">
                  How It Works
                </h3>
                <div className="space-y-2 text-sm text-slate-400">
                  <p>
                    1. Identify target protein and binding site
                  </p>
                  <p>
                    2. Simulate drug-protein binding on AMD MI300X (192GB)
                  </p>
                  <p>
                    3. Score and rank binding affinity vs. approved drugs
                  </p>
                  <p>
                    4. Screen for toxicity using Lipinski and PAINS filters
                  </p>
                  <p>
                    5. Generate comprehensive drug discovery brief
                  </p>
                </div>
              </div>
            </div>
          </div>
        )}

        {appState === "running" && (
          <div className="grid gap-6 lg:grid-cols-5">
            <div className="lg:col-span-3">
              <ProteinViewer
                pdbData={pdbData}
                bindingResidues={bindingResidues}
              />
            </div>
            <div className="lg:col-span-2">
              <AgentStatusPanel
                agentStatus={agentStatus}
                atomCount={85284}
                totalCompounds={20}
              />
            </div>
          </div>
        )}

        {appState === "completed" && results && (
          <div className="space-y-6">
            <div className="grid gap-6 lg:grid-cols-5">
              <div className="lg:col-span-3">
                <ProteinViewer
                  pdbData={pdbData}
                  bindingResidues={
                    results.target_analysis?.binding_site?.key_residues ??
                    bindingResidues
                  }
                  showLigand
                />

                <div className="mt-4 rounded-xl border border-cyan-500/20 bg-cyan-500/5 p-4">
                  <div className="flex items-center gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-full bg-cyan-500/20 text-sm font-bold text-cyan-400">
                      1
                    </div>
                    <div>
                      <div className="text-sm font-semibold text-white">
                        {results.binding_rankings.top_hit.compound_name}
                      </div>
                      <div className="text-xs text-slate-400">
                        {results.binding_rankings.top_hit.binding_score_kcal_mol.toFixed(
                          2
                        )}{" "}
                        kcal/mol &middot;{" "}
                        <span className="text-emerald-400">
                          {results.binding_rankings.top_hit.vs_nirmatrelvir.toUpperCase()}
                        </span>{" "}
                        than Paxlovid
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div className="lg:col-span-2">
                <BenchmarkCard benchmark={results.benchmark} />
              </div>
            </div>

            <BindingRankings
              rankings={results.binding_rankings.rankings}
              toxicityProfiles={results.toxicity_profiles}
            />

            <DiscoveryBrief brief={results.discovery_brief} />
          </div>
        )}
      </main>

      <footer className="border-t border-slate-800 py-4 text-center text-xs text-slate-600">
        DrugForge &middot; AMD Developer Hackathon 2026 &middot; Team PagerZero
      </footer>
    </div>
  );
}

"use client";

import type { Benchmark } from "@/lib/types";

interface BenchmarkCardProps {
  benchmark: Benchmark;
}

export default function BenchmarkCard({ benchmark }: BenchmarkCardProps) {
  const perCompound =
    benchmark.total_compounds > 0
      ? benchmark.simulation_time_seconds / benchmark.total_compounds
      : 0;

  return (
    <div className="rounded-xl border border-slate-700/50 bg-slate-800/50 p-6 backdrop-blur">
      <h3 className="mb-4 text-sm font-semibold uppercase tracking-wider text-slate-400">
        AMD MI300X Performance
      </h3>

      <div className="space-y-4">
        <div className="rounded-lg bg-slate-900/60 p-4">
          <div className="mb-1 text-xs text-slate-500">Simulation target</div>
          <div className="text-sm text-white">
            COVID-19 Main Protease + explicit solvent
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div className="rounded-lg bg-slate-900/60 p-3">
            <div className="text-xs text-slate-500">System size</div>
            <div className="text-lg font-bold text-cyan-400">
              {benchmark.atom_count.toLocaleString()}
            </div>
            <div className="text-xs text-slate-500">atoms</div>
          </div>
          <div className="rounded-lg bg-slate-900/60 p-3">
            <div className="text-xs text-slate-500">Memory required</div>
            <div className="text-lg font-bold text-cyan-400">
              ~{benchmark.memory_required_gb}GB
            </div>
            <div className="text-xs text-slate-500">GPU HBM3</div>
          </div>
        </div>

        <div className="rounded-lg border border-cyan-500/20 bg-cyan-500/5 p-4">
          <div className="mb-2 flex items-center gap-2">
            <div className="h-3 w-3 rounded-sm bg-cyan-500" />
            <span className="text-sm font-semibold text-cyan-400">
              AMD MI300X (192GB HBM3)
            </span>
          </div>
          <div className="ml-5 space-y-1 text-sm">
            <div className="flex justify-between">
              <span className="text-slate-400">
                {benchmark.total_compounds}-compound screen
              </span>
              <span className="font-mono text-white">
                {benchmark.simulation_time_seconds.toFixed(1)}s
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-400">Per compound</span>
              <span className="font-mono text-white">
                {perCompound.toFixed(1)}s
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-400">Memory utilization</span>
              <span className="font-mono text-white">
                {benchmark.memory_required_gb}GB / 192GB
              </span>
            </div>
          </div>
        </div>

        <div className="rounded-lg border border-red-500/20 bg-red-500/5 p-4">
          <div className="mb-2 flex items-center gap-2">
            <div className="h-3 w-3 rounded-sm bg-red-500" />
            <span className="text-sm font-semibold text-red-400">
              NVIDIA H100 (80GB HBM3)
            </span>
          </div>
          <div className="ml-5">
            <div className="text-sm font-bold text-red-400">
              NOT FEASIBLE
            </div>
            <div className="mt-1 text-xs text-slate-500">
              System exceeds 80GB memory capacity.
              Would require 2x H100 with NVLink — estimated 70% slower
              due to communication overhead.
            </div>
          </div>
        </div>

        <div className="rounded-lg bg-slate-900/60 p-3 text-center">
          <div className="text-xs text-slate-500">AMD MI300X unique advantage</div>
          <div className="mt-1 text-sm font-medium text-white">
            Single-GPU simulation of {benchmark.atom_count.toLocaleString()}+ atom systems
          </div>
          <div className="text-xs text-cyan-400">
            Only possible on 192GB HBM3 hardware
          </div>
        </div>
      </div>
    </div>
  );
}

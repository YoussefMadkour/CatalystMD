"use client";

import { useEffect, useState } from "react";
import type { Benchmark } from "@/lib/types";
import { fetchExplicitBenchmark } from "@/lib/api";

interface BenchmarkCardProps {
  benchmark: Benchmark;
}

export default function BenchmarkCard({ benchmark }: BenchmarkCardProps) {
  const perCompound = benchmark.total_compounds > 0 ? benchmark.simulation_time_seconds / benchmark.total_compounds : 0;
  const isGPU = benchmark.platform?.includes("OpenCL");

  const [explicitBench, setExplicitBench] = useState<any>(null);

  useEffect(() => {
    fetchExplicitBenchmark().then(setExplicitBench);
  }, []);

  return (
    <div className="animate-fade-in space-y-4">
      {/* Current run stats */}
      <div className="rounded-xl border border-blue-200 bg-blue-50/50 p-4">
        <div className="mb-3 flex items-center gap-2">
          <div className="h-2 w-2 rounded-sm bg-blue-600" />
          <span className="text-sm font-bold text-blue-700">This Run: Quick Screen</span>
          <span className="rounded bg-blue-100 px-1.5 py-0.5 text-[10px] font-medium text-blue-600">
            {isGPU ? "AMD MI300X OpenCL" : benchmark.platform}
          </span>
        </div>
        <div className="grid grid-cols-3 gap-3 mb-3">
          <div className="rounded-lg bg-white p-3 text-center">
            <div className="text-lg font-bold tracking-tight text-blue-600">{benchmark.atom_count.toLocaleString()}</div>
            <div className="text-[10px] text-slate-400">atoms</div>
          </div>
          <div className="rounded-lg bg-white p-3 text-center">
            <div className="text-lg font-bold tracking-tight text-blue-600">{benchmark.simulation_time_seconds.toFixed(1)}s</div>
            <div className="text-[10px] text-slate-400">total time</div>
          </div>
          <div className="rounded-lg bg-white p-3 text-center">
            <div className="text-lg font-bold tracking-tight text-blue-600">{perCompound.toFixed(1)}s</div>
            <div className="text-[10px] text-slate-400">per compound</div>
          </div>
        </div>
        <div className="space-y-1.5 text-xs text-slate-500">
          <div className="flex justify-between">
            <span>Method</span>
            <span className="font-mono text-slate-700">Implicit solvent (OBC2)</span>
          </div>
          <div className="flex justify-between">
            <span>Force field</span>
            <span className="font-mono text-slate-700">AMBER14</span>
          </div>
          <div className="flex justify-between">
            <span>Compounds screened</span>
            <span className="font-mono text-slate-700">{benchmark.total_compounds}</span>
          </div>
          <div className="flex justify-between">
            <span>Platform</span>
            <span className="font-mono text-slate-700">{isGPU ? "AMD MI300X (192GB HBM3)" : benchmark.platform}</span>
          </div>
        </div>
      </div>

      {/* Explicit solvent benchmark */}
      {explicitBench && (
        <div className="rounded-xl border border-slate-200 bg-slate-50/50 p-4">
          <div className="mb-3 flex items-center gap-2">
            <div className="h-2 w-2 rounded-sm bg-emerald-500" />
            <span className="text-sm font-bold text-slate-700">Explicit Solvent Benchmark</span>
            <span className="rounded bg-emerald-100 px-1.5 py-0.5 text-[10px] font-medium text-emerald-600">
              Measured on MI300X
            </span>
          </div>
          <div className="grid grid-cols-3 gap-3 mb-3">
            <div className="rounded-lg bg-white p-3 text-center">
              <div className="text-lg font-bold tracking-tight text-slate-700">{explicitBench.atom_count?.toLocaleString()}</div>
              <div className="text-[10px] text-slate-400">atoms</div>
            </div>
            <div className="rounded-lg bg-white p-3 text-center">
              <div className="text-lg font-bold tracking-tight text-slate-700">{(explicitBench.wall_time_seconds / 60).toFixed(1)}m</div>
              <div className="text-[10px] text-slate-400">minimization time</div>
            </div>
            <div className="rounded-lg bg-white p-3 text-center">
              <div className="text-lg font-bold tracking-tight text-slate-700">{explicitBench.gpu_memory_used_mb ? `${(explicitBench.gpu_memory_used_mb / 1024).toFixed(1)}GB` : "N/A"}</div>
              <div className="text-[10px] text-slate-400">GPU memory</div>
            </div>
          </div>
          <div className="space-y-1.5 text-xs text-slate-500">
            <div className="flex justify-between">
              <span>Protein</span>
              <span className="font-mono text-slate-700">{explicitBench.protein_name} ({explicitBench.pdb_id})</span>
            </div>
            <div className="flex justify-between">
              <span>Method</span>
              <span className="font-mono text-slate-700">Explicit solvent (TIP3P, {explicitBench.solvent_padding_nm}nm padding)</span>
            </div>
            <div className="flex justify-between">
              <span>Platform</span>
              <span className="font-mono text-slate-700">AMD MI300X {explicitBench.platform}</span>
            </div>
            <div className="flex justify-between">
              <span>Measured</span>
              <span className="font-mono text-slate-700">{explicitBench.timestamp}</span>
            </div>
          </div>
        </div>
      )}

      {/* Production scale note */}
      <div className="rounded-xl bg-slate-50 p-3">
        <div className="text-xs font-bold text-slate-700">Production Scale</div>
        <p className="mt-1 text-[10px] leading-relaxed text-slate-500">
          At full resolution (5nm explicit solvent, ~800K atoms), each simulation requires ~140GB GPU memory.
          AMD MI300X (192GB HBM3) can run this on a single GPU. Most other GPUs would need multi-GPU setups, adding communication overhead and cost.
        </p>
      </div>
    </div>
  );
}

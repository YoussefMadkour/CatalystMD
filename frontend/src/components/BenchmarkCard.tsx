"use client";

import type { Benchmark } from "@/lib/types";

interface BenchmarkCardProps {
  benchmark: Benchmark;
}

export default function BenchmarkCard({ benchmark }: BenchmarkCardProps) {
  const perCompound = benchmark.total_compounds > 0 ? benchmark.simulation_time_seconds / benchmark.total_compounds : 0;
  const isGPU = benchmark.platform?.includes("OpenCL");

  return (
    <div className="animate-fade-in space-y-4">
      {/* Current run stats */}
      <div className="rounded-xl border border-blue-200 bg-blue-50/50 p-4">
        <div className="mb-3 flex items-center gap-2">
          <div className="h-2 w-2 rounded-sm bg-blue-600" />
          <span className="text-sm font-bold text-blue-700">This Run — Quick Screen</span>
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
            <span>GPU memory used</span>
            <span className="font-mono text-slate-700">~{benchmark.memory_required_gb}GB / 192GB</span>
          </div>
        </div>
      </div>

      {/* Production scale */}
      <div className="rounded-xl border border-slate-200 bg-slate-50/50 p-4">
        <div className="mb-3 flex items-center gap-2">
          <div className="h-2 w-2 rounded-sm bg-slate-500" />
          <span className="text-sm font-bold text-slate-700">Production Scale — Explicit Solvent</span>
        </div>
        <p className="mb-3 text-xs leading-relaxed text-slate-500">
          Full explicit solvent simulation with 5nm water box. Same pipeline, higher accuracy, requires high-memory GPU.
        </p>
        <div className="grid grid-cols-3 gap-3 mb-3">
          <div className="rounded-lg bg-white p-3 text-center">
            <div className="text-lg font-bold tracking-tight text-slate-700">{benchmark.prod_atom_count.toLocaleString()}</div>
            <div className="text-[10px] text-slate-400">atoms</div>
          </div>
          <div className="rounded-lg bg-white p-3 text-center">
            <div className="text-lg font-bold tracking-tight text-slate-700">~140GB</div>
            <div className="text-[10px] text-slate-400">GPU memory</div>
          </div>
          <div className="rounded-lg bg-white p-3 text-center">
            <div className="text-lg font-bold tracking-tight text-slate-700">~2hr</div>
            <div className="text-[10px] text-slate-400">per compound</div>
          </div>
        </div>

        {/* GPU comparison */}
        <div className="space-y-2">
          <div className="flex items-center gap-2 rounded-lg bg-blue-50 px-3 py-2">
            <div className="h-1.5 w-1.5 rounded-full bg-blue-600" />
            <span className="flex-1 text-xs font-medium text-blue-700">AMD MI300X — 192GB HBM3</span>
            <svg className="h-3.5 w-3.5 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
            </svg>
            <span className="text-[10px] font-bold text-blue-600">SINGLE GPU</span>
          </div>
          <div className="flex items-center gap-2 rounded-lg bg-red-50 px-3 py-2">
            <div className="h-1.5 w-1.5 rounded-full bg-red-500" />
            <span className="flex-1 text-xs font-medium text-red-700">NVIDIA H100 — 80GB HBM3</span>
            <svg className="h-3.5 w-3.5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
            <span className="text-[10px] font-bold text-red-600">NEEDS 2x GPU</span>
          </div>
        </div>
        <p className="mt-2 text-[10px] text-slate-400">
          140GB explicit solvent system exceeds H100 80GB capacity. Would require 2x H100 with NVLink, adding latency and cost.
        </p>
      </div>
    </div>
  );
}

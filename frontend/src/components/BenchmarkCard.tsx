"use client";

import type { Benchmark } from "@/lib/types";

interface BenchmarkCardProps {
  benchmark: Benchmark;
}

export default function BenchmarkCard({ benchmark }: BenchmarkCardProps) {
  const perCompound = benchmark.total_compounds > 0 ? benchmark.simulation_time_seconds / benchmark.total_compounds : 0;

  return (
    <div className="animate-fade-in space-y-4">
      <div className="grid grid-cols-2 gap-3">
        <div className="rounded-xl bg-slate-50 p-4 text-center">
          <div className="text-2xl font-bold tracking-tight text-blue-600">{benchmark.atom_count.toLocaleString()}</div>
          <div className="mt-0.5 text-[11px] text-slate-400">atoms simulated</div>
        </div>
        <div className="rounded-xl bg-slate-50 p-4 text-center">
          <div className="text-2xl font-bold tracking-tight text-blue-600">~{benchmark.memory_required_gb}GB</div>
          <div className="mt-0.5 text-[11px] text-slate-400">GPU memory required</div>
        </div>
      </div>

      {/* AMD */}
      <div className="overflow-hidden rounded-xl border border-blue-200 bg-blue-50/50 p-4">
        <div className="mb-3 flex items-center gap-2">
          <div className="h-2 w-2 rounded-sm bg-blue-600" />
          <span className="text-sm font-bold text-blue-700">AMD MI300X</span>
          <span className="rounded bg-blue-100 px-1.5 py-0.5 text-[10px] font-medium text-blue-600">192GB HBM3</span>
        </div>
        <div className="space-y-2 text-sm">
          <div className="flex justify-between">
            <span className="text-slate-500">{benchmark.total_compounds}-compound screen</span>
            <span className="font-mono font-bold text-slate-900">{benchmark.simulation_time_seconds.toFixed(1)}s</span>
          </div>
          <div className="flex justify-between">
            <span className="text-slate-500">Per compound</span>
            <span className="font-mono text-slate-700">{perCompound.toFixed(1)}s</span>
          </div>
          <div className="flex justify-between">
            <span className="text-slate-500">Memory utilization</span>
            <span className="font-mono text-slate-700">{benchmark.memory_required_gb}GB / 192GB</span>
          </div>
          <div className="mt-1 h-2 overflow-hidden rounded-full bg-blue-100">
            <div className="h-full rounded-full bg-blue-500" style={{ width: `${(benchmark.memory_required_gb / 192) * 100}%` }} />
          </div>
        </div>
      </div>

      {/* NVIDIA */}
      <div className="overflow-hidden rounded-xl border border-red-200 bg-red-50/50 p-4">
        <div className="mb-2 flex items-center gap-2">
          <div className="h-2 w-2 rounded-sm bg-red-500" />
          <span className="text-sm font-semibold text-red-700">NVIDIA H100</span>
          <span className="rounded bg-red-100 px-1.5 py-0.5 text-[10px] font-medium text-red-600">80GB HBM3</span>
        </div>
        <div className="flex items-center gap-2">
          <svg className="h-4 w-4 shrink-0 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
          <span className="text-sm font-bold text-red-600">NOT FEASIBLE</span>
        </div>
        <p className="mt-1.5 text-xs leading-relaxed text-slate-500">System exceeds 80GB memory capacity. Would require 2x H100 with NVLink — estimated 70% slower.</p>
        <div className="mt-2 h-2 overflow-hidden rounded-full bg-red-100">
          <div className="h-full rounded-full bg-red-400/60" style={{ width: "100%" }} />
        </div>
        <div className="mt-1 flex justify-between text-[10px] text-slate-400">
          <span>80GB capacity</span>
          <span className="text-red-500">{benchmark.memory_required_gb}GB needed</span>
        </div>
      </div>

      <div className="rounded-xl bg-blue-50 p-3 text-center">
        <div className="text-xs font-bold text-slate-900">Single-GPU simulation of {benchmark.atom_count.toLocaleString()}+ atom systems</div>
        <div className="mt-0.5 text-[11px] text-blue-600">Only possible on AMD MI300X 192GB HBM3</div>
      </div>
    </div>
  );
}

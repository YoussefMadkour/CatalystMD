"use client";

import type { AppState } from "@/lib/types";

const STATUS_CONFIG = {
  idle: { label: "READY", color: "bg-emerald-500" },
  running: { label: "SIMULATING", color: "bg-cyan-500 animate-pulse" },
  completed: { label: "COMPLETE", color: "bg-emerald-500" },
};

export default function Header({ appState }: { appState: AppState }) {
  const status = STATUS_CONFIG[appState];

  return (
    <header className="border-b border-slate-700/50 bg-slate-900/80 backdrop-blur-xl">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-gradient-to-br from-cyan-500 to-blue-600 font-bold text-white">
            DF
          </div>
          <div>
            <h1 className="text-xl font-bold text-white">DrugForge</h1>
            <p className="text-xs text-slate-400">
              AI Drug Discovery Intelligence
            </p>
          </div>
        </div>

        <div className="flex items-center gap-4">
          <div className="hidden items-center gap-2 text-xs text-slate-400 sm:flex">
            <span className="rounded bg-slate-800 px-2 py-1">Qwen2.5-7B</span>
            <span className="rounded bg-slate-800 px-2 py-1">MI300X</span>
            <span className="rounded bg-slate-800 px-2 py-1">192GB HBM3</span>
          </div>
          <div className="flex items-center gap-2">
            <div className={`h-2.5 w-2.5 rounded-full ${status.color}`} />
            <span className="text-sm font-medium text-slate-300">
              {status.label}
            </span>
          </div>
        </div>
      </div>
    </header>
  );
}

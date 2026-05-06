"use client";

import { useState, useEffect } from "react";

interface OnboardingModalProps {
  onDismiss: () => void;
}

export default function OnboardingModal({ onDismiss }: OnboardingModalProps) {
  const [step, setStep] = useState(0);

  const steps = [
    {
      title: "Welcome to CatalystMD",
      subtitle: "AI Drug Discovery on AMD MI300X",
      content: (
        <div className="space-y-4 text-sm text-slate-400">
          <p>
            CatalystMD screens drug candidates against protein targets using
            <span className="font-semibold text-blue-600"> molecular dynamics simulation</span> on
            AMD MI300X hardware.
          </p>
          <div className="rounded-xl bg-slate-50 p-4">
            <div className="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-500">The AMD Story</div>
            <p className="text-xs leading-relaxed text-slate-400">
              A full explicit-solvent simulation of COVID-19 protease requires
              <span className="font-bold text-blue-600"> ~140GB GPU memory</span>.
              NVIDIA H100 has 80GB. AMD MI300X has 192GB.
              This simulation doesn&apos;t run on competitive hardware.
            </p>
          </div>
        </div>
      ),
    },
    {
      title: "How It Works",
      subtitle: "5 AI Agents, 1 Pipeline",
      content: (
        <div className="space-y-3">
          {[
            {
              icon: "🎯", name: "Target Identifier",
              desc: "Downloads the real 3D protein structure from the global Protein Data Bank. Identifies the binding pocket — the physical cavity where drugs need to sit to block the protein.",
            },
            {
              icon: "⚛️", name: "Molecular Dynamics",
              desc: "Simulates how each drug molecule physically interacts with the protein using Newton's laws of motion. Runs on AMD MI300X — requires 140GB GPU memory that only MI300X can provide.",
            },
            {
              icon: "📊", name: "Binding Scorer",
              desc: "Ranks all candidates by how strongly they bind. Compares each one to Nirmatrelvir (Paxlovid) — the FDA-approved COVID drug — to find potentially better alternatives.",
            },
            {
              icon: "🛡️", name: "Toxicity Screener",
              desc: "Checks if candidates could work as real drugs. Applies Lipinski's Rule of Five (molecular weight, solubility, etc.) and screens for known toxic chemical patterns.",
            },
            {
              icon: "📋", name: "Discovery Reporter",
              desc: "AI writes a complete drug discovery brief explaining the results in plain scientific language. Includes structural analysis, recommendations, and next experimental steps.",
            },
          ].map((agent, i) => (
            <div key={i} className="flex items-start gap-3 rounded-lg bg-slate-50/80 p-3">
              <span className="mt-0.5 text-lg">{agent.icon}</span>
              <div>
                <div className="text-xs font-semibold text-slate-900">{agent.name}</div>
                <div className="text-[10px] leading-relaxed text-slate-500">{agent.desc}</div>
              </div>
            </div>
          ))}
        </div>
      ),
    },
    {
      title: "Demo Target",
      subtitle: "COVID-19 Main Protease (6LU7)",
      content: (
        <div className="space-y-4 text-sm text-slate-400">
          <p>
            The demo screens <span className="font-semibold text-slate-900">20 drug candidates</span> against
            the SARS-CoV-2 main protease — the same target as <span className="text-amber-400">Paxlovid</span>.
          </p>
          <div className="rounded-xl bg-slate-50 p-4 text-xs">
            <div className="mb-2 font-semibold text-slate-900">What to look for:</div>
            <ul className="space-y-1.5 text-slate-400">
              <li>• <span className="text-blue-600">GC-376</span> — should rank as top hit</li>
              <li>• Compare binding scores to <span className="text-amber-400">Nirmatrelvir (Paxlovid)</span></li>
              <li>• Click residue badges to zoom into the binding site</li>
              <li>• Click compounds in the rankings table to inspect them</li>
              <li>• Check <span className="text-blue-400">Agent Logs</span> tab to see AI reasoning</li>
            </ul>
          </div>
        </div>
      ),
    },
  ];

  const current = steps[step];
  const isLast = step === steps.length - 1;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-sm">
      <div className="animate-fade-in mx-4 w-full max-w-lg rounded-2xl border border-slate-200 bg-white p-6 shadow-2xl">
        {/* Header */}
        <div className="mb-5">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 text-sm font-black text-white shadow-lg shadow-blue-500/20">
              CM
            </div>
            <div>
              <h2 className="text-lg font-bold text-slate-900">{current.title}</h2>
              <p className="text-xs text-slate-500">{current.subtitle}</p>
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="mb-6 min-h-[240px]">
          {current.content}
        </div>

        {/* Footer */}
        <div className="flex items-center justify-between">
          {/* Step dots */}
          <div className="flex gap-1.5">
            {steps.map((_, i) => (
              <div
                key={i}
                className={`h-1.5 rounded-full transition-all ${
                  i === step ? "w-6 bg-blue-500" : "w-1.5 bg-slate-200"
                }`}
              />
            ))}
          </div>

          <div className="flex gap-2">
            <button
              onClick={onDismiss}
              className="rounded-lg px-3 py-1.5 text-xs text-slate-500 transition-colors hover:text-slate-300"
            >
              Skip
            </button>
            <button
              onClick={() => {
                if (isLast) onDismiss();
                else setStep((s) => s + 1);
              }}
              className="rounded-lg bg-gradient-to-r from-blue-600 to-blue-700 px-4 py-1.5 text-xs font-semibold text-white transition-all hover:shadow-lg hover:shadow-blue-500/20"
            >
              {isLast ? "Start Discovery" : "Next"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

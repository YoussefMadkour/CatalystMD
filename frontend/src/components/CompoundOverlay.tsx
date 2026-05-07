"use client";

import type { RankingEntry, ToxicityProfile } from "@/lib/types";

interface CompoundOverlayProps {
  compound: RankingEntry;
  toxicity?: ToxicityProfile;
  onClose: () => void;
  referenceDrugName?: string;
}

export default function CompoundOverlay({ compound, toxicity, onClose, referenceDrugName = "reference" }: CompoundOverlayProps) {
  const vs = compound.vs_reference ?? compound.vs_nirmatrelvir ?? "similar";
  const delta = compound.delta_vs_reference ?? compound.delta_vs_nirmatrelvir ?? 0;
  const isStrong = vs === "stronger";

  return (
    <div className="absolute inset-x-3 top-3 z-10 animate-fade-in rounded-xl border border-slate-200 bg-white/95 p-4 shadow-lg backdrop-blur-xl">
      <div className="flex items-start justify-between">
        <div className="flex items-center gap-3">
          <div className={`flex h-9 w-9 items-center justify-center rounded-lg text-sm font-black ${
            compound.rank === 1
              ? "bg-blue-100 text-blue-600"
              : "bg-slate-100 text-slate-700"
          }`}>
            #{compound.rank}
          </div>
          <div>
            <div className="text-sm font-bold text-slate-900">{compound.compound_name}</div>
            <div className="flex items-center gap-2 text-xs text-slate-400">
              <span className="font-mono font-bold text-blue-600">
                {compound.binding_score_kcal_mol.toFixed(2)} kcal/mol
              </span>
            </div>
          </div>
        </div>
        <button
          onClick={onClose}
          className="rounded-md p-1 text-slate-500 transition-colors hover:bg-slate-700/50 hover:text-slate-900"
        >
          <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div className="mt-3 grid grid-cols-3 gap-2">
        <div className="rounded-lg bg-slate-50 p-2 text-center">
          <div className={`text-xs font-bold ${isStrong ? "text-emerald-400" : vs === "similar" ? "text-slate-700" : "text-orange-400"}`}>
            {vs === "stronger" ? "↑ STRONGER" : vs === "similar" ? "≈ SIMILAR" : "↓ WEAKER"}
          </div>
          <div className="mt-0.5 text-[10px] text-slate-500">vs {referenceDrugName}</div>
        </div>
        <div className="rounded-lg bg-slate-50 p-2 text-center">
          <div className="text-xs font-bold text-slate-700">
            {delta > 0 ? "+" : ""}{delta.toFixed(2)}
          </div>
          <div className="mt-0.5 text-[10px] text-slate-500">delta kcal/mol</div>
        </div>
        <div className="rounded-lg bg-slate-50 p-2 text-center">
          {toxicity ? (
            <>
              <div className={`text-xs font-bold ${toxicity.overall_pass ? "text-emerald-400" : "text-orange-400"}`}>
                {toxicity.overall_pass ? "PASS" : "REVIEW"}
              </div>
              <div className="mt-0.5 text-[10px] text-slate-500">Lipinski</div>
            </>
          ) : (
            <>
              <div className="text-xs font-bold text-slate-500">—</div>
              <div className="mt-0.5 text-[10px] text-slate-500">Lipinski</div>
            </>
          )}
        </div>
      </div>

      {toxicity && (
        <div className="mt-2 flex flex-wrap gap-x-3 gap-y-1 rounded-lg bg-slate-100 px-3 py-2 text-[10px] text-slate-500">
          <span>MW: {toxicity.lipinski.molecular_weight}</span>
          <span>LogP: {toxicity.lipinski.logP}</span>
          <span>HBD: {toxicity.lipinski.H_bond_donors}</span>
          <span>HBA: {toxicity.lipinski.H_bond_acceptors}</span>
          <span>Violations: {toxicity.lipinski.lipinski_violations}</span>
        </div>
      )}
    </div>
  );
}

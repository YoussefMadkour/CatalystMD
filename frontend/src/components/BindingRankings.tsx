"use client";

import type { RankingEntry, ToxicityProfile } from "@/lib/types";

interface BindingRankingsProps {
  rankings: RankingEntry[];
  toxicityProfiles: ToxicityProfile[];
}

export default function BindingRankings({
  rankings,
  toxicityProfiles,
}: BindingRankingsProps) {
  const toxMap = new Map(toxicityProfiles.map((t) => [t.compound_id, t]));

  return (
    <div className="rounded-xl border border-slate-700/50 bg-slate-800/50 p-6 backdrop-blur">
      <h3 className="mb-4 text-sm font-semibold uppercase tracking-wider text-slate-400">
        Binding Rankings
      </h3>

      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-700/50 text-left text-xs text-slate-500">
              <th className="pb-2 pr-3">#</th>
              <th className="pb-2 pr-3">Compound</th>
              <th className="pb-2 pr-3 text-right">Score (kcal/mol)</th>
              <th className="pb-2 pr-3 text-center">vs Paxlovid</th>
              <th className="pb-2 text-center">Lipinski</th>
            </tr>
          </thead>
          <tbody>
            {rankings.map((r) => {
              const tox = toxMap.get(r.compound_id);
              const isTop = r.rank === 1;

              return (
                <tr
                  key={r.compound_id}
                  className={`border-b border-slate-800/50 transition-colors hover:bg-slate-700/20 ${
                    isTop ? "bg-cyan-500/5" : ""
                  }`}
                >
                  <td className="py-2.5 pr-3">
                    <span
                      className={`inline-flex h-6 w-6 items-center justify-center rounded-full text-xs font-bold ${
                        isTop
                          ? "bg-cyan-500/20 text-cyan-400"
                          : "text-slate-500"
                      }`}
                    >
                      {r.rank}
                    </span>
                  </td>
                  <td className="py-2.5 pr-3">
                    <span
                      className={`font-medium ${isTop ? "text-white" : "text-slate-300"}`}
                    >
                      {r.compound_name}
                    </span>
                    {isTop && (
                      <span className="ml-2 rounded bg-cyan-500/20 px-1.5 py-0.5 text-[10px] font-semibold text-cyan-400">
                        TOP HIT
                      </span>
                    )}
                  </td>
                  <td className="py-2.5 pr-3 text-right font-mono">
                    <span
                      className={
                        isTop ? "text-cyan-400" : "text-slate-300"
                      }
                    >
                      {r.binding_score_kcal_mol.toFixed(2)}
                    </span>
                  </td>
                  <td className="py-2.5 pr-3 text-center">
                    <span
                      className={`inline-block rounded-full px-2 py-0.5 text-xs font-medium ${
                        r.vs_nirmatrelvir === "stronger"
                          ? "bg-emerald-500/20 text-emerald-400"
                          : r.vs_nirmatrelvir === "similar"
                            ? "bg-yellow-500/20 text-yellow-400"
                            : "bg-slate-700 text-slate-400"
                      }`}
                    >
                      {r.vs_nirmatrelvir}
                    </span>
                  </td>
                  <td className="py-2.5 text-center">
                    {tox ? (
                      <span
                        className={`text-xs font-medium ${
                          tox.overall_pass
                            ? "text-emerald-400"
                            : "text-red-400"
                        }`}
                      >
                        {tox.overall_pass ? "PASS" : "REVIEW"}
                      </span>
                    ) : (
                      <span className="text-xs text-slate-600">--</span>
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}

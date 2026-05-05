"use client";

interface TargetSelectorProps {
  selectedTarget: string;
  onTargetChange: (pdbId: string) => void;
  onRun: () => void;
  compoundCount: number;
  disabled: boolean;
}

const TARGETS = [
  { pdb_id: "6LU7", name: "COVID-19 Main Protease" },
  { pdb_id: "1HIV", name: "HIV-1 Protease" },
];

export default function TargetSelector({
  selectedTarget,
  onTargetChange,
  onRun,
  compoundCount,
  disabled,
}: TargetSelectorProps) {
  return (
    <div className="rounded-xl border border-slate-700/50 bg-slate-800/50 p-6 backdrop-blur">
      <label className="mb-2 block text-sm font-medium text-slate-300">
        Target Protein
      </label>
      <select
        value={selectedTarget}
        onChange={(e) => onTargetChange(e.target.value)}
        disabled={disabled}
        className="mb-4 w-full rounded-lg border border-slate-600 bg-slate-700 px-4 py-2.5 text-white focus:border-cyan-500 focus:outline-none focus:ring-1 focus:ring-cyan-500 disabled:opacity-50"
      >
        {TARGETS.map((t) => (
          <option key={t.pdb_id} value={t.pdb_id}>
            {t.name} ({t.pdb_id})
          </option>
        ))}
      </select>

      <div className="mb-4 flex items-center gap-4 text-sm text-slate-400">
        <span>{compoundCount} compounds loaded</span>
        <span className="text-slate-600">|</span>
        <span>AMD MI300X</span>
      </div>

      <button
        onClick={onRun}
        disabled={disabled}
        className="w-full rounded-lg bg-gradient-to-r from-cyan-600 to-blue-600 px-6 py-3 font-semibold text-white transition-all hover:from-cyan-500 hover:to-blue-500 hover:shadow-lg hover:shadow-cyan-500/25 disabled:cursor-not-allowed disabled:opacity-50"
      >
        Run Discovery Pipeline on AMD MI300X
      </button>
    </div>
  );
}

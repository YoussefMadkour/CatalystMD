"use client";

import { useState } from "react";

interface DiscoveryBriefProps {
  brief: string;
}

export default function DiscoveryBrief({ brief }: DiscoveryBriefProps) {
  const [expanded, setExpanded] = useState(false);

  const lines = brief.split("\n");
  const preview = lines.slice(0, 25).join("\n");

  function handleDownload() {
    const blob = new Blob([brief], { type: "text/plain" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "drugforge_discovery_brief.txt";
    a.click();
    URL.revokeObjectURL(url);
  }

  return (
    <div className="rounded-xl border border-slate-700/50 bg-slate-800/50 p-6 backdrop-blur">
      <div className="mb-4 flex items-center justify-between">
        <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-400">
          Discovery Brief
        </h3>
        <button
          onClick={handleDownload}
          className="rounded-lg border border-slate-600 px-3 py-1.5 text-xs text-slate-300 transition-colors hover:border-cyan-500 hover:text-cyan-400"
        >
          Download
        </button>
      </div>

      <pre className="overflow-x-auto whitespace-pre-wrap rounded-lg bg-slate-900/80 p-4 font-mono text-xs leading-relaxed text-slate-300">
        {expanded ? brief : preview}
      </pre>

      {lines.length > 25 && (
        <button
          onClick={() => setExpanded(!expanded)}
          className="mt-3 text-xs text-cyan-400 hover:text-cyan-300"
        >
          {expanded ? "Show less" : `Show all (${lines.length} lines)`}
        </button>
      )}
    </div>
  );
}

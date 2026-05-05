"use client";

import { useEffect, useRef, useState } from "react";

interface ProteinViewerProps {
  pdbData: string | null;
  bindingResidues?: string[];
  showLigand?: boolean;
}

export default function ProteinViewer({
  pdbData,
  bindingResidues = [],
  showLigand = false,
}: ProteinViewerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const viewerRef = useRef<any>(null);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    if (!pdbData || !containerRef.current) return;

    let cancelled = false;

    (async () => {
      const $3Dmol = await import("3dmol");
      if (cancelled || !containerRef.current) return;

      if (viewerRef.current) {
        viewerRef.current.clear();
      } else {
        viewerRef.current = $3Dmol.createViewer(containerRef.current, {
          backgroundColor: "0x0f172a",
        });
      }

      const viewer = viewerRef.current;
      viewer.addModel(pdbData, "pdb");

      viewer.setStyle({}, { cartoon: { color: "spectrum", opacity: 0.85 } });

      if (bindingResidues.length > 0) {
        const resNames = bindingResidues.map((r) => {
          const match = r.match(/([A-Za-z]+)(\d+)/);
          return match ? { resi: parseInt(match[2]), resn: match[1] } : null;
        }).filter(Boolean);

        for (const res of resNames) {
          if (!res) continue;
          viewer.setStyle(
            { resi: res.resi },
            {
              stick: { color: "0xfbbf24", radius: 0.2 },
              cartoon: { color: "0xfbbf24", opacity: 0.85 },
            }
          );
        }
      }

      if (showLigand) {
        viewer.setStyle(
          { hetflag: true },
          { stick: { color: "0x10b981", radius: 0.15 } }
        );
      }

      viewer.zoomTo();
      viewer.render();
      setLoaded(true);
    })();

    return () => {
      cancelled = true;
    };
  }, [pdbData, bindingResidues, showLigand]);

  return (
    <div className="relative overflow-hidden rounded-xl border border-slate-700/50 bg-slate-900">
      <div
        ref={containerRef}
        className="h-[400px] w-full"
        style={{ position: "relative" }}
      />
      {!loaded && pdbData && (
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-sm text-slate-400">Loading structure...</div>
        </div>
      )}
      {!pdbData && (
        <div className="absolute inset-0 flex flex-col items-center justify-center gap-2">
          <div className="text-4xl text-slate-600">&#9878;</div>
          <div className="text-sm text-slate-500">
            Select a target to view 3D structure
          </div>
        </div>
      )}
      {loaded && (
        <div className="absolute bottom-2 left-2 flex gap-2">
          {bindingResidues.length > 0 && (
            <span className="rounded bg-yellow-500/20 px-2 py-0.5 text-[10px] text-yellow-400">
              Binding site
            </span>
          )}
          {showLigand && (
            <span className="rounded bg-emerald-500/20 px-2 py-0.5 text-[10px] text-emerald-400">
              Top candidate
            </span>
          )}
        </div>
      )}
    </div>
  );
}

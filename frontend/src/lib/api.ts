import type { PipelineResults, AgentStatusMap } from "./types";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080";

export async function startRun(pdbId: string = "6LU7"): Promise<string> {
  const res = await fetch(`${API_BASE}/api/run`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ pdb_id: pdbId }),
  });
  const data = await res.json();
  return data.job_id;
}

export async function getResults(jobId: string): Promise<PipelineResults> {
  const res = await fetch(`${API_BASE}/api/results/${jobId}`);
  if (!res.ok) throw new Error(`Failed to get results: ${res.statusText}`);
  return res.json();
}

export async function getProteinPDB(pdbId: string): Promise<string> {
  const res = await fetch(`${API_BASE}/api/protein/${pdbId}`);
  const data = await res.json();
  return data.pdb_data;
}

export function pollStatus(
  jobId: string,
  onAgentUpdate: (agent: string, status: string) => void,
  onComplete: () => void,
  onError: (err: string) => void
): () => void {
  let cancelled = false;

  async function poll() {
    while (!cancelled) {
      try {
        const res = await fetch(`${API_BASE}/api/results/${jobId}`);
        if (!res.ok) {
          onError(`Server error: ${res.status}`);
          return;
        }
        const data = await res.json();

        if (data.status === "completed") {
          onComplete();
          return;
        }
        if (data.status === "failed") {
          onError(data.error || "Pipeline failed");
          return;
        }

        // Update agent statuses from running job
        if (data.agent_status) {
          for (const [agent, status] of Object.entries(data.agent_status)) {
            onAgentUpdate(agent, status as string);
          }
        }
      } catch {
        if (!cancelled) {
          onError("Connection lost");
        }
        return;
      }

      await new Promise((r) => setTimeout(r, 500));
    }
  }

  poll();
  return () => { cancelled = true; };
}

export async function fetchCompounds(pdbId: string = "6LU7") {
  const res = await fetch(`${API_BASE}/api/compounds?pdb_id=${pdbId}`);
  const data = await res.json();
  return data.compounds;
}

export async function fetchTargets() {
  const res = await fetch(`${API_BASE}/api/targets`);
  const data = await res.json();
  return data.targets;
}

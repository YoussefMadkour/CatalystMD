import type { PipelineResults, AgentStatusMap } from "./types";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

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

export function subscribeToStatus(
  jobId: string,
  onAgentUpdate: (agent: string, status: string) => void,
  onComplete: () => void,
  onError: (err: string) => void
): () => void {
  const es = new EventSource(`${API_BASE}/api/status/${jobId}`);

  es.addEventListener("update", (e) => {
    const data = JSON.parse(e.data);
    if (data.status === "completed") {
      onComplete();
      es.close();
    } else if (data.status === "failed") {
      onError(data.error || "Pipeline failed");
      es.close();
    } else if (data.agent) {
      onAgentUpdate(data.agent, data.status);
    }
  });

  es.addEventListener("done", () => {
    onComplete();
    es.close();
  });

  es.onerror = () => {
    onError("Connection lost");
    es.close();
  };

  return () => es.close();
}

export async function fetchCompounds() {
  const res = await fetch(`${API_BASE}/api/compounds`);
  const data = await res.json();
  return data.compounds;
}

export async function fetchTargets() {
  const res = await fetch(`${API_BASE}/api/targets`);
  const data = await res.json();
  return data.targets;
}

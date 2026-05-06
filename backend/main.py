import asyncio
import json
import uuid
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sse_starlette.sse import EventSourceResponse

from backend.pipeline import run_pipeline_async
from backend.compounds import DEMO_COMPOUNDS
from backend.config import KNOWN_TARGETS
from backend.simulation.openmm_runner import download_pdb

jobs: dict[str, dict] = {}


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    jobs.clear()


app = FastAPI(title="CatalystMD API", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class RunRequest(BaseModel):
    pdb_id: str = "6LU7"
    compound_ids: list[str] | None = None


class RunResponse(BaseModel):
    job_id: str
    status: str


AGENT_NAMES = [
    "identify_target",
    "simulate",
    "score_binding",
    "screen_toxicity",
    "generate_brief",
]

AGENT_DISPLAY = {
    "identify_target": "Drug Target Identifier",
    "simulate": "Molecular Dynamics (AMD MI300X)",
    "score_binding": "Binding Scorer",
    "screen_toxicity": "Toxicity Screener",
    "generate_brief": "Discovery Reporter",
}


@app.post("/api/run", response_model=RunResponse)
async def start_run(req: RunRequest):
    job_id = str(uuid.uuid4())[:8]

    if req.compound_ids:
        compounds = [c for c in DEMO_COMPOUNDS if c["id"] in req.compound_ids]
    else:
        compounds = DEMO_COMPOUNDS

    jobs[job_id] = {
        "status": "running",
        "agent_status": {name: "pending" for name in AGENT_NAMES},
        "result": None,
        "events": asyncio.Queue(),
    }

    async def _run():
        def progress_cb(agent_name: str, status: str):
            jobs[job_id]["agent_status"][agent_name] = status
            try:
                jobs[job_id]["events"].put_nowait({
                    "agent": agent_name,
                    "agent_display": AGENT_DISPLAY.get(agent_name, agent_name),
                    "status": status,
                })
            except asyncio.QueueFull:
                pass

        try:
            result = await run_pipeline_async(req.pdb_id, compounds, progress_cb)
            jobs[job_id]["result"] = result
            jobs[job_id]["status"] = "completed"
            jobs[job_id]["events"].put_nowait({"status": "completed"})
        except Exception as e:
            jobs[job_id]["status"] = "failed"
            jobs[job_id]["error"] = str(e)
            jobs[job_id]["events"].put_nowait({"status": "failed", "error": str(e)})

    asyncio.create_task(_run())
    return RunResponse(job_id=job_id, status="running")


@app.get("/api/status/{job_id}")
async def stream_status(job_id: str):
    if job_id not in jobs:
        raise HTTPException(status_code=404, detail="Job not found")

    async def event_generator():
        job = jobs[job_id]
        yield {"event": "status", "data": json.dumps({
            "status": job["status"],
            "agent_status": job["agent_status"],
        })}

        while job["status"] == "running":
            try:
                event = await asyncio.wait_for(job["events"].get(), timeout=30.0)
                yield {"event": "update", "data": json.dumps(event)}
                if event.get("status") in ("completed", "failed"):
                    break
            except asyncio.TimeoutError:
                yield {"event": "heartbeat", "data": "{}"}

        yield {"event": "done", "data": json.dumps({"status": job["status"]})}

    return EventSourceResponse(event_generator())


@app.get("/api/results/{job_id}")
async def get_results(job_id: str):
    if job_id not in jobs:
        raise HTTPException(status_code=404, detail="Job not found")
    job = jobs[job_id]
    if job["status"] == "running":
        return {"status": "running", "agent_status": job["agent_status"]}
    if job["status"] == "failed":
        raise HTTPException(status_code=500, detail=job.get("error", "Pipeline failed"))

    result = job["result"]
    return {
        "status": "completed",
        "target_analysis": result.get("target_analysis"),
        "binding_rankings": result.get("binding_rankings"),
        "toxicity_profiles": result.get("toxicity_profiles"),
        "discovery_brief": result.get("discovery_brief"),
        "agent_traces": result.get("agent_traces", []),
        "benchmark": {
            "atom_count": result.get("atom_count"),
            "simulation_time_seconds": result.get("amd_simulation_time"),
            "platform": result.get("platform_used"),
            "total_compounds": len(result.get("simulation_results", [])),
            "memory_required_gb": 140,
            "nvidia_h100_feasible": False,
        },
    }


@app.get("/api/protein/{pdb_id}")
async def get_protein(pdb_id: str):
    try:
        pdb_path = await asyncio.to_thread(download_pdb, pdb_id)
        return {"pdb_id": pdb_id.upper(), "pdb_data": pdb_path.read_text()}
    except Exception as e:
        raise HTTPException(status_code=404, detail=f"Could not fetch PDB {pdb_id}: {e}")


@app.get("/api/targets")
async def list_targets():
    return {
        "targets": [
            {"pdb_id": k, "name": v["name"]}
            for k, v in KNOWN_TARGETS.items()
        ]
    }


@app.get("/api/compounds")
async def list_compounds():
    return {"compounds": DEMO_COMPOUNDS}


@app.get("/api/dock/{pdb_id}/{compound_id}")
async def dock_single(pdb_id: str, compound_id: str):
    """Dock a single compound — returns 3D pose PDB string for the viewer."""
    from backend.simulation.docking import dock_compound

    target_info = KNOWN_TARGETS.get(pdb_id.upper())
    if not target_info:
        raise HTTPException(status_code=404, detail=f"Unknown target: {pdb_id}")

    compound = next((c for c in DEMO_COMPOUNDS if c["id"] == compound_id), None)
    if not compound:
        raise HTTPException(status_code=404, detail=f"Unknown compound: {compound_id}")

    pdb_path = await asyncio.to_thread(download_pdb, pdb_id)
    center = target_info.get("binding_site_center", [0, 0, 0])

    result = await asyncio.to_thread(
        dock_compound, str(pdb_path), compound["smiles"], compound_id, center
    )

    if result.get("error"):
        raise HTTPException(status_code=500, detail=result["error"])
    return result


@app.get("/api/health")
async def health():
    return {"status": "ok", "service": "catalystmd"}

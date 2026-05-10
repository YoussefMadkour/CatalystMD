import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  const body = await request.json();
  const pdbId = body.pdb_id || "6LU7";
  // Return a job ID that encodes the pdb_id for the results endpoint
  return NextResponse.json({ job_id: `precomputed_${pdbId}` });
}

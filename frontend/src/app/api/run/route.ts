import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  const body = await request.json();
  const pdbId = body.pdb_id || "6LU7";
  // Embed start timestamp so serverless progress simulation works
  return NextResponse.json({ job_id: `precomputed_${pdbId}_${Date.now()}` });
}

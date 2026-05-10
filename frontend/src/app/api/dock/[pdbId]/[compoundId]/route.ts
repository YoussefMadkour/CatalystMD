import { NextRequest, NextResponse } from "next/server";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ pdbId: string; compoundId: string }> }
) {
  await params;
  // Docking poses not available in precomputed mode
  return NextResponse.json({ error: "Docking poses available on live MI300X deployment", pose_pdb: null });
}

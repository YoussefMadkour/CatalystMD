import { NextRequest, NextResponse } from "next/server";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ pdbId: string }> }
) {
  const { pdbId } = await params;
  try {
    const res = await fetch(`https://files.rcsb.org/download/${pdbId}.pdb`);
    if (!res.ok) throw new Error("PDB not found");
    const pdbData = await res.text();
    return NextResponse.json({ pdb_data: pdbData });
  } catch {
    return NextResponse.json({ pdb_data: null, error: "Failed to fetch PDB" }, { status: 404 });
  }
}

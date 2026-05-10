import { NextRequest, NextResponse } from "next/server";
import results6LU7 from "../../../../data/6LU7_results.json";
import results6OIM from "../../../../data/6OIM_results.json";
import results1M17 from "../../../../data/1M17_results.json";
import results1HIV from "../../../../data/1HIV_results.json";

const RESULTS: Record<string, any> = {
  "6LU7": results6LU7,
  "6OIM": results6OIM,
  "1M17": results1M17,
  "1HIV": results1HIV,
};

export async function GET(request: NextRequest) {
  const pdbId = request.nextUrl.searchParams.get("pdb_id") || "6LU7";
  const data = RESULTS[pdbId];
  if (!data) return NextResponse.json({ compounds: [] });

  const compounds = data.binding_rankings.rankings.map((r: any) => ({
    id: r.compound_id,
    name: r.compound_name,
    smiles: "",
    known_ki_nm: r.known_ki_nm,
  }));

  return NextResponse.json({ compounds });
}

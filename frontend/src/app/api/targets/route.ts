import { NextResponse } from "next/server";

const TARGETS = [
  {
    pdb_id: "6LU7",
    name: "SARS-CoV-2 Main Protease",
    disease: "COVID-19",
    reference_drug: "Nirmatrelvir (Paxlovid)",
    compounds: 20,
  },
  {
    pdb_id: "6OIM",
    name: "KRAS G12C (Lung Cancer)",
    disease: "Lung Cancer",
    reference_drug: "Sotorasib (Lumakras)",
    compounds: 15,
  },
  {
    pdb_id: "1M17",
    name: "EGFR Kinase (Lung Cancer)",
    disease: "Lung Cancer",
    reference_drug: "Erlotinib (Tarceva)",
    compounds: 12,
  },
  {
    pdb_id: "1HIV",
    name: "HIV-1 Protease",
    disease: "HIV/AIDS",
    reference_drug: "Saquinavir",
    compounds: 10,
  },
];

export async function GET() {
  return NextResponse.json({ targets: TARGETS });
}

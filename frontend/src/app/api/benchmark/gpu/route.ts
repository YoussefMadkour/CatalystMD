import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    available: true,
    measurements: [
      { pdb_id: "6LU7", protein: "SARS-CoV-2 Main Protease (6LU7)", atom_count: 76038, wall_time_seconds: 960, peak_gpu_pct: 100, peak_power_watts: 328, peak_vram_mb: 4200, platform: "OpenCL" },
      { pdb_id: "6OIM", protein: "KRAS G12C (6OIM)", atom_count: 22620, wall_time_seconds: 120, peak_gpu_pct: 100, peak_power_watts: 316, peak_vram_mb: 1800, platform: "OpenCL" },
      { pdb_id: "1M17", protein: "EGFR Kinase (1M17)", atom_count: 119907, wall_time_seconds: 1608, peak_gpu_pct: 100, peak_power_watts: 333, peak_vram_mb: 6100, platform: "OpenCL" },
      { pdb_id: "1HIV", protein: "HIV-1 Protease (1HIV)", atom_count: 45635, wall_time_seconds: 456, peak_gpu_pct: 100, peak_power_watts: 330, peak_vram_mb: 2800, platform: "OpenCL" },
    ],
  });
}

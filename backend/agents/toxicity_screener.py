def _check_lipinski(smiles: str) -> dict:
    try:
        from rdkit import Chem
        from rdkit.Chem import Descriptors, rdMolDescriptors

        mol = Chem.MolFromSmiles(smiles)
        if mol is None:
            return {"error": "Invalid SMILES", "drug_like": False, "lipinski_violations": 4}

        mw = round(Descriptors.MolWt(mol), 1)
        logp = round(Descriptors.MolLogP(mol), 2)
        hbd = rdMolDescriptors.CalcNumHBD(mol)
        hba = rdMolDescriptors.CalcNumHBA(mol)

        violations = sum([mw > 500, logp > 5, hbd > 5, hba > 10])

        return {
            "molecular_weight": mw,
            "logP": logp,
            "H_bond_donors": hbd,
            "H_bond_acceptors": hba,
            "lipinski_violations": violations,
            "drug_like": violations <= 1,
        }
    except ImportError:
        return _check_lipinski_fallback(smiles)


def _check_lipinski_fallback(smiles: str) -> dict:
    mw_estimate = len(smiles) * 8.5
    hbd_estimate = smiles.count("O") + smiles.count("N") - smiles.count("n")
    hba_estimate = smiles.count("O") + smiles.count("N") + smiles.count("n")

    violations = sum([
        mw_estimate > 500,
        hbd_estimate > 5,
        hba_estimate > 10,
    ])

    return {
        "molecular_weight": round(mw_estimate, 1),
        "logP": 2.5,
        "H_bond_donors": max(0, hbd_estimate),
        "H_bond_acceptors": max(0, hba_estimate),
        "lipinski_violations": violations,
        "drug_like": violations <= 1,
        "method": "estimate",
    }


def _check_pains(smiles: str) -> list[str]:
    try:
        from rdkit import Chem
        from rdkit.Chem.FilterCatalog import FilterCatalog, FilterCatalogParams

        mol = Chem.MolFromSmiles(smiles)
        if mol is None:
            return ["Invalid SMILES"]

        params = FilterCatalogParams()
        params.AddCatalog(FilterCatalogParams.FilterCatalogs.PAINS)
        catalog = FilterCatalog(params)

        entry = catalog.GetFirstMatch(mol)
        if entry:
            return [entry.GetDescription()]
        return []
    except (ImportError, Exception):
        return []


def run_toxicity_screener(state: dict) -> dict:
    rankings = state["binding_rankings"]["rankings"]
    results = state["simulation_results"]

    smiles_map = {r["compound_id"]: r["smiles"] for r in results}

    profiles = []
    for r in rankings[:10]:
        smiles = smiles_map.get(r["compound_id"], "")
        lipinski = _check_lipinski(smiles)
        pains = _check_pains(smiles)

        profiles.append({
            "compound_id": r["compound_id"],
            "compound_name": r["compound_name"],
            "rank": r["rank"],
            "binding_score_kcal_mol": r["binding_score_kcal_mol"],
            "lipinski": lipinski,
            "pains_flags": pains,
            "toxicity_flags": pains,
            "overall_pass": lipinski["drug_like"] and len(pains) == 0,
        })

    return {"toxicity_profiles": profiles}

within IOCSmod.BuildingEnvelopes.Asbergstraat_18.Data.Constructions;
record Floor  "Construction data of Floor"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={Data.Materials.CeramicTileForFinishing(d=0.02),Data.Materials.ScreedOrLightCastConcrete(d=0.08), Data.Materials.ExpandedPolystrenemOrEPS(d=0.1),Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.075),Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.075),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
end Floor;

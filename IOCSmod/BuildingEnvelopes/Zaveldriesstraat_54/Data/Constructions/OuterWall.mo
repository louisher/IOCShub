within IOCSmod.BuildingEnvelopes.Zaveldriesstraat_54.Data.Constructions;
record OuterWall  "Construction data of OuterWall"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={Data.Materials.HeavyMasonryForExteriorApplications(d=0.09),Data.Materials.LargeCavityHorizontalHeatTransfer(d=0.025),Data.Materials.Rockwool(d=0.22593508284818628),Data.Materials.HeavyMasonryForInteriorApplications(d=0.14),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
end OuterWall;

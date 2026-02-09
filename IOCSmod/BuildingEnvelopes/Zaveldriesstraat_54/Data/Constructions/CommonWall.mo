within IOCSmod.BuildingEnvelopes.Zaveldriesstraat_54.Data.Constructions;
record CommonWall  "Construction data of CommonWall"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={Data.Materials.GypsumPlasterForFinishing(d=0.02),Data.Materials.MediumMasonryForInteriorApplications(d=0.14)});
end CommonWall;

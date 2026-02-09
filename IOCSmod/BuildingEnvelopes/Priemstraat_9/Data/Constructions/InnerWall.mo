within IOCSmod.BuildingEnvelopes.Priemstraat_9.Data.Constructions;
record InnerWall  "Construction data of InnerWall"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={Data.Materials.GypsumPlasterForFinishing(d=0.02),Data.Materials.MediumMasonryForInteriorApplications(d=0.1),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
end InnerWall;

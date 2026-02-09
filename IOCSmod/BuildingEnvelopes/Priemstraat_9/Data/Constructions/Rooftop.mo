within IOCSmod.BuildingEnvelopes.Priemstraat_9.Data.Constructions;
record Rooftop  "Construction data of Rooftop"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final mats={Data.Materials.Rockwool415TimberForFinishing35(d=0.11148316146540027),Data.Materials.TimberForFinishing(d=0.01),Data.Materials.GypsumPlasterForFinishing(d=0.025)});
end Rooftop;

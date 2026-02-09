within IOCSmod.BuildingEnvelopes.Asbergstraat_18.Data.Constructions;
record GroundFloor  "Construction data of GroundFloor"
  extends IDEAS.Buildings.Data.Interfaces.Construction(locGain={3},
    final mats={Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.2),Data.Materials.ExpandedPolystrenemOrEPS(d=0.04179605510290019),Data.Materials.ScreedOrLightCastConcrete(d=0.06),Data.Materials.CeramicTileForFinishing(d=0.02)});
  annotation (Documentation(revisions="<html> 
 	 	<ul> 
 	 	<li>March 10, 2024, by Lucas Verleyen:<br> 
 	 	Add locGain={3}.</li> 
 	 	</ul> 
 	 	</html>"));
end GroundFloor;

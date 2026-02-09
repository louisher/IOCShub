within IOCSmod.Optimization;
model ThreeHousesIdeal
  extends IOCSmod.Optimization.Interface;
  Blocks.Demand.Clusters.ThreeHousesIdeal threeHouses(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

end ThreeHousesIdeal;

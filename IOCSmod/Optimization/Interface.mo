within IOCSmod.Optimization;
partial model Interface
   inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  inner BoundaryConditions.CO2Emissions.EmissionsSimInfoManager co2Sim
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  inner BoundaryConditions.ElectricityPrices.PriceSimInfoManager priceSim
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  parameter Boolean addDummyEquation=true
  "=true, to balance equations in dymola";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Interface;

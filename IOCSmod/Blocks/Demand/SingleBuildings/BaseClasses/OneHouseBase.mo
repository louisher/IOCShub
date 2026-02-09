within IOCSmod.Blocks.Demand.SingleBuildings.BaseClasses;
partial model OneHouseBase
extends IOCSmod.Blocks.BaseClasses.DemandInterface;
    replaceable IOCSmod.Demand.BuildingModels.TwoZoneBase House1(
    addDummyEquation=addDummyEquation,
    loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School_School.txt"),
    Q_flow_nominal=20000,
    redeclare
      IOCSmod.Demand.BuildingEnvelopes.Priemstraat_9.Priemstraat_9_1595127_Structure
      bui)
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,42},{60,-60}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,42},{0,90},{60,42},{0,42},{-60,42}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OneHouseBase;

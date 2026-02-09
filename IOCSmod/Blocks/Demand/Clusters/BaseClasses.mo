within IOCSmod.Blocks.Demand.Clusters;
package BaseClasses
  partial model ThreeHousesBase
    extends IOCSmod.Blocks.BaseClasses.DemandInterface;

      replaceable IOCSmod.Demand.BuildingModels.TwoZoneBase House1(
      addDummyEquation=addDummyEquation,
      loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School_School.txt"),
      Q_flow_nominal=6000,
      redeclare
        IOCSmod.Demand.BuildingEnvelopes.Zaveldriesstraat_54.Zaveldriesstraat_54_1593993_Structure
        bui)
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    replaceable IOCSmod.Demand.BuildingModels.TwoZoneBase House2(
      addDummyEquation=addDummyEquation,
      loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School.txt"),
      Q_flow_nominal=21000,
      redeclare
        IOCSmod.Demand.BuildingEnvelopes.Priemstraat_9.Priemstraat_9_1595127_Structure
        bui) annotation (Placement(transformation(extent={{-10,40},{10,60}})));

    replaceable IOCSmod.Demand.BuildingModels.TwoZoneBase House3(
      addDummyEquation=addDummyEquation,
      loadFile=Modelica.Utilities.Files.loadResource("modelica://IOCSmod/Resources/OccupancyProfiles/FTE_FTE.txt"),
      Q_flow_nominal=21000,
      redeclare
        IOCSmod.Demand.BuildingEnvelopes.Asbergstraat_18.Asbergstraat_18_1574473_Structure
        bui) annotation (Placement(transformation(extent={{40,40},{60,60}})));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-20,60},{20,20}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-20,60},{0,80},{20,60},{0,60},{-20,60}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-84,-16},{-64,4},{-44,-16},{-64,-16},{-84,-16}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-84,-16},{-44,-56}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{36,-18},{56,2},{76,-18},{56,-18},{36,-18}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{36,-18},{76,-58}},
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ThreeHousesBase;
end BaseClasses;

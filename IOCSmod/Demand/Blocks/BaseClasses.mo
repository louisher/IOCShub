within IOCSmod.Demand.Blocks;
package BaseClasses
  partial model BlockInterface

      outer IDEAS.BoundaryConditions.SimInfoManager sim
      annotation (Placement(transformation(extent={{80,80},{100,100}})));
    outer BoundaryConditions.CO2Emissions.EmissionsSimInfoManager co2Sim
      annotation (Placement(transformation(extent={{60,80},{80,100}})));
    outer BoundaryConditions.ElectricityPrices.ElectricityPriceSimInfoManager
      elePriceSim
      annotation (Placement(transformation(extent={{40,80},{60,100}})));

        parameter Boolean hasHyd=true
      "Set to true if the agent has an external hydronic connection"
      annotation (Evaluate=true, Dialog(group="Configuration"));

        parameter Boolean hasEl=true
      "Set to true if the agent has an Electrical output connection"
      annotation (Evaluate=true, Dialog(group="Configuration"));

      replaceable package Medium = IDEAS.Media.Water
          constrainedby Modelica.Media.Interfaces.PartialMedium
          "Medium in the agent hydronic system";

          Modelica.Fluid.Interfaces.FluidPort_a port_a(
          redeclare package Medium=Medium) if hasHyd
          "Hydronic inlet port"
          annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
        Modelica.Fluid.Interfaces.FluidPort_b port_b(
          redeclare package Medium=Medium) if hasHyd
          "Hydronic outlet port"
          annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));

    Modelica.Blocks.Interfaces.RealOutput P if hasEl
      annotation(Placement(transformation(extent={{-100,80},{-120,100}}),
        iconTransformation(extent={{100,-64},{120,-44}})));

    annotation (Icon(graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            lineThickness=1,
            pattern=LinePattern.Dot)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end BlockInterface;

  partial model DemandInterface "Interface for demand blocks"
    extends IOCSmod.Demand.Blocks.BaseClasses.BlockInterface;
    annotation (Icon(graphics={  Rectangle(lineColor = {238, 46, 47}, fillColor = {238, 46, 47},
              fillPattern =                                                                          FillPattern.Solid,
              lineThickness =                                                                                                           1, extent = {{-20, -88}, {20, -92}})}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));

  end DemandInterface;

  partial model EnergyHubInterface "Interface for energy hub blocks"
    extends IOCSmod.Demand.Blocks.BaseClasses.BlockInterface;

    annotation (Icon(graphics={Rectangle(
            extent={{-2,-60},{2,-100}},
            lineColor={0,140,72},
            lineThickness=1,
            fillColor={0,140,72},
            fillPattern=FillPattern.Solid), Rectangle(
            extent={{-20,-78},{20,-82}},
            lineColor={0,140,72},
            lineThickness=1,
            fillColor={0,140,72},
            fillPattern=FillPattern.Solid)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end EnergyHubInterface;
end BaseClasses;

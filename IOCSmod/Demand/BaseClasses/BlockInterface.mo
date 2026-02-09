within IOCSmod.Demand.BaseClasses;
partial model BlockInterface
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
        annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_b(
        redeclare package Medium=Medium) if hasHyd
        "Hydronic outlet port"
        annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));

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

within IOCSmod.Blocks.Demand.Clusters;
model Cluster10Naomi
  extends IOCSmod.Blocks.BaseClasses.DemandInterface
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

   final parameter Modelica.Units.SI.PressureDifference dp_network_nominal=Houses.house1.dp_nom_val "Nominal pump head of the primary circulation pump";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_network_nominal=Houses.m_flow_nom_dh
    "Nominal mass flow rate at the heat generation side of the thermal network";

  IOCSmod.Demand.BuildingModels.Cluster10Naomi Houses(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{30,-8},{-30,12}})));
  UnitTests.Components.FlowControlled_dp pumNetwork(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=Houses.m_flow_nom_dh,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    use_inputFilter=false,
    dp_nominal=dp_network_nominal)
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  Modelica.Blocks.Math.Sum Pnet(nin=2)    annotation (
    Placement(visible = true, transformation(origin={-70,90},     extent={{10,-10},
            {-10,10}},                                                                             rotation=0)));
equation
  connect(port_a, pumNetwork.port_a)
    annotation (Line(points={{60,-100},{60,-60},{40,-60}}, color={0,127,255}));
  connect(pumNetwork.port_b, Houses.port_a1)
    annotation (Line(points={{20,-60},{6,-60},{6,-8}}, color={0,127,255}));
  connect(port_b, Houses.port_b1) annotation (Line(points={{-60,-100},{-60,-80},
          {-6,-80},{-6,-8}}, color={0,127,255}));
  connect(Houses.P, Pnet.u[1]) annotation (Line(points={{31,10},{36,10},{36,89},
          {-58,89}}, color={0,0,127}));
  connect(pumNetwork.P, Pnet.u[2]) annotation (Line(points={{19,-51},{-42,-51},{
          -42,91},{-58,91}}, color={0,0,127}));
  connect(Pnet.y, P)
    annotation (Line(points={{-81,90},{-110,90}}, color={0,0,127}));

    annotation (Icon(graphics={
        Rectangle(
          extent={{-20,60},{20,20}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,-16},{-44,-56}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84,-16},{-64,4},{-44,-16},{-64,-16},{-84,-16}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,60},{0,80},{20,60},{0,60},{-20,60}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,-18},{76,-58}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,-18},{56,2},{76,-18},{56,-18},{36,-18}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end Cluster10Naomi;

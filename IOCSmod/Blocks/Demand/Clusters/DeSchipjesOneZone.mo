within IOCSmod.Blocks.Demand.Clusters;
model DeSchipjesOneZone
    extends IOCSmod.Blocks.BaseClasses.DemandInterface
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));


   final parameter Modelica.Units.SI.PressureDifference dp_network_nominal=4.843*9.81*
      Medium.d_const "Nominal pump head of the primary circulation pump";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_network_nominal=5.862*Medium.d_const
      /3600
    "Nominal mass flow rate at the heat generation side of the thermal network";

  IOCSmod.Demand.BuildingModels.DeSchipjesOneZone Houses(addDummyEquation=
        addDummyEquation)
    annotation (Placement(transformation(extent={{10,4},{-10,24}})));
  UnitTests.Components.FlowControlled_dp pumNetwork(
    redeclare package Medium = IDEAS.Media.Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_network_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    use_inputFilter=false,
    dp_nominal=dp_network_nominal)
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  Modelica.Blocks.Math.Sum Pnet(nin=2)    annotation (
    Placement(visible = true, transformation(origin={-70,90},     extent={{10,-10},
            {-10,10}},                                                                             rotation=0)));
equation
  connect(port_a, pumNetwork.port_a) annotation (Line(points={{60,-100},{60,-58},
          {40,-58},{40,-60}}, color={0,127,255}));
  connect(pumNetwork.port_b, Houses.port_a1)
    annotation (Line(points={{20,-60},{6,-60},{6,0}}, color={0,127,255}));
  connect(port_b, Houses.port_b1) annotation (Line(points={{-60,-100},{-60,-60},
          {-6,-60},{-6,0}}, color={0,127,255}));
  connect(pumNetwork.P, Pnet.u[1]) annotation (Line(points={{19,-51},{-40,-51},{
          -40,89},{-58,89}}, color={0,0,127}));
  connect(Houses.P, Pnet.u[2]) annotation (Line(points={{11,21.8},{20,21.8},{20,
          91},{-58,91}}, color={0,0,127}));
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
end DeSchipjesOneZone;

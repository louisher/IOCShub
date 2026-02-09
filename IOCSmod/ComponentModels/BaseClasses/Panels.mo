within IOCSmod.ComponentModels.BaseClasses;
partial model Panels "Base model for STC and PVT blocks"
    extends IOCSmod.ComponentModels.BaseClasses.PanelsSimple;

  Modelica.Fluid.Interfaces.FluidPort_a port_aReg(redeclare package Medium=Medium) if hasReg  "Hydronic inlet port for borefield regeneration"
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bReg(redeclare package Medium=Medium) if hasReg
                                                                                            "Hydronic outlet port for borefield regeneration"
        annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

  UnitTests.Components.TwoWayLinear valSupReg(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    dpValve_nominal=dp_Val_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,-42})));
  UnitTests.Components.TwoWayLinear valRetReg(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    dpValve_nominal=dp_Val_nominal)
                          annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-40})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTRegIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={124,-56})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTRegOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_panels_nominal,
    tau=0,
    allowFlowReversal=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-12,-80})));


equation
  connect(valSupReg.port_b, pumPanelHex.port_a) annotation (Line(points={{42,-32},
          {42,-20},{80,-20},{80,14},{62,14}}, color={0,127,255}));
  connect(senTRegIn.port_b, valSupReg.port_a) annotation (Line(points={{118,-56},{42,-56},{42,-52}}, color={0,127,255}));
  connect(valRetReg.port_b, senTRegOut.port_a) annotation (Line(points={{-40,-50},
          {-40,-80},{-18,-80}}, color={0,127,255}));

  if optSel then
    connect(uSelPvt, valRetReg.y) annotation (Line(points={{-120,0},{-60,0},{-60,-40},
          {-52,-40}}, color={0,0,127}));
    connect(uSelPvt, valSupReg.y) annotation (Line(points={{-120,0},{20,0},{20,-42},
            {30,-42}}, color={0,0,127}));
  else
    connect(ExprDefaultSelection.y, valRetReg.y) annotation (Line(points={{-99,30},
            {-60,30},{-60,-40},{-52,-40}}, color={0,0,127}));
    connect(ExprDefaultSelection.y, valSupReg.y) annotation (Line(points={{-99,30},
            {-60,30},{-60,0},{20,0},{20,-42},{30,-42}}, color={0,0,127}));
  end if;

  if hasReg then
    connect(port_aReg, senTRegIn.port_a) annotation (Line(points={{100,0},{140,0},{140,-56},{130,-56}}, color={0,127,255}));
    connect(port_bReg, senTRegOut.port_b) annotation (Line(points={{100,-80},{-6,-80}}, color={0,127,255}));
  else
      connect(senTRegIn.port_a, senTRegOut.port_b) annotation (Line(points={{130,-56},{146,-56},{146,-80},{-6,-80}}, color={0,127,255}));
  end if;

  connect(valRetReg.port_a, senTHexOut.port_b) annotation (Line(points={{-40,
          -30},{-42,-30},{-42,14},{-26,14}}, color={0,127,255}));
    annotation (Line(points={{42,14},{26,14}}, color={0,127,255}),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Panels;

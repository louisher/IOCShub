within IOCSmod.Demand.PeakLoadSimulations;
model Gesl_M_A "Terraced building A + hvac system"
  replaceable package MediumAir = IDEAS.Media.Air "Medium in the component";
  parameter Real [nZones] n= (3.6/nZones).*bui.AZones./bui.VZones
    "Air change rate (Air changes per hour ACH)";
  parameter Modelica.Units.SI.MassFlowRate[nZones] m_flow_nominal_fan=n.*bui.VZones./3600.*1.204 "Nominal ventilation mass flow rate in the zones";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_air = sum(m_flow_nominal_fan) "Total ventilation mass flow rate";
  parameter Integer nZones(min=1) = bui.nZones
    "Number of conditioned thermal building zones";
  DistrictHeating_5GDHC.BaseClasses.BuildingEnvelopes.Gesl_M.Gesl_M_Structure_A bui(useFluPor=
       true, redeclare package Medium = MediumAir)
        annotation (Placement(transformation(extent={{-14,-10},{16,10}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=0)
    annotation(Placement(transformation(extent={{60, 30}, {40, 50}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=0)
    annotation(Placement(transformation(extent={{60, 10}, {40, 30}})));
    parameter Boolean addDummyEquation=false  "=true, to balance equations in dymola";
    parameter Boolean isDh=true "=true, if the system is connected to a DH grid";

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness
    hex(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=m_flow_nominal_air,
    m2_flow_nominal=m_flow_nominal_air,
    eps=0.84,
    dp1_nominal=65,
    dp2_nominal=225) "Heat recovery unit"
    annotation (Placement(transformation(extent={{-48,36},{-68,56}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanSup[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=100)                                       "Supply fan"
    annotation (Placement(transformation(extent={{-28,24},{-8,44}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fanRet[nZones](
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal_fan,
    tau=0,
    use_inputFilter=false,
    redeclare package Medium = MediumAir,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    dp_nominal=80)                                        "Return fan"
    annotation (Placement(transformation(extent={{-8,50},{-28,70}})));
  IDEAS.Fluid.Sources.Boundary_pT bouAir(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    nPorts=2)
    "Boundary for air model"
    annotation (Placement(transformation(extent={{-92,40},{-80,52}})));
  Modelica.Blocks.Sources.RealExpression Te(y=sim.Te) "Ambient air"
    annotation (Placement(transformation(extent={{-112,40},{-100,54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealH1
    annotation (Placement(transformation(extent={{52,-18},{32,2}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealH2
    annotation (Placement(transformation(extent={{52,-50},{32,-30}})));
  IDEAS.Controls.Continuous.LimPID conPIDHea1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=40000,
    yMin=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={84,-8})));
  Modelica.Blocks.Sources.RealExpression T1(y=bui.TSensor[1] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={102,18})));
  Modelica.Blocks.Sources.RealExpression TSet(y=21) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={118,-8})));
  IDEAS.Controls.Continuous.LimPID conPIDHea2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=40000,
    yMin=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,-56})));
  Modelica.Blocks.Sources.RealExpression T2(y=bui.TSensor[2] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,-30})));
  Modelica.Blocks.Sources.RealExpression TSet1(y=21) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={116,-56})));
  IDEAS.Controls.Continuous.LimPID conPIDCoo1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=0,
    yMin=-40000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={160,-6})));
  Modelica.Blocks.Sources.RealExpression T3(y=bui.TSensor[1] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={178,20})));
  Modelica.Blocks.Sources.RealExpression TSet2(y=23) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={194,-6})));
  IDEAS.Controls.Continuous.LimPID conPIDCoo2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=2000,
    Ti=120,
    yMax=0,
    yMin=-40000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={158,-54})));
  Modelica.Blocks.Sources.RealExpression T4(y=bui.TSensor[2] - 273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={176,-28})));
  Modelica.Blocks.Sources.RealExpression TSet3(y=23) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={192,-54})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC1
    annotation (Placement(transformation(extent={{52,-34},{32,-14}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow idealC2
    annotation (Placement(transformation(extent={{52,-70},{32,-50}})));
equation
  connect(occ1.y, bui.occ[1]) annotation(Line(points={{39, 40}, {11, 40}, {11, 10}}, color={0, 0, 127}));
  connect(occ2.y, bui.occ[2]) annotation(Line(points={{39, 20}, {11, 20}, {11, 10}}, color={0, 0, 127}));
  connect(Te.y,bouAir. T_in) annotation (Line(points={{-99.4,47},{-99.4,48.4},{-93.2,
          48.4}},         color={0,0,127}));
  for i in 1:nZones loop
    connect(hex.port_b2,fanSup [i].port_a) annotation (Line(points={{-48,40},{-40,
          40},{-40,34},{-28,34}}, color={0,127,255}));
  end for;
  for i in 1:nZones loop
    connect(hex.port_a1,fanRet [i].port_b) annotation (Line(points={{-48,52},{-40,
          52},{-40,60},{-28,60}}, color={0,127,255}));
  end for;
  connect(hex.port_b1,bouAir. ports[1]) annotation (Line(points={{-68,52},{-80,52},
          {-80,47.2}},      color={0,127,255}));
  connect(hex.port_a2,bouAir. ports[2]) annotation (Line(points={{-68,40},{-80,40},
          {-80,44.8}},      color={0,127,255}));
  connect(fanSup.port_b, bui.port_a) annotation (Line(points={{-8,34},{3,34},{3,10}},  color={0,127,255}));
  connect(fanRet.port_a, bui.port_b) annotation (Line(points={{-8,60},{-1,60},{-1,10}},  color={0,127,255}));
  connect(T1.y, conPIDHea1.u_m)
    annotation (Line(points={{91,18},{84,18},{84,4}}, color={0,0,127}));
  connect(TSet.y, conPIDHea1.u_s)
    annotation (Line(points={{107,-8},{96,-8}}, color={0,0,127}));
  connect(conPIDHea1.y, idealH1.Q_flow)
    annotation (Line(points={{73,-8},{52,-8}}, color={0,0,127}));
  connect(T2.y, conPIDHea2.u_m)
    annotation (Line(points={{89,-30},{82,-30},{82,-44}}, color={0,0,127}));
  connect(TSet1.y, conPIDHea2.u_s)
    annotation (Line(points={{105,-56},{94,-56}}, color={0,0,127}));
  connect(conPIDHea2.y, idealH2.Q_flow) annotation (Line(points={{71,-56},{60,
          -56},{60,-40},{52,-40}}, color={0,0,127}));
  connect(T3.y, conPIDCoo1.u_m)
    annotation (Line(points={{167,20},{160,20},{160,6}}, color={0,0,127}));
  connect(TSet2.y, conPIDCoo1.u_s)
    annotation (Line(points={{183,-6},{172,-6}}, color={0,0,127}));
  connect(T4.y, conPIDCoo2.u_m)
    annotation (Line(points={{165,-28},{158,-28},{158,-42}}, color={0,0,127}));
  connect(TSet3.y, conPIDCoo2.u_s)
    annotation (Line(points={{181,-54},{170,-54}}, color={0,0,127}));
  connect(conPIDCoo2.y, idealC2.Q_flow) annotation (Line(points={{147,-54},{140,
          -54},{140,-76},{52,-76},{52,-60}}, color={0,0,127}));
  connect(conPIDCoo1.y, idealC1.Q_flow) annotation (Line(points={{149,-6},{132,
          -6},{132,-24},{52,-24}}, color={0,0,127}));
  connect(idealH1.port, bui.heatPortCon[1])
    annotation (Line(points={{32,-8},{24,-8},{24,2},{16,2}}, color={191,0,0}));
  connect(idealC1.port, bui.heatPortCon[1]) annotation (Line(points={{32,-24},{
          24,-24},{24,2},{16,2}}, color={191,0,0}));
  connect(idealH2.port, bui.heatPortCon[2]) annotation (Line(points={{32,-40},{
          26,-40},{26,2},{16,2}}, color={191,0,0}));
  connect(idealC2.port, bui.heatPortCon[2]) annotation (Line(points={{32,-60},{
          26,-60},{26,2},{16,2}}, color={191,0,0}));
annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {100,100}}),                                     graphics={
  Line(points={{-70, 4}, {-70, -86}, {-16, -86}, {-16, -30}, {16, -30}, {16, -86}, {70, -86}, {70, 4}, {0, 74}, {-70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-70, 4}, {-76, -2}, {-88, -2}, {0, 86}, {88, -2}, {76, -2}, {70, 4}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-14, 28}, {14, 28}, {14, 0}, {-14, 0}, {-14, 28}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{30, -30}, {58, -30}, {58, -58}, {30, -58}, {30, -30}}, color={244, 125, 35}, thickness=0.5),
  Line(points={{-58, -30}, {-30, -30}, {-30, -58}, {-58, -58}, {-58, -30}}, color={244, 125, 35}, thickness=0.5),
        Text(
          extent={{-180,140},{180,100}},
          textColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
  experiment(
      StopTime=30240000,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
  Documentation(info="<html> 
         <p>Q_design = QzoneDay kW (DayZone) &amp; QzoneNight kW (NightZone)</p> 
         <p>UA_building = UAbuilding W/K</p> 
         <p>Roof</p> 
         <ul><li>Side1: Surface1 m2, tilt = Tilt1 rad (Tilt1deg &deg;)</li><li>Side2: Surface2 m2, tilt = Tilt2 rad (Tilt2deg &deg;)<br></li></ul> 
         </html>", revisions="<html><ul><li>March 5, 2024, by Lucas Verleyen:<br> Remove mass flow sources and set useFluPor = false.<li>October 9, 2023, by Lucas Verleyen:<br> Initial implementation.</li></ul></html>"));
end Gesl_M_A;

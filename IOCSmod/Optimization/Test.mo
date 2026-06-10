within IOCSmod.Optimization;
model Test

  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  parameter Real nb_of_appartments_in_A = 37;

  ComponentModels.Thermal.Bhp bhp_A(
    QConBhpFile=Modelica.Utilities.Files.loadResource("modelica://ArtesMod/Resources/BHP_profiles/Qcon_bhp_building_A.txt"),
    Qbhp_nominal=nb_of_appartments_in_A*2500,
    dpFixed_nominal(displayUnit="Pa") = 10000,
    Kv=bhp_A.valBhp.m_flow_nominal/sqrt(10000)/(bhp_A.valBhp.rhoStd/3600/sqrt(1E5)),
    bhp(
      dT_max=5,
      copDef=5.3,
      coeffEva={-298.15,0.08046},
      coeffCon={-304.9,-0.07626}),
    boundary(T=273.15 + 31.75))
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  IDEAS.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = IDEAS.Media.Water,
    T=318.15,
    nPorts=1) annotation (Placement(transformation(extent={{-90,2},{-70,22}})));
  IDEAS.Fluid.Sources.Boundary_pT bou1(redeclare package Medium =
        IDEAS.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-92,-30},{-72,-10}})));
  IDEAS.Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal = bhp_A.m_flow_nominalEva,
    dp_nominal=20000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{-48,2},{-28,22}})));
equation


  connect(bou.ports[1], pum.port_a)
    annotation (Line(points={{-70,12},{-48,12}}, color={0,127,255}));
  connect(pum.port_b, bhp_A.port_a) annotation (Line(points={{-28,12},{-12,12},{
          -12,4},{-8,4}}, color={0,127,255}));
  connect(bhp_A.port_b, bou1.ports[1]) annotation (Line(points={{-8,-4},{-64,-4},
          {-64,-20},{-72,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=300,
      __Dymola_Algorithm="Dassl"));
end Test;

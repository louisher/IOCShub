within IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem;
model HeatingSystem "Building heating system optimisation model"
  extends
    IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.BaseClasses.HeatingSystem(
      tankDhw(nPorts=2));

  IDEAS.Fluid.Sensors.TemperatureTwoPort TTankDhwOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nom_bhp_con,
    tau=0) annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=0,
        origin={30,40})));
equation
  QdhwStor = bhp.port_a2.m_flow*(bhp.port_b2.h_outflow-TTankDhwOut.port_b.h_outflow);

  connect(TBhpConIn.port_a, TTankDhwOut.port_b)
    annotation (Line(points={{-3,40},{25,40}}, color={0,127,255}));
  connect(TTankDhwOut.port_a, tankDhw.ports[2])
    annotation (Line(points={{35,40},{120,40},{120,30}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}})), Icon(coordinateSystem(extent={{-200,-100},
            {200,100}})),
    experiment(
      StopTime=36000,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end HeatingSystem;

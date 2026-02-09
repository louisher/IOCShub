within IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.BaseClasses;
model HeatingSystem
  extends HeatingSystemMix;
  IDEAS.Fluid.Actuators.Valves.TwoWayLinear
                                      valveBhp(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nom_bhp_eva,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=kvsValveBhp,
    dpFixed_nominal=dp_nom_sec - (valveBhp.m_flow_nominal*3.6/valveBhp.Kv)^2*10
        ^5) annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
equation
  connect(valveBhp.port_b, TBhpEvaIn.port_a)
    annotation (Line(points={{-50,70},{-45,70}}, color={0,127,255}));
  connect(valveBhp.port_a, TSecSup.port_b) annotation (Line(points={{-70,70},{
          -80,70},{-80,-30},{25,-30}}, color={0,127,255}));
end HeatingSystem;

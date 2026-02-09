within IOCSmod.ComponentModels.Thermal.SizeOpt;
model SimpleTankOpt
  extends BaseClasses.ElecThermInterface(hasEl=false, hasHyd=false, hasMulHyd=true);

  // Tank Parameters
  parameter input Real Size "Tank Size in m3" annotation(Dialog(group="Optimal sizing"));

  // investemnt
  parameter Real inv_cost(fixed=false, start=0) "Investment cost per unit of Size (€/m3)" annotation(Dialog(group="Investment cost"));
  parameter Real interest_rate(fixed=false, start=0) annotation(Dialog(group="Investment cost"));
  parameter Integer lifetime(fixed=false, start=0) "Lifetime in years" annotation(Dialog(group="Investment cost"));
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years" annotation(Dialog(group="Investment cost"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Tank.MixingVolumeOpt vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=VTan,     nPorts=nPorts)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression TeExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,0})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TePrescribedTemperature
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-60,0})));
  Tank.ThermalResistorOpt                                  resTan(R=RTan)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,0})));

  IOCSmod.ComponentModels.BaseClasses.Investment inv(inv_cost=inv_cost,
    interest_rate=interest_rate,
    lifetime=lifetime,
    observation_time=observation_time)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

protected
  parameter input Modelica.Units.SI.Volume VTan=Size
    "Volume of the water tank";
  final parameter input Modelica.Units.SI.Length hTan = (4*VTan/Modelica.Constants.pi)^(1/3) "height of the tank, default minimizes area/volume ratio";
  final parameter input Modelica.Units.SI.Length rTan= sqrt(VTan/(Modelica.Constants.pi*hTan))
    "Radius of the storage tank (without insulation)";
  final parameter Modelica.Units.SI.ThermalConductivity kTan=0.041
    "Thermal conductivity of the water tank insulation material, default minimizes area/volume ratio";
  final parameter Modelica.Units.SI.Length tTan=0.110
    "Thickness of the water tank insulation material";

  parameter input Modelica.Units.SI.ThermalResistance RTan=Modelica.Math.log((rTan +
      tTan)/rTan)/(2*Modelica.Constants.pi*kTan*hTan)
    "Thermal resistance of the storage tank";

equation
  connect(vol.ports, ports)
    annotation (Line(points={{0,-10},{0,-100}}, color={0,127,255}));
  connect(resTan.port_b, vol.heatPort)
    annotation (Line(points={{-20,-7.21645e-16},{-10,0}}, color={191,0,0}));
  connect(TePrescribedTemperature.port, resTan.port_a)
    annotation (Line(points={{-50,0},{-40,1.72085e-15}}, color={191,0,0}));
  connect(TeExpression.y, TePrescribedTemperature.T)
    annotation (Line(points={{-79,-1.38778e-15},{-72,0}}, color={0,0,127}));
  annotation (defaultComponentName="tan", Icon(graphics={Text(
          extent={{-152,100},{148,140}},
          textColor={0,0,0},
          textString="%name"),
        Rectangle(
          extent={{-60,80},{60,0}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,0},{60,-80}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,82},{62,-82}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          lineThickness=1)}));
end SimpleTankOpt;

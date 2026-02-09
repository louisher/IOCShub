within IOCSmod.ComponentModels.Thermal.SizeOpt;
model PvtOpt
"Model of a PVT-module that can be used for regeneration or regualar heating:
  Regular ports are used for heating, while additional ports are created for regeneration"
  extends IOCSmod.ComponentModels.Thermal.SizeOpt.StcOpt(final hasEl=true,
    redeclare
      IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.PhotoVoltaicThermalCollector
      panels(
      totalArea=Size,
      totalArea_nominal=Size_nominal,
      U_pvt=U_pvt,
      G_STC=G_STC,
      P_STC=P_STC,
      gamma=gamma,
      P_loss_factor=P_loss_factor,
      module_efficiency=module_efficiency,
      eta_nom_inverter=eta_nom_inverter,
      P_ac0=P_ac0));

  // Parameters
  parameter Modelica.Units.SI.Irradiance G_STC=1000
    "Irradiance at Standard Conditions (usualy 1000 W/m2)"
    annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.Power P_STC=370
    "Power of one pPVT panel at Standard Conditions, usualy equal to power at Maximum Power Point (MPP)"
    annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma=-0.0037
    "Temperature coefficient of the photovoltaic panel(s)"
    annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.Efficiency P_loss_factor=0.14
    "Loss factor of the photovoltaic panel(s)"
    annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.Efficiency module_efficiency=0.3
    "Module efficiency of the photovoltaic installation"
    annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.Efficiency eta_nom_inverter=0.96
    "Nominal inverter efficiency" annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.Power P_ac0=0.7*(panels.ATot_internal/panels.per.A)
      *panels.P_STC "Inverter rated AC power"
    annotation (Dialog(group="Electrical"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U_pvt=35
    "Heat coefficient used in cell temperature calculation" annotation (Dialog(group="General"));
equation
  connect(panels.P, P) annotation (Line(points={{13,52},{32,52},{32,90},{-110,90}},
        color={0,0,127}));
  annotation (defaultComponentName="pvt",                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PvtOpt;

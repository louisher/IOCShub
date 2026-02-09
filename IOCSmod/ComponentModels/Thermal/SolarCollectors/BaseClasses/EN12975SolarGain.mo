within IOCSmod.ComponentModels.Thermal.SolarCollectors.BaseClasses;
model EN12975SolarGain "Model calculating solar gains per the EN12975 standard"
  extends Modelica.Blocks.Icons.Block;
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialParameters;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the system";

  parameter Real eta0(final unit="1") "Optical efficiency (maximum efficiency)";
  parameter Modelica.Units.SI.Angle[:] incAngDat "Incidence angle modifier spline derivative coefficients";
  parameter Real[size(incAngDat,1)] incAngModDat(each final unit="1") "Incidence angle modifier spline derivative coefficients";
  parameter Real incAngTable[size(incAngDat,1),2] = [incAngDat, incAngModDat] "Incidence angle modifier table (angle vs. modifier)";

  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in,group="Shading"));

  parameter Real iamDiff "Incidence angle modifier for diffuse radiation";

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Time varying input for the shading coefficient"
    annotation(Placement(transformation(extent={{-140,-70},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput HSkyDifTil(
    unit="W/m2",
    quantity="RadiantEnergyFluenceRate")
    "Diffuse solar irradiation on a tilted surfce from the sky"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil(
    unit="W/m2",
    quantity="RadiantEnergyFluenceRate")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](each final unit="W")
    "Solar heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
     each final unit="K",
     each displayUnit="degC",
     each final quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Tables.CombiTable1Ds incAngModTab(
    table=incAngTable,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Modelica.Blocks.Interfaces.RealInput QMax(unit="W", quantity="Power")
    "Maximum power" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

protected
  Modelica.Blocks.Interfaces.RealInput shaCoe_internal "Internally used shaCoe";
  Real iamBea "Incidence angle modifier for director solar radiation";
  parameter Real delta=0.0001 "parameter to set smoothing region";

  Modelica.Units.SI.Power QSeg=A_c/nSeg*(eta0*(iamBea*HDirTil*(1.0 -
      shaCoe_internal) + iamDiff*HSkyDifTil))
    "Computed thermal power per segment";

  Modelica.Units.SI.Power QLim=QSeg + QMax/nSeg - (QSeg^6 + (QMax/nSeg)^6)^(1/6)
    "Limited thermal power";

equation
  connect(shaCoe_internal, shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal = shaCoe;
  end if;

  // EnergyPlus 23.2.0 Engineering Reference Eq 18.298
  iamBea = Buildings.Utilities.Math.Functions.smoothMax(incAngModTab.y[1], 0, delta);
  // Modified from EnergyPlus 23.2.0 Engineering Reference Eq 18.302
  // by applying shade effect for direct solar radiation
  // Only solar heat gain is considered here
  for i in 1 : nSeg loop
    QSol_flow[i] = QLim;
  end for;

  connect(incAngModTab.u, incAng) annotation (Line(points={{-82,-90},{-96,-90},{
          -96,-20},{-120,-20}}, color={0,0,127}));
  annotation (
    defaultComponentName="solGai", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EN12975SolarGain;

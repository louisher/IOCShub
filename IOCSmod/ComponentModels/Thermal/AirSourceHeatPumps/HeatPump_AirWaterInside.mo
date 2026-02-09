within IOCSmod.ComponentModels.Thermal.AirSourceHeatPumps;
model HeatPump_AirWaterInside
  "Heat pump model inside the air water heat pump model"
  extends IOCSmod.ComponentModels.Thermal.AirSourceHeatPumps.HeatPump_AirWaterInsideBase(
    mod(quantity="free_" + u_name,
      min=0,
      max=1,
      nominal=1/Q_flow_nominal,
      start=mod_start));

  parameter Real mod_start=0;

      //start=0 to avoid pushing huge powers into the system, which may lead to too large temperatures during initialization
  parameter Boolean addDummyEquation=false
    "=true, to balance equations in dymola"
    annotation(Dialog(group="Control"));
  parameter Modelica.Units.SI.Power Q_flow_nominal=min(Q1_flow_nominal,
      Q2_flow_nominal) "Nominal heat flow rate, for scaling only"
    annotation (Dialog(tab="Scaling"));
  parameter String y_name = ""
    "Optional: low level output name for writing to bacnet"
    annotation(Dialog(group="Optimization"));
  parameter String u_name = ""
    "Optional: control measurement name for reading from bacnet"
    annotation(Evaluate=true, Dialog(group="Optimization"));
  Real y_out(quantity=y_name) = mod^1 if not y_name==""
    "For creating low level output";

  Modelica.Blocks.Sources.Constant mod_dummy(k=mod_start)
    "Dummy for connecting to dp_in"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TConIn "Condenser inlet temperature" annotation (
    Placement(visible = true, transformation(origin = {100, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 270), iconTransformation(origin = {110, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
protected
  parameter Boolean isWaterMedium1=Medium1.density(Medium1.setState_phX(
      Medium1.p_default,
      Medium1.h_default,
      Medium1.X_default)) > 500;
  parameter Boolean isWaterMedium2=Medium2.density(Medium2.setState_phX(
      Medium2.p_default,
      Medium2.h_default,
      Medium2.X_default)) > 500;
  parameter Modelica.Units.SI.Power Q1_flow_nominal=if isWaterMedium1 then abs(
      dT_maxSca*4180*m1_flow_nominal) else abs(dT_maxSca*1000*m1_flow_nominal);
  parameter Modelica.Units.SI.Power Q2_flow_nominal=if isWaterMedium2 then abs(
      dT_maxSca*4180*m2_flow_nominal) else abs(dT_maxSca*1000*m2_flow_nominal);
equation
  if addDummyEquation then
    connect(mod,mod_dummy.y);
  end if;
  connect(senTemConIn.T, TConIn) annotation (
    Line(points={{50,-49},{50,40},{100,40},{100,110}},          color = {0, 0, 127}));
  annotation (
    Icon(graphics={  Ellipse(lineColor = {28, 108, 200}, fillColor = {28, 108, 200},
            fillPattern =                                                                          FillPattern.Solid, extent = {{-144, -12}, {-120, 12}})}));
end HeatPump_AirWaterInside;

within IOCSmod.ComponentModels.Electrical.SizeOpt;
model LinearBatteryOpt "Model for a linear DC battery"

  parameter input Real Size "Battery size in kWh" annotation(Dialog(group="Optimal sizing"));

  // investemnt
  parameter Real inv_cost(fixed=false, start=0) "Investment cost per unit of Size (€/kWh)" annotation(Dialog(group="Investment cost"));
  parameter Real interest_rate(fixed=false, start=0) annotation(Dialog(group="Investment cost"));
  parameter Integer lifetime(fixed=false, start=0) "Lifetime in years" annotation(Dialog(group="Investment cost"));
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years" annotation(Dialog(group="Investment cost"));

  parameter Modelica.Units.SI.Power P_max=5000 "Maximal charging/discharging power"
    annotation(Dialog(group="Battery settings"));
  parameter Modelica.Units.SI.Efficiency effCha(min=0,max=1)=0.85 "Charging efficiency (between 0 and 1)"
    annotation(Dialog(group="Battery settings"));
  parameter Modelica.Units.SI.Efficiency effDisCha(min=0,max=1)=0.85 "Discharging efficiency (between 0 and 1)"
    annotation(Dialog(group="Battery settings"));
  parameter Real u_min(min=-1,max=0)=-1 "Discharging"
    annotation(Dialog(group="Optimisation settings"));
  parameter Real u_max(min=0,max=1)=1 "Charging"
    annotation(Dialog(group="Optimisation settings"));
  parameter Real SoC_min=0.1 "Minimal state of charge (between 0 and 1)"
    annotation(Dialog(group="Optimisation settings"));
  parameter Real SoC_max=0.9 "Maximal state of charge (between 0 and 1)"
    annotation(Dialog(group="Optimisation settings"));

  Modelica.Units.SI.Power PCha "Charging/discharging power";
  Modelica.Units.SI.Energy EBat "Stored energy";
  Modelica.Units.SI.Power PtoE "Effective charging/discharging power after losses";
  Real SoC(start=0) "State of charge";
  Modelica.Units.SI.Efficiency eff "Effective charging or discharging efficiency";

  Modelica.Blocks.Interfaces.RealInput u(
    quantity="free",
    final min=u_min,
    final max=u_max,
    final start=0,
    final nominal=1/P_max)
    "Battery charging input; 1 = charging, -1 = discharging"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput PDem
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput PGrid
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  IOCSmod.ComponentModels.BaseClasses.Investment inv(inv_cost=inv_cost,
    interest_rate=interest_rate,
    lifetime=lifetime,
    observation_time=observation_time)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
protected
  parameter Real SoC_start(min=0,max=1)=0 "Initial state of charge (between 0 and 1)"
    annotation(Dialog(group="Initialisation settings"));
  parameter input Real EBat_max_kWh=Size "Maximal storage capacity in kWh"
    annotation(Dialog(group="Battery settings"));

initial equation
  SoC = SoC_start;
equation
  PCha = u*P_max;
  eff = (1/effDisCha-effCha)/(1+exp(100*u))+effCha+(effCha+effDisCha)/2*(1/exp(100*(u+0.01)^2)-1/exp(100*(u-0.01)^2));
  PtoE = PCha*eff;
  der(EBat) = PtoE;
  EBat = SoC*EBat_max_kWh*3600000;
  PGrid = PDem + PCha;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,62},{60,-90}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,62},{-20,80}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,62},{40,80}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-56},{20,-60}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,22},{20,18}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,40},{2,0}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=inputType == UnitTests.Confidential.BaseClasses.RealInputType.Optimize,
          extent={{-12,140},{12,164}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>This is a simple continuous battery model. </p>
<p>This model takes into account: different charging and discharging efficiency.</p>
<p>Pdem is positive for electrical demands (eg. heat pump loads) and negative for electricity yields (eg. PV yield), same holds for P_grid (positive is offtake and negative is injection)</p>
</html>",                                                                                         revisions="<html>
<ul>
<li>January 27, 2024, by Louis Hermans:<br>
Changed sign convention of P_grid and Pdem --> changed equation P_grid = Pdem - Pcha to P_grid = Pdem + Pcha.</li>
<li>June 13, 2024, by Lucas Verleyen:<br>
Initial implementation.</li>
</ul>
</html>"));
end LinearBatteryOpt;

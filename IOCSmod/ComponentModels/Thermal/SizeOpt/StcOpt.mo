within IOCSmod.ComponentModels.Thermal.SizeOpt;
model StcOpt
  "Model of a STC-module that can be used for regeneration or regualar heating:
  Regular ports are used for heating, while additional ports are created for regeneration"
    extends IOCSmod.ComponentModels.BaseClasses.Panels(hasEl=false, redeclare IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.EN12975 panels(
        totalArea_nominal=totalArea_nominal), final totalArea=Size, final totalArea_nominal=Size_nominal,
    pumPanels(inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous),
    pumPanelHex(inputType=UnitTests.Confidential.BaseClasses.InputType.Continuous));

  // Parameters
  parameter input Real Size "Heat pump size in m2" annotation(Dialog(group="Optimal sizing"));
  parameter input Real Size_nominal "Nominal STC area in m2, used for calculating nominal mass flow rates and pressure drops" annotation(Dialog(group="Optimal sizing"));

  // investemnt
  parameter Real inv_cost(fixed=false, start=0) "Investment cost per unit of Size (€/m2)" annotation(Dialog(group="Investment cost"));
  parameter Real interest_rate(fixed=false, start=0) annotation(Dialog(group="Investment cost"));
  parameter Integer lifetime(fixed=false, start=0) "Lifetime in years" annotation(Dialog(group="Investment cost"));
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years" annotation(Dialog(group="Investment cost"));

  input Real modPumPanels(quantity="free", min=1/1000, max=1, nominal=1/(10*4180*panels.m_flow_nominal), start=1) "modulation variable to vary mass flow rate trough the panels. This is done to allow to vary to the maximum mass flow rate depending on optimized size";

  Modelica.Blocks.Sources.RealExpression Expr_mFlowStc(y=modPumPanels*panels.m_flow_nominal_actual)
    "Expression that sets the mass flow rate through the panels"
    annotation (Placement(transformation(extent={{26,76},{46,96}})));
  Modelica.Blocks.Sources.RealExpression Expr_mFlowHex(y=2*(panels.m_flow_nominal_actual
        /valSupHea.Kv_SI)^2)
    "Expression that sets the mass flow rate through the panels"
    annotation (Placement(transformation(extent={{100,30},{80,50}})));

  IOCSmod.ComponentModels.BaseClasses.Investment inv(inv_cost=inv_cost,
    interest_rate=interest_rate,
    lifetime=lifetime,
    observation_time=observation_time)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

equation
  connect(Expr_mFlowStc.y, pumPanels.m_flow_in)
    annotation (Line(points={{47,86},{50,86},{50,72}}, color={0,0,127}));
  connect(Expr_mFlowHex.y, pumPanelHex.dp_in)
    annotation (Line(points={{79,40},{52,40},{52,26}}, color={0,0,127}));
  annotation (defaultComponentName="stc", Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={            Text(
          extent={{-150,100},{150,140}},
          textColor={0,0,0},
          textString="%name"),                                                                         Text(
          extent={{-72,35},{76,-35}},
          textColor={238,46,47},
          textString="%name")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StcOpt;

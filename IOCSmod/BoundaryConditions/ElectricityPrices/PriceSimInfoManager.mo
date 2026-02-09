within IOCSmod.BoundaryConditions.ElectricityPrices;
model PriceSimInfoManager
  "This model propagates economic and price data through all component models"
  parameter String path_economic_params_json "path the the economic_params.json file";
  parameter ExternData.JSONFile jsonreader_economic_params(fileName=path_economic_params_json) annotation(evaluate=false);

   /* Fixed economic parameters*/
  parameter Real interest_rate(fixed=false, start=0) "Interest rate";
  parameter Integer observation_time(fixed=false, start=0) "Observation time in years";
  parameter Real p_elec_fix_offtake(fixed=false, start=0) "Fixed offtake electricity price in €/mWh";
  parameter Real p_elec_fix_inj(fixed=false, start=0) "Fixed injection electricity price €/mWh";

  parameter String loadFile=Modelica.Utilities.Files.loadResource(
        "modelica://IOCSmod/Resources/ElectricityPrices/BE_Belpex_consumer_2021_2022jan.txt")
        annotation(Dialog(loadSelector(filter="All files (*.*)", caption="Select the electricity price data file")));
  Modelica.Blocks.Sources.CombiTimeTable electricityPrices(
    columns=2:6,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=loadFile,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="data",
    tableOnFile=true,
    timeScale=1,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
                 annotation (Placement(visible=true, transformation(
        origin={-10,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  IOCSmod.BoundaryConditions.ElectricityPrices.priceBus priceBus annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,0})));

initial equation
  interest_rate = jsonreader_economic_params.getReal("INTEREST_RATE");
  observation_time = jsonreader_economic_params.getInteger("OBSERVATION_TIME");
  p_elec_fix_offtake = jsonreader_economic_params.getInteger("ELEC_PRICE_OFFTAKE");
  p_elec_fix_inj = jsonreader_economic_params.getInteger("ELEC_PRICE_INJECTION");

equation
  connect(electricityPrices.y[1], priceBus.dynamic_raw)
    annotation (Line(points={{1,0},{50,0},{50,0.1},{99.9,0.1}},
                                             color={0,0,127}));
  connect(electricityPrices.y[2], priceBus.dynamic_consumer)
    annotation (Line(points={{1,0},{50,0},{50,0.1},{99.9,0.1}},
                                             color={0,0,127}));
  connect(electricityPrices.y[3], priceBus.dynamic_consumer_daily)
    annotation (Line(points={{1,0},{50,0},{50,0.1},{99.9,0.1}},
                                             color={0,0,127}));
  connect(electricityPrices.y[4], priceBus.dynamic_consumer_weekly)
    annotation (Line(points={{1,0},{50,0},{50,0.1},{99.9,0.1}},
                                             color={0,0,127}));
  connect(electricityPrices.y[5], priceBus.dynamic_consumer_yearly)
    annotation (Line(points={{1,0},{50,0},{50,0.1},{99.9,0.1}},
                                             color={0,0,127}));
annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Line(points={{-80,-30},{88,-30}}, color={0,0,0}),
        Line(points={{-76,-68},{-46,-30}}, color={0,0,0}),
        Line(points={{-42,-68},{-12,-30}}, color={0,0,0}),
        Line(points={{-8,-68},{22,-30}}, color={0,0,0}),
        Line(points={{28,-68},{58,-30}}, color={0,0,0}),
        Rectangle(
          extent={{-60,76},{60,-24}},
          lineColor={238,46,47},
          fillPattern=FillPattern.Solid,
          fillColor={238,46,47}),
        Rectangle(
          extent={{-50,66},{50,-4}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-10,-34},{10,-24}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={238,46,47}),
        Polygon(
          points={{-40,-60},{-40,-60}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-34},{40,-34},{50,-44},{-52,-44},{-40,-34}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={255,0,0}),
        Rectangle(
          extent={{44,0},{38,40}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{34,0},{28,12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,0},{18,56}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{14,0},{8,36}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{4,0},{-2,12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-6,0},{-46,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{-60,72},{0,12}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Italic},
          fontName="Bookman Old Style",
          textString="€")}),
    defaultComponentName="priceSim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.BoundaryConditions.SimInfoManager into your model.",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
    <ul>
    <li>August 9, 2023, by Lucas Verleyen:<br>Initial implementation.</li>
</ul>
</html>", info="<html>
Model used to propagate electricity price data through all models inside agents. The ElectricityPriceSimInfoManager should be declared as an inner component in the outside model layer. Note that the loadFile parameter has to be propagated to be able to adapt it in higher model layers. 
</html>"));
end PriceSimInfoManager;

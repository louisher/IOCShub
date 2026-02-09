within IOCSmod.BoundaryConditions.GasPrices;
model GasPriceSimInfoManager
  "This model propagates gas price data through all component models"

  parameter String loadFile=Modelica.Utilities.Files.loadResource(
        "modelica://IOCSmod/Resources/GasPrices/BE_DynamicGas_consumer_2021.txt")
        annotation(Dialog(loadSelector(filter="All files (*.*)", caption="Select the gas price data file")));
  Modelica.Blocks.Sources.CombiTimeTable gasPrices(
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=loadFile,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="data",
    tableOnFile=true,
    timeScale=1,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents) annotation (
      Placement(visible=true, transformation(
        origin={-10,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  IOCSmod.BoundaryConditions.GasPrices.priceBus priceBus annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,0})));
equation
  connect(gasPrices.y[1], priceBus.dynamic_consumer) annotation (Line(points={{1,0},{
          50,0},{50,0.1},{99.9,0.1}}, color={0,0,127}));
annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Line(points={{-80,-30},{88,-30}}, color={0,0,0}),
        Line(points={{-76,-68},{-46,-30}}, color={0,0,0}),
        Line(points={{-42,-68},{-12,-30}}, color={0,0,0}),
        Line(points={{-8,-68},{22,-30}}, color={0,0,0}),
        Line(points={{28,-68},{58,-30}}, color={0,0,0}),
        Rectangle(
          extent={{-60,76},{60,-24}},
          lineColor={162,29,33},
          fillPattern=FillPattern.Solid,
          fillColor={162,29,33}),
        Rectangle(
          extent={{-50,66},{50,-4}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-10,-34},{10,-24}},
          pattern=LinePattern.None,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          lineColor={162,29,33}),
        Polygon(
          points={{-40,-60},{-40,-60}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-34},{40,-34},{50,-44},{-52,-44},{-40,-34}},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={162,29,33}),
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
    defaultComponentName="gasPriceSim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.BoundaryConditions.SimInfoManager into your model.",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
    <ul>
    <li>August 13, 2024, by Lucas Verleyen:<br>Initial implementation.</li>
</ul>
</html>", info="<html>
Model used to propagate gas price data through all models inside agents. The GasPriceSimInfoManager should be declared as an inner component in the outside model layer. Note that the loadFile parameter has to be propagated to be able to adapt it in higher model layers. 
</html>"));
end GasPriceSimInfoManager;

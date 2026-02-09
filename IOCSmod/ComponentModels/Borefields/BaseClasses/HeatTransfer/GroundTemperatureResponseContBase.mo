within IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer;
partial model GroundTemperatureResponseContBase "Partial model for a taco optimizable continous mode. "

  Modelica.Blocks.Interfaces.RealInput QBor_flow(unit="W")
    "Heat flow from all boreholes combined (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput delTBor(unit="K")
    "Temperature difference current borehole wall temperature minus initial borehole wall temperature"
    annotation (Placement(transformation(extent={{100,-14},{126,12}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  parameter Modelica.Units.SI.Time tLoaAgg(final min = Modelica.Constants.eps)
    "Time resolution of load aggregation";
  parameter IDEAS.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat
    "Record containing all the parameters of the borefield model" annotation (
     choicesAllMatching=true, Placement(transformation(extent={{-80,-80},{-60,-60}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,-4},{72,-4}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{-100,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
</ul>
</html>", info="<html>
<p>In this model, the default load aggregation scheme of the IBPSA library is made continuous using a QUICK scheme. For more information see the PhD thesis of I. Cupeiro</p>
</html>"));
end GroundTemperatureResponseContBase;

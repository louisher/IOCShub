within IOCSmod.BoundaryConditions.CO2Emissions;
connector co2Bus "Data bus that stores CO2 emissions data"

  IDEAS.Buildings.Components.Interfaces.RealConnector co2IntensityGrid(
    final unit="kg/J") "CO2 emission intensity factor of electricity from the grid"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector co2IntensityGrid_daily(
    final unit="kg/J") "CO2 emission intensity factor of electricity from the grid - daily average"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector co2IntensityGrid_weekly(
    final unit="kg/J") "CO2 emission intensity factor of electricity from the grid - weekly average"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector co2IntensityGrid_yearly(
    final unit="kg/J") "CO2 emission intensity factor of electricity from the grid - yearly median"
    annotation ();

  annotation (
    defaultComponentName="co2Bus",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
          Rectangle(
            lineColor={255,204,51},
            lineThickness=0.5,
            extent={{-20,-2},{20,2}}),
          Polygon(
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,
              -40},{-100,30}},
            smooth=Smooth.Bezier),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65,15},{-55,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5,15},{5,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55,15},{65,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35,-25},{-25,-15}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25,-25},{35,-15}}),
                              Rectangle(
          extent={{-21,2},{21,-2}},
          lineColor={255,204,51},
          lineThickness=0.5),
          Rectangle(
            lineColor={255,204,51},
            lineThickness=0.5,
            extent={{-20,-2},{20,2}}),
          Polygon(
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},
              {-100,30}},
            smooth=Smooth.Bezier),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65,15},{-55,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5,15},{5,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55,15},{65,25}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35,-25},{-25,-15}}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25,-25},{35,-15}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(revisions="<html>
    <ul>
	<li>August 11, 2023, by Lucas Verleyen:<br>Adopted from MoPED. Changes to include more columns (daily, weekly and yearly values).</li>
   	<li>May 11, 2023, by Lucas Verleyen:<br>Initial implementation (see issue <a href=\"https://gitlab.kuleuven.be/positive-energy-districts/moped/-/issues/104\">!104</a>).</li>
</ul>
</html>", info="<html>
<p>Data bus to combine all CO2 emissions related data. </p>
</html>"));
end co2Bus;

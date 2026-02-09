within IOCSmod.BoundaryConditions.ElectricityPrices;
connector priceBus "Data bus that stores electricity price data"

  IDEAS.Buildings.Components.Interfaces.RealConnector dynamic_raw(
    final unit="euro/J") "Dynamic grid electricity price (only energy component)"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector dynamic_consumer(
    final unit="euro/J") "Dynamic grid electricity price for consumers (including grid tarrifs and taxes)"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector dynamic_consumer_daily(
    final unit="euro/J") "Dynamic grid electricity price for consumers (including grid tarrifs and taxes) - daily average"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector dynamic_consumer_weekly(
    final unit="euro/J") "Dynamic grid electricity price for consumers (including grid tarrifs and taxes) - weekly average"
    annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector dynamic_consumer_yearly(
    final unit="euro/J") "Dynamic grid electricity price for consumers (including grid tarrifs and taxes) - yearly median"
    annotation ();

  annotation (
    defaultComponentName="priceBus",
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
    <li>August 9, 2023, by Lucas Verleyen:<br>Initial implementation.</li>
</ul>
</html>", info="<html>
<p>Data bus to combine all electricity price related data. </p>
</html>"));
end priceBus;

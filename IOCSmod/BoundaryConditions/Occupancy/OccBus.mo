within IOCSmod.BoundaryConditions.Occupancy;
connector OccBus "Data bus that stores occupancy data"

    IDEAS.Buildings.Components.Interfaces.RealConnector elecPowAct(
      final quantity="ActivePower",
      final unit="W") "Active electric power use" annotation ();
    IDEAS.Buildings.Components.Interfaces.RealConnector elecPowRec(
      final quantity="ReactivePower",
      final unit="W") "Reactive electric power use" annotation ();
    IDEAS.Buildings.Components.Interfaces.RealConnector heaGainRad(
      final quantity="HeatFlowRate",
      final unit="W",
      start=0) "radiative internal heat gains of appliances and lighting";
    IDEAS.Buildings.Components.Interfaces.RealConnector heaGainConv(
      final quantity="HeatFlowRate",
      final unit="W",
      start=0) "convective internal heat gains of appliances and lighting";
    IDEAS.Buildings.Components.Interfaces.RealConnector DHWdem(unit="l/min", start=0) "Domestic hot water demand" annotation ();
    IDEAS.Buildings.Components.Interfaces.RealConnector numOccAwake "number of occupants present that are awake" annotation ();
    IDEAS.Buildings.Components.Interfaces.RealConnector numOccSleep "number of occupants present that are sleeping" annotation ();
    IDEAS.Buildings.Components.Interfaces.RealConnector TSetSHDayZone(
      final quantity="Temperature",
      final unit="K",
      start=0) "Setpoint of the DayZone determined by the occupants";
    IDEAS.Buildings.Components.Interfaces.RealConnector TSetSHNightZone(
      final quantity="Temperature",
      final unit="K",
      start=0) "Setpoint of the NightZone determined by the occupants";

    annotation (
      defaultComponentName="occBus",
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
      <li>January 9, 2024, by Lucas Verleyen:<br>Add TSetDay and TSetNight.</li>
    <li>February 27, 2023, by Louis Hermans:<br>Initial implementation (see issue <a href=\"https://gitlab.kuleuven.be/positive-energy-districts/moped/-/issues/91\">#91</a>).</li>
        </ul>
        </html>",   info="<html>
        <p>Data bus to combine all occupancy profiles coming from StroBe. </p>
        </html>"));
end OccBus;

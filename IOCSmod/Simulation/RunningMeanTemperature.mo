within IOCSmod.Simulation;
model RunningMeanTemperature
  "Takes running mean temperature by checking temperature in the last 24 hours every 2 hours"


  discrete Modelica.Blocks.Interfaces.RealOutput y(unit="K", displayUnit="degC")
    "Average ambient temperature"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Sources.RealExpression Tamb(y=sim.Te)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

protected
  parameter Modelica.Units.SI.Time t_start(fixed=false)
    "Start time of the model";
  parameter Real coeTRm[12] = {1,1,1,1,1,1,1,1,1,1,1,1}./12;
  discrete Real[12] TMeasurementsOfTheDay(each unit="K",each displayUnit = "degC")
    "Vector with the temperatures of the previous measurements";

initial equation
  t_start = time;
  TMeasurementsOfTheDay=ones(12).*sim.Te;
  y = sim.Te;
algorithm
  when sample(t_start + 1*3600,24*3600) then
    TMeasurementsOfTheDay[1] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 3*3600,24*3600) then
    TMeasurementsOfTheDay[2] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 5*3600,24*3600) then
    TMeasurementsOfTheDay[3] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 7*3600,24*3600) then
    TMeasurementsOfTheDay[4] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 9*3600,24*3600) then
    TMeasurementsOfTheDay[5] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 11*3600,24*3600) then
    TMeasurementsOfTheDay[6] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 13*3600,24*3600) then
    TMeasurementsOfTheDay[7] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 15*3600,24*3600) then
    TMeasurementsOfTheDay[8] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 17*3600,24*3600) then
    TMeasurementsOfTheDay[9] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 19*3600,24*3600) then
    TMeasurementsOfTheDay[10] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 21*3600,24*3600) then
    TMeasurementsOfTheDay[11] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  when sample(t_start + 23*3600,24*3600) then
    TMeasurementsOfTheDay[12] := sim.Te;
    y := TMeasurementsOfTheDay*coeTRm;
  end when;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{0,100},{98,0},{0,-100}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-48,32},{58,-26}},
          lineColor={0,0,255},
          textString="EN15251")}),
Documentation(revisions="<html>
<ul>
<li>
April 17, 2018, by Damien Picard:<br/>
Add t_start in sample to compute correctly for non zero initial time.<br/>
Use sim.Te as initialization instead of an arbitrary value of 283.15K.
</li>
<li>
January 19, 2015, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end RunningMeanTemperature;

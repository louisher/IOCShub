within IOCSmod.BoundaryConditions.Occupancy;
model OccSimInfoManager
 "This propagates the occupancy profiles through all component models"

 parameter String loadFile=Modelica.Utilities.Files.loadResource(
    "modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School.txt") annotation(Dialog(loadSelector(filter="All files (*.*)", caption="Select the occupancy file")));
 Modelica.Blocks.Sources.CombiTimeTable occProfile(
   columns=2:10,
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

  IOCSmod.BoundaryConditions.Occupancy.OccBus occBus annotation (Placement(
        transformation(
        extent={{-18,-18},{18,18}},
        rotation=90,
        origin={100,0}), iconTransformation(
        extent={{-18,-18},{18,18}},
        rotation=90,
        origin={100,0})));
  IDEAS.Utilities.IO.SignalExchange.Read reaElePowAct(
    description="Active electrical power use",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="W")) "Active electrical power use. "
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaElePowRea(
    description="Reactive electrical power use",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="W")) "Reactive electrical power use. "
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaHeaGaiRad(
    description="Radiative internal heat gains of appliances and lighting.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="W")) "Radiative internal heat gains of appliances and lighting."
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaHeaGaiCon(
    description="Convective internal heat gains of appliances and lighting.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="W")) "Convective internal heat gains of appliances and lighting."
    annotation (Placement(transformation(extent={{40,4},{60,24}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaDhwDem(
    description="Domestic hot water demand.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="l/min")) "Domestic hot water demand."
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaNumOccAwa(
    description="Number of occupants present that are awake.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1")) "Number of occupants present that are awake."
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaNumOccSle(
    description="Number of occupants present that are sleeping.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1")) "Number of occupants present that are sleeping."
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaTSetSHDayZone(
    description="Setpoint temperature of the DayZone for SH.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Setpoint temperature of the DayZone for SH."
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  IDEAS.Utilities.IO.SignalExchange.Read reaTSetSHNightZone(
    description="Setpoint temperature of the NightZone for SH.",
    KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Setpoint temperature of the NightZone for SH."
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

equation
 connect(occProfile.y[1], occBus.elecPowAct) annotation (Line(points={{1,0},{50,
   0},{50,0.09},{99.91,0.09}},    color={0,0,127}));
 connect(occProfile.y[2], occBus.elecPowRec) annotation (Line(points={{1,0},{50,
   0},{50,0.09},{99.91,0.09}},    color={0,0,127}));
 connect(occProfile.y[3], occBus.heaGainRad) annotation (Line(points={{1,0},{50,
   0},{50,0.09},{99.91,0.09}},    color={0,0,127}));
 connect(occProfile.y[4], occBus.heaGainConv) annotation (Line(points={{1,0},{50,
   0},{50,0.09},{99.91,0.09}},    color={0,0,127}));
 connect(occProfile.y[5], occBus.DHWdem) annotation (Line(points={{1,0},{50,0},
   {50,0.09},{99.91,0.09}},
           color={0,0,127}));
 connect(occProfile.y[6], occBus.numOccAwake) annotation (Line(points={{1,0},{50,
   0},{50,0.09},{99.91,0.09}},    color={0,0,127}));
 connect(occProfile.y[7], occBus.numOccSleep) annotation (Line(points={{1,0},{50,
   0},{50,0.09},{99.91,0.09}},    color={0,0,127}));
 connect(occProfile.y[8], occBus.TSetSHDayZone) annotation (Line(points={{1,0},{
          50,0},{50,0.09},{99.91,0.09}},
                                  color={0,0,127}));
 connect(occProfile.y[9], occBus.TSetSHNightZone) annotation (Line(points={{1,0},{
          50,0},{50,0.09},{99.91,0.09}},
                                  color={0,0,127}));
  connect(occProfile.y[1], reaElePowAct.u)
    annotation (Line(points={{1,0},{20,0},{20,100},{38,100}},
                                                            color={0,0,127}));
  connect(reaElePowRea.u, occProfile.y[2])
    annotation (Line(points={{38,70},{20,70},{20,0},{1,0}}, color={0,0,127}));
  connect(reaHeaGaiRad.u, occProfile.y[3])
    annotation (Line(points={{38,40},{20,40},{20,0},{1,0}}, color={0,0,127}));
  connect(reaHeaGaiCon.u, occProfile.y[4])
    annotation (Line(points={{38,14},{20,14},{20,0},{1,0}}, color={0,0,127}));
  connect(reaDhwDem.u, occProfile.y[5]) annotation (Line(points={{38,-20},{20,-20},
          {20,0},{1,0}}, color={0,0,127}));
  connect(reaNumOccAwa.u, occProfile.y[6]) annotation (Line(points={{38,-50},{
          20,-50},{20,0},{1,0}}, color={0,0,127}));
  connect(reaNumOccSle.u, occProfile.y[7]) annotation (Line(points={{38,-80},{
          20,-80},{20,0},{1,0}}, color={0,0,127}));
  connect(reaTSetSHDayZone.u, occProfile.y[8]) annotation (Line(points={{38,-140},
          {20,-140},{20,0},{1,0}}, color={0,0,127}));
  connect(reaTSetSHNightZone.u, occProfile.y[9]) annotation (Line(points={{38,-110},
          {20,-110},{20,0},{1,0}}, color={0,0,127}));
 annotation (Icon(coordinateSystem(extent={{-100,-100},{100,120}}),
     graphics={
    Line(points={{-80,-30},{88,-30}}, color={0,0,0}),
    Line(points={{-76,-68},{-46,-30}}, color={0,0,0}),
    Line(points={{-42,-68},{-12,-30}}, color={0,0,0}),
    Line(points={{-8,-68},{22,-30}}, color={0,0,0}),
    Line(points={{28,-68},{58,-30}}, color={0,0,0}),
    Rectangle(
   extent={{-60,76},{60,-24}},
   lineColor={95,95,95},
   fillPattern=FillPattern.Solid,
   fillColor={95,95,95}),
    Rectangle(
   extent={{-50,66},{50,-4}},
   fillPattern=FillPattern.Solid,
   fillColor={255,255,255},
   pattern=LinePattern.None),
    Rectangle(
   extent={{-10,-34},{10,-24}},
   pattern=LinePattern.None,
   fillColor={95,95,95},
   fillPattern=FillPattern.Solid,
   lineColor={0,0,0}),
    Polygon(
   points={{-40,-60},{-40,-60}},
   pattern=LinePattern.None,
   smooth=Smooth.None,
   fillColor={0,0,0},
   fillPattern=FillPattern.Solid),
    Polygon(
   points={{-40,-34},{40,-34},{50,-44},{-52,-44},{-40,-34}},
   smooth=Smooth.None,
   fillColor={95,95,95},
   fillPattern=FillPattern.Solid,
   pattern=LinePattern.None),
    Rectangle(
   extent={{44,0},{38,40}},
   fillColor={217,67,180},
   fillPattern=FillPattern.Solid,
   pattern=LinePattern.None),
    Rectangle(
   extent={{34,0},{28,12}},
   fillColor={217,67,180},
   fillPattern=FillPattern.Solid,
   pattern=LinePattern.None),
    Rectangle(
   extent={{24,0},{18,56}},
   fillColor={217,67,180},
   fillPattern=FillPattern.Solid,
   pattern=LinePattern.None),
    Rectangle(
   extent={{14,0},{8,36}},
   fillColor={217,67,180},
   fillPattern=FillPattern.Solid,
   pattern=LinePattern.None),
    Rectangle(
   extent={{4,0},{-2,12}},
   fillColor={217,67,180},
   fillPattern=FillPattern.Solid,
   pattern=LinePattern.None),
    Line(
   points={{-6,0},{-46,0}},
   color={0,0,127},
   smooth=Smooth.None),
    Text(
   extent={{-88,136},{82,66}},
   textColor={217,67,180},
   textString="Strobe")}),
   defaultComponentName="occSim",
   defaultComponentPrefixes="inner",
   missingInnerMessage=
    "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.BoundaryConditions.SimInfoManager into your model.",
   Diagram(coordinateSystem(extent={{-100,-100},{100,120}})),
   Documentation(revisions="<html>
        <ul>
<li> September 27, 2023, by Javier Arroyo:<br>
Add Read and Overwrite blocks. See <a href=\"https://gitlab.kuleuven.be/positive-energy-districts/moped/-/issues/83\">!83</a>.</li>
        <li>February 27, 2023, by Louis Hermans:<br>Initial implementation (see issue <a href=\"https://gitlab.kuleuven.be/positive-energy-districts/moped/-/issues/91\">#91</a>).</li>
        </ul>
        </html>",   info="<html>
        Model used to propagate occupancy profiles from StroBe throughtout all models inside agents. In the outer agent layer the OccSimInfoManager should be declared as an inner component. Note that the loadFile parameter has to be propagated to be able to adapt it in higher model layers. 
        </html>"));
end OccSimInfoManager;

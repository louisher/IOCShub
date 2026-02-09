within IOCSmod.Demand.BuildingModels;
model TwoZoneBase "Base building model with only two zone envelope and occupancy"

  parameter Boolean addDummyEquation=true
  "=true, to balance equations in dymola";

  /* Parameter declaration */
  parameter String loadFile=Modelica.Utilities.Files.loadResource(
    "modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School.txt")
    annotation(Dialog(tab="House", group="Occupancy"));
  parameter Modelica.Units.SI.Temperature TStart=273.15 + 22
    "Initial zone temperature."
    annotation(Dialog(tab="HVAC", group="Initialisation"));
  parameter Modelica.Units.SI.Temperature TSetSHDayPresent=273.15 + 20
    "Setpoint temperature for space heating when people are present."
    annotation(Dialog(tab="HVAC", group="Space heating"));
  parameter Modelica.Units.SI.Temperature TSetSHNightPresent=273.15 + 18
    "Setpoint temperature for space heating when people are present."
    annotation(Dialog(tab="HVAC", group="Space heating"));
  parameter Modelica.Units.SI.Temperature TSetSHDayAbsent=273.15 + 16
    "Setpoint temperature for space heating when people are present."
    annotation(Dialog(tab="HVAC", group="Space heating"));
  parameter Modelica.Units.SI.Temperature TSetSHNightAbsent=273.15 + 16
    "Setpoint temperature for space heating when people are present."
    annotation(Dialog(tab="HVAC", group="Space heating"));

  parameter Modelica.Units.SI.Temperature TSetSCDayPresent=273.15 + 26
    "Setpoint temperature for space cooling when people are present."
    annotation(Dialog(tab="HVAC", group="Space cooling"));
  parameter Modelica.Units.SI.Temperature TSetSCNightPresent=273.15 + 26
    "Setpoint temperature for space cooling when people are present."
    annotation(Dialog(tab="HVAC", group="Space cooling"));
  parameter Modelica.Units.SI.Temperature TSetSCDayAbsent=273.15 + 35
    "Setpoint temperature for space cooling when people are present."
    annotation(Dialog(tab="HVAC", group="Space cooling"));
  parameter Modelica.Units.SI.Temperature TSetSCNightAbsent=273.15 + 35
    "Setpoint temperature for space cooling when people are present."
    annotation(Dialog(tab="HVAC", group="Space cooling"));


  parameter Modelica.Units.SI.Power Q_flow_nominal=40000 "Nominal heat flow rate in substation, used for calculation of m_flow_nominal at both side";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Nominal pressure raise of main circulation pump"
    annotation(Dialog(tab="HVAC", group="Space heating"));

  parameter Real n1=0
    "Number of photovoltaic panels"
    annotation(Dialog(tab="Electrical system", group="Main photovoltaic installation"));
  parameter Modelica.Units.SI.Angle azi1=0
    "Surface azimuth (0°=south, 90°=west, 180°=north, 270°=east)"
    annotation(Dialog(tab="Electrical system", group="Main photovoltaic installation"));
  parameter Modelica.Units.SI.Angle til1=0.785
    "Surface tilt (0°=horizontal, 90°=vertical)"
    annotation(Dialog(tab="Electrical system", group="Main photovoltaic installation"));
  parameter Real n2=0
    "Number of photovoltaic panels. Set n2=0 if no second installation."
    annotation(Dialog(tab="Electrical system", group="Second photovoltaic installation"));
  parameter Modelica.Units.SI.Angle azi2=0
    "Surface azimuth (0°=south, 90°=west, 180°=north, 270°=east)"
    annotation(Dialog(tab="Electrical system", group="Second photovoltaic installation"));
  parameter Modelica.Units.SI.Angle til2=0.785
    "Surface tilt (0°=horizontal, 90°=vertical)"
    annotation(Dialog(tab="Electrical system", group="Second photovoltaic installation"));
  parameter Modelica.Units.SI.Efficiency effPVInv=0.96 "Fixed inverter efficiency of the entire PV installation"
    annotation(Dialog(tab="Electrical system", group="PV inverter"));
  parameter Modelica.Units.SI.Power P_ac0=0.7*(n1+n2)*370 "Inverter rated AC power"
    annotation(Dialog(tab="Electrical system", group="PV inverter"));

  /* Simulation information managers */
  outer IDEAS.BoundaryConditions.SimInfoManager sim(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://IOCSmod/Resources/weatherdata/Vliet_2021-2022jan.mos"),
                                                    lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-138,136},{-118,156}})));
  inner IOCSmod.BoundaryConditions.Occupancy.OccSimInfoManager occSim(loadFile=
        loadFile) annotation (Placement(transformation(extent={{-138,110},{-118,
            132}})));

  /* Main components */
  replaceable IDEAS.Templates.Interfaces.BaseClasses.Structure bui(redeclare
      package Medium = IDEAS.Media.Specialized.DryAir,T_start=TStart)
    annotation (Placement(transformation(extent={{-56,50},{-26,70}})));

  IOCSmod.ComponentModels.ApplianceHeatGains applianceHeatGains(partition={
        0.8,0.2}, loadFile=loadFile)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  MoPED.Electrical.Photovoltaics.PVOrientedDCPower PV1(
    n=n1,
    til=til1,
    azi=azi1) "Main PV installation"
    annotation (Placement(transformation(extent={{40,130},{20,150}})));
  MoPED.Electrical.Photovoltaics.PVOrientedDCPower PV2(
    n=n2,
    til=til2,
    azi=azi2)
    "Second PV installation for different orientation than PV1. Set n2=0 if not used."
    annotation (Placement(transformation(extent={{40,110},{20,130}})));
  Modelica.Blocks.Math.Sum PVSum(nin=2) annotation (Placement(visible=true,
        transformation(
        origin={70,130},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  ComponentModels.Electrical.PVInverter_fixedEff PVinverter(eta_nom=
        effPVInv, P_ac0=P_ac0) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={100,130})));
  ComponentModels.Electrical.ACLoad Pac
    annotation (Placement(transformation(extent={{60,94},{80,114}})));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{140,-10},{160,10}}),
      iconTransformation(extent={{100,-64},{120,-44}})));
  Modelica.Blocks.Math.Sum Pnet(nin=3, k={-1,1,1})
    annotation (Placement(visible = true, transformation(origin={120,60},     extent = {{-10, -10}, {10, 10}}, rotation=270)));

  /* Set points and real expressions */
  Modelica.Blocks.Sources.RealExpression occ1(y=occSim.occBus.numOccAwake)
    annotation (Placement(transformation(extent={{0,100},{-20,120}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=occSim.occBus.numOccSleep)
    annotation (Placement(transformation(extent={{0,80},{-20,100}})));
  Modelica.Blocks.Sources.RealExpression TSetSHDayExpr(y=if people_present > 0
         then TSetSHDayPresent else TSetSHDayAbsent)
    annotation (Placement(transformation(extent={{-134,90},{-114,110}})));
  Modelica.Blocks.Sources.RealExpression TSetSHNightExpr(y=if people_present >
        0 then TSetSHNightPresent else TSetSHNightAbsent)
    annotation (Placement(transformation(extent={{-134,76},{-114,96}})));

  Modelica.Blocks.Sources.RealExpression TSetSCDayExpr(y=if people_present > 0
         then TSetSCDayPresent else TSetSCDayAbsent)
    annotation (Placement(transformation(extent={{-134,62},{-114,82}})));
  Modelica.Blocks.Sources.RealExpression TSetSCNightExpr(y=if people_present >
        0 then TSetSCNightPresent else TSetSCNightAbsent)
    annotation (Placement(transformation(extent={{-134,48},{-114,68}})));

  Real people_present;
equation
  people_present = occSim.occBus.numOccAwake + occSim.occBus.numOccSleep;

  connect(occ2.y, bui.occ[2])
    annotation (Line(points={{-21,90},{-31,90},{-31,70}},
                                                      color={0,0,127}));
  connect(occ1.y, bui.occ[1])
    annotation (Line(points={{-21,110},{-31,110},{-31,70}},
                                                      color={0,0,127}));

  connect(PVinverter.P_out,Pnet. u[1]) annotation (Line(points={{111,130},{120,
          130},{120,74},{118.667,74},{118.667,72}},
                                               color={0,0,127}));
  connect(Pac.P,Pnet. u[2])
    annotation (Line(points={{80.2,104},{120,104},{120,72}}, color={0,0,127}));
  connect(PVSum.y,PVinverter. P_PV)
    annotation (Line(points={{81,130},{88,130}}, color={0,0,127}));
  connect(PV1.P,PVSum. u[1]) annotation (Line(points={{41,140},{50,140},{50,129},
          {58,129}},   color={0,0,127}));
  connect(PV2.P,PVSum. u[2]) annotation (Line(points={{41,120},{50,120},{50,130},
          {58,130},{58,131}},   color={0,0,127}));
  connect(Pnet.y,P)
    annotation (Line(points={{120,49},{120,0},{150,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-56,-26},{-56,-92},{-12,-92},{-12,-46},{10,-46},{10,-92},{56,
              -92},{56,-26},{0,14},{-56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-56,-26},{-66,-34},{-72,-26},{0,26},{72,-26},{68,-34},{56,-26}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-44,-46},{-26,-46},{-26,-64},{-44,-64},{-44,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{24,-46},{42,-46},{42,-64},{24,-64},{24,-46}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{-10,-14},{8,-14},{8,-32},{-10,-32},{-10,-14}},
          color={244,125,35},
          thickness=0.5),
        Polygon(
          points={{6,24},{64,-18},{64,-16},{6,26},{6,24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,32},{76,32},{84,30},{86,26},{86,22},{86,18},{80,18},{80,22},
              {80,24},{76,26},{56,26},{56,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,32},{72,32},{72,40},{76,38},{76,42},{66,42},{66,38},{70,40},
              {70,32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,16},{82,12},{82,10},{84,8},{86,10},{86,12},{84,16}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-40,20}},
          textColor={0,0,0},
          textStyle={TextStyle.Italic},
          textString="2"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{140,160}})),
    Documentation(revisions="<html>
<ul>
<li>June 21, 2024, by Lucas Verleyen:<br>
Initial implementation.</li>
</ul>
</html>"));
end TwoZoneBase;

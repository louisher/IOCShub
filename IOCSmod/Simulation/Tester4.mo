within IOCSmod.Simulation;
model Tester4

    replaceable package Medium =
    IDEAS.Media.Water "Medium"
    annotation (choices(
        choice(redeclare package Medium = IDEAS.Media.Water "Water"),
        choice(redeclare package Medium =
            IDEAS.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

    parameter Modelica.Units.SI.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity muMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";
  ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube
    RCnetw(
    borFieDat(
      filDat(
        kFil=2,
        cFil=840,
        dFil(displayUnit="kg/m3") = 1818),
      soiDat(
        kSoi=1.9,
        cSoi=900,
        dSoi=1400),
      conDat(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        Rb(unit="(m.K)/W"),
        mBorFie_flow_nominal=100*0.2,
        dp_nominal(displayUnit="Pa") = 1,
        hBor=175,
        cooBor=[0,0; 0,3; 3,0; 3,3],
        mBor_flow_nominal=0.2,
        nBor=100,
        kTub=0.38,
        rBor=0.066,
        dBor=0.8,
        rTub=0.016,
        eTub=0.0029,
        xC=0.043)),
    T_start=283.15,
    cpMed=cpMed,
    kMed=kMed,
    muMed=muMed)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));


  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=278.15)
    annotation (Placement(transformation(extent={{-28,-48},{-8,-28}})));
equation
  connect(fixedTemperature1.port, RCnetw.port_3)
    annotation (Line(points={{-8,-38},{0,-38},{0,-10}}, color={191,0,0}));
  connect(fixedTemperature.port, RCnetw.port_4)
    annotation (Line(points={{-36,0},{-10,0}}, color={191,0,0}));
  connect(fixedTemperature1.port, RCnetw.port_1) annotation (Line(points={{-8,-38},
          {-8,-40},{30,-40},{30,18},{0,18},{0,10}}, color={191,0,0}));
  connect(fixedTemperature.port, RCnetw.port_2) annotation (Line(points={{-36,0},
          {-22,0},{-22,-16},{20,-16},{20,0},{10,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Tester4;

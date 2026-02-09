within IOCSmod.ComponentModels.Electrical.Examples;
model PVInverter "Example for the LinearBattery component model"
  extends Modelica.Icons.Example;
  IOCSmod.ComponentModels.Electrical.PVInverter_fixedEff pVInverter(P_ac0=5000)
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  MoPED.Electrical.Photovoltaics.PVOrientedDCPower PV(
    n=14,
    til=0.5235987755983,
    azi=0) "Main PV installation"
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://TinyCluster/Resources/weatherdata/Vliet_2021-2022jan.mos"),
      lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-96,74},{-76,94}})));
  PVInverter_variableEff                                    pVInverter1(P_ac0=
        5000) annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
equation
  connect(PV.P, pVInverter.P_PV)
    annotation (Line(points={{-19,10},{8,10}}, color={0,0,127}));
  connect(PV.P, pVInverter1.P_PV) annotation (Line(points={{-19,10},{0,10},{0,
          -20},{8,-20}}, color={0,0,127}));
  annotation (experiment(
      StopTime=31536000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end PVInverter;

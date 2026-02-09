within IOCSmod.ComponentModels.Verification;
model VerificationBatOpt
  Electrical.PVPanelDC pv(PVArea=100)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,76},{-80,96}})));
  Electrical.SizeOpt.LinearBatteryOpt bat(inv_cost=100)
    annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));

      Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
        "modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-50,32},{-30,52}})));
  Modelica.Blocks.Math.Sum sum1(nin=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-52,0})));
equation
  connect(bat.PDem, sum1.y)
    annotation (Line(points={{-78,0},{-63,8.88178e-16}}, color={0,0,127}));
  connect(P_appliances_profile.y[1], sum1.u[1]) annotation (Line(points={{-29,
          42},{-26,42},{-26,1},{-40,1}}, color={0,0,127}));
  connect(pv.P, sum1.u[2])
    annotation (Line(points={{-11,0},{-40,-1.9984e-15}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VerificationBatOpt;

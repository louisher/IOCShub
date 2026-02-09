within IOCSmod.Simulation;
model TestBor








  Modelica.Units.SI.HeatFlowRate QBor(unit="W")
                                               "Heat flow from all boreholes combined (positive if heat from fluid into soil)";

  Modelica.Blocks.Sources.CombiTimeTable QBorProfile(
    tableOnFile=true,
    tableName="power",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
        "modelica://BorOptMod/Resources/Data/Swimmingpool_power_ground.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
   constant Real b = 5 " Transition parameter for smooth min/max";

  Modelica.Blocks.Sources.RealExpression realExpression(y=QBor)
    annotation (Placement(transformation(extent={{-82,-24},{-62,-4}})));



  ComponentModels.Thermal.Borefields.SizeOpt.GroundTemperatureResponseFinal
    TBor annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
equation
  QBor=QBorProfile.y[1]*1000;
  connect(realExpression.y, TBor.QBor_flow) annotation (Line(points={{-61,-14},
          {-26,-14},{-26,2},{-11,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=35218800,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Euler"));
end TestBor;

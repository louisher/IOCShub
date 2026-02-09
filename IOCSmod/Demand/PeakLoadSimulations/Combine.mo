within IOCSmod.Demand.PeakLoadSimulations;
model Combine
  Office_A office_A
    annotation (Placement(transformation(extent={{-50,12},{-28,32}})));
  Gesl_M_A gesl_M_A
    annotation (Placement(transformation(extent={{-38,-36},{-16,-16}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://IOCSmod/Resources/weatherdata/Brussels-City_XMY2021-2040_ssp245_MAR-BCC_SWDbased.mos"))
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=30240000,
      Interval=300,
      __Dymola_Algorithm="Dassl"));
end Combine;

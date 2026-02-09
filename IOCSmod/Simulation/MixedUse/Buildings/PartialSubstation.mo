within IOCSmod.Simulation.MixedUse.Buildings;
partial model PartialSubstation
  replaceable package Medium=IDEAS.Media.Water;

    outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{198,-100},{218,-80}})));

  // *********** Building characteristics and  interface ***********
  parameter Integer nZones(min=1)=2
    "Number of conditioned thermal zones in the building";
  //parameter Boolean isHea=true "=true, if system is able to heat";
  //parameter Boolean isCoo=false "=true, if system is able to cool";
  parameter Boolean isDH=false "=true, if the system is connected to a DH grid";

  parameter Boolean hasIntCon=false "Tsensor and Tset inptus activated";
  //parameter Boolean InInterface = false;
  parameter Modelica.Units.SI.Power[nZones] Q_design
    "Total design heat load for heating system based on heat losses"
    annotation (Dialog(enable=InInterface));
    parameter Modelica.Units.SI.Area A_floor[nZones] "Floor/tabs surface area";

  // --- Ports
  parameter Integer nConvPorts(min=0) = nZones
    "Number of ports in building for convective heating/cooling"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nRadPorts(min=0) = nZones
    "Number of ports in building for radiative heating/cooling"
    annotation(Dialog(tab="Advanced"));
  parameter Integer nEmbPorts(min=0) = nZones
    "Number of ports in building for embedded systems"
    annotation(Dialog(tab="Advanced"));

  // --- Sensor
  parameter Integer nTemSen(min=0) = nZones
    "number of temperature inputs for the system";

  // *********** Outputs ***********
  // --- Thermal
  Modelica.Units.SI.Power QHeaSys=sum({max(0, -heatPortCon[i].Q_flow) for i in
      1:nConvPorts}) + sum({max(0, -heatPortRad[i].Q_flow) for i in 1:nRadPorts})
       + sum({max(0, -heatPortEmb[i].Q_flow) for i in 1:nEmbPorts})
    "Total thermal power use for space heating";
  Modelica.Units.SI.Power QCooTotal=sum({max(0, heatPortCon[i].Q_flow) for i in
          1:nConvPorts}) + sum({max(0, heatPortRad[i].Q_flow) for i in 1:
      nRadPorts}) + sum({max(0, heatPortEmb[i].Q_flow) for i in 1:nEmbPorts})
    "Total thermal power use for cooling";

// *********** Interface ***********
  // --- thermal
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nConvPorts] heatPortCon
    "Nodes for convective heat gains"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nRadPorts] heatPortRad
    "Nodes for radiative heat gains"
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nEmbPorts] heatPortEmb
    "Construction nodes for heat gains by embedded layers"
    annotation (Placement(transformation(extent={{-210,50},{-190,70}})));

  // --- Sensor
  Modelica.Blocks.Interfaces.RealInput[nTemSen] TSensor(
    final quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC",
    min=0) if hasIntCon "Sensor temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-204,-60})));

  Modelica.Blocks.Interfaces.RealInput[nZones] TSet(
    final quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC",
    min=0) if hasIntCon "Setpoint temperature for the zones" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-104}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-102})));

    annotation (Dialog(enable=InInterface),                                            Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{220,
            100}}),
        graphics={
        Rectangle(
          extent={{-202,100},{220,-100}},
          lineColor={0,128,255},
          lineThickness=1),
        Text(
          extent={{-178,140},{182,100}},
          textColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Bitmap(extent={{-152,-84},{136,104}}, fileName="modelica://MoBuild/Resources/Icons/hvac.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            220,100}})));
end PartialSubstation;

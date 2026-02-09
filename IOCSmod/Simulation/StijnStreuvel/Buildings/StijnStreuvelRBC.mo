within IOCSmod.Simulation.StijnStreuvel.Buildings;
model StijnStreuvelRBC
  extends IOCSmod.Simulation.StijnStreuvel.Buildings.StijnSBaseRBC(
    airHandlingUnit__AHU_huis_nr_3(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_5(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_7(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_9(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_11(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_13(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_15(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_17(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_19(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_21(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_23(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_25(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_27(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_29(threeWayValveMotor(ctrl=ctrlAhuHx)),
    airHandlingUnit__AHU_huis_nr_31(threeWayValveMotor(ctrl=ctrlAhuHx)),
    floorHeating__TABS_huis_nr_3__valve(y=valveSwitchApt3.y),
    floorHeating__TABS_huis_nr_5__valve(y=valveSwitchApt5.y),
    floorHeating__TABS_huis_nr_7__valve(y=valveSwitchApt7.y),
    floorHeating__TABS_huis_nr_9__valve(y=valveSwitchApt9.y),
    floorHeating__TABS_huis_nr_11__valve(y=valveSwitchApt11.y),
    floorHeating__TABS_huis_nr_13__valve(y=valveSwitchApt13.y),
    floorHeating__TABS_huis_nr_15__valve(y=valveSwitchApt15.y),
    floorHeating__TABS_huis_nr_17__valve(y=valveSwitchApt17.y),
    floorHeating__TABS_huis_nr_19__valve(y=valveSwitchApt19.y),
    floorHeating__TABS_huis_nr_21__valve(y=valveSwitchApt21.y),
    floorHeating__TABS_huis_nr_23__valve(y=valveSwitchApt23.y),
    floorHeating__TABS_huis_nr_25__valve(y=valveSwitchApt25.y),
    floorHeating__TABS_huis_nr_27__valve(y=valveSwitchApt27.y),
    floorHeating__TABS_huis_nr_29__valve(y=valveSwitchApt29.y),
    floorHeating__TABS_huis_nr_31__valve(y=valveSwitchApt31.y));

  output Real TSetLow = 21;
  output Real TSetHigh = 26;
  output Real CoolingPeriod = coolingPeriod_real.y;
  output Real ctrlAhuHx=(CoolingPeriod-0.5)*0.998+0.5 "AHU heat exchanger control signal considering min=0.001 and max=0.999. 0.001 in winter. 0.999 in summer";

    // PI controller parameters
  parameter Real k=0.8;
  parameter Real Ti=3000;


    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-250,-490},{-230,-470}}),
    iconTransformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        IDEAS.Media.Water)
    annotation (Placement(transformation(extent={{-120,-490},{-100,-470}}),
    iconTransformation(extent={{10,-110},{30,-90}})));

  Modelica.Blocks.Interfaces.RealOutput P
    annotation(Placement(transformation(extent={{0,-10},{20,10}}),
      iconTransformation(extent={{100,-64},{120,-44}})));

  Modelica.Blocks.Sources.CombiTimeTable P_appliances_profile(
    tableOnFile=true,
    tableName="data",
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
        "modelica://IOCSmod/Resources/OccupancyProfiles/Appliance_power_demand_StijnS_14houses.txt"),
    columns=2:2,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=P_AHUs_Schema_Sts)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Math.Sum Pnet(nin=2, k={1,1})
    annotation (Placement(visible = true, transformation(origin={-30,0},      extent = {{-10, -10}, {10, 10}}, rotation=0)));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,492},{618,512}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_5(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,452},{618,472}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_7(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,412},{618,432}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_9(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,372},{618,392}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_11(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,332},{618,352}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_13(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,292},{618,312}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_15(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,252},{618,272}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_17(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,212},{618,232}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_19(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,172},{618,192}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_21(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,132},{618,152}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_23(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,92},{618,112}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_25(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,52},{618,72}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_27(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,12},{618,32}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_29(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,-28},{618,-8}})));

  IDEAS.Controls.Continuous.LimPID conPiHeaApt_31(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Leefruimte.comfort.TComf),
    u_s=TSetLow + 0.5,
    k=k,
    Ti=Ti,
    yMin=0) annotation (Placement(transformation(extent={{598,-68},{618,-48}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_3_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,492},{658,512}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_5(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_5_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,452},{658,472}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_7(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_7_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,412},{658,432}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_9(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_9_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,372},{658,392}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_11(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_11_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,332},{658,352}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_13(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_13_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,292},{658,312}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_15(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_15_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,252},{658,272}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_17(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_17_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,212},{658,232}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_19(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_19_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,172},{658,192}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_21(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_21_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,132},{658,152}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_23(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_23_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,92},{658,112}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_25(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_25_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,52},{658,72}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_27(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_27_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,12},{658,32}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_29(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_29_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,-28},{658,-8}})));

  IDEAS.Controls.Continuous.LimPID conPiCooApt_31(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_m=Modelica.Units.Conversions.to_degC(zone__Huis_nr_31_Leefruimte.comfort.TComf),
    u_s=TSetHigh - 0.5,
    k=k,
    Ti=Ti,
    yMin=0,
    reverseActing=false)
            annotation (Placement(transformation(extent={{638,-68},{658,-48}})));

  Modelica.Blocks.Logical.Switch valveSwitchApt3
    annotation (Placement(transformation(extent={{678,492},{698,512}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt5
    annotation (Placement(transformation(extent={{678,452},{698,472}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt7
    annotation (Placement(transformation(extent={{678,412},{698,432}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt9
    annotation (Placement(transformation(extent={{678,372},{698,392}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt11
    annotation (Placement(transformation(extent={{678,332},{698,352}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt13
    annotation (Placement(transformation(extent={{678,292},{698,312}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt21
    annotation (Placement(transformation(extent={{678,132},{698,152}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt23
    annotation (Placement(transformation(extent={{678,92},{698,112}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt19
    annotation (Placement(transformation(extent={{678,172},{698,192}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt17
    annotation (Placement(transformation(extent={{678,212},{698,232}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt15
    annotation (Placement(transformation(extent={{678,252},{698,272}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt25
    annotation (Placement(transformation(extent={{678,52},{698,72}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt27
    annotation (Placement(transformation(extent={{678,12},{698,32}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt29
    annotation (Placement(transformation(extent={{678,-28},{698,-8}})));
  Modelica.Blocks.Logical.Switch valveSwitchApt31
    annotation (Placement(transformation(extent={{678,-68},{698,-48}})));
  Modelica.Blocks.Logical.GreaterThreshold coolcheck(threshold=20 + 273.15)
    annotation (Placement(transformation(extent={{-180,380},{-160,400}})));
  RunningMeanTemperature runningMeanTemperature
    annotation (Placement(transformation(extent={{-220,380},{-200,400}})));
  Modelica.Blocks.Math.BooleanToReal coolingPeriod_real
    annotation (Placement(transformation(extent={{-140,380},{-120,400}})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr3(k=1/3600)
    annotation (Placement(transformation(extent={{-620,330},{-640,350}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr3(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_3_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-582,330},{-602,350}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr3(k=1/3600)
    annotation (Placement(transformation(extent={{-620,290},{-640,310}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr3(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_3_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,290},{-600,310}})));
  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr5(k=1/3600)
    annotation (Placement(transformation(extent={{-620,250},{-640,270}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr5(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_5_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,250},{-600,270}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr5(k=1/3600)
    annotation (Placement(transformation(extent={{-620,210},{-640,230}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr5(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_5_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,210},{-600,230}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr7(k=1/3600)
    annotation (Placement(transformation(extent={{-620,170},{-640,190}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr7(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_7_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,170},{-600,190}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr7(k=1/3600)
    annotation (Placement(transformation(extent={{-620,130},{-640,150}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr7(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_7_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,130},{-600,150}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr9(k=1/3600)
    annotation (Placement(transformation(extent={{-620,90},{-640,110}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr9(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_9_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,90},{-600,110}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr9(k=1/3600)
    annotation (Placement(transformation(extent={{-620,50},{-640,70}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr9(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_9_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,50},{-600,70}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr11(k=1/3600)
    annotation (Placement(transformation(extent={{-620,10},{-640,30}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr11(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_11_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,10},{-600,30}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr11(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-30},{-640,-10}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr11(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_11_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-30},{-600,-10}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr13(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-70},{-640,-50}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr13(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_13_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-70},{-600,-50}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr13(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-110},{-640,-90}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr13(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_13_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-110},{-600,-90}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr15(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-150},{-640,-130}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr15(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_15_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-150},{-600,-130}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr15(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-190},{-640,-170}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr15(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_15_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-190},{-600,-170}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr17(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-230},{-640,-210}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr17(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_17_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-230},{-600,-210}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr17(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-270},{-640,-250}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr17(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_17_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-270},{-600,-250}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr19(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-310},{-640,-290}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr19(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_19_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-310},{-600,-290}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr19(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-350},{-640,-330}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr19(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_19_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-350},{-600,-330}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr21(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-390},{-640,-370}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr21(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_21_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-390},{-600,-370}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr21(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-430},{-640,-410}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr21(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_21_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-430},{-600,-410}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr23(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-470},{-640,-450}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr23(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_23_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-470},{-600,-450}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr23(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-510},{-640,-490}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr23(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_23_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-510},{-600,-490}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr25(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-550},{-640,-530}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr25(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_25_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-550},{-600,-530}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr25(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-590},{-640,-570}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr25(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_25_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-590},{-600,-570}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr27(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-630},{-640,-610}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr27(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_27_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-630},{-600,-610}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr27(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-670},{-640,-650}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr27(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_27_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-670},{-600,-650}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr29(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-710},{-640,-690}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr29(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_29_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-710},{-600,-690}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr29(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-750},{-640,-730}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr29(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_29_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-750},{-600,-730}})));

  Modelica.Blocks.Continuous.Integrator DiscmfCoo_nr31(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-790},{-640,-770}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfCoo_nr31(y=if coolcheck.y
         then (max(0, T_zone__Huis_nr_31_Leefruimte - TSetHigh)) else 0)
    annotation (Placement(transformation(extent={{-580,-790},{-600,-770}})));
  Modelica.Blocks.Continuous.Integrator DiscmfHea_nr31(k=1/3600)
    annotation (Placement(transformation(extent={{-620,-830},{-640,-810}})));
  Modelica.Blocks.Sources.RealExpression ExprDiscmfHea_nr31(y=if coolcheck.y
         then 0 else (max(0, TSetLow - T_zone__Huis_nr_31_Leefruimte)))
    annotation (Placement(transformation(extent={{-580,-830},{-600,-810}})));
Modelica.Blocks.Sources.RealExpression TotalDiscomfort(
    y=DiscmfCoo_nr3.y  + DiscmfHea_nr3.y  +
      DiscmfCoo_nr5.y  + DiscmfHea_nr5.y  +
      DiscmfCoo_nr7.y  + DiscmfHea_nr7.y  +
      DiscmfCoo_nr9.y  + DiscmfHea_nr9.y  +
      DiscmfCoo_nr11.y + DiscmfHea_nr11.y +
      DiscmfCoo_nr13.y + DiscmfHea_nr13.y +
      DiscmfCoo_nr15.y + DiscmfHea_nr15.y +
      DiscmfCoo_nr17.y + DiscmfHea_nr17.y +
      DiscmfCoo_nr19.y + DiscmfHea_nr19.y +
      DiscmfCoo_nr21.y + DiscmfHea_nr21.y +
      DiscmfCoo_nr23.y + DiscmfHea_nr23.y +
      DiscmfCoo_nr25.y + DiscmfHea_nr25.y +
      DiscmfCoo_nr27.y + DiscmfHea_nr27.y +
      DiscmfCoo_nr29.y + DiscmfHea_nr29.y +
      DiscmfCoo_nr31.y + DiscmfHea_nr31.y)
    annotation (Placement(transformation(extent={{-540, 360},{-560, 380}})));
equation
  connect(port_a, collector__Heating_collector.port_a1) annotation (Line(points={{-240,
          -480},{-242,-480},{-242,-514},{408,-514},{408,362},{483,362},{483,690}},
                 color={0,127,255}));
  connect(collector__Heating_collector.port_b1, port_b) annotation (Line(points={{503,690},
          {364,690},{364,338},{396,338},{396,-500},{-110,-500},{-110,-480}},
        color={0,127,255}));
  connect(realExpression.y, Pnet.u[1]) annotation (Line(points={{-79,20},{-60,
          20},{-60,-1},{-42,-1}}, color={0,0,127}));
  connect(P_appliances_profile.y[1], Pnet.u[2]) annotation (Line(points={{-79,
          -10},{-62,-10},{-62,1},{-42,1}}, color={0,0,127}));
  connect(Pnet.y, P)
    annotation (Line(points={{-19,0},{10,0}}, color={0,0,127}));
  connect(conPiCooApt_3.y,valveSwitchApt3.u1) annotation (Line(points={{659,502},
          {630,502},{630,520},{666,520},{666,510},{676,510}},color={0,0,127}));
  connect(conPiHeaApt_3.y,valveSwitchApt3.u3) annotation (Line(points={{619,502},
          {619,504},{666,504},{666,494},{676,494}},color={0,0,127}));
  connect(conPiCooApt_5.y,valveSwitchApt5.u1) annotation (Line(points={{659,462},
          {630,462},{630,480},{666,480},{666,470},{676,470}},color={0,0,127}));
  connect(conPiHeaApt_5.y,valveSwitchApt5.u3) annotation (Line(points={{619,462},
          {619,454},{676,454}},                    color={0,0,127}));
  connect(conPiCooApt_7.y,valveSwitchApt7.u1) annotation (Line(points={{659,422},
          {630,422},{630,440},{666,440},{666,430},{676,430}},color={0,0,127}));
  connect(conPiHeaApt_7.y,valveSwitchApt7.u3) annotation (Line(points={{619,422},
          {619,414},{676,414}},                    color={0,0,127}));
  connect(conPiCooApt_9.y,valveSwitchApt9.u1) annotation (Line(points={{659,382},
          {630,382},{630,400},{666,400},{666,390},{676,390}},color={0,0,127}));
  connect(conPiHeaApt_9.y,valveSwitchApt9.u3) annotation (Line(points={{619,382},
          {662,382},{662,374},{676,374}},          color={0,0,127}));
  connect(conPiCooApt_11.y,valveSwitchApt11.u1) annotation (Line(points={{659,342},
          {630,342},{630,360},{666,360},{666,350},{676,350}}, color={0,0,127}));
  connect(conPiHeaApt_11.y,valveSwitchApt11.u3) annotation (Line(points={{619,342},
          {662,342},{662,334},{676,334}},           color={0,0,127}));
  connect(conPiCooApt_13.y,valveSwitchApt13.u1) annotation (Line(points={{659,302},
          {630,302},{630,320},{666,320},{666,310},{676,310}}, color={0,0,127}));
  connect(conPiHeaApt_13.y,valveSwitchApt13.u3) annotation (Line(points={{619,302},
          {619,294},{676,294}},                     color={0,0,127}));
  connect(conPiCooApt_15.y,valveSwitchApt15.u1) annotation (Line(points={{659,262},
          {630,262},{630,280},{666,280},{666,270},{676,270}}, color={0,0,127}));
  connect(conPiHeaApt_15.y,valveSwitchApt15.u3) annotation (Line(points={{619,262},
          {662,262},{662,254},{676,254}},           color={0,0,127}));
  connect(conPiCooApt_17.y,valveSwitchApt17.u1) annotation (Line(points={{659,222},
          {630,222},{630,240},{666,240},{666,230},{676,230}}, color={0,0,127}));
  connect(conPiHeaApt_17.y,valveSwitchApt17.u3) annotation (Line(points={{619,222},
          {662,222},{662,214},{676,214}},           color={0,0,127}));
  connect(conPiCooApt_19.y,valveSwitchApt19.u1) annotation (Line(points={{659,182},
          {630,182},{630,200},{666,200},{666,190},{676,190}}, color={0,0,127}));
  connect(conPiHeaApt_19.y,valveSwitchApt19.u3) annotation (Line(points={{619,182},
          {662,182},{662,174},{676,174}},           color={0,0,127}));
  connect(conPiCooApt_21.y,valveSwitchApt21.u1) annotation (Line(points={{659,142},
          {630,142},{630,160},{666,160},{666,150},{676,150}}, color={0,0,127}));
  connect(conPiHeaApt_21.y,valveSwitchApt21.u3) annotation (Line(points={{619,142},
          {662,142},{662,134},{676,134}},           color={0,0,127}));
  connect(conPiCooApt_23.y,valveSwitchApt23.u1) annotation (Line(points={{659,102},
          {630,102},{630,120},{666,120},{666,110},{676,110}}, color={0,0,127}));
  connect(conPiHeaApt_23.y,valveSwitchApt23.u3) annotation (Line(points={{619,102},
          {619,94},{676,94}},                       color={0,0,127}));
  connect(conPiCooApt_25.y,valveSwitchApt25.u1) annotation (Line(points={{659,62},
          {630,62},{630,80},{666,80},{666,70},{676,70}},      color={0,0,127}));
  connect(conPiHeaApt_25.y,valveSwitchApt25.u3) annotation (Line(points={{619,62},
          {662,62},{662,54},{676,54}},              color={0,0,127}));
  connect(conPiCooApt_27.y,valveSwitchApt27.u1) annotation (Line(points={{659,22},
          {662,22},{662,30},{676,30}},                        color={0,0,127}));
  connect(conPiHeaApt_27.y,valveSwitchApt27.u3) annotation (Line(points={{619,22},
          {619,24},{666,24},{666,14},{676,14}},     color={0,0,127}));
  connect(conPiCooApt_29.y,valveSwitchApt29.u1) annotation (Line(points={{659,-18},
          {630,-18},{630,0},{666,0},{666,-10},{676,-10}},     color={0,0,127}));
  connect(conPiHeaApt_29.y,valveSwitchApt29.u3) annotation (Line(points={{619,-18},
          {619,-16},{666,-16},{666,-26},{676,-26}}, color={0,0,127}));
  connect(conPiCooApt_31.y,valveSwitchApt31.u1) annotation (Line(points={{659,-58},
          {630,-58},{630,-40},{666,-40},{666,-50},{676,-50}},
                                                         color={0,0,127}));
  connect(conPiHeaApt_31.y,valveSwitchApt31.u3) annotation (Line(points={{619,-58},
          {619,-56},{666,-56},{666,-66},{676,-66}},
                                                color={0,0,127}));
  connect(runningMeanTemperature.y, coolcheck.u)
    annotation (Line(points={{-199.4,390},{-182,390}}, color={0,0,127}));
  connect(coolcheck.y, coolingPeriod_real.u)
    annotation (Line(points={{-159,390},{-142,390}}, color={255,0,255}));

  connect(coolcheck.y, valveSwitchApt3.u2) annotation (Line(points={{-159,390},{
          -150,390},{-150,566},{-130,566},{-130,562},{600,562},{600,564},{638,564},
          {638,560},{668,560},{668,502},{676,502}}, color={255,0,255}));
  connect(valveSwitchApt3.u2, valveSwitchApt5.u2)
    annotation (Line(points={{676,502},{676,462}}, color={255,0,255}));
  connect(valveSwitchApt5.u2, valveSwitchApt7.u2)
    annotation (Line(points={{676,462},{676,422}}, color={255,0,255}));
  connect(valveSwitchApt7.u2, valveSwitchApt9.u2) annotation (Line(points={{676,
          422},{524,422},{524,382},{676,382}}, color={255,0,255}));
  connect(valveSwitchApt9.u2, valveSwitchApt11.u2) annotation (Line(points={{
          676,382},{524,382},{524,342},{676,342}}, color={255,0,255}));
  connect(valveSwitchApt11.u2, valveSwitchApt13.u2) annotation (Line(points={{
          676,342},{524,342},{524,302},{676,302}}, color={255,0,255}));
  connect(valveSwitchApt13.u2, valveSwitchApt15.u2) annotation (Line(points={{
          676,302},{524,302},{524,262},{676,262}}, color={255,0,255}));
  connect(valveSwitchApt15.u2, valveSwitchApt17.u2) annotation (Line(points={{
          676,262},{524,262},{524,222},{676,222}}, color={255,0,255}));
  connect(valveSwitchApt17.u2, valveSwitchApt19.u2) annotation (Line(points={{
          676,222},{524,222},{524,182},{676,182}}, color={255,0,255}));
  connect(valveSwitchApt19.u2, valveSwitchApt21.u2) annotation (Line(points={{
          676,182},{524,182},{524,142},{676,142}}, color={255,0,255}));
  connect(valveSwitchApt21.u2, valveSwitchApt23.u2) annotation (Line(points={{
          676,142},{524,142},{524,102},{676,102}}, color={255,0,255}));
  connect(valveSwitchApt23.u2, valveSwitchApt25.u2) annotation (Line(points={{
          676,102},{524,102},{524,62},{676,62}}, color={255,0,255}));
  connect(valveSwitchApt25.u2, valveSwitchApt27.u2) annotation (Line(points={{
          676,62},{524,62},{524,22},{676,22}}, color={255,0,255}));
  connect(valveSwitchApt27.u2, valveSwitchApt29.u2) annotation (Line(points={{
          676,22},{524,22},{524,-18},{676,-18}}, color={255,0,255}));
  connect(valveSwitchApt29.u2, valveSwitchApt31.u2) annotation (Line(points={{
          676,-18},{524,-18},{524,-58},{676,-58}}, color={255,0,255}));
  connect(ExprDiscmfCoo_nr3.y, DiscmfCoo_nr3.u)
    annotation (Line(points={{-603,340},{-618,340}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr3.y, DiscmfHea_nr3.u)
    annotation (Line(points={{-601,300},{-618,300}}, color={0,0,127}));
  connect(ExprDiscmfCoo_nr5.y, DiscmfCoo_nr5.u)
    annotation (Line(points={{-601,260},{-618,260}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr5.y, DiscmfHea_nr5.u)
    annotation (Line(points={{-601,220},{-618,220}}, color={0,0,127}));
  connect(ExprDiscmfCoo_nr7.y,  DiscmfCoo_nr7.u)   annotation (Line(points={{-601,180},{-618,180}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr7.y,  DiscmfHea_nr7.u)   annotation (Line(points={{-601,140},{-618,140}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr9.y,  DiscmfCoo_nr9.u)   annotation (Line(points={{-601,100},{-618,100}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr9.y,  DiscmfHea_nr9.u)   annotation (Line(points={{-601,60},{-618,60}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr11.y, DiscmfCoo_nr11.u)  annotation (Line(points={{-601,20},{-618,20}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr11.y, DiscmfHea_nr11.u)  annotation (Line(points={{-601,-20},{-618,-20}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr13.y, DiscmfCoo_nr13.u)  annotation (Line(points={{-601,-60},{-618,-60}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr13.y, DiscmfHea_nr13.u)  annotation (Line(points={{-601,-100},{-618,-100}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr15.y, DiscmfCoo_nr15.u)  annotation (Line(points={{-601,-140},{-618,-140}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr15.y, DiscmfHea_nr15.u)  annotation (Line(points={{-601,-180},{-618,-180}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr17.y, DiscmfCoo_nr17.u)  annotation (Line(points={{-601,-220},{-618,-220}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr17.y, DiscmfHea_nr17.u)  annotation (Line(points={{-601,-260},{-618,-260}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr19.y, DiscmfCoo_nr19.u)  annotation (Line(points={{-601,-300},{-618,-300}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr19.y, DiscmfHea_nr19.u)  annotation (Line(points={{-601,-340},{-618,-340}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr21.y, DiscmfCoo_nr21.u)  annotation (Line(points={{-601,-380},{-618,-380}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr21.y, DiscmfHea_nr21.u)  annotation (Line(points={{-601,-420},{-618,-420}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr23.y, DiscmfCoo_nr23.u)  annotation (Line(points={{-601,-460},{-618,-460}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr23.y, DiscmfHea_nr23.u)  annotation (Line(points={{-601,-500},{-618,-500}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr25.y, DiscmfCoo_nr25.u)  annotation (Line(points={{-601,-540},{-618,-540}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr25.y, DiscmfHea_nr25.u)  annotation (Line(points={{-601,-580},{-618,-580}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr27.y, DiscmfCoo_nr27.u)  annotation (Line(points={{-601,-620},{-618,-620}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr27.y, DiscmfHea_nr27.u)  annotation (Line(points={{-601,-660},{-618,-660}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr29.y, DiscmfCoo_nr29.u)  annotation (Line(points={{-601,-700},{-618,-700}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr29.y, DiscmfHea_nr29.u)  annotation (Line(points={{-601,-740},{-618,-740}}, color={0,0,127}));

  connect(ExprDiscmfCoo_nr31.y, DiscmfCoo_nr31.u)  annotation (Line(points={{-601,-780},{-618,-780}}, color={0,0,127}));
  connect(ExprDiscmfHea_nr31.y, DiscmfHea_nr31.u)  annotation (Line(points={{-601,-820},{-618,-820}}, color={0,0,127}));

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
          textString="15"),
        Polygon(
          points={{84,-40},{90,-40},{84,-54},{92,-54},{78,-80},{84,-58},{76,-58},
              {84,-40}},
          lineColor={0,0,0},
          fillColor={244,221,46},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-680,-480},{420,380}})));
end StijnStreuvelRBC;

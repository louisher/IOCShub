within IOCSmod.ComponentModels.Thermal.SizeOpt.Pumps;
model FlowControlled_m_flow
  extends UnitTests.Confidential.BaseClasses.FlowControlled_m_flow(
    redeclare replaceable UnitTests.Components.GenericThreePoints per(
      motorEfficiency(V_flow={2},eta={0.95}),
      hydraulicEfficiency(V_flow={0, 150, 300}/3600*1.225,
            eta={etaHydPar, etaHydPar, etaHydPar}),
      pressure(V_flow={0,150,300}/3600*1.225,
            dp={300,200,50})),
    redeclare replaceable UnitTests.Components.BaseClasses.SimplifiedFlowMachineInterface eff,
    use_inputFilter=false,
    allowFlowReversal=false,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_in(min=m_flow_min,
              max=m_flow_max,
              start=m_flow_nominal,
              nominal=m_flow_nominal/Q_flow_nominal,
              quantity=if inputType == UnitTests.Confidential.BaseClasses.InputType.Optimize
                      then "free_" + u_name
                      else ""));

  parameter String y_name = ""
    "Optional: low level output name for normalized speed"
    annotation(Dialog(group="Optimization"));
  parameter String m_flow_name = ""
    "Optional: low level output name for flow rate"
    annotation(Dialog(group="Optimization"));
  parameter String u_name = ""
    "Optional: control measurement name for reading from bacnet"
    annotation(Evaluate=true, Dialog(group="Optimization"));
  parameter Boolean addDummyEquation=false
    "=true, to balance equations in dymola"
    annotation(Dialog(enable=inputType == UnitTests.Confidential.BaseClasses.InputType.Optimize,group="Control"));
  parameter input Modelica.Units.SI.MassFlowRate m_flow_min(min=1e-8)=
    m_flow_nominal/1000 "Minimum pump mass flow rate" annotation (Dialog(enable=
         inputType == UnitTests.Confidential.BaseClasses.InputType.Optimize,
        group="Control"));
  parameter input Modelica.Units.SI.MassFlowRate m_flow_max(min=m_flow_min)=
    m_flow_nominal "Maximum pump mass flow rate" annotation (Dialog(enable=
          inputType == UnitTests.Confidential.BaseClasses.InputType.Optimize,
        group="Control"));
  parameter Real etaHydPar = 0.5 "Constant hydraulic efficiency";
// adding dummy variables with power of 1 to avoid being detected as alias variable
  Modelica.Blocks.Sources.Constant m_flow_dummy(k=m_flow_nominal)
    "Dummy for connecting to m_flow_in"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  parameter Modelica.Units.SI.Power Q_flow_nominal=if isWaterMedium then 10*
      4180*m_flow_nominal else 2*1000*m_flow_nominal
    "Nominal heat flow rate, for scaling only"
    annotation (Dialog(tab="Scaling"));
protected
  parameter Boolean isWaterMedium = Medium.density(Medium.setState_phX(Medium.p_default, Medium.h_default, Medium.X_default)) > 500;
  Real y_out(quantity=y_name) = y_actual^1 if not y_name == "";
  Real m_flow_out(quantity=m_flow_name) = m_flow_actual^1 if not m_flow_name == "";
equation
  if addDummyEquation and inputType == UnitTests.Confidential.BaseClasses.InputType.Optimize then
    connect(m_flow_in, m_flow_dummy.y);
  end if;
end FlowControlled_m_flow;

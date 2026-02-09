within IOCSmod.ComponentModels.Thermal.SizeOpt.Tank;
partial model PartialMixingVolumeOpt
  "Partial mixing volume with inlet and outlet ports (flow reversal is allowed)"

  extends
    IOCSmod.ComponentModels.Thermal.SizeOpt.Tank.LumpedVolumeDeclarationsOpt;
  parameter Boolean initialize_p = not Medium.singleState
    "= true to set up initial equations for pressure"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));

  // We set prescribedHeatFlowRate=false so that the
  // volume works without the user having to set this advanced parameter,
  // but to get high robustness, a user can set it to the appropriate value
  // as described in the info section.
  constant Boolean prescribedHeatFlowRate = false
    "Set to true if the model has a prescribed heat flow at its heatPort. If the heat flow rate at the heatPort is only based on temperature difference, then set to false";

  constant Boolean simplify_mWat_flow = true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  // Port definitions
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter input Modelica.Units.SI.Volume V "Volume";
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

  Medium.Temperature T(start=T_start, nominal=300) = Medium.temperature_phX(p=p, h=hOut_internal, X=cat(1,Xi,{1-sum(Xi)}))
    "Temperature of the fluid";
  Modelica.Blocks.Interfaces.RealOutput U(unit="J")
    "Internal energy of the component";
  Modelica.Units.SI.Pressure p=if nPorts > 0 then ports[1].p else p_start
    "Pressure of the fluid";
  Modelica.Blocks.Interfaces.RealOutput m(unit="kg") "Mass of the component";
  Modelica.Units.SI.MassFraction Xi[Medium.nXi]=XiOut_internal
    "Species concentration of the fluid";
  Modelica.Blocks.Interfaces.RealOutput mXi[Medium.nXi](each unit="kg")
    "Species mass of the component";
  Medium.ExtraProperty C[Medium.nC](nominal=C_nominal) = COut_internal
    "Trace substance mixture content";
  Modelica.Blocks.Interfaces.RealOutput mC[Medium.nC](each unit="kg")
    "Trace substance mass of the component";


  IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation steBal(
    final simplify_mWat_flow = simplify_mWat_flow,
    redeclare final package Medium=Medium,
    final m_flow_nominal = m_flow_nominal,
    final allowFlowReversal = allowFlowReversal,
    final m_flow_small = m_flow_small,
    final prescribedHeatFlowRate=prescribedHeatFlowRate,
    hOut(start=Medium.specificEnthalpy_pTX(
                 p=p_start,
                 T=T_start,
                 X=X_start)))
      if useSteadyStateTwoPort "Model for steady-state balance if nPorts=2"
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
  ConservationEquationOpt                     dynBal(
    final simplify_mWat_flow = simplify_mWat_flow,
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final fluidVolume = V,
    final initialize_p = initialize_p,
    m(start=V*rho_start),
    nPorts=nPorts,
    final mSenFac=mSenFac)
      if not useSteadyStateTwoPort "Model for dynamic energy balance"
    annotation (Placement(transformation(extent={{62,0},{82,20}})));

  // Density at start values, used to compute initial values and start guesses
  parameter Modelica.Units.SI.Density rho_start=Medium.density(state=
      state_start) "Density, used to compute start and guess values";
  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
  // Density at medium default values, used to compute the size of control volumes
  final parameter Modelica.Units.SI.Density rho_default=Medium.density(state=
      state_default) "Density, used to compute fluid mass";
  final parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
      T=T_start,
      p=p_start,
      X=X_start[1:Medium.nXi]) "Medium state at start values";
  // See info section for why prescribedHeatFlowRate is used here.
  // The condition below may only be changed if StaticTwoPortConservationEquation
  // contains a correct solution for all foreseeable parameters/inputs.
  // See Buildings, issue 282 for a discussion.
  final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and
      (prescribedHeatFlowRate or (not allowFlowReversal)) and (
      energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
      massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
      substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
      traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flag, true if the model has two ports only and uses a steady state balance"
    annotation (Evaluate=true);
  // Outputs that are needed to assign the medium properties
  Modelica.Blocks.Interfaces.RealOutput hOut_internal(unit="J/kg")
    "Internal connector for leaving temperature of the component";
  Modelica.Blocks.Interfaces.RealOutput XiOut_internal[Medium.nXi](each unit="1")
    "Internal connector for leaving species concentration of the component";
  Modelica.Blocks.Interfaces.RealOutput COut_internal[Medium.nC](each unit="1")
    "Internal connector for leaving trace substances of the component";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    "Port temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression portT(y=T) "Port temperature"
    annotation (Placement(transformation(extent={{-10,-10},{-30,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

equation
  ///////////////////////////////////////////////////////////////////////////
  // asserts
  if not allowFlowReversal then
    assert(ports[1].m_flow > -m_flow_small,
  "In " + getInstanceName() + ": Model has flow reversal,
  but the parameter allowFlowReversal is set to false.
  m_flow_small    = " + String(m_flow_small) + "
  ports[1].m_flow = " + String(ports[1].m_flow) + "
");
  end if;
  // Actual definition of port variables.
  //
  // If the model computes the energy and mass balances as steady-state,
  // and if it has only two ports,
  // then we use the same base class as for all other steady state models.
  if useSteadyStateTwoPort then
  connect(steBal.port_a, ports[1]) annotation (Line(
      points={{20,10},{10,10},{10,-20},{0,-20},{0,-20},{0,-100}},
      color={0,127,255}));

  connect(steBal.port_b, ports[2]) annotation (Line(
      points={{40,10},{46,10},{46,-20},{0,-20},{0,-100}},
      color={0,127,255}));
    U=0;
    mXi=zeros(Medium.nXi);
    m=0;
    mC=zeros(Medium.nC);
    connect(hOut_internal,  steBal.hOut);
    connect(XiOut_internal, steBal.XiOut);
    connect(COut_internal,  steBal.COut);
  else
      connect(dynBal.ports, ports) annotation (Line(
      points={{72,0},{72,-80},{2.22045e-15,-80},{2.22045e-15,-100}},
      color={0,127,255}));
    connect(U,dynBal.UOut);
    connect(mXi,dynBal.mXiOut);
    connect(m,dynBal.mOut);
    connect(mC,dynBal.mCOut);
    connect(hOut_internal,  dynBal.hOut);
    connect(XiOut_internal, dynBal.XiOut);
    connect(COut_internal,  dynBal.COut);
  end if;

  connect(portT.y, preTem.T)
    annotation (Line(points={{-31,0},{-38,0}},   color={0,0,127}));
  connect(heaFloSen.port_b, preTem.port)
    annotation (Line(points={{-70,0},{-65,0},{-60,0}},    color={191,0,0}));
  connect(heaFloSen.Q_flow, steBal.Q_flow) annotation (Line(points={{-80,-11},{-80,
          -16},{6,-16},{6,18},{18,18}},
                                     color={0,0,127}));
  connect(heaFloSen.Q_flow, dynBal.Q_flow) annotation (Line(points={{-80,-11},{-80,
          -16},{6,-16},{6,24},{50,24},{50,16},{60,16}},        color={0,0,127}));
  annotation (
defaultComponentName="vol",
Documentation(info="<html>
<p>
This is a partial model of an instantaneously mixed volume.
It is used as the base class for all fluid volumes of the package
<a href=\"modelica://IDEAS.Fluid.MixingVolumes\">
IDEAS.Fluid.MixingVolumes</a>.
</p>


<h4>Typical use and important parameters</h4>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mWat_flow = 0</code>.
</p>
<p>
Set the constant <code>simplify_mWat_flow = true</code> to simplify the equation
</p>
<pre>
  port_a.m_flow + port_b.m_flow = - mWat_flow;
</pre>
<p>
to
</p>
<pre>
  port_a.m_flow + port_b.m_flow = 0;
</pre>
<p>
This causes an error in the mass balance of about <i>0.5%</i>, but generally leads to
simpler equations because the pressure drop equations are then decoupled from the
mass exchange in this component.
</p>

<p>
To increase the numerical robustness of the model, the constant
<code>prescribedHeatFlowRate</code> can be set by the user.
This constant only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if the <i>only</i> means of heat transfer
at the <code>heatPort</code> is a prescribed heat flow rate that
is <i>not</i> a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
If the <code>heatPort</code> is not connected, then set <code>prescribedHeatFlowRate=true</code> as
in this case, <code>heatPort.Q_flow=0</code>.
</li>
<li>Set <code>prescribedHeatFlowRate=false</code> if there is heat flow at the <code>heatPort</code>
computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.<br/>
If there is a combination of <i>K * (T-heatPort.T)</i> and a prescribed heat flow rate,
for example a solar collector that dissipates heat to the ambient and receives heat from
the solar radiation, then set <code>prescribedHeatFlowRate=false</code>.
</li>
</ul>
<p>
Set the parameter <code>use_C_flow = true</code> to enable an input connector
for the trace substance flow rate.
</p>
<h4>Implementation</h4>
<p>
If the model is (i) operated in steady-state,
(ii) has two fluid ports connected, and
(iii) <code>prescribedHeatFlowRate=true</code> or <code>allowFlowReversal=false</code>,
then the model uses
<a href=\"modelica://IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation\">
IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
in order to use
the same energy and mass balance implementation as is used as in
steady-state component models.
In this situation, the functions <code>inStream</code> are used for the two
flow directions rather than the function
<code>actualStream</code>, which is less efficient.
However, the use of <code>inStream</code> has the disadvantage
that <code>hOut</code> has to be computed, in
<a href=\"modelica://IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation\">
IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation</a>,
using
</p>
<pre>
if allowFlowReversal then
  hOut = IDEAS.Utilities.Math.Functions.regStep(y1=port_b.h_outflow,
                                                    y2=port_a.h_outflow,
                                                    x=port_a.m_flow,
                                                    x_small=m_flow_small/1E3);
else
  hOut = port_b.h_outflow;
end if;
</pre>
<p>
Hence, for <code>allowFlowReversal=true</code>, if <code>hOut</code>
were to be used to compute the temperature that
drives heat transfer such as by conduction,
then the heat transfer would depend on upstream and the <i>downstream</i>
temperatures for small mass flow rates.
This can give wrong results. Consider for example a mass flow rate that is positive
but very close to zero. Suppose the upstream temperature is <i>20</i>&deg;C,
the downstream temperature is <i>10</i>&deg;C, and the heat port is
connected through a heat conductor to a boundary condition of <i>20</i>&deg;C.
Then, <code>hOut = (port_b.h_outflow + port_a.h_outflow)/2</code> and hence
the temperature <code>heatPort.T</code>
is <i>15</i>&deg;C. Therefore, heat is added to the component.
As the mass flow rate is by assumption very small, the fluid that leaves the component
will have a very high temperature, violating the 2nd law.
To avoid this situation, if
<code>prescribedHeatFlowRate=false</code>, then the model
<a href=\"modelica://IDEAS.Fluid.Interfaces.ConservationEquation\">
IDEAS.Fluid.Interfaces.ConservationEquation</a>
is used instead of
<a href=\"modelica://IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation\">
IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation</a>.
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://IDEAS.Fluid.MixingVolumes\">
IDEAS.Fluid.MixingVolumes</a>.
</p>
</html>", revisions="<html>
<ul>
<li>September 18, 2020, by Michael Wetter:<br>Set start value for <span style=\"font-family: Courier New;\">steBal.hOut</span> so that <span style=\"font-family: Courier New;\">T_start</span> can be used which is not known in that instance.<br>See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1397\">#1397</a>. </li>
<li>February 21, 2020, by Michael Wetter:<br>Changed icon to display its operating state.<br>This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>. </li>
<li>October 30, 2019 by Filip Jorissen:<br>Added <span style=\"font-family: Courier New;\">getInstanceName()</span> to flow reversal check. This if or <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1228\">issue 1228</a>. </li>
<li>October 19, 2017, by Michael Wetter:<br>Changed initialization of pressure from a <span style=\"font-family: Courier New;\">constant</span> to a <span style=\"font-family: Courier New;\">parameter</span>.<br>Removed <span style=\"font-family: Courier New;\">partial</span> keyword as this model is not partial.<br>Moved <span style=\"font-family: Courier New;\">C_flow</span> and <span style=\"font-family: Courier New;\">use_C_flow</span> to child classes.<br>This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>. </li>
<li>April 11, 2017, by Michael Wetter:<br>Moved heat port to the extending classes to provide better comment. Otherwise, the mixing volume without water input would have a comment that says latent heat can be added at this port.<br>Removed blocks <span style=\"font-family: Courier New;\">QSen_flow</span> and <span style=\"font-family: Courier New;\">QLat_flow</span>.<br>This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>. </li>
<li>February 19, 2016 by Filip Jorissen:<br>Added outputs U, m, mXi, mC for being able to check conservation of quantities. This if or <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/247\">issue 247</a>. </li>
<li>January 22, 2016 by Michael Wetter:<br>Updated model to use the new parameter <span style=\"font-family: Courier New;\">use_mWat_flow</span> rather than <span style=\"font-family: Courier New;\">sensibleOnly</span>. </li>
<li>January 17, 2016, by Michael Wetter:<br>Removed <span style=\"font-family: Courier New;\">protected</span> block <span style=\"font-family: Courier New;\">masExc</span> as this revision introduces a conditional connector for the moisture flow rate in the energy and mass balance models. This change was done to use the same modeling concept for the moisture input as is used for the trace substance input. </li>
<li>December 2, 2015, by Filip Jorissen:<br>Added conditional input <span style=\"font-family: Courier New;\">C_flow</span> for handling trace substance insertions. </li>
<li>July 17, 2015, by Michael Wetter:<br>Added constant <span style=\"font-family: Courier New;\">simplify_mWat_flow</span> to remove dependencies of the pressure drop calculation on the moisture balance. </li>
<li>July 1, 2015, by Filip Jorissen:<br>Set <span style=\"font-family: Courier New;\">prescribedHeatFlowRate=prescribedHeatflowRate</span> for <a href=\"modelica://IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation\">IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation</a>. This results in equations that are solved more easily. See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">issue 282</a> for a discussion. </li>
<li>June 9, 2015 by Michael Wetter:<br>Set start value for <span style=\"font-family: Courier New;\">heatPort.T</span> and changed type of <span style=\"font-family: Courier New;\">T</span> to <span style=\"font-family: Courier New;\">Medium.Temperature</span> rather than <span style=\"font-family: Courier New;\">Modelica.Units.SI.Temperature</span> to avoid an error because of conflicting start values if <span style=\"font-family: Courier New;\">IDEAS.Fluid.Chillers.Carnot_y</span> is translated using pedantic mode in Dymola 2016. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>. </li>
<li>June 5, 2015, by Michael Wetter:<br>Moved assignment of <span style=\"font-family: Courier New;\">dynBal.U.start</span> from instance <span style=\"font-family: Courier New;\">dynBal</span> to the actual model implementation. This is required for a pedantic model check in Dymola 2016. It addresses <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">issue 266</a>. </li>
<li>May 6, 2015, by Michael Wetter:<br>Improved documentation and changed the test </li>
<p><span style=\"font-family: Courier New;\">final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and</span></p>
<p><span style=\"font-family: Courier New;\">prescribedHeatFlowRate and ...</span></p>
<p>to </p>
<p><span style=\"font-family: Courier New;\">final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and</span></p>
<p><span style=\"font-family: Courier New;\">(prescribedHeatFlowRate or (not allowFlowReversal)) and ...</span></p>
<p>The reason is that if there is no flow reversal, then <a href=\"modelica://IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation\">IDEAS.Fluid.Interfaces.StaticTwoPortConservationEquation</a> computes <span style=\"font-family: Courier New;\">hOut = port_b.h_outflow;</span>, and hence it is correct to use <span style=\"font-family: Courier New;\">hOut</span> to compute temperature-driven heat flow, such as by conduction or convection. See also the model documentation.</p>
<p>This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/412\">#412</a>. </p>
<li>February 5, 2015, by Michael Wetter:<br>Changed <span style=\"font-family: Courier New;\">initalize_p</span> from a <span style=\"font-family: Courier New;\">parameter</span> to a <span style=\"font-family: Courier New;\">constant</span>. This is only required in finite volume models of heat exchangers (to avoid consistent but redundant initial conditions) and hence it should be set as a <span style=\"font-family: Courier New;\">constant</span>. </li>
<li>October 29, 2014, by Michael Wetter:<br>Made assignment of <span style=\"font-family: Courier New;\">mFactor</span> final, and changed computation of density to use default medium states as are also used to compute the specific heat capacity. </li>
<li>October 21, 2014, by Filip Jorissen:<br>Added parameter <span style=\"font-family: Courier New;\">mFactor</span> to increase the thermal capacity. </li>
<li>July 3, 2014, by Michael Wetter:<br>Added parameter <span style=\"font-family: Courier New;\">initialize_p</span>. This is required to enable the coil models to initialize the pressure in the first volume, but not in the downstream volumes. Otherwise, the initial equations will be overdetermined, but consistent. This change was done to avoid a long information message that appears when translating models. </li>
<li>May 29, 2014, by Michael Wetter:<br>Removed undesirable annotation <span style=\"font-family: Courier New;\">Evaluate=true</span>. </li>
<li>February 11, 2014 by Michael Wetter:<br>Removed <span style=\"font-family: Courier New;\">Q_flow</span> and added <span style=\"font-family: Courier New;\">QSen_flow</span>. This was done to clarify what is sensible and total heat flow rate as part of the correction of issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>. </li>
<li>October 8, 2013 by Michael Wetter:<br>Removed propagation of <span style=\"font-family: Courier New;\">show_V_flow</span> to instance <span style=\"font-family: Courier New;\">steBal</span> as it has no longer this parameter. </li>
<li>September 13, 2013 by Michael Wetter:<br>Renamed <span style=\"font-family: Courier New;\">rho_nominal</span> to <span style=\"font-family: Courier New;\">rho_start</span> because this quantity is computed using start values and not nominal values. </li>
<li>April 18, 2013 by Michael Wetter:<br>Removed the check of multiple connections to the same element of a fluid port, as this check required the use of the deprecated <span style=\"font-family: Courier New;\">cardinality</span> function. </li>
<li>February 7, 2012 by Michael Wetter:<br>Revised base classes for conservation equations in <span style=\"font-family: Courier New;\">IDEAS.Fluid.Interfaces</span>. </li>
<li>September 17, 2011 by Michael Wetter:<br>Removed instance <span style=\"font-family: Courier New;\">medium</span> as this is already used in <span style=\"font-family: Courier New;\">dynBal</span>. Removing the base properties led to 30&percnt; faster computing time for a solar thermal system that contains many fluid volumes. </li>
<li>September 13, 2011 by Michael Wetter:<br>Changed in declaration of <span style=\"font-family: Courier New;\">medium</span> the parameter assignment <span style=\"font-family: Courier New;\">preferredMediumStates=true</span> to <span style=\"font-family: Courier New;\">preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</span>. Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <span style=\"font-family: Courier New;\">T</span> as a state. See ticket Dynasim #13596. </li>
<li>July 26, 2011 by Michael Wetter:<br>Revised model to use new declarations from <a href=\"IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations\">IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations</a>. </li>
<li>July 14, 2011 by Michael Wetter:<br>Added start values for mass and internal energy of dynamic balance model. </li>
<li>May 25, 2011 by Michael Wetter:<br></li>
<li><ul>
<li>Changed implementation of balance equation. The new implementation uses a different model if exactly two fluid ports are connected, and in addition, the model is used as a steady-state component. For this model configuration, the same balance equations are used as were used for steady-state component models, i.e., instead of <span style=\"font-family: Courier New;\">actualStream(...)</span>, the <span style=\"font-family: Courier New;\">inStream(...)</span> formulation is used. This changed required the introduction of a new parameter <span style=\"font-family: Courier New;\">m_flow_nominal</span> which is used for smoothing in the steady-state balance equations of the model with two fluid ports. This implementation also simplifies the implementation of <a href=\"modelica://IDEAS.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort\">IDEAS.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</a>, which now uses the same equations as this model. </li>
<li>Another revision was the removal of the parameter <span style=\"font-family: Courier New;\">use_HeatTransfer</span> as there is no noticeable overhead in always having the <span style=\"font-family: Courier New;\">heatPort</span> connector present. </li>
</ul></li>
<li>July 30, 2010 by Michael Wetter:<br>Added nominal value for <span style=\"font-family: Courier New;\">mC</span> to avoid wrong trajectory when concentration is around 1E-7. See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">https://trac.modelica.org/Modelica/ticket/393</a>. </li>
<li>February 7, 2010 by Michael Wetter:<br>Simplified model and its base classes by removing the port data and the vessel area. Eliminated the base class <span style=\"font-family: Courier New;\">PartialLumpedVessel</span>. </li>
<li>October 12, 2009 by Michael Wetter:<br>Changed base class to <a href=\"modelica://IDEAS.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">IDEAS.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>. </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
       Text(
          extent={{-60,-26},{56,-58}},
          textColor={255,255,255},
          textString="V=%V"),
        Text(
          extent={{-152,100},{148,140}},
          textString="%name",
          textColor={0,0,255}),
       Ellipse(
          extent={{-100,98},{100,-102}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor=DynamicSelect({170,213,255}, min(1, max(0, (1-(T-273.15)/50)))*{28,108,200}+min(1, max(0, (T-273.15)/50))*{255,0,0})),
        Text(
          extent={{62,28},{-58,-22}},
          textColor={255,255,255},
          textString=DynamicSelect("", String(T-273.15, format=".1f")))}));
end PartialMixingVolumeOpt;

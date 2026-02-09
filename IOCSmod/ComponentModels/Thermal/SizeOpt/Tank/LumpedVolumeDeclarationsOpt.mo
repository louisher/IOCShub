within IOCSmod.ComponentModels.Thermal.SizeOpt.Tank;
block LumpedVolumeDeclarationsOpt "Declarations for lumped volumes (This model is copied from IDEAS, and the energyDynamics are made protected as this should not be changed anymore because it needs to be set to fixedInitial)"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = IDEAS.Media.Air "Moist air"),
        choice(redeclare package Medium = IDEAS.Media.Water "Water"),
        choice(redeclare package Medium =
            IDEAS.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));


  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
       quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
       quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the volume"
    annotation(Dialog(tab="Dynamics"));

  // The parameter below is evaluated by OCT during compilation, and
  // if false, the assert statement won't be optimized away during
  // code generation.
    // Assumptions
protected
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state, must be steady state if energyDynamics is steady state"
    annotation(Evaluate=true, Dialog(tab = "Advanced", group="Dynamics"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
    "Type of independent mass fraction balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Type of trace substance balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  final parameter Boolean wrongEnergyMassBalanceConfiguration=
    not (energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState or
         massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "True if configuration of energy and mass balance is wrong."
    annotation(Evaluate=true);
initial equation
  if wrongEnergyMassBalanceConfiguration then
  assert(not wrongEnergyMassBalanceConfiguration,
         "In " + getInstanceName() +
         ": energyDynamics is selected as steady state, and therefore massDynamics must also be steady-state.");
  end if;

annotation (preferredView="info",
Documentation(info="<html>
<p>
This class contains parameters and medium properties
that are used in the lumped  volume model, and in models that extend the
lumped volume model.
</p>
<p>
These parameters are used for example by
<a href=\"modelica://IDEAS.Fluid.Interfaces.ConservationEquation\">
IDEAS.Fluid.Interfaces.ConservationEquation</a>,
<a href=\"modelica://IDEAS.Fluid.MixingVolumes.MixingVolume\">
IDEAS.Fluid.MixingVolumes.MixingVolume</a> and
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2\">
IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>April, 2025, by Louis Hermans:<br>Moved <span style=\"font-family: Courier New;\">energyDynamics, massDynamics, substanceDynamics, traceDynamics</span> to proteced tab, and fixed the energyDynamics to fixedInitial to ensure correct strating temperature is used in TACO when temperature is a state (enforced if <span style=\"font-family: Courier New;\">preferredMediumStates=true</span> in medium instance of volume).</li>
<li>March 3, 2022, by Michael Wetter:<br>Moved <span style=\"font-family: Courier New;\">massDynamics</span> to <span style=\"font-family: Courier New;\">Advanced</span> tab, added assertion for correct combination of energy and mass dynamics and changed type from <span style=\"font-family: Courier New;\">record</span> to <span style=\"font-family: Courier New;\">block</span>.<br>This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>. </li>
<li>January 18, 2019, by Jianjun Hu:<br>Limited the media choice. See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>. </li>
<li>November 9, 2018 by Michael Wetter:<br>Limited choices of media that are displayed in the pull down menu of graphical editors.<br>This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">issue 1050</a>. </li>
<li>April 11, 2016 by Michael Wetter:<br>Corrected wrong hyperlink in documentation for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>. </li>
<li>January 26, 2016, by Michael Wetter:<br>Added <span style=\"font-family: Courier New;\">quantity=Medium.substanceNames</span> for <span style=\"font-family: Courier New;\">X_start</span>. </li>
<li>October 21, 2014, by Filip Jorissen:<br>Added parameter <span style=\"font-family: Courier New;\">mFactor</span> to increase the thermal capacity. </li>
<li>August 2, 2011, by Michael Wetter:<br>Set <span style=\"font-family: Courier New;\">substanceDynamics</span> and <span style=\"font-family: Courier New;\">traceDynamics</span> to final and equal to <span style=\"font-family: Courier New;\">energyDynamics</span>, as there is no need to make them different from <span style=\"font-family: Courier New;\">energyDynamics</span>. </li>
<li>August 1, 2011, by Michael Wetter:<br>Changed default value for <span style=\"font-family: Courier New;\">energyDynamics</span> to <span style=\"font-family: Courier New;\">Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</span> because <span style=\"font-family: Courier New;\">Modelica.Fluid.Types.Dynamics.SteadyStateInitial</span> leads to high order DAE that Dymola cannot reduce. </li>
<li>July 31, 2011, by Michael Wetter:<br>Changed default value for <span style=\"font-family: Courier New;\">energyDynamics</span> to <span style=\"font-family: Courier New;\">Modelica.Fluid.Types.Dynamics.SteadyStateInitial</span>. </li>
<li>April 13, 2009, by Michael Wetter:<br>First implementation. </li>
</ul>
</html>"));
end LumpedVolumeDeclarationsOpt;

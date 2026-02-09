within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses;
partial model PartialInternalHEX
  "Partial model to implement the internal heat exchanger of a borehole segment"
  parameter IDEAS.Fluid.Geothermal.Borefields.Data.Borefield.Template
    borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium"
    annotation (choices(
        choice(redeclare package Medium = IDEAS.Media.Water "Water"),
        choice(redeclare package Medium =
            IDEAS.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  constant Real mSenFac=1
    "Factor for scaling the sensible thermal mass of the volume";
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material"
    annotation (Dialog(tab="Dynamics"));
  parameter input Modelica.Units.SI.Length hSeg
    "Length of the internal heat exchanger";
  parameter Modelica.Units.SI.Length hSeg_dummy=100
    "Dummy length of the internal heat exchanger to calculate resistances";
  parameter input Modelica.Units.SI.Volume VTubSeg=hSeg*Modelica.Constants.pi*(
      borFieDat.conDat.rTub - borFieDat.conDat.eTub)^2
    "Fluid volume in each tube";
  parameter Modelica.Units.SI.Temperature TFlu_start
    "Start value of fluid temperature" annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature TGro_start
    "Start value of grout temperature" annotation (Dialog(tab="Initialization"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
protected
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
  parameter Real Rgb_val(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Real RCondGro_val(fixed=false)
    "Thermal resistance between: pipe wall to capacity in grout";
  parameter Real x(fixed=false) "Capacity location";
initial equation
  assert(borFieDat.conDat.rBor > borFieDat.conDat.xC + borFieDat.conDat.rTub and
         0 < borFieDat.conDat.xC - borFieDat.conDat.rTub,
         "The borehole geometry is not physical. Check the borefield data record
         to ensure that the shank spacing is larger than the outer tube radius
         and that the borehole radius is sufficiently large.");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>Partial model to implement models simulating the thermal and fluid behaviour of a borehole segment. --&gt; hSeg, VTubSeg are made input parameters, hSeg_dummy added. </p>
<p>The thermodynamic properties of the fluid circulating in the borehole are calculated as protected parameters in this partial model: <i>c<sub>p</i></sub> (<span style=\"font-family: Courier New;\">cpMed</span>), <i>k</i> (<span style=\"font-family: Courier New;\">kMed</span>) and <i>&mu;</i> (<span style=\"font-family: Courier New;\">muMed</span>). Additionally, the following parameters are already declared as protected parameters and thus do not need to be declared in models which extend this partial model: </p>
<ul>
<li><span style=\"font-family: Courier New;\">Rgb_val</span> (Thermal resistance between grout zone and borehole wall) </li>
<li><span style=\"font-family: Courier New;\">RCondGro_val</span> (Thermal resistance between pipe wall and capacity in grout) </li>
<li><span style=\"font-family: Courier New;\">x</span> (Grout capacity location) </li>
</ul>
<p><br><b>To allow parameter optimization:</b></p>
<p>- Made hSeg and VTubSeg input parameters.</p>
<p>- Added dummy segment length parameter hSeg_dummy.</p>
</html>", revisions="<html>
<ul>
<li>July 24, 2025, by Louis Hermans:<br>Made hSeg, and VTubSeg input parameters and added hSeg_dummy as parameter. This to allow parameter optimization.</li>
<li>January 18, 2019, by Jianjun Hu:<br>Limited the media choice to water and glycolWater. See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>. </li>
<li>July 10, 2018, by Alex Laferri&egrave;re:<br>First implementation of partial model. </li>
<li>June 18, 2014, by Michael Wetter:<br>Added initialization for temperatures and derivatives of <span style=\"font-family: Courier New;\">capFil1</span> and <span style=\"font-family: Courier New;\">capFil2</span> to avoid a warning during translation. </li>
<li>February 14, 2014, by Michael Wetter:<br>Removed unused parameters <span style=\"font-family: Courier New;\">B0</span> and <span style=\"font-family: Courier New;\">B1</span>. </li>
<li>January 24, 2014, by Michael Wetter:<br>Revised implementation, added comments, replaced <span style=\"font-family: Courier New;\">HeatTransfer.Windows.BaseClasses.ThermalConductor</span> with resistance models from the Modelica Standard Library. </li>
<li>January 23, 2014, by Damien Picard:<br>First implementation. </li>
</ul>
</html>"));
end PartialInternalHEX;

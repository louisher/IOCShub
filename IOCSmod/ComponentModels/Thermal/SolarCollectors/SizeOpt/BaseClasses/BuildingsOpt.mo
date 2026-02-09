within IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.BaseClasses;
package BuildingsOpt
  block EN12975HeatLoss "Calculate the heat loss of a solar collector per EN12975"
    extends IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.BaseClasses.BuildingsOpt.PartialHeatLoss(
      QLos_internal = A_c/nSeg * {dT[i] * (a1 - a2 * dT[i]) for i in 1:nSeg});

    parameter Modelica.Units.SI.CoefficientOfHeatTransfer a1(final min=0)
      "a1 from ratings data";

    parameter Real a2(final unit = "W/(m2.K2)", final min=0)
      "a2 from ratings data";

  annotation (
  defaultComponentName="heaLos",
  Documentation(info="<html>
<p>
This component computes the heat loss from the solar thermal collector
to the environment. It is designed anticipating ratings data collected in
accordance with EN12975. A negative heat loss indicates that heat
is being lost to the environment.
</p>
<p>
This model calculates the heat loss to the ambient, for each
segment <i>i &isin; {1, ..., n<sub>seg</sub>}</i>
where <i>n<sub>seg</sub></i> is the number of segments, as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>los,i</sub> = A<sub>c</sub> &frasl; n<sub>seg</sub>
(T<sub>env</sub>-T<sub>flu,i</sub>) (a<sub>1</sub> - a<sub>2</sub>
  (T<sub>env</sub>-T<sub>flu,i</sub>))
</p>
<p>
where
<i>a<sub>1</sub> &gt; 0</i> is the heat loss coefficient
from EN12975 ratings data,
<i>a<sub>2</sub> &ge; 0</i> is the temperature dependence of heat loss
from EN12975 ratings data,
<i>A<sub>c</sub></i> is the collector area,
<i>T<sub>env</sub></i> is the environment temperature and
<i>T<sub>flu,i</sub></i> is the fluid temperature in segment
<i>i &isin; {1, ..., n<sub>seg</sub>}</i>.
</p>
<p>
This model reduces the heat loss rate to <i>0</i> when the fluid temperature is within
<i>1</i> Kelvin of the minimum temperature of the medium model. The calculation is
performed using the
<a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
Buildings.Utilities.Math.Functions.smoothHeaviside</a> function.
</p>
<h4>Implementation</h4>
<p>
EN 12975 uses the arithmetic average temperature of the collector fluid inlet
and outlet temperature to compute the heat loss (see Duffie and Beckmann, p. 293).
However, unless the environment temperature that was present during the collector rating
is known, which is not the case, one cannot compute
a log mean temperature difference that would improve the <i>UA</i> calculation. Hence,
this model is using the fluid temperature of each segment
to compute the heat loss to the environment.
If the arithmetic average temperature were used, then segments at the collector
outlet could be cooled below the ambient temperature, which violates the 2nd law
of Thermodynamics.
</p>

<h4>References</h4>
<p>
CEN 2006, European Standard 12975-1:2006, European Committee for Standardization
</p>
</html>",   revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
December 17, 2017, by Michael Wetter:<br/>
Revised computation of heat loss.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">
issue 1100</a>.
</li>
<li>
Jan 16, 2012, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
  end EN12975HeatLoss;

  block PartialHeatLoss
    "Partial heat loss model on which ASHRAEHeatLoss and EN12975HeatLoss are based"
    extends Modelica.Blocks.Icons.Block;
    extends IOCSmod.ComponentModels.Thermal.SolarCollectors.SizeOpt.BaseClasses.BuildingsOpt.PartialParameters;

    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium in the component";

    Modelica.Blocks.Interfaces.RealInput TEnv(
      quantity="ThermodynamicTemperature",
      unit="K",
      displayUnit="degC") "Temperature of surrounding environment"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

    Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
      each quantity="ThermodynamicTemperature",
      each unit = "K",
      each displayUnit="degC") "Temperature of the heat transfer fluid"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.RealOutput QLos_flow[nSeg](
      each quantity="HeatFlowRate",
      each unit="W",
      each displayUnit="W") = {QLos_internal[i]*smooth(1, if TFlu[i] > TMedMin2
       then 1 else Buildings.Utilities.Math.Functions.smoothHeaviside(TFlu[i] -
      TMedMin, dTMin)) for i in 1:nSeg}
      "Limited heat loss rate at current conditions"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  protected
    constant Modelica.Units.SI.Temperature dTMin=1
      "Safety temperature difference to prevent TFlu < Medium.T_min";
    final parameter Modelica.Units.SI.Temperature TMedMin=Medium.T_min + dTMin
      "Fluid temperature below which there will be no heat loss computed to prevent TFlu < Medium.T_min";
    final parameter Modelica.Units.SI.Temperature TMedMin2=TMedMin + dTMin
      "Fluid temperature below which there will be no heat loss computed to prevent TFlu < Medium.T_min";

    input Modelica.Units.SI.HeatFlowRate QLos_internal[nSeg]
      "Heat loss rate at current conditions for each segment";

    Modelica.Units.SI.TemperatureDifference dT[nSeg]={TEnv - TFlu[i] for i in 1:
        nSeg} "Environment minus collector fluid temperature";

    annotation (
  defaultComponentName="heaLos",
  Documentation(info="<html>
<p>
This component is a partial model used as the base for
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss</a> and
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a>. It contains the
input, output and parameter declarations which are common to both models. More
detailed information is available in the documentation of the extending classes.
</p>
</html>",   revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
December 17, 2017, by Michael Wetter:<br/>
Revised computation of heat loss.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">
issue 1100</a>.
</li>
<li>
June 29, 2015, by Michael Wetter:<br/>
Revised implementation of heat loss near <code>Medium.T_min</code>
to make it more efficient.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Added missing <code>each</code> keyword.
</li>
<li>
Apr 17, 2013, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
  end PartialHeatLoss;

  block PartialParameters "Partial model for parameters"

    parameter input Modelica.Units.SI.Area A_c "Area of the collector";
    parameter Integer nSeg=3 "Number of segments";

    annotation(Documentation(info="<html>
<p>
Partial parameters used in all solar collector models
</p>
</html>",   revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
Apr 17, 2013, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
  end PartialParameters;
end BuildingsOpt;

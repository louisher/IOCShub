within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalResistancesOneUTube
  "Internal resistance model for single U-tube borehole segments."
  extends
    IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalResistances;

  parameter Modelica.Units.SI.ThermalResistance Rgg_val
    "Thermal resistance between the two grout zones";

  parameter input Modelica.Units.SI.HeatCapacity Co_fil=borFieDat.filDat.dFil*
      borFieDat.filDat.cFil*hSeg*Modelica.Constants.pi*(borFieDat.conDat.rBor^2
       - 2*borFieDat.conDat.rTub^2)
    "Heat capacity of the whole filling material";

  IOCSmod.ComponentModels.Thermal.SizeOpt.HeatCapacitorOpt capFil1(
    C=Co_fil/2,
    T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    if dynFil
    "Heat capacity of the filling material" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,50})));
  IOCSmod.ComponentModels.Thermal.SizeOpt.HeatCapacitorOpt capFil2(
    C=Co_fil/2,
    T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    if dynFil
    "Heat capacity of the filling material" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={70,50})));
  IOCSmod.ComponentModels.Thermal.SizeOpt.Tank.ThermalResistorOpt Rgg(R=Rgg1)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,50})));
  IOCSmod.ComponentModels.Thermal.SizeOpt.Tank.ThermalResistorOpt Rgb1(R=Rgb)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,30})));
  IOCSmod.ComponentModels.Thermal.SizeOpt.Tank.ThermalResistorOpt Rgb2(R=Rgb)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,0})));
protected
  parameter input Modelica.Units.SI.ThermalResistance Rgb=Rgb_val/hSeg;
  parameter input Modelica.Units.SI.ThermalResistance Rgg1=Rgg_val/hSeg;
equation
  connect(Rgb1.port_b, port_wall) annotation (Line(points={{-30,20},{-30,20},{-30,
          0},{0,0}}, color={191,0,0}));
  connect(capFil1.port, Rgb1.port_a)
    annotation (Line(points={{-60,50},{-30,50},{-30,40}}, color={191,0,0}));
  connect(Rgg.port_a, Rgb1.port_a)
    annotation (Line(points={{20,50},{-30,50},{-30,40}}, color={191,0,0}));
  connect(Rgb2.port_a, port_wall)
    annotation (Line(points={{20,0},{0,0},{0,0}}, color={191,0,0}));
  connect(capFil2.port, Rgg.port_b)
    annotation (Line(points={{60,50},{50,50},{40,50}}, color={191,0,0}));

  connect(port_1, capFil1.port)
    annotation (Line(points={{0,100},{0,50},{-60,50}}, color={191,0,0}));
  connect(Rgb2.port_b, capFil2.port)
    annotation (Line(points={{40,0},{48,0},{48,50},{60,50}}, color={191,0,0}));
  connect(port_2, capFil2.port) annotation (Line(points={{100,0},{48,0},{48,50},
          {60,50}}, color={191,0,0}));
    annotation (
    Documentation(info="<html>
<p>This model simulates the internal thermal resistance network of a borehole segment in the case of a single U-tube borehole using the method of Bauer et al. (2011) and computing explicitely the fluid-to-ground thermal resistance <i>R<sub>b</i></sub> and the grout-to-grout resistance <i>R<sub>a</i></sub> as defined by Claesson and Hellstrom (2011) using the multipole method. </p>
<p><b>To allow parameter optimization:</b></p>
<p>- Co_fil is made an input parameter</p>
<p>- Addition of protected resistance variables that are calculated as the absolute resitances devided by the input parameter hSeg.</p>
<p>- Change the resistance and capacity models to size optimizable ones.</p>
<p><br><b>References</b></p>
<p>J. Claesson and G. Hellstrom. <i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger. </i>HVAC&amp;R Research, 17(6): 895-911, 2011.</p>
<p>D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. <i>Thermal resistance and capacity models for borehole heat exchangers </i>. International Journal Of Energy Research, 35:312-320, 2011. </p>
</html>", revisions="<html>
<ul>
<li>
July 24, 2024, by Louis Hermans:<br/>
made Co_fil input parameter, added protected resistance parameter calculation, changed resistance and capacity models to optimizable ones. 
</li>
<li>
July 15, 2024, by Louis Hermans:<br/>
Removed Rpg1 and Rpg2 resistances to avoid series coupling of resistances in TACO.
</li>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
Extended the model from a partial class.
</li>
<li>
June, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Line(
          points={{-2,100}},
          color={0,0,0},
          thickness=1),          Text(
          extent={{-100,144},{100,106}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}));
end InternalResistancesOneUTube;

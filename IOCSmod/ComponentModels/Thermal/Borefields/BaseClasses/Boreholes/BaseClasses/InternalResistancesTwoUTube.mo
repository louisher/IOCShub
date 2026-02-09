within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalResistancesTwoUTube
  "Internal resistance model for double U-tube borehole segments."
  extends
    IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalResistances;

  parameter Modelica.Units.SI.ThermalResistance Rgg1_val
    "Thermal resistance between two neightbouring grout capacities, as defined by Bauer et al (2010)";
  parameter Modelica.Units.SI.ThermalResistance Rgg2_val
    "Thermal resistance between two  grout capacities opposite to each other, as defined by Bauer et al (2010)";
  parameter Modelica.Units.SI.HeatCapacity Co_fil=borFieDat.filDat.dFil*
      borFieDat.filDat.cFil*hSeg*Modelica.Constants.pi*(borFieDat.conDat.rBor^2
       - 4*borFieDat.conDat.rTub^2)
    "Heat capacity of the whole filling material";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_3
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_4
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg14(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg21(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=270,
        origin={50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg11(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={90,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg12(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={50,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={30,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb3(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb4(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-30,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg13(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg22(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={30,-84})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if dynFil "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{-8,-8},
            {8,8}},
        rotation=90,
        origin={-22,64})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if dynFil "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{58,8},{
            74,24}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil3(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if dynFil "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{-8,-8},
            {8,8}},
        rotation=90,
        origin={-26,-62})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil4(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if dynFil "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{-82,20},
            {-66,36}})));
equation
  connect(Rgb1.port_b, port_wall)
    annotation (Line(points={{0,22},{0,22},{0,0}}, color={191,0,0}));
  connect(port_wall, Rgb3.port_b)
    annotation (Line(points={{0,0},{0,0},{0,-22}}, color={191,0,0}));
  connect(port_wall, Rgb2.port_b)
    annotation (Line(points={{0,0},{11,0},{22,0}}, color={191,0,0}));
  connect(port_wall, Rgb4.port_b)
    annotation (Line(points={{0,0},{-12,0},{-22,0}}, color={191,0,0}));
  connect(Rgg13.port_b, Rgb3.port_a) annotation (Line(points={{-50,-38},{-50,-38},
          {-50,-50},{0,-50},{0,-38},{-4.44089e-016,-38}}, color={191,0,0}));
  connect(Rgg13.port_b, Rgg12.port_b) annotation (Line(points={{-50,-38},{-50,-38},
          {-50,-50},{50,-50},{50,-38}}, color={191,0,0}));
  connect(Rgb2.port_a, Rgg12.port_a)
    annotation (Line(points={{38,0},{38,0},{50,0},{50,-22}}, color={191,0,0}));
  connect(Rgg14.port_a, Rgb1.port_a) annotation (Line(points={{-50,38},{-50,46},
          {0,46},{0,38},{4.996e-016,38}}, color={191,0,0}));
  connect(capFil1.port, Rgb1.port_a) annotation (Line(points={{-14,64},{0,64},{0,
          38},{4.996e-016,38}}, color={191,0,0}));
  connect(port_1, capFil1.port)
    annotation (Line(points={{0,100},{0,64},{-14,64}}, color={191,0,0}));
  connect(Rgg21.port_b, Rgb1.port_a)
    annotation (Line(points={{50,38},{50,46},{0,46},{0,38}}, color={191,0,0}));
  connect(Rgg14.port_b, Rgb4.port_a)
    annotation (Line(points={{-50,22},{-50,0},{-38,0}}, color={191,0,0}));
  connect(Rgg13.port_a, Rgb4.port_a) annotation (Line(points={{-50,-22},{-50,0},
          {-38,0},{-38,1.77636e-15}}, color={191,0,0}));
  connect(capFil4.port, Rgb4.port_a)
    annotation (Line(points={{-74,20},{-74,0},{-38,0}}, color={191,0,0}));
  connect(Rgb2.port_a, Rgg21.port_a)
    annotation (Line(points={{38,0},{50,0},{50,22}}, color={191,0,0}));
  connect(capFil3.port, Rgb3.port_a)
    annotation (Line(points={{-18,-62},{0,-62},{0,-38}}, color={191,0,0}));
  connect(capFil2.port, Rgb2.port_a)
    annotation (Line(points={{66,8},{66,0},{38,0}}, color={191,0,0}));
  connect(port_2, capFil2.port)
    annotation (Line(points={{100,0},{66,0},{66,8}}, color={191,0,0}));
  connect(port_4, capFil4.port)
    annotation (Line(points={{-100,0},{-74,0},{-74,20}}, color={191,0,0}));
  connect(port_3, capFil3.port)
    annotation (Line(points={{0,-100},{0,-62},{-18,-62}}, color={191,0,0}));
  connect(Rgg11.port_b, capFil3.port)
    annotation (Line(points={{90,22},{90,-62},{-18,-62}}, color={191,0,0}));
  connect(Rgg11.port_a, capFil1.port) annotation (Line(points={{90,38},{92,38},
          {92,64},{-14,64}}, color={191,0,0}));
  connect(capFil4.port, Rgg22.port_a)
    annotation (Line(points={{-74,20},{-74,-84},{22,-84}}, color={191,0,0}));
  connect(Rgg22.port_b, capFil2.port)
    annotation (Line(points={{38,-84},{66,-84},{66,8}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{0,-50},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,40},{0,
              50}},
          color={0,0,0},
          origin={-50,0},
          rotation=-90,
          thickness=0.5),
        Line(
          points={{0,-50},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,40},{0,
              50}},
          color={0,0,0},
          origin={0,-50},
          rotation=360,
          thickness=0.5),
        Line(
          points={{0,-70.7107},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,
              40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={-50,-50},
          rotation=45,
          thickness=0.5),
        Line(
          points={{7.10543e-015,-70.7107},{0,-40},{-10,-30},{9.99997,-9.99997},
              {-9.99997,9.99997},{10,30},{0,40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={-50,50},
          rotation=135,
          thickness=0.5),
        Line(
          points={{7.10543e-015,-70.7107},{0,-40},{-10,-30},{9.99997,-9.99997},
              {-9.99997,9.99997},{10,30},{0,40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={50,-50},
          rotation=135,
          thickness=0.5),        Text(
          extent={{-100,144},{100,106}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This model simulates the internal thermal resistance network of a borehole segment in
the case of a double U-tube borehole using the method of Bauer et al. (2011) 
and computing explicitely the fluid-to-ground thermal resistance 
<i>R<sub>b</sub></i> and the 
grout-to-grout resistance
<i>R<sub>a</sub></i> as defined by Claesson and Hellstrom (2011)
using the multipole method. 
</p>
<h4>References</h4>
<p>J. Claesson and G. Hellstrom. 
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger. 
</i>
HVAC&amp;R Research,
17(6): 895-911, 2011.</p>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
Thermal resistance and capacity models for borehole heat exchangers
</i>.
International Journal Of Energy Research, 35:312-320, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
Removed Rpg1, Rpg2, Rpg3, and Rpg4 resistances to avoid series coupling of resistances in TACO.
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
</html>"));
end InternalResistancesTwoUTube;

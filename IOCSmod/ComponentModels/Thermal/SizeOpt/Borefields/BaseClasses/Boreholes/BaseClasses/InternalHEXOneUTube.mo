within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalHEXOneUTube
  "Internal heat exchanger of a borehole for a single U-tube configuration"
  extends
    IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX;
  extends IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFlu_start,
    T2_start=TFlu_start,
    final tau1=VTubSeg*rho1_nominal/m1_flow_nominal,
    final tau2=VTubSeg*rho2_nominal/m2_flow_nominal,
    vol1(
      final prescribedHeatFlowRate=false,
      final allowFlowReversal=allowFlowReversal1,
      final m_flow_small=m1_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac),
    vol2(
      final prescribedHeatFlowRate=false,
      final m_flow_small=m2_flow_small,
      final V=VTubSeg,
      final mSenFac=mSenFac));


public
  IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesOneUTube
    intResUTub(
    dynFil=dynFil,
    hSeg=hSeg,
    energyDynamics=energyDynamics,
    Rgb_val=resistanceCalculator.Rgb_val,
    Rgg_val=resistanceCalculator.Rgg_val,
    RCondGro_val=resistanceCalculator.RCondGro_val,
    borFieDat=borFieDat,
    T_start=TGro_start)
    "Internal resistances for a single U-tube configuration"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-12,12},{12,-12}},
        rotation=270,
        origin={0,-28})));
  Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
    "Pipe convective resistance"
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,28})));
  ResistanceCalculator_OneUTube resistanceCalculator(
    borFieDat=borFieDat,
    cpMed=cpMed,
    kMed=kMed,
    muMed=muMed)
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Modelica.Blocks.Sources.RealExpression RConv1Expr(y=
        IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
        hSeg=hSeg_dummy,
        rTub=borFieDat.conDat.rTub,
        eTub=borFieDat.conDat.eTub,
        kMed=kMed,
        muMed=muMed,
        cpMed=cpMed,
        m_flow=m1_flow,
        m_flow_nominal=m1_flow_nominal)*hSeg_dummy)
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-117,2},{-103,18}})));
  Modelica.Blocks.Sources.RealExpression RVol1(y=(RConv1Expr.y +
        resistanceCalculator.RCondGro_val)/hSeg)
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-97,2},{-83,18}})));
  Modelica.Blocks.Sources.RealExpression RConv2Expr(y=
        IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
        hSeg=hSeg_dummy,
        rTub=borFieDat.conDat.rTub,
        eTub=borFieDat.conDat.eTub,
        kMed=kMed,
        muMed=muMed,
        cpMed=cpMed,
        m_flow=m1_flow,
        m_flow_nominal=m2_flow_nominal)*hSeg_dummy)
    "Convective and thermal resistance at fluid 1"
    annotation (Placement(transformation(extent={{-117,-18},{-103,-2}})));
  Modelica.Blocks.Sources.RealExpression RVol2(y=(RConv2Expr.y +
        resistanceCalculator.RCondGro_val)/hSeg)
    "Convective and thermal resistance at fluid 2"
    annotation (Placement(transformation(extent={{-98,-1},{-82,-19}})));

equation
    assert(borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
  "This model should be used for single U-type borefield, not double U-type.
  Check that the conDat record has been correctly parametrized");
  connect(vol1.heatPort, RConv1.fluid) annotation (Line(points={{-10,60},{-20,
          60},{-20,40},{6.66134e-016,40}}, color={191,0,0}));
  connect(RConv1.solid, intResUTub.port_1)
    annotation (Line(points={{0,16},{0,16},{0,10}}, color={191,0,0}));
  connect(RConv2.fluid, vol2.heatPort) annotation (Line(points={{0,-40},{20,-40},
          {20,-60},{12,-60}}, color={191,0,0}));
  connect(RConv2.solid, intResUTub.port_2) annotation (Line(points={{0,-16},{0,
          -12},{16,-12},{16,0},{10,0}}, color={191,0,0}));
  connect(intResUTub.port_wall, port_wall) annotation (Line(points={{0,0},{0,0},
          {0,6},{-28,6},{-28,86},{0,86},{0,100}},             color={191,0,0}));
  connect(RVol1.y, RConv1.Rc) annotation (Line(points={{-82.3,10},{-60,10},{-60,
          28},{-12,28}}, color={0,0,127}));
  connect(RVol2.y, RConv2.Rc) annotation (Line(points={{-81.2,-10},{-60,-10},{-60,
          -28},{-12,-28}}, color={0,0,127}));
    annotation (Dialog(tab="Dynamics"),
    Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
                    graphics={Rectangle(
          extent={{88,54},{-88,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{88,-66},{-88,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Model for the heat transfer between the fluid and within the borehole filling for a single borehole segment. This model computes the dynamic response of the fluid in the tubes, the heat transfer between the fluid and the borehole filling, and the heat storage within the fluid and the borehole filling. </p>
<p>This model computes the different thermal resistances present in a single-U-tube borehole using the method of Bauer et al. (2011) and computing explicitely the fluid-to-ground thermal resistance <i>R<sub>b</i></sub> and the grout-to-grout resistance <i>R<sub>a</i></sub> as defined by Claesson and Hellstrom (2011) using the multipole method. </p>
<p><b>To allow parameter optimization:</b></p>
<p>- Extensions changed to custom models with input parameters</p>
<p>- Added real expressions to calculate the convective resistance for a dummy segment lenght. The actual resistance value is then found by deviding this dummy resistance by the dummy lenght and multiplying by the actual length. Note that for RCondGro the dummy value is taken from the resistance calculator (where the dummy value is already muliplied by the dummy length).</p>
<p><b>References</b></p>
<p>J. Claesson and G. Hellstrom. <i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger. </i>HVAC&amp;R Research, 17(6): 895-911, 2011.</p>
<p>D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch. <i>Thermal resistance and capacity models for borehole heat exchangers </i>. International Journal Of Energy Research, 35:312-320, 2011. </p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
Changed the value in the real expressions setting the convective resistance. Taco suitabale version of the function is used. <br/>
Additionally, RCondGro_val is added to the convective resistance and removed in the internalresistances model to avoid series coupling of resistances in TACO. 
</li>
<li>
March 7, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
February 28, 2022, by Massimo Cimmino:<br/>
Removed <code>printDebug</code> parameter from call to
<a href=\"modelica://IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube\">
IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1582\">IDEAS, #1582</a>.
</li>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Updated documentation following major changes to the IDEAS.Fluid.HeatExchangers.Ground package.
Additionally, implemented a partial InternalHex model.
</li>
<li>
June 18, 2014, by Michael Wetter:<br/>
Added initialization for temperatures and derivatives of <code>capFil1</code>
and <code>capFil2</code> to avoid a warning during translation.
</li>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused parameters <code>B0</code> and <code>B1</code>.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation, added comments, replaced
<code>HeatTransfer.Windows.BaseClasses.ThermalConductor</code>
with resistance models from the Modelica Standard Library.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, initialScale=0.1)));
end InternalHEXOneUTube;

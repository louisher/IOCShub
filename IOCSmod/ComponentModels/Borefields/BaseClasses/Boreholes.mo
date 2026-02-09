within IOCSmod.ComponentModels.Borefields.BaseClasses;
package Boreholes "Package with borehole heat exchangers (copied from IDEAS (taco) and adapted such that series connection of thermal resistances between capacitances is avoided in borehole model"
extends Modelica.Icons.VariantsPackage;

  model OneUTube "Single U-tube borehole heat exchanger"
    extends
      IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole;

    IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
      intHex[nSeg](
      redeclare each final package Medium = Medium,
      each final hSeg=borFieDat.conDat.hBor/nSeg,
      each final from_dp1=from_dp,
      each final from_dp2=from_dp,
      each final linearizeFlowResistance1=linearizeFlowResistance,
      each final linearizeFlowResistance2=linearizeFlowResistance,
      each final deltaM1=deltaM,
      each final deltaM2=deltaM,
      each final energyDynamics=energyDynamics,
      each final dynFil=dynFil,
      each final mSenFac=mSenFac,
      final dp1_nominal={if i == 1 then dp_nominal else 0 for i in 1:nSeg},
      each final dp2_nominal=0,
      each final m1_flow_nominal=m_flow_nominal,
      each final m2_flow_nominal=m_flow_nominal,
      each final borFieDat=borFieDat,
      each final allowFlowReversal1=allowFlowReversal,
      each final allowFlowReversal2=allowFlowReversal,
      each final show_T=show_T,
      each final p1_start=p_start,
      each final p2_start=p_start,
      final TFlu_start=TFlu_start,
      final TGro_start=TGro_start) "Borehole segments"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  equation
    connect(port_a, intHex[1].port_a1) annotation (Line(
        points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,6},{-10,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_b, intHex[1].port_b2) annotation (Line(
        points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-6},{
            -10,-6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(intHex[nSeg].port_b1, intHex[nSeg].port_a2)
      annotation (Line(
        points={{10,6},{20,6},{20,-6},{10,-6}},
        color={0,127,255},
        smooth=Smooth.None));
    for i in 1:nSeg - 1 loop
      connect(intHex[i].port_b1, intHex[i + 1].port_a1) annotation (Line(
          points={{10,6},{10,20},{-10,20},{-10,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(intHex[i].port_a2, intHex[i + 1].port_b2) annotation (Line(
          points={{10,-6},{10,-20},{-10,-20},{-10,-6}},
          color={0,127,255},
          smooth=Smooth.None));
    end for;
    connect(intHex.port_wall, port_wall)
      annotation (Line(points={{0,10},{0,10},{0,100}}, color={191,0,0}));
    annotation (
      defaultComponentName="borHol",
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.5), graphics={
          Rectangle(
            extent={{56,88},{48,-92}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-52,-92},{-44,88}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,-84},{56,-92}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.5), graphics={Text(
            extent={{60,72},{84,58}},
            textColor={0,0,255},
            textString="")}),
      Documentation(info="<html>
<p>
Model of a single U-tube borehole heat exchanger. 
The borehole heat exchanger is vertically discretized into
<i>n<sub>seg</sub></i> elements of height
<i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
Each segment contains a model for the heat transfer in the borehole, 
with a uniform borehole wall boundary temperature given by the
<code>port_wall</code> port.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer
coefficient that depends on the fluid velocity, a heat resistance between the
two pipes, and a heat resistance between the pipes and the borehole wall.
The heat capacity of the fluid and the heat capacity of the grout are taken
into account. The vertical heat flow is assumed to be zero.
</p>
</html>",   revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
Changed the InternalHexOneUTube model to the version where resistances in series are avoided and a taco-proof calculation of the convective resistance is used.
</li>
<li>
July 2018, by Alex Laferri&egrave;re:<br/>
Following major changes to the structure of the IDEAS.Fluid.HeatExchangers.Ground package,
the documentation has been changed to reflect the new role of this model.
Additionally, this model now extends a partial borehole model.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
  end OneUTube;

  model TwoUTube "Double U-tube borehole heat exchanger"
    extends
      IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole;

    IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXTwoUTube
      intHex[nSeg](
      redeclare each final package Medium = Medium,
      each final borFieDat=borFieDat,
      each final hSeg=borFieDat.conDat.hBor/nSeg,
      final dp1_nominal={if i == 1 and borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then dp_nominal elseif i == 1 and borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries
           then dp_nominal/2 else 0 for i in 1:nSeg},
      final dp3_nominal={if i == 1 and borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then dp_nominal elseif i == 1 and borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries
           then dp_nominal/2 else 0 for i in 1:nSeg},
      each final dp2_nominal=0,
      each final dp4_nominal=0,
      each final show_T=show_T,
      each final energyDynamics=energyDynamics,
      each final m1_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then m_flow_nominal/2 else m_flow_nominal,
      each final m2_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then m_flow_nominal/2 else m_flow_nominal,
      each final m3_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then m_flow_nominal/2 else m_flow_nominal,
      each final m4_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then m_flow_nominal/2 else m_flow_nominal,
      each final m1_flow_small=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,

      each final m2_flow_small=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,

      each final m3_flow_small=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,

      each final m4_flow_small=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,

      each final dynFil=dynFil,
      each final mSenFac=mSenFac,
      each final allowFlowReversal1=allowFlowReversal,
      each final allowFlowReversal2=allowFlowReversal,
      each final allowFlowReversal3=allowFlowReversal,
      each final allowFlowReversal4=allowFlowReversal,
      each final from_dp1=from_dp,
      each final linearizeFlowResistance1=linearizeFlowResistance,
      each final deltaM1=deltaM,
      each final from_dp2=from_dp,
      each final linearizeFlowResistance2=linearizeFlowResistance,
      each final deltaM2=deltaM,
      each final from_dp3=from_dp,
      each final linearizeFlowResistance3=linearizeFlowResistance,
      each final deltaM3=deltaM,
      each final from_dp4=from_dp,
      each final linearizeFlowResistance4=linearizeFlowResistance,
      each final deltaM4=deltaM,
      each final p1_start=p_start,
      each final p2_start=p_start,
      each final p3_start=p_start,
      each final p4_start=p_start,
      final TFlu_start=TFlu_start,
      final TGro_start=TGro_start) "Discretized borehole segments"
      annotation (Placement(transformation(extent={{-10,-30},{10,10}})));

  equation
    // Couple borehole port_a and port_b to first borehole segment.
    connect(port_a, intHex[1].port_a1) annotation (Line(
        points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,6},{-10,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_b, intHex[1].port_b4) annotation (Line(
        points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-27},
            {-10,-27}},
        color={0,127,255},
        smooth=Smooth.None));
    if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel then
      // 2U-tube in parallel: couple both U-tube to each other.
      connect(port_a, intHex[1].port_a3) annotation (Line(
          points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,-16.4},{-10,-16.4}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(port_b, intHex[1].port_b2) annotation (Line(
          points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-4},
              {-10,-4}},
          color={0,127,255},
          smooth=Smooth.None));
    elseif borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries then
      // 2U-tube in serie: couple both U-tube to each other.
      connect(intHex[1].port_b2, intHex[1].port_a3) annotation (Line(
          points={{-10,-4},{-24,-4},{-24,-16},{-18,-16},{-18,-16.4},{-10,-16.4}},
          color={0,127,255},
          smooth=Smooth.None));
    end if;

    // Couple each layer to the next one
    for i in 1:nSeg - 1 loop
      connect(intHex[i].port_b1, intHex[i + 1].port_a1) annotation (Line(
          points={{10,6},{10,10},{-10,10},{-10,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(intHex[i].port_a2, intHex[i + 1].port_b2) annotation (Line(
          points={{10,-4},{10,0},{-10,0},{-10,-4}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(intHex[i].port_b3, intHex[i + 1].port_a3) annotation (Line(
          points={{10,-16.2},{10,-12},{-10,-12},{-10,-16.4}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(intHex[i].port_a4, intHex[i + 1].port_b4) annotation (Line(
          points={{10,-26},{10,-22},{-10,-22},{-10,-27}},
          color={0,127,255},
          smooth=Smooth.None));
    end for;

    // Close U-tube at bottom layer
    connect(intHex[nSeg].port_b1, intHex[nSeg].port_a2)
      annotation (Line(
        points={{10,6},{16,6},{16,-4},{10,-4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(intHex[nSeg].port_b3, intHex[nSeg].port_a4)
      annotation (Line(
        points={{10,-16.2},{14,-16.2},{14,-16},{18,-16},{18,-26},{10,-26}},
        color={0,127,255},
        smooth=Smooth.None));

    connect(intHex.port_wall, port_wall)
      annotation (Line(points={{0,10},{0,10},{0,100}}, color={191,0,0}));

    annotation (
      defaultComponentName="borHol",
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.5), graphics={
          Rectangle(
            extent={{58,88},{50,-92}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-52,-92},{-44,88}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,-84},{56,-92}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{22,88},{14,-92}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-10,88},{-18,-92}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.5), graphics={Text(
            extent={{60,72},{84,58}},
            textColor={0,0,255},
            textString=""), Text(
            extent={{50,-32},{90,-38}},
            textColor={0,0,255},
            textString="")}),
      Documentation(info="<html>
<p>
Model of a double U-tube borehole heat exchanger. 
The borehole heat exchanger is vertically discretized into
<i>n<sub>seg</sub></i> elements of height
<i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
Each segment contains a model for the heat transfer in the borehole, 
with a uniform borehole wall boundary temperature given by the
<code>port_wall</code> port.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer
coefficient that depends on the fluid velocity, a heat resistance between each
pair of pipes, and a heat resistance between the pipes and the borehole wall.
The heat capacity of the fluid and the heat capacity of the grout are taken
into account. The vertical heat flow is assumed to be zero. 
</p>
</html>",   revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
Changed the InternalHexTwoUTube model to the version where resistances in series are avoided and a taco-proof calculation of the convective resistance is used.
</li>
<li>
July 2018, by Alex Laferri&egrave;re:<br/>
Following major changes to the structure of the IDEAS.Fluid.HeatExchangers.Ground package,
the documentation has been changed to reflect the new role of this model.
Additionally, this model now extends a partial borehole model.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
  end TwoUTube;

  package BaseClasses
    model InternalHEXOneUTube
      "Internal heat exchanger of a borehole for a single U-tube configuration"
      extends
        IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX;
      extends IDEAS.Fluid.Interfaces.FourPortHeatMassExchanger(
        redeclare final package Medium1 = Medium,
        redeclare final package Medium2 = Medium,
        T1_start=TFlu_start,
        T2_start=TFlu_start,
        final tau1=VTubSeg*rho1_nominal/m1_flow_nominal,
        final tau2=VTubSeg*rho2_nominal/m2_flow_nominal,
        redeclare final IDEAS.Fluid.MixingVolumes.MixingVolume vol1(
          final energyDynamics=energyDynamics,
          final massDynamics=energyDynamics,
          final prescribedHeatFlowRate=false,
          final m_flow_small=m1_flow_small,
          final V=VTubSeg,
          final mSenFac=mSenFac),
        redeclare final IDEAS.Fluid.MixingVolumes.MixingVolume vol2(
          final energyDynamics=energyDynamics,
          final massDynamics=energyDynamics,
          final prescribedHeatFlowRate=false,
          final m_flow_small=m2_flow_small,
          final V=VTubSeg,
          final mSenFac=mSenFac));

    protected
      parameter Real Rgg_val(fixed=false) "Thermal resistance between the two grout zones";

    public
      Modelica.Blocks.Sources.RealExpression RVol1(y=
        IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
          hSeg=hSeg,
          rTub=borFieDat.conDat.rTub,
          eTub=borFieDat.conDat.eTub,
          kMed=kMed,
          muMed=muMed,
          cpMed=cpMed,
          m_flow=m1_flow,
          m_flow_nominal=m1_flow_nominal) + RCondGro_val)
        "Convective and thermal resistance at fluid 1"
        annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
      Modelica.Blocks.Sources.RealExpression RVol2(y=
        IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
          hSeg=hSeg,
          rTub=borFieDat.conDat.rTub,
          eTub=borFieDat.conDat.eTub,
          kMed=kMed,
          muMed=muMed,
          cpMed=cpMed,
          m_flow=m2_flow,
          m_flow_nominal=m2_flow_nominal) + RCondGro_val)
        "Convective and thermal resistance at fluid 2"
        annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));

      IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesOneUTube
        intResUTub(
        dynFil=dynFil,
        hSeg=hSeg,
        energyDynamics=energyDynamics,
        Rgb_val=Rgb_val,
        Rgg_val=Rgg_val,
        RCondGro_val=RCondGro_val,
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
    initial equation
      (x,Rgb_val,Rgg_val,RCondGro_val) =
        IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesOneUTube(
        hSeg=hSeg,
        rBor=borFieDat.conDat.rBor,
        rTub=borFieDat.conDat.rTub,
        eTub=borFieDat.conDat.eTub,
        sha=borFieDat.conDat.xC,
        kFil=borFieDat.filDat.kFil,
        kSoi=borFieDat.soiDat.kSoi,
        kTub=borFieDat.conDat.kTub,
        use_Rb=borFieDat.conDat.use_Rb,
        Rb=borFieDat.conDat.Rb,
        kMed=kMed,
        muMed=muMed,
        cpMed=cpMed,
        m_flow_nominal=m1_flow_nominal);

    equation
        assert(borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
      "This model should be used for single U-type borefield, not double U-type.
  Check that the conDat record has been correctly parametrized");
      connect(RVol2.y, RConv2.Rc) annotation (Line(points={{-79,-8},{-60,-8},{-40,
              -8},{-40,-28},{-12,-28}},
                                    color={0,0,127}));
      connect(RVol1.y, RConv1.Rc) annotation (Line(points={{-79,8},{-40,8},{-40,28},
              {-12,28}}, color={0,0,127}));
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
<p>
Model for the heat transfer between the fluid and within the borehole filling
for a single borehole segment.
This model computes the dynamic response of the fluid in the tubes,
the heat transfer between the fluid and the borehole filling,
and the heat storage within the fluid and the borehole filling.
</p>
<p>
This model computes the different thermal resistances present
in a single-U-tube borehole using the method of Bauer et al. (2011)
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
</html>",     revisions="<html>
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
        Diagram(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
        graphics));
    end InternalHEXOneUTube;

    model InternalHEXTwoUTube
      "Internal heat exchanger of a borehole for a double U-tube configuration. In loop 1, fluid 1 streams from a1 to b1 and comes back from a2 to b2. In loop 2: fluid 2 streams from a3 to b3 and comes back from a4 to b4."

      extends
        IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX;
      extends IDEAS.Fluid.Interfaces.EightPortHeatMassExchanger(
        redeclare final package Medium1 = Medium,
        redeclare final package Medium2 = Medium,
        redeclare final package Medium3 = Medium,
        redeclare final package Medium4 = Medium,
        T1_start=TFlu_start,
        T2_start=TFlu_start,
        T3_start=TFlu_start,
        T4_start=TFlu_start,
        final tau1=VTubSeg*rho1_nominal/m1_flow_nominal,
        final tau2=VTubSeg*rho2_nominal/m2_flow_nominal,
        final tau3=VTubSeg*rho3_nominal/m3_flow_nominal,
        final tau4=VTubSeg*rho4_nominal/m4_flow_nominal,
        vol1(
          final energyDynamics=energyDynamics,
          final massDynamics=energyDynamics,
          final prescribedHeatFlowRate=false,
          final allowFlowReversal=allowFlowReversal1,
          final m_flow_small=m1_flow_small,
          final V=VTubSeg,
          final mSenFac=mSenFac),
        vol2(
          final energyDynamics=energyDynamics,
          final massDynamics=energyDynamics,
          final prescribedHeatFlowRate=false,
          final m_flow_small=m2_flow_small,
          final V=VTubSeg,
          final mSenFac=mSenFac),
        vol3(
          final energyDynamics=energyDynamics,
          final massDynamics=energyDynamics,
          final prescribedHeatFlowRate=false,
          final allowFlowReversal=allowFlowReversal3,
          final m_flow_small=m3_flow_small,
          final V=VTubSeg,
          final mSenFac=mSenFac),
        vol4(
          final energyDynamics=energyDynamics,
          final massDynamics=energyDynamics,
          final prescribedHeatFlowRate=false,
          final m_flow_small=m4_flow_small,
          final V=VTubSeg,
          final mSenFac=mSenFac));

      Modelica.Blocks.Sources.RealExpression RVol1(y=
            IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
            hSeg=hSeg,
            rTub=borFieDat.conDat.rTub,
            eTub=borFieDat.conDat.eTub,
            kMed=kMed,
            muMed=muMed,
            cpMed=cpMed,
            m_flow=m1_flow,
            m_flow_nominal=m1_flow_nominal) + RCondGro_val)
        "Convective and thermal resistance at fluid 1"
        annotation (Placement(transformation(extent={{-16,56},{-30,72}})));
      Modelica.Blocks.Sources.RealExpression RVol2(y=
            IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
            hSeg=hSeg,
            rTub=borFieDat.conDat.rTub,
            eTub=borFieDat.conDat.eTub,
            kMed=kMed,
            muMed=muMed,
            cpMed=cpMed,
            m_flow=m2_flow,
            m_flow_nominal=m2_flow_nominal) + RCondGro_val)
        "Convective and thermal resistance at fluid 2"
        annotation (Placement(transformation(extent={{88,-8},{72,-26}})));
      Modelica.Blocks.Sources.RealExpression RVol3(y=
            IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
            hSeg=hSeg,
            rTub=borFieDat.conDat.rTub,
            eTub=borFieDat.conDat.eTub,
            kMed=kMed,
            muMed=muMed,
            cpMed=cpMed,
            m_flow=m3_flow,
            m_flow_nominal=m3_flow_nominal) + RCondGro_val)
        "Convective and thermal resistance at fluid 1"
        annotation (Placement(transformation(extent={{-12,-60},{-26,-76}})));

      Modelica.Blocks.Sources.RealExpression RVol4(y=
            IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
            hSeg=hSeg,
            rTub=borFieDat.conDat.rTub,
            eTub=borFieDat.conDat.eTub,
            kMed=kMed,
            muMed=muMed,
            cpMed=cpMed,
            m_flow=m1_flow,
            m_flow_nominal=m4_flow_nominal) + RCondGro_val)
        "Convective and thermal resistance at fluid 1"
        annotation (Placement(transformation(extent={{-68,12},{-54,28}})));
      IOCSmod.ComponentModels.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube
        intRes2UTub(
        hSeg=hSeg,
        borFieDat=borFieDat,
        Rgb_val=Rgb_val,
        Rgg1_val=Rgg1_val,
        Rgg2_val=Rgg2_val,
        RCondGro_val=RCondGro_val,
        dynFil=dynFil,
        energyDynamics=energyDynamics,
        T_start=TGro_start)
        "Internal resistances for a double U-tube configuration"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv1
        "Pipe convective resistance" annotation (Placement(transformation(
            extent={{-8,-8},{8,8}},
            rotation=90,
            origin={0,46})));

      Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv2
        "Pipe convective resistance" annotation (Placement(transformation(
            extent={{8,-8},{-8,8}},
            rotation=180,
            origin={34,0})));
      Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv3
        "Pipe convective resistance" annotation (Placement(transformation(
            extent={{8,-8},{-8,8}},
            rotation=90,
            origin={0,-32})));
      Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor RConv4
        "Pipe convective resistance" annotation (Placement(transformation(
            extent={{-8,8},{8,-8}},
            rotation=180,
            origin={-34,0})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
        annotation (Placement(transformation(extent={{-10,90},{10,110}})));

    protected
      parameter Real Rgg1_val(fixed=false);
      parameter Real Rgg2_val(fixed=false);

    initial equation
      (x,Rgb_val,Rgg1_val,Rgg2_val,RCondGro_val) =
        IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube(
        hSeg=hSeg,
        rBor=borFieDat.conDat.rBor,
        rTub=borFieDat.conDat.rTub,
        eTub=borFieDat.conDat.eTub,
        sha=borFieDat.conDat.xC,
        kFil=borFieDat.filDat.kFil,
        kSoi=borFieDat.soiDat.kSoi,
        kTub=borFieDat.conDat.kTub,
        use_Rb=borFieDat.conDat.use_Rb,
        Rb=borFieDat.conDat.Rb,
        kMed=kMed,
        muMed=muMed,
        cpMed=cpMed,
        m_flow_nominal=m1_flow_nominal);

    equation
      assert(borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         or borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries,
        "This model should be used for double U-type borefield, not single U-type.
  Check that the conDat record has been correctly parametrized");
      connect(RVol1.y, RConv1.Rc) annotation (Line(
          points={{-30.7,64},{-34,64},{-34,46},{-8,46}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(RConv1.fluid, vol1.heatPort) annotation (Line(
          points={{4.44089e-016,54},{-14,54},{-14,70},{-10,70}},
          color={191,0,0},
          smooth=Smooth.None));

      connect(RConv1.solid, intRes2UTub.port_1)
        annotation (Line(points={{0,38},{0,24},{0,10}}, color={191,0,0}));
      connect(RConv2.fluid, vol2.heatPort)
        annotation (Line(points={{42,0},{46,0},{50,0}}, color={191,0,0}));
      connect(RConv2.solid, intRes2UTub.port_2)
        annotation (Line(points={{26,0},{18,0},{10,0}}, color={191,0,0}));
      connect(RConv3.fluid, vol3.heatPort) annotation (Line(points={{0,-40},{-14,-40},
              {-14,-60},{-10,-60}}, color={191,0,0}));
      connect(RConv3.solid, intRes2UTub.port_3)
        annotation (Line(points={{0,-24},{0,-10}}, color={191,0,0}));
      connect(RConv4.fluid, vol4.heatPort)
        annotation (Line(points={{-42,0},{-46,0},{-50,0}}, color={191,0,0}));
      connect(RConv4.solid, intRes2UTub.port_4)
        annotation (Line(points={{-26,0},{-18,0},{-10,0}}, color={191,0,0}));
      connect(RVol4.y, RConv4.Rc)
        annotation (Line(points={{-53.3,20},{-34,20},{-34,8}}, color={0,0,127}));
      connect(RVol3.y, RConv3.Rc) annotation (Line(points={{-26.7,-68},{-30,-68},{-30,
              -32},{-8,-32}}, color={0,0,127}));
      connect(RVol2.y, RConv2.Rc)
        annotation (Line(points={{71.2,-17},{34,-17},{34,-8}}, color={0,0,127}));
      connect(intRes2UTub.port_wall, port_wall) annotation (Line(points={{0,0},{6,0},
              {6,20},{20,20},{20,100},{0,100}}, color={191,0,0}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
        Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
            graphics={
            Rectangle(
              extent={{98,74},{-94,86}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{96,24},{-96,36}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{100,-38},{-92,-26}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{94,-88},{-98,-76}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
Model for the heat transfer between the fluid and within the borehole filling.
This model computes the dynamic response of the fluid in the tubes,
the heat transfer between the fluid and the borehole filling,
and the heat storage within the fluid and the borehole filling.
</p>
<p>
This model computes the different thermal resistances present
in a single-U-tube borehole using the method of Bauer et al. (2011)
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
</html>",     revisions="<html>
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
<a href=\"modelica://IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube\">
IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.internalResistancesTwoUTube</a>.<br/>
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
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics));
    end InternalHEXTwoUTube;

    model InternalResistancesOneUTube
      "Internal resistance model for single U-tube borehole segments."
      extends
        IDEAS.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalResistances;

      parameter Modelica.Units.SI.ThermalResistance Rgg_val
        "Thermal resistance between the two grout zones";
      parameter Modelica.Units.SI.HeatCapacity Co_fil=borFieDat.filDat.dFil*
          borFieDat.filDat.cFil*hSeg*Modelica.Constants.pi*(borFieDat.conDat.rBor^2
           - 2*borFieDat.conDat.rTub^2)
        "Heat capacity of the whole filling material";

      Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
        "Grout thermal resistance" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-30,30})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(
        C=Co_fil/2,
        T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
        der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
        if dynFil
        "Heat capacity of the filling material" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-70,50})));
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(
        C=Co_fil/2,
        T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
        der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
        if dynFil
        "Heat capacity of the filling material" annotation (Placement(
            transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={70,50})));
      Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg(R=Rgg_val)
        "Grout thermal resistance" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,50})));

      Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
        "Grout thermal resistance" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,0})));

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
<p>
This model simulates the internal thermal resistance network of a borehole segment in
the case of a single U-tube borehole using the method of Bauer et al. (2011) 
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
</html>",     revisions="<html>
<ul>
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
</html>"),     Icon(graphics={
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
</html>",     revisions="<html>
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

    package Functions "Package with functions for evaluation of borehole thermal resistances"
    extends Modelica.Icons.VariantsPackage;

      function convectionResistanceCircularPipe
        "Thermal resistance from the fluid in pipes and the grout zones (Bauer et al. 2011) with modification to avoid RegNoPower function --> commented"
        extends Modelica.Icons.Function;

        // Geometry of the borehole
        input Modelica.Units.SI.Height hSeg "Height of the element";
        input Modelica.Units.SI.Radius rTub "Tube radius";
        input Modelica.Units.SI.Length eTub "Tube thickness";
        // thermal properties
        input Modelica.Units.SI.ThermalConductivity kMed
          "Thermal conductivity of the fluid";
        input Modelica.Units.SI.DynamicViscosity muMed
          "Dynamic viscosity of the fluid";
        input Modelica.Units.SI.SpecificHeatCapacity cpMed
          "Specific heat capacity of the fluid";
        input Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
        input Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";

        // Outputs
        output Modelica.Units.SI.ThermalResistance RFluPip
          "Convection resistance (or conduction in fluid if no mass flow)";

      protected
        parameter Modelica.Units.SI.Radius rTub_in=rTub - eTub "Pipe inner radius";
        Modelica.Units.SI.CoefficientOfHeatTransfer h
          "Convective heat transfer coefficient of the fluid";

        Real k(unit="s/kg")
          "Coefficient used in the computation of the convective heat transfer coefficient";
        Modelica.Units.SI.MassFlowRate m_flow_abs=
            IDEAS.Utilities.Math.Functions.spliceFunction(
            m_flow,
            -m_flow,
            m_flow,
            m_flow_nominal/30);
        Real Re "Reynolds number";
        Real NuTurb "Nusselt at Re=2400";
        Real Nu "Nusselt";

      algorithm
        // Convection resistance and Reynolds number
        k := 2/(muMed*Modelica.Constants.pi*rTub_in);
        Re := m_flow_abs*k;

        if Re>=2400 then
          // Turbulent, fully-developped flow in a smooth circular pipe with the
          // Dittus-Boelter correlation: h = 0.023*k_f*Re*Pr/(2*rTub)
          // Re = rho*v*DTub / mue_f
          //    = m_flow/(pi r^2) * DTub/mue_f = 2*m_flow / ( mue*pi*rTub)
          Nu := 0.023*(cpMed*muMed/kMed)^(0.35)*Re^(0.8);
      //     Nu := 0.023*(cpMed*muMed/kMed)^(0.35)*
      //       IDEAS.Utilities.Math.Functions.regNonZeroPower(
      //         x=Re,
      //         n=0.8,
      //         delta=0.01*m_flow_nominal*k);
        else
          // Laminar, fully-developped flow in a smooth circular pipe with uniform
          // imposed temperature: Nu=3.66 for Re<=2300. For 2300<Re<2400, a smooth
          // transition is created with the splice function.
          NuTurb := 0.023*(cpMed*muMed/kMed)^(0.35)*(2400)^(0.8);
          Nu := IDEAS.Utilities.Math.Functions.spliceFunction(NuTurb,3.66,Re-(2300+2400)/2,((2300+2400)/2)-2300);
        end if;
        h := Nu*kMed/(2*rTub_in);

        RFluPip := 1/(2*Modelica.Constants.pi*rTub_in*hSeg*h);

        annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment 
with heigth <i>h<sub>Seg</sub></i> using correlations suggested by Bergman et al. (2011).
</p>
<p>
If the flow is laminar (<i>Re &le; 2300</i>, with <i>Re</i> being the Reynolds number of the flow),
the Nusselt number of the flow is assumed to be constant at 3.66. If the flow is turbulent (<i>Re &gt; 2300</i>),
the correlation of Dittus-Boelter is used to find the convection heat transfer coefficient as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Nu = 0.023 &nbsp; Re<sup>0.8</sup> &nbsp; Pr<sup>n</sup>,
</p>
<p>
where <i>Nu</i> is the Nusselt number and 
<i>Pr</i> is the Prandlt number.
A value of <i>n=0.35</i> is used, as the reference uses <i>n=0.4</i> for heating and 
<i>n=0.3</i> for cooling. To ensure that the function is continuously differentiable,
a smooth transition between the laminar and turbulent values is created for the
range <i>2300 &lt; Re &lt; 2400</i>.
</p>
<h4>References</h4>
<p>
Bergman, T. L., Incropera, F. P., DeWitt, D. P., &amp; Lavine, A. S. (2011). <i>Fundamentals of heat and mass
transfer</i> (7th ed.). New York: John Wiley &amp; Sons.
</p>
</html>",       revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Added laminar flow and smooth laminar-turbulent transition.
Revised documentation.
</li>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused input <code>rBor</code>.
Revised documentation.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation. 
Changed <code>cpFluid</code> to <code>cpMed</code> to use consistent notation.
Added regularization for computation of convective heat transfer coefficient to
avoid an event and a non-differentiability.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
      end convectionResistanceCircularPipe;
    end Functions;
  end BaseClasses;
end Boreholes;

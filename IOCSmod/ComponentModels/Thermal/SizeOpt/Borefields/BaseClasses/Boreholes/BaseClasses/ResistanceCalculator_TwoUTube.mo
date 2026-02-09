within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses;
model ResistanceCalculator_TwoUTube
  "Model to calculate the absolute thermal resistances inside the borehole using the multipole method"

  parameter Real hSeg_dummy=100;

  parameter IDEAS.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat "Borefield data";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpMed "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.ThermalConductivity kMed "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity muMed "Dynamic viscosity of the fluid";
  parameter Modelica.Units.SI.ThermalResistance Rgb_val=
   IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Rgb_TwoUTube(
     hSeg=hSeg_dummy,
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
     m_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
          then borFieDat.conDat.mBor_flow_nominal/2 else borFieDat.conDat.mBor_flow_nominal)*hSeg_dummy
                        "Thermal resistance between grout zone and borehole wall" annotation(Evaluate=true);

  parameter Modelica.Units.SI.ThermalResistance RCondGro_val=
    IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.RCondGro_TwoUTube(
      hSeg=hSeg_dummy,
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
      m_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then borFieDat.conDat.mBor_flow_nominal/2 else borFieDat.conDat.mBor_flow_nominal)*hSeg_dummy
    "Thermal resistance between: pipe wall to capacity in grout" annotation(Evaluate=true);

  parameter Modelica.Units.SI.ThermalResistance Rgg1_val=
    IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Rgg1_TwoUTube(
      hSeg=hSeg_dummy,
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
      m_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
           then borFieDat.conDat.mBor_flow_nominal/2 else borFieDat.conDat.mBor_flow_nominal)*hSeg_dummy
         "Thermal resistance between two neightbouring grout capacities, as defined by Bauer et al (2010)" annotation(Evaluate=true);
  parameter Modelica.Units.SI.ThermalResistance Rgg2_val=
     IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Rgg2_TwoUTube(
     hSeg=hSeg_dummy,
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
     m_flow_nominal=if borFieDat.conDat.borCon == IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
          then borFieDat.conDat.mBor_flow_nominal/2 else borFieDat.conDat.mBor_flow_nominal)*hSeg_dummy
    "Thermal resistance between two  grout capacities opposite to each other, as defined by Bauer et al (2010)" annotation(Evaluate=true);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={95,95,95},
          lineThickness=1),
        Line(
          points={{-82,0},{-60,60},{-40,0},{-20,58},{-2,0},{20,60},{40,0}},
          color={0,0,255},
          thickness=1),
        Line(
          points={{40,0},{60,60},{80,0}},
          color={0,0,255},
          thickness=1),
        Text(
          extent={{-48,-4},{40,-80}},
          textColor={0,0,255},
          textString="?"),
        Text(
          extent={{-91,151},{71,109}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model calculates the values of the thermal resistances in a borehole (according to the multipole method. It calculates these values for a dummy segment lengt hSeg_dummy. Afterwards the calculated parameter values are multiplied by the value of hSeg_dummy to allow to reconvert these resistance values to other segment lengths by deviding these values by the actual segment lengths. </p>
</html>", revisions="<html>
<ul>
<li>July 24, 2025, by Louis Hermans:<br>Initial implementation. </li>
</ul>
</html>"));
end ResistanceCalculator_TwoUTube;

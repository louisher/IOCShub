within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses;
package HeatTransfer "Package with ground heat transfer models"
extends Modelica.Icons.VariantsPackage;

  model GroundTemperatureResponseFinal

    parameter Integer nSteps=lifetime*nStepsYear "Number of borefield steps, intialized at lifetime*nStepsYear";
    parameter Integer lifetime=40 "Borefield lifetime in years";
    parameter Integer nStepsYear=12 "Number of steps in a year for borefield temperature calculation";

    parameter input Real H "Borefield depth";

    Modelica.Blocks.Interfaces.RealInput QBor_flow(unit="W")
      "Heat flow from all boreholes combined (positive if heat from fluid into soil)"
      annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));

    Modelica.Blocks.Interfaces.RealOutput delTBor[nStepsYear]
      "Temperature difference in last year of operation of borefield: current borehole wall temperature minus initial borehole wall temperature"
      annotation (Placement(transformation(extent={{100,-12},{126,14}}),
          iconTransformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput delTfExt[nStepsYear]
      "Temperature difference in last year of operation of borefield: current borefield peak extraction fluid temperature minus initial borehole wall temperature"
      annotation (Placement(transformation(extent={{100,28},{126,54}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput delTfInj[nStepsYear]
      "Temperature difference in last year of operation of borefield: current borefield peak injection fluid temperature minus initial borehole wall temperature"
      annotation (Placement(transformation(extent={{100,-54},{126,-28}}),
          iconTransformation(extent={{100,-50},{120,-30}})));

    Real lastInterval "Value that is 1 in last hour of the year";

    Modelica.Units.SI.HeatFlowRate QBorExt "Smooth approximation of extraction heat flow of the borefield (negative)";
    Modelica.Units.SI.HeatFlowRate QBorInj "Smooth approximation of injection heat flow of the borefield (positive)";
    constant Real b = 5 " Transition parameter for smooth min/max of QBor_flow";

    Modelica.Blocks.Sources.RealExpression QBorStep[nStepsYear](y={(if ((time >= (
          i - 1)*tStep) and (time <= i*tStep)) then QBor_flow else 0) for i in 1:
          nStepsYear}) "Vector of the borefield loads in each borefield time step"
      annotation (Placement(transformation(extent={{10,50},{30,70}})));
    Modelica.Blocks.Continuous.Integrator[nStepsYear] QBorStepAvg(k=1/tStep) "Vector of the running average borefield load in each borefield time step"
      annotation (Placement(transformation(extent={{50,50},{70,70}})));

    Modelica.Blocks.Sources.RealExpression QBorExtStep[nStepsYear](y={(if ((time >=
          (i - 1)*tStep) and (time <= i*tStep)) then QBorExt else 0) for i in 1:
          nStepsYear}) "Vector of the borefield extraction loads in each borefield time step"
      annotation (Placement(transformation(extent={{10,20},{30,40}})));
    Modelica.Blocks.Continuous.Integrator[nStepsYear] QBorExtStepAvg(k=1/tStep) "Vector of the running average borefield extraction load in each borefield time step"
      annotation (Placement(transformation(extent={{50,20},{70,40}})));

    Modelica.Blocks.Sources.RealExpression QBorInjStep[nStepsYear](y={(if ((time >=
          (i - 1)*tStep) and (time <= i*tStep)) then QBorInj else 0) for i in 1:
          nStepsYear}) "Vector of the borefield injection loads in each borefield time step"
      annotation (Placement(transformation(extent={{10,80},{30,100}})));
    Modelica.Blocks.Continuous.Integrator[nStepsYear] QBorInjStepAvg(k=1/tStep) "Vector of the running average borefield injection load in each borefield time step"
      annotation (Placement(transformation(extent={{50,80},{70,100}})));

    Real QpeakExt;
    Real QpeakInj;
    Modelica.Blocks.Sources.RealExpression QpeakExtExpr
      annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
    Modelica.Blocks.Sources.RealExpression QpeakInjExpr
      annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

   parameter Real Gamma_Constants[7] "A,B,C,D,E,F,G constants of Gamma function";
   parameter Real Xi_Ext_Constants[7] "A,B,C,D,E,F,G constants of the Xi_Ext function";
   parameter Real Xi_Inj_Constants[7] "A,B,C,D,E,F,G constants of the Xi_Inj function)";
   parameter Real Kappa_L3_Constants[nSteps, 7] "A,B,C,D,E,F,G constants of Kappa functions";
    Modelica.Blocks.Sources.RealExpression Gamma(y=(Gamma_Constants[1]*H^4 + Gamma_Constants[2]*H^3 + Gamma_Constants[3]*H^2 + Gamma_Constants[4]*H + Gamma_Constants[5])/(Gamma_Constants[6]*H + Gamma_Constants[7]));
    Modelica.Blocks.Sources.RealExpression Xi_Ext(y=(Xi_Ext_Constants[1]*H^4 + Xi_Ext_Constants[2]*H^3 + Xi_Ext_Constants[3]*H^2 + Xi_Ext_Constants[4]*H + Xi_Ext_Constants[5])/(Xi_Ext_Constants[6]*H + Xi_Ext_Constants[7]));
    Modelica.Blocks.Sources.RealExpression Xi_Inj(y=(Xi_Inj_Constants[1]*H^4 + Xi_Inj_Constants[2]*H^3 + Xi_Inj_Constants[3]*H^2 + Xi_Inj_Constants[4]*H + Xi_Inj_Constants[5])/(Xi_Inj_Constants[6]*H + Xi_Inj_Constants[7]));
    Modelica.Blocks.Sources.RealExpression Kappa_L3[nSteps](y = {
    (Kappa_L3_Constants[i,1]*H^4 + Kappa_L3_Constants[i,2]*H^3 + Kappa_L3_Constants[i,3]*H^2 + Kappa_L3_Constants[i,4]*H + Kappa_L3_Constants[i,5]) /
    (Kappa_L3_Constants[i,6]*H + Kappa_L3_Constants[i,7]) for i in 1:nSteps});

  protected
      parameter Modelica.Units.SI.Time tStep=8760*3600/nStepsYear
      "Duration of borefield time step in seconds";

  equation
    QBorExt = QBor_flow - QBor_flow * 0.5*(1 + QBor_flow/(sqrt(QBor_flow^2 + b^2)));
    QBorInj = QBor_flow * 0.5*(1 + QBor_flow/(sqrt(QBor_flow^2 + b^2)));
    QpeakExt = QpeakExtExpr.y*lastInterval;
    QpeakInj = QpeakInjExpr.y*lastInterval;

    if time > 8759*3600 then
      lastInterval=1;
       for i in 1:nStepsYear loop
        delTBor[i] = sum(QBorStepAvg[integer(j - nStepsYear*floor((j - 1)/nStepsYear))].y * Kappa_L3[(lifetime-1)*nStepsYear + 1 + i - j].y for j in 1:(lifetime-1)*nStepsYear+i);
        delTfExt[i] = delTBor[i] + QBorExtStepAvg[i - nStepsYear*integer(floor((i -1)/12))].y * Gamma.y + (QpeakExt - QBorExtStepAvg[i - nStepsYear*integer(floor((i - 1)/12))].y) * Xi_Ext.y;
        delTfInj[i] = delTBor[i] + QBorInjStepAvg[i - nStepsYear*integer(floor((i -1)/12))].y * Gamma.y + (QpeakInj - QBorInjStepAvg[i - nStepsYear*integer(floor((i - 1)/12))].y) * Xi_Inj.y;
      end for;
    else
      lastInterval=0;
      for i in 1:nStepsYear loop
        delTBor[i] = 0;
        delTfExt[i] = 0;
        delTfInj[i] = 0;
      end for;

    end if;

    connect(QBorInjStep.y, QBorInjStepAvg.u)
      annotation (Line(points={{31,90},{48,90}}, color={0,0,127}));
    connect(QBorExtStep.y, QBorExtStepAvg.u)
      annotation (Line(points={{31,30},{48,30}}, color={0,0,127}));

    connect(QBorStep.y, QBorStepAvg.u)
      annotation (Line(points={{31,60},{48,60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-100,30},{100,-100}},
            lineColor={0,0,0},
            fillColor={127,127,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-52,30},{-94,-100}},
            lineColor={0,0,0},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-66,-4},{72,-4}},
            color={255,0,0},
            arrow={Arrow.None,Arrow.Filled}),
          Rectangle(
            extent={{-100,30},{-94,-100}},
            lineColor={0,0,0},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-151,147},{149,107}},
            lineColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255},
              textString="%name")}), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>This model calculates the borefield fluid temperature evolution in the last year of operation of the borefield lifetime in function of a depth parameter which is an input parameter (to allow parameter optimization).</p>
<p>The model calculates these temperatures with for timesteps with a duration of tStep (typically a 730h*3600s for L3 approach). The L3 temperature calculation method of GHEtool is used (see paper IOCS applied energy for equations). </p>
<p><br>In this temperature calculation 4 functions are used that depend on the depth of the borefield and the g-function of the borefield (which itself is also dependent on depth):</p>
<ul>
<li>Kappa: To calculate the evolution of the borehole wall temperature (a function has to be defined for each borefield timestep over the entire lifetime of the borefield)</li>
<li>Gamma: To calculate the evolution of the monthly average fluid temperatures for extraction and injection starting from the borehole wall temperature</li>
<li>Xi_Ext, and Xi_Inj: To calculate the peak temperatures for extraction and injection starting from the monthly average fluid temperatures</li>
</ul>
<p><br>This model assumes these function can be estimated using the following formula: (A*H^4 + B*H^3 + C*H^2 + D*H + E) / (F*H + G).</p>
<p>The corresponding values of these constants A, B, C, D, E, F, G have to be provided by the user for the specific borefield configuration using the parameters <span style=\"font-family: Courier New;\">Gamma_Constants, Xi_Ext_Constants, Xi_Inj_Constants, and KappaConstants.</span><span style=\"font-family: Niagara Engraved;\"> </span></p>
<p><br>Note that for Kappa, Kappa[1] should correspond to the kappa value in calculated after one borefield timestep and Kappa[nSteps] should correspond to the kappa value after nSteps borefield time steps. </p>
</html>"));
  end GroundTemperatureResponseFinal;

  model GroundTemperatureResponseContEq
    "Ground temperature response model where the rCel variable is externally calculated and provided through a data record, and the Kappa variable is estimated using an equation."
    extends
      IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseContBase;

     Modelica.Units.SI.HeatFlowRate[groTemResDat.i] QAgg_flow
      "Vector of aggregated loads";
     Modelica.Units.SI.HeatFlowRate[groTemResDat.i] QFace
       "Vector of cell face values of aggregated loads";
    parameter input Modelica.Units.SI.Length H "Borefield depth";

    parameter IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.GroundResponseDataTemplate groTemResDat "Ground response parameters";
    parameter Real Kappa_agg_Constants[groTemResDat.i, 7] "A,B,C,D,E,F,G constants of Kappa_agg functions";
     Modelica.Blocks.Sources.RealExpression Kappa_agg[groTemResDat.i](y = {
    (Kappa_agg_Constants[i,1]*H^4 + Kappa_agg_Constants[i,2]*H^3 + Kappa_agg_Constants[i,3]*H^2 + Kappa_agg_Constants[i,4]*H + Kappa_agg_Constants[i,5]) /
    (Kappa_agg_Constants[i,6]*H + Kappa_agg_Constants[i,7]) for i in 1:groTemResDat.i});

  initial equation
    QAgg_flow = zeros(groTemResDat.i);
    delTBor = 0;

  equation
    delTBor = QAgg_flow[:]*Kappa_agg[:].y;

    // "QUICK" scheme
     QFace[1] = QBor_flow;
     QFace[2] = 0.5*(QAgg_flow[1] + QAgg_flow[2]) - 0.125*(0.5*groTemResDat.rCel.rCel[1] + 0.5*groTemResDat.rCel.rCel[2])^2/groTemResDat.rCel.rCel[1]*((QAgg_flow[2] - QAgg_flow[1])/(0.5*groTemResDat.rCel.rCel[1] + 0.5*groTemResDat.rCel.rCel[2]) - (QAgg_flow[1] - QBor_flow)/(0.5*groTemResDat.rCel.rCel[1]));
     for j in 3:groTemResDat.i loop
       QFace[j] = 0.5*(QAgg_flow[j-1] + QAgg_flow[j]) - 0.125*(0.5*groTemResDat.rCel.rCel[j-1] + 0.5*groTemResDat.rCel.rCel[j])^2/groTemResDat.rCel.rCel[j-1]*((QAgg_flow[j] - QAgg_flow[j-1])/(0.5*groTemResDat.rCel.rCel[j-1] + 0.5*groTemResDat.rCel.rCel[j]) - (QAgg_flow[j-1] - QAgg_flow[j-2])/(0.5*groTemResDat.rCel.rCel[j-1] + 0.5*groTemResDat.rCel.rCel[j-2]));
     end for;
     for j in 1:groTemResDat.i-1 loop
       der(QAgg_flow[j])*groTemResDat.rCel.rCel[j]*tLoaAgg = QFace[j] - QFace[j+1];
     end for;
     der(QAgg_flow[groTemResDat.i]) = 1/(groTemResDat.rCel.rCel[groTemResDat.i]*tLoaAgg)*(QAgg_flow[groTemResDat.i-1]);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-100,30},{100,-100}},
            lineColor={0,0,0},
            fillColor={127,127,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-52,30},{-94,-100}},
            lineColor={0,0,0},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-66,-4},{72,-4}},
            color={255,0,0},
            arrow={Arrow.None,Arrow.Filled}),
          Rectangle(
            extent={{-100,30},{-94,-100}},
            lineColor={0,0,0},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-151,147},{149,107}},
            lineColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255},
              textString="%name")}), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(revisions="<html>
<ul>
<li>
July 24, 2025, by Louis Hermans:<br/>
Add kappa as calculation using a formula for which parameters have to be provided. 
</li>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
</ul>
</html>",   info="<html>
<p>In this model, the default load aggregation scheme of the IBPSA library is made continuous using a QUICK scheme. For more information see the PhD thesis of I. Cupeiro.</p>
<p>Note that is very imporant that the parameter tLoaAgg is set as used to make the rCel and kappa records.</p>
<p>To allow the optimization of the depth. The kappa values have to be made dependent on depth. For this, model assumes each kappa (for each aggregation cell) can be estimated using a function with the following formula: (A*H^4 + B*H^3 + C*H^2 + D*H + E) / (F*H + G).</p>
<p>The corresponding values of these constants A, B, C, D, E, F, G have to be provided by the user for the specific borefield configuration using the parameters Kappa_Constants. </p>
</html>"));
  end GroundTemperatureResponseContEq;
end HeatTransfer;

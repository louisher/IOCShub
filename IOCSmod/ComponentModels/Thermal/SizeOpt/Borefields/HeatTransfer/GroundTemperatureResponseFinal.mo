within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.HeatTransfer;
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

 parameter Real GammaConstants[7] "A,B,C,D,E,F,G constants of Gamma function";
 parameter Real Xi_ExtConstants[7] "A,B,C,D,E,F,G constants of the Xi_Ext function";
 parameter Real Xi_InjConstants[7] "A,B,C,D,E,F,G constants of the Xi_Inj function)";
 parameter Real Kappa_Constants[nSteps, 7] "A,B,C,D,E,F,G constants of Kappa functions";
  Modelica.Blocks.Sources.RealExpression Gamma(y=(GammaConstants[1]*H^4 + GammaConstants[2]*H^3 + GammaConstants[3]*H^2 + GammaConstants[4]*H + GammaConstants[5])/(GammaConstants[6]*H + GammaConstants[7]));
  Modelica.Blocks.Sources.RealExpression Xi_Ext(y=(Xi_ExtConstants[1]*H^4 + Xi_ExtConstants[2]*H^3 + Xi_ExtConstants[3]*H^2 + Xi_ExtConstants[4]*H + Xi_ExtConstants[5])/(Xi_ExtConstants[6]*H + Xi_ExtConstants[7]));
  Modelica.Blocks.Sources.RealExpression Xi_Inj(y=(Xi_InjConstants[1]*H^4 + Xi_InjConstants[2]*H^3 + Xi_InjConstants[3]*H^2 + Xi_InjConstants[4]*H + Xi_InjConstants[5])/(Xi_InjConstants[6]*H + Xi_InjConstants[7]));
  Modelica.Blocks.Sources.RealExpression Kappa[nSteps](y = {
  (Kappa_Constants[i,1]*H^4 + Kappa_Constants[i,2]*H^3 + Kappa_Constants[i,3]*H^2 + Kappa_Constants[i,4]*H + Kappa_Constants[i,5]) /
  (Kappa_Constants[i,6]*H + Kappa_Constants[i,7]) for i in 1:nSteps});

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
      delTBor[i] = sum(QBorStepAvg[integer(j - nStepsYear*floor((j - 1)/nStepsYear))].y * Kappa[(lifetime-1)*nStepsYear-1+i - j + 1].y for j in 1:(lifetime-1)*nStepsYear-1+i);
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
<p>The corresponding values of these constants A, B, C, D, E, F, G have to be provided by the user for the specific borefield configuration using the parameters <span style=\"font-family: Courier New;\">GammaConstants, Xi_ExtConstants, Xi_InjConstants, and KappaConstants.</span><span style=\"font-family: Niagara Engraved;\"> </span></p>
<p><br>Note that for Kappa, Kappa[1] should correspond to the kappa value in calculated after one borefield timestep and Kappa[nSteps] should correspond to the kappa value after nSteps borefield time steps. </p>
</html>"));
end GroundTemperatureResponseFinal;

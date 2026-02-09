within IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer;
model GroundTemperatureResponseContRecord "Ground temperature response model where the rCel and kappa variable are externally calculated and provided through a data record"
  extends
    IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseContBase;

   Modelica.Units.SI.HeatFlowRate[i] QAgg_flow
    "Vector of aggregated loads";
   Modelica.Units.SI.HeatFlowRate[i] QFace
     "Vector of cell face values of aggregated loads";

  parameter Integer i(min=1)=size(kappa.kappa,1)
      "Number of aggregation cells";

  parameter
    IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data.RCelTemplate
    rCel annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  parameter
    IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.Data.KappaTemplate
    kappa annotation (Placement(transformation(extent={{70,-100},{90,-80}})));

initial equation
  QAgg_flow = zeros(i);
  delTBor = 0;

equation
  delTBor = QAgg_flow[:]*kappa.kappa[:];

  // "QUICK" scheme
   QFace[1] = QBor_flow;
   QFace[2] = 0.5*(QAgg_flow[1] + QAgg_flow[2]) - 0.125*(0.5*rCel.rCel[1] + 0.5*rCel.rCel[2])^2/rCel.rCel[1]*((QAgg_flow[2] - QAgg_flow[1])/(0.5*rCel.rCel[1] + 0.5*rCel.rCel[2]) - (QAgg_flow[1] - QBor_flow)/(0.5*rCel.rCel[1]));
   for j in 3:i loop
     QFace[j] = 0.5*(QAgg_flow[j-1] + QAgg_flow[j]) - 0.125*(0.5*rCel.rCel[j-1] + 0.5*rCel.rCel[j])^2/rCel.rCel[j-1]*((QAgg_flow[j] - QAgg_flow[j-1])/(0.5*rCel.rCel[j-1] + 0.5*rCel.rCel[j]) - (QAgg_flow[j-1] - QAgg_flow[j-2])/(0.5*rCel.rCel[j-1] + 0.5*rCel.rCel[j-2]));
   end for;
   for j in 1:i-1 loop
     der(QAgg_flow[j])*rCel.rCel[j]*tLoaAgg = QFace[j] - QFace[j+1];
   end for;
   der(QAgg_flow[i]) = 1/(rCel.rCel[i]*tLoaAgg)*(QAgg_flow[i-1]);

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
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
</ul>
</html>", info="<html>
<p>In this model, the default load aggregation scheme of the IBPSA library is made continuous using a QUICK scheme. For more information see the PhD thesis of I. Cupeiro.</p>
<p>Note that is very imporant that the parameter tLoaAgg is set as used to make the rCel and kappa records.</p>
</html>"));
end GroundTemperatureResponseContRecord;

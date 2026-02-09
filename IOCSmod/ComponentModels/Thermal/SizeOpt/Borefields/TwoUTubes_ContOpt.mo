within IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields;
model TwoUTubes_ContOpt
  "Double U-tube borefield model with a continuous ground model and an optimizable depth."
  extends
    IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.PartialBorefield_ContRecord(
      redeclare IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.Boreholes.TwoUTube
                                                                                      borHol(depth=
          depth), redeclare replaceable IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseContEq groTemRes(H=depth,
        groTemResDat=groTemResDat),
    borFieDat(conDat(
        Rb(unit="(m.K)/W"),
        dp_nominal(displayUnit="Pa"),
        hBor=100)))
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  IOCSmod.ComponentModels.Thermal.SizeOpt.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseFinal
    groTemResFin(H=depth)
    annotation (Placement(transformation(extent={{20,102},{40,122}})));
  parameter input Real depth;


  Modelica.Blocks.Sources.RealExpression QBorHolExpr(y=borHol.port_a.m_flow*(inStream(borHol.port_a.h_outflow) - borHol.port_b.h_outflow))
    annotation (Placement(transformation(extent={{-60,102},{-40,122}})));
protected
    Modelica.Blocks.Math.Gain gaiQ_flowFin(k=borFieDat.conDat.nBor)
    "Gain to multiply the heat extracted by one borehole by the number of boreholes"
    annotation (Placement(transformation(extent={{-20,102},{0,122}})));
equation
  connect(gaiQ_flowFin.y, groTemResFin.QBor_flow)
    annotation (Line(points={{1,112},{19,112}}, color={0,0,127}));
  connect(QBorHolExpr.y, gaiQ_flowFin.u)
    annotation (Line(points={{-39,112},{-22,112}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
July 25, 2025, by Louis Hermans:<br/>
Added depth as input parameter. Use borHol model with optimizable parameter. Add model GroundTemperatureResponseFinal to calculate monthly temperatures in last year of operation. 
</li>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
<ul>
</html>", info="<html>
<p><b>To allow parameter optimization:</b></p>
<p>- Addition of ground temperature calculation model in final year of operation. This is done using the model GroundTemperatureResponseFinal. This model needs the depth parameter as input.</p>
<p>- Changed the borHol model to the version with optimizable depth. </p>
</html>"));
end TwoUTubes_ContOpt;

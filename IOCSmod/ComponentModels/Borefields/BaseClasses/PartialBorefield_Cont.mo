within IOCSmod.ComponentModels.Borefields.BaseClasses;
model PartialBorefield_Cont "Partial borefield model with the QUICK continuous implementation of the aggregation scheme"
extends IOCSmod.ComponentModels.Borefields.BaseClasses.PartialBorefield;

      Modelica.Blocks.Interfaces.RealOutput TBorAve(final quantity="ThermodynamicTemperature",
                                                final unit="K",
                                                displayUnit = "degC",
                                                start=TExt0_start)
    "Average borehole wall temperature in the borefield"
    annotation (Placement(transformation(extent={{100,34},{120,54}})));

  replaceable
    IOCSmod.ComponentModels.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponseContBase
    groTemRes(final tLoaAgg=tLoaAgg, final borFieDat=borFieDat)
    "Ground temperature response"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

protected
    Modelica.Blocks.Math.Gain gaiQ_flow(k=borFieDat.conDat.nBor)
    "Gain to multiply the heat extracted by one borehole by the number of boreholes"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  IDEAS.Utilities.Math.Average AveTBor(nin=nSeg)
    "Average temperature of all the borehole segments"
    annotation (Placement(transformation(extent={{50,34},{70,54}})));

  Modelica.Blocks.Sources.Constant TSoiUnd[nSeg](
    k = TExt_start,
    each y(unit="K",
           displayUnit="degC"))
    "Undisturbed soil temperature"
    annotation (Placement(transformation(extent={{-40,14},{-20,34}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TemBorWal[nSeg]
    "Borewall temperature"
    annotation (Placement(transformation(extent={{50,6},{70,26}})));

  Modelica.Blocks.Math.Add TSoiDis[nSeg](each final k1=1, each final k2=1)
    "Addition of undisturbed soil temperature and change of soil temperature"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  Modelica.Blocks.Math.Sum QTotSeg_flow(
    final nin=nSeg,
    final k = ones(nSeg))
    "Total heat flow rate for all segments of this borehole"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Modelica.Blocks.Routing.Replicator repDelTBor(final nout=nSeg)
    "Signal replicator for temperature difference of the borehole"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
equation
  connect(QBorHol.Q_flow, QTotSeg_flow.u) annotation (Line(points={{-11,-10},{-80,
          -10},{-80,80},{-62,80}}, color={0,0,127}));
  connect(QTotSeg_flow.y, gaiQ_flow.u)
    annotation (Line(points={{-39,80},{-22,80}}, color={0,0,127}));
  connect(gaiQ_flow.y, groTemRes.QBor_flow)
    annotation (Line(points={{1,80},{19,80}}, color={0,0,127}));
  connect(groTemRes.delTBor, repDelTBor.u)
    annotation (Line(points={{41,80},{58,80}}, color={0,0,127}));
  connect(repDelTBor.y, TSoiDis.u1) annotation (Line(points={{81,80},{90,80},{90,
          60},{0,60},{0,36},{8,36}}, color={0,0,127}));
  connect(TSoiUnd.y, TSoiDis.u2)
    annotation (Line(points={{-19,24},{8,24}}, color={0,0,127}));
  connect(TSoiDis.y, AveTBor.u) annotation (Line(points={{31,30},{40,30},{40,44},
          {48,44}}, color={0,0,127}));
  connect(TSoiDis.y, TemBorWal.T) annotation (Line(points={{31,30},{40,30},{40,16},
          {48,16}}, color={0,0,127}));
  connect(TemBorWal.port, QBorHol.port_b) annotation (Line(points={{70,16},{78,16},
          {78,0},{6.66134e-16,0}}, color={191,0,0}));
  connect(AveTBor.y, TBorAve)
    annotation (Line(points={{71,44},{110,44}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2024, by Louis Hermans:<br/>
First implementation based on work of I. Cupeiro.
</li>
<ul>
</html>"));
end PartialBorefield_Cont;

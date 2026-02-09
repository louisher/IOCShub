within IOCSmod.Simulation.DeSchipjesOneZone.Buildings;
model Building "Building optimisation model"
  extends DeSchipjes.Simulation.HeatDemand.BaseClasses.Building(
    redeclare IOCSmod.Simulation.DeSchipjesOneZone.Buildings.HeatingSystem.HeatingSystemRbc heatingSystem(addDummyEquation=
          addDummyEquation),
    redeclare package Medium = IDEAS.Media.Water,
    redeclare package MediumAir = IDEAS.Media.Specialized.DryAir,
    strobe(
      FilNam_mDHW=String(occupantID) + "_mDHW_"+inputFile+".txt",
      FilNam_QCon=String(occupantID) + "_QCon_"+inputFile+".txt",
      FilNam_QRad=String(occupantID) + "_QRad_"+inputFile+".txt",
      FilNam_QConMet_day=String(occupantID) + "_QConMet_day_"+inputFile+".txt",
      FilNam_QRadMet_day=String(occupantID) + "_QRadMet_day_"+inputFile+".txt",
      FilNam_QConMet_night=String(occupantID) + "_QConMet_night_"+inputFile+".txt",
      FilNam_QRadMet_night=String(occupantID) + "_QRadMet_night_"+inputFile+".txt",
      FilNam_TSet="sh_day_opt.txt",
      FilNam_TSet2="sh_day_opt.txt"),
     final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);

//       FilNam_mDHW=String(occupantID) + "_mDHW_opt.txt",
//       FilNam_QCon=String(occupantID) + "_QCon_"+inputFile+".txt",
//       FilNam_QRad=String(occupantID) + "_QRad_"+inputFile+".txt",
//       FilNam_QConMet_day="None.txt",
//       FilNam_QRadMet_day="None.txt",
//       FilNam_QConMet_night="None.txt",
//       FilNam_QRadMet_night="None.txt",
//   parameter String inputFile = "opt" "='prediction_P_historic' to use perfect predictions, 'prediction_P_historic' otherwise";

  parameter String inputFile = "opt" "='opt' to use perfect predictions, 'prediction_P_historic' otherwise";

  parameter Boolean addDummyEquation=true
    "=true, to balance equations in dymola";

equation
  connect(occupant.mDHW38C, heatingSystem.mDHW) annotation (Line(points={{6,-30},
          {6,-22},{30,-22},{30,7},{22,7}}, color={0,0,127}));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{60,22},{0,74},{-60,24},{-60,-46},{60,-46}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{60,22},{56,18},{0,64},{-54,20},{-54,-40},{60,-40},{60,-46},{
              -60,-46},{-60,24},{0,74},{60,22}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,6},{-46,-6},{-44,-8},{-24,4},{-24,16},{-26,18},{-46,6}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-18},{-46,-30},{-44,-32},{-24,-20},{-24,-8},{-26,-6},{-46,
              -18}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-44,-4},{-50,-8},{-50,-32},{-46,-36},{28,-36},{42,-26}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,14},{-20,16},{-20,-18},{-16,-22},{-16,-22},{40,-22}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-10},{-20,-8}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{40,-12},{40,-32},{50,-38},{58,-32},{58,-16},{54,-10},{48,-6},
              {40,-12}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-60},{100,-100}},
          lineColor={127,0,0},
          textString="%name")}));
end Building;

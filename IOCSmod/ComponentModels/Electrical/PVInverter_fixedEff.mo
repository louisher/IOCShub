within IOCSmod.ComponentModels.Electrical;
model PVInverter_fixedEff
  "Inverter used to transform DC input power to AC output power for a photovoltaic installation"
  parameter Modelica.Units.SI.Efficiency eta_nom = 0.96 "Nominal inverter efficiency"
    annotation (Dialog(group="Specifications"));
  parameter Modelica.Units.SI.Power P_ac0 "Inverter rated AC power"
    annotation (Dialog(group="Specifications"));

  Modelica.Units.SI.Power P_ac "Uncurtailed inverter AC output power";

  Modelica.Blocks.Interfaces.RealInput P_PV "Inverter DC input power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_out "Curtailed inverter AC output power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  P_ac = eta_nom*P_PV;
  P_out = UnitTests.Confidential.smoothMin2(P_ac, P_ac0, 10);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false),
      graphics={Rectangle(lineColor = {131, 131, 131},
                fillColor = {239, 239, 239},
                fillPattern = FillPattern.Solid,
                lineThickness = 1,
                extent = {{-100, 100}, {100, -100}}),
                Line(points = {{-100, -100}, {100, 100}},
                color = {131, 131, 131}, thickness = 1),
                Text(textColor = {28, 108, 200},
                extent={{-20,-8},{80,-108}},
                textString = "~"),
                Text(textColor = {28, 108, 200},
                extent={{-100,80},{0,-20}},
                textString = "="),
        Rectangle(
          extent={{2,98},{98,2}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={237,248,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{22,80},{82,20}},
          textColor={28,108,200},
          textString="PV")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(
      info = "<html><p>Model for an inverter which can be used to transform the DC power of a PV module into an AC power. 
              The model inputs are the DC power of the PV installation represented by a real input 
              and a fixed inverter efficiency set by the user. 
              The model outputs AC power through a real output connector.</p>
              <p>This model is a simple inverter model and uses a fixed efficiency 'eta_nom'
              and automatically curtails power when the inverter rated AC power is exceeded.</p></html>",
      revisions="<html>
<ul>
<li>July 30, 2024, by Lucas Verleyen:<br>
Initial implementation</li>
</ul>
</html>"));
end PVInverter_fixedEff;

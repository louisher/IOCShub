within IOCSmod.ComponentModels;
model ApplianceHeatGains
  "Model to account for internal heat gains of electrical appliances"

  parameter Integer nZones(min=1)=2
    "Number of conditioned thermal zones in the building";
  parameter Real[nZones] partition(each min=0, each max=1)=ones(nZones)/nZones
    "Array to divide the internal heat gains among the zones. Values between 0 and 1. Sum of all values should be 1!";
  parameter String loadFile=Modelica.Utilities.Files.loadResource(
    "modelica://IOCSmod/Resources/OccupancyProfiles/FTE_PTE_School.txt")
    "File for Occupancy Sim Info Manager";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
    "Nodes for internal convective heat gains from electrical appliances" annotation (Placement(
        transformation(extent={{-110,10},{-90,30}}),iconTransformation(extent={{-110,10},
            {-90,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortRad
    "Nodes for internal radiative heat gains from electrical appliances" annotation (Placement(
        transformation(extent={{-110,-30},{-90,-10}}),iconTransformation(extent={{-110,
            -30},{-90,-10}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] convHeat
    annotation (Placement(transformation(extent={{-40,10},{-60,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] radHeat
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
  Modelica.Blocks.Sources.RealExpression[nZones] convHeatInput(y=occSim.occBus.heaGainConv*partition)
    annotation (Placement(transformation(extent={{0,10},{-20,30}})));
  Modelica.Blocks.Sources.RealExpression[nZones] radHeatInput(y=occSim.occBus.heaGainRad*partition)
    annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));
  outer TinyCluster.BoundaryConditions.Occupancy.OccSimInfoManager occSim(loadFile=
        loadFile)
    annotation (Placement(transformation(extent={{-94,72},{-74,94}})));
equation
  connect(convHeat.port, heatPortCon)
    annotation (Line(points={{-60,20},{-100,20}}, color={191,0,0}));
  connect(radHeat.port, heatPortRad)
    annotation (Line(points={{-60,-20},{-100,-20}}, color={191,0,0}));
  connect(convHeatInput.y, convHeat.Q_flow)
    annotation (Line(points={{-21,20},{-40,20}}, color={0,0,127}));
  connect(radHeatInput.y, radHeat.Q_flow)
    annotation (Line(points={{-21,-20},{-40,-20}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                    Rectangle(lineColor = {131, 131, 131}, fillColor = {239, 239, 239},
            fillPattern =                                                                                                                             FillPattern.Solid,
            lineThickness =                                                                                                                                                              1, extent={{-100,98},
              {100,-102}}),
        Text(
          extent={{-22.5,41.5},{22.5,-41.5}},
          textColor={28,108,200},
          textString="~",
          origin={-40.5,56.5},
          rotation=90),
        Text(
          extent={{-22.5,41.5},{22.5,-41.5}},
          textColor={28,108,200},
          textString="~",
          origin={1.5,56.5},
          rotation=90),
        Text(
          extent={{-22.5,41.5},{22.5,-41.5}},
          textColor={28,108,200},
          textString="~",
          origin={45.5,56.5},
          rotation=90),
        Ellipse(
          extent={{-40,30},{40,-66}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,32},{44,-4}},
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-22,16},{-16,-4}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,16},{20,-4}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,-64},{4,-92}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-4},{44,-10}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-6},{40,-20}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),                          Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model reads the convective and radiative internal heat gains via an Occupancy Sim Info manager and connects those internal heat gains with heat ports.</p>
<p>The user can connect the heat ports of this model to the heat ports of a zone model. </p>
<p>The user can also set the number of zones among which the internal heat gains should be divided. In that case, the partition array should be updated accordingly, i.e. every entry corresponds to a fraction of the internal heat gains allocated to that zone. The fraction is a number between 0 and 1. The total of all fractions in the partition array should be 1.</p>
</html>", revisions="<html>
<ul>
<li>August 23, 2023, by Lucas Verleyen:<br>
Initial implementation.</li>
</ul>
</html>"));
end ApplianceHeatGains;

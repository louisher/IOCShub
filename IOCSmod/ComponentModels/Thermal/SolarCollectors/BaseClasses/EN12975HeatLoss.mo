within IOCSmod.ComponentModels.Thermal.SolarCollectors.BaseClasses;
model EN12975HeatLoss "Calculate the heat loss of a solar collector per EN12975"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss(
    each QLos_flow = A_c/nSeg * {dT[i] * (a1 - a2 * (if linearize then -abs(dT_nominal) else dT[i])) for i in 1:nSeg});

  parameter Boolean linearize = true
    "Linearize heat transfer"
    annotation(Evaluate=true);

    parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Ambient temperature minus fluid temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
end EN12975HeatLoss;

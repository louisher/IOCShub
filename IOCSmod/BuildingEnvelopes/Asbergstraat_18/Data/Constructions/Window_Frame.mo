within IOCSmod.BuildingEnvelopes.Asbergstraat_18.Data.Constructions;
record Window_Frame    "Frame data of Window"
    extends IDEAS.Buildings.Data.Interfaces.Frame(
    present=true,
    U_value=3.7378860471196185,
    redeclare parameter IDEAS.Buildings.Components.ThermalBridges.LineLosses briTyp(psi=0.06, len=5.214520726296749));
end Window_Frame;

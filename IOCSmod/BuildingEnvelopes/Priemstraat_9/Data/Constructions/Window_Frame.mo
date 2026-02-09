within IOCSmod.BuildingEnvelopes.Priemstraat_9.Data.Constructions;
record Window_Frame    "Frame data of Window"
    extends IDEAS.Buildings.Data.Interfaces.Frame(
    present=true,
    U_value=4.417200337866755,
    redeclare parameter IDEAS.Buildings.Components.ThermalBridges.LineLosses briTyp(psi=0.06, len=4.189299516776689));
end Window_Frame;

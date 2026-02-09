within IOCSmod.BuildingEnvelopes.Zaveldriesstraat_54.Data.Constructions;
record Window_Frame    "Frame data of Window"
    extends IDEAS.Buildings.Data.Interfaces.Frame(
    present=true,
    U_value=2.1901694997247203,
    redeclare parameter IDEAS.Buildings.Components.ThermalBridges.LineLosses briTyp(psi=0.06, len=2.9602788121746793));
end Window_Frame;

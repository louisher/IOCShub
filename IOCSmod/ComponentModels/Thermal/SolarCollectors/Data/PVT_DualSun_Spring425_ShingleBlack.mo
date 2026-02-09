within IOCSmod.ComponentModels.Thermal.SolarCollectors.Data;
record PVT_DualSun_Spring425_ShingleBlack =
    Buildings.Fluid.SolarCollectors.Data.GenericEN12975 (
    final A=2.08,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final C=5.97e3,
    final V=5/1000,
    final mDry=29.4,
    final mperA_flow_nominal=0.02,
    final dp_nominal=1000,
    final incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    final incAngModDat={1,1,1,0.99,0.99,0.97,0.96,0.91,0.79,0.00},
    final IAMDiff=0.97,
    final eta0=0.35,
    final a1=8.59,
    final a2=0)
  "PVT - DualSun Spring 425 Shingle Black";

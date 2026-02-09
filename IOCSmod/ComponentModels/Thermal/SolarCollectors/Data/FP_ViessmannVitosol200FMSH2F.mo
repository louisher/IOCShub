within IOCSmod.ComponentModels.Thermal.SolarCollectors.Data;
record FP_ViessmannVitosol200FMSH2F =
  Buildings.Fluid.SolarCollectors.Data.GenericEN12975 (
    final A=2.51,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.TotalCapacity,
    final C=5.97e3,
    final V=2.4/1000,
    final mDry=40.9,
    final mperA_flow_nominal=30/3600,
    final dp_nominal=10000,
    final incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    final incAngModDat={1,1,0.99,0.97,0.94,0.89,0.81,0.63,0.33,0.00},
    final IAMDiff=0.89,
    final eta0=0.760,
    final a1=4.031,
    final a2=0.034)
  "FP - Viessmann Vitosol 200-FM SH2F";

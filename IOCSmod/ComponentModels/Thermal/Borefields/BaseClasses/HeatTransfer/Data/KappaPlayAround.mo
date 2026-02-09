within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data;
record KappaPlayAround
extends
    IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.KappaTemplate(
      kappa={2.9088998228403884e-05,1.273290716843072e-05,
        1.1475136862608074e-05,1.1234091568027e-05,
        1.1246489249695072e-05,1.1313390028220392e-05,
        1.1364341212013527e-05,1.1384403513499603e-05,
        1.1833388643941309e-05,1.550622294622902e-05,
        2.6015278326767233e-05,4.459197887788234e-05,
        7.09810221757768e-05,0.0001005987529321,0.0001230753339992168,
        0.00012746342469265655,0.00011090853851630962,
        3.803314423229942e-05});
annotation (defaultComponentName="kappa", defaultComponentPrefixes="parameter", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end KappaPlayAround;

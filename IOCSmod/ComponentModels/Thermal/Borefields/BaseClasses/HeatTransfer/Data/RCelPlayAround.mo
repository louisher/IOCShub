within IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data;
record RCelPlayAround
extends
    IOCSmod.ComponentModels.Thermal.Borefields.BaseClasses.HeatTransfer.Data.RCelTemplate(
      rCel={1.0,2.0,4.0,8.0,16.0,32.0,64.0,128.0,256.0,512.0,1024.0,
        2048.0,4096.0,8192.0,16384.0,32768.0,65536.0,44129.0});
annotation (defaultComponentName="rCel", defaultComponentPrefixes="parameter", Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end RCelPlayAround;

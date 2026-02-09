within IOCSmod.ComponentModels.Thermal;
model Stc
  "Model of a STC-module that can be used for regeneration or regualar heating:
  Regular ports are used for heating, while additional ports are created for regeneration"
    extends IOCSmod.ComponentModels.BaseClasses.Panels(hasEl=false);


  annotation (defaultComponentName="stc", Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={            Text(
          extent={{-150,100},{150,140}},
          textColor={0,0,0},
          textString="%name"),                                                                         Text(
          extent={{-72,35},{76,-35}},
          textColor={238,46,47},
          textString="%name")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Stc;

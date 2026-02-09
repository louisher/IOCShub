within IOCSmod.ComponentModels.Verification;
model VerificationPV
  Electrical.PVPanelDC pv
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim(lineariseJModelica=true)
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  Electrical.SizeOpt.PVPanelDC_AreaOpt pvOpt(inv_cost=200)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VerificationPV;

within IOCSmod.Demand.BuildingEnvelopes;
model DeSchipjesBaseBhp
  extends IOCSmod.Demand.BuildingEnvelopes.DeSchipjesRadVal
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  ComponentModels.Thermal.Bhp bhp_158(
    Qbhp_profile_name="158_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,920},{1960,940}})));

  ComponentModels.Thermal.Bhp bhp_156(
    Qbhp_profile_name="156_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,820},{1960,840}})));

  ComponentModels.Thermal.Bhp bhp_154(
    Qbhp_profile_name="154_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,720},{1960,740}})));

  ComponentModels.Thermal.Bhp bhp_152(
    Qbhp_profile_name="152_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,620},{1960,640}})));

  ComponentModels.Thermal.Bhp bhp_150(
    Qbhp_profile_name="150_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,520},{1960,540}})));

  ComponentModels.Thermal.Bhp bhp_148(
    Qbhp_profile_name="148_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,420},{1960,440}})));

  ComponentModels.Thermal.Bhp bhp_146(
    Qbhp_profile_name="146_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,320},{1960,340}})));

  ComponentModels.Thermal.Bhp bhp_144(
    Qbhp_profile_name="144_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,220},{1960,240}})));

  ComponentModels.Thermal.Bhp bhp_142(
    Qbhp_profile_name="142_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,120},{1960,140}})));

  ComponentModels.Thermal.Bhp bhp_140(
    Qbhp_profile_name="140_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,20},{1960,40}})));

  ComponentModels.Thermal.Bhp bhp_138(
    Qbhp_profile_name="138_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,-80},{1960,-60}})));

  ComponentModels.Thermal.Bhp bhp_136(
    Qbhp_profile_name="136_Qcon_bhp_opt_1hour",
    m_flow_nominalCon=300/3600,
    m_flow_nominalEva=250/3600,
    dpFixed_nominal(displayUnit="Pa") = 22000,
    Kv=0.944911183)
    annotation (Placement(transformation(extent={{1940,-180},{1960,-160}})));

equation
  connect(circulationPumpDp__Pump_158.port_b2, bhp_158.port_a) annotation (Line(
        points={{1848,922},{1848,908},{1932,908},{1932,934},{1940,934}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_158.port_a2, bhp_158.port_b) annotation (Line(
        points={{1868,922},{1868,914},{1940,914},{1940,926}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_156.port_b2, bhp_156.port_a) annotation (Line(
        points={{1848,822},{1848,808},{1932,808},{1932,834},{1940,834}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_156.port_a2, bhp_156.port_b) annotation (Line(
        points={{1868,822},{1868,814},{1940,814},{1940,826}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_154.port_b2, bhp_154.port_a) annotation (Line(
        points={{1848,722},{1848,708},{1932,708},{1932,734},{1940,734}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_154.port_a2, bhp_154.port_b) annotation (Line(
        points={{1868,722},{1868,714},{1940,714},{1940,726}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_152.port_b2, bhp_152.port_a) annotation (Line(
        points={{1848,622},{1848,608},{1932,608},{1932,634},{1940,634}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_152.port_a2, bhp_152.port_b) annotation (Line(
        points={{1868,622},{1868,614},{1940,614},{1940,626}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_150.port_b2, bhp_150.port_a) annotation (Line(
        points={{1848,522},{1848,508},{1932,508},{1932,534},{1940,534}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_150.port_a2, bhp_150.port_b) annotation (Line(
        points={{1868,522},{1868,514},{1940,514},{1940,526}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_148.port_b2, bhp_148.port_a) annotation (Line(
        points={{1848,422},{1848,408},{1932,408},{1932,434},{1940,434}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_148.port_a2, bhp_148.port_b) annotation (Line(
        points={{1868,422},{1868,414},{1940,414},{1940,426}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_146.port_b2, bhp_146.port_a) annotation (Line(
        points={{1848,322},{1848,308},{1932,308},{1932,334},{1940,334}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_146.port_a2, bhp_146.port_b) annotation (Line(
        points={{1868,322},{1868,314},{1940,314},{1940,326}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_144.port_b2, bhp_144.port_a) annotation (Line(
        points={{1848,222},{1848,208},{1932,208},{1932,234},{1940,234}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_144.port_a2, bhp_144.port_b) annotation (Line(
        points={{1868,222},{1868,214},{1940,214},{1940,226}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_142.port_b2, bhp_142.port_a) annotation (Line(
        points={{1848,122},{1848,108},{1932,108},{1932,134},{1940,134}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_142.port_a2, bhp_142.port_b) annotation (Line(
        points={{1868,122},{1868,114},{1940,114},{1940,126}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_140.port_b2, bhp_140.port_a) annotation (Line(
        points={{1848,22},{1848,8},{1932,8},{1932,34},{1940,34}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_140.port_a2, bhp_140.port_b) annotation (Line(
        points={{1868,22},{1868,14},{1940,14},{1940,26}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_138.port_b2, bhp_138.port_a) annotation (Line(
        points={{1848,-78},{1848,-92},{1932,-92},{1932,-66},{1940,-66}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_138.port_a2, bhp_138.port_b) annotation (Line(
        points={{1868,-78},{1868,-86},{1940,-86},{1940,-74}}, color={0,127,255}));

  connect(circulationPumpDp__Pump_136.port_b2, bhp_136.port_a) annotation (Line(
        points={{1848,-178},{1848,-192},{1932,-192},{1932,-166},{1940,-166}}, color={
          0,127,255}));
  connect(circulationPumpDp__Pump_136.port_a2, bhp_136.port_b) annotation (Line(
        points={{1868,-178},{1868,-186},{1940,-186},{1940,-174}}, color={0,127,255}));

end DeSchipjesBaseBhp;

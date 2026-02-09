within IOCSmod.BuildingEnvelopes.Zaveldriesstraat_54;
model Zaveldriesstraat_54_1593993_Structure "Structure of Zaveldriesstraat_54_1593993"
    extends IDEAS.Templates.Interfaces.BaseClasses.Structure(
        nZones = 2,
        VZones = {
            DayZone.V,
            NightZone.V},
        AZones = {
            DayZone.A,
            NightZone.A},
        Q_design = {
            DayZone.Q_design,
            NightZone.Q_design},
        nEmb = 2, useFluPor=false);

   Modelica.Blocks.Interfaces.RealInput[nZones] occ "Occupancy of the zones"
   annotation (Placement(transformation(extent={{-10,-10},{10,10}},
     rotation=270,
     origin={100,100})));

    parameter Modelica.Units.SI.Area OuterWall_1_1_A =  9.985336620226056;
    parameter Modelica.Units.SI.Angle OuterWall_1_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_1_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.OuterWall OuterWall_1_1(T_start=T_start,
        A=OuterWall_1_1_A,
        inc=OuterWall_1_1_inc,
        azi=OuterWall_1_1_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={10,-60})));

    parameter Modelica.Units.SI.Area OuterWall_1_2_A =  22.459640480217153;
    parameter Modelica.Units.SI.Angle OuterWall_1_2_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_1_2_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall OuterWall_1_2(T_start=T_start,
        A=OuterWall_1_2_A,
        inc=OuterWall_1_2_inc,
        azi=OuterWall_1_2_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-20,-60})));

    parameter Modelica.Units.SI.Area OuterWall_1_3_A =  0.0668687978030762;
    parameter Modelica.Units.SI.Angle OuterWall_1_3_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_1_3_azi =  0.0;

    IDEAS.Buildings.Components.OuterWall OuterWall_1_3(T_start=T_start,
        A=OuterWall_1_3_A,
        inc=OuterWall_1_3_inc,
        azi=OuterWall_1_3_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-50,-60})));

    parameter Modelica.Units.SI.Area Window_1_1_A =  2.434236290502869;
    parameter Modelica.Units.SI.Angle Window_1_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.Window Window_1_1(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        A=Window_1_1_A,
        inc=Window_1_1_inc,
        azi=Window_1_1_azi,
        frac=0.2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-80,-62})));

    parameter Modelica.Units.SI.Area Window_1_2_A =  5.47523573895841;
    parameter Modelica.Units.SI.Angle Window_1_2_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_2_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.Window Window_1_2(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        A=Window_1_2_A,
        inc=Window_1_2_inc,
        azi=Window_1_2_azi,
        frac=0.2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-110,-62})));

    parameter Modelica.Units.SI.Area Window_1_3_A =  0.01630134871816285;
    parameter Modelica.Units.SI.Angle Window_1_3_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_3_azi =  0.0;

    IDEAS.Buildings.Components.Window Window_1_3(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        A=Window_1_3_A,
        inc=Window_1_3_inc,
        azi=Window_1_3_azi,
        frac=0.2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-140,-60})));

    IDEAS.Buildings.Components.SlabOnGround GroundFloor_1_1(T_start=T_start,
        A=40.61329650878906,
        inc=0.0,
        azi=0.0,
        redeclare parameter Data.Constructions.GroundFloor constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-170,-60})));

    parameter Modelica.Units.SI.Area CommonWall_1_1_A =  56.28171885878978;
    parameter Modelica.Units.SI.Angle CommonWall_1_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle CommonWall_1_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.BoundaryWall CommonWall_1_1(T_start=T_start,
        A=CommonWall_1_1_A,
        inc=CommonWall_1_1_inc,
        azi=CommonWall_1_1_azi,
        redeclare parameter Data.Constructions.CommonWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-200,-60})));
    IDEAS.Buildings.Components.InternalWall InnerWall_1_1(T_start=T_start,
        A=32.36672945044483,
        inc=1.5707963267948966,
        azi=3.141592653589793,
        redeclare parameter Data.Constructions.InnerWall constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-260,-60})));

    IDEAS.Buildings.Components.InternalWall Floor_1_1(T_start=T_start,
        A=40.61329650878906,
        inc=Modelica.Constants.pi,
        azi=0.0,
        redeclare parameter Data.Constructions.Floor constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-290,-60})));

    IDEAS.Buildings.Components.Zone DayZone(T_start=T_start,
        nSurf=11,
        V=134.4878349082096,
        A=40.61329650878906,
        n50=8.0,
        fRH=22,
        allowFlowReversal=false,
        redeclare package Medium = Medium,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure
      interzonalAirFlow,
     redeclare IDEAS.Buildings.Components.Occupants.Input occNum) "Thermal zone: DayZone"
        annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

    parameter Modelica.Units.SI.Area OuterWall_2_1_A =  9.985336620226056;
    parameter Modelica.Units.SI.Angle OuterWall_2_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_2_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.OuterWall OuterWall_2_1(T_start=T_start,
        A=OuterWall_2_1_A,
        inc=OuterWall_2_1_inc,
        azi=OuterWall_2_1_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-20,0})));

    parameter Modelica.Units.SI.Area OuterWall_2_2_A =  22.459640480217153;
    parameter Modelica.Units.SI.Angle OuterWall_2_2_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_2_2_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall OuterWall_2_2(T_start=T_start,
        A=OuterWall_2_2_A,
        inc=OuterWall_2_2_inc,
        azi=OuterWall_2_2_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-50,0})));

    parameter Modelica.Units.SI.Area OuterWall_2_3_A =  0.0668687978030762;
    parameter Modelica.Units.SI.Angle OuterWall_2_3_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_2_3_azi =  0.0;

    IDEAS.Buildings.Components.OuterWall OuterWall_2_3(T_start=T_start,
        A=OuterWall_2_3_A,
        inc=OuterWall_2_3_inc,
        azi=OuterWall_2_3_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-80,0})));

    parameter Modelica.Units.SI.Area Window_2_1_A =  2.434236290502869;
    parameter Modelica.Units.SI.Angle Window_2_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.Window Window_2_1(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        A=Window_2_1_A,
        inc=Window_2_1_inc,
        azi=Window_2_1_azi,
        frac=0.2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-110,0})));

    parameter Modelica.Units.SI.Area Window_2_2_A =  5.47523573895841;
    parameter Modelica.Units.SI.Angle Window_2_2_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_2_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.Window Window_2_2(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        A=Window_2_2_A,
        inc=Window_2_2_inc,
        azi=Window_2_2_azi,
        frac=0.2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-140,0})));

    parameter Modelica.Units.SI.Area Window_2_3_A =  0.01630134871816285;
    parameter Modelica.Units.SI.Angle Window_2_3_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_3_azi =  0.0;

    IDEAS.Buildings.Components.Window Window_2_3(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        A=Window_2_3_A,
        inc=Window_2_3_inc,
        azi=Window_2_3_azi,
        frac=0.2,
    redeclare IDEAS.Buildings.Components.Shading.None shaType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-170,0})));

    parameter Modelica.Units.SI.Area Rooftop_2_1_A =  51.8166502801066;
    parameter Modelica.Units.SI.Angle Rooftop_2_1_inc =  0.6700533443350621;
    parameter Modelica.Units.SI.Angle Rooftop_2_1_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall Rooftop_2_1(T_start=T_start,
        A=Rooftop_2_1_A,
        inc=Rooftop_2_1_inc,
        azi=Rooftop_2_1_azi,
        redeclare parameter Data.Constructions.Rooftop constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-200,0})));

    parameter Modelica.Units.SI.Area CommonWall_2_1_A =  56.28171885878978;
    parameter Modelica.Units.SI.Angle CommonWall_2_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle CommonWall_2_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.BoundaryWall CommonWall_2_1(T_start=T_start,
        A=CommonWall_2_1_A,
        inc=CommonWall_2_1_inc,
        azi=CommonWall_2_1_azi,
        redeclare parameter Data.Constructions.CommonWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-230,0})));
    IDEAS.Buildings.Components.InternalWall InnerWall_2_1(T_start=T_start,
        A=32.36672945044483,
        inc=1.5707963267948966,
        azi=3.141592653589793,
        redeclare parameter Data.Constructions.InnerWall constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-290,0})));

    IDEAS.Buildings.Components.Zone NightZone(T_start=T_start,
        nSurf=11,
        V=134.4878349082096,
        A=40.61329650878906,
        n50=8.0,
        fRH=22,
        allowFlowReversal=false,
        redeclare package Medium = Medium,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure
      interzonalAirFlow,
     redeclare IDEAS.Buildings.Components.Occupants.Input occNum) "Thermal zone: NightZone"
        annotation (Placement(transformation(extent={{40,0},{60,20}})));

equation
    connect(DayZone.propsBus[1], OuterWall_1_1.propsBus_a);
    connect(DayZone.propsBus[2], OuterWall_1_2.propsBus_a);
    connect(DayZone.propsBus[3], OuterWall_1_3.propsBus_a);
    connect(DayZone.propsBus[4], Window_1_1.propsBus_a);
    connect(DayZone.propsBus[5], Window_1_2.propsBus_a);
    connect(DayZone.propsBus[6], Window_1_3.propsBus_a);
    connect(DayZone.propsBus[7], GroundFloor_1_1.propsBus_a);
    connect(DayZone.propsBus[8], CommonWall_1_1.propsBus_a);
    connect(DayZone.propsBus[9], InnerWall_1_1.propsBus_b);
    connect(DayZone.propsBus[10], InnerWall_1_1.propsBus_a);
    connect(DayZone.propsBus[11], Floor_1_1.propsBus_a);
    connect(DayZone.TSensor, TSensor[1]);
    connect(DayZone.gainCon, heatPortCon[1]);
    connect(DayZone.gainRad, heatPortRad[1]);

    connect(NightZone.propsBus[1], Floor_1_1.propsBus_b);
    connect(NightZone.propsBus[2], OuterWall_2_1.propsBus_a);
    connect(NightZone.propsBus[3], OuterWall_2_2.propsBus_a);
    connect(NightZone.propsBus[4], OuterWall_2_3.propsBus_a);
    connect(NightZone.propsBus[5], Window_2_1.propsBus_a);
    connect(NightZone.propsBus[6], Window_2_2.propsBus_a);
    connect(NightZone.propsBus[7], Window_2_3.propsBus_a);
    connect(NightZone.propsBus[8], Rooftop_2_1.propsBus_a);
    connect(NightZone.propsBus[9], CommonWall_2_1.propsBus_a);
    connect(NightZone.propsBus[10], InnerWall_2_1.propsBus_b);
    connect(NightZone.propsBus[11], InnerWall_2_1.propsBus_a);
    connect(NightZone.TSensor, TSensor[2]);
    connect(NightZone.gainCon, heatPortCon[2]);
    connect(NightZone.gainRad, heatPortRad[2]);

   connect(DayZone.yOcc, occ[1]);
   connect(NightZone.yOcc, occ[2]);

   connect(GroundFloor_1_1.port_emb[1], heatPortEmb[1]);
   connect(Floor_1_1.port_emb[1], heatPortEmb[2]);

   annotation (Documentation(revisions="<html>
          <ul> 
          <li>March 11, 2024, by Lucas Verleyen:<br>
          Remove Medium redeclaration from the building envelope structure, such that Medium can be set in the top layer model.</li>
          <li>March 10, 2024, by Lucas Verleyen:<br>
          Enable T_start parameter.</li>
          <li>September 19, 2023, by Lucas Verleyen:<br> 
          - Set nEmb = 2.<br> 
          - Connect GroundFloor with heatPortEmb[1] and Floor with heatPortEmb[2].</li> 
          - Change occupancy type in zone models (both zones) to yOcc.<br> 
          - Add occ[nZones] as input connector to connect occupancy from outside.<br> 
          </ul> 
          </html>"));
end Zaveldriesstraat_54_1593993_Structure;

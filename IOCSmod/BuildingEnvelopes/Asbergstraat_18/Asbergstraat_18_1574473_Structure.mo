within IOCSmod.BuildingEnvelopes.Asbergstraat_18;
model Asbergstraat_18_1574473_Structure "Structure of Asbergstraat_18_1574473"
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

    parameter Modelica.Units.SI.Area OuterWall_1_1_A =  24.049887603659393;
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

    parameter Modelica.Units.SI.Area OuterWall_1_2_A =  19.134209708544414;
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

    parameter Modelica.Units.SI.Area OuterWall_1_3_A =  19.60577282799718;
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

    parameter Modelica.Units.SI.Area OuterWall_1_4_A =  26.098988324026937;
    parameter Modelica.Units.SI.Angle OuterWall_1_4_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_1_4_azi =  1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall OuterWall_1_4(T_start=T_start,
        A=OuterWall_1_4_A,
        inc=OuterWall_1_4_inc,
        azi=OuterWall_1_4_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-80,-60})));

    parameter Modelica.Units.SI.Area Window_1_1_A =  7.553118445827325;
    parameter Modelica.Units.SI.Angle Window_1_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.Window Window_1_1(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_1_1_A,
        inc=Window_1_1_inc,
        azi=Window_1_1_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-110,-60})));

    parameter Modelica.Units.SI.Area Window_1_2_A =  6.009298449858234;
    parameter Modelica.Units.SI.Angle Window_1_2_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_2_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.Window Window_1_2(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_1_2_A,
        inc=Window_1_2_inc,
        azi=Window_1_2_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-140,-60})));

    parameter Modelica.Units.SI.Area Window_1_3_A =  6.157397773838797;
    parameter Modelica.Units.SI.Angle Window_1_3_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_3_azi =  0.0;

    IDEAS.Buildings.Components.Window Window_1_3(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_1_3_A,
        inc=Window_1_3_inc,
        azi=Window_1_3_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-170,-60})));

    parameter Modelica.Units.SI.Area Window_1_4_A =  8.196659933564305;
    parameter Modelica.Units.SI.Angle Window_1_4_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_1_4_azi =  1.5707963267948966;

    IDEAS.Buildings.Components.Window Window_1_4(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_1_4_A,
        inc=Window_1_4_inc,
        azi=Window_1_4_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-200,-60})));

    parameter Modelica.Units.SI.Area Rooftop_1_1_A =  55.80388849439922;
    parameter Modelica.Units.SI.Angle Rooftop_1_1_inc =  0.1419244894224415;
    parameter Modelica.Units.SI.Angle Rooftop_1_1_azi =  1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall Rooftop_1_1(T_start=T_start,
        A=Rooftop_1_1_A,
        inc=Rooftop_1_1_inc,
        azi=Rooftop_1_1_azi,
        redeclare parameter Data.Constructions.Rooftop constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-230,-60})));

    IDEAS.Buildings.Components.SlabOnGround GroundFloor_1_1(T_start=T_start,
        A=110.46117401123048,
        inc=0.0,
        azi=0.0,
        redeclare parameter Data.Constructions.GroundFloor constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-260,-60})));

    parameter Modelica.Units.SI.Area CommonWall_1_1_A =  45.562139923957666;
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
            origin={-290,-60})));
    IDEAS.Buildings.Components.InternalWall InnerWall_1_1(T_start=T_start,
        A=94.77435699362675,
        inc=1.5707963267948966,
        azi=3.141592653589793,
        redeclare parameter Data.Constructions.InnerWall constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-350,-60})));

    IDEAS.Buildings.Components.InternalWall Floor_1_1(T_start=T_start,
        A=56.26300430297852,
        inc=Modelica.Constants.pi,
        azi=0.0,
        redeclare parameter Data.Constructions.Floor constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-380,-60})));

    IDEAS.Buildings.Components.Zone DayZone(T_start=T_start,
        nSurf=14,
        V=374.1695230248083,
        A=110.46117401123048,
        n50=8.0,
        fRH=22,
        allowFlowReversal=false,
        redeclare package Medium = Medium,
    redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure
      interzonalAirFlow,
     redeclare IDEAS.Buildings.Components.Occupants.Input occNum) "Thermal zone: DayZone"
        annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

    parameter Modelica.Units.SI.Area OuterWall_2_1_A =  12.249724320269008;
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

    parameter Modelica.Units.SI.Area OuterWall_2_2_A =  9.7459413481924;
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

    parameter Modelica.Units.SI.Area OuterWall_2_3_A =  9.986130338182667;
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

    parameter Modelica.Units.SI.Area OuterWall_2_4_A =  13.293426450716707;
    parameter Modelica.Units.SI.Angle OuterWall_2_4_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle OuterWall_2_4_azi =  1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall OuterWall_2_4(T_start=T_start,
        A=OuterWall_2_4_A,
        inc=OuterWall_2_4_inc,
        azi=OuterWall_2_4_azi,
        redeclare parameter Data.Constructions.OuterWall constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-110,0})));

    parameter Modelica.Units.SI.Area Window_2_1_A =  3.8471538929622766;
    parameter Modelica.Units.SI.Angle Window_2_1_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_1_azi =  3.141592653589793;

    IDEAS.Buildings.Components.Window Window_2_1(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_2_1_A,
        inc=Window_2_1_inc,
        azi=Window_2_1_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-140,0})));

    parameter Modelica.Units.SI.Area Window_2_2_A =  3.060814694110359;
    parameter Modelica.Units.SI.Angle Window_2_2_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_2_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.Window Window_2_2(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_2_2_A,
        inc=Window_2_2_inc,
        azi=Window_2_2_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-170,0})));

    parameter Modelica.Units.SI.Area Window_2_3_A =  3.1362485556184714;
    parameter Modelica.Units.SI.Angle Window_2_3_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_3_azi =  0.0;

    IDEAS.Buildings.Components.Window Window_2_3(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_2_3_A,
        inc=Window_2_3_inc,
        azi=Window_2_3_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-200,0})));

    parameter Modelica.Units.SI.Area Window_2_4_A =  4.1749394503564945;
    parameter Modelica.Units.SI.Angle Window_2_4_inc =  1.5707963267948966;
    parameter Modelica.Units.SI.Angle Window_2_4_azi =  1.5707963267948966;

    IDEAS.Buildings.Components.Window Window_2_4(T_start=T_start,
        redeclare parameter Data.Constructions.Window_Glazing glazing,
        redeclare parameter Data.Constructions.Window_Frame fraType,
        redeclare IDEAS.Buildings.Components.Shading.None shaType,
        A=Window_2_4_A,
        inc=Window_2_4_inc,
        azi=Window_2_4_azi,
        frac=0.2)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-230,0})));

    parameter Modelica.Units.SI.Area Rooftop_2_1_A =  32.625005245296784;
    parameter Modelica.Units.SI.Angle Rooftop_2_1_inc =  0.8723779476598655;
    parameter Modelica.Units.SI.Angle Rooftop_2_1_azi =  -1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall Rooftop_2_1(T_start=T_start,
        A=Rooftop_2_1_A,
        inc=Rooftop_2_1_inc,
        azi=Rooftop_2_1_azi,
        redeclare parameter Data.Constructions.Rooftop constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-260,0})));

    parameter Modelica.Units.SI.Area Rooftop_2_2_A =  54.91378813266793;
    parameter Modelica.Units.SI.Angle Rooftop_2_2_inc =  0.8723779476598655;
    parameter Modelica.Units.SI.Angle Rooftop_2_2_azi =  1.5707963267948966;

    IDEAS.Buildings.Components.OuterWall Rooftop_2_2(T_start=T_start,
        A=Rooftop_2_2_A,
        inc=Rooftop_2_2_inc,
        azi=Rooftop_2_2_azi,
        redeclare parameter Data.Constructions.Rooftop constructionType)
        annotation (Placement(transformation(
            extent={{-5.5,-10.5},{5.5,10.5}},
            rotation=90,
            origin={-290,0})));

    parameter Modelica.Units.SI.Area CommonWall_2_1_A =  23.206913175971785;
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
            origin={-320,0})));
    IDEAS.Buildings.Components.InternalWall InnerWall_2_1(T_start=T_start,
        A=48.27298010432435,
        inc=1.5707963267948966,
        azi=3.141592653589793,
        redeclare parameter Data.Constructions.InnerWall constructionType)
        annotation (Placement(transformation(
            extent={{-5,-10},{5,10}},
            rotation=90,
            origin={-380,0})));

    IDEAS.Buildings.Components.Zone NightZone(T_start=T_start,
        nSurf=14,
        V=190.58190963865604,
        A=56.263004302978466,
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
    connect(DayZone.propsBus[4], OuterWall_1_4.propsBus_a);
    connect(DayZone.propsBus[5], Window_1_1.propsBus_a);
    connect(DayZone.propsBus[6], Window_1_2.propsBus_a);
    connect(DayZone.propsBus[7], Window_1_3.propsBus_a);
    connect(DayZone.propsBus[8], Window_1_4.propsBus_a);
    connect(DayZone.propsBus[9], Rooftop_1_1.propsBus_a);
    connect(DayZone.propsBus[10], GroundFloor_1_1.propsBus_a);
    connect(DayZone.propsBus[11], CommonWall_1_1.propsBus_a);
    connect(DayZone.propsBus[12], InnerWall_1_1.propsBus_b);
    connect(DayZone.propsBus[13], InnerWall_1_1.propsBus_a);
    connect(DayZone.propsBus[14], Floor_1_1.propsBus_a);
    connect(DayZone.TSensor, TSensor[1]);
    connect(DayZone.gainCon, heatPortCon[1]);
    connect(DayZone.gainRad, heatPortRad[1]);

    connect(NightZone.propsBus[1], Floor_1_1.propsBus_b);
    connect(NightZone.propsBus[2], OuterWall_2_1.propsBus_a);
    connect(NightZone.propsBus[3], OuterWall_2_2.propsBus_a);
    connect(NightZone.propsBus[4], OuterWall_2_3.propsBus_a);
    connect(NightZone.propsBus[5], OuterWall_2_4.propsBus_a);
    connect(NightZone.propsBus[6], Window_2_1.propsBus_a);
    connect(NightZone.propsBus[7], Window_2_2.propsBus_a);
    connect(NightZone.propsBus[8], Window_2_3.propsBus_a);
    connect(NightZone.propsBus[9], Window_2_4.propsBus_a);
    connect(NightZone.propsBus[10], Rooftop_2_1.propsBus_a);
    connect(NightZone.propsBus[11], Rooftop_2_2.propsBus_a);
    connect(NightZone.propsBus[12], CommonWall_2_1.propsBus_a);
    connect(NightZone.propsBus[13], InnerWall_2_1.propsBus_b);
    connect(NightZone.propsBus[14], InnerWall_2_1.propsBus_a);
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
end Asbergstraat_18_1574473_Structure;

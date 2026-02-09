within IOCSmod.Demand.BuildingEnvelopes;
package Zaveldriesstraat_54 "House 1 model"

  extends Modelica.Icons.Package;

  package Data "Data for transient thermal building simulation"

    extends Modelica.Icons.MaterialPropertiesPackage;

    package Constructions "Library of building envelope constructions"

      extends Modelica.Icons.MaterialPropertiesPackage;

      record CommonWall  "Construction data of CommonWall"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.GypsumPlasterForFinishing(d=0.02),Data.Materials.MediumMasonryForInteriorApplications(d=0.14)});
      end CommonWall;

      record Floor  "Construction data of Floor"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.CeramicTileForFinishing(d=0.02),Data.Materials.ScreedOrLightCastConcrete(d=0.08), Data.Materials.ExpandedPolystrenemOrEPS(d=0.1), Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.075),Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.075),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
      end Floor;

      record GroundFloor  "Construction data of GroundFloor"
        extends IDEAS.Buildings.Data.Interfaces.Construction(locGain={3},
          final mats={Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.2),Data.Materials.ExpandedPolystrenemOrEPS(d=0.025864660947232342),Data.Materials.ScreedOrLightCastConcrete(d=0.06),Data.Materials.CeramicTileForFinishing(d=0.02)});
        annotation (Documentation(revisions="<html> 
 	 	<ul> 
 	 	<li>March 10, 2024, by Lucas Verleyen:<br> 
 	 	Add locGain={3}.</li> 
 	 	</ul> 
 	 	</html>"));
      end GroundFloor;

      record InnerWall  "Construction data of InnerWall"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.GypsumPlasterForFinishing(d=0.02),Data.Materials.MediumMasonryForInteriorApplications(d=0.1),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
      end InnerWall;

      record OuterWall  "Construction data of OuterWall"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.HeavyMasonryForExteriorApplications(d=0.09),Data.Materials.LargeCavityHorizontalHeatTransfer(d=0.025),Data.Materials.Rockwool(d=0.22593508284818628),Data.Materials.HeavyMasonryForInteriorApplications(d=0.14),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
      end OuterWall;

      record Rooftop  "Construction data of Rooftop"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.Rockwool415TimberForFinishing35(d=0.10822229190018291),Data.Materials.TimberForFinishing(d=0.01),Data.Materials.GypsumPlasterForFinishing(d=0.025)});
      end Rooftop;

      record Window_Frame    "Frame data of Window"
          extends IDEAS.Buildings.Data.Interfaces.Frame(
          present=true,
          U_value=2.1901694997247203,
          redeclare parameter IDEAS.Buildings.Components.ThermalBridges.LineLosses briTyp(psi=0.06, len=2.9602788121746793));
      end Window_Frame;

      record Window_Glazing =
                    IDEAS.Buildings.Data.Glazing.Ins2
        "Glazing data of Window";
    end Constructions;

    package Materials "Library of construction materials"

      extends Modelica.Icons.MaterialPropertiesPackage;

      record CeramicTileForFinishing =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=1.4,
            c=840,
            rho=2100,
            epsLw=0.88,
            epsSw=0.55)
        "Material name: CeramicTileForFinishing, Material ID: 0aba520e-83ff-11e6-920d-2cd444b2e704";
      record DenseCastConcreteAlsoForFinishing =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=1.4,
            c=840,
            rho=2100,
            epsLw=0.88,
            epsSw=0.55)
        "Material name: DenseCastConcreteAlsoForFinishing, Material ID: 0abb8a82-83ff-11e6-8ff5-2cd444b2e704";
      record ExpandedPolystrenemOrEPS =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.036,
            c=1470,
            rho=26,
            epsLw=0.8,
            epsSw=0.8)
        "Material name: ExpandedPolystrenemOrEPS, Material ID: 0abaa033-83ff-11e6-ae46-2cd444b2e704";
      record GypsumPlasterForFinishing =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.6,
            c=840,
            rho=975,
            epsLw=0.85,
            epsSw=0.65)
        "Material name: GypsumPlasterForFinishing, Material ID: 0aba51fd-83ff-11e6-b93d-2cd444b2e704";
      record HeavyMasonryForExteriorApplications =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=1.10,
            c=840,
            rho=1850,
            epsLw=0.88,
            epsSw=0.55)
        "Material name: HeavyMasonryForExteriorApplications, Material ID: 0abaee5a-83ff-11e6-a1cb-2cd444b2e704";
      record HeavyMasonryForInteriorApplications =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.90,
            c=840,
            rho=1850,
            epsLw=0.88,
            epsSw=0.55)
        "Material name: HeavyMasonryForInteriorApplications, Material ID: 0abb1554-83ff-11e6-bed8-2cd444b2e704";
      record LargeCavityHorizontalHeatTransfer =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.1388888888888889,
            c=20,
            rho=1.23,
            epsLw=0.88,
            epsSw=0.55,
            final gas=true)
        "Material name: LargeCavityHorizontalHeatTransfer, Material ID: 0abbb1a0-83ff-11e6-9986-2cd444b2e704";
      record MediumMasonryForInteriorApplications =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.54,
            c=840,
            rho=1400,
            epsLw=0.88,
            epsSw=0.55)
        "Material name: MediumMasonryForInteriorApplications, Material ID: 44500e2c-ad86-11eb-9b6c-484d7ef975f7";
      record Rockwool = IDEAS.Buildings.Data.Interfaces.Material (
            k=0.036,
            c=840,
            rho=110,
            epsLw=0.8,
            epsSw=0.8)
        "Material name: Rockwool, Material ID: 0abb8a8e-83ff-11e6-a195-2cd444b2e704";
      record Rockwool415TimberForFinishing35 =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.042,
            c=920.0,
            rho=144.22,
            epsLw=0.85,
            epsSw=0.85)
        "Material name: Rockwool415TimberForFinishing35, Material ID: 0abb8aa2-83ff-11e6-95cb-2cd444b2e704";
      record ScreedOrLightCastConcrete =
          IDEAS.Buildings.Data.Interfaces.Material (
            k=0.6,
            c=840,
            rho=1100,
            epsLw=0.88,
            epsSw=0.55)
        "Material name: ScreedOrLightCastConcrete, Material ID: 0abb6391-83ff-11e6-8633-2cd444b2e704";
      record TimberForFinishing = IDEAS.Buildings.Data.Interfaces.Material (
            k=0.11,
            c=1880,
            rho=550,
            epsLw=0.86,
            epsSw=0.44)
        "Material name: TimberForFinishing, Material ID: 0abaa02c-83ff-11e6-b0b6-2cd444b2e704";
    end Materials;
  end Data;

  model Zaveldriesstraat_54_1593993
    Zaveldriesstraat_54_1593993_Structure bui(useFluPor=false)
       annotation (Placement(transformation(extent={{-14,-10},{16,10}})));
    inner IDEAS.BoundaryConditions.SimInfoManager sim
      annotation (Placement(transformation(extent={{-96,72},{-76,92}})));
    Modelica.Blocks.Sources.RealExpression occ1(y=1)
      annotation(Placement(transformation(extent={{60, 30}, {40, 50}})));
    Modelica.Blocks.Sources.RealExpression occ2(y=1)
      annotation(Placement(transformation(extent={{60, 10}, {40, 30}})));

  equation
    connect(occ1.y, bui.occ[1]) annotation(Line(points={{39, 40}, {11, 40}, {11, 10}}, color={0, 0, 127}));
    connect(occ2.y, bui.occ[2]) annotation(Line(points={{39, 20}, {11, 20}, {11, 10}}, color={0, 0, 127}));

  annotation(Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Line(points={{-70, 4}, {-70, -86}, {-16, -86}, {-16, -30}, {16, -30}, {16, -86}, {70, -86}, {70, 4}, {0, 74}, {-70, 4}}, color={244, 125, 35}, thickness=0.5),
    Line(points={{-70, 4}, {-76, -2}, {-88, -2}, {0, 86}, {88, -2}, {76, -2}, {70, 4}}, color={244, 125, 35}, thickness=0.5),
    Line(points={{-14, 28}, {14, 28}, {14, 0}, {-14, 0}, {-14, 28}}, color={244, 125, 35}, thickness=0.5),
    Line(points={{30, -30}, {58, -30}, {58, -58}, {30, -58}, {30, -30}}, color={244, 125, 35}, thickness=0.5),
    Line(points={{-58, -30}, {-30, -30}, {-30, -58}, {-58, -58}, {-58, -30}}, color={244, 125, 35}, thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86000, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html> 
 	<p>Q_design = QzoneDay kW (DayZone) &amp; QzoneNight kW (NightZone)</p> 
 	<p>UA_building = UAbuilding W/K</p> 
 	<p>Roof</p> 
 	<ul><li>Side1: Surface1 m2, tilt = Tilt1 rad (Tilt1deg &deg;)</li><li>Side2: Surface2 m2, tilt = Tilt2 rad (Tilt2deg &deg;)<br></li></ul> 
 	</html>",   revisions="<html><ul><li>March 5, 2024, by Lucas Verleyen:<br> Remove mass flow sources and set useFluPor = false.<li>October 9, 2023, by Lucas Verleyen:<br> Initial implementation.</li></ul></html>"));
  end Zaveldriesstraat_54_1593993;

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
      redeclare IDEAS.Buildings.Components.InterzonalAirFlow.FixedPressure
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
      redeclare IDEAS.Buildings.Components.InterzonalAirFlow.FixedPressure
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

  model Zaveldriesstraat_54_TACO
    "Ventilation system to solve problem of InterzonalAirFlow"
    extends Zaveldriesstraat_54_1593993(
      sim(lineariseJModelica=true),
      bui(
        redeclare package Medium = IDEAS.Media.Specialized.DryAir,
        T_start=294.15,
        useFluPor=true),
      occ1(y=occSim.occBus.numOccAwake),
      occ2(y=occSim.occBus.numOccSleep));
    inner BNDF_5GDHC.BaseClasses.Occupancy.OccSimInfoManager occSim
      annotation (Placement(transformation(extent={{-72,72},{-52,94}})));
    Modelica.Fluid.Interfaces.FluidPort_a Sup(redeclare package Medium =
          IDEAS.Media.Water) if isDh "Supply water connection to the DH grid"
      annotation (Placement(transformation(extent={{94,14},{106,26}}),
          iconTransformation(extent={{94,14},{106,26}})));
    Modelica.Fluid.Interfaces.FluidPort_b Ret(redeclare package Medium =
          IDEAS.Media.Water) if isDh "Return water connection to the DH grid"
      annotation (Placement(transformation(extent={{94,-26},{106,-14}}),
          iconTransformation(extent={{94,-26},{106,-14}})));
    IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
          IDEAS.Media.Specialized.DryAir, nPorts=2)
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=90,
          origin={4,48})));
    IDEAS.Fluid.Sources.MassFlowSource_T boundary(
      redeclare package Medium = IDEAS.Media.Specialized.DryAir,
      m_flow=0,
      nPorts=4) annotation (Placement(transformation(extent={{-26,14},{-10,30}})));
  equation
    connect(boundary.ports[1:2], bui.port_b) annotation (Line(points={{-10,
            22.8},{-1,22.8},{-1,10}},
                                color={0,127,255}));
    connect(boundary.ports[3:4], bui.port_a)
      annotation (Line(points={{-10,19.6},{3,19.6},{3,10}}, color={0,127,255}));
    connect(bou.ports[1:2], bui.port_a) annotation (Line(points={{5.6,40},{
            5.6,23.2},{3,23.2},{3,10}},
                                    color={0,127,255}));
  end Zaveldriesstraat_54_TACO;
end Zaveldriesstraat_54;

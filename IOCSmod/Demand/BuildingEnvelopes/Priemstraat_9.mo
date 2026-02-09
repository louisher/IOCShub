within IOCSmod.Demand.BuildingEnvelopes;
package Priemstraat_9 "House 3 model"

  extends Modelica.Icons.Package;

  package Data "Data for transient thermal building simulation"

    extends Modelica.Icons.MaterialPropertiesPackage;

    package Constructions "Library of building envelope constructions"

      extends Modelica.Icons.MaterialPropertiesPackage;

      record Floor  "Construction data of Floor"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.CeramicTileForFinishing(d=0.02),Data.Materials.ScreedOrLightCastConcrete(d=0.08), Data.Materials.ExpandedPolystrenemOrEPS(d=0.1),Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.075),Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.075),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
      end Floor;

      record GroundFloor  "Construction data of GroundFloor"
        extends IDEAS.Buildings.Data.Interfaces.Construction(locGain={3},
          final mats={Data.Materials.DenseCastConcreteAlsoForFinishing(d=0.2),Data.Materials.ExpandedPolystrenemOrEPS(d=0.03128809016143771),Data.Materials.ScreedOrLightCastConcrete(d=0.06),Data.Materials.CeramicTileForFinishing(d=0.02)});
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
          final mats={Data.Materials.HeavyMasonryForExteriorApplications(d=0.09),Data.Materials.LargeCavityHorizontalHeatTransfer(d=0.025),Data.Materials.Rockwool(d=0.05265922077922079),Data.Materials.HeavyMasonryForInteriorApplications(d=0.14),Data.Materials.GypsumPlasterForFinishing(d=0.02)});
      end OuterWall;

      record Rooftop  "Construction data of Rooftop"
        extends IDEAS.Buildings.Data.Interfaces.Construction(
          final mats={Data.Materials.Rockwool415TimberForFinishing35(d=0.11148316146540027),Data.Materials.TimberForFinishing(d=0.01),Data.Materials.GypsumPlasterForFinishing(d=0.025)});
      end Rooftop;

      record Window_Frame    "Frame data of Window"
          extends IDEAS.Buildings.Data.Interfaces.Frame(
          present=true,
          U_value=4.417200337866755,
          redeclare parameter IDEAS.Buildings.Components.ThermalBridges.LineLosses briTyp(psi=0.06, len=4.189299516776689));
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
        "Material name: MediumMasonryForInteriorApplications, Material ID: 0aba7915-83ff-11e6-8883-2cd444b2e704";
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

  model Priemstraat_9_1595127
    Priemstraat_9_1595127_Structure bui(useFluPor=false)
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
  end Priemstraat_9_1595127;

  model Priemstraat_9_1595127_Structure "Structure of Priemstraat_9_1595127"
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

      parameter Modelica.Units.SI.Area OuterWall_1_1_A =  29.45637268897832;
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

      parameter Modelica.Units.SI.Area OuterWall_1_2_A =  30.81855320276413;
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

      parameter Modelica.Units.SI.Area OuterWall_1_3_A =  29.05893075800219;
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

      parameter Modelica.Units.SI.Area OuterWall_1_4_A =  31.86383347146197;
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

      parameter Modelica.Units.SI.Area Window_1_1_A =  4.8750640114626105;
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

      parameter Modelica.Units.SI.Area Window_1_2_A =  5.1005064741171395;
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

      parameter Modelica.Units.SI.Area Window_1_3_A =  4.809286908667029;
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

      parameter Modelica.Units.SI.Area Window_1_4_A =  5.273501576862005;
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

      IDEAS.Buildings.Components.SlabOnGround GroundFloor_1_1(T_start=T_start,
          A=166.9929237365723,
          inc=0.0,
          azi=0.0,
          redeclare parameter Data.Constructions.GroundFloor constructionType)
          annotation (Placement(transformation(
              extent={{-5,-10},{5,10}},
              rotation=90,
              origin={-230,-60})));

      IDEAS.Buildings.Components.InternalWall InnerWall_1_1(T_start=T_start,
          A=113.0048392738523,
          inc=1.5707963267948966,
          azi=3.141592653589793,
          redeclare parameter Data.Constructions.InnerWall constructionType)
          annotation (Placement(transformation(
              extent={{-5,-10},{5,10}},
              rotation=90,
              origin={-290,-60})));

      IDEAS.Buildings.Components.InternalWall Floor_1_1(T_start=T_start,
          A=166.9929237365723,
          inc=Modelica.Constants.pi,
          azi=0.0,
          redeclare parameter Data.Constructions.Floor constructionType)
          annotation (Placement(transformation(
              extent={{-5,-10},{5,10}},
              rotation=90,
              origin={-320,-60})));

      IDEAS.Buildings.Components.Zone DayZone(T_start=T_start,
          nSurf=12,
          V=513.4283962668568,
          A=166.99292373657232,
          n50=8.0,
          fRH=22,
          allowFlowReversal=false,
          redeclare package Medium = Medium,
      redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure
        interzonalAirFlow,
       redeclare IDEAS.Buildings.Components.Occupants.Input occNum) "Thermal zone: DayZone"
          annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

      parameter Modelica.Units.SI.Area OuterWall_2_1_A =  29.45637268897829;
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

      parameter Modelica.Units.SI.Area OuterWall_2_2_A =  30.818553202764093;
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

      parameter Modelica.Units.SI.Area OuterWall_2_3_A =  29.058930758002163;
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

      parameter Modelica.Units.SI.Area OuterWall_2_4_A =  31.863833471461938;
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

      parameter Modelica.Units.SI.Area Window_2_1_A =  4.875064011462605;
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

      parameter Modelica.Units.SI.Area Window_2_2_A =  5.100506474117134;
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

      parameter Modelica.Units.SI.Area Window_2_3_A =  4.809286908667024;
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

      parameter Modelica.Units.SI.Area Window_2_4_A =  5.2735015768619995;
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

      parameter Modelica.Units.SI.Area Rooftop_2_1_A =  94.5184475636757;
      parameter Modelica.Units.SI.Angle Rooftop_2_1_inc =  0.4378813710731626;
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

      parameter Modelica.Units.SI.Area Rooftop_2_2_A =  89.87139467427471;
      parameter Modelica.Units.SI.Angle Rooftop_2_2_inc =  0.4378813710731626;
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

      IDEAS.Buildings.Components.InternalWall InnerWall_2_1(T_start=T_start,
          A=113.0048392738522,
          inc=1.5707963267948966,
          azi=3.141592653589793,
          redeclare parameter Data.Constructions.InnerWall constructionType)
          annotation (Placement(transformation(
              extent={{-5,-10},{5,10}},
              rotation=90,
              origin={-350,0})));

      IDEAS.Buildings.Components.Zone NightZone(T_start=T_start,
          nSurf=13,
          V=513.4283962668563,
          A=166.99292373657215,
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
      connect(DayZone.propsBus[9], GroundFloor_1_1.propsBus_a);
      connect(DayZone.propsBus[10], InnerWall_1_1.propsBus_b);
      connect(DayZone.propsBus[11], InnerWall_1_1.propsBus_a);
      connect(DayZone.propsBus[12], Floor_1_1.propsBus_a);
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
      connect(NightZone.propsBus[12], InnerWall_2_1.propsBus_b);
      connect(NightZone.propsBus[13], InnerWall_2_1.propsBus_a);
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
  end Priemstraat_9_1595127_Structure;
end Priemstraat_9;

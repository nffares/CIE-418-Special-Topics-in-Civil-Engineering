(* ::Package:: *)

(* ::Title:: *)
(*shearWalls*)


(* ::Subsubtitle:: *)
(*Last modified: August 29, 2011*)


(* ::Section::Closed:: *)
(*Basic Documentation*)


(* ::Text:: *)
(*(* :Title: shearWalls.m *)*)
(**)
(*(* :Context: NFPackages`shearWalls` *)*)
(**)
(*(* :Author: Nabil F Fares *)*)
(**)
(*(* :Summary:*)
(*This package contains procedures to analyze shear walls*)
(* *)*)
(* *)
(*(* :Copyright: none *)*)
(**)
(*(* :Package Version: 1.0 *)*)
(**)
(*(* :Mathematica Version: 7.0  *)*)
(**)
(*(* :History:*)
(**)*)
(**)
(*(* :Keywords: structures, members, analysis, shear walls  *)*)
(**)
(*(* :Sources:*)
(*   Nabil Fares: some of the sections below may have theory notes*)
(**)*)
(**)
(*(* :Warnings:*)
(*   This package may not run with Mathematica versions prior to 7.0*)
(**)*)
(**)
(*(* :Limitations:*)
(**)*)
(**)
(*(* :Discussion:*)
(**)*)
(**)
(*(* :Requirements:*)
(**)*)


(* ::Section::Closed:: *)
(*Pre-amble*)


(* ::Subsection::Closed:: *)
(*Set up the package context, including any imports*)


BeginPackage["NFPackages`shearWalls`", { "Units`"} ];


(* ::Subsection::Closed:: *)
(*Disable annoying spell warnings*)


Off[ General::spell];
Off[ General::spell1];


(* ::Subsection::Closed:: *)
(*Usage messages for the exported functions and the context itself *)


(* ::Subsubsection::Closed:: *)
(*Package usage message*)


shearWalls::usage = "shearWalls is a package to analyze shear walls alone or in a building.\n" <>
"";


(* ::Subsubsection::Closed:: *)
(*shearWalls key access words*)


shearSlabKeysGetList::usage = "shearSlabKeysGetList is a list of all key words used in sending messages to shearSlabGet.";


shearSlabKeysPutList::usage = "shearSlabKeysGetList is a list of all key words used in sending messages to shearSlabPut.";


shearWallKeysGetList::usage = "shearWallKeysGetList is a list of all key words used in sending messages to shearWallGet.";


shearWallKeysPutList::usage = "shearWallKeysPutList is a list of all key words used in sending messages to shearWallPut.";


shearBuildingKeysGetList::usage = "shearBuildingKeysGetList is a list of all key words used in sending messages to shearBuildingGet.";


shearBuildingKeysPutList::usage = "shearBuildingKeysGetList is a list of all key words used in sending messages to shearBuildingPut.";


(* ::Subsubsection:: *)
(*Other key words*)


(* ::Subsubsection::Closed:: *)
(*Objects*)


shearSlab::usage = "shearSlab[ serial # ] represents a shearSlab object.  Once created, values associated with this slab may be viewed and/or changed and various calculations may be done using the specific slab's data.";


shearWall::usage = "shearWall[ serial # ] represents a shearWall object.  Once created, values associated with this shear wall may be viewed and/or changed and various calculations may be done using the specific shear wall's data.";


shearBuilding::usage = "shearBuilding[ serial # ] represents a shearBuilding object.  Once created, values associated with this building containing one or more floors with each floor containing one or more shear walls may be viewed and/or changed and various calculations may be done using the specific shear floor's data.";


(* ::Subsubsection:: *)
(*-------------------------------------------------------------------------------------------------------*)


(* ::Subsubsection::Closed:: *)
(*Utilities*)


getUnitlessValue::usage = "getUnitlessValue[ expr, whatUnits ] obtains the value without the units for the specified expression.";


getMeterValue::usage = "getMeterValue[ expr ] obtains the value without the length units in meters for the specified expression.";


showStickBuilding::usage = "showStickBuilding[ dofs:{{_, _, _} ... }, heightsList, {scaleDisplacement, scaleRotation}, rotationLineLengthFraction, directivesForMainLine, directivesForTransverseLines, directivesForMainPoints, directivesForTransversePoints, initailDirectionOfTransverseLines, \"track\", nTrack, trackOpacity_Opacity ] ... or same but omit \"track\", nTrack, trackOpacity_Opacity or showStickBuilding[ \"initial\" ] to initial tracking figures.";


(* ::Subsubsection::Closed:: *)
(*Earthquake records*)


shearWallsEarthquakeRecords::usage = "shearWallsEarthquakeRecords[ eqName ] gives time versus acceleration of an earthquake.  shearWallsEarthquakeRecords[] gives all the available earthquakes.\n" <>
"\nNote:\n" <>
"\[Bullet]  Time is in seconds and acceleration is in m/\!\(\*SuperscriptBox[\(s\), \(2\)]\)\n" <>
"";


(* ::Text:: *)
(*shearWallsEarthquakeRecords[ "El Centro 1940" ]*)


(* ::Subsubsection::Closed:: *)
(*Response spectra*)


$responseSpectrumAvailable::usage = "$responseSpectrumAvailable returns the available response spectra functions that are available.";


responseSpectrumAccelerationEurocodeElastic2004::usage = 
"responseSpectrumAccelerationEurocodeElastic2004[ periodOfSDOF ] returns the acceleration in m/s^2 (meters per second per second).  accelerationResponseSpectrumFunction[] returns a grid depiction of the defaults used in options.  Options allow customizing the spectrum function including setting up some reference magnitude for the acceleration (see Options[ accelerationResponseSpectrumFunction ]).";


responseSpectrumAccelerationElCentro1940::usage = 
"responseSpectrumAccelerationElCentro1940[ T, \[Xi] ] gives the value of the response spectrum for the (true) acceleration of the 1940 El-Centro earthquake in m / s^2 (meters per second per second).  The period 'T' is measured in seconds and damping ratio '\[Xi]' is non-dimensional.";


responseSpectrumVelocityElCentro1940::usage = 
"responseSpectrumVelocityElCentro1940[ T, \[Xi] ] gives the value of the response spectrum for the (true) velocity of the 1940 El-Centro earthquake in m / s (meters per second).  The period 'T' is measured in seconds and damping ratio '\[Xi]' is non-dimensional.";


responseSpectrumDisplacementElCentro1940::usage = 
"responseSpectrumDisplacementElCentro1940[ T, \[Xi] ] gives the value of the response spectrum for the (true) displacement of the 1940 El-Centro earthquake in m (meters).  The period 'T' is measured in seconds and damping ratio '\[Xi]' is non-dimensional.";


(* ::Subsubsection:: *)
(*-------------------------------------------------------------------------------------------------------*)


(* ::Subsubsection::Closed:: *)
(*shearSlab options*)


shearSlabDOF::usage = "shearSlabDOF is an option associated with shearSlab objects.  It specifies the triplet {ux, uy, \[Theta]} for the slab where 'ux' and 'uy' are dimensionless but assumed to be in meters and '\[Theta]' is in radians.";


shearSlabCenterOfRotation::usage = 
"shearSlabCenterOfRotation is an option associated with shearSlab objects.  It specifies the coordinate pair {xc, yc} for the slab as dimensionless values but assumed to be in meters, around which the rotation associated with the degrees of freedom is specified.";


shearSlabDisplacementScaleFactor::usage = 
"shearSlabDisplacementScaleFactor is an option associated with shearSlab objects.  It specifies a scale factor to multiply the displacements when drawing a graphical representation of the slab.";


shearSlabRotationScaleFactor::usage = 
"shearSlabRotationScaleFactor is an option associated with shearSlab objects.  It specifies a scale factor to multiply the rotation when drawing a graphical representation of the slab.";


shearSlabDrawType::usage = 
"shearSlabDrawType is an option associated with shearSlab objects.  It specifies the type of graphic to use to represent the slab (eg. Line or Polygon).";


shearSlabView::usage = 
"shearSlabView is an option associated with shearSlab objects.  It specifies the view in which to present a shearSlab object.  Allowable values are List, Table or Grid.";


shearSlabZCoordinate::usage = 
"shearSlabZCoordinate is an option associated with shearSlab objects.  It specifies the z-coordinate as a dimensionless value but assumed to be in meters of the z-coordinate of the slab.";


shearSlabDirectives::usage = 
"shearSlabDirectives is an option associated with shearSlab objects.  It specifies the graphic directives with which to render the slab.";


shearSlabShowDeformedQ::usage =  
"shearSlabShowDeformedQ is an option associated with shearSlab objects.  If True then it shows the slab in the deformed configuration otherwise in the original configuration.";


shearSlabEdit::usage = 
"shearSlabEdit is an option associated with shearSlab objects.  If True, it allows the editing of slab parameters when seeing specs (see 'shearSlabSpecs').";


(* ::Subsubsection::Closed:: *)
(*shearSlab messages*)


shearSlabThickness::usage = "shearSlabThickness is a keyword that may be sent to shearSlab objects to get or set its value.  This keyword is associated with the thickness of the slab.\n" <>
"Note:\n" <>
"\[Bullet] Thickness must be expressed as a non-dimensionless value but is assumed to have units of length.";


shearSlabOuterBorder::usage = "shearSlabOuterBorder is a keyword that may be sent to shearSlab objects to get or set its value.  This keyword is associated with the list of coordinates as dimensionless pairs identifying the outer border of the slab but assumed to be in meters.\n" <>
"Note:\n" <>
"\[Bullet] Border points must be expressed as dimensionless pairs but are assumed to be in meters.\n" <>
"\[Bullet] It is allowed to either repeat the first point at the end of the list or to omit it.  In either case, the border is assumed to be a close contour where the first point equals the last point.";


shearSlabSpecificGravity::usage = 
"shearSlabSpecificGravity is a keyword that may be sent to shearSlab objects to get or set its value.  This keyword is associated with the specific gravity of the slab.\n" <>
"Note:\n" <>
"\[Bullet] Specific gravity is a dimensionaless quantity.";


shearSlabExistsQ::usage = 
"shearSlabExistsQ is a keyword that may be sent to shearSlab objects to (only) get its value.  When getting its value, the result is True only if the slab has been defined and not deleted.\n" <>
"Note:\n" <>
"\[Bullet] shearSlabExistsQ[ aSlab ] is equivalent to shearSlabGet[ aSlab, shearSlabExistsQ ].\n" <>
"";


shearSlabAdditionalDeadMassAtCentroid::usage = "shearSlabAdditionalDeadMassAtCentroid is a keyword that may be sent to shearSlab objects to get or set its value.  This keyword is associated with an additional dead mass assumed to act at the centroid of the slab.\n" <>
"Note:\n" <>
"\[Bullet] Dead mass must be expressed as dimensionless value but assumed to have units of Kilograms.";


(* ::Subsubsection::Closed:: *)
(*shearSlab methods*)


shearSlabNew::usage = "shearSlabNew[  outerBorderSpec ] creates a new object of type shearSlab.\n" <>
"Note:\n" <>
"\[Bullet] 'outerBorderSpec' may either be a list of pairs of coordinates each specified as dimensionless values, but assumed to be in meters, or a valid 'shearBuilding' object.  If a 'shearBuilding' object is specified then the slab will be a rectangle that exactly fits all the walls." <>
"\[Bullet] Most parameters are set by options.\n" <>
"\[Bullet] Use SetOptions[ shearSlabNew, someOption -> value, otherOption -> value ...] to set defaults for these options if needed.\n" <>
"\[Bullet] All values are checked before they are assigned.  This includes the case when using SetOptions to set defaults.\n" <>
"\[Bullet] Values may be specified partially symbolically.  For example, the thickness may be specified as 'h' with 'h' being specified later.  This does create the possibility of using inconsistent units if 'h' is later specifed inconsistently.";


shearSlabDraw::usage = "shearSlabDraw[ aShearSlab ] returns graphics primitives representing a shear slab in 3-D.";


shearSlabDraw2D::usage = "shearSlabDraw2D[ aShearSlab ] returns graphics primitives representing a shear slab in 2-D.  The thickness (z) direction is ignored.";


shearSlabSpecs::usage = "shearSlabSpecs[ aShearSlab ] returns a list, table or grid presentation of the data associated with aShearSlab.\n" <>
"\nNote:\n" <>
"\[Bullet] The option shearSlabView may take the values List, Table or Grid to present different views of the data.\n" <>
"\[Bullet] The option shearSlabEdit may be set to True in order to allow in-place editing of values.\n" <>
"";


shearSlabClearAll::usage = "shearSlabClearAll[] clears all shearSlab objects and their values and also resets default options.";


shearSlabGet::usage = "shearSlabGet[ aShearSlab, whatToGet ] returns the value of 'whatToGet' if it is a valid keyword for shearSlabGet.\n" <>
"Note:\n" <>
"\[Bullet] Check the members of the list in 'shearSlabKeysGetList' to obtain the list of keywords that may be used.\n" <>
"\[Bullet] Some keywords may be used with shearSlabGet but not with shearSlabPut.";


shearSlabPut::usage = "shearSlabPut[ aShearSlab, whatToPut, someValue ] puts the value 'someValue' into the keyword 'whatToPut' for the shear slab 'aShearSlab'.\n" <>
"Note:\n" <>
"\[Bullet] The value 'someValue' will be checked before the value is put in 'whatToPut'.  If the value is not suitable then a message is given and the value is not put.\n" <>
"\[Bullet] Check the members of the list in 'shearSlabKeysPutList' to obtain the list of keywords that may be used.\n" <>
"\[Bullet] Some keywords may be used with shearSlabGet but not with shearSlabPut.\n" <>
"";


shearSlabDeepClone::usage = "shearSlabDeepClone[ aShearSlab ] returns a new shearSlab copy that is an exact copy of the input " <>
"but is independent and not affected by changes in the original";


shearSlabCentroid::usage = "shearSlabCentroid[ aShearSlab ] returns the coordinates of the centroid of the slab.  The result is a non-dimensional quantity but assumed to be in meters.";


shearSlabArea::usage = "shearSlabArea[ aShearSlab ] returns the area of the slab.  The result is a non-dimensional quantity but assumed to be in \!\(\*SuperscriptBox[\(m\), \(2\)]\).";


shearSlabPolarMomentOfInertiaRelativeToCentroid::usage = "shearSlabPolarMomentOfInertiaRelativeToCentroid[ aShearSlab ] returns the polar moment of inertia relative to the centroid of the slab.  The result is a non-dimensional quantity but assumed to be in \!\(\*SuperscriptBox[\(m\), \(4\)]\).";


shearSlabMassSlabOnly::usage = "shearSlabMassSlabOnly[ aShearSlab ] returns the mass of the slab that does NOT include the additional dead load specified.  The result is a non-dimensional quantity but assumed to be in Kg.";


shearSlabMassSlabAndDeadMass::usage = "shearSlabMassSlabAndDeadMass[ aShearSlab ] returns the mass of the slab plus the specified dead load.  The result is a non-dimensional quantity but assumed to be in Kg.";


shearSlabMassPolarMomentOfInertiaRelativeToCentroid::usage = "shearSlabMassPolarMomentOfInertiaRelativeToCentroid[ aShearSlab ] returns the mass polar moment of inertia of the slab \[Integral] \!\(\*SuperscriptBox[\(r\), \(2\)]\)dm.  The result is a non-dimensional quantity but assumed to be in Kg \!\(\*SuperscriptBox[\(m\), \(2\)]\).";


shearSlabXYminmaxPairsList::usage = "shearSlabXYminmaxPairsList[ aShearSlab ] returns the list {{xMin, xMax}, {yMin, yMax}} where 'x' and 'y' denote the 'x' and 'y' coordinates respectively. These bounds on the coordinates represent the smallest rectangle that can enclose the slab.  The result is a non-dimensional quantity but assumed to be in m.";


shearSlabPolarMomentOfInertiaRelativeToSpecifiedCenter::usage = "shearSlabPolarMomentOfInertiaRelativeToSpecifiedCenter[ aShearSlab, {xc, yc} ] returns the polar moment of inertia of the slab relative to the coordinate {xc, yc}.  The coordinates {xc, yc} are non-dimensional quantities but are assumed to be in m.  The result is a non-dimensional quantity but assumed to be in \!\(\*SuperscriptBox[\(m\), \(4\)]\).";


shearSlabMassPolarMomentOfInertiaRelativeToSpecifiedCenter::usage = "shearSlabMassPolarMomentOfInertiaRelativeToSpecifiedCenter[ aShearSlab, {xc, yc} ] returns the mass polar moment of inertia of the slab \[Integral] \!\(\*SubsuperscriptBox[\(r\), \(c\), \(2\)]\)dm relative to the coordinate {xc, yc} (note: \!\(\*SubscriptBox[\(r\), \(c\)]\) is the distance of a point to the center {xc, yc})  The coordinates {xc, yc} are non-dimensional quantities but are assumed to be in m.  The result is a non-dimensional quantity but assumed to be in kg \!\(\*SuperscriptBox[\(m\), \(2\)]\).";


(* ::Subsubsection:: *)
(*-------------------------------------------------------------------------------------------------------*)


(* ::Subsubsection::Closed:: *)
(*shearWall options*)


shearWallHeightList::usage = 
"shearWallHeightList is an option associated with shearWall objects.  It specifies the floor-to-floor (center-to-center) height list used in some procedures.  The heights are specified dimensionless but are assumed to be in Meters.";


shearWallNumberOfFloors::usage = 
"shearWallNumberOfFloors is an option associated with shearWall objects.  It specifies the number of floors to be used in some procedures.";


shearWallCenterOfRotationRules::usage = "shearWallCenterOfRotationRules is an option associated with shearWall objects.  It specifies rules for the center of rotation at each floor for the rotational degrees of freedom.  The ground floor is assumed fixed.  The coordinates are assumed to be dimensionless but are assumed to be in Meters.";


shearWallDisplacementScaleFactor::usage = "shearWallDisplacementScaleFactor is an option associated with shearWall objects.  It specifies the displacement scale factor when drawing the deformed form of a wall.";


shearWallRotationScaleFactor::usage = "shearWallRotationScaleFactor is an option associated with shearWall objects.  It specifies the rotation scale factor when drawing the deformed form of a wall.";


shearWallDOFList::usage = "shearWallDOFList is an option associated with shearWall objects.  It specifies the degrees of freedom (DOF) at each floor.  These may be arranged or ordered either in \"floor\" ordering or in \"building\" ordering (see shearBuilding related procedures).  All degrees of freedom are specified nondimensionally but displacements are assumed to be in Meters while rotations in radians.";


shearWallView::usage = "shearWallView is an option associated with shearWall objects.  It specifies the view in which to present a shearWall object.  Allowable values are List, Table or Grid.";


shearWallDrawType::usage = "shearWallDrawType is an option associated with shearWall objects.  It specifies the way to draw shearWall object.  Allowable values are Polygon, Line or Automatic.";


shearWallDirectives::usage = 
"shearWallDirectives is an option associated with shearWall objects.  It specifies the directives (using Directive[ ... ]) to draw shearWall object.";


shearWallAnnotateStyleFunction::usage = 
"shearWallAnnotateStyleFunction is an option associated with shearWall objects.  It specifies a styling function for the annotation on the wall.";


shearWallAnnotateTextList::usage = 
"shearWallAnnotateTextList is an option associated with shearWall objects.  It specifies the list of text (or expressions) to be shown near corresponding walls at each floor starting with the first floor.";


shearWallAnnotateAlongPositiveNormalQ::usage = 
"shearWallAnnotateAlongPositiveNormalQ is an option associated with shearWall objects.  It specifies the whether annotation is along positive or negative normal from wall.";


shearWallAnnotateDistanceFromWall::usage = 
"shearWallAnnotateDistanceFromWall is an option associated with shearWall objects.  It specifies the distance from the wall centroid along normal in which to show the annotation.  This specification is unitless but assumed to be in Meters.";


shearWallAnnotateOrientation::usage = 
"shearWallAnnotateOrientation is an option associated with shearWall objects.  It specifies the orientation of the text in which to show the annotation.  If the value is Automatic then the text will be shown parallel to the wall and always in an orientation that can be read (ie. not upside down).";


shearWallShowDeformedQ::usage = 
"shearWallShowDeformedQ is an option associated with shearWall objects.  If True, it shows the wall after deformation otherwise in the initial configuration.";


shearWallEdit::usage = 
"shearWallEdit is an option associated with shearWall objects.  If True, it allows the editing of wall parameters when seeing specs (see 'shearWallSpecs').";


shearWallDOFOrdering::usage = 
"shearWallDOFOrdering is an option associated with shearWall objects.  It specifies the ordering of the degrees of freedom.\n" <>
"Note:\n"<>
"\[Bullet] The values of this option may be \"building\", \"Building\", \"floor\" or \"Floor\".\n" <>
"\[Bullet] In the case of \"building\" or \"Building\", the degrees of freedom are ordered as {\!\(\*SubscriptBox[\(u\), \(x1\)]\), \!\(\*SubscriptBox[\(u\), \(x2\)]\), \!\(\*SubscriptBox[\(u\), \(x3\)]\), \[Ellipsis] \!\(\*SubscriptBox[\(u\), \(xn\)]\), \!\(\*SubscriptBox[\(u\), \(y1\)]\), \!\(\*SubscriptBox[\(u\), \(y2\)]\), \!\(\*SubscriptBox[\(u\), \(y3\)]\), \[Ellipsis] \!\(\*SubscriptBox[\(u\), \(yn\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(1\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(2\)]\), \[Ellipsis] \!\(\*SubscriptBox[\(\[Theta]\), \(n\)]\)}\n"<>
"\[Bullet] In the case of \"floor\" or \"Floor\", the degrees of freedom are ordered as {\!\(\*SubscriptBox[\(u\), \(x1\)]\), \!\(\*SubscriptBox[\(u\), \(y1\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(1\)]\), \!\(\*SubscriptBox[\(u\), \(x2\)]\), \!\(\*SubscriptBox[\(u\), \(y2\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(2\)]\),  \[Ellipsis] \!\(\*SubscriptBox[\(u\), \(xn\)]\), \!\(\*SubscriptBox[\(u\), \(yn\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(n\)]\)}";


(* ::Subsubsection::Closed:: *)
(*shearWall messages*)


shearWallBaseStartCoordinates::usage = "shearWallBaseStartCoordinates is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the start coordinates (x, y) of the base (longest part) of the wall.\n" <>
"Note:\n" <>
"\[Bullet] Start coordinates must be a list of pairs {x, y} expressed dimensionless but assumed to be in Meters.";


shearWallBaseEndCoordinates::usage = "shearWallBaseEndCoordinates is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the end coordinates (x, y) of the base (longest part) of the wall.\n" <>
"Note:\n" <>
"\[Bullet] End coordinates must be a list of pairs {x, y} expressed dimensionless but assumed to be in Meters.";


shearWallIncludeWhatStiffness::usage = "shearWallIncludeWhatStiffness is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with identifying what type of stiffness to include in calculating the member stiffness of the wall.  Allowable values are 'shearWallIncludeBendingTypeOnly', 'shearWallIncludeShearTypeOnly' and 'shearWallIncludeShearAndBendingTypes'.";


shearWallBaseLength::usage = "shearWallBaseLength is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the length of the base of the shear wall.  When the length of the base of a shear wall is set using shearWallPut, the end coordinate is changed so that the wall has the same direction but the new length that is specified.\n" <>
"Note:\n" <>
"\[Bullet] Length must be expressed dimensionless but assumed to be in Meters.";


shearWallLengthAtFloor::usage = "shearWallLengthAtFloor is a keyword that may be sent to shearWall objects to get its value.  This keyword is associated with the length of the shear wall at a specified floor level.  The length of a shear wall at a given level is set by changing the start and end local coordinates that are fractions of the base length (see 'shearWallStartEndLengthFractionsRules').\n" <>
"Note:\n" <>
"\[Bullet] Length is expressed as dimensionless but assumed to be in Meters.";


shearWallThicknessRules::usage = "shearWallThicknessRules is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with a list of rules that specifies the thickness of the wall at any floor.\n" <>
"Note:\n" <>
"\[Bullet] Thickness must be expressed dimensionless but assumed to be in Meters.";


shearWallThicknessAtFloor::usage = "shearWallThicknessAtFloor is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the thickness of the shear wall at a specified floor level.  The thickness of a shear wall at a given level is set by changing the thickness rules (see 'shearWallThicknessRules').\n" <>
"Note:\n" <>
"\[Bullet] Thickness is expressed as dimensionless but assumed to be in Meters.";


shearWallStartEndLengthFractionsRules::usage = "shearWallStartEndLengthFractionsRules is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with a list of rules that specifies a local coordinate for the start and end of the wall at each level.  Local coordinates must be between 0 and 1 where 0 is at the base start coordinate and 1 at the base end coordinate.  Also, the start coordinate must be less than the end coordinate.\n" <>
"Note:\n" <>
"\[Bullet] Length fractions are dimensionless";


shearWallExistsQ::usage = "shearWallExistsQ is a keyword that may be sent to shearWall objects to get its value.  This keyword returns True if the wall exists and False otherwise.\n" <>
"Note:\n" <>
"\[Bullet] shearWallExistsQ may be used as a keyword or as a function as in shearWallExistsQ[ aShearWall ].   This is equivalent to shearWallGet[ aShearWall, shearWallExistsQ ].\n" <>
"\[Bullet] The value of shearWallExistsQ may not be directly set.  It is set to True automatically when a wall is created with shearWallNew and set to False automatically with shearWallClearAll[].  A wall that has not been created returns by default False.";


shearWallShearModulus::usage = "shearWallShearModulus is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the shear modulus (usually denoted by G or \[Mu]) of the wall.\n" <>
"Note:\n" <>
"\[Bullet] Shear modulus must be expressed dimensionless but assumed to be in Giga Pascal.";


shearWallYoungsModulus::usage = "shearWallYoungsModulus is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with Young's modulus (usually denoted by E) of the wall.\n" <>
"Note:\n" <>
"\[Bullet] Young's modulus must be expressed dimensionless but assumed to be in Giga Pascal.";


shearWallStartEndLengthFractionsAtFloor::usage = 
"shearWallStartEndLengthFractionsAtFloor is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the start-end length fractions of the shear wall at a specified floor level.  This pair of values of a shear wall at a given level is set by changing the start-end length fraction rules (see 'shearWallStartEndLengthFractionsRules').\n" <>
"Note:\n" <>
"\[Bullet] Start-end length fractions are dimensionless.";


shearWallStartCoordinatesAtFloor::usage = 
"shearWallStartCoordinatesAtFloor is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the starting coordinate of the shear wall at a specified floor level.  This coordinate of a shear wall at a given level is set by changing either the base coordinate or the start-end length fractions rules (see 'shearWallStartEndLengthFractionsRules' and 'shearWallBaseStartCoordinates').\n" <>
"Note:\n" <>
"\[Bullet] Coordinates are expressed as dimensionless but assumed to be in Meters.";


shearWallEndCoordinatesAtFloor::usage = 
"shearWallEndCoordinatesAtFloor is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the end coordinate of the shear wall at a specified floor level.  This coordinate of a shear wall at a given level is set by changing either the base coordinate or the start-end length fractions rules (see 'shearWallStartEndLengthFractionsRules' and 'shearWallBaseEndCoordinates').\n" <>
"Note:\n" <>
"\[Bullet] Coordinates are expressed as dimensionless but assumed to be in Meters.";


shearWallSpecificGravity::usage = 
"shearWallSpecificGravity is a keyword that may be sent to shearWall objects to get or set its value.  This keyword is associated with the specific gravity of the wal.\n" <>
"Note:\n" <>
"\[Bullet] Specific gravity is a dimensionaless quantity.";


shearWallIncludeMassQ::usage = "shearWallIncludeMassQ is a keyword that may be sent to shearWall objects to get its value.  This keyword returns True if the mass of the wall will be included in the mass matrix of the building and False otherwise.\n" <>
"Note:\n" <>
"\[Bullet] The calculation of the mass and summaries will still be done but the mass will not contribute to the dynamics of the building.";


(* ::Subsubsection::Closed:: *)
(*shearWall keywords*)


shearWallIncludeBendingTypeOnly::usage = 
"shearWallIncludeBendingTypeOnly is a keyword that may be sent to shearWall objects as the value to put into or get from shearWallIncludeWhatStiffness.  This keyword indicates that only the bending stiffness should be included in calculating the stiffness of the shear wall.";


shearWallIncludeShearTypeOnly::usage = 
"shearWallIncludeShearTypeOnly is a keyword that may be sent to shearWall objects as the value to put into or get from shearWallIncludeWhatStiffness.  This keyword indicates that only the shear stiffness should be included in calculating the stiffness of the shear wall.";


shearWallIncludeShearAndBendingTypes::usage = 
"shearWallIncludeShearAndBendingTypes is a keyword that may be sent to shearWall objects as the value to put into or get from shearWallIncludeWhatStiffness.  This keyword indicates that both the shear and bending stiffnesses should be included (in series; sum of reciprocals) in calculating the stiffness of the shear wall.";


(* ::Subsubsection::Closed:: *)
(*shearWall methods*)


shearWallClearAll::usage = "shearWallClearAll[] clears all shearWall objects and their values and also resets default options.";


shearWallCheck::usage = "shearWallCheck[ whatToCheck, proposedValue ] returns True if 'proposedValue' is a valid value for 'whatToCheck'.";


shearWallGet::usage = "shearWallGet[ aShearWall, whatToGet ] returns the value of 'whatToGet' if it is a valid keyword for shearWallGet.\n" <>
"Note:\n" <>
"\[Bullet] Check the members of the list in shearWallKeysGetList to obtain the list of keywords that may be used.\n" <>
"\[Bullet] Some keywords may be used with shearWallGet but not with shearWallPut.";


shearWallPut::usage = "shearWallPut[ aShearWall, whatToPut, someValue ] puts the value 'someValue' into the keyword 'whatToPut' for the shear wall 'shearWall'.\n" <>
"Note:\n" <>
"\[Bullet] The value 'someValue' will be checked before the value is put in 'whatToPut'.  If the value is not suitable then a message is given and the value is not put.\n" <>
"\[Bullet] Check the members of the list in shearWallKeysPutList to obtain the list of keywords that may be used.\n" <>
"\[Bullet] Some keywords may be used with shearWallGet but not with shearWallPut.\n" <>
"";


shearWallUnitVectorAlongWall::usage = "shearWallUnitVectorAlongWall[ aShearWall ] returns a list {tx, ty} representing the components of a unit vector along the wall direction pointing from the start to the end coordinate.";


shearWallDisplacementMagnitudesAlongWall::usage = "shearWallDisplacementMagnitudesAlongWall[ aShearWall, dofList ] returns a list of displacements {u1, u2, ...} where the u's are the wall displacement magnitudes parallel (in the direction start to end coordinates) to the wall at each floor level starting from the first floor.\n" <>
"\nNote:\n" <>
"\[Bullet] The dofList is the degrees of freedom list and is specified non-dimensionally.  Displacements are assumed to be in Meters and rotations in radians.\n" <>
"\[Bullet] The results are returned dimensionless but are assumed to be in Meters.\n" <>
"";


shearWallShearForcesAlongWall::usage = "shearWallShearForcesAlongWall[ aShearWall, dofList, heightList ] returns a list {V1, V2, ...} where the V's are the wall (shear) force  magnitudes parallel (in the direction start to end coordinates) to the wall at each floor level starting from the first floor.\n" <>
"\nNote:\n" <>
"\[Bullet] The dofList is the degrees of freedom list and is specified non-dimensionally.  Displacements are assumed to be in Meters and rotations in radians.\n" <>
"\[Bullet] The height list is specified non-dimensionally but is assumed to be in Meters.\n" <>
"\[Bullet] The results are returned dimensionless but are assumed to be in Newtons.\n" <>
"";


shearWallBendingMomentPairs::usage = "shearWallBendingMomentPairs[ aShearWall, dofList, heightList ] returns a list { {M1bottom, M1top}, {M2bottom, M2top}, ...} where the M's are the wall bending moment magnitudes at the bottom and top of each floor (in that order) to the wall at each floor level starting from the first floor.\n" <>
"\nNote:\n" <>
"\[Bullet] The dofList is the degrees of freedom list and is specified non-dimensionally.  Displacements are assumed to be in Meters and rotations in radians.\n" <>
"\[Bullet] The height list is specified non-dimensionally but is assumed to be in Meters.\n" <>
"\[Bullet] The results are returned dimensionless but are assumed to be in Newtons Meters.\n" <>
"";


shearWallStiffnessMatrix::usage = 
"shearWallStiffnessMatrix[ aShearWall, heightList ] returns a 3n \[Times] 3n matrix relating the vector of forces/moments to displacement/rotations where the ordering of the degrees of freedom is specified in an option.\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"\[Bullet] The dofList is the degrees of freedom list and is implicitly non-dimensional.  Displacements are assumed to be in Meters and rotations in radians.\n" <>
"\[Bullet] The implicit torque is in the z-direction and is specified dimensionless at every floor and are assumed to be in  Newton Meters.\n" <>
"\[Bullet] The forces at every floor are assumed to be in Newtons.\n" <>
"\[Bullet] The units of the matrix are as follows assuming \"floor\" ordering is given by:\n" <>
"\t\t({
 {N/m, N/m, N, ...},
 {N/m, N/m, N, ...},
 {N, N, N m, ...},
 {\[VerticalEllipsis], \[VerticalEllipsis], \[VerticalEllipsis], \[DescendingEllipsis]}
})\n" <>
"";


shearWallSpecs::usage = "shearWallSpecs[ aShearWall ] returns a list, table or grid presentation of the data associated with aShearWall.\n" <>
"\nNote:\n" <>
"\[Bullet] The option shearWallView may take the values List, Table or Grid to present different views of the data.\n" <>
"\[Bullet] The option shearWallEdit may be set to True in order to allow in-place editing of values.\n" <>
"";


shearWallDraw::usage = "shearWallDraw[ aShearWall ] returns graphics primitives representing a shear wall in 3-D.";


shearWallDraw2D::usage = "shearWallDraw2D[ aShearWall ] returns a list of graphics primitives representing a shear wall in 2-D.  The 2-D list of figures are at the base of each floor starting at floor 1.";


shearWallNew::usage = "shearWallNew[  startCoordinates, endCoordinates ] creates a new object of type shearWall.\n" <>
"Note:\n" <>
"\[Bullet] Most parameters are set by options.\n" <>
"\[Bullet] Use SetOptions[ shearWallNew, someOption -> value, otherOption -> value ...] to set defaults for these options if needed.\n" <>
"\[Bullet] All values are checked before they are assigned.  This includes the case when using SetOptions to set defaults.\n" <>
"\[Bullet] Values may be specified partially symbolically.  For example, the height may be specified as 'h' with 'h' being specified later.  This does create the possibility of using inconsistent units if 'h' is later specifed consistently.";


shearWallDeepClone::usage = "shearWallDeepClone[ aShearWall ] returns a new shearWall copy that is an exact copy of the input " <>
"but is independent and not affected by changes in the original";


shearWallMassList::usage = "shearWallMassList[ aShearWall, heightList ] returns a list of mass values assumed to be in Kilograms of each wall section between floors.  The first element in the list is the mass of the wall between ground and first floor, the second element is the mass of the wall between first and second floor and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"";


shearWallMassLumpedList::usage = "shearWallMassLumpedList[ aShearWall, heightList ] returns a list of mass values assumed to be in Kilograms of each wall section between floors.  Assuming there are more than 2 floors, the first element in the list is the mass of the wall between ground and half the second floor, the second element is the mass of the wall between half the second floor and half the third floor and so on.  The last floor has half the mass of the last floor's wall.\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"\[Bullet] If there is only one floor then the mass of the first element is the mass of the first floor.\n" <>
"\[Bullet] If there is two floors then the mass of the second element is half the mass of the second floor.\n" <>
"";


shearWallMassPolarMomentOfInertiaList::usage = "shearWallMassPolarMomentOfInertiaList[ aShearWall, heightList ] returns a list of mass polar moment of inertia values assumed to be in Kilograms \!\(\*SuperscriptBox[\(Meter\), \(2\)]\) of each wall section between floors.  The first element in the list is the value for the section of the wall between ground and first floor, the second element is the value for the section of the wall between first and second floor and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"\[Bullet] If the option 'shearWallCenterOfRotationRules' is Automatic then the base center of the base of the wall is used as the center for all floors.\n" <>
"\[Bullet] If the option 'shearWallCenterOfRotationRules' returns Automatic for any particular floor, then the center of the wall at that floor is used as the center for that floor.\n" <>
"";


shearWallMassLumpedPolarMomentOfInertiaList::usage = "shearWallMassLumpedList[ aShearWall, heightList ] returns a list of mass polar moment of inertia values assumed to be in Kilograms \!\(\*SuperscriptBox[\(Meter\), \(2\)]\) of each wall section between floors. Assuming there are more than 2 floors, the first element in the list is the mass polar moment of inertia of the wall between ground and half the second floor, the second element is the same for the wall between half the second floor and half the third floor and so on.  The last floor has half the value of the last floor's wall.\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"\[Bullet] If there is only one floor then the value of the first element is the mass polar moment of inertia of the first floor.\n" <>
"\[Bullet] If there is two floors then the mass of the second element is half the mass polar moment of inertia of the second floor.\n" <>
"";


shearWallMassTotal::usage = "shearWallMassTotal[ aShearWall, heightList ] returns the total mass of the wall for all floors assumed to be in Kilograms.\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"";


shearWallMassPolarMomentOfInertiaTotal::usage = "shearWallMassPolarMomentOfInertiaTotal[ aShearWall, heightList ] returns the total mass moment of inertia of the wall for all floors assumed to be in Kilograms \!\(\*SuperscriptBox[\(Meter\), \(2\)]\).\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"";


shearWallMassMatrix::usage = "shearWallMassMatrix[ aShearWall, heightList ] returns the mass matrix of the wall for all floors where units for masses are assumed to be in Kilograms and units for mass moment of inertia are assumed to be in Kilograms \!\(\*SuperscriptBox[\(Meter\), \(2\)]\).\n" <>
"\nNote:\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"\[Bullet] The ordering of the elements in the matrix depends on whether the option 'shearWallDOFOrdering' is \"floor\" or \"building\".\n" <>
"\[Bullet] The mass matrix is a diagonal matrix (see below)." <>
"\[Bullet] The wall section between ground and first floor is treated as follows:\n" <>
"\t\t\[Rule] The mass and mass moment of inertia of the whole section (not just half) is lumped into the first floor.\n." <>
"\[Bullet] The units of the matrix are as follows assuming \"floor\" ordering is given by:\n" <>
"\t\t({
 {Kg, 0, 0, Kg, 0, 0, ...},
 {0, Kg, 0, 0, Kg, 0, ...},
 {0, 0, Kg m^2, 0, 0, Kg m^2, ...},
 {Kg, 0, 0, Kg, 0, 0, ...},
 {0, Kg, 0, 0, Kg, 0, ...},
 {0, 0, Kg m^2, 0, 0, Kg m^2, ...},
 {\[VerticalEllipsis], \[VerticalEllipsis], \[VerticalEllipsis], \[VerticalEllipsis], \[VerticalEllipsis], \[VerticalEllipsis], \[DescendingEllipsis]}
})\n" <>
"";"";


shearWallLengthList::usage = 
"shearWallLengthList[ aShearWall, numberOfFloors ] returns the length of all floors starting from floor 1, floor 2 and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] The length list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"";


shearWallThicknessList::usage = 
"shearWallThicknessList[ aShearWall, numberOfFloors ] returns the thickness of all floors starting from floor 1, floor 2 and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] The thickness list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"";


shearWallCentroidList::usage = 
"shearWallCentroidList[ aShearWall, numberOfFloors ] returns the centroids (midpoints of wall sections) of all floors.  Note that the first element is the midpoint of the section from ground to first floor, the second element is the midpoint of the section from first floor to second and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] The centroid list is specified non-dimensionally as a pair of values and these values are assumed to be in Meters.\n" <>
"";


shearWallCenterOfMassLumpedList::usage = 
"shearWallCenterOfMassLumpedList[aShearWall, heightList ] returns the centers of mass consistent with the lumped masses obtained by the method 'shearWallMassLumpedList'.  First element is the center of mass for floor 1, second for floor 2 and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] The center of mass list is specified non-dimensionally as a pair of values and these values are assumed to be in Meters.\n" <>
"\[Bullet] The height list is specified non-dimensionally and is assumed to be in Meters.\n" <>
"\[Bullet] The center of mass can differ from the centroid list because the walls may not be aligned due to different values implied by the procedure 'shearWallStartEndLengthFractionsRules'.  In that case, the height and thickness of the sections affect the location of center of mass.\n" <>
"";


(* ::Subsubsection:: *)
(*-------------------------------------------------------------------------------------------------------*)


(* ::Subsubsection::Closed:: *)
(*shearBuilding options*)


shearBuildingCentersOfRotationRules::usage = "shearBuildingCentersOfRotationRules is an option associated with shearBuilding objects.  It specifies the list of rules from which the center of rotation of each floor may be determined.\n" <>
"Note:\n" <>
"\[Bullet] The rules must be such that any integer between 1 and the number of floors in the building must return either the keyword \"CenterOfMass\" or \"centerOfMass\" valid coordinates (pair of numbers) that are specified dimensionless but are assumed to be in Meters.\n" <>
"\[Bullet] Alternatively this option may take the value \"CenterOfMass\" or \"centerOfMass\" which indicates that all floors have center of rotation at their centers of mass.\n" <>
"\[Bullet] The rules may be explicit.  For example, for a 4-floor building, we may specify {1 -> {0.5, 0.5} , 2 -> \"CenterOfMass\", 3 -> {1, 0} , 4 -> \"centerOfMass\"}\n" <>
"\[Bullet] The rules may be partially or totally implicit.  For example, for a any number of floors, we may specify {a_ /; a < 6 -> \"CenterOfMass\", a_ /; a >= 6 -> {0, 0}}.  This will specify that the coordinate of the center of mass of each floor will be used for any floor below the sixth and {0, 0} will be used for all floors at the sixth or above (if such floors exist).";


shearBuildingDOFList::usage = "shearBuildingDOFList is an option associated with shearBuilding objects.  It specifies a list of degrees of freedom of all floors.\n" <>
"Note:\n" <>
"\[Bullet] The rules must be such that any integer between 1 and the 3 times the number of floors in the building is a DOF value.  All degrees of freedom are specified nondimensionally but displacements are assumed to be in Meters while rotations in radians.\n" <>
"\[Bullet] The degrees of freedom may be arranged or ordered either in \"floor\" ordering or in \"building\" ordering (see shearBuilding related procedures).";


shearBuildingDisplacementScaleFactor::usage = "shearBuildingDisplacementScaleFactor is an option associated with shearBuilding objects.  It specifies the displacement scale factor when drawing the deformed form of a building.";


shearBuildingRotationScaleFactor::usage = 
"shearBuildingRotationScaleFactor is an option associated with shearBuilding objects.  It specifies the rotation scale factor when drawing the deformed form of a building.";


shearBuildingView::usage = "shearBuildingView is an option associated with shearBuilding objects.  It specifies the view in which to present a shearBuilding object.  Allowable values are List, Table or Grid.";


shearBuildingDOFOrdering::usage = "shearBuildingDOFOrdering is an option associated with shearBuilding objects.  It specifies the ordering of the degrees of freedom.\n" <>
"Note:\n"<>
"\[Bullet] The values of this option may be \"building\", \"Building\", \"floor\" or \"Floor\".\n" <>
"\[Bullet] In the case of \"building\" or \"Building\", the degrees of freedom are ordered as {\!\(\*SubscriptBox[\(u\), \(x1\)]\), \!\(\*SubscriptBox[\(u\), \(x2\)]\), \!\(\*SubscriptBox[\(u\), \(x3\)]\), \[Ellipsis] \!\(\*SubscriptBox[\(u\), \(xn\)]\), \!\(\*SubscriptBox[\(u\), \(y1\)]\), \!\(\*SubscriptBox[\(u\), \(y2\)]\), \!\(\*SubscriptBox[\(u\), \(y3\)]\), \[Ellipsis] \!\(\*SubscriptBox[\(u\), \(yn\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(1\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(2\)]\), \[Ellipsis] \!\(\*SubscriptBox[\(\[Theta]\), \(n\)]\)}\n"<>
"\[Bullet] In the case of \"floor\" or \"Floor\", the degrees of freedom are ordered as {\!\(\*SubscriptBox[\(u\), \(x1\)]\), \!\(\*SubscriptBox[\(u\), \(y1\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(1\)]\), \!\(\*SubscriptBox[\(u\), \(x2\)]\), \!\(\*SubscriptBox[\(u\), \(y2\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(2\)]\),  \[Ellipsis] \!\(\*SubscriptBox[\(u\), \(xn\)]\), \!\(\*SubscriptBox[\(u\), \(yn\)]\), \!\(\*SubscriptBox[\(\[Theta]\), \(n\)]\)}";


shearBuildingSlabDrawType::usage = "shearBuildingSlabDrawType is an option associated with shearBuilding objects.  It specifies the way to draw shearSlab object.  Allowable values are Polygon, Line or Automatic.";


shearBuildingAnnotateTextListsOnePerWall::usage = 
"shearBuildingAnnotateTextListsOnePerWall is an option associated with shearBuilding objects.  It specifies a list of lists of text or expressions to be associated with each wall when drawing their 2-D representation.  This is usually specified as one list per wall." <>
"\nNote:\n" <>
"\[Bullet] The order of specification of list of texts for the walls is in the order in which they appear when 'shearBuildingWallList[ aBuilding ]' is called.\n" <>
"\[Bullet] The list for each wall should specify the text for that wall at each floor level with the first member in the list being for the first floor and so on.\n" <>
"\[Bullet] If this option has a value of 'None' then no text is drawn for any wall.\n" <>
"\[Bullet] If this option has an i'th member that is not a list then no text is drawn for the i'th wall.\n" <>
"\[Bullet] If a member of a list of a given wall has a value 'None' then no text is drawn for the corresponding floor of that i'th wall.\n" <>
"\[Bullet] If the specified list is shorter than the number of floors then the unspecified floors have no text.\n" <>
"";


shearBuildingAnnotateUnits::usage = 
"shearBuildingAnnotateUnits is an option associated with shearBuilding objects.  It specifies a value for the units to be appended to each text shown for the walls when drawing their 2-D representation." <>
"\nNote:\n" <>
"\[Bullet] If this option has a value of 'None' then no units is appended for any wall.\n" <>
"";


shearBuildingCenterOfRotation::usage = 
"shearBuildingCenterOfRotation is an option associated with shearBuilding objects.  It specifies the center of rotation for the degrees of freedom.  A value of \"centerOfMass\" or Automatic implies that the center of rotations are at the centerOfMasss of the slabs (plus walls if option is set to include walls) of each floor." <>
"\nNote:\n" <>
"\[Bullet] The coordinates are specified nondimensionally but assumed to be in Meters";


shearBuildingShowDeformedQ::usage = 
"shearBuildingShowDeformedQ is an option associated with shearBuilding objects.  If True, it shows the walls after deformations otherwise in the initial configuration.";


shearBuildingEarthquakeMotionDirection::usage =  
"shearBuildingEarthquakeMotionDirection is an option associated with shearBuilding objects.  It specifies the direction of earthquake motion.  This direction may either be specified as a 2-D vector or as an angle.  If a 2-D vector is specified, that vector will be automatically normalized before being used.";


shearBuildingEdit::usage = 
"shearBuildingEdit is an option associated with shearBuilding objects.  If True, it allows the editing of building parameters when seeing specs (see 'shearBuildingSpecs').";


(* ::Subsubsection::Closed:: *)
(*shearBuilding messages*)


shearBuildingDampingRatio::usage  = 
"shearBuildingDampingRatio is a keyword that may be sent to shearBuilding objects to get or set its value.  It specifies a uniform damping ratio for all modes.";


shearBuildingWallList::usage = 
"shearBuildingWallList is a keyword that may be sent to shearBuilding objects to get its value.  This keyword returns a list of shearWall objects associated with the building (applies to all floors).\n" <>
"Note:\n" <>
"\[Bullet] It is allowed to both put and get this value although it is required to put at least one floor and it is recommended to put at least 3 nonconcentric walls in order to avoid zero eigenvalues (for the twist mode) unless orthogonal wall stiffness is included.";


shearBuildingExistsQ::usage = "shearBuildingExistsQ is a keyword that may be sent to shearBuilding objects to get its value.  This keyword when accessed returns True if the building exists and False otherwise.\n" <>
"Note:\n" <>
"\[Bullet] The value of shearBuildingExistsQ may not be directly set.  It is set to True automatically when a building is created with shearBuildingNew and set to False automatically with shearBuildingClearAll[].  A building that has not been created returns by default False.";


shearBuildingNumberOfFloors::usage = "shearBuildingNumberOfFloors is a keyword that may be sent to shearBuilding objects to get or set its value.\n" <>
"Note:\n" <>
"\[Bullet] It is the user's responsibility to have the number of floors be consistent with the values of shearBuildingSlabRules and shearBuildingWallsList (if necessary) so that each floor in the new size will have applicable rules (ie. when the rule is used on each floor number then a valid substitution occurs).";


shearBuildingHeightRules::usage = "shearBuildingHeightRules is a keyword that may be sent to shearBuilding objects to get or specify its value.  This keyword returns a list of heights for each story of a building.\n" <>
"Note:\n" <>
"\[Bullet] The heights are specified nondimensionally but assumed to be in Meters" <>
"\[Bullet] The rules must be such that any integer between 1 and the number of floors in the building must return a valid height value.\n" <>"\[Bullet] When a call to shearBuildingPut sets this value then all the walls in the building will have their values changed to the new values implied by the rules.\n" <>
"\[Bullet] The rules may be explicit.  For example, for a 4-floor building, we may specify {1 -> 3, 2 -> 3, 3 -> 2.5, 4 -> 2.5}\n" <>
"\[Bullet] The rules may be partially or totally implicit.  For example, for a any number of floors, we may specify {a_ /; a < 6 -> 3, a_ /; a >= 6 -> 2.5}.  This will specify that a height of 3 meters will be used for any floor below the sixth and a height of 2.5 meters will be used for all floors at the sixth or above (if such floors exist).";


shearBuildingHeightAtFloor::usage = "shearBuildingHeightAtFloor is a keyword that may be sent to shearBuilding objects to get its value.  This keyword returns the height of a floor at a particular floor number.  The call to shearBuildingGet would be shearBuildingGet[ aBuilding, shearBuildingHeightAtFloor, floorNumber ] or equivalently shearBuildingHeightAtFloor[ aBuilding, floorNumber ].  Note that if a floor number is not covered by the floor rules but is within the number of floors of the building then that floor will be assigned a height which is the same as the first floor.";


shearBuildingHeightList::usage = 
"shearBuildingHeightList is a keyword that may be sent to shearBuilding objects to get its value.  This keyword returns a list of shearFloor heights associated with each floor number in order from 1 upwards.  Note that it is NOT allowed to put this value (only to get it).";


shearBuildingHeight::usage =
"shearBuildingHeight is a keyword that may be sent to shearBuilding objects to get its value.  This keyword returns the total height of the building (sums the height list).  Note that it is NOT allowed to put this value (only to get it).";


shearBuildingSlabRules::usage = "shearBuildingSlabRules is a keyword that may be sent to shearBuilding objects to get or set its value.  This keyword is associated with the list of rules specifying the shape of each floor.\n" <>
"Note:\n" <>
"\[Bullet] The rules must be such that any integer between 1 and the number of floors in the building must return an expression of the form Polygon[ ... ], Line[ ... ], List[ ... ] or shearSlab[<index>] or Automatic.\n" <>
"\[Bullet] The right-hand-side of every rule must evaluate to an expression with head List, Polygon, Line or shearSlab or to the value Automatic.\n" <>
"\[Bullet] A value of Automatic for a shape implies using a rectangular Polygon that fits all the floors in the building (gets updated whenever needed).\n" <>"\[Bullet] The rules may be explicit.  For example, for a 2-floor building, we may specify {1 -> Polygon[ {{0, 0}, {1, 0}, {1, 1}, {0, 0}}], 2 -> Line[ {{0, 0}, {2, 0}, {2, 1}, {0, 0}}]}\n" <>
"\[Bullet] The rules may be partially or totally implicit.  For example, for a any number of floors, we may specify {a_ /; a < 6 -> Polygon[ {{0, 0}, {1, 0}, {1, 1}, {0, 0}}], a_ /; a >= 6 -> Polygon[ {{0, 0}, {3, 0}, {1, 3}, {0, 0}}]}.";


shearBuildingSlabList::usage = "shearBuildingSlabList is a keyword that may be sent to shearBuilding objects to get its value.  This keyword returns a list of shearSlab objects associated with each floor number in order from 1 upwards.  Note that it is NOT allowed to put this value (only to get it).";


shearBuildingSlabDrawPrimitives::usage = "shearBuildingSlabDrawPrimitives is a keyword that may be sent to shearBuilding objects to get its value.  This keyword returns the floor shape (expression with head Polygon or Line) associated with a particular floor number.  The call to shearBuildingGet would be shearBuildingGet[ aBuilding, shearBuildingSlabDrawPrimitives, floorNumber ].\n" <>
"Note:\n" <>
"\[Bullet] The value returned may be Automatic or an expression with Head Polygon or Head Line.";


shearBuildingWallThicknessRules::usage = "shearBuildingWallThicknessRules is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because each each wall may have a different value.  This keyword is associated with the list of thickness rules of the walls.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to the building will have their values changed to the new value.  The value of each individual wall may also be set separately to different values at any time.\n" <>
"\[Bullet] Thickness must be expressed non-dimensionally but are assumed to have units of Meters.";


shearBuildingShearModulus::usage = "shearBuildingShearModulus is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because each wall may have a different value.  This keyword is associated with the shear modulus, usually denoted by G or \[Mu], of the walls.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to all the building will have their values changed to the new value.  The value of each individual wall may also be set separately to a different value at any time.\n" <>
"\[Bullet] Shear modulus must be expressed non-dimensionally but is assumed to have units of Giga Pascal.";


shearBuildingYoungsModulus::usage = "shearBuildingYoungsModulus is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because wall may have a different value.  This keyword is associated with the Young's modulus, usually denoted by E, of the walls.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to all the building will have their values changed to the new value.  The value of each individual wall may also be set separately to a different value at any time.\n" <>
"\[Bullet] Young's modulus must be expressed non-dimensionally but is assumed to have units of Giga Pascal.";


shearBuildingIncludeWhatStiffness::usage = "shearBuildingIncludeWhatStiffness is a keyword that may be sent to shearBuilding objects to set its value.  This keyword is associated with identifying what type of stiffness to include in calculating the member stiffness of each wall in the building.  \n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to all the building will have their values changed to the new value.  The value of each individual wall in the building may also be set separately to a different value at any time.\n" <>
"\[Bullet] Allowable values for 'shearBuildingIncludeWhatStiffness' are 'shearWallIncludeBendingTypeOnly', 'shearWallIncludeShearTypeOnly' and 'shearWallIncludeShearAndBendingTypes'.";


shearBuildingWallSpecificGravity::usage = "shearBuildingWallSpecificGravity is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because each wall may have a different value.  This keyword is associated with the specific gravity, usually denoted by \[Gamma], of the walls.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to all the building will have their values changed to the new value.  The value of each individual wall may also be set separately to a different value at any time.\n" <>
"\[Bullet] Specific gravity is nondimensional.";


shearBuildingWallIncludeMassQ::usage = "shearBuildingWallIncludeMassQ is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because each wall may have a different value.  This keyword is associated with whether to include the mass of walls.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to all the building will have their values changed to the new value.  The value of each individual wall may also be set separately to a different value at any time.\n" <>
"\[Bullet] The value of this parameter must be either True or False.";


shearBuildingSlabSpecificGravity::usage = "shearBuildingSlabSpecificGravity is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because each slab may have a different value.  This keyword is associated with the specific gravity, usually denoted by \[Gamma], of the slabs.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to all the building will have their values changed to the new value.  The value of each individual slab may also be set separately to a different value at any time.\n" <>
"\[Bullet] Specific gravity is nondimensional.";


shearBuildingSlabThickness::usage = "shearBuildingSlabThickness is a keyword that may be sent to shearBuilding objects to set its value.  Note that this value may not be accessed by a call using 'shearBuildingGet' because each each slab may have a different value.  This keyword is associated with the thickness of all slabs.\n" <>
"Note:\n" <>
"\[Bullet] When a call to shearBuildingPut sets this value then all walls belonging to the building will have their values changed to the new value.  The value of each individual slab may also be set separately to different values at any time.\n" <>
"\[Bullet] Thickness must be expressed non-dimensionally but are assumed to have units of Meters.";


(* ::Subsubsection::Closed:: *)
(*shearBuilding methods  -----   SOME MORE MESSAGES NEEDED*)


shearBuildingCenterOfMassList::usage = "shearBuildingCenterOfMassList[ aShearBuilding ] gives a list of center-of-mass (2-D) dimensional coordinates for the centers of mass of each floor (in order from first floor to top).\n" <>
"\nNote:\n" <>
"\[Bullet] The center of mass may or may not include the walls masses depending on the setting of some options in specifying the walls.\n" <>
"\[Bullet] When the wall masses are included then tributary areas of half the walls above and below are used.  This implies that the last floor gets only half a wall and that the lower half of the first floor will not contribute to any floor mass\n" <>
"";


shearBuildingRigidityCenters::usage = 
"shearBuildingRigidityCenters[ aShearBuilding ] gives a list of rigidity centers (2-D) dimensional coordinates for the centers of rigidity of each floor (in order from first floor to top).\n" <>
"\nNote:\n" <>
"\[Bullet] Center coordinates are assumed to be in meters but are returned as nondimensional list of pairs.\n" <>
"";


shearBuildingSlabCentroids::usage = "shearBuildingFloorCentroids[ aShearBuilding ] gives a list of centroid (2-D) dimensional coordinates for the centroid of each slab (in order from bottom to top).";


shearBuildingSlabAreas::usage = "shearBuildingFloorAreas[ aShearBuilding ] gives a list of areas of each slab (in order from bottom to top).";


shearBuildingSlabPolarMomentOfInertiaRelativeToCentroids::usage = "shearBuildingFloorPolarMomentOfInertiaRelativeToCentroids[ aShearBuilding ] gives a list of polar moment of inertias relative to the centroids of each slab (in order from bottom to top).";


shearBuildingClearAll::usage = "shearBuildingClearAll[] clears all shearBuilding objects and their values and also resets default options.";


shearBuildingNew::usage = "shearBuildingNew[  numberOfFloors , listOfWalls ] creates a new shearBuilding object.\n" <>
"\nNote:\n" <>
"\[Bullet] The shape of the slabs are set by an option.\n" <>
"\[Bullet] The heights of the floors are set by an option.\n" <>
"\[Bullet] The value 'numberOfFloors' must be an integer greater or equal to one.\n" <>
"\[Bullet] The list 'listOfWalls' must have at least one shearWall object.\n" <>
"\[Bullet] The option 'shearBuildingSlabRules' must be such that any integer between 1 and the number of floors in the building must return an expression of the form Polygon[ ... ] or Line[ ... ] or Automatic.\n" <>
"";


shearBuildingCheck::usage = "shearBuildingCheck[ whatToCheck, proposedValue ] returns True if 'proposedValue' is a valid value for 'whatToCheck'.";


shearBuildingGet::usage = "shearBuildingGet[ aShearBuilding, whatToGet ] returns the value of 'whatToGet' if it is a valid keyword for shearBuildingGet.\n" <>
"Note:\n" <>
"\[Bullet] Check the members of the list in shearBuildingKeysGetList to obtain the list of keywords that may be used.\n" <>
"\[Bullet] In some cases, the call to shearFloorGet requires a floor number such as shearFloorGet[ aShearFloor, shearBuildingHeightAtFloor, floorNumber ]\n" <>
"\[Bullet] Some keywords may be used with shearBuildingGet but not with shearBuildingPut and vice-versa.\n" <>
"\[Bullet] The reason some keywords may be called with shearBuildingGet but not shearBuildingPut is that for some parameters each wall in a building may have its value separately set and hence there is no common value for the building for some variables.  When shearBuildingPut is used with a keyword associated with walls then all walls in the building will have their values changed to the one specified.\n" <>
"";


shearBuildingPut::usage = "shearBuildingPut[ aShearBuilding, whatToPut, someValue ] puts the value 'someValue' into the keyword 'whatToPut' for the shear building 'aShearBuilding'.\n" <>
"Note:\n" <>
"\[Bullet] The value 'someValue' will be checked before the value is put in 'whatToPut'.  If the value is not suitable then a message is given and the value is not put.\n" <>
"\[Bullet] Check the members of the list in shearBuildingKeysPutList to obtain a list of keywords that may be used.\n" <>
"\[Bullet] Some keywords may be used with shearBuildingGet but not with shearBuildingPut and vice-versa.\n" <>
"\[Bullet] When a call to shearBuildingPut sets a value then all walls belonging to the building will have their values changed to the new value.  The value of each individual wall in the building may also be set separately to different values.\n" <>
"";


shearBuildingStiffnessMatrix::usage = 
"shearBuildingStiffnessMatrix[ aShearBuilding ] returns a 3(n+1) \[Times] 3(n+1) matrix relating the vector {Fx0, Fy0, T0, Fx1, Fy1, T1, Fx2, Fy2, T2, ...., Fxn, Fyn, Tn} to {ux0, uy0, \[Theta]0, ux1, uy1, \[Theta]1, ux2, uy2, \[Theta]2, ...., uxn, uyn, \[Theta]n} assuming floor ordering (building ordering returns a properly reordered result) where 'n' is the number of floors in a building.  'F' denotes a force, 'T' denotes a torque, 'u' denotes a displacement and '\[Theta]' denotes a rotation.  Floor '0' corresponds to the ground.\n" <>
"\nNote:\n" <>
"\[Bullet] The center of rotation is specified in an option and must be dimensionally correct (length units).  It is assumed to be the same for all floors.\n" <>
"\[Bullet] Forces are assumed to be in Newtons, Torques in Newton Meter, displacements in Meter and rotations in radians.\n" <>
"\[Bullet] The torque is in the z-direction for all floors.\n" <>
"\[Bullet] The units of the matrix are as follows (for \"floor\" ordering - see shearBuildingDOFOrdering):\n" <>
"\t\t({
 {N/m, N/m, N, ...},
 {N/m, N/m, N, ...},
 {N, N, N m, ...},
 {\[VerticalEllipsis], \[VerticalEllipsis], \[VerticalEllipsis], \[DescendingEllipsis]}
})\n" <>
"";


shearBuildingDraw::usage = "shearBuildingDraw[ aShearBuilding ] returns graphics primitives representing a building of shear walls in 3-D.";


shearBuildingDraw2D::usage = "shearBuildingDraw2D[ aShearBuilding ] returns graphics primitives representing a building of shear walls in 2-D.  Allows various values to annotate the walls.";


shearBuildingSpecs::usage = "shearBuildingSpecs[ aShearBuilding ] returns a list, table or grid presentation of the data associated with aShearBuilding.  The table returned is automatically and dynamically updated and should not be wrapped by Dynamic.\n" <>
"\nNote:\n" <>
"\[Bullet] The option shearBuildingView may take the values List, Table or Grid to present different views of the data.\n" <>
"\[Bullet] The option shearBuildingEdit may be set to True in order to allow in-place editing of values.\n" <>
"";


(* shearBuildingRigidityCenterList::usage = "shearBuildingRigidityCenterList[ aShearBuilding ] IS NOT YET IMPLEMENTED."; *)


shearBuildingXYZminmaxPairsList::usage = "shearBuildingXYZminmaxPairsList[ aShearBuilding ] returns a list {{xMin, xMax}, {yMin, yMax}, {zMin, zMax}} which bounds the building at its current configuration.";


shearBuildingMassMatrix::usage = 
"shearBuildingMassMatrix[ aShearBuilding ] returns a 3(n) \[Times] 3(n) diagonal matrix related to the acceleration vector \!\(\*SuperscriptBox[\(d\), \(2\)]\)/\!\(\*SuperscriptBox[\(dt\), \(2\)]\)\[NonBreakingSpace]{ux1, uy1, \[Theta]1, ux2, uy2, \[Theta]2, ...., uxn, uyn, \[Theta]n} assuming floor ordering (building ordering returns a properly reordered result) where 'n' is the number of floors in a building. 'u' denotes a displacement and '\[Theta]' denotes a rotation.  Floor '0' corresponds to the ground.\n" <>
"\nNote:\n" <>
"\[Bullet] The center of rotation is specified in an option and must be nondimensional but assumed to be in meters.  This center is assumed to be the same for all floors unless \"centerOfMass\" is used in which case it will be the center of mass of each floor.\n" <>
"\[Bullet] Displacements are implicitly assumed to be in Meter, rotations in radians, time is in seconds, mass is in Kilogram and mass-polar moment of inertia is in Kilogram \!\(\*SuperscriptBox[\(Meter\), \(2\)]\).\n" <>
"\[Bullet] The rotation axis is in the z-direction for all floors.\n" <>
"\[Bullet] The units of the matrix are implicitly assumed as follows (for \"floor\" ordering - see shearBuildingDOFOrdering):\n" <>
"\t\t({
 {Kg,   0, 0,  ...},
 {0,    Kg, 0,  ...},
 {0,   0,   Kg m^2,  ...},
 {\[VerticalEllipsis],   \[VerticalEllipsis], \[VerticalEllipsis],  \[DescendingEllipsis]}
})\n" <>
"";


shearBuildingDampingMatrix::usage = 
"shearBuildingDampingMatrix[ aShearBuilding ] returns a 3(n) \[Times] 3(n) matrix related to the velocity svector d/dt\[NonBreakingSpace]{ux1, uy1, \[Theta]1, ux2, uy2, \[Theta]2, ...., uxn, uyn, \[Theta]n} assuming floor ordering (building ordering returns a properly reordered result) where 'n' is the number of floors in a building. 'u' denotes a displacement and '\[Theta]' denotes a rotation.  Floor '0' corresponds to the ground.\n" <>
"\nNote:\n" <>
"\[Bullet] The center of rotation is specified in an option and must be nondimensional but assumed to be in meters.  This center is assumed to be the same for all floors unless \"centerOfMass\" is used in which case it will be the center of mass of each floor.\n" <>
"\[Bullet] Displacements are implicitly assumed to be in Meter, rotations in radians, time is in seconds, mass is in Kilogram and mass-polar moment of inertia is in Kilogram \!\(\*SuperscriptBox[\(Meter\), \(2\)]\).\n" <>
"\[Bullet] The rotation axis is in the z-direction for all floors.\n" <>
"\[Bullet] The units of the matrix are as follows (for \"floor\" ordering - see shearBuildingDOFOrdering):\n" <>
"\t\t({
 {Kg/s,    Kg/s,   Kg m/s, ...},
 {Kg/s,    Kg/s,   Kg m/s, ...},
 {Kg m/s,    Kg m/s,   Kg m^2/s, ...},
 {\[VerticalEllipsis],    \[VerticalEllipsis], \[VerticalEllipsis], \[DescendingEllipsis]}
})\n" <>
"";


shearBuildingEigensystem::usage = "shearBuildingEigensystem[ aShearBuilding ] returns a list where the first member is a list of the eigenvalues in ascending order and the second list is a matrix of the corresponding eigenvectors arranged so that each row is an eigenvector.  The units of displacements are implicitly assumed to be in meters, rotations in radians and time in seconds.  The eigenvalues and eigenvectors are returned as unitless values but assume the units just mentioned.\n" <>
"\nNote:\n" <>
"\[Bullet] All eigenvectors are normalized so that they are unit vectors (ie. Norm[ oneEigenvector ] = 1).\n" <>
"\[Bullet] The eigenvalues are calculated for zero damping irrespective of the damping ratio specified.\n" <>
"\[Bullet] The eigenvalues and eigenvectors satisfy the relation:   M \[Phi] + \[Lambda] K \[Phi] = 0  where \[Lambda] is an eigenvalue and \[Phi] is the corresponding eigenvector.\n" <>
"";


shearBuildingDeepClone::usage = "shearBuildingDeepClone[ aShearBuilding ] returns a new shearBuilding copy that is an exact copy of the input " <>
"but is independent and not affected by changes in the original";


shearBuildingGetWallShearForcesFromDOF::usage = "shearBuildingGetWallShearForcesFromDOF[ aShearBuilding, degreesOfFreedom ] returns a list of lists of wall shear forces (component along top of wall)." <>
"The lists are arranged in order with first element being first floor and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] Each list specifies the values for one wall and within each list, they are arranged in order with first element being first floor and so on.\n" <>
"\[Bullet] The order of specification for the walls is in the order in which they appear when 'shearBuildingWallList[ aBuilding ]' is called.\n" <>
"\[Bullet] It is important to correctly set the option 'shearBuildingDOFOrdering' to correspond to that used in obtaining the dofs\n" <>
"\[Bullet] degreesOfFreedom are non-dimensional numbers but assume that displacements are in meters and rotations are in radians.\n" <>
"";


shearBuildingGetWallDeltaDisplacementsFromDOF::usage = "shearBuildingGetWallDeltaDisplacementsFromDOF[ aShearBuilding, degreesOfFreedom ] returns a list of lists of change in displacement between top and bottom of a wall in the direction of the wall.\n" <>
"\nNote:\n" <>
"\[Bullet] Each list specifies the values for one wall and within each list, they are arranged in order with first element being first floor and so on.\n" <>
"\[Bullet] The order of specification for the walls is in the order in which they appear when 'shearBuildingWallList[ aBuilding ]' is called.\n" <>
"\[Bullet] It is important to correctly set the option 'shearBuildingDOFOrdering' to correspond to that used in obtaining the dofs\n" <>
"\[Bullet] degreesOfFreedom are non-dimensional numbers but assume that displacements are in meters and rotations are in radians.\n" <>
"";


shearBuildingGetWallBendingMomentsFromDOF::usage = "shearBuildingGetWallBendingMomentsFromDOF[ aShearBuilding, degreesOfFreedom ] returns a list of lists of wall bending moments (component along top of wall).  " <>
"The lists are arranged in order with first element being first floor and so on.\n" <>
"\nNote:\n" <>
"\[Bullet] Each list specifies the values for one wall and within each list, they are arranged in order with first element being first floor and so on.\n" <>
"\[Bullet] The order of specification for the walls is in the order in which they appear when 'shearBuildingWallList[ aBuilding ]' is called.\n" <>
"\[Bullet] It is important to correctly set the option 'shearBuildingDOFOrdering' to correspond to that used in obtaining the dofs\n" <>
"\[Bullet] degreesOfFreedom are non-dimensional numbers but assume that displacements are in meters and rotations are in radians.\n" <>
"";


shearBuildingEarthquakeLoadMassVector::usage = "shearBuildingEarthquakeLoadMassVector[ aShearBuilding ] returns a 3(n) vector which when multiplied by the (positive) ground acceleration gives the forcing or load function due to an earthquake when the degrees of freedom are considered to be the relative motions with respect to the ground.\n" <>
"\nNote:\n" <>
"\[Bullet] The units of the matrix are in Kilogram whenever they're non-zero.\n" <>
"\[Bullet] The direction of motion may be specified by an option (see 'shearBuildingEarthquakeMotionDirection') which specifies either a 2-D vector or an angle." <>
"";


shearBuildingAddShearWall::usage = 
"shearBuildingAddShearWall[ aShearBuilding, someShearWall ] adds a shearWall to the list of shearWall objects in the building.  If the building already contains the shearWall 'someShearWall' then nothing is done (no error message).  However, the shearWall object must exist.\n" <>
"\nNote:\n" <>
"\[Bullet] shearBuildingAddShearWall[ aShearBuilding, listOfShearWalls ] operates on each of the walls in the list separately.";


shearBuildingRemoveShearWall::usage = 
"shearBuildingRemoveShearWall[ aShearBuilding, someShearWall ] removes a shearWall from the list of shearWall objects in the building.  If the building does not contain the shearWall 'someShearWall' then nothing is done (no error message).\n" <>
"\nNote:\n" <>
"\[Bullet] shearBuildingRemoveShearWall[ aShearBuilding, listOfShearWalls ] operates on each of the walls in the list separately.";


shearBuildingBuildingToFloorVectorTransform::usage = 
"shearBuildingBuildingToFloorVectorTransform[ dofOrLoad ] converts dofOrLoad vector from building to floor ordering (see 'shearBuildingDOFOrdering')";


shearBuildingFloorToBuildingVectorTransform::usage = 
"shearBuildingFloorToBuildingVectorTransform[ dofOrLoad ] converts dofOrLoad vector from floor to building ordering (see 'shearBuildingDOFOrdering')";


shearBuildingFromDOForLoadSpecToVector::usage = 
"shearBuildingFromDOForLoadSpecToVector[ dofOrLoadSpecification, numberOfFloors ] returns a vector specifying the degrees of freedom or the load vector in a form appropriate for a building with 'numberOfFloors' floors.\n" <>
"\nNote:\n" <>
"\[Bullet] dofOrLoadSpecification for degrees of freedom is of the form:  {  (\"ux\" | \"uy\" | \"\[Theta]\"  or uppercase variations of same)[ index ] \[Rule] value ...  }\n" <>
"\[Bullet] dofOrLoadSpecification for loads is of the form:  {  (\"fx\" | \"fy\" | \"t\"  or uppercase variations of same )[ index ] \[Rule] value ...  }\n" <>
"\[Bullet] In the above specifications, index must be a non-zero positive or negative integer.  Negative integers imply specification from the end with -1 being the last floor, -2 the floor before the last and so on.\n" <>
"\[Bullet] If a duplicate specification is used then the first applicable rule applies.\n" <>
"\[Bullet] 'numberOfFloors' may take the value Automatic in which case the number of floors is inferred to be the minimum that is consistent with the specifications.\n" <>
"\[Bullet] 'numberOfFloors' may be omitted in which case it is assumed to be Automatic.\n" <>
"\[Bullet] 'numberOfFloors' may be replaced by a shearBuilding object in which case it is assumed to be the number of floors in the building.\n" <>
"\[Bullet]  If the 'numberOfFloors' is inconsistent with the minimum inferred number of floors then a warning message is given and the minimum inferred number is used.\n" <>
"";


shearBuildingCalculateDOFFromForces::usage = 
"shearBuildingCalculateDOFFromForces[ aShearBuilding, loadSpecification ] returna a vector of degrees of freedom representing the response of the building to the specified static load.  Only stiffness affects the calculated response.\n" <>
"\nNote:\n" <>
"\[Bullet] The load may either be specified as a specification of the form that may be identified by 'shearBuildingFromDOForLoadSpecToVector' or as a vector in either \"floor\" or \"building\" order (see 'shearBuildingDOFOrdering').\n" <>
"\[Bullet] The option 'shearBuildingDOFOrdering' applies to the output and to 'loadSpecification' in case the load is specified as a vector of values.\n" <>
"\[Bullet] The load may also be specified as \"gforce\"[ gForceFraction, gForceDirectionVector, eccentricityDistance ] where the load at each floor is the weight of the floor times 'gForceFraction' in the direction 'gForceDirectionVector'.  There is also a torque applied on each floor equals to the calculated force times the distance 'eccentricityDistance'.\n" <>
"\[Bullet] Forces are assumed to be in Newtons and distances in Meters.\n" <>
"";


{shearBuildingEarthquakeAnalyzeResponseSpectrum, shearBuildingResponseSpectrumForDisplacementFunction, shearBuildingEarthquakeResultsResponseSpectrumOpenerViewer,
shearBuildingEigenvalues, shearBuildingModePeriods, shearBuildingModeShapes, shearBuildingModeVsMassContributionsPercent};


{shearBuildingEarthquakeAnalyzeDirectIntegration, shearBuildingEarthquakeAccelerationData, shearBuildingEarthquakeMaxTime, shearBuildingDOFFunction};


(* ::Subsubsection:: *)
(*-------------------------------------------------------------------------------------------------------*)


(* ::Subsubsection::Closed:: *)
(*Polygon operations:  area, center of gravity, moments of inertia - THESE ALL NEED USAGE MESSAGES*)


{signedAreaOfPolygon, areaOfPolygon,cgOfPolygon,  momentOfInertiaRelativeToOriginOfPolygon, momentOfInertiaRelativeToCentroidOfPolygon, polarMomentOfInertiaRelativeToCentroidOfPolygon, polarMomentOfInertiaRelativeToOriginOfPolygon,
polarMomentOfInertiaRelativeToSpecifiedCenter};


(* ::Subsection::Closed:: *)
(*Error Messages for the exported objects*)


shearWalls::incom = "Incompatible setting of variable or option value: `1`";


shearWalls::noMem = "Object `1` has no object of type `2`";


shearWalls::incon = "Inconsistent or unknown value `1` for the parameter `2`";


shearWalls::locked = "Shear wall `1` is locked and may not be changed (unlock first).";


shearWalls::cantAddWall = "Wall `1` cannot be added to floor `2`";


shearWalls::wallIsMember = "Wall `1` is already a member of floor `2` and is not added again";


shearWalls::wallNotMember = "Wall `1` is not a member of floor `2` and cannot be removed";


shearWalls::nofloor = "Floor `1` does not belong to building `2`";


shearWalls::floorNoExist = "Floor `1` does not exist";


shearWalls::unknwnord = "Unknown ordering `1` for the degrees of freedom of the building";


shearWalls::centWrng = "Error in calculating a center for rotation of some floor.";


shearWalls::noEuroData = "Data for ground type or elastic response type unavailable for: response type = `1`, ground type = `2`";


shearWalls::unknwnDirFormat = "Specification of direction must either be a 2-D vector or an angle.  Specification \"`1`\" is of unknown type.";


shearWalls::rsNonNumeric = "Response spectrum function returns non-numeric values.  Function is specified as:  `1`";


shearWalls::eqNoGood = "Earthquake record must be a list of at least 2 pair of numeric numbers.  Input data specified as:  `1`";


shearWalls::tmaxNotNumeric = "Determination of tmax for integration gave non-numeric result.  Identified tmax as:  `1`";


shearWalls::dofMustMult3 = "Number of degrees of freedom must be a multiple of 3.  Degrees of freedom list is:  `1`";


shearWalls::hMustSameDof = "Height list must be same length as the length of the degrees of freedom divided by 3.\nHeight list: `1`.\nDof list: `2`";


shearWalls::dofOrLoadSpecNotValidString = "Degree of freedom or load specifications must be either all chosen from `1` or all from `2`.  Input was: `3`.";


shearWalls::floorsInferredMoreThanSpecified = "Number of floors inferred is `1` while number of floors specified is `2`.  Inferred should be less or equal to specified.";


shearWalls::dofSpecNotValidString = "Degree of freedom must be all chosen from `1`.  Input was: `2`.";


shearWalls::loadSpecNotValidString = "Load must be all chosen from `1`.  Input was: `2`.";


shearWalls::numberOfFloorsInvalid = "The specified or implied number of walls is invalid, value given or inferred: `1`";


(* ::Subsection::Closed:: *)
(*Set the private Context*)


Begin["`Private`"];


(* ::Subsection::Closed:: *)
(*Unprotect any system functions for which rules will be defined*)


(* ::Text:: *)
(*None*)


(* ::Subsection::Closed:: *)
(*Unprotect the functions to be defined - NEEDS TO BE DONE*)
(*(Note: needed if repeated redefinition during debugging)*)


Unprotect[  shearWalls ];


(* ::Section::Closed:: *)
(*Notes*)


(* ::Subsection::Closed:: *)
(*Notes on wall stiffness*)


(* ::Subsubsection::Closed:: *)
(*How the wall is modeled*)


(* ::Text:: *)
(*The wall is modelled as a cantilever with forces applied at discrete points which we call nodes that correspond to the slabs pushing on the wall. *)


(* ::Text:: *)
(*The slab is pin-connected to the wall so that the applied moment at the nodes are all zero.*)


(* ::Text:: *)
(* Let the in-wall-plane forces and in-wall-plane moment at each floor level be  { Subscript[Fw, i], Subscript[Mw, i]};   The force vector for the whole wall is FVw =  { Subscript[Fw, 1], Subscript[Mw, 1], Subscript[Fw, 2], Subscript[Mw, 2], ...}*)
(* Let the in-wall-plane displacement and in-wall-plane rotation at each floor level be  { Subscript[uw, i], Subscript[\[Theta]w, i]};   The force vector for the whole wall is  UVw = { Subscript[uw, 1], Subscript[\[Theta]w, 1], Subscript[uw, 2], Subscript[\[Theta]w, 2], ...}*)


(* ::Text:: *)
(* We then have:*)


(* ::Text:: *)
(*	FVw = Kw UVw*)


(* ::Text:: *)
(*where:  Kw which we call the global shear wall stiffness in wall coordinates (coordinates with uw's along wall) is obtained by assembling (eg. using direct stiffness method) floor-sized sections for a cantilever*)


(* ::Subsubsection::Closed:: *)
(*Stiffness of a wall over a single floor*)


(* ::Text:: *)
(*A floor-sized member from floor 'i' to 'i+1' (neglecting shear stiffness) is given by:*)


(* ::Text:: *)
(*	KFBw  = ({*)
(* {12 Subscript[EI, i]/Subscript[H, i]^3, -6 Subscript[EI, i]/Subscript[H, i]^2, -12 Subscript[EI, i]/Subscript[H, i]^3, -6 Subscript[EI, i]/Subscript[H, i]^2},*)
(* {-6 Subscript[EI, i]/Subscript[H, i]^2, (4 Subscript[EI, i])/Subscript[H, i], 6 Subscript[EI, i]/Subscript[H, i]^2, (2 Subscript[EI, i])/Subscript[H, i]},*)
(* {-12 Subscript[EI, i]/Subscript[H, i]^3, 6 Subscript[EI, i]/Subscript[H, i]^2, 12 Subscript[EI, i]/Subscript[H, i]^3, 6 Subscript[EI, i]/Subscript[H, i]^2},*)
(* {-6 Subscript[EI, i]/Subscript[H, i]^2, (2 Subscript[EI, i])/Subscript[H, i], 6 Subscript[EI, i]/Subscript[H, i]^2, (4 Subscript[EI, i])/Subscript[H, i]}*)
(*})*)


(* ::Text:: *)
(*where:  E is Young's modulus*)
(*	Subscript[I, i] = Subscript[t, i] \!\( *)
(*\*SubsuperscriptBox[\(L\), \(i\), \(3\)]/12\)*)
(*	Subscript[t, i]  is the thickness of the wall between floors 'i' and 'i+1'*)
(*	Subscript[L, i] is the length of the wall between floors 'i' and 'i+1'*)
(*	Subscript[H, i] is the height of the wall between floors 'i' and 'i+1'*)


(* ::Text:: *)
(*where:   ({*)
(* {Subscript[Fw, i]},*)
(* {Subscript[Mw, i]},*)
(* {Subscript[Fw, i+1]},*)
(* {Subscript[Mw, i+1]}*)
(*}) = KFw ({*)
(* {Subscript[uw, i]},*)
(* {Subscript[\[Theta]w, i]},*)
(* {Subscript[uw, i+1]},*)
(* {Subscript[\[Theta]w, i+1]}*)
(*})*)


(* ::Text:: *)
(*If we want to include the shear stiffness, then we consider the stiffness due to shear also as follows:*)


(* ::Text:: *)
(*	KFSw  = ({*)
(* {Subscript[GA, i]/(cf Subscript[H, i]), -(Subscript[GA, i]/(2 cf )), -(Subscript[GA, i]/(cf Subscript[H, i])), -(Subscript[GA, i]/(2 cf  ))},*)
(* {-(Subscript[GA, i]/(2 cf  )), \[Infinity], Subscript[GA, i]/(2 cf  ), \[Infinity]},*)
(* {- (Subscript[GA, i]/(cf Subscript[H, i])), Subscript[GA, i]/(2 cf  ),  (Subscript[GA, i]/(cf Subscript[H, i])), Subscript[GA, i]/(2 cf  )},*)
(* {-(Subscript[GA, i]/(2 cf  )), \[Infinity], Subscript[GA, i]/(2 cf  ), \[Infinity]}*)
(*})*)


(* ::Text:: *)
(*	KFSw  = ({*)
(* {Subscript[GA, i]/(cf Subscript[H, i]), 0, -(Subscript[GA, i]/(cf Subscript[H, i])), 0},*)
(* {0, Subscript[GA, i] h / (4 cf), 0, Subscript[GA, i] h / (4 cf)},*)
(* {- (Subscript[GA, i]/(cf Subscript[H, i])), 0,  (Subscript[GA, i]/(cf Subscript[H, i])), 0},*)
(* {0, Subscript[GA, i] h / (4 cf), 0, Subscript[GA, i] h / (4 cf)}*)
(*})*)


(* ::Text:: *)
(*where:  G is shear's modulus*)
(*	Subscript[A, i] = Subscript[t, i] Subscript[L, i]*)
(*	cf = 1.2   (cf is a correction factor to get an effective shear stiffness for the section due to non-uniform variation of the shear over the cross-section)*)
(*Note:  The rotational stiffness is infinite because a shear beam cannot develop rotation without a shear deformation*)


(* ::Text:: *)
(*The combined stiffness is obtained as springs in series so that if we call 'KFCw' to be the combined stiffness then:*)


(* ::Text:: *)
(*	KFCw[[i, j ]]  =  1/(1/KFBw[[i, j ]] + 1/KFSw[[i, j ]])          (note:   1/\[Infinity] is taken to be 0)*)


(* ::Text:: *)
(*In what follows, the floor stiffness matrix is referred to as KFw  and may be KFBw, KFSw or KFCw depending on user preference*)


(* ::Subsubsection::Closed:: *)
(*Assembling global stiffness in wall coordinates and static condensation*)


(* ::Text:: *)
(*The global shear wall stiffness Kw may be assembled from KFw's using the direct stiffness method.  Note that we assume Subscript[uw, 0] = Subscript[\[Theta]w, 0] = 0.  Once assembled, the rows and columns may be rearranged so that all the displacement components for the floors in order are written first and then the wall rotations are written.  The modified force and displacement vectors become:*)
(*	 FVMw =  { Subscript[Fw, 1], Subscript[Fw, 2], ... , Subscript[Mw, 1], Subscript[Mw, 2], ...}      and       UVMw = { Subscript[uw, 1], Subscript[uw, 2], ... , Subscript[\[Theta]w, 1], Subscript[\[Theta]w, 2], ...}*)


(* ::Text:: *)
(*The global shear wall stiffness KMw becomes:*)
(**)
(*	KMw = ({*)
(* {Subscript[KMw, u u], Subscript[KMw, u \[Theta]]},*)
(* {Subscript[KMw, \[Theta] u], Subscript[KMw, \[Theta] \[Theta]]}*)
(*})*)
(*where the u's denote displacement degrees of freedom and \[Theta]'s denote rotation degrees of freedom.   Each of the submatrices have dimensions n*n  where 'n' is the number of floors.*)


(* ::Text:: *)
(*Since Subscript[Mw, 1] = Subscript[Mw, 2] = .... = 0, we can use static condensation to obtain a reduced stiffness matrix in terms of the displacements only as follows:*)


(* ::Text:: *)
(*	\[Theta]w = - Subscript[KMw, \[Theta] \[Theta]]^-1. Subscript[KMw, \[Theta] u] . uw*)


(* ::Text:: *)
(*	KRw = (Subscript[KMw, u u] -  Subscript[KMw, u \[Theta]] . Subscript[KMw, \[Theta] \[Theta]]^-1. Subscript[KMw, \[Theta] u] )*)


(* ::Text:: *)
(*where:    FVRw  = { Subscript[Fw, 1], Subscript[Fw, 2], ...  },   UVRw = { Subscript[uw, 1], Subscript[uw, 2], ... }*)
(*and:        FVRw = KRw . UVRw*)


(* ::Subsubsection::Closed:: *)
(*Relating slab motion to wall motion*)


(* ::Text:: *)
(*At each floor, we have slab displacement and rotations {Subscript[us, i x], Subscript[us, i y], Subscript[\[Theta]s, i]} and the wall displacement Subscript[uw, i]*)
(*The slab and wall displacements are kinematically related as follows:*)


(* ::Text:: *)
(*	Subscript[uw, i]  =  {Subscript[us, i x]- Subscript[\[Theta]s, i] Subscript[\[CapitalDelta]rw, y], Subscript[us, i y] + Subscript[\[Theta]s, i] Subscript[\[CapitalDelta]rw, x]} . {Subscript[tw, x], Subscript[tw, y]}*)


(* ::Text:: *)
(*where:  {Subscript[\[CapitalDelta]rw, x], Subscript[\[CapitalDelta]rw, y]} is the relative position vector from the center of rotation to any point on the wall*)
(*	{Subscript[tw, x], Subscript[tw, y]}  is a tangent vector along the wall*)


(* ::Text:: *)
(*The above may be written in matrix form as:*)


(* ::Text:: *)
(*	Subscript[uw, i]  =  (  {*)
(* {Subscript[tw, x],              Subscript[tw, y],         (- Subscript[\[CapitalDelta]rw, y] Subscript[tw, x] + Subscript[\[CapitalDelta]rw, x] Subscript[tw, y]}*)
(*})   )({*)
(* {Subscript[us, i x]},*)
(* {Subscript[us, i y]},*)
(* {Subscript[\[Theta]s, i]}*)
(*})*)


(* ::Subsubsection::Closed:: *)
(*Relating forces and torque on slab to forces on wall*)


(* ::Text:: *)
(*At each floor, we have a wall force Subscript[Fw, i].  In global coordinates, this is given by:*)


(* ::Text:: *)
(*	Subscript[*)
(*\!\(\*OverscriptBox[\(Fw\), \(\[RightVector]\)]\), i] = Subscript[Fw, i] {Subscript[tw, x], Subscript[tw, y]}*)
(**)
(*If we choose a center for the slab at a specific point and denote by {Subscript[\[CapitalDelta]rw, x], Subscript[\[CapitalDelta]rw, y]} the relative position vector from the center of rotation to any point on the wall, then the static equivalent of the wall force at that center is given by:*)


(* ::Text:: *)
(*	{Subscript[Fs, i x], Subscript[Fs, i y], Subscript[Ts, i]} = {Subscript[Fw, i] Subscript[tw, x],  Subscript[Fw, i] Subscript[tw, y], {Subscript[\[CapitalDelta]rw, x], Subscript[\[CapitalDelta]rw, y]} \[Cross] {Subscript[tw, x], Subscript[tw, y]} Subscript[Fw, i] }  *)


(* ::Text:: *)
(*where:   Subscript[Ts, i] is the torque on the slab about the center on the i'th floor*)


(* ::Text:: *)
(*In matrix form, this gives:*)


(* ::Text:: *)
(*	({*)
(* {Subscript[Fs, i x]},*)
(* {Subscript[Fs, i y]},*)
(* {Subscript[Ts, i]}*)
(*}) = ({*)
(* {Subscript[tw, x]},*)
(* {Subscript[tw, y]},*)
(* {- Subscript[\[CapitalDelta]rw, y] Subscript[tw, x] + Subscript[\[CapitalDelta]rw, x] Subscript[tw, y]}*)
(*}) Subscript[Fw, i]*)


(* ::Text:: *)
(*Note that the above operator is the transpose of the one relating wall to slab motion*)


(* ::Subsubsection::Closed:: *)
(*Relating global stiffness in wall coordinates to global stiffness in global coordinates*)


(* ::Text:: *)
(*In order to relate slab motion to static equivalent of the wall on the slab then we simply substitute the relations obtained in the previous section.   This implies that every element of KRw is replaced by that element multiplied by the outer product of (  {*)
(* {Subscript[tw, x],              Subscript[tw, y],         (- Subscript[\[CapitalDelta]rw, y] Subscript[tw, x] + Subscript[\[CapitalDelta]rw, x] Subscript[tw, y]}*)
(*})   ) by itself.   If we call the global stiffness matrix of the wall to be KGw then:*)


(* ::Text:: *)
(*	KGw[[ i, j ]]  =   ({*)
(* {Subscript[tw, x]^2,             Subscript[tw, x] Subscript[tw, y],          Subscript[tw, x] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y])},*)
(* {Subscript[tw, x] Subscript[tw, y],           (Subscript[tw, y]^2),          Subscript[tw, y] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y])},*)
(* {Subscript[tw, x] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y]),         Subscript[tw, y] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y]),          ((Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y])^2)}*)
(*}) KRw[[i, j ]]*)


(* ::Text:: *)
(*Note:*)
(*Useful mathematica operators to handle above:*)
(*Outer[Times, {twx, twy, -\[CapitalDelta]rwy twx + \[CapitalDelta]rwx twy}, {twx, twy, -\[CapitalDelta]rwy twx + \[CapitalDelta]rwx twy}] // FullSimplify // MatrixForm*)
(*Table[  {{a, b}, {c, d} } i j, {i, 1, 4}, {j, 3, 5} ] // ArrayFlatten // MatrixForm*)


(* ::Subsubsection::Closed:: *)
(*Combining shear and bending stiffness*)


(* ::Text:: *)
(*Let:*)
(*Kb be the reduced stiffness in bending*)
(*Ks be the reduced stiffness in shear*)
(**)
(*The two modes are in series (same wall with competing deformation modes):*)
(*Kb ub  = Ks us  = F      and       u = ub + us      and       K u = F*)
(*ub = Kb^-1 . Ks . us      and    u = (I + Kb^-1 . Ks).us*)
(*Ks . us = K . u = K . (I + Kb^-1 . Ks).us*)
(*Ks = K . (I + Kb^-1 . Ks)   \[Implies]   K = Ks . (I + (Kb^-1 . Ks))^-1*)


(* ::Subsection::Closed:: *)
(*Notes on modal analysis*)


(* ::Subsubsection::Closed:: *)
(*Orthogonality*)


(* ::Text:: *)
(*Given:*)
(*  m *)
(*\!\(\*OverscriptBox[\(u\), \(..\)]\) + k u = 0   *)
(*  where:  'm' is a diagonal positive-definite real matrix and 'k' is a symmetric positive-definite real matrix*)


(* ::Text:: *)
(*Let:*)
(*\[CapitalPhi] be a matrix whose columns are the eigenvectors of the system above  (in Mathematica, this is obtained as *)
(*\[CapitalLambda] be a diagonal matrix of the corresponding eigenvalues*)


(* ::Text:: *)
(*This implies that m \[CapitalPhi] is in the same direction as k \[CapitalPhi]  (proportionality constant is the eigenvalue)*)
(*We then have:*)
(*- m \[CapitalPhi] \[CapitalLambda] + k \[CapitalPhi] = 0*)


(* ::Text:: *)
(*Let:*)
(*M = \[CapitalPhi]^T m  \[CapitalPhi]*)
(*K = \[CapitalPhi]^T k  \[CapitalPhi]*)


(* ::Text:: *)
(*Then:*)
(*M and K are diagonal matrices if the eigenvalues are all distinct*)
(*Let Subscript[\[Phi], i] and Subscript[\[Phi], j] be two distinct eigenvalues then:*)
(*Subscript[\[Lambda], i] m Subscript[\[Phi], i] = k Subscript[\[Phi], i]*)
(*Premultiply by *)
(*\!\(\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\) to get:   Subscript[\[Lambda], i] *)
(*\!\(\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\) m Subscript[\[Phi], i] = \!\( *)
(*\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\ k\ *)
(*\*SubscriptBox[\(\[Phi]\), \(i\)]\)*)
(*Now both  'm' and 'k' are symmetric so that \!\( *)
(*\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\ k\ *)
(*\*SubscriptBox[\(\[Phi]\), \(i\)]\) = \!\( *)
(*\*SubsuperscriptBox[\(\[Phi]\), \(i\), \(T\)]\ k\ *)
(*\*SubscriptBox[\(\[Phi]\), \(j\)]\) = Subscript[\[Lambda], j] *)
(*\!\(\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\) m Subscript[\[Phi], i]*)
(*\[Implies]  (Subscript[\[Lambda], i] - Subscript[\[Lambda], j]) *)
(*\!\(\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\) m Subscript[\[Phi], i] = 0  and since (only if) \[Lambda]'s are distinct then \!\( *)
(*\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\ m\ *)
(*\*SubscriptBox[\(\[Phi]\), \(i\)]\) = 0*)
(*If Subscript[\[Lambda], i] != 0 \[Implies]  \!\( *)
(*\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\ k\ *)
(*\*SubscriptBox[\(\[Phi]\), \(i\)]\) = 0  since   Subscript[\[Lambda], i] *)
(*\!\(\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\) m Subscript[\[Phi], i] = \!\( *)
(*\*SubsuperscriptBox[\(\[Phi]\), \(j\), \(T\)]\ k\ *)
(*\*SubscriptBox[\(\[Phi]\), \(i\)]\)   (a \[Lambda] will be zero only if the matrix is singular)*)
(*The above implies that both M and K are diagonal matrices.*)


(* ::Subsubsection::Closed:: *)
(*Orthogonal damping matrix  (ref: "Dynamics of Structures" by Clough and Penzien;  also many others)*)


(* ::Text:: *)
(*If the damping matrix is orthogonal to the eigenvectors of m *)
(*\!\(\*OverscriptBox[\(u\), \(..\)]\) + k u = 0  then these same eigenvectors may be used to decouple the matrix equations:*)
(*m *)
(*\!\(\*OverscriptBox[\(u\), \(..\)]\) + c *)
(*\!\(\*OverscriptBox[\(u\), \(.\)]\) +  k u = 0 *)


(* ::Text:: *)
(*If 'c' is orthogonal to the eigenvectors, then let u = \[CapitalPhi] Y(t)  where Y(t) is a list of time dependent amplitudes*)
(*Then:*)
(*     \[CapitalPhi]^T m \[CapitalPhi] *)
(*\!\(\*OverscriptBox[\(Y\), \(..\)]\)(t)  + \[CapitalPhi]^T c \[CapitalPhi] *)
(*\!\(\*OverscriptBox[\(Y\), \(.\)]\)(t) + \[CapitalPhi]^T k \[CapitalPhi] Y(t) = 0*)
(*     M *)
(*\!\(\*OverscriptBox[\(Y\), \(..\)]\)(t)  + C *)
(*\!\(\*OverscriptBox[\(Y\), \(.\)]\)(t) + K Y(t) = 0 *)
(* and 'M', 'C' and 'K' are all diagonal and hence we have decoupled system of ODEs*)


(* ::Text:: *)
(*The most general way to specify 'c' to be orthogonal is to choose it as follows:*)
(*        c = (\[CapitalPhi]^-T) C (\[CapitalPhi]^-1)     where:   'C' is a diagonal matrix*)
(*        Usually, the diagonal elements of 'C' are written as:  Subscript[C, n] = 2 Subscript[\[Xi], n] Subscript[\[Omega], n] Subscript[M, n]  where Subscript[\[Xi], n] is the damping ratio*)


(* ::Text:: *)
(*Computationally, if we write: Subscript[C, n] = 2 Subscript[\[Xi], n] Subscript[\[Omega], n] Subscript[M, n]  where Subscript[\[Omega], n] = Sqrt[Subscript[\[Lambda], n]] (assuming all Subscript[\[Lambda], n]'s are positive) *)
(*Then we can show that   c = m \[CapitalPhi] \[Zeta] \[CapitalPhi]^T m*)
(*Note:  *)
(*\[Bullet]  It takes less than a second to invert a 1000*1000 system of (fully populated) equations in Mathematica on my MacBook circa 2011 so that the above computational shortcut is not really needed.*)
(*\[Bullet]  For buildings less than 50 floors the system is less than 150*150 and this would take less than 5/1000^th of a second (see below)*)


(* ::Text:: *)
(*With[ {nDim = 150},*)
(*  With[ {m = RandomReal[ {1, 10}, {nDim, nDim} ]},*)
(*    Timing[ Inverse[ m ]; ] // Print;*)
(*    (((Inverse[ m ] . m) // Chop) - (IdentityMatrix[ nDim ] // N)) // Flatten // Norm*)
(*    ]*)
(*  ]*)


(* ::Text:: *)
(*{0.003488, Null}*)


(* ::Text:: *)
(*1.73279*10^-12*)


(* ::Subsection::Closed:: *)
(*Notes on available response spectra*)


(* ::Subsubsection::Closed:: *)
(*Eurocode - relevant sections*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJzsvc/L997W3/UB/wJBKI6ksw7aqIhDxUxEEBoQdfAYLFTMQCmmWpSAozgo*)
(*EcrTINIMCgEloESk0QdSxAimtA1CsAYeQiEe4oEcMEIO5AwyyOA2yd472fmd*)
(*fK7P9eO+7veL58f3zvVJ9u+91157rbX/7F/+j/6Nv/xPPB6Pv9j9n3+3+9/+*)
(*v38AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8QdoqjaMgCMIoqdpL*)
(*LxRpHPa/j/OquZZCEUf9G3GaX3rhfhLHNPUmVd00O396QaJdsmkUeH6Y16/4*)
(*2LvB10DTXOoBM9rZB+6/f5WmTAPPC5Pi3VIAAAAAfnXy0BIfPKKbVAe/b4tI*)
(*nb+gWNGhMNBGtjp7QVDC8uiN+0mcUjvK/Is0J2qcx5qw9RfFebs0lzoy+5x5*)
(*VKfvQFuX5VUZrR6zObS/dbfgTWrzVWfGr5KD27LgdipNMmbTiMoXJQE+mjs9*)
(*EwAAwEdTReaGVPRQs72Zu02VrRc0L99LInO338hfl8Rlcl3Y/mCTutxf1OQ1*)
(*ok3DSVxi9KFqw9oUHnp0QxqNDInmVLotGfZUIXu/kwxfIwXXcdc5jelbTTJ2*)
(*DNGIXpIE+HBu90wAAAAfB5HBJD1Ms9ifaQ6tHdmIiHmCrBn6XHzbUzRRMU9Q*)
(*DWOhtNvTLN1O4ga1LU3fs/gMcPqoh2S/SojLHGXM/EeuhemQ7i0JLbHkN9Vz*)
(*E48V+BrJkMiBfGaaacvwKuETfDBP9EwAAAAfRpPYomSNx3KDiobiZptWdpXR*)
(*rdUmVdc0uc/JWWq69UYdd29I7OivCYzpDcVJX5LEHWaS4Wx54gSbV4igE2WW*)
(*xHH6kfrC3Nep6Hunvr6WZNhmukil9JlquSn72iy+ttUm2OG5ngkAAODTKDx2*)
(*orp3mtyW2cx/JBhN9PbEibrIS+6Nwhcm+WHzjftJ3OA5ybD0LU0UBLFHNuxg*)
(*tJFs8sAwTGvANN2iW/sCS+5+KkhO/NvA6v9o91iWE3aFaoqw+93w4x5rxDSd*)
(*gB5tV4mvyTQ1WTWCdJLcA4u+0/2/MCuzPq0hMcVgjkNt7HAmnZJu26Zph6Q+*)
(*O6nKtfTu24/uHUFUdDvhrD0vSoZ1FhrKUImCqJr+ZO23LRk2SeDqikyTlBTL*)
(*T/ielYd2n58uTVmzbV2Se21tW8Yqd7SvW3ZX4OBP/1FXnVZfnU5XnSHXR5o8*)
(*1Ics9VUh636yaYLYBLY5NpXT7VXa3NLk/hXVmap4r3TbWW26JmataFpumESu*)
(*IvUt0v1mlY3dXlRnPutFZtdPyiq1hh7QZc3wzqtrzHvoGJIw/FVSvQNT4Saz*)
(*u4IPLa2Zti5LVlL3PVkfq8cOk8Q1lCEP3W/8VYUepbXTHJs983/1Dxqly2ff*)
(*4jRLXSItP9wsr2iXzepGeR45tAlYxlLfGhslyLCnAACA67S+Ro97ncsGfaNx*)
(*mqAFl16oQnakLPiHTijPJ3HE/DQ54STQNt2WDJuMSaaSYY4aT4UettcppwSV*)
(*TEubvmFEeeRO3xw8UJhWVlC0bsmbeeUobtZ9L/PoFyTVMDT6acVJSGKRoz32*)
(*EIfvJ1tWo6rXlbMI6Z802zXVMdPyKJ5fkQy7lZn8RHdcXaLpUj/htWTYFuST*)
(*gmK4jjklacfkjSLQaVXZDvtal3RtbbkKuf/XP3aNqToNJnyWkUXLZZrjn60t*)
(*pWXqG1NtaaY2pUJNQA9Kt5PVH50cwnWoJeZoTXfYi+o82vSBWnxkLw9DVecG*)
(*VbHqrkP1cka46cFd0K8ohmPTX/btVeeOtl8UibOFOExrrzn2euY/OmqUbis0*)
(*jRHRTH60mTWZpNBWS31zv/IekrT4o5JAWwkAAOc0aeTp8jSFiqpz7TiwGhdx*)
(*+5rPxnRgLV+05budxHH6vGTYrY2+R/A9i7NpnESjTloW2CLWi8slXZ17cY38*)
(*pp275Y6VKJq9/JPaM3GrTrp1UwyHym0Sm6txs1esFD77tzbI5sXoL+PQ4+iZ*)
(*1GRFGaeHkaiHSxVNniCTA2/B8v3wyl5/M/7GYILHuWRYBjQ7itvnnzUlqZm1*)
(*ZDjWlaj3In0yyoYicdNumGeSMkinwz9Z0rE1/niydvjRJkvhc9xoDFkK6Qk0*)
(*rfwVjb0t+wwyxlHpjrKaWpO8qvRCb8k90ItrvYg35OiGRlZEY7syy4qjPASs*)
(*o7i9rn/sJBua/zZzuax2vdeZKpOr3j6V6kcVW+O/NZ/KfkdpHTfHds88bBQu*)
(*S5JJMjwON4ltamZf0P2sTBxeHLTCvIimghhwfgEAgFOadK2ykO1NI8A5ZUCV*)
(*B9bmQrwBWyzkq46695M4pN5ZhhaLEhONVmffg2hHoDpP7slDUL22k7o827Tc*)
(*rO7/uhC3uh9LOtF85rz6z+nNrtqAraQsA/UoHzF96ZR/4pzbrBfKzVPdhhMF*)
(*46Y35mQFGyv2VDKMmWinekTeYas28WVepZtMuTf7JMNRO0QUlRUn5YpO90oT*)
(*SaJRLjLDO0pvJEEfENkjZ8KTYGz2Fr71BTdr2iK2TdMNs7PSXcuqQJ/UnL9/*)
(*323u9SIpHGpzzKpEpdz9PNSjxKUR6W3cj1grgw1eBCUbwNiQ9LBcVK8ekKJU*)
(*5qSiGxriMK2T5ti2NzhqFP4VUg98RbHCcYNCDxe9nQqlzWpPAQAA4IymiDT+*)
(*FE88jb/HJmTpqtftOKubV7ftt5O4+sH1GlFPq8koGnHLqEBdcqbTcPo6Lxmu*)
(*F509cSvh9EoClRWnpX+QMHumSDK0OeqFwMCnTsWA7fWXhJQc7N/iyOGcvpng*)
(*cSoZcmKqrOq6ro0RJ0moxlW6bRmpg3mXZvtx4MhT7yJreuursw2JpHtjdrcz*)
(*s0yC06AqPslk5Lu24xOx/Kj1l937uHTXsjoKsbxyLK5u9iJSOVxWqaf8bh7q*)
(*UbMnSJre532tEB5pJ1ti+pkpeClXvaNIGU2aXqs6Seu3J81xKhmu55ybkiHb*)
(*5kzBqWj3frnjPAAA/CoUxji3nwW1y1xy3qVcPeNtU/qCnVzMze0kzrnngcIt*)
(*Q3LcLH+2WtPFYGU5uS3hjAeX5MsbC1yyfJ02x5FkSItzsAi2pWfOQ47fkQz5*)
(*qjMs0+hdaLr/NWziVLKTbpl4VMiaykzX9DpxFpl5KNSM4aJkuK6xQ3jlUrD3*)
(*p83S3cvqXJ652YtWkuHUG7fzwPeBh2JQ76Yu64a9daFR7ayihTrJbs/htjC9*)
(*ucJhWr8/aY4zyXDVKPclQ9qZV08gGQIAwLO0GVt9DuPvtbk3rPZyyMyFqsi2*)
(*goM7y6h7i2SG7Ell63ax74NyP4krvFUyXEtiW0vVxJaEw4e/ZkZ6w7et5cK6*)
(*Fg+elwybbIz/o6Z1NebhCZ2htGnFt5Fu4zOdp+qk9di1uIpqMm9xvE/OW6/q*)
(*DA/UTVtFWCmXLpfuVla5s0s9LJ/qRRuS4V4eZu9ecq9ofH3+GXHbHuDH6qz8*)
(*MK2z5jiTDDcsRjhNPiRDAAD4ENqqnN9JPJroKO7wvI2d/mRGkPSoYD9sM3JY*)
(*I1lBmsRRFIVef44kDcrAtoz13h9Q0J3pPjsWx0wOkiSOu1dCuxcU5cFP8HYS*)
(*b+BpyZCeA87X9IXN2CXJsIomZ8xxAc09VTT/3pg3YfAmfqlkOJk1mn2lt6vF*)
(*9JbOUOakgtJ3Blu5VbqFr44fbLZ8BxJbc7K22wPY3DkpkYqv2RkuPM25XLcn*)
(*p8kr8e+kdNeyypyqmHEsyedTvWhDMtzLA/81XriqYn8jgE8da6rbDgFwlopr*)
(*/jSZVSZv+7rQT67S+s1Jc5xKhhsyeTmeYpC/bhjWQjIEAICX0XhkiRGUYIwO*)
(*xyzMqUFUORnPP1SfzO+ush0lgqwFAefNQiOOMXfIJWQlvZ/EG9iXJeZ3oLDq*)
(*mLyD6Qo+eWsS9+HuvdVZIcdSbGgz7jRXcMkFgW2mDN+fXFZFc+GBwlSLzULB*)
(*0qztDHk1i512a6Kue79Pp4NIxQ7iYAr0IZlh3cydZXYMCdjhPimrNXSZaoiy*)
(*M/hBLOUKTjUqqEESW1ObSmFedcJCbIoPkUpTEfMN1we1cMwFuUm6X9q6m9Z8*)
(*G5G2KwLej6frxoN80/try1vBSY5On49Ld5BV7rxVJYkW/pgrafBDv9CLlgIP*)
(*b2fI/LX38jDrVA8z7D9Zpb09oR5uSIbi2PPLaHQRKeYtqNIo9MVYEnod4WFa*)
(*J82x1TObE5OAaQgMGWi8ybBx085w+AJ3vSYVX1c9BwAAwBac42E3sbthlsUk*)
(*YpzqUsfkhg/JMsg2Eec6MYdETan5o9J+Eq6ivRdIOI77SbyBOuGt+BUnHlVL*)
(*Y7i/ATlkt2xULN6FoDhVWzlMvDHYmpuP4txDsOPFQlz7o8qlPxZvp2As/c/N*)
(*rMgC1yLhggZVRsX+LjhJVY3BN0hMmyE3Y9WIei9Fj5dKPPp4HUTK4JxYBWHQ*)
(*3oZzy8YVQid7NFxWpbXBZM9cKngwy0F3kKKa3J/eN8J2vkdYYybUlVVQ7ayq*)
(*U5cIFYI/7CY42ekh9N8VgnKehEk00iXfh0c0fysi5xiI79G3/VJmOizdQVZ5*)
(*Z6Je2xtM14SPV/mc9qJ4+ojo571icLrgW9DJBuIgD5k3zzt5l/kxzaDin2iH*)
(*WV0lpIkELVhYivZv2547hSScht5hWsfNsdUzjxtlitUzZFqc9SgaRJH/wnCj*)
(*E99PBM3vZdJsuhVdsbetBQAAAPzoJ3njsUBU/ZQ/bZl8UnrBgwsHsXrRYDGB*)
(*2Te7FW2m/FnClsXbSTxFy0k+s496yU6cYXY4WMbO/E3RGW/7mwczfMwudpmi*)
(*2DH+6K/8+b2yjRELi0XAYVFzqDXmfOHehKgNmzwY9XOiag95rUdliyCpfci3*)
(*UUUmqFHZrLK6cTLe08kSs7qQnEEYbrnALPQPXVZSb3K2toKynMRy1e7lurhv*)
(*+Nl75mRH2gTmJGHZUVkny6qmtyu2uTXTMAumvxlwaRWwaH1ovlO6H4dZ5SVD*)
(*kXtd0lx+IB30omR3KzTL6mF1/UjcWRR0SVtLWaQaov4r/GdkM9/oYHxmOf/l*)
(*07QOm2PVM88bpS0CLleyZevc1zvB+PeLL4iaoc4rWuFibtN627mxHQAAQE9b*)
(*51lKyMvNCbMp8qwoL5m20xfKIstvXW17O4mPhtRS/z/5dkCUl1KX+WGLXKGt*)
(*66qe57WpO6ZKbpv+F098ueg7TNY18YUG69Noply0dVWNWej6Sd/mTd21fve5*)
(*avW5PofVpfquipxk6c2ts126g6zyBgPd47L/QVasC/Pjrb3ovLrqYsj6TuqU*)
(*uigGn5dukPal3Da1tdOmSy/Ldlv5OK3D5tjomSf09dYn9QFDDwAAAADgLfCe*)
(*Oz+3bwPcNAAAAAAA3sZ0AeLkuPRz0vJuGj93UQAAAAAAPp4yDTifJsHy469s*)
(*E3FEUwbW5FoiKFacbxsqAgAAAACALWpPV9XhlrgBTZUVN/0pvRuazFMUdSqJ*)
(*pii691OWBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPwaVImnKlax*)
(*eJhFYVLyT3xNNrxk+XLbVGvqun3fLC/Tret6lYfmvbOwTVOGrikJop3U75dI*)
(*mYamKkl68PJ6LiNbliTFDD6p+s7py65JouK8Y/2Cd6eOPUuWRKnrbJoZ5U82*)
(*5vsNhFdQOlo/mPz8XQbT1x+q710Db+JDJuoreZDfJw8/Q/cAX5fEUR+Ph+pE*)
(*Y/+pstBQxO6hYET8L+vU7R4+FLucPXT6n24gSIoeZu816Lp0he10R/Ti/DMv*)
(*JnOUMXkzrt4ljSad0hDNl6eReyr5dPQFBa82VaeyW+9Tv+ADKC1pmGAsU2LN*)
(*GZTnr81454HwAupIpLmL3+PzX3qoEt65Bp7mIybq0zy46rvm4SfoHuCrQjqn*)
(*7ufjk8SWxu4qrYZzm/vCMM4XQlcR6OQV1Q6yLPFtfRTb7Pccd5nH0nWTqip7*)
(*iiKNPKVPXvqwEZF6DillU5Z54onvO+E0RZF7ukiko5cXsdtpdp+WdP8jd5pj*)
(*BZ7RlO9Z9l+ROnHc1UHAO5MO67Lm97NIm7lscbzUnlxXed+B8ApKW+2yJ7+f*)
(*zvDjh+oJy+70vjVwl4+dqE9oqhfnYTGLfsXuAX4GmtTp9+16MHtYV+2PNjSk*)
(*TcnwBxMCRT2cvZVYZHq3EtoNq8hksqGWr7/yIkpfZunOV4bC60r2QZJhm3aZ*)
(*MKJxTJaG8O4TThkaX3hBvMmyAk8ofO37lP2zyZyu7j9Y4VZbw3JoMVGwyuIg*)
(*TC6tX6uu8q0Gws/PZ3Sny3zGRH1Grr0qDzdnUQB2KAa9nuAVGxY6iSXvSYbd*)
(*gDKHid3NpxdrJhlyPby2qPbxHXV3W+kSmsB2so/YLLXBoLWwppWtJmrXd51w*)
(*aMG/w4nqugJPaFjZIQy8lcLvq16yP1arQAfI9RZnbHSVbzQQfn4+pztd5HMm*)
(*6jNelYfbsygAm7C99vb+7lAypIdBD9UbRcNNyZCdS0vXjomeYSvdNnbddDU+*)
(*iiSwDE3t0Aw3zHhpuK1y3zZUM6ibzNa17gfhRXv4tvR0WkjV8qMwjLJqWvi6*)
(*TFSJbfZfNJ2wWr6aOqauKn2GLO+27EwLPkzCie/oWoe5tup8otTDc123Y/Lj*)
(*QZ/DE0X0P+Jyav4icK0hGdWw3Kzi02ny2NdV1e/2EVVf5FltbFdg/zzsP6h0*)
(*1aMbVpDMjBfqt0iGde51pe4rRLfcsJzvio6qq84Dx1ANv3tYxJ7R17juhkQd*)
(*3rAmMPx4ympfk5bpdd2gLbqq1rQ+zbhYds2zNtJVo3evSAPaykG27Er9n1Ty*)
(*AYt35Th+vUo9WvWC6vetShq0/9pQ85rt+Y751JK12x/arEuImVep9pBslF1y*)
(*HtnpKtcGwm4VXaTtuq6hKYqiGbbv26bDT4wHH2+Hzq9HUz/bq942T4KuX3rd*)
(*MGmLrov2ncV0STmaIiEDx7B8fh+/GKqUwx5+rbRHo68jjzzSYbu/hulJd1rV*)
(*QM+b+/ztEn3WRH32kQ3JsExDq+9spAWD+YSx1X92hsZ299hpvutF6RrUUDU/*)
(*r/PQ7j5jOCErzsFEtD18PmSGPJrQXtK434uGCHd7st+xZEiOoXll4JaElmmP*)
(*j9MZcnulXHkI4SzFylEHlb2sWSbLFPGjaXNzMqsURleahevNHond1ZLAO8IM*)
(*NUYHu6xpvG+OaEzn70U4HLULiq4p45/zO3M4LXj3BZVPXwwnM/77pf7rf2d6*)
(*zrYMsckXYpZW3JCcUFcgzbQ0tjbYcZ9OHhhTzWga/zKxYdiuwDomJgKybo1f*)
(*1INiWfb7kmEZ2wKpa9OQaarKaP5wVF3s1w9RswyZy+9D90Jb4R887LRuy0iT*)
(*BPaGqc19tOxkHCMX20jWlFnNB+M62+eN/EJXWCpGkJ+/3iTLqh92cMSMRDZs*)
(*x6L5MW+eTx30hy67vrbyV1PcK2qOnbF2YSDsVdF1ynBwl1Fs16ElGjfU+x/P*)
(*g9GcZjrj26zegvulalmz7tXNGoE1qy55cMnn25fb3R/28GucjL7SHupZVA1D*)
(*ozlVnGSzO/3J/7xRAy/o8/f5xIn67CNLyTAm7S/Ilm3S+hWMsfY3+89G6f74*)
(*Tza7x27zXYOfzx/iWGeDh8vBKNsaPuVHzZAHE9pLGve70cSkUvc0AseSYfc6*)
(*6VXjeJ8kNKofrDzW2ILmv19lj+lKqmGZHYYyGEjyWkoy1kRmTtlk1OhX0IJu*)
(*zxB1M+/YqWTD0vsfy3Z6PQvsaKxePHn0WpGwqAqXVgXLVdF78Yg6rZYmsWkR*)
(*rBuOAGPBu2KEaVEkLk2DNdkzpf7bf396LlG5KzZEgQsJErHRSL2W6DoiMl1G*)
(*w9pd6J5UaRR41jjoVTsoynysDbZfWFZg5g7jVHHJF4Ph94I69aInJcMyGAqm*)
(*0nRy6vigutlJdf2o4jCw2So5VHheZOE0mwlqkBZVHpI5rHfDrLPAH/fxw6zY*)
(*bZXHLzz0/GIbqVPlBVwrj56eQS9uiz6dzmrmcCnH1aXX6bk8a2s6LQgO+Veb*)
(*e4+751yH/eEHS4XMHhddTvivr8ba+UDYraLLiQ+bIyFgsmDv8cn63sHHqzQO*)
(*PFOgJSVuD9vVW+dx4E+Of5oT5mUR2mwdJAOnKkNbnQYOP4TH5jvs4Rc5Hn3B*)
(*YIHEZInWpeVViR5n0Z02auAVff5ZPmeiPvvIXDJsqbs9tdQa3u0tvsg/j4bn*)
(*vHSb3eOs+U4p+/ncHCUwwyZSbL/1OBgI28PnY2bIgxp7SeN+P4rg2CXqRDKs*)
(*qWA5/mCan3sl1LQBEFXnbiyKW3DrgkiYDe0fY9gEKZzJiiT7dMRVEdkK0c11*)
(*296SZNfHAfSJNnp819HwgMpC1LvHjrI06UjTkGrT7kTeYNKRPuo+YpNzGnpD*)
(*qRf+Hblv2Kw2qQUC57UUDRpFkVexsk0H3RG0CREDJv93Ot2NbbSswIQENGFd*)
(*K7XlReU8JRm2/lDLqsey0WZkoe2b6UJ1tekwdXSbSvYDmjFBXz5hUzHLuc5s*)
(*G2geHkQoupBoasmLViZfoK1cklEsR1k29KQscuhBLdmynby+NtKj41py6Z69*)
(*dcSHdkdneN4ffvCS4d2TrI2jt5OBcFZFVyj8wedOc2mlZF1P0KtLH881vqRH*)
(*1duQouk+0w+tBw57MnruzIfqYQ+/zMHo6xbWoftOHoU5NQyglb9l87mogTf3*)
(*+ef5nIn67CPzXNHBQo9jxha/0H82hsZiJj9tvmtUxtCEik3Fy77NDgfC7vD5*)
(*gBlyv8Ze0rjfjzo2Wf0/JRn+qMgZ41oylEw/jgLf93y/28G/+7n9xmlyf64h*)
(*jn2J/WBu61iOgnE9/Uayn8ru7oQzbU7pUkjyUDHHHGGkj/YriZ0UfT0D9ULb*)
(*M2+yt5Sa7p7WclcVsoyPgSJpSRf9JJgFEqHlHZczcvB0IBl2m8EkTsqmKbPQ*)
(*HLeEXH6ekgw31E19sPQhHPqd6uKyEW83wZgx2iL8JpRKxf2JxqVEd5KgrcxG*)
(*MdeT+q4kssC5x69v1CRtmuEl1Yy78dvWdwLGX+kP7yMZPltFV6DrFymZ1zdM*)
(*XdXXPr5Y9w+ql/XPqTesB86y3uZD9aiH32B/9K2r+scQy6JhO+mtgTmrgbf3*)
(*+TfwKRP16UeWuao62Sor2yEC9qhhud5/+KGxmMlPm+9WNc709ocDYW/4/Hj/*)
(*GXK/xl6zCn8/RoFKD7dVemeDcbkEbNn7fQSbHiihZY0eKCya6Lx3sTlWGU6N*)
(*3+TRsD/hTE9mEw75qxS/rZ7Weeab7C2l3nlesnlKnGyOWNzpRT+hAhLVRh7X*)
(*xtYPeq+VkBw0iKpBN5/S2yRDFhV5Gd1o4Lnq2muCpWTIVw5T43QPn0t0Lf8f*)
(*rJjHr2/+gLeO63/JdvqXuNQf3kln+GQVXWJm0fQYVRAXPr7M8H71Xp9Gpiez*)
(*sh/28FvsjT7qeLi/gz6VDN/e59/Ap0zUpx/ZyFVokyC9omHSQ9mn+s+yJk+b*)
(*706JNhLabaCd4fPj/WfIH7s19ppV+PtBJe3ZFnXGqc7Q2pEMPzgCwGm6OdGo*)
(*P6SZy9l8jv0MyZCG+eW/k6Y3rF+PR8RbSr35nOjeH3NPkDEYlzh32BkFpI3j*)
(*kmVtbPygjEibimQCYScOb9QZFvQQxJlbkLZlGKbPVdczkiE7NOw2vM8luqUZ*)
(*Xt710xRpPrgDPyEZDq/HlspN5ep1O+Er/eETJMODKrpME3sWVyn9YdaFj2/t*)
(*erar982S4WEPv17Og9HHjEmUdF5zZRIm5XZ/W5Ti7X3+DXzKRH36kUUeSjpW*)
(*qACTrkfK5f6zrMnT5rtVoo2EjgbCxvD58f4z5H6NvWYV/n4wk4NdI/BTD5Q9*)
(*O8OvJhmOlqUaL9IwJTOJePjBkiFzydB4u9867oatcd/OcHtEvKXU6+ejeSEX*)
(*3ryJvLCeTLhncwKVBKjP6V3JkNaPzi5Le5FkOFb7zNw6d+WH5DxXXVclQ4vf*)
(*EVPFTjfuriS6PtmfH5XSzq96vItB3W2S9cGW5vj1qQgSk9naTFfof9dZwFyU*)
(*1PTqXHmlP3ysZHhWRVfIPZ35M9aBRdU4ipNd+PjCL+Cget8uGR718IslPR59*)
(*U3lnLi1Z9wubHyMSb2c4q4G39/k38CkT9elH5qft5Fh2NNdpRjvDJ/rPcmic*)
(*Nt/FEm0kdDgQ9obPj/efIfdr7DWr8DeE6WyNaOc0mdrS72iem2QxRzUpbcS3*)
(*n2Xc4jxdVlLe95/2ZPaEfuSNdob9UVnuumHDjDA58xVSXTLRXafjlZ2CGvax*)
(*3toidqU+/Rtbe3rFDJdnModTm403lHr55TJkx8jm1Ffabmugl9PVnLwukUY4*)
(*Z0+oCfpebawq8O/+V8M/FVoblUOMnSS7KLNs2NtSSfVme8VjOBDZIoEb0+Gg*)
(*oXcWeKq61k+oCCTNJENB88c8sLlOJ9fCnSaae9pRK3MXB6t2WDVtWxeDv59M*)
(*zm1PXufWjr7qAzf8038g8hHsK9L0N9x4L/SHafa4P1esx9rZQDiroivEpvBQ*)
(*vPGf4aCb679//nE6FcjeUPY63q/eZmW+tXqyqrdF2Y96+OUatg5G32/+j9Fq*)
(*yxwiebZV2scqEehiuuxO/Y148xp4e5/vRJnAVhXVcO7GQvucifrsI6XB5YEp*)
(*OqjdRcUCQFlxnidZe9R/LgwNFo9or/muse6oJ6Nsd/h8wAy5X2MvadzvSOuT*)
(*uEbzS+4YlUcmBEHf3EwwleM4AbaxzaLXuskHKmObmPlAKXa0N9OX7J4+QXU6*)
(*yaLOQ9InHGqM2LCjUjlcxdi8ANt9iFIfn0n1/5D75MEYJ6ob4CQDVkSnxykg*)
(*xcSN9bfLM4sLp8ZUXV85ZEckWyQ6yLOlbph3mDLEUKVHVB1GmBZ51pPGdpc6*)
(*3aZN9odOH7OuDi0a9YJ61+3XhhkWWxX4P/5tpviXVf4MYMhDn6ex7Ep860CQ*)
(*m74mBIOIu2fV1UZ02R0rvHtCfqImNT0x8XWRPen/zezrHmbQb5DbMiZhbUy2*)
(*HTtto7GVR1nAYZEoZhPjHLYHP399NB2X5L6mvf97WPq7qXIQLIrQIk15p5ZP*)
(*+sMPbr1TnbtzxXKstRcGwmEVXYK0o2INbm1tQVqVqCyOP96woxnFpjE09qq3*)
(*LSOZ/yX3RGUDp2FDiT2ZD9UfJz38Yg3bh6NvWk85RmP1ZXcq2mUNvL3PN8mY*)
(*q5kq6ULRPmOiPvlIyxwulCEe9agle4iypiyq36z3+8/O0Jh3D15M3Wq+KzRF*)
(*QJcNM+SXjYOBcDB83n2GPKixlzTud4R2wtW8UY+dc6ys1SxKNIpDqLcfTeYK*)
(*y+qV/K0b917LOp8H6RbD3eITguzS0LuFMc+9Ed6abXpyX2fpG3/6j+a5Ut2Q*)
(*ya4ExR22JHU6BqIl/T68UWPT7E1edqJwlsZDJePmfqlrR+YfS//L3//vV5U8*)
(*/pEp8NvCVmfpyLpLkhk1uqyUbuTOcqoNETb4Csz66wic8XOS4Wcx/cgwFzWL*)
(*uc1O74zkKuZDqgqKxW989qurtmfV8nDiefzv4YkxeyKFZTvOexyiFc5CRFxO*)
(*dNXKgka2wqk/a0zVjtrrr7fZmG3dz1iYCA7ZuFXBx/1hXZMP1gcuMu8qVwfC*)
(*ThVdZdnY3XjxJsXC3scXnb+Pn7xTvU3mzB52kgofUrh/4sZjwUnpzf9tMVQD*)
(*MoEc9vArHI6+oTYcfkUVyJpOmXenjRoYeFOfb7Lxyd0Ihx8+UTN2PrJcwvoY*)
(*5pU7tZ/spRmb7pR+/344PBdDY7t7HDffGcWiW4omv1juDYSD4fPuM+TvDye0*)
(*lzTuN4RWrL2+Se4EogAXPkD8eyVtnWdpmmV5cc/0/NK3m7qqbm82qiJPuxzl*)
(*71mP71lqnrocypLlVf1MOssKbOuyLMeAG01V3g6+sZ9UOdRIXm6110ura7Si*)
(*6UOA9OTbdfP2RJuq/0KaPfWBtq96pvyv66ZtmzLvtcNdfp7Lzo8394cDnhtr*)
(*b6miLsW+UqpyUJnn1bonXv34y6r3OJWjHn7pAyejr/t7lqU7/ZnvTkdJPN3n*)
(*26ooikR/PJ4ISvyJE/X1j9RVX/1sRDbTf5/1n4ulO2y+t7E1EA6Gz/vPkOcj*)
(*7iNW4Z8NqsqW7l1GT6y8lh5wAIA5L7KcBwDMqAZN5n2dBvhaYIb8spCrA/mb*)
(*Io9p816YfNcL7wD4Hiws5wEAb6b0hovLNRfD6qcHM+RXhhqEa97pBiwf7nYX*)
(*de+XN9IE4JCmTGOPWURKbnzn+ikAwC514NhRjiXoJwcz5E9Bk9nGua1yFjhO*)
(*iBYE4IQm8xRZ0TS9R9MUWQ1ynHwBAEAPZkgAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAwDegSCPf83w/iJJsCMPeJlFy5itVeoZqsrs7h/jzu7h/*)
(*9d/S/4f/80pOysiWJUkxg1d4ajVZ7OuyqNi3AkbVsWfJkih12dDMKP+No/U5*)
(*8t/Ld+w4k00WedrtItymTENTlSQ9eG2gzjqPLE0Rh7o03eg01kafDU0SFafe*)
(*f/JyXtrlvjflO4+Fq1SJpyrW7Ys8n6LhJ7K6Xk9zDR0zX6VyLtFWaRQGgR8E*)
(*UXEnv1UWhcnsRllfkw0PEfkA+F40mSkvbn4Wlf42c/FoIa/i4YpGdZxWAm11*)
(*ffQaxT69vDz3yN2Ph6lfoGV32d8MMl9a/V20gmGZ7E7af+GfIxl6h0j1x5ls*)
(*MvfxTBFu0qTTVcyi+cIby6qoj/8pKEYn2tGbOfX9kPJtOl36KQ7XEq2fvA+v*)
(*6nLfH3Zx7XuMheskww2/qhN9iARWO8ry7tkFGtkdf43KuUKT+7MLtx+ik5wP*)
(*ryoLjaEqBCPin9epe3FuBwDsUifOFwpfX7uDWCDIVjpcydiUiUFmDcnaXSeb*)
(*YckW9HxSMBW6MDyyvTjLQovIGpKX5HmWBk5/1/lf+A/+i7/wWN5CvqYcLhCX*)
(*dP+t035bF0VqK8ItsSodbnDX/D6PLRPM/uiP/qXHQ34XVcBxJvsbUlNy6frL*)
(*JcPUc2K6GjRFkXu6SASwlwlHVODUh+ZuqfAlHHy/KZfZWD95F17W5b4/pa2K*)
(*7zUWrpG5fU/S/Y+NK9tkbOOrJWV/rW9HkaeeqXCi4OdXziVaMjAlw7L0SehV*)
(*s8PTgsSeZMn1XESuBjud2wEAe2ROt9K/UjPzJupoGPCCzw/pJpGPdr71ID3N*)
(*Xym8/gmTFH11mEZll002tSk89LAsgl5EFA8UR6+GXj90VayqrWGmtGIqhlRZ*)
(*HISnp+pv5TiTN4twjTbtPmpEUzckt4G/UACrY3O+v6jiIEjODq4KX1tkY/0E*)
(*/LI0qTPsP4MPT7m2d/bLvtIPpA/Pz/Ok/Rynj9c6RKZMCnasMG/qqv3RhoPW*)
(*YHMu+vi5HYDvQ+H3oodkf5VdZROTecGZXc5ed4u6Hm1Lr2QGEDR/9tBTHhqb*)
(*Hume9KF6474+V+lRXWkOopebf9C903clQzL/W+8uDM44zuQ73LreBoMiji9m*)
(*nVhEAHvVnqUhH7zZ1RuWjXr/CfhVoQcTXvHxt9YzyXDVD5s8sP3sw/PzPHWe*)
(*Zvwgb2LpgmRIOJyLPnpuB+B9aNPA0VRFUTXb8x3THA/X8tgzTb8bKGXsG7qm*)
(*aprlxYsFri1Tx9RVRVXV7q/LUZVHnqF1f1J1wwpT+t0q9Zi5lepHURjGZbcN*)
(*q3Lf7h056iaz+7SM/ynoCAfi4YD3R5lGiye9/j4JDLUTvrpPFJ7dpabpppuR*)
(*Q7gi6fLWf8vyTybROmZZ0rjThDY09WDbaqQ0BnWgsZAb23q0w64T+0H1kNMX*)
(*64pmnBzXdlLjXr6GCtF1O+Z+sNdS2xRdq/W/VnTLMTaOYvuv6X3j9BXEbiBt*)
(*s65FXGrXptpD+0SkSto89nVVj0pW9UMOVaN31ug/pXWYQbbI02Yq1zM5QWdj*)
(*O+0yQppVN5yEZqZJo5DR9ZGUPB07TBCMuR7zVXo6bXPV8odS9jmvOUEu8Wmh*)
(*wmyR7ZNCsfpJu9rT+K7e5WzMR10ErjUMDtWw3Kya5a9eyYHrJwcfaYqUq46o*)
(*aru2C/knQy7aLKb/JrladblmaHG114FXKalz0wmXDVxlrmX0vVLVLTcseset*)
(*tmOzTg5qL0/CYJ7njLVpENEG7XNomV63fWuLbrrQ+k5gxZwCdj2NhKxj7zfZ*)
(*7rDqWtAxtK5zaobt+7bpjD1zORYIRRJYZL7TDDecHUteGCxXRzdTay8PXPZz*)
(*e1z8kzl8zoZk2JaRM5MJtytnr5+sZ/Xteb6bKFTNz+s8tLsqNpywvp35Q8rh*)
(*IFiyr2wJj3epq7m98kxNUc0LNowAfBWIYlw2bMeii5gZlbGjTcYU5mT/3qM4*)
(*YwcvwuGkTFB0jRnviwbbKpX2cJYqqoahyezVhBzRCjMvjX/1r/3r438Lo8HH*)
(*n/9P/6ZCf0b0bG3smhL3pAjM8TXVsmT+k6IRBtYs2/KxUyc5GqYlPrUSIac5*)
(*xxvMmLhuCMamaHn0hTYfvT74+X+rpfbmmk6mHepD7CrGEKeSxVMSw99lbTKx*)
(*MYK8+4OvrezMFfcfc1XdC8N8DrtvKHxzisG4Iuymci2Tc8hs/BDludG44KZ1*)
(*l5DBPTXYOlVEjsT6w8J8KLGX3ZCkSwWwrkurs0KFYyueFIpvRm/tjOQOx1d1*)
(*4pA/aaY1eqXY8dRTrkiGBx/JA2Mql2oXdeFqfIPZ/SBti8EerP+on/3jRZeb*)
(*fUGbeVXxh5hVTLY/khME1qwbPIxNyWa39prQ4uYZwSj6Dk9/IRnBH8pIGwe/*)
(*Zi46qZ0s+uQ0jfRuAodNtjusynDwwVJs16GVR2tmPhZYTTjUdESzTDZ5EmeE*)
(*a4Pl8uhuyEy1HCY7uT3tsYdz+JrxNHnSgfcHJTo9KNmpnKN+onvu8TzPd8WH*)
(*ODbssATcy/wBZP6XLh6SHEuGi7md2pP8DC45AFCICl1wyL+6tayfkeIqiwLP*)
(*HoXDh2I4vmeN0xtxTPhR9JssUfep1oaqyB6S1fuVBMOBRy8KDh926cCl9r3s*)
(*iG1Y5ro9Z8hNF7Jh6f24k+101PDH43KY0UHXPanzOPAng2DNCfOyCLlsq3ZQ*)
(*VGVoq/w43a+KhPMAPZleqJRy4JzClIrinu0NO79eah0XFTImsdNSm9+mTqYy*)
(*2/+SVYObygYHapHZQ45SsUzrmeXNHO0M0zjwTIE+rGgO1clsO0iLInEXPonH*)
(*qZxmckEyyv6y4YddO48tT5w7GtrHZqL40PF2hHPu0HxqRiqA9d/RQq5QV6tu*)
(*L9t8V6lJ9YpMmdx4VNCZ1MvnkuHZR1q6PAke2+eMW5Wx07RpP2b7Y69Vl6vS*)
(*bgqwpgbuhlKZuzSJcShlZMiwCqTnaB225ydLLe157U2ytDzobAfrAot08joL*)
(*/FHLO4hAvs/3gXx/GjlKdH9YxX1hhIBJV31vFUnNzMcCqduhlUUmMzeZRxtD*)
(*Cy4Nluujm06Jy7/u5fakzg/n8C2YZChIhmmZpmnoCj86NivnvJ8czvO9CpF9*)
(*s8OwyYhSkt/czfwWbZ3F/tiPzK0t3poTy5b53N4Oldz30QCOKeAngZ6iSi7V*)
(*dLeO+NCIrNImpHtrXkp+O83bw5xDrXDtKEuTjjQNqWZBNEv6S20ysKMHlDp5*)
(*srbmqiKyMVTIro2eRtEhxs0YTTJ/0pCZSh/9QFi2J6899sTaW7xHqniKWyId*)
(*WJpR+7QjyZDNBruJsvPrvell6XFw0FILWPQVJ5s2wOGQYZpWGQy5l6MsG1ou*)
(*ixwqFFMxdZIM+e/n2vwh9RYW9bGVfU24msppJleQ2VjUvPGFkCkKaSWvZ+DC*)
(*f8zsPBfQZY4vJuuZU6GIQHW16nayzXf1aFgXZ1sGttwLGl3mTiXDCx+pyV5u*)
(*ipBTsj5JF+hBfpCcSfmz6HLroURrmI4+phuRRxOTjIgd8o5R5YXayz12/C71*)
(*uVeclP8AsUTtWoeZA7c+U2eSXczGNHKc6P6wKvzBlUBz6R+yTvDQWSPOxwKN*)
(*0yKF3FiP6U5a8AaR7GSwXB/dBSnOUjLcze1h8Q/m8J3Zj0mGD0EkkA4xG7PL*)
(*ieK8n5zP8xXRH7Nwpv3ycD/zGzSpuzgjMcJz+e1EMlzN7U1VFAXOksHPAx2A*)
(*QzdWzbiouz1UTYYrHa0yr2Cn83A/9CqmQxRG+ji+kiiqzu94leCY1GSCt7/w*)
(*SfZMkNqYMRZPmNpn+gXN2PRkW87ZgWmuhnG952pXWWzDv/dFFhpO3j+eqMjG*)
(*efdIgmyBxyo6aKk5TOsl8yah/FQ2nm5wLdc3nSiINpEZtmtsKUfV8bKVr6dy*)
(*msk19K+8QoB6lI9ZaqkzOFMSDkLdQRPsS4ZPFeog21xXp4kuihnMg9KcSYaX*)
(*PkIlvYdCrPTKwWeqh1hADfKMPh2Tr7rcxlCardfMknbSxjcp/cLmuLhWe7Uz*)
(*dnTVXTTdRh9g2wFy9rqeRk4S3R9WVAol1ez1Ja6r6at8z2GdWZrtAstRhKt/*)
(*nA2WG6ObFWcxm+3l9rD4vz2Yw/c2tKNv8pi7xJYEPVr/ZpooTvvJ9Xk+Wc7z*)
(*dzK/T1P6JqtAZdnr1px5w53M7QB8fXjLkL4zs13nxmhlQbSGh2SoSkuPlAFq*)
(*grsQ8ziuGthfnjG4eXL15EQyLD0n4BNl81g/R6Tbc8R4pLJ3TMlONo8mme3F*)
(*ncvGskJ2W2pOTuUBKeVO82bizfDlo1nromS4yuH1VE4zuWbrrzRLveHBQJvT*)
(*0ItG7yeRKccxpY90hs8U6iDbnCKOhq1efISdlVNl18kAufaRUXeh97VRTqac*)
(*3Rrd/Cj6zYvC1/8q0b2hxEYf01KOWll2dL498K/WXhXSnK4ufNnoA23GV8Ve*)
(*vR0kujusZvaBD06ht6wZblbkvssGkTJ0zuN+dZSNrTp8zEX6g9weFv9oDt9h*)
(*8kCZslcEppetf8N3m5N+8vw8fyvzJ4wbq1MNwplkeDK3A/BT0BSxpXLTijqc*)
(*Rm1JhnSv1+98aefX/IXuvU7T/HchPdNJ56ZGZRIS66ObkiGnWXq5ZFgFwsNY*)
(*LECxtYxt1ZaJqcr9jlRSo/L31nEQbKYB2D/H/DHuea9Lhj/2WmoOEw9mDbcW*)
(*b5h5Hv/xNK/4Q/wXSIZ7qZxmcs2BZMhpjJlMLtnJYJ3uZgcrx5OS4VHV7WSb*)
(*+2CubRmgLg6dzwbIpY9Mh62qV/SvC0GeEIlcc8Ou+y0vcbgrGXZ7QJdF7g6S*)
(*xCeyjeDthDi+WHupMxn8Lk6Tt/pAwzJZH9XbYaL7w6qJOfvq8Wh4UTPjNmfm*)
(*tj0fRKeS4WE2uDqMqWS4ZaaykdvD4v/+YA7fsbPejVqz/g0/rE76yRvm+TuZ*)
(*P4Geer9AMjyZ2wH46rSZrrDFKAuY+bbaS3TjaOWmAKoM7KeFmpmn82Feuomr*)
(*kwmN37LpS3X5vWTWfdCmvpn0bGUa59tBOchmU5jW9zZ5rWQ4nLao+fIhPR6i*)
(*zmXDjGH01mu50kc4LOmCuyMZVvQER1hOWjzNiZ3hskIOWmo78zPfxoQLFTj+*)
(*QJ3v9KfgjYeS4Xigszp8XBy8HqVymsk1W/oiaqzIn+TSzQvhyEXox+YSdiIZ*)
(*nlbdTrbX4tZisaY/Y0rmi6fJxx+Z3mKZ7p5EnBe3N19Cn5AMf5T+8ECW+/NJ*)
(*STWcdEdCvlh7RGOvuhG982USxqYCStZGH9iVDI8T3R9WuaezzlkH9DKjTlLN*)
(*+JohY2H0fdB4FwO2PSSWtMeD5froHo29zblkuJfbw+L/9mAOP7EzvCAZ8o5d*)
(*J/3kqXn+fubPYIFrTg+jTz1Qjud2AL46dSzyMTnpOQ712pPJzDzNdjUxZiHb*)
(*tHSM8yKoYR9JrS1iV3oMEeeo4+QwlsNe7GqrtLfjYH6R4wTe9Mcobpg3TBu5*)
(*sDNMSBrMp6Bi3omjNq9ZzUKrJ2yKtrYswcgYN+ZHMxE5eCNmhENZ1L7IbdCv*)
(*qlJYttShRjQ3T5MDZo15dIEmy9We9WMVmbMKOWipBczy6iFoo4kdMcATjeFo*)
(*lbsgWLXDqmnbuhgqlpnkbdcYNZ6RWYegzgJck9FQ1cQM7DiV00yuWM/G1I5u*)
(*OZOPUtN8pd6ALTd9DnLXDZt1td8q1BbUAIyTUZkNKu+rSL1Fxic0Zh2XjcWT*)
(*Kx8hlaQzr04ioowH7mvdyKrs1JVgNZRG3Q75gRrvS4MzLnY8ItmysU8i2BBI*)
(*H+DDyzOpjErIG9PIcaL7wyo2hYfijZ8hIXSYieN8LLATbT6rVCRjT04Gy/XR*)
(*zdIyotnsspvbw+IfzeE7TThGrdkXn5YTxXk/eWaeP818E7uGrOjRzn1DbV3m*)
(*+exvxKWFm5B3v5DYR1YTq7m98i1DM+xlVFQAvixE/OtG1hD7tAiH2UxxudPk*)
(*fjEeunQbO3NxqM2mADETdDabhi3HaBsz2kVLQ3Q6r/gD8zOVw9kwbFhAOkEz*)
(*DHkeHk624raMmDEPFRjGJyoNmNNfmy7On8y+z0RYw4t7D5m2jlgsR3sw1CFL*)
(*sKCokvAQFZOG6y7Izl1cx8GuWJS5PkTP/kkm2/vvSRQNc7pU6Oxy0FIrIi46*)
(*oOV61iz6m2An9egByjOqYsYidDU2fr9hygpW1Q2LfKiy2bpyWNiT2Wq4k8pp*)
(*JheFimmoC2FoqSYPqV43WEVHYYqypTHDCqZ2EKU+flp/eDcViq1irFCyRcLD*)
(*HBdqBXtdUJNpWRyjdohOH36wpvdrT7q+MRsKy8b6yelHKOlyFaNHXdryyt1l*)
(*l2vZwGGxp/qOQZI0if8m9cmdIwiirK0CnlOOaq/Ohh4xjamMDU5BdUmhx8hF*)
(*ZtBrwNoyJi5HJhWTms1p5CjR/WFF0lKsweG4LUjKVAG4HAs/yog5eqhO1x/r*)
(*PKSu99RS+Wyw3Bjd1M1qcf/aQW6Pin84h2+kzSq8Syoqd2auVeVc6Ccn83xT*)
(*BLRdzZALa36YeZaosB03bFQ5Spbf+227OglBEHLXEux9ofJIDCJB35zhF3P7*)
(*tNjdCqcDwCeyHrOykTLzcvmxRFCs2QFUnc6GcTezcfd9cOGy+7+RyZzSZqNc*)
(*oPv/wJhPBXzcgDp1pj92MmpB3FFFzfL+NP5vZ691CxgfE7V/4sa+zj9Yuhs3*)
(*idRHybZ1eV4NguxENA+DQKInRVXTaxiIgzVVN82uSBm1HPNMbVY82XX24c62*)
(*WsWZVb0UdLV60FIbNIHJ5UWUyfcESXXClBQk9We1rtoRLdeq1TUvnx3R9mq9*)
(*vzv/meBE4SweuqDlR6lczSRPW2W2Nk9VNravFRhuQxZ3Xcsn8rF7SEbWTMrG*)
(*7UI9VLLOHxaKy8U60rWo0+EzRZmmyLrLelKz2FTZabl6Up99hKMMHvO404Xf*)
(*R7ubm+4vu5z/v//tWV2obuTOKkPrbWjHBX3NvhJ1p+NZ3EZhOKNNZ4UWeq3g*)
(*FNNyQrRCIuIWB9PIbpPtD6vYXP7FGOJ3rcYCldCKyJ69IMguDV1enw+W398Y*)
(*3VRNOnd/28vtSfF/nMzhfA9ZzwyiHix+ulM55/3kYJ7/B3/nr89TNfnlYTfz*)
(*THG3I4+1obHIk+RE873S1hc4/0RWgNWucDG3txnV0p8dYQDwdeiDI7RtU+Z5*)
(*lmU5H3NptDOsur9mWZrl5fZUVRV5mnZ/3phQ2rrs38zy9UI/3CRXbUZmWNKU*)
(*JPnhH3W+/bXnaIuMjtamHkrZFaSYKaGGyCeC2+sKm8TTBaZ7oXOg7FwpwQri*)
(*KCqcXdo3y+puS+3QVMVQ931x2qqrttUrTfd0KPHF08DnOEzlPJPrr/UV0LXS*)
(*rlhchr28d/FW2bbpu+GVXy6z8eaq63pc/4muzG/o0Bc+0nXyuU9IJ2TnR5YO*)
(*F2kLvz+VtKKmbaqyLHq6Wom9/jaTw8Dyz9beaGfY9HNCtjOx3Ep0d1h1HaP/*)
(*Q1UO3S2vrozztu6TGL5zs0VvjW4qpNlc6ITz3B7W+cEc/nau9pNn5/m9zHdz*)
(*S5rteEPRH3T13df4XnudfmGLjbm97ia5fCvyOwA/HVu+yb8gbRGMe2VZ97gp*)
(*mzp+XgqTOIfYjC38LsFboXf1DrfPSDvBlsHLoCtguKrotr/AQnjDFba7nPmE*)
(*/irQazWOovF/HT6hn3wimNvBN2f0DsMS2211q7rZ2PIV5H6Mtanb0cfyflYf*)
(*b7sAL4GeCwuSPFy5at0X18E9RissWfOitOwGSNNUZRY4vWAurM4ZX8LMa+PX*)
(*hlwZvOeu9YX4jH7yWWBuB9+bMk99ZgMm6W7+vbZ1L6Vye5tswTuKmzeRB71t*)
(*uah7qNHXwttZrc2fwDvQhuba6q9HsYLX7yabMo09ZnkoufGl+22/N9RTjLsv*)
(*8kvysf3k88DcDr47tacriqrpA5qqqOa3GsIvJw9sy8/Of/fjR7dVdkIsaq+n*)
(*rRKz76maE+Ac5+Po5DXP7iqeoJm2l+64rL41ocxTZEUjc5KmKbIa3LX/+pY0*)
(*mW1Y13aln8mH9ZNPBHM7AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*eJbG16WHsOTxeFhx/dl5Ay+ncVXxsWrvx0NBawMAAADgx4/a6iSFh6hqM1RF*)
(*9TLICt+PNnIMlW9sXZe79n9IkAwBAAAA0EmGttQJhnbz2fkAn0Wb2l0PgGQI*)
(*AAAAACYZWtVn5wN8FnViQTIEAAAAwACVDCEX/LJAMgQAAAAAA5Lhrw4kQwAA*)
(*AAAwvoZk2Db1IU37ufn7zkAyBAAAAADjS0iGod7HyTlCNGEJ+U5AMgQAAAAA*)
(*4ytIhsUgGAqa5UZpGljKIAtKXpxlaeJZ2vC34DMz+K2BZAgAAAAAxheQDAuv*)
(*E/28nAbO8dVBf6i47AC5Nh4PPYLK8L2AZAgAAAAAxudLhpkjPbSI/qNNicZQ*)
(*9XL6pEnETm5BvMV3A5IhAAAAABifLxlWeVqw5AcppT899gv257bKsmLnVfAC*)
(*IBkCAAAAgPH5kiFPZEqDYGiUn52TXwdIhgAAAABgfCnJsDQE4ogcnf8WvAhI*)
(*hgAAAABgfCXJsPBJ8Bor+RLZ+UWAZAgAAOBbkrimE906hGw8XXWSX9zp9QtJ*)
(*hrmnDoKhkrybv8n9TvIzUyWm6Z6WFpIhAACA70dkyZ1IYQT3XBVSp3/LDH8Z*)
(*UWGDryMZNkNr8PFqXsxzneTnpS0DsQ8MaR73b0iGAAAAvhlFoHcLoObn5z9d*)
(*0nh99DzBy3/Z29e+jGTYxPIiXs1LeUMn+Ylpc2+IE+4f9G9IhgAAAL4VdSwN*)
(*iqYnTyCbRB58Hn5VveFXkQyryCTX4Pnv0RJv7CQ/M4k9aEr3z9AhGQIAAPhO*)
(*BMPNau4blH7EvE17H1XVl+erSIa+Jrzf/chv7yQ/MW02mG9qe/0bkiEAALyI*)
(*tkjjMAyjJHsPRURTH/PKND8yrQPKLAk6wjBJyU1pbRqf1S3xZl2JE/dKRM8x*)
(*1eznFRyaMgmHyouSvOpL15ZpWl5puEuSYZUnUfqOWtUycYhXci/AvLwVdjrJ*)
(*y2irNI7CYS64VOU9ix7avKrQmy2VDAaWqpdtvgLJEIDvRekZqjkaVHcTVNQt*)
(*D34QRMW1CaqbRoKBKC34qcnXZMNLXp7d70Od6tJjQtSeCrPRVNVOO5WB8DjB*)
(*uHmT7G5i75DWbdrcUha5kFS1F1mOr0WLh8DIkhnPnt4uUT0cuD30n9MVJQ+s*)
(*Zd0pQ90tqmWb/++v/NnH48/8pd/u/LnOI1Pt/RgE431iDDaJsmodQfVeuBvZ*)
(*7iQvooxdaZ55w98WwDhaqiDlSvz2M/SDlmoSe0jE+N3/4/8rj8ffSv4wezE2*)
(*u84SQTIE4BtQxcMZgUqkwCb35xOUeBKOoy2cYRrhlhN9fKNO3f6JYv+UK+W7*)
(*U5pDzWlu2v2jCAf7KEG/cxjZpMEgjOjbqy2xlhckze1k9sQnS6dkeFmeJZGn*)
(*ScNSUlxVMzRlautdakK4Nfm/Nq2naNwhVUE2iZqrLiKd9E3JPlyvChIYeSG4*)
(*PlGixBpGj+r9dFrDJnOIaGH66aArrGNXIwP6WlTA6j/7c4/HP6P8butvKZGY*)
(*SQW+j2T1/mx3ktdQhUTCEyRZ4mZT8zgwDgvbyM29zhsl4ZOWImaWD+G/+5P/*)
(*uvt/fzOeV0UVa5L2fpGCAAAfRJOqRBohKxm9hl4yLEtXxhnq6HQs1MnkJMqK*)
(*PE1TgjHdVprTI5hfJcTDZXJ/WHmnw6nhPO7xkJ30wttN0smErMbNYFuc9NXe*)
(*i5JO1YVHfu6w5qwjo1vorqxzTZkMMuGAbG6e070qredp6LLl812t7k94T7Re*)
(*VDcoBvN1+IkSMfeHn+9Amci0gubzD+P+9FC6dj54dJo86JnbUBd/Yslwp5O8*)
(*hMzp5l3JY6e3qafTsXZ0Ot/284egRXmeZ5Siemu3O2upimxm/8O/oW9IhgCA*)
(*70DdT0jcSppa3bDXR5OsyCTCgLR7QNCm/cph+HSCaDKDKRxNbtIguhdRD9+r*)
(*HD8l9AIvfvqtQmMQbfRDKZqXCQXdCXZNktpU4vR7qUOUXpMBedfcwtky3cuE*)
(*GpUJBVkP9ozEXpHWG2kyl+TTnYlljSU89EM9DwuMPO/nT5WozZkAmf5cqpPG*)
(*Jafw8xiATWJelufP7QyJldq5ZNhmuijaX+z6ku1O8hrqrpa1cFbNgSaeSIZE*)
(*YTjuXF7Kfkux8+t/89+HZAjAt4QelnFagjpPM36sUyXM7mRYJ50ko89mBxIT*)
(*dS4Zjsemv6hP3yZVuK6owYSbyDab8/0gEzJtguGEJxqCtkrTUcakCklBC6bk*)
(*8qzYX+ZmMqFihNmxUcGb0tqh8k1d1az04ou0u3I68CFlS5LDw7zH5AhYNGZS*)
(*73MlIrFr+mZ9sQBRl0WWZWX/1bYsivrVI4kY0XXoXKS+unu6Y6iwzuDLJMM6*)
(*FpcTyOez3Ul66tizdU3TTY/kuExD2zS6J6Zz3O9G2jJfGnSX3rAT2fV2aano*)
(*OCDrTvbS7nbQUuRPj3/xjyAZAvAdKc/NZsphWyrZu79oymLpjkDX0MXETlUu*)
(*P6H91TsxWGsvK6pJ7fVD8pfEtySByYRudPvUqI7Iwn/FOaIpEkujcoKoGNGx*)
(*TPi2tI4+w6pItC4qG+vJSEq2rqdNArU9pH2p5nqJpjDLp+4Dl6nTlVvNQ311*)
(*pOU6scePW8/c+/Y6ybD5ipLhTiepncku72GFiavNjK61Z+9JSW1lsROZMVTR*)
(*nDOD8DucS4aPfw2SIQDfjyYlBucHhyPkrFm6Z1FMLRUFb26ZfyG5XwumHpxX*)
(*yKRxmnm8WmwZEM3wucOjkpxTd8mdzeWj3rL7cXjRNf3ZtI5pC4/kQ7++vNac*)
(*g6pkXvN3aX2VWJDtSjU3SsQkQ25VbWPXUFXtAFU1dw+fy3D4oOAkvbTGzHrf*)
(*xZcncabKu3/12/eWDLc7Se7KD8Eqq5hz29CDpMgj+7HsBreoyP565+ygz09T*)
(*V0WeBp412YO/rldckAz/WUiGAHw/6ADf1JO0dRb72mgxuOPdsEkdD3LF+o4A*)
(*tmK+e9ySnwRaUY9HMDu+35QMfxSxy+Z/UbP8+8eyzDroxEWX5KFwDSohiLLm*)
(*x3clhDtpnealLPLiZoepokm+ka/koSbnhPtSzZ0S1cFKJKh7q1DhiG7A7Bw+*)
(*50QStFh/oLp3YX2meUhbJlGUXug3sTVVnr2pg9r91AvtDJPuS9YnGWpWWV++*)
(*VSm2O0kRB10lVSF1GFGdmEpm7YZRwc6XNyDa8suG2U04ttqLLmeBZAjAL0kb*)
(*kHAeW5Jhk7qLowojvCgeVMP8ueW+R8Md/LSeia+GqeZkXiRgkUM2FSZtHrlj*)
(*fKB78iG9vKATlK54PQ9vVJlrqjQx6Y58eD+t11MGY+Ql6fwk+kwyvFWiyl9J*)
(*hs8Tr/yFybos3gwJyDSNyhVpKxy9yB7yehu3/6nnJcMm81SFU6qq5Oxc1vVR*)
(*p6qH+Sy93/zmN//N6/iTP/kT+l0WwXIVH+Cgk9BYSbwgV8WrE4HdL68g8SJu*)
(*urfTVpvHvGrLSFcOkWXd3cgPJEMAfkkqekB5EM+/KX2THZJc24qmTj+lqe6m*)
(*hRUNdwDJkMCM6GYHQONJ7sFRWh57vHyYX5AP2VH+weHUXi5zj5MPvfhce3yc*)
(*VltX1btciVL6TsDXBGc1d77CMueCnYgrt2pv4zT5WWrm/8V5+RtUhXhPHUvd*)
(*ah/ypmVIlXj+TJVV2dO4X47l/U89Lxm2QwxVpkAV6Xn5XKkqzyX8OI7/2uv4*)
(*4z/+Y5YTasAgrXYBu52E2aByUR+ZkpmbNg++PIdurm+fC9PjBpF3eulGgfAQ*)
(*xH26mlXsjZsIIBkC8EtC/UROj6WoalG0TqcAsk0W9WBnRqMpQjKksCi1Mw+U*)
(*0fjwrLp7+ZCpdlTTyw9dVdlkvnvh6QmdfGgx+VBUO/nwILHjtIrIIfF2BJEE*)
(*9BXt6BVxLqugS3HRkyPqbHtu2npkWXG39phkyDVr45vakZmhqurWhvlo7g3h*)
(*LmV7/FMZkFNL5W4w4bZMHMvyou0ShJqwjOpTUWlnHQdy/1OvtjP8nKg1bRI4*)
(*lu2tN1x7naQgUUn57sFsQub2sbtf5n/jk3uZnzlJbxzpNODVVeCbDMAvCTsc*)
(*OfDHHKAKkzPJkIazVg9Ui2QvDMlwhDYBf9xJV5kLcjj9/SgfHoUWodraXT/H*)
(*q/md5MPNO1AupjVEVFYGVdRTLk6bWesVsFK28fCxOK/fyZK8/8ubtbchGRKP*)
(*6UMzw62klwfHdURVxYp7KSdXqUzhofoLgYKeKVw4ix+5LBlaZ9dlfkUPlL1O*)
(*0hDfZP58n0YlvdDxFkRDEjPzzk4Qv3jNdDucQctvvQOFcNBSTDL8tyEZAvDt*)
(*GI3qTyTDMXDN0c/KSB6UG/w0UWXpzLG1gZ3hEhJPktvm0zhCd4O9lEmUHkSx*)
(*YcrJ1/j+tGUU7R/Pnqc1lFH1yReGqxYOdHqVbxma4Zye4pLVypjXW6hvxQpu*)
(*67IsF+fYLFjQVk5u1h77lHgxkt3Bl2joaTUg3zVY3BojSH1Nmt1Yt1Woy+nE*)
(*RACd1d0UbPO6cHNBMiQiMmv9gyx9Qclwu5OwirInLV/rES9m5V6ErmjwIlGc*)
(*uK6rciBPB+NBxev/XGe2rqqaGQ32lnUeu64XT/rHhhzueC8KGLvfUjRKz7/8*)
(*V/8TSIYAfD9yd9D/iCa/InQrTD6PuUoMm/mjsdg1ZEWPxl8RsfChxGVFZrSi*)
(*yEO33zU7/DS143X7a0Nt12UrakcHQ9lZm7iHjmVau9i25YY7R51t6apUpNC8*)
(*a8eheWiaR6lZlptvCiFX0ir8UcoqE0/cLi9ljGcobZlC8VkeY8oZXly37Y+2*)
(*ihx65y9/lUYe9N2S2LEZvMc9DbW0uiD4fu0VyxsPnyehp+GiZpC7ymTOL0wb*)
(*peWuuYRuDdf6EsiqKsv6raPIMYTmQzbj4XK1Ko9oTL79ptniVDKsaGUK2kkO*)
(*v2Sk681Owi5G4c5wxyAMN/Z3dTB5/SwhNqX0Pm6WVsz2CYrhBAG5wnsWovxt*)
(*HLQUdZb/L52/AckQgG8IvQeW9yMe4+ZJlh9lWeLq/YwjmSHnI0GPtITh9KTO*)
(*g90ZbX4kym4N27aB/4UpbC6Isay75camv+Gj6W6y9hT40W/8ldUPhVM3itHh*)
(*Yp8Nn46LabH9iEg7mh4c5KZlt92dxDNs+iAnqmXp8tylXpCdeOrcQ3REcnJN*)
(*BHK+K7bkxgmF8xt9rvbohbOnB6YXaDJ37BlKPwZzepYvatN543A9pTJIrcQu*)
(*UfPunWGmnTwnaLalL8IRyJpzM9r1kWTIh9EmHEnaTV+oLycZbnUSXyPNPZ2D*)
(*MFvQGxPd6JyyAfM1pgOnp1dalqE5+5WkBS+6BOWkpegVV/Lf+4d/6wHJEIBv*)
(*CHUJ0SfRsA2XW1fJWZiaM9UfWfs8VXjsoM5nfno88UZTt29KVRRVz7cXmgcR*)
(*V7TKtsljd3DBNI7VHHVZVtXpRXBtkVHRsanLPMvSNM2KpYhNe6AkS/3/dOub*)
(*yIt5VTTYhr01HByxBxBedaj3oynzPC9ZBTRV0f1r9ulBvUbUU0T7t1R7ntF2*)
(*na9miRV5X3dpVj5z9975afLPzoVOQk8Bzk/Mb9OUVTPYnzC73KafNur6aTOC*)
(*Z6Ah31Xv9wkkQwC+J/QgaW603FT9YtQtr3mxbbvWTUhptn2cuE9p9FvNd7m4*)
(*Afw0DGFYxnhu5IDM/igX1MQSH8KB3EK6qPSm646JHl5xP66XE7+DwfNrONkU*)
(*40/bXnyaZNjUx7wyONJJJ2FRW98nnn/ZjxjpNT4mz0Gs07st1R8gGQLwbaF+*)
(*KO99cEN2msppiFfwrSEqF5fp04a+J2wERX8fhnh0gssOwjNHd+ZGVORWmrd4*)
(*SA1eAB+9/cmdXv+pKLIka8HdG65fSfkf/7nH48/8pd99dLLB7rkF44Vy2nEn*)
(*qSLqDv9ym5kq8Yag5/qlO1TeCXKUrPXq0E3JsOnNP257ZAMAvh7FYOcuBVv2*)
(*bS+BBLQRtJcfr4CfjMFafwj71laBRW22PmwZYffLSJYfBq7+eKirg2yyUXry*)
(*LJjYZ94J8/IKBusOyfDiJE6SNMuOA1u+K7/7S//U4/FP/jsfLBkSB39B0twg*)
(*ShOf2IZ2FZLlWRIR14zXyupHnSQ2t9zhX0GdBbYbfaq5CbF2pvrSTcmwTsxe*)
(*aw3JEIDvAPFEE7y7F2RcIA9I+GsPs8UvTZub7OLnh0DcHiXdDj5Yw5V6OlMj*)
(*ie6m8qXNBtdi7a5mpiUe+tLVQJSvo9AWCjLBeEms4/v87t/7pz9BMvTVXotF*)
(*Zy7qVfdwmGa47tXUxosbZb+TVImryrKxdd/cT05LYi1aTPu6IxlakAwB+E7k*)
(*gW35m7favYkscJy9gCoAfDxNH1rpSLFWJ7253r1Ln4frJyTzVX4n16l7RaXW*)
(*pdsSk7qyt3Pbj0P+rnyGZNim0kMYy5s6RGU4XUeSWqLwHgFUn+kkPzF13NuB*)
(*mFygJ0iGAAAAfiHaOi9uLm/NBzqIcgxx7WQ/yau6aTq50NNfEkrxKehp8m8/*)
(*Ms22StNRRUqDLfABEOo8u9uSl5O+30l+Wtq6LOaRE/4Q/01IhgAAAMBXo858*)
(*lQtEKKr23agBr+P3//k//3j8M8pHe6CM1PSu57tXCIEnaP/ff6j9RdlN/8A/*)
(*hGQIAAAAfAWauq6qqm4+18frk+MZ0lB7D+ldAsaAC0AyBAAAAADjcyXD8SL4*)
(*wxvewXsCyRAAAAAAjE+VDNuM3B4n/zJeIV8QSIYAAAAAYHymZDhe9n16sTV4*)
(*PyAZAgAAAIDxmZJhYsmLeDU0T1U1vygP4fbfEUiGAAAAAGB8omRYkbtH+Hg1*)
(*A03kGNR1WxBlWaKhwN0YAuJ7AMkQAAAAAIzPkwwLX9i/Hzm1+/sDY3rIXPuG*)
(*NNz9i/D7rweSIQAAAAAYnyQZtuVwuedwluxtyHuJ1d9PE43ZqoLu16IZfWQe*)
(*fxEgGQIAAACA8QmSYWIrjyXCwgmFSIYJOz/OhruzJSv5wGz+KkAyBAAAAADj*)
(*kyNd70GcUyRF1TRVFol2USvO3wO3gWQIAAAAAMaXlQz7bLlxlmdpFLjKIBsq*)
(*Fk6TXw8kQwAAAAAwvrJkOHqgdNmMhwA3coLAh68GkiEAAAAAGF9bMpyyVQ6B*)
(*bDifFPAiIBkCAAAAgEElw43AMZ8KOU0Oy8EFpa0jRxtUhg7kl5cDyRAAAAAA*)
(*DCoZfqVD2iawWESb3mtZGP5bVA23QKjrd6BJIRkCAAAAgFBZ5I4RaYYoyn7+*)
(*laRF8BpqV5XEZVvjmB4AAAAAhDaydWWFLMlOClnh+1F7uiLLq+aW9RT7AAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD4erRFqAhyVF9/*)
(*o3FVyQzy98sSAAAAAAD4eNrCFx+Ph2xXd97KPLV7SfMhHAIAAAAAfBfarJfw*)
(*RLO8/2qg9xKlkzWvzxUAAAAAAPhwQqOX7ry8feZlIlUKevHqXAEAAAAAgA+m*)
(*LbxestP8p79Q+Hr3BcXNXpgrAAAAAHwL2qpkVD3jP6bH9UecPLbNPCPlmupV*)
(*+fjItA5ykSeh53Z4YZQM6bVJGJ85lLS+KnRynRnPDAzvlahJ5EcvG6ZPKR2/*)
(*Am2dh35feZ4fJnlfFW0RR/kNb5yX0ZRx4HsdfpiV13pNWy+a5qdtBwAAeE/a*)
(*0tVlfbSNb6s4pPNtXl+aOKssHl7wwnh2zOZpkubGmHu3KYPHGZKVvCq1uiz2*)
(*GjPQhNOMJHfEtY9M6zZNZkiLFAVZFh8P8cTXuI7EIXsLCfJmiRpnEA214Kc8*)
(*Us58Y1l3Ul93ghF9cE6K0FrUu2qfTjXt4AY0w33OMAAAAL4xVaz087sWD5vu*)
(*JvPmy6ZgRcdLWO3pszcExS7YXNt9rZ+9ZROz75oi0IfqMvwoLfKALHOS4Rdl*)
(*kaWRqfQPnrRnm1MXsaV2bSSE25JP0efjIRqOn+ZFaNCM+GlR5Fnkmf2/Ve9i*)
(*Pj4yraeoiWAmKFY2CK9tlVnykA3RPPY1Ju21+tntEiUW0Rq+azHfhTq16ZwQ*)
(*ktPwNgtMMurN6Jaj9psp6XgRZUWRxXHyOXb9bgtvKcRL9mfoOgEA4AvTpMQk*)
(*Pmf/VIbp0nQcUx3lvaOTr9Tp35A007EnTYzsTGZUbRGIJImfbiF8X1q/q3o9*)
(*oLVS+GTNslOqXWqSbs3V3qhXYnIalYU2m2CwnRN8Js37RAMmO0zL1VjCJQXX*)
(*R6b1PHU0ZFHw+ETafhScar2IblA0Qv7hEyWqYiJNqT/dgXJs9pUnqDMzy8zt*)
(*ZgAx/FjBMOvlezlgR9hFSAXUQ/F+GHGCnpRVWfQHyUVRlNfORAAA4JeB6E/E*)
(*gAXgSKxOiJtEuNhWyL5695StSfoXxn16HdMXzJj/VRn2J1CCFrxHGX5aCpVT*)
(*rGUOqTk1Y5VfhZqghXsvn1Ln8Sjbi4oRZbsLZuGrgs6EopZsDXgXiVI/W/c/*)
(*Mq230sQykcBnJ9Z1L4WHh3FoiFvxqm8/UaJ2tQv4WaDaTtme1V2/hdGfiOHz*)
(*Bvr20udayohsTCVrVwdIql31YFkIAAB7FL72mDta1kU2MySn1vL7kuGPOktn*)
(*+hCydohL9UtlDgc+iOTG01RjtdY2OeJU/WnVauuqeWYNG+Q0kclpZpSfSVpt*)
(*M7q5NOy40CumpLt87uXjI9Pao4xdVVYM95pBZh0zzbbKy2WRpQfFYcrsRWMh*)
(*QD5RIjqsHtapy8td2ipPO/q9XVMVefFiIZvoDPu6c9PpaRnq5q0tTB06pqoq*)
(*qm6TTWiRBKau9Q9M76KEWZXlolZp5YvWTplbnzMHlVQrWX4AAABASUyijAMD*)
(*oXI4CJZu3PVAYvla8fKN4cipV6ZANNyAHnE+9LcdpM50d6oZ33cXpUv/hYB7*)
(*H5nWcUZMJpleu6uuIT1xeMO4YeHAxDlzX5y7WiKmt1RfGrsmJTaNM17sAd1k*)
(*7vhp48mb/iqbs0o2g9id++9o3pN1krmDTnfPSLWJxccSK/wpnYAAAOCdaFKH*)
(*7J4P9IHDWfMNR9E6cYZd+4b2hiX30fZIPwVVaLy9coZDPaoRCZ/Uh5RDFOel*)
(*Kd3npnVGSzYjD8G4usw3qTYKB4J+UY3d5q5AJcO9RrpcIiYZLg6mXdtWDpBl*)
(*ndfUzXMXEgtAze0zR32o38WXhwpgA/p9KS535YdgVTWtgR5ZD9KyyjySZ8V+*)
(*zhm/JgLnwalE09RlkUW+o3KiqfOzHegDAMD7QU2GNg9f2jqNPHZI+DD8vfVo*)
(*oi5Sz2JLhmSka2mTqVyWh3FgDHuyexB2jabwWRMIkupG9z1+Sv9M+PmMtM5p*)
(*y2I3SM42dTLJN9fuuatj63Gc4Ru1ty0ZWoYhHiDsSk35YBbC6fapjKr5d3Ri*)
(*TRmHQXJqD9BNHc5UedvDef9TTZmm1bgVemiTDQA147S52ivTOAiTK2aBpHUE*)
(*/aol81SEyVcIAAB+cZimZctgu0ldSZgf8ZwsMbWrzd8YnZ2nj26vhqBb2IkK*)
(*S35J6MJeZmMqMVFxo+y6xJTTWG9yfHGx/Mi0Xk4VjWqrK3rLOjmRDG+U6LVj*)
(*oaLe1tMYbYhJ5ORZdoVAp/F2rrRIbE2Vt5YNzz7VkgN93iWtSYiJpjjZtrC4*)
(*NLJ9tjMlARY4760rsCLI7xs8EwAAfhoqi6gExX1XvrYKLGaSdW1nXWWBwuRD*)
(*e6k3rC0JkuEGTUbO2V96sDXIbMI9mY0Z4N3VonxkWm+i9Gx/5l9FLRyuiQfM*)
(*A2VHMrxTopdKhsS4UTInn6+KhHA5C8+4wKdatG1zzSr2/NmInsw118HYjz81*)
(*1iTvgBPSjerk9UwuIhyeHe+YiOGi6N/VW7dEnjwwpwEAgF8KapZzJBkOhCQW*)
(*xPWDzjLcWUBpipAMFyQ2dUeYSVRNVRTkxjxy21pVP3FNXlMENpPZBMUJD2U2*)
(*dtz/5JW+r06rzNMoDMMo6eOv1/nVu88OqAJBMBa9PT2NyzTlOZa3Ozb5653a*)
(*2/mUbdnqPoqiemsrDRZLx0rGP1HPMsm6N9DaKvVs24+3/UpCTVhEiemKvBmi*)
(*6vRTJCTCrMOzaD+qx7/SpqFnO/6hb1PrD/pJd8N+5RRyGY0KS0MAABigGrxT*)
(*ybAl3og3TODoUREkw2tQ5S0fO+jHcBGtpTPNy3jLgyC78X0rzaYMbHq8t3Mv*)
(*SU9Nwy9PQZuf4RVpNVTzLGiGZRq0Eo486K8xJKouhBV2RnxDMtyUuO7V3o5k*)
(*aOq6cEBvb7BKmurfpgv7YuagbN86Wz2h6r6qeMvKe2pE08sBRX06wWe1d9sD*)
(*KxpOhO2Ef61K0ovWlYMVh2RDMAQAgAEW3esgMCyhCkngmut78mgwf+eUGANM*)
(*qQLJcAZzW9iy5G/7lVe06MpVZ0O9CreMxziqODrSjlAvGMF4hYPQG9IigZJk*)
(*LlBSm+udSLd/61mV+rqm2cGJso64XC3iAtHwyJdKTa/V2+zAt2qPhT18hZ8+*)
(*FTKlaKju6VJj0UhST5ZfdPUbSUWce38zD2j9lk8ZtYrsxLkpa8Hy4phLxMPm*)
(*VrbjqiZ3mhR5GhpdRqXhO3VqaaqqGuGgc6zzyHVcLrZSGwxNjwirAAAwQg3m*)
(*xdla1tZlnhf8XElOkzmNTRO5pqabIZ1j2/6FinuDnCavbZxG3+QIvsmMtnSZ*)
(*B7jsrM3sayIZjjWZDefOu9qzOnPMfawON99ZBqvEZfah8qXDtfdKqxpWeylc*)
(*nluagrrnJFJTi9kT1wmqquor0Iv7EOJtHTnUfWYVfrN3di7LpVRFLoJcb6bu*)
(*1l7hb96//BTMZk+QNX3QtCrKFJNFmXWqltwG90QiTJTtww7Eee8r3AlaGqn2*)
(*O8FOf0x+Otok6LOj5Due1HVgcKFn5pABkljjD/orJmN6n/VDMZwgoDe9Px07*)
(*EQAAvif0cnnegXFaZC0vyrLEHSZQyQincymmKCCXzI5x7STNitIsjRxyvrS+*)
(*TqLNSXKf54v6xWAWbjzKXEIhkuF42lU5w9K/56gyLd+7KBuvMmsxno1Ty49J*)
(*izjVblg41PvXeTQe/ehhfOkm6b6sWrauLAIeS3Y0e68twk6EFKVBP6s6s31T*)
(*7tKitdNnn6g94m2xdtx4itrTxhIp3bgrAyruqvaUja5QXd+RVE3uepAkK7Kk*)
(*7YZG3CDtOqKg2pa+rDvNuWt6EAy5nfnLRETPecMTpJtM9jseNV9kIij9chmZ*)
(*s19JWpAisioAACygN7Lpk2jYhsuduOSE81O88VCYrGtlsHxBczaVRemQ2MKa*)
(*DhxC7LgEWVFVVaYqD/2NcaG/NOSKja6T3BM32jpLs/IkoGFbZFQCbOoyz7I0*)
(*TbN8HaS71NkFysRRYu5RUr7ikkfqIeLdjwG5+8U8z4uxLE2R5+U8CGAvLQrm*)
(*cMY67OxEM6tuFKGtioKKbU1Z5H3dnVf41W///+zdy8u17r8f9vVX9C/ooJM4*)
(*z6x2UOiklj0oNDiNs+w4K466a2jAQWmcJE6KG4qFYlMq7OCemBBpiYRKiFAc*)
(*RDY2YAL+igV/AQMO7nodPC6P63Afnuf94jv4PuteSy8vL/XjdfRVmh2vXx2p*)
(*LfIiIdWzfSdMsl4gzakHBnMBAPweeM3PvHtPU5HnTPfozIv1KWa7+2v3TB1/*)
(*0pKHBfvF9jq/7JE6W08WjtDIUNDjnDyMA5cFFIL16zbHs/mKxdPzFb9eFZJM*)
(*FqWOyAKWeQVgSadovjrsd6agPUsV9xOvBLZquUnjo0IngeG36evbv2k+uS7k*)
(*hoq8j4oYYwIAcF7L+n6bTw/83Meep8pKVzrYwfsZDo1sfOWIX3jtabZ+9NF4*)
(*+TfunwyS3V9/mfeE3F48+QBrSv7kV6SQDF6SyVVeBqTB9dLaKO9U8wmuXz+p*)
(*YJV6NObUTq2hAgAAo4JOlCve9wx8lTanlSSq98vGM++yjAw/2Ny/Xxc4vR9v*)
(*QHcXzbVNomnuZxw1rdAbqwRLX530iGNYJ7fH+kWwWc2/YHh+5ZP9KoosyaaX*)
(*fJ9QiU3T/ZrBOHN1FtguJrEGAHhM5dKuPl72+vtoHtL1TDUPt+jrGlI9JZos*)
(*Zm+rzGaDTx+bifqH6N4jaFc+Jch4sNCWsbqypM6bFKzNXjHcKCKVTsvJl6iM*)
(*jm64OrK1rWLldnaZ5peiU1RJRhh3kjRN8yudDN+qrfIoiuKzMxACAMDnyQPb*)
(*fMMcDt2L+3IMC5zQ5IEmj4N7BLYotfi9KnzepC36GVH4cUtu8nnDSNsiGIYb*)
(*K3a0ldsxGVouXhlo39gimSTqdeNOLphM4cI5nxRpAwAAALxATWbfW5lU8FM0*)
(*ZEHCoxGsdXUxbc0XjYltyWIfVhddt03dJbquQlOSbXT6BQAAAPjt1DEZuKQ5*)
(*EV18uy7TQLkJ7pfUXQIAAADA12pyW5u2JsseJnkGAAAA+I21TV0R6F4IAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAPCraTJXuK0Rzer1e6sdeXVnUly/fmcAAAAAcEmd*)
(*WDQ00yzLMqfssHn93prQnu3EtCxDkxAZAgAAAHwHLDK00jeEgee0aZcAEZEh*)
(*AAAAwJdjkaEZ7zcdt1XZq4jhH+PH9YOxJU0AIkMAAACAr3cqMiyD1d6Bs56C*)
(*VvJEAhAZAgAAAHy9M5FhEejddwTF8KO0yAM2YkUy/KIssjQyFfKBl7dPJACR*)
(*IQAAAMDXOxEZtr56u+kBj/wKn0WGdt81sUnM200rnkoAIkMAAACAr3ciMizU*)
(*mxD2kVvmKDQwVLO+jrAKNUELn0sAIkMAAACAr3emNbmphrittumEhILqj43H*)
(*bV01DzYlfyAyBAAAAPg2zo1NHr4dSbTGUA8ebj1eTQAiQwAAAICvdykyrEKD*)
(*rY8Svm59FESGAAAAAN/Epcgw0OjoE9F64cJ5iAwBAAB+tioxdedSa2Limk5U*)
(*vis98IQrkWGu0RpD+dGpC7cTgMgQAADgZ6poTzPRKC6MOWhDk/zICF/WOQ1e*)
(*5Xxk2GQOm9TaeelSeogMAQAAfqxCJ82Jen75h62ndr8UHp4PGd7kfGSYsGHJ*)
(*k/lq7jRFlsRxnOakfrgu8vrE2UZkCAAA8EPFtOrvwSqjJiET4YkmGpW/ldOR*)
(*YWWJdL4azV/9c+qb5KVBkHXDUCXyFkAGqpyI9xAZAgAA/EglXRZN9R6u9cs9*)
(*jW7geo0jvM3ZyLDkS58Y4Upoz8+sm45fj0m8FyEyBAAA+EWxcalm9MSw1CaW*)
(*D5oj4bOdigzb0lVF1slQdtLlX8tApH9YBHe+qgQnCgsiQwAA6J40VdmriOEf*)
(*48f1K3u5f4NkfJNDJinJk9BzO14YJRXZZ5uER09mPsWxtKgFapv5YZX3qslR*)
(*8RU09OCnNim3dR76JPM8P0xyEve0RRzlXxHWNGUc+F7HD7PyXMlp68WpaU9E*)
(*hqnNlsObUqZfL+kkh6qb3e2tQj9DAPh5undhXdb9vnmrreKQ32xPdZ6eqjPf*)
(*dYOEP/I8TdLcGFUj68rg7lmzJL1uZoy6LNZP5huS8Zn7ekSTGdJit4Isi4cN*)
(*f2Wok++K5iKA4BPc7R5WMglbEovu/okm6S+U+cYy7ySSd4IRfXJKitBa5Ltq*)
(*H95tWk9dnhs3b6+tgbKG9T61kgdjO0SGAPCNVDF5GRa0mL5xN5k3f2YKVnR+*)
(*ko3aYcuJ9s+Ibmvk1i2bGIt5rwhImCEohh+lRR6wZ5xk+EVZZGlkKuSDlwxi*)
(*rYvYUruzKqz2hH9tMj5zX4/qS6liZTR+bavMkoXVkG8h0EmDoaiH848LFi8a*)
(*jp/mRWjww/LTosizyDPv+yVWkckCmR/XoFynNr8thKxyrM0CdizPtbA/oOTl*)
(*R5QVRRaHG5bm73XgbAtvGcRLdn11dbw1iSUjMgSAX0GTkhdooZ9/o0lpk4lk*)
(*Oo6pDhGikp57fmUufxuXzHj4sC1o95tuFz/tIfhmra+SBkWeKwXv2W73I16b*)
(*pHvgak/OfNfHaTwQWjsFL0vGZ+7rKbxFWPCme2rJhXBQ69Vm2l3x/qDBRvdT*)
(*v5/Z0Gf1h7LT1xE2lnDT5gvsDvHJa+fE+wSsZkxQZyNzM1d57VJxZ2QkvpeD*)
(*vgm7CHmAuhve0xIo6ElZlQVpSC6KoqRvB3/4C3Ln+5M//6uH08Oam+9bk+81*)
(*/8rtvvn35lFoTQr/qbEqAADvxCpPxKG7U0JmZBhDuJh3rVn2qlrVFv7w3r54*)
(*dLIeOIIWvDb1P1yhTirWMkdZVCJVoSZo4daPD9V5PMT2omJE2dbT8gXJ+Mx9*)
(*vQAfAHKzp+27HzWJStcGnE6+ErODXIxLLXxV0PuQsmXvVjdljBBK/T5qahKW*)
(*BvOnVRKxmrGbbM/yjkQ1+ud2miTnS5/XUkasi4BkbeYpexlRveruteUP/+hv*)
(*dn/507984iAqWocpGItXmzKw7HkQ+MfkH9xHhk3mSqL2014UAOBXU/jabT4x*)
(*V11ks17k/Pl1JjIsSBuaqDumch8ZdjdNk0aNToYb36iphmzlQxIE1R8fWW1d*)
(*NY9Us9I4TezjNDPKD6pynknGZ+5rW+kaqqIa8f3zfj3RcV8brk4fxJGlB/sr*)
(*mmyFc20zDJpp+sZWb7Kp5n4IQh+dnqliuqat8rRDXu+aqsiLF1fksTrD23xu*)
(*FtL/0rwU0tehY6rdSdNt9h5aJIGpa+QD0zu5rExVlosv8szfXM649SfdQSXV*)
(*SiYbWI3Wrkoc1jHHGXrZ5qQmU1/Eii/ZFwDAG5SsP5Sx0zuIzcMg2Ye3sJj2*)
(*qO/u6Rl93t9Fhqy9idSkIDRcwds3b3rwVFPqrO5ONeOrY0WvJOMz93WwpZg3*)
(*I4p3pW5D4w7DTEXjfCeHNudNwDu90XjgJCyDgbsk8Mjw/kp5Rsr6NM6c7Qpy*)
(*UpO5w6aN4LEpGSt70pXZDGJ3Pn5nZUKYc3hvlq1xPU0s3pasfqXCV0VrWdCf*)
(*AkEg81zLZn53y0NkCADfU5Oy1T936gNZW/NsTOX69xLyqi7bZEgpa2y6f971*)
(*u/vszkg/QhUaz2cObdHj1SHhsjblxcn4zH0dags+EuFCkNmk2hAcCPrJmuya*)
(*zFq8HxmWhsjizaMKtLXIsC0jXdkly7q7FTXxRZkFzSWJqyMeBb1h+PPQnZjk*)
(*uXe5zjN35ZtgVTXPARoL6kFaVpnH0iw+OMa5ZgHnTsNE09RlkUW+o05CU9bV*)
(*85XRWtuQ/otFsTVbDSJDAPieeH+h1ZaXtk4jr28kvBn+7it8m5HnhMS3sxUZ*)
(*Di1xq2sH/Ob4nCebrWDnNIVv8Ue2IKludHnEz4VkfOa+Tmi7B355tdIyGeOb*)
(*c2vVseGre5Fhv0DG8RDX1cgw92VBEHcIN8Ven9Inpz1DJtX7PEbV/CtVsk0Z*)
(*h0Fy1CXggzSbjpm3fkVvb6op07QaXg1umjscUabebbBM4yBMznQTYHG7oJ/t*)
(*zDweAh0r9JnRGiJDAPiWWjb/xmpv7SZ1JWHWvrP9fGFdd8aan+3I8C3NZ7+E*)
(*nNVfyS+Zx4/EbH19mKi40flpUa4n4zP39Q5VNFRbHdfyfYwdFLcCv5zPlCfH*)
(*h5WQr70cKj7aerxMG5ZU8dJc2oHO59s5Tj/pQDJm3n1seLSpljXoT0elNQnr*)
(*ojlJcz8vjWwftS+zORYuzgLUH4KcNHvRWlEU/8FL/Zt/9j8gMgSA74evC38T*)
(*t8fxtVVg9f2xxik4Zgr64j9txduMDD9qNrkvIsOFJmPt7JsTmFRFnsRxnGSk*)
(*5qQp8jMVKDRmE67EbIfJ+IR9tXVVVfVU++Km0NKz/dkQK97JgYcHR+mO+xEo*)
(*q8/0vvvixsVyZVPXsM6Nkjk2wlZsCpej6RkXfF6Ltj53ShV7fjrLvKG75v3k*)
(*5PubGmJsazKWJ+TvqvbwEZ0OiH22/wbBOi6K/tWq65bFk6RHDeoMAeC3x/vk*)
(*7EWGVMgmglhv9ePBHu1rLTC3CdmaBoF8j4gMFxKbj1K9j6iaPGRt+opu6Bqv*)
(*otkbMbT8fRHYfcwmKE64F7PtJOPT9lVEw7K03UbEfh5jzY1fNMdhFQiCsSjw*)
(*6fmpmYaKPmutDPf9JZQzw43XIsMm8xRZUbcpiuqld6lseSPsZI5lPrhsPZ3b*)
(*2ir1bNuP18eVhJqwmCWmO2Sed3cX9f6m2KwIswLQz/ajetOftGno2Y6/O7yp*)
(*9Wn9pHufM8ca2pWaDFFHZAgAv70+qDuKDFs2FHErMrwf7DchGogMD/HK2+nc*)
(*QVwZ0oHh1thSV5Mqjssz4DVlYPO2vdV1SQ6S8cn7qshw+KGQVFnAAgb9wWGw*)
(*M3QUs7rYUN978MzUTHzxlNUy3A+RHqe83tFPbjNrh21zsvyQsGP5tsV3zC6s*)
(*oVzE/ehY+5UrrFTdVhVvmXkPXdQsHpstJdPn3uURSRFtpLCT6c+qJD35KkF7*)
(*NUg2+hkCAIxTe+3MCstULD6xV7/WzJr+6qatWfdFyQjrhvx78tUE/QxX9GMW*)
(*7rrxs2eutHhQ1pEhGY9lYBVH2+3Em8l4zBP7oh3kZvPPVCGrtt6uK618S9d0*)
(*+7DSiHV1WAxh5tMjC8Y8NW1VllW1PIiUzc69dtXwMTXL7azjlWYXW3vX8epH*)
(*KaKJHRc1Fo0k9WR5cuW2dVmW9WPzRrG9iPNpnPsR0PqlYsN7RXbh3Ji0YLlw*)
(*zClssizZjquarWlS5GlodAmV6Hbq1NJUVTVCWudY55HruJPpldqAnno2lhmR*)
(*IQAA7y0vzh5k3aMjz4vpzZm1Jk9aMJvINTXdDDcaeI7HJkcYm9xry6H1dDmH*)
(*GxtBcF+j252hrX6GdeaY26yOez+12kEytrxvX/eRYd8DbauydJzP8GA8C6+q*)
(*IoXQi8mU2m0dOXwEjTV5TLdlpAi8NVtkk8AMf8rZbH7LSQKrxO07Ushn+mmy*)
(*I7ra2ruu77MnyJpOF55WlHFOFqXP5JzOsycrJAtkVZEV49Ks830lJ3nri2lX*)
(*1y7Q0tiZPDHf6VQ/Tkcb6x/7puQrI6lrFtetYverxBq+QJZcjPl61jfFcILA*)
(*0+kftX7WHUSGAAAffOXW6ejFoXVYsrwoyxKX3j0lIxwfg30twdYKs1uRYT9L*)
(*8Ilhm7+HvnvblDI8K9h8wuen4PiYPrs3KfdBy34yvmBfa5Ehm5Jla7mQPlo7*)
(*iiuapNuyatm6sugDIdnR9Iel0S+TV/g63ey0CbVcrubT97WbWmnzneH9AL3X*)
(*LCVee9pwREpQtGXAw13V7pPRpjLpAEkOJPdYZl67EFNbugmqbenLvNOck0uW*)
(*DAKa2tl4mYjVc55ahZPp7ifbZY93X+xDUL7lMjJn35K0IB0LH1sd70+cx9dN*)
(*Pm99dTwyGArrJgPA1+LLk+ljaNiGy9dwyQnnPYuGRuGN+hk2uOD+IZ7Sz5/t*)
(*xvbbYJOznZpK5RezGhnSR7y27OQ2qosszQ9n3G6LjEeATV3mWZamaXb/qyqk*)
(*dYWSLBECqXabFXW2CPhTnSLY6r2K+8JegGWe58VwLE2R57O65Zos/6HSZnQW*)
(*1U+Gq5zSVkXBf9GURU7yLs3KjZmcL2p9lQbKr18gqS3yIiHhfd8Jk6wXSHPq*)
(*rk393/7Dv/G1kSHt7yr+tGW0AeBXw2t+5n17moo8ZLrnZl6sN1t2N9fugXrx*)
(*Hs5qWoSzS6ICWzzuaHzQL2gtMmSdV68GM4+hbdP7VTcVbaW8UMG1QJuSP/da*)
(*YNOzqF7Dw2zxG1Xd9y+bz6+TuKYir6SifXi4D0WGpDMqVxHDP8aP17p1IjIE*)
(*gG+sZR2/zfMToTyEVbMojy6H+ltiI1AEdzG8tI41zfs+T/XXo22+s8iw8Nlq*)
(*Hi8YnHxCSyv0xubgwtfWukbQRkv/gdiOzaD4mh6GV+QOGfesKLIka0H2jXq4*)
(*1XyC68cj7S1V6tGYUzuzhsojkWEZbLdo940ua20riAwB4Hsr6Cy5YvC2Gow2*)
(*p21n6i8dz7xBl29sLsPhOd6UsbK7LOyvgC57IfJOaG0Ru2whYu/zjrpg0+4o*)
(*phtFJLSw14aU9L31rr3stCVddUV6zZqAF9B6Ocnw4iROkjTL8te0A78Cm6b7*)
(*NcO05+ossN2z8eYDkWERkG6ogmL4UVrkfLkWyfCLssjSyKSjgVa7kiIyBIBv*)
(*r3JpPx8ve/1dKQ/pYqaahxveA9qiH/55Y5OIS276jWp7Xq6IbHmYK51Pmy6o*)
(*pne178KTmjwYFn5T7M3KvcRVuzOSXAixapP2UHzNuJNrin4VwyF7jXe03T6g*)
(*SlxFllUz+NoXnuuRYUvWedEDfjILPhfT8B7RJCYbE30PkSEA/Ah5YJveibUb*)
(*Lure2pdjWOCiqiw6ZYlnxmdqSC+xo5q1uiiuVL615XxKqE9Tp44g6DmZp4cq*)
(*Y/kmbE9F/ju6HhkW6iQPM4cv4TL0/qhCTdDWR5AhMgQAAIAvFJFZclQ/yau6*)
(*abq40NPf0Xr7oz3QmtxUQxjH53kQpl1P27pq1l8bEBkCAADAF6ozfzqJo6ja*)
(*n9xA//09NWtNzVd1OTm8GpEhAAAAfLmmJjOr1BsVWb85Hhn++SORYRWymbrP*)
(*LvrMIkPjnyEyBAAAAPiO/vAXpKPgn/7lI2t38kWfxbNDzpt/5cr/+X+b/nH2*)
(*ISJDAAAAgG+CBmY385G1jHM27ls+WLb7TAIQGQIAAAB8vYcjwyZzWO9NZ23e*)
(*y4sJQGQIAAAA8PUejgzZSvHT+WqeSAAiQwAAAICv92hkWFl00Leg+a9IACJD*)
(*AAAAgK/3YGRY8qVPjPCRoSt3CUBkCAAAAPD1HokM29JV+TSRsnNtBe2NBCAy*)
(*BAAAAPh6VyPD1FZuS8ojI5tnCUBkCAAAAPD1npi15oUJQGQIAAAA8PUQGQIA*)
(*AAAAwyJDK/my9aQbRIYAAAAA3wOLDG+CKM2IouK8I1iLbFUQZ/uiY5wlRIYA*)
(*AAAAX67JPEWSlQVZVs3wuRmsV9WuJt/trNub/tw6KgAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAPC7azJXuK0Rzeqr07alSe3VJEtm/NVJAwAAAPjB6sSiQZVm*)
(*WZY5ZYfNV6dtS5OHpjFNa5d2QyLBLCJDAAAAgMexyNBKv20YeFJrizcBkSEA*)
(*AADAE1hkaMbftun4pNoSUWcIAAAA8JSTkWHbVGWv6pT3qv1qx+e3sH8ciAwB*)
(*AAAAnnQyMgy09XEq0/EfyW5g9/wW9o8DkSEAAADAk85FhoVOhysbjp/mRWiw*)
(*GE/y06LIs8gzyb9Vr33vFg6OA5EhAAAAwJPORIZt4d1ugl/wwM1ntX+y09fw*)
(*NZZw04LirVs4PA5EhgAAAABPOhMZFr4q6BH/R5sqtL5PcbP+76V+E8PdSsfn*)
(*t3AEkSEAAADAs061JrdNPdTu8VmmBa8Y236bqj5oCH5+CwcQGQIAAAA86+qs*)
(*NbEp0bBOf7jp9/ktrEFkCAAAAPCsi5FhaYhsJEn46A6f38IqRIYAAAAAz7oW*)
(*GZY+G1T8+MzYz29hHSJDAACAz5YFjpdce6BnvuOn9ZvSA8+7FBnmnkrDOjl+*)
(*dOLB57ewAZEhAADAp0oc8kzXvPzKj1o2v7H94xdf+2VdiQwblw0qHmebWaqK*)
(*PInjOMmqtvt6kVeLYSXrW2jrqqrqqfbycBREhgAAAJ+nikw6zUh6/ac1DQbE*)
(*oHx9quB5FyLDJpGXs81M/piHKu1AqOiGrrEv3oyoOrOFInLZb+nIFJE1N4uy*)
(*5sbnB6kgMgQAAPgs7IEu2Q+2Ctcx/bmFesNv6HxkWMcmC9384q5GrwxFeorH*)
(*8L9OVbLZ+uwWqqDbgtSHdlUWsMpFPThZR43IEAAA4JNEdDSpkz3eMyxzaUu0*)
(*/9J5SuAVzkeGfOFjwbir/a1tMg+NtJiquo4MyZiFattb6N4+4m4bs9CuCuns*)
(*NmJ06o0CkSEAwM/VVmWvIoZ/jB/XL+6evpeaZp6c8l71vtRkoe+6wX0Nyju0*)
(*dR76nuu6nh8mOXnctkUc5UcVgSWpzOkeuvPn88WTWMf0Ka9d6qT4/bR5EpIc*)
(*dL0wSmixaJMw/qoBNmUW+x4Rxuei9rZeFOz2dGRYJa7Am3vldLEzGtTdRGuZ*)
(*D93uJv0M97bwsRYZfnyEuni7q3jcgMgQAF6hLV1d1v3+YdVWcUhvtH6Yn56P*)
(*v55HEmwif0+TNDf+lKf9D1QGtyOSlbx2n3VZbJ1SXo+xm5zkUmjY1kV5Kljo*)
(*F4MQo/fHFplvLI5KkGSR1N9E+z9MLJkGhvOvXT6JrFrpZoQ/trthkxnSMgtl*)
(*koWfcfqW2txW5uVWUKNy/5bT8mHBE27eHkeGTaLcnVzZGmOwJnPJ/vXg4S3Q*)
(*76xEhrmvdd9U17o13kFkCABPq2JysxK0uCRP/Sbz5nd9wYqOW77a3Fve7xSP*)
(*bY3ctWUzR3R4pwh0kr+K4UdpkQfs8SYZflEWWRqZ9HnnvS7j6iK21O7cCuH6*)
(*47sgqbmJhuOneREaPDl+WhR5Fnkm+bfqnU5NHXsWKUj6QbhFtGn/oJbeXetU*)
(*9+uRWSF7yLZZwHp83cyDtrqSZcliKMEDJ5GvfKH6P/OaqB06dkJQrIy+Y7RV*)
(*Zsn0uJe1qZ8h0PkoDUVVhqEbXbHbuW7awlu+AtGOo1fXQLlXx9bt+ZmrVyND*)
(*7/xweESGAPCchj6UBT3v/0lfaSXTcUx1iBCV9GgpUF9d3muthD/j24K2wQl7*)
(*9+rfUpdppFs5z5WCT3tr981LTdJFLNpLuqP1MSF/oK+eiO5xOe0P77P6w3FK*)
(*jcYSblpwJjl9TEj3ZoaHP2l9bXikvz0yZFGZoPrTDzMyZlgMDwLDgC1YEczq*)
(*ox45iVXEKi3V7CdeEXXEVnTzpkdFY/vDStfXa1OZ3K2C/l6TW3wo8E6AR0+Z*)
(*oCdlVRakdaMoipKGuH/4C3Lz+5M//6vH08My5741+ZK1yDCgrcnDTXX4Ki25*)
(*i93V3aUqIDIEgAex1/9xGo2ke9ucvG7HNmv6kA4aiUhQ0b3PJlV3ry34vXb6*)
(*0CtD8igUtO1Glt9RoU6q7zJHWUQLVagJ2rPLZtV5PET4omJE2Wb0U3TB/VC/*)
(*17IXhOmUGqV+GDuRmNDsY0LRcKPlFG5rWNnQbFbU3h4Zshbhm2xPW8VrEr/p*)
(*+427uaetXQuPnMQ253VWz4xk+TJNzIIve9axoCYR8Ke3j9dxV3iMWankgzW2*)
(*I0MWvavefeH8wz/6m91f/vQvnzkK1lVAcBdBfx1rmnf2ZDfJMjIsfPpWct83*)
(*tSbvYHeRIe3D88CsSgAA3f1GowHbWH9SF9msGz6fdGs/MmxZ/ZKb7sQNlSn+*)
(*2Efh2zTVkK21zVropi2MbV01j1cq0ZhQ7GNCM8qP2sjaZhgn0ff6E7zJgJCm*)
(*2ulySmLCvuJPNN1zYyg/+joWxWtp5c88MmwT31YVWVZUy/VsvXvWrZTCMnZV*)
(*WTHcs70x4z50VaePzjLUzYMgnP/wbjDpIyexn8vu3ICCa6oiT5M059Mr568f*)
(*MsRH0JAsnI6eiCz90vChOgtNXVUU1Wa1yk0ROKamdnTv/Nx9TVUuS2XDunFu*)
(*RIb8ZsVrqFUrmbzC/jH5B92Hf++5qcjbnEVxStC/hTUl6a5z4dZXkj4JfXfW*)
(*tohdVlntrWyBBqJPVlECAIzW+03Nv0Jb0CR7517Z9i1o7F5r+snq4yFjM/4r*)
(*LkLDFbyF7qafaq492ti0nlA148Mht3f6KEg/0cF0Wk8omd6lWIdVWSuk8okN*)
(*6hwjwzak88MohuM5xvbysnUfj54d+8DGCDDG2QniCF7ZKG0/hc+fxL7a7dyA*)
(*gtOq1JSXnTpk5+V1R/3iHSTXjce6iLD+eEOpiSNnnu7D7ivb+j6rbr52p2li*)
(*8bZk9R0eXhIZkiQUUd8/QhDIgUm7b80zRWSP55D9unvVML3Vo0FkCACv1aQO*)
(*uy9vP1LZg/tgOGpiSstbrWzdVx70uztskfwdVaHxqsyhDaP8iRsejNDcUhqs*)
(*kuK4Iz3p0cRjBDO6ujM2s5/FHsQ8WOojQxooCnqfgMK/rUeGLet/dROM8yE1*)
(*2y+jeydjs76uafspfOEk9pGhNGkxbMtIV3bJsr7TRFjyKe9cuppzzCNmwX1H*)
(*794m1YYcFPTr7QBZF1qaSZXa8nginLCoS1+Xjm5KB9gokp030KapyyKLfEed*)
(*3LccWvv5qsiQIT1rSN+at0ZtiAwB4JV4HYi4thxDW6eRNyzSZPi71Q5tU1dl*)
(*nkaOOZkJ4v7O3Leg/eDJOt4m6KOOFzyTmsK3+IkQJNWNrkcGpb9dR3f33cQf*)
(*hraopnt+jiNW1TwGn4vIkDdZik7CSkvrSsJd93u+pe4JfHq3HFv4+HahQNZ8*)
(*UM32U/jCSVyNDHNfFgRxh3BT7K1G85yFalZ/ykoepp6o9Z0lrIzDIDnsePBB*)
(*IrAxB0VzNQfLNA7CZK2vaZPGXUBe8bpgQRu+xIP2eZP99nbuVfQ0nV1/cCwG*)
(*dKTVayPDT4HIEABeqK9sWWsda9LuOTxr3jm7ZEMVD2OUncUUrmtPQ6D4Y11+*)
(*4dSFJD7s63VExY0ujILN+Vxvcny6LqhIfK2vgVEMNzt+ihc0KpjELXU869Ha*)
(*v0fcaIP4cSfJ62Jr3MOJ2PAwMrxyEl99LfAB15MOwwmLkPRrI5j6GWCkU6e+*)
(*isYcvK9eLvkEPrK9/l7Z8mZ9YRLF9R01p/MBHm1nKqWR3qU2+r4YyElzEBn+*)
(*u3/37+pv5t//+/8XkSEAvE5liQd1IB9tFVh9j6Jx9pIj/BHf3ckXj0j+bEVk*)
(*uNBkznos/YJNk/hQuBYf9r3Izp/xHo0PhTPx4dDNTOxeQASmDzLo9Jdx/VGE*)
(*Q7M4iw+dJ+uaq9jzZ2NYxv5yZ6YTj1nx3bherp3E10aGvH+jNOkvXLLG5L0u*)
(*xGt8XoW21Wmz9Gx/loO8iwiPrKboJEg0WRv1nLwv6/TNlM8LdLOmw5COtjOo*)
(*2FyC+sVZInm/RPJKsh8Z/vW//tf/w2/m7/7d/waRIQC8Dl+I4fCuEhr8gXj+*)
(*GcOahO6eenyPiAwXEt7bajm7XV1V1bSCoHk0bmyKwO7jQ0Fxwt34sK+sUx4d*)
(*HFEmwSQ+dFbjwzqeRX13eGTSlomlTXqDKefn2V4RaoK+iJT6BSnOlMn9EShb*)
(*J3FdHxlO59ZuMk+RFXWboqje2uhsXsdL52pm+qZk+erQ57ZKPdv2442BOVUg*)
(*CMZik+nmxFZtGnq242+MfypY9eS0fo8PUlvOzbK/nf5LOZuL5oEBbg3tTU3G*)
(*WaM1GQB+b8f9phje6HMlMmRznijLQZGIDFfxyttpUyDVRI4xjKMURT6gQNHt*)
(*kz2ulpoysHlj4cYaKEQfs41TXj+mTAOdjbFcXQOlbebNYk3Nnuw3KSi6f9Rt*)
(*Hcn9ghp1HvZdFJRra/PNVKbQhZaLmOdCmUz6Zse1cGvrJG4YIsNJENLmZO0h*)
(*Ycf9MmoUq8wcD2EYfis7rx18QsuGusxBNuLj4piRtfFoFa+UfWC6bNauLc+m*)
(*UKiypDhVWmg3AMlGP0MA+O31Yy13ZuFgqlCc10gcYnMC28t+hgn6Ga7oh3us*)
(*joOggzeHZ26TeDp75F9sJJyq4mivvZMPo7ibte/BnWVxWp4L5u7GJot0KVv+*)
(*1zoUN8KPKvV1TbODoxpOtn1xPoS5jlgQpZ/oaNjP8bgWAu2exO1NnenfeIyF*)
(*rPyyarLhdUL3E1+XN4btPL6jxZw8kbE+zeO+iDclT+4qd8vHnFWxxnQ5Liq2*)
(*cntR5JFLak3trPmoU4tMkmiEtM6x7v7iuJN5nNqApp9NNojIEAB+c7wRSpzd*)
(*0tu6zPPZqzZrTZ50WGoi19R0M8z7QaS+6/pjPUpbBHTu4u2xyRHGJvfa0lWH*)
(*Cp6VDvZ0HMFsWRC+EsdOJ8A6c8xtVmd9prdOlbh9dz/55PM5Cw725oTn5gzs*)
(*5zPsR6DQQE5QWTErImvjqGveXfZo0EQfjJEljWM6DXQXJPBJ5+6n6+wug7Ks*)
(*Fxvs14VZxlpHJ/Fe4bMVql+zynA/d7eg6vSAJGUyfEyZJratu9DpsRrnj77V*)
(*lV7CXkym727ryOGjnKxL0VSbsZ+pkyrc1FltSj5KUx7czZnVo9mbDOs00jUK*)
(*Y2Ps5xAEHpsjR+tnLkJkCAC/O76s/HSGh/E5a3lRliUuvXVKRjg+TfpqFr5G*)
(*ah2NHdj8wLPpLX9tirN+RbALI15/bX0HrSll8VC6jwz7Dlqb7apjCLRJWYn6*)
(*+h53U6ttl4ufDdHClrMzLfM6Q4330+uL2Ugy1jrZNR5P98H0LGn3BBVU29IX*)
(*m5U0Z9Fsngekuklkk8D706rIlu1r2k3izEm8F9JUSMfZe0qTeUMgKJtB25UQ*)
(*9g9BnbyEVSQMEiSFNPFLqqrImnctnKBLtqmWrSvLLLSja1Pj9HPjT4fM8DWS*)
(*LjYoDPerFawHYz/Q/sZeOspo3sFV0oLJHNRfEhm2dZEmSZo/9r6MyBAAXovP*)
(*EaGPoWHLx5tMbp3LOp+hUZgP5yysWWwgaFawemNls9qe7YgF1FpkyLrGPT4V*)
(*8A/R1nXTtk2Z51mW5cX2w7qtszS7WyLt7ltVUfSN8mWRZ2ln5Vd0JCyb2p2N*)
(*XJ5N816xuOLZdXz42kPeC+eg7vIpy4fDaaoiz2eznNP5zwVaZtjicYKfXp0G*)
(*vS0yHgE2dbc7koVZ/uBc6nebft9C0m2RFwmppB06KpDcyfPirlKYr5v8J85f*)
(*vToNm4pgEqnK5lZl/rbVyJC8r4notAMAD+H1S/NGuqYqyY2TPo5Xb/vdnbV7*)
(*JEx/UpXkXlsUO2u0smk0ZuvwwqHfODL8GmyIsSDJEvmvK7LyvCsgWx3mucxn*)
(*UZDifuaVwAsSvT7T7v9F61vV3Kf9PIYvWBtyRUU2L9qHh/xv/+Hf+NzIkK4F*)
(*E6Rlmdm0Q8LZaWNHq5EhqUpFZAgAj2rZiAPziSENZ7BpNO5GK8OBtcgwp2ds*)
(*OX0cvETSPVOFvbY5NhPjM6Oo6Azzzw79voq9A9LBI3QYtfytli8fRohfH5V8*)
(*pEo91kvhzIj+z44M69geFmdsyZCr6+OyERkCwDsUJltP6m2Pqn6qMe87PYx+*)
(*hvvIkK3yIL7hGQoffAYYwe3bNDNHv5u5mg/qf6wtmM3W8qoehlfUpNlSlBVZ*)
(*UnTneqvlO/GVEN/yflpnge2ereJ9SWTYNmyENFFV1fiP0VrbCu3GeX0SUUSG*)
(*APAmlUsnjPOy17dQ5qFFuxde7O4OFI0M+7lN2ipkS9LIFtrk36RfykS0/DBw*)
(*9fvp+wg+tFa9Oh9MW4Z0fplXrI59EZ11UHSCKI7jhPYP/PQk7KhcXZVl1f/q*)
(*gPUlkWGgDeOBtkj3Ff5Naq1+fgSRIQC8UR7Ypvfgshc7ulf2s/OWwEwTWMMa*)
(*1DeBjZUVZNtPEBW+VconjSTxobs2HJqoE408kC+tc10bXxjV92vMjdHJF9Rb*)
(*fneviAzZwHDRcPw0L0I+SY7kp0WRZ5FnstaTuyJABiWplzsZfiAyBAAA+Ay0*)
(*QfBouHNdlJcqDduy+LK63siUZCsmUxBSRWILgolq/IXnI0M6tn3sRMpXExiH*)
(*+DWWcNOCRQRIZkMSjPChHSIyBAAAgIvogjKi5iR52TRNXWaOKpydZ/J38nxk*)
(*WPiqMCwH2U+NPuk9WOqzBQGJLmgX9ID/ojp8H1lAZAgAAABXtYlrTHu/6W6M*)
(*Pgn3eGT450+0JrfNMEtiP+f8bKquppqGfm1Ep+ux/MD3PNfpzpG0tir3DjrX*)
(*t7BYTAeRIQAAABxqazJW9mKl1O/kD39BKvn+9C9fMzyHr1q4PUljEei3OUEL*)
(*Lu6k9jRZ9xbVv4gMAQAAAJ5FR3DfzNesjscmRb+JD3YgfAYiQwAAAIBnvTIy*)
(*LNna0K+KMy9BZAgAAADwrBdGhrmn0sBQjr9gjkZEhgAAAADPel1k2LhsWPJ8*)
(*SfrPgsgQAAAA4FkviwybRF7OV/OZEBkCAAAAPOtVkWEdm2yosf81U5sjMgQA*)
(*AAB41qsiQ750smB80erUiAwBAAAAnvWSyLBK3H5ScTn9il6GiAwBAAAAnvds*)
(*ZNgkym1Jtj4/QkNkCAAAAPCsl850/YUQGQIAAAA8i0WGVvI1bcCv03SRoYDI*)
(*EAAAAOAJLDK8CaI0I4qKU3912jaVkSqK8xSTfo6oMwQAAAB4RpN5iiQrC7Ks*)
(*muGXzD5zRp268lqadTf96qQBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMy0dR44*)
(*hniTvLz56rQAAAAAwJdJHeXWM+Pqq5MDAAAAAF+mqaoi9UREhgAAAABAVKaI*)
(*yBAAAAAAOrUtITIEAAAA+PXUSRhwvh8m5Ueddf/Tf+IF3ScfH22V9d9Imz4y*)
(*tLr/rRLb0FRF1W2/nG+3KcmfZFlRVNV0w0kQ2WSRpyl6XLdZYKuKoltB/9cm*)
(*8W1NIVTdDDNEngAAAACfqM1NeRhTIjlxUSbu+IGoOFHRfauMHfaBoPttHxnK*)
(*mibcRoIWDFvNA5P93ND7ESuCnrUfuW+MPxCHXytJQ1NCN6vohirxP2he9nVZ*)
(*AwAAAPAbal0Wvike/6CJWXCoBeX4ne4j2W3J//PIkHzBCcuq9HX2bymu6XcL*)
(*n8R9RtCyX2YuCwFFMyrTOPStISI0XVsRWGTY+iTMlPyC/ahxFfYtKULFIQAA*)
(*AMAnqhOL1esNTcKuxIM5HpfRYM9KWOTHI0Pdz/m3m1hiURz9e2iQASqSHaZJ*)
(*EsdJmoa8blFgW6stOoBFsRP2axILlgH9TA7TlPwmSSNHY9GjgdAQAAAA4FPl*)
(*LA6T7ZT+s9D7aj03I9NZJ1YX+ukF/3Lfz5BXEQ51jKzOsLJYVCkMRIkQJc1r*)
(*pj9P6mH3dWzyNmdx9iNRlFkCAAAAAODTJJbMegOWXWwXmWNnQD3qAkWN1AGm*)
(*/XfvxibPIkP2VynaDOhWhjazSkvJjN92fAAAAABwWuELvJKwcEgFYZj5rB5R*)
(*DcIubBPGLoenIsOb5hfzHTRZmrerPx+bs7V88Zsiy6v2HYcLAAAAANtqexyT*)
(*fHO7EK2JpOHfittMv7kbGbJuhF1ImU5iOtperFerPyd/tfhv3PRj8qPuNxr6*)
(*GQIAAAB8ujLoexfKDo0D2Xjh+2EgFYv9xo6CTcIjQ/qzbFhbWVDDrGo/2iL2*)
(*umBQstiQk+a+n+FHmw7rMat2WDVtWxceGfIsJehmCAAAAPD5moSFZ8PQkjqx*)
(*WbCWTWr/mtxnlYKqk/Rfc1gEqQe0NbjNtNs9PnK5KUJWNymb4TToy72VH6Hn*)
(*IQAAAMBXCUl0ZkzqB8nYE8EYw7M+Vhwq+NzE16cfKA5tDq5TQ55Mgy2oYUHC*)
(*wCIwZj+/adOYM/WN6dTZihWiiyEAAADAl6mLvGx2P7igKvK8yLOsuBDgNVXe*)
(*6X6DgScAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAC/nTZPQs/teGGUVA35JAnj+uBHpavLup/zfzVV2as6*)
(*5cz/9Lf/s7/9P/6TP74h6WVkS5Ik617zgo11+RAYiihqfvuCrR3trC4CxxBv*)
(*kpe/Iu1zL80WAAAA+G00mSHd5gRZFm83MdoJDatYIV/U4pKHHoEm3A79V2b+*)
(*6pAr7mIrYje1ZzSpMqRTtKrXpG5T6ox7M+PX7+1l2QIAAAC/kdqRaSyoWFlN*)
(*gra2yiyZxniiuRmvNKlKfqPn40eFTn9jOH6aF6HBokTJT4sizyLPJP/+m3/n*)
(*P2a/emlwWMWOJAiyETxYOdYkpuHR6Kkpy8LXRRYZvjueauuqSD3xdZFh6tpR*)
(*Oebss9kCn2tx+gAAAL5GHdH6QsErJh+2JPATjGjrNzSYFINy8ovC637hF/zR*)
(*5rP6Q9npw5LGEm5aUJShQSsagzccyYNSu8uAMQauIvNzIkOqNMUXRYZt2h2G*)
(*Eb27phPeA6cPAAC+iSamVYY3O5nWLdVdeKSF5eovCl+j0Z0//1AV9D6SbHmz*)
(*rOJm/d9L/SaG5LlXsVjIyb5FVVabeySElewhNXVifU5rMtubLb0kMmx9jWSr*)
(*lXyLXIWLcPoAAODbqOO+j6GaTp5LkaUHxWrbVskaipf1G21TD/WDqX3j9ZDj*)
(*FpqqZv/IXIVFja96CjZV5lmaZkWT5LaJb6uKLCuq5Xq2rrnpShVgmbgi71ap*)
(*ekHo+6Q1j0eGNFbsNqKpHcNPF5FbQ/6kEKpuhtl+XLfz5ZXIsEwDS1dlknbN*)
(*dPx8lvC142oKV+PHoVheGPhhWm5kSxeYdx/qitwlRTWdoNg+B/zndtI2ma2r*)
(*XdKDrD46nK1sb7LI01Uz744u7v5HJXt37/o/1rlvm5qm6xo58mTWtEq20O3U*)
(*y9uPKnEMmiDLn36lLRPbIPnW/cHzbE33Jtu/cL62ttOUJOtMMt6q6P5HVcj5*)
(*CfPFQezuaDXz108fO149rtss6LJU6Q72/wh8P+j4ET2/XTo9j30QJH1f37bq*)
(*8lBXdDJ+Ko9cmtWaHaRsT3H3N1KedTeadAPpzq+myKqZoD8qAAAQjTuMhBCN*)
(*wx6ATeqwDoQ74xpikzVQ68XaX/stsCrE57T5OHZm7BXZhnTwhWI4nsP7O65U*)
(*yjWJfFuQ47qPDAVZU6YDaoQxCmlzdnyKbqj93jUvW27/1JeXkWFs8U6ftmv3*)
(*+x+ycf24qtgSbsI0rdLf/4u1bCGjlVn/UcMy+43LK+PPp7l6E8Qxe9xm73DW*)
(*kxfZ6pAu0xz+n31gDbXSVcLfJlStC4t54qyQHHruG+MvVHU2zGkYQl4GIs03*)
(*x/MM3ku2r/W9dL7WtlOWkdrngqSZmjhNwc2K+oPY3dFW5t+fvv/0b/3p+A9x*)
(*+Iv83/93/EJl3TzaIjI1uf8knl8LqqXPBpVpbmAr0w9uVl/k6thknyjORp4A*)
(*AMDvpkm14YEh6PvNvAkLXfYaW0s2KFY0wo3d8ZDM2GitvqCt4ii02WNb6nsG*)
(*NqQWVND7vRf+bbu5tuE1hGOvQh4ZkqzQwqwsU489YiUrZrukXSilvkdlF1fz*)
(*sTZrfcQOvzyPDPtWeN6qyKIU0tBfHx1Xw7ZjsW+uZkvp032rvMWS9Atl8UB6*)
(*l+oyDvufk5DEtA2SLtn+F3uHs5G8PI58Rx/KVxc3Br49RC0qC5x4Z1fRL/p8*)
(*0/nevbytsjj0rSEc0+ygqAqPRz78DSWxyM6DPhYk/R0EFhJfOl8b26nzMPCN*)
(*Pl4lcWMQOGPopWbt0Y4OMn92+sqUHO8QEZr8HUHpfkuT10XY8ZBgj0bK9JM6*)
(*icIxVbT01mU8xrGCGqRlVUT8E9XjCc3c221SeAAAAD7IU2WszRHN7YitDfR5*)
(*vHGPPwS3+871PRunD7hnsFEt45gR3j4uOgk7jtaVhK2n3n2vwv6Tcdj17HHM*)
(*ozU5TNMkjpMkjRweVq8MHzj+8jwybHjLvs8TzkNo/te941prlZ5lS+vTEEL1*)
(*+sNqM5YUzZs0LE5zhlclKTELZtr24HB2ktcfyFhTV/g8YKHJi+i7hDgd8TTU*)
(*6LIApo+Zh8kzP6qQFcSYR4Z0TJTm8uPPnZtI+45eOl872/n4CFgKxPHVKejD*)
(*V3KYezsqjzL//vTVLBRW7IT/YpK86YWT2LNPWtaRQzSG6vqMTY40mUYgtaRF*)
(*mW/rsqzQxREAAOaqaGhd3azu+6h43c320N3cYzGmHG8+amr2aHpVZDhEd32d*)
(*4dhMLKpmlO81Wi9/O3wyCX2nj+Oh6U0QBU6UOqIou3eVrSe+vAwJqjxN86pt*)
(*ytAxhsqePm7cOa6VyHB+aPWsUpFr6nr7JPX9Lcec2T+cneTxdwF5OsCCz35J*)
(*pjDiaVuUh5BPH8Sq/vr0D43ffJs8MkztceemG1Vte/oUzGxt52MoBlYyfrt/*)
(*CdL8fHdHfzjK/JXIcO0na5Hh/JP70nv/yeeOvgcAgB+k9Gx/9qziPQCXD/EJ*)
(*/sDafqz0vRbH+Wo2N/KuyPDjowjN24SoOlu1oJuRobgRGdK/nkz5iS+vhASh*)
(*zeqTBNPleTn8dfu4jiLDZminPhsObOXMzuFsJm8exfEvB6yJWYyqlL1LLLbM*)
(*+y3w9uK7A1xss82tWbdR0YnLM2le2tjOx1pURubw5H0Ho70dHWf+ZmS4qHg/*)
(*Gxnuluf7TwAAAIgqEARj8XRIeT/1yQAT0tRU9tUbvLpv87HSVxxN5qu59/bI*)
(*8IOO3LS0SSd8xVsdW/NYZHi7aYsm2KbI8mq5hxNfXgQAJe/FyVszm/vwYOO4*)
(*DusMeedPedGrsC3DILmWM7vHvp68tciw6ds9y498iK+mm+17tLK+DUeRId15*)
(*4lvTcRdu3lw6Xzvb+ViPDBtWxWiE5e6O/s1R5l+MDCf1logMAQDgVWj7l7p4*)
(*kPUPOB4Z5gHpq8bGRxp+1nez3+xn2LepjVNer+ijx3dFhnUk9wNy6zzsx7Iq*)
(*q7WgQ1vbXT/DrdZkPj5FdadPeTr9412/tRNfngUAPPfGMd1DZFgfHddxa3I/*)
(*hENNJ2cm95ShH91Brh4ezk7y+tbkaQcD3uuAbL+viL7NBrPzyJBXPh9EhrEp*)
(*D103Q4v3mZXt9NL52tnOx2pr8gfvLtidoN0d/eujzD8fGUqTPCFSRIYAAPAi*)
(*7EmnB7OpZSI284VglHxZE4kGHqyNmPx//0A3Vttn+85j63/lhrHJ0dNjkyke*)
(*UA094ppYJPU8/TO45kMVVqfZGZ6SDWkMdcO8WW6t73vGQ4J2XFtZtcOqadua*)
(*jZOVViLP4y/zNVBYOyOfdrsPYqvUYxllJUXiuen/t3NcQyDR/TJ33bC5y5Zk*)
(*aCWVTToxYZsF5Nj1jRHivE5vMgf4weHsZDuP4oTxr31tGxuU0fdNven+UBpr*)
(*9gWNf5KzkjU2yPJSJLFoM+nyUfaGlLJiTOKlS+drZztDBqpj5XM/b6dGDmt3*)
(*R0eZf3/6mtV+hmk/nIRlSt0PnB+qW4ezVi8SOf0kmX3SFJGhqqpmpZuVqAAA*)
(*8DtonP5hZXhx9yD7aOthNCWb64wNexQkWSL/iWTcZUkm3GBNf8FdQFElbj/V*)
(*hpxu9zLs45+dISrXDsTn03AoMXu0sThEUNksxEVEY7+Nfo/DwIHuEG8ksPlj*)
(*P1+KmvCZuWtH4Y2dLK7JvXGOn8FW/ef+l9uCD2FQ7LgdptAhiZdVRZr/SEn/*)
(*uHNcfZWgIEkCa8O9z5Z0PqEdsz7nZPft0GTlQw4mkznvHc5Otvej0buv0rW5*)
(*29hh7xfDKPjS5IcrOHFBqkdZrwbZqRcZ5fAquzpx2CdstDILvRQrpGFXwQIx*)
(*h5bCS+drZztDdEcrz8nUPqxedJh8aTdz9jN/efr+WIQ8981wWm77WLT7oqr3*)
(*kxn2RDf7Y8QTqfKT/tHefdKEfN5D/klsDnM17vQNBgCAX12TdI8H1bJ1ZT5v*)
(*702yI/68SrrHlXDf5MQrc/RpaNgk9w8+2Vp/+LIquMXieo+qnfnjkQw4raPF*)
(*Id0kY20JFKrNhzHAuvcv7Xk45sSxMduWwiLe1DemUxN3gcRObcvWl2s+t/OQ*)
(*X10UVLnj9HOSl/AZR0h4Vhwc1zgddPdhs5YtnSqeztIs8Pqre8UsxfOZbTaP*)
(*fSd5Q2Q4IShWPg1E2sJRZxuQdZdNLt6/SvRUNwmM6QeSFY/hTc/w0uM039nZ*)
(*TmKtHIQVzLpj7O1oN/Onp++f+rOj67I/G7dSu5Opvs0gi2n7siBrXvR//YO/*)
(*MfuZHSeLo7Gj5fFZSZ2MfSrVDLWGAAC/r7bIeATY1GWeZWmaZvlsQTL60BGG*)
(*yT0yR2eVJ7ziYm/08Q7WfjpbOO/V2rpu2rYp8+6wsrw4XGqlratqe/qWDU2V*)
(*52QHxZk2uCtfrru0DBOadEcxzjR3cFxtQ47jaPNtd7LJqS6e6GW2fjjbyRv6*)
(*GVYNKWrbJ6UriaQcdgWxvlY8yNqM3b4ruvk8X5mc79wp2NlO388wbpoyowex*)
(*vqW9He1l/rnTR5CNZBnLIpKhz5xKsuO6KPKAXJa7nUAAAOC312R8GTvLDwNX*)
(*nwxXaVl/QnN1GYldbPrllXU34Be2Njb5x1kbm/yrYDNv61uzmAIAAHCpN6xr*)
(*JrqzFtmCdgwTgytVf23us6Ug0J3p99LORov8UKn9a0aGZUx7bMrWG2vxAQDg*)
(*V9JUZD7DladGxbo8eRud1RbykAxJEDTvJ9cbwWVlnvoW7y4p6W5xsZn4W2jK*)
(*NPb5Msg3yY03Ru38TGXs2n76A88KAAB8R3lgm97OpNajLLCdcH2JXviFpZ4h*)
(*K6pGqaqsGMHPqzisU0Ppj0FTFVn18593EAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAA30Nblb2KGP4xflw3X53IfaWtypIke9nz6Wzz*)
(*JDAUUdT89gUJO2OZ+LpIXVMVRC19c66XkS11O9a9b3527zx/ups08jRJkK3k*)
(*6cRUoWNIoiCKoqToQVo9s622LgLHEG+Slw+H9sKy/Qlen9q1PHneCwvAd1Rn*)
(*oaFKAi2Vuh1Ue/eyVxbgQ02ZepYm3JS4fut+AOA5ZXA7In3z+2cdiTSdghE9*)
(*tZ0mVYZjFq333iIHs8Q37pgCKXrzzTM22J7Fd+/oxZ473W3ujVlsxs8lpTQl*)
(*koGmY8l8k4JfPPhKkTrjuTfjvvS9qmx/jlendj1PnvPSAvAdlZFJCqVq2npf*)
(*Kjffc19ZgI80nip82s0NAJ5RBDq5HSiGH6VFHrBLVzL8oiyyNDIV8oGXf1b9*)
(*2YNKp3v/F2T/sVqFJjENj96omrIsfF1kkeFn3bpmia+rKo8sdhJe/lqdunZU*)
(*jqeyih2yYyP4EbVRE8+dbnKWc4c+pJ4MDFjcovkF+UfhC88FMG1dFaknLjfy*)
(*5MF+shendiNPnvSyAvAdNQkNpnVaKFtfo6VSMFfvJa8twMdJ625usSO85+b2*)
(*JRZ3VIBfReur3V0k4IW7vznYfUNmFzR1d47i69L3CVK7e202h7thRd+4PzEy*)
(*vNMk8jtunm3aHacRfVJV6DeX2vLTgUFt0ZDF6s9TXSRh9GQXgNIU3/t0/oHe*)
(*kievKADfUR3T25c03L7qJAzTcrVUvqMAH3nTze1L4I4Kv6xCvQlhf5FmvO1G*)
(*zfrXoCrUBC38qsR9gjb3aN2BPdwP68RikeGXXfBNLL++waX1NfIYsJIfUfX0*)
(*dq8IDBrySvHiLK3ZNhEZTrwlT37VyLBN7dv8hrbtHQX4SPvLRIa4o8KvrKmG*)
(*S7SmN8uboE46pbR11Xz/2vImizxN0cKxYr9NfFtVZFlRLdezdc1NV+5EZeKK*)
(*vHON6gWh75OWAR4Z0ltrtxFN7Rj+smN2Q/6kEKpuhtnqM6t7Ww8Gnhew/jtl*)
(*Eno++cT3Q/rJXeJ5ZCgn7UceODQBmuXFkxsQ+4ke120WdIep6FZAUtCUoWvR*)
(*o1Y03fTjvP964Wr8QBXLCwM/TEvycZV5lqZZ0ewE17lvm5qm65qqmU4yayth*)
(*+1VI74IqcQxd7Y7e8neaU5qy20WXlC4lRfc/XVK7jYb54lxsZiZPoZ20TWbT*)
(*vQVZvXa6D1NO5LGnk9yRNcNiPbAOAoPtDVZZ3J1SVeyzlObp+hNi66Rs7PIu*)
(*CloeLM3S7uR3F2lXyB2dFA/dT8rFXjfL5156NsrVnbZMbEPtcrI7/Z5na7pX*)
(*z7ZwNbVtGrr01PAkNS2zlSe7B7jtqADsb3MvkRsF9XCbDxxFm8c+KZTd1adq*)
(*TpCOt7wy9f3As9ThhtbdYpL12sKtArxTAJ44kCbvrn2S74pmWdpKV5nde053*)
(*vDq75zS5S+8hmuGkdFBNU8Q2yYdun+5u/4WVx0FdJIHPb86+N2RUl7304+7u*)
(*TEvpelHfuKOSv5Dva+TqUlXTDYeMaKvuGHV6IXzkUVeQukKi2UHKfhR3f6OX*)
(*hhtNrseuLGmKrJrJj4+i4SerI3oDvunBT2o9zn2j79U8VOy3IR1boRiO5xib*)
(*nWd4u8aU3N2veGQoyJoiTP4kjAFQm9Nu2zdFN1SJ/1nzsuX228JWxeH3iuGy*)
(*yLCIXJn1/VGsf/4X94kfIsObLI8/p5twqvnx3sQhhUryh0jmO7Jtgx8Z60FU*)
(*xZZwE6YHI/39vzCkYSOTlvTEZgeraroq819YYbHIZ0lVp1tb7d/eltFw9JJm*)
(*avNDsaI+NtjKzDYfU3gTxl//J+NJm7bj7KSc7SZgm5M02zGHDe9Ehrsb5O9Q*)
(*U4Lqrjya6s2TsmEWBS3LdpcnY0ZIi/I5dgbeKZ/b6dksV/dHVQYkFYLieJ7B*)
(*coZWsD+Y2o+SZaakO1Fgz4qJwErmXWR48gKcOSoAB9vcTuRf+7M/Wy2ostvs*)
(*b/ORo6gcmo1CF6fo/TUoW+zG0hb+/CIjX3TXB4mvFOD/6L+YfLQoAE8cSFsE*)
(*7DPN6oK/MeOHyHDvnhOMJUo1x7NGv64HgTU7AGmr/8/646AIzMlvDV5z0JZu*)
(*f10YQb5V1FfuqFZME8x6IimG3o+cEvSsmdzKRNXSZ8ehuYGtTD+4WX055x0D*)
(*yI1/v1QAvFEVsstQDH9UQ1b38hv61iz8a2KJXJF9I3jh37abohpeQzjeVXhk*)
(*SC5qLczKMvWkybXfd+qW+hF8jcsfedJqf5OE34JJBeDA617rZaddTfzHGBmS*)
(*u5MTRIEz3EpULy/T8SfkV65N96/8o/+Z3l/6VqSAjaOR7KEyp285oh+0VRyF*)
(*PHAdjp2/Goh95NLywTh0CBJL6vDo6V53i6rw+F1ureG7zrtXaaO/1ZO7axA4*)
(*412R9VjYzsyyjMNwDK1l0zbIAf6Xxv+ykmO7Ke/+nbm0IkW2+Q8q/hK0GRke*)
(*bZB9yZpm6ZrM3T8pKzueRkHL4jE9a7R8BmlR9gM0RPO4fO6kZ6tc3UeGCTls*)
(*oa9L6nbHQ7iHUvuRe/zUsDwZnoakhIWsQmwRGV67APsTsV8ADra5l8h/8n/+*)
(*87WCKtv/YnebjxxFTAcQi3rAsz7vQ0HVGwrl/Q1t26wAbxeA/aTu/rXNaMbd*)
(*7P5SjUx2b+sjw90Lrc6TcHL305ywbOrY0foPbqodlHU1fOKujpTcfhy0mct+*)
(*qAeTSuzcHT7ZKupsu/bi8qdbFg3eab/buMCL+j9OonC89dHHSl3G48uyoAZp*)
(*WRUR/6Q/m02fvJ07DMC7Bdr4TvTTlOxVkD876pjdbRzeaNW6krB1cd33Kuw/*)
(*0YdqfXp/6B8i7C3yJodpmsRxkqRRf19a74rMEzN57yvZrWlIzzzxH2Nk6Azt*)
(*kxWv6umDCt51XLH5bEJtn8ibxp8arBvV5LhWmuRK9i7Qj7WJ6Ju1OJ1vZKhW*)
(*ZTerls/qo/t93lShOL3P3wnYD0R9qLoI+js/OSNHmdk/ghXelM7bF5c5dpDy*)
(*fjIiZ1J/wn6yFRkeZ8VGli4cnZR799tcHizvDDwpn+H0WHaz9LCQ3JertYOi*)
(*8Ynm8l/lzk0cerVdTO1H47C6uHFerJwld3KBzPPk6gX4Mc5GtVkADrZ5nMiV*)
(*grq/zQeOomIzAknh5FrrXzzHOtgr3aTvC9taAXjiQPikQ4o76Ycxu2OcuNB4*)
(*ADa2ZN3fhdpEum1fibuPg4BHY/pQj0+fg7yn/W5RX+YeL9h2mCYkJ9I0ZE9U*)
(*Fkzy/p+iMeyIXxrCeGmk7PKcnLu2LssK/RjhC/F73c+c+nV+kU6aiUXVjPK9*)
(*e+RwI13WGU5eutn9gT1EhuoCQRQ4UeqIorzRcNPHQgK/+cRkpKU+aVC8uz/3*)
(*/QynPQv5I4BvpF6+rn6QasA0SaumLdPQGGowxuNaCWPmx86/sAiWQj6Hz6xd*)
(*bxjMOAyW2YoMedZNC1XJx79rfn6YmUOfz/nmF8dykPJ/zSuB5/k5Oad3zmTF*)
(*epYuHZyUzV1PH9aLT+4rhS6Uz3OFZL+OIh1bIkXTjap2Gj9eS+3QrCmaQ2zA*)
(*wzDFTVe3uX+AdZElM2k99BzeLgBH5fA4kfcF9SCdDxxFvDaZFQ/MxnhyeUNr*)
(*6+W2io2Qe6MAPHEgf2CRzuzyn90xHrrnrHyyO3p9/3FQeOx2xCNPGkb2zUOX*)
(*inrFDvYmCLOMkERJI0sJ3D9W7j/5+mkxAOaazGEXgPPuhTfeYnmLK8JJHxJy*)
(*Q3DKrV9uRYbixpOX/vXSkMY2540CtIYhU0hL8rTfyFZkOHsE8Ccsb7ddj0nq*)
(*PGQdeQTVci1lfts5igzblLX7LA4t4TPgbuz3ZGQ422ahs8ppIzrMzPtzsXIs*)
(*Ryn/3/839tKjpu3yr+u7PpUVa7mxegh7J2Xl64eR4ZPl82ohWdHmw7TI7PJy*)
(*4uHyupbaj6Fa9abyS6J/jtvjjWgeGe4dYG3O+r+So+xOVu4fFIDDTDtM5NZt*)
(*ZGubDxxFye9p82utb18YotZFSsaG72FbYwXdcWF76kDanFWaqe7kdje9Yzx2*)
(*zzmX7Kndx0HL598WjJK0JKuk+Xj484Wizv4pRRvPzzMPmo3bHcCX6Vslxvlq*)
(*fpSVO0NbJtbY4bl7vfdWj+yxyPB20xZDTJsiyzfXoOLJI90EyVuhOI+jTkaG*)
(*rDFio08+WfiAJUx0E9qFhjdenK8zzIeAbZo4fpcWzfJ0Uu9/vhgBysqaEZaH*)
(*mXkqMjxK+T/tHzTTRO7WGZ7JirXcuHN0Uu69JjLcytIHCsmGNvGtaU/6fmjo*)
(*5cjwo05566NsxmnMuqEJ2nTFxpXIcOMA/+gbssiqaihBVJN6jDS2CsDxRX2U*)
(*yM3byMY2HziKwtfZuZv1A+8jQ6Mf0rVISZv7s22JguoMNXgXIsNHDuTf/HOe*)
(*79OrbHbHeOiecz0y/Nh9HAy9Dc0wJo3p8mIo2cmizv95N76syVLS0o/IEH6g*)
(*inUvETT/q1PymPlFWkdy3+RX52E/hG9tlOWkSv+un+FWax0fn6KOrV3kYzIh*)
(*+Hbfcd6jjxL6DuTrif9YD7dy1oW+72d4dyesWD3DcF9qLkeGffg6a+nu79Ky*)
(*05xO6sfdz+erK2ZDH63DzDwXGR6k/A/9XqY9uPqE7bUm72bFB8nzgxmYD0/K*)
(*5q6PW5MfKZ9/9UAhudcFRn1O1iGbI4UMuEgfSC0T0G0oiiwKoiTPZmK53+YD*)
(*F2B9VADObHM/kStP+d1tPnAUfavBPPYYay/5nq+0SN4X4LW7xOMH8q95RDWZ*)
(*/WA+0/VD95yrkeHx44D3DWCmG7lS1Ot+eN6saprW2eoVIkP4ifquX0a41ej6*)
(*zVWzUaJNLE7HqdW8z/PqxNHDxdiQRgc3zPueM5MuQ3xSXBbetOPayqodVk3b*)
(*1myIrrQ74ykfo3ebd4NfSfzHZKbr8Yv85bq/C90Ni+uXwZJ51/HKZ3MvSHZZ*)
(*xq6fTe5jDQkz3bAZWpr6I+UDMEnX7uE+zXtY9Q8j3jw0SWp/n984dn6Tn46d*)
(*ZNHITSPn5ygzm/Vpe5c5dpDyMuhb59Qh4SGdSELQFlH6x6kN9qeJPda2e+Ud*)
(*npR7vMfUZJvLgy1Y2+gj5fMwPfflakXSJVH2hn9GxmR81tXU9l9QnHi7sWKe*)
(*Jw9cgIcF4Gibh4lcKaj723zkNsK7gg89lj+GpoTJJ/yK2xv/Pvz4vgCvFYAn*)
(*DmQYbjZWVBZs0WrBp4+aExfafZLuP9ntH3vicdDflG7LGHWvqC/vqP/3sMa3*)
(*oIZZ1X60RexJfVEfSki92On0k2T2SVNEBp3LNt1sjQJ4m7Z0+77ospMef//7*)
(*aXLei1ix6a2bRVbd5UlnVC5YC9pY1TMz9MORZHKdu/kf+2kTuocIux5rNofY*)
(*TTTY3SX3xmkTBoc9D7fGpS4TT3bIBiHeBNmI86qpczZ/hNgvYtgUIZ8KxwwX*)
(*A+XIh+owqVj/CenW2L/SCpIksMaUxufj8pSY33nKfsowwYkLkg4205bs8Jap*)
(*fvFEpb/P14nD+2/76xM49w15N4MGQm0Zs3f24R1kNzObkM9xIQeTybFXcuwo*)
(*5dE4oZhkuZ41m11RsFceKAcb/CDzsPFjVzcDhsOTsjTmcH9odwfb9mdNTfhZ*)
(*q06Xz4P0rJWrzXOqWHSMbFuwM8z6Jz+Q2tgQb3cEQVRNv9rIkwcuwMMCsL/N*)
(*o0SuF9T9bT5wFGXUD/dQnaIh9wEWi9jjNP599gpqfBRO3BfgrQLw+IHwkcj0*)
(*E83yXGuW73IXAh3dc8p+Bs4+kZNP+F1omDKxKyErx3nqccDD0b4+kNsp6it3*)
(*1DZbyQgegrYRvxMO5+X+kybkpZR/EpvDhLDrDy+AN0kXk2zSy+tnLcw1ed1j*)
(*V5Xb9JHV5Oo01pZAoSbz8erev7Tnz0snXjwTFHZXSH1j2km8u3Ucv9RVIZkN*)
(*Yd4LZSXxNE1ZYMvTHdwEw+vrWCazv1Ia6xra3efHm7DuZzHfsmzyeHKciLjL*)
(*jaaeNqB0+MDqtnDU2QHLustm+G77h/6Q1GSektWW2WTegZsdixXMwsiNzCxm*)
(*n5K5c/PtHNtLOcvpwJwUdVHm4wgl1Qn6N4BlwdjZYBsai8BqfY7iw5MyVSfz*)
(*Q5Odcnmwzv86n2L8rnzKrFl/q3zupOf/2ShX98YHVs/w0rVTcyq1bTb/1YTU*)
(*RWx3eVLvlZkdxwVgZ5u7iQxWC+rHiXQ+cBspI2eWhYI8jIlYXqE3Os3y+hZX*)
(*CvDf+jv/9fyDWQF4+ECaPJg+Y2SFZ7xqOAkbJb19oS3PfhcLzseSkE8W5fa+*)
(*svTc44DOIbOcy3erqDPzOyrbV2pMb9xdOFqMY9sHdpwsNmxHy11ZXdkfuzf+*)
(*0P7/AN9KW9dN2zZlnmdZlhfH3enrqqqvvpU1VZ6THRSnq/q79FzqQFKVRUYP*)
(*YD10udcdd93U/ZE0VVnOj6ptyIEebqYu8zRNux2XZ3e8aejN1TRlRg9mPbeu*)
(*Z+aq/ZQ3VZF1f83Jzbqt8mx3OqMzGzzl6KS8y1aWPp2erhSRq6sq6dWVPzfd*)
(*GluaRInKpiubZVl0ukQnkU8bJHebRK+XmeMCsL7NJxJ5mM4HSn5b5xktlMXO*)
(*upRv8PiBNN2NLCV/ouupZNl9mXnhPefOmccBnYdTXY5SPCzqq3fUqisdBcmJ*)
(*Z4+krbuCFpCQ0fih3bwAAO7tDgGG3x0fmSWv9PZ0u4KjR/eff74fkUh4DJuh*)
(*kA3b+Y5LjbAW6mEBFwCAn48PN0BkCGv6JjRBs7w0L+uGVMrlaWiSznKCn3+L*)
(*3lU/IpFwWZvzxSFl2gD8/Rb/KmPaEbRfFxsA4MdryjT2+RqqN8mNi+OfwG+m*)
(*7Yc83JH97LtU4PyIRMJls/6Hor+65vKXKmPX9tNvlywAgIfVqaEoqsaoiqyi*)
(*dgXW1GnomXpXRAhVM9zwG67D9CMSCZe0iWd2Z1MzHEwLAwAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjyptVZYk2cuapzfV5klg*)
(*KKKo+e0LEnavSSNPkwTZSp7cUBnZUnfMuvf8Mf98L8vVl2qL95alLS+8HH5r*)
(*ReSFef3VqXiHK9dLW7q6rPv5+1P1Y3R5p7nx517UAHBRHYk3QjCip7bTpMqt*)
(*J1rVi1I3aHNv2Lxkxk9uLTbYQYvRL/nsOu21ufoyby5Le151Ofzucq3LRNn9*)
(*xQKAa9dLFZNiLGhxibeMUZN5AikbZv6LFQ6AX0rpdC/AguznD92+msQ0PBpe*)
(*NWVZ+LrInuZvCLi67eeOKrwkhqlihxyzEfz2t+xX5urrtFX11rI0Sl07KqeP*)
(*qOcuhy80Xolfr4pMFtb75Vcn5cVOXy9NqpKwUEd14b22CESWOQgOAX5FqS3d*)
(*buZQq8OfCG97mqe2/M1imF/B98zVKjLeHhm2aVd8jehTayXfZHElfqmaFqhv*)
(*VhH9Oieul9ohXxGDXy0wfpkyNGh9avDVCQGAF2tz2i4g2UP1Sp1Yb20B/J4x*)
(*zE/3PXN1KEtviwxbXyNVF1by06oH79xfiV+IJ4ZT01+uXujweil8jYY9/mem*)
(*6qepTNom4KBDL/y6qiJPkzSvuptgU+R59ZMKe5NFnqZo4dim1ia+rSqyrKiW*)
(*69m65qYrD+cycVmPrJugekHo+6RRjj/N6ROq24imdgw/XcSJDfmTQqi6GWYH*)
(*UWQeezpJjawZli7fV0TsbG3zQJoq8yxNs6LpU6utUtfUux0pimY6QV43LTXJ*)
(*JcXL248qcYwuRapu+eXBU69NQ5cmXtF0049zvsV2kgY7aZvMptsLMpa8No99*)
(*U9P0bi+q5gTDo7VJAt8POn6UksqItkw8j30QJH1fpqYkm1V0vyWH7+jkFOh+*)
(*sqy8OMrVuaYMXYseBz+Q5RfIsehK92dV7bKumJX/tss6si96goKkWGx66/Rt*)
(*RIZb32cnSI/rNgu6k67oVsD+VqaBpavktKrdafX5qIimcDVefhXLCwM/TMvJ*)
(*dqaXw84ZuZDhS3Xu22STukaSlcx2d62w3V2J//if/pOg1xWYPvCtM1Z8fJ8c*)
(*HE12dy67U1l0/9PlWJeOuzEj1y5VJtS7wFCxbY0lSguK499QJy7AlfP7/a6X*)
(*0qCR8WZddFvlaYc0pTbdk6M4/xrdNsf2bklFl1GGYXnxeIG2VRJ1ZSYsTgTw*)
(*r33MZS7tTay4/ZnIuqImq2byTbpEADyjSk158opMyU761ck6JfeNIc39fawN*)
(*6egMxXA8h93hbmZ8d+9qEvm2POi47p/mgqwp0zwRxqdam5sSvR/ohirxP2te*)
(*tpHANjDolyTNdsz+65N78t7WNg6kzY1hQ+KkHTy22badMLRVcXpg2t/7s+H/*)
(*JVWdney9kbMla1OTdCcK7NkW/9qf/dmQhpsw/knubpKVQ7NOkFVd7/clW+S+*)
(*3RauwUdmsPERbRGZmtx/EpNDG7clLU6BN/bpOcrVhTpi+1AM2zbk/rjHx30Z*)
(*2XRPomGZ/T5JYeCZQD8S1e6BqvRHc+b0rUWGG9+fFuObOBy10oVEsUUTLCi2*)
(*a///7L1Ni8XMd+B3v0I+RLb6DNFmCHghvAoBkU1AiwQbLbLRKqCdVkYYxmIw*)
(*aDEIDHImiEzQTILGscZ2xN8WiZUYjYMmKAZ5oT/IoGehRS06qle9lV5u39vd*)
(*t/s5v1W3rlSqOnXq1KmqUyWeN7vB1e0pN2UuIM3LZc0Bq8Z+jVwU+JquoMqm*)
(*mNbos7KnvBSLdJ6HS8omaYm/+9/9zvSPEzN5tnnIXvWf/7f/9X8mMu1aC9W8*)
(*eRl3iu5rqkJbcg1HkI36WbH6vraCcLEBrur3sHa+pr0MZUB/l+5uKyN33Vvc*)
(*jIvTqn3urB/dsj/HThdw6U08b0PIJGSfuO8f0M1xQalpR0vnMnEEZzoGAC9O*)
(*mxJDoYYFVu7cZfsaw28SWdtVeRp7C/dvoIY9ZXc08U3qGRIGNkM42SLWm2MZ*)
(*WGnVtmVEDanGnAEUW+PbtJgNUEe7pDArKntDFZrEAPnsxy7TFjb5MLW9gqAu*)
(*z3jXM+W8Im+6eWy82nmsA1D8KP6L3/xmlJLoQyw/abomsrUD+z9SRyzz9Hdh*)
(*9/Dzf/aXv5l3f7rrky5M9wvqyag2C79BdcxuMiNayILkbN4rRSIefl40UgVJ*)
(*2YxVwLZh80fOpLqtBdJ58JXKhG4M0Xzu+sVE6CabmWoibt5xr5HgChr/LuZZ*)
(*5V3hiTJsPMPd++NsUmNcy8wJNIpf2B5ntl7cJlQUPqvlwdfmlS5rDm9vRzVy*)
(*TeBreipwlTvXiO21ud1Gb4Tm4V5l27RELhzFnk9+RVgcdtvXaRI7oqNXjCBJ*)
(*Alu4PGZ1oXb2oNpC3aqcu1EXVgyPGuD/9pe/kdfvcFg75Mrnt5eCDkYk/jBK*)
(*iUAUK8Q/8V3wIqunoL7Os/yILCcTelJqE1e1bWPZaXTgVoW/T3LwX/z7f+y7*)
(*rt/Nxp3d3JhW10/szmLyQY2TYiUdqvC20AEA+KbUdL3E450IH5Sdjb9eC7b2*)
(*wbpCMuQfjUDA1lNQqCl7TXUbVcivTDvyFpaZdc16WpZFnhdFmQVsyUmy8sKP*)
(*Lpl3KxkZ5F9K7bAgrKa418FHr7pYZakja9HVIpaZ6WiyLqUeUi6XzRDQCcPp*)
(*0DOmLS5/gPuKBnspQmOnQ9NMZ2kWLJqfTWLQfmfeKxXLqKcqMFZVkM6FdirV*)
(*DbQGbzxWnAZZ8UpHMelnzYi/DVW0mNaYXRZvZomcMKneLOx7nCnD2jM8ub+n*)
(*7pThM4FjYQ1UB25shyxiPRH3+nrqGS4HPsvmcKFGTgS+gUpbnZ+KI+b9qJNw*)
(*t7LJ4nuZxz6b3SVXjJBNyCT0HaotFCHhDipuJnc11YnGxnXAD6vhrvjpRoPz*)
(*Biit31dsL4gPndZzd3VMS8Q9zFHT1GUFfSRD4eJBwfhX6eE5w0FoyH9Cq1U1*)
(*3Fwer3BvNzdkgZiLVei8vGo4koikIadVJSSJ+rb9VpFYALAlZwPAKcyY9qGq*)
(*mKf6Hiz7x9nilGq6WX00QbBd7+s3s4hzyyzmzRRVYajaiKrq4WZWgU8/6rOY*)
(*mHtSOyzIKucDW92b5mSGkl4R8fNMSp7om5lZ2+us2fZM1RUOAPMVjbBcysqf*)
(*pJfTIi/T5N0r7ZElPd3yynYidyG0M6lKQF1ZlN2A2jJ1xAQLE12/mnajWej7*)
(*4U2mDOw3RAt7ogyrOjq7X5qTNxzRVXdoaNOptzr2DBcXr9TIscA3sPRXv6bs*)
(*iB4a3nCvskljMumkH542pD14jq3TlALL5Py45smZrO9qqgJ6NIHmZ23T1HXd*)
(*tgXzJvdnO1n5rjfAWf2+ZHvp2ITvalWXzTQqkxvIhi137F8emsz3PP8IzwvS*)
(*nepBPZkUJDVrjyNnOuCzk/9IBGvuna7zvm6OjB81KrQ6camh22SM5eHV9r4B*)
(*wPthS0LztZWWzrIvxtR4FNT2Lz0MWvePTcrXPamFM4M907XrGapHZvaiHWBD*)
(*7OXexrtSOyjIOp98cknMqLCZBy3gVbfxIs46azbVdjNZitxT9Uu+IWAjq5Zl*)
(*eJkmH1lTJ/O0pzuuglOpSunr1KIdm+mFnjH1pINYrpVIoQxmd27TPKu+tWd4*)
(*cr/UzcPXU7YVQnFDFlR13TO8UiPHAl+DSrpsuvqVLUEy1+huZZPu1hHHMtt4*)
(*rwZZTLSnuTtZJhubBYxmdzVVIZdgE/IoMI5j0t7RAF+0vbB8ruqC+lfaNE58*)
(*62jm1cVBQ6jv2nZ3Pbgn/rOyDxagd3JCO7ZLo+9OpmRJfkiG96ITr3Vz22wX*)
(*82EIIpUrWV6Xj5IA4PvCoshmEz58jl3E3uOx0thWdQObER3vzXRecoO+xOSi*)
(*tvCsaY/EzZBHwrzPM5wvL1KGptqGx4i+cm72701tryDbfJYh9x/iPI9pj6PM*)
(*PpF2d2f91pdswkR38zJ36U4Ia/oe3zYPTWzTTiWd21De0zlka8B2queunu5U*)
(*qlvajMqZRRkhOpnD0mcrYutYdNSmSfGPrEUY5VLt2yItWnRafVLPcP9++dIw*)
(*i/mikV08sPC6Z3ilRu7zDN9q4X3Nr/LgNLeVZuxdniGOoKCu8KguxA+ZL4nK*)
(*MjlQd8xJ27uaKnsZcUSNoECzHbSoZ57waYzN3Q3wRdsLmwdb7pxaRVG+iaAF*)
(*TezGeutwNKmiGTj+UzPH/sL6kHPLM0cb+ySNNNpp2n/HM7zQzcmzzTxDHnus*)
(*SJTzDTxD4OeRrwKbh5ytVekBd0pKHQ+BsWWlMTNmmL+iY7gyuX2m82FsX6d8*)
(*s58hPfJNLBdu4gz3VpPZ/hQznDsS/dgNWJvgJXHzfHDK7fyF1A4LIulJ25hU*)
(*n6FrqqpqlhOUix7wfs/w7S0hZtUwdFVRNX192sk2DwPfv7MIPZomG/s3MRWp*)
(*i7mUt1K6OnZWBXtS3dDRvZQiS8PCM+z5ZonFpEodGTfV/+1UQfPNhrVBJk5P*)
(*lWGzmnx8v8RzYEuiivBJhGfIkjz1DK/UyLHAN/A5paWnxDwQVq3v9Qy19bTM*)
(*UNH4vdv2V8lq8lslQmHvaqoUEp4nyWHps+2v7vHelXsb4Iu2F76IP58qZzHP*)
(*k3ByvkHZr/hiOY4DVMiMMdVSJS7PzsR6D73PQz/F2sWBZ3jaze1lm4hd8eI0*)
(*8ulISI+qzRt4TYFnCPwYFsZ/qEQMkx0Xsa3jsWGPG5FJzvKinemrbrli2wBZ*)
(*9kjbnzad9Sz0XRomJPruAS/dhmk9sL54NsZkp8LSDghN38M1/bQbEOrpvktN*)
(*4nm2Cd+NaArJpQ4NeknOUzssyCafNMrazPd39lF7P1UiM2vanrtPT7s1gt1v*)
(*xzMXaxF+w4K9Z84MD8HiV9gSLf+357u/xRxUwwPd5VVwKtU1rKfTWeR/F9OD*)
(*azS/bfMwrvikCp4aJbYfVQnWCjttRymL1UU3wc4h6ipyu0NOlztRBvYNFFGQ*)
(*k/vXG43fpiOX2XCgKyOaH69oiigcnVPubIw/12FIA7SWzeFCjZwIfAObh8G2*)
(*QiTJolK5h3O3sm1b4irl22anA6u42cZYHtpn4UZzV1PF78GbQVTpx6bZiuRC*)
(*RFupnDVASf2+ZHvh9as6UxAOd+wzIrpKHEykOsWok7q/mmQrx79JVX4ANVWH*)
(*ZDq+cOEZtmUajq2a18JpN7eXbeoZOj5deV5O6k5i4XuTyezu0GSOaZqWV+7q*)
(*AAC8OvxABsW0yXlgmqFNp6MZ2IbQgCITrx4SW6G+5ozhwD9YYPg53c6pk2LR*)
(*M28bupI4G3HPEWHqmo6lEda/8PM3RivKxpT0tLHRBlIfje9OXbC/i3M6PMwL*)
(*I29x8priF/1RakcFGWKWlMF6InGCxBwcdG/SY7pRw4LzxQEsfREozEjKY7dz*)
(*R56k6cZ0ZTOlC8w3PZkdL9xmPPLfDJphtJYp7aB9cUY3675vijaq3iquSw2r*)
(*X3jRzIIZ2G5VBadSXVUyn+O66aY41o5fCSoRarhk2S+vfuNHHx8qw6aODu8f*)
(*BcWk6U4R+GJOCZ92Z6zybpSIT3gqmqawSIN1czivEXQq8A0tP81FCfIGKx+d*)
(*VWOre+9Rtk1LnF7cs80d62l/4dLTAw9Rm9N5dXqEyFntLBkaeo6MGRSSEvel*)
(*xU2j4WdyK3jWAKX1+/aK7YUvns63lrA5Q3zOq00P3JlpI43ApPkkTYPsYdHD*)
(*D+kuyKFSbjaPHJ95hogdQalwt/m0m9vLNvUYC2yGSQUZkuLwgRvb3cMPw5kH*)
(*lwLAN2Oopi9A6W6C6HENpA2JZlcHeNxkGLqmW8m1zwd8MsJsMsxw2JpoTXbg*)
(*AGV2VKwd/a2/7HuDfOUcsXizMnbmR6YaXro/RBwSd+ZaqDqzU5oZJMz33E1t*)
(*tyD9Kk6e7LUcgpXjMKH/H38//9oXllKRLI6cla4roWop2/n9frLINDnjRTzY*)
(*ZsEi54oe5AtLHs7OP3aTiq74jJ1OlP2ff/L7i3Q3VUCjg86lOqcrpvxodlyx*)
(*E4mp2tM78nlvqbDJQ0YRzh0MxY0Xx9juVN+w8ihF/yu9v0lWJwBbfI2uC6ec*)
(*aVFR8WR1+pmW6VjpUTcGWXM4qZEhMq8IfKscTbA8zFm3Q7p2uPy03FVlW7bE*)
(*5UHBZPZP2czmTZO9s4J5ycLzvNRU+eYRaZG5XzpDvnB51ACTeK9+j2uHZeGT*)
(*24uYp7VnrmE06aGRNKhNWKMwfVGbeKV+THzsLgw7qD/ENyKbR/RwmeX5nKGI*)
(*fmRDkgvdnDzb8x0odIrV3JyRTudmxa5nvmXvxk/UBIDvydDWVd1y04C/c1TP*)
(*IkPIVLnmRHmBTwOrqnr/INGXAuFjRdBYtroaM33+5SaEz0i9144NXV3jFzQX*)
(*Fg5GwVZlOWZlIN+VqrYH6chTu6MgqEk0/OWEbEBD17YNpq5K/GWw28wtuQf6*)
(*3QQja4ehZ0mOGSmymKzIHSyrsbzXuMxjtuWxRqPmjb9S3cNq2Nydw3OpLvMz*)
(*CrPn1YxltK5y1NY0PWnYQVvh/O7sXbhHGd5xf9/Nsj7qw/LENDRg/T1P5axG*)
(*3kHf4o+kVTMb8hjyltiRLQPbD7KIYLlhGGunelrtvItHG+CLtRc2xFgutYyG*)
(*aJY9/HW5+XZeEg+gBgk+ybrAL7p8ls1lMjIBuAz6fePL9HyrEa7udqFEh93c*)
(*XrapmxexxYGGOpz+wmOne5yVSKxro36s9ARfdZ5feAB4FZr1YozifKsTsH89*)
(*sHMY0m13UYdjtcmDZI5TpDv4dEkkUjh2yPbJyRIA8Cjsc8Md1m3ZSOT0qKJP*)
(*5PkN8KtB9Os/J5tu5vCPBwl2dri8Ez4frsRzrwvVnogQUc1L305eIcn2XyUe*)
(*n6VV9JB+aIB4/je6oEBeQi3k+iwjek7+NzsQGADuoC8DRbHHkTqinwhqc300*)
(*ca+5B+VXDl93VnQ7ysq264dh6No6DckGwqMvI+8iPiBleVE5DrgHPHNYlyn5*)
(*rrASf8xaEQBQanqci6LpGvFPZF+3LP2X8Qw/oAG+AA2ZolOTa+5W5mq6l4vu*)
(*oil8RXGf113wrw2erlbcyfuyjeqYfjlpMaeak2Ba+s1rAPihZHgC3YyLGtu5*)
(*0S+M7NWhpsDLgPhmkDW6G7/PkCIeML9NMt6e3gAAT2UK5sffqth4VkNb5jH7*)
(*DPJNC/MvX8p4fgN8DToa4ig5sGUFOUhBtYKibvEgsq0CU1mfEfoI3Pf2ZGOE*)
(*9/OubNepR8bM69Ma2zz04xK8QuBn01exMQtmVk0fJopemb4pI9+1TNPAmI4X*)
(*Fs2DFdaXaeTaFkvRcsK0BBUAPgHUFa6Jdc5PZF1tXzr4R4pp6OYrTGJ/QAN8*)
(*CerEdzebLzagIlxs9rHD3dOu3gOqXUMf03xikjTdd2S7Svwg3fsWHwD8KsDh*)
(*7TgsHEZCAAAAwAGIdhffrbf4ptkGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgO8F6lpOhxH/*)
(*TJf74aszeUzrm7qm6VH1eD5RXSSOoapWjJ6QMZxg8+QEPwTUN0ngqDctqoUM*)
(*nyLVJ1aNhL5KHVNTFFVVNdtPukMRo77elPEFeVxiQ5lFlqboXvFwZro0cDSV*)
(*yNewk7I7vvubSBh4Li9q4mQ27RP4WItH6Ms0NFXFDMsPe8V9QMP/gbTJ7Qzt*)
(*CV3MR9JnKsmn4mQPpTOUhiiz6p30gl+S4MdQBlM23Zxn8ylSfVbVyGgzF8vV*)
(*dH1bZ7nf75vkZXxBHpMYqqOp2br5Y1lpXQ0L2A08Ll8lbnY7/28jYeCJvKqJ*)
(*+zJt/EiLNzJU4fMa+HOAhv8jaRIbq7HhxFnZ1IlCVc6Jm7apysw18IWofqmx*)
(*4JY2sDRF0eP3DViGwnWinvzVtk1sq9TK9U/IGOq65yb4IaC+a8pIXTftx6R6*)
(*kMgk8AcYCmKP7Ab/g2KLaK7irpItQz9rsfYOnbSML8iDYh91uA5M5fGOgxp8*)
(*KyYCbmJlR3TfUMLXeIqWfmiCT0LU4Lt4URO3Y9M+gHW1PsVs7oP6tq184wkN*)
(*/Fn8tIYPYFBsjr1rwuwCt/9+ybR61Pqxc2i+Ln+fQOlro0YLhe7ITNQTrVyX*)
(*Oa9mNmW0rvpJTXsl8PfR56SaNCHVvkjTsl1aY1SOb3KyqW4/rYxfS+nrD3cc*)
(*vUdk5eVMwH1TpFm57u1+roSfoqUfmuBzWNfge3hVE/cZNu1LqvUZDfy5/JyG*)
(*DxAa86akvD1XbFrYrPgIskstxUq/KnOfAKojMvryRZfXF95zV0ZEgi9mNlf0*)
(*2MJ9fNPeCvyd6ZT+7SQdFFvYWnnFVLefU8Yv5xkdx0BlNZPelh8r4Wdp6ccl*)
(*+CS2NfgeXtXEfbg2flW1Ft6reYY/pOEDgqETrbkn/clNMWfBWqjvhhdfSn7D*)
(*wRdZZBlWOq2JoCL2TUPXDdMLI9+2wlJitNoipHPgY5mjJI1jvKjCrBxp7GMi*)
(*ljnixOvY+wH/ZGBM202ro+YgN5t9HfuuZdm2ZVpuUPCcD02RxAkljsYCoToT*)
(*F5IoSkmcF6roxTgu+CzZ0Ba+Y40FNkzTDVORoaGrIs+y/AINlW+bY3aTSmq/*)
(*t017LVXUjXm2DRurR52FtjmmZvkJjYIe8vE3LCs7zOq9qpEKfEdqcvngbLRl*)
(*HCeRZ4p05nLgr21Ci73K8KLxjrRsRRm9cnjrsLiwOPy4Xb55T5JbhnaUre3G*)
(*Y3mb8Q9zfMJy03ol3j1VoZKx8x5Vyairhu0lnUzstNB1HmNxOKOMrSApt2Kr*)
(*88jGGq9bjkfjLk86jn0Jd1U+6pqpcukR8a37vk+RMM3NKFuD3hwkzSof+6Xg*)
(*kjRwMExXBA7Rfi+e34JwTsxRaOMPUeRbNl4W3NPStkzGStaxURlfFc/rmWiC*)
(*RZrGaHkC2hBGpaS/XlR7aWbeHlWzfRnKa3BPLY+Kf8UzPHicln58L1Zgkv+k*)
(*WK5THerAvjrJ3ZW7TeXQpqFHehPDGushZ/Ztp1ql7fdRRV3BPEO/HB8NSCuz*)
(*bD+fyWWvLO/W4bNqOm/4VeKNInSiV9k1A1ylz0jd3uzkO60e17Fz4/A1EZQ6*)
(*uMkaThAFzl581GhK9dsKPe+5lVN0y1BmPylTQ0U1icy/GbZjauxnK6r2crg1*)
(*m2PTYQbFGlspe4uXYrE3qSteqVlBM7ShPWXTsAPsGaImsOiLVRrNUid0Bdxw*)
(*bB4MrNjVUDuaeFRRp1KGshHuwoqupYpmSammZ0/p4rKHiW/ML9w8aSI7At9y*)
(*IB8s/iZW1+ko4XInYJd7yk2Z15/m5aKMumUtqtZKJnWSSnJjolGbmTwTmuVa*)
(*ywx5GbeIO6oyl8xNFXkx/m20VWZcmoCoojK6DLbJ7ta92V4QlNDq0Sw/cEXd*)
(*HHiGhxJmI8SFfM21zny0hClt5pN0VMdzeXOcdOagFHMJa6Y5z8y0TalNcL0p*)
(*RhBFDn1c9bodLc3pLhzF8EOf54TEuI5NY6p9bWU0cF9/Ue1lmWkfU7NjGW5r*)
(*8J/93u9P/8zUshj2i0815swzPH4c7+clV1VzHNUwrdC9/IoOHKqTxDO821T2*)
(*Ga0+w/F9h9UkDr6VVeu//lfS9vuwom6gnuFN1ReG+Hbzi6WtXpblr96tw+fV*)
(*dNrwh5A9YUiGtcAL06VURdXFoKvr+jnDiy2GkPmNNPYW7t+Qa7i580XwJr7t*)
(*z3IPbIZwsmnMyhG1Tqu2LSPazjTWBOhmB41v0hwVnu3a2QvVWZtN5oGrMfd0*)
(*WPw23+mDqoD+G/ImyeyAYoshGL0noO4QKaDqsGBRVIU0Q+ofxHma+qJr0V3f*)
(*wY1T96U7zRdWdCPVvsjSQDiERDJ9m09dlWImZds1GbtiRkhaNTKBbzJyIp+r*)
(*6UzrobNZcdFvBmnbtTErkcY6mj1Juptthn2dJrHDjTzu0JNkkg+Lx9hVlTib*)
(*JIOFwwy18Rd/J5EY7VVVm9lYVHPHmAh5pArJ9Knuswc6NsTb9QwvSbj31tL7*)
(*XAmPtDTs2WRLnQ3bdm0E5WkpqO4J9bT8pOmaiGcmI5kpcAkVNiOGKwvvYKL/*)
(*rbULsR24bNWVenG4I+7fUJdns1Y29oVl0/KAfJVXwam6yjPzmJphi3Qsw2UN*)
(*tqVcLYtf9otPa/3YMzyQHiEh3oQRMLsUMf+IuBDH+T9Rp41neL+prKhDw9eL*)
(*E6pjmt/LqlVq8R5XVJm2cLdUd5Ism6tEPbTysvxx9KAOH1XTacMXmwS56IDv*)
(*Aq33ZXzdkAV8MKGoOhugKHaYv5jX39KZQdYY+5y2xIDNhKNQU/Y6uG1UIb9i*)
(*izVRYrR5P8salJ6WZZHnRVFmgUUltBfFvTKbGZGoOj/TQAw/WV/POuVpwFUz*)
(*X9Hlk6J435DKmhidINX8tCxwjsoyZcM20s2xnRo3I6emDe0u327G10upitA+*)
(*1RGDfRaYqkyyKmnWJ3muEzkN47wgn0vpyErErtgxz+9AVYVZ4GNJbkmoqVVt*)
(*MWGZcJuP9e1EVdgWD4M76rxoS4l19BAMLZ3pb8Em9eiUFOt2g9msKZXhnmd4*)
(*TcJXAoc+VMKjkiskRzwpVFHxWeTKeSm4QzJlpkupMHPmGRKX2wrZq8dWpjIH*)
(*YK1drBQ3tjyG2ItEwVlDmBmNdFkFp+p6kJkH1Kw9lqG0BiVqeVb8E8/w8HEW*)
(*qnezhOjqiOWxQic6cKZO69K9w1RS43/jpphG8Ip6lFXr2uI9rqhbmGdoBKLN*)
(*Z9xXpD2dpCyP6fBhNb2dNnx6qW3bbxCbBiyoaTVvT8clbUFjCvbW03UrK643*)
(*KXwhSwswm+dXTTer7wsC7Dej+3m4L29xo6esMFRtRFX1cOdo0+UrWFZXvXbK*)
(*jn1g/WMT09ow+PDOZuUxQtIKcaOz2KJ/5zGHXVlkSFM1Kxqm4pyO1HZ7+bX9*)
(*386vzq5sdnbvJLK78HRJPhfSOSqR2G87mi99ssAnktzCFGPeZNgUB24gZ6rS*)
(*bybcJNnuczqDvewj+Hh/9DD5FLeez7J4GKB+UcIPeYbPkLBUPkPPTt2/Uorj*)
(*zPBenj4QZt1s0CSJAKnLsu7Q0KbBtPJ2MBO+qoJTdT3IzANq9ttDGb4d1eBS*)
(*LY+Lf1q6g8e3NoRlceZv7OT/VJ1WpXuXqURdWZTdgNoydcSsGi+prOCrlz5B*)
(*UbdIVIL3ejQYTFqWR3T4sJreUwTgWzDwFcxgE2lOBk0zz7/DZx7KV3++jLV9*)
(*m0fr4fZnBu3ek3ueoXrUQO7aFLZIEJVk5W+dAl8d4HJmzWps5q04EIAWJe3H*)
(*bmFMQ+e7CWnZtWxnnf/ytsHLnuGhrDZX7vQML8rnMc9wurIwXyeS3CJzwBqb*)
(*BUVlZ6qy53otrrdMk5cGlqvH2AxrNogw59E7R57hVQk/5Bk+QcKDWIKU1fCl*)
(*UhxnBs+DiEU5Ks4gZ3ZC2uOnPhW14oYsZupAq+/1DA8y8341O5bhm0xE+2p5*)
(*V/G3L9p7nJ2TLF1nP8n/qTpJnbS7TWVfpzSsWzG90Fvk9twzfIqibpCpBEuE*)
(*Tk7ulOX9OnxUTdtSXygC8C3g61PmNhSceoYFv15F9u32al9FkVgz1BaeNYvP*)
(*NSLpNPb7PMP5pDplaKp659tsywRrYdLn9/CIYld4sGxx34gavIarJHVJ5w3N*)
(*IMF1JaIoedmteLVvaKhKHDT2zTzDy/L5MM9wV5JbZPZ5oC3JSdszVbnkGTYx*)
(*rfZF9K/wDJ2sFV3M3AIfzhlelPDHeYYXJdzSeQ09WG5mRG2ajNboSimu9Fao*)
(*iL2ZmbiFZEvXRrtaljBb7R1Otfpuz3A/Mw+o2T8eylAmInm93138JUePtyy+*)
(*3VjNSbRFWrTH+T9VJ/n03V2mss2oeNWwIGvfLKLm+pzhsxT1bfu41DOkEUey*)
(*jD2kw4fVJLNm4Bn+BDoaW6JY8fY3ph66aVmmzjasvdrZ10u17DOdL4qNwz2+*)
(*3cuQHtklJskPlimXq8lsf8rym5U9PhD8UpyhiNSdb83jhkKf4kYGtp2N5j0a*)
(*r+TTrtPbbOW65+HLi1kjssZkdy/rGWp7AVdX5XPhQPK7/ZZjSW6RrOm8sTgo*)
(*N+/PVOWSZzjw/VCL7oyvHPnl9JZ5mCvP2NFq8pmErxxd+6ESlt9cRwYJwLtS*)
(*ipPeKnd1LrQ+pYcg4U0HuLJWWspWbBXxLtGrMu0bLnqGu2p/lJkH1OwfDmUo*)
(*E5FMLU+Lf2xkjh+f5X9+vENtYPX+7bEOnKnT2jO831R2rrJofYPUM1xUq9wd*)
(*fURRt0g8Q1RRpWFxhlvL/JgOH1bT8I4iAN8AHrUyjkC3P5I5QzXMq7qu8oTt*)
(*ezO8l1pN7hb7KIdcnW3sHQ0tjeaV7vMSLWjAa9BhWg/84xpThAY7N5haZjR9*)
(*J9T0025AqKdbybS9w2LZBwJ4gnXEzL499fXsnJDlYJYtGN3EEn8TsQvqIly/*)
(*Ep+tVMy06tAbanK8n5pmeDg/EZrCvhcwW7jpVrtTRVLiDsmVYnVlnchW4Kt8*)
(*XJQPM61H8ZPCWI2vqMMwHfgIaCojc7FYGO2xJLewPMz2xTCB3CysfSeqst3Y*)
(*K5UYCwCemXQuZHqlTbiamCKllAQDz8+KuVvCPF79cG/yx0p4tgHTJYexoSrB*)
(*ymMTM3WhFDWdd9/LTDFqvB6J12VEaIulAa6lf/aXf0rNHm3jXRnpTDhNEYVj*)
(*62SBwXtG44LaH2TmETU7lqGsBiVqyXcf7BZ/ZeJWnDz+21ysorsJ9jpQV5Fc*)
(*O+2ZDpyp09qm3W8q2Y5afp5DFzvM7LRtHsaVrFrXFu9xRd2y9QzZ4gLfC7Mt*)
(*y2klnuhwf1RNb2cNn+5mNQ3Ti+E8w28CakMeWLuetCfQ1eRJRZmG6I+dmv9M*)
(*BqbzN8PP6U46nbZ9co5nQ5cDZtNNc0T8tkZ2Xof1L/xIgbGfpZa4p6fJ3VSH*)
(*Opt8T9aC/XCyIWYnuRg5W25u+eSfEuQNnuKkpwHqwcqu8tAO0VSZGV+O2qb9*)
(*eqscEU94SF3aoPVkc7bsIg3+YUQmw61U3xDf/mbygmyvDCk7S4td2SSyFfh2*)
(*nfaKfNgRf2Mt5zuL+NMUgaJpCp53/YWf92IGor8OaPbspD6TpATRbTkxMZVt*)
(*TieoxQjrQFWGJmUV46ZzzdxKrM34FgMzaAb8IO3efH54ezadX6Z5YeQtjr1T*)
(*fIlrdy7hjkvGDA4OIvhgCQ+TzzNDeMgnpZhUepsZsoGOVp/hkW3fqKGVSUdh*)
(*Ky0N/s0/5+LUTWO+3nsjp3Yg3sbNgmljtzIap2p/kJlH1OxMhpsalKmlmLje*)
(*Kf7WxC2r8eRxbuhWWaQ77I7zf6hOW5t2v6mcDmPRTXOVdT2ottW6bb+PK+qW*)
(*nIWeK06Yd8NQ8yMfE35y0bYsZ7VwrsMH1TScNvw+E1bJ3+xlAF6N0t/WtbFa*)
(*PmKe4WS6O7qXfa+7/GT48Jlj4rNJ1ycha47sEyiE2SGfdvS3/rLFBHnuLNJi*)
(*URZl7MzP8xzt+U7vOawaE+umUROYi3R1O5SceN8mt+UqYZvgY84kku/L6dCz*)
(*G/GK8Xn4zSKX01EVm6eLpQz1oF1L9V/+i0V4/M3PC3cpZT/LV1f+MPqjZSLk*)
(*tOSFwHeOBz+UDx/8ztg5Knk6RVZz/uav13pSxPb8Aj8lTypJOdOExuwBL1kI*)
(*WaoqTeIsn6InP8iUmdZ7FizEoehiewJhSNyZnvHzbxXNDBI+vrlDwih1Vh3H*)
(*7kHuHy3hty6f+7kKmzg6L8VaScbMLGWueflaX8e2Jj7QsNbSLpzyoUWFmHzS*)
(*k+afouX5xBujQY5lPlP7g8y8W82uyHBeg38ey9XyuPhyE7esxf3HWdUX4dxl*)
(*U9x4JqJjHdhRp61N64/u3zWV4xBpyrodVzlLVnfJoYjLat1rvw8q6lZbUFf5*)
(*1kIrFN3hHt1eWR7W4Z1qWota2vD5GsRtO7MBfE/oajL71g/q2WFZ+iufV4nw*)
(*Zno0tHVdVVXdHJ1aw+7vuv7ecczQ1TV+QbM7Z3VC39ZlWY4ZbOWdN85YU62W*)
(*nfq63ttm/dY1dd3gHL38kVGXBH5BPhfeNOBX3fvURUmKcL5haCvMziakh1UF*)
(*g/q6IuJo5F/NGroG/17jfg51dXV4WBPl9SVM39DWtGTyt7y7FGPOsZnoWmIm*)
(*6m6tkGst7cf/xIEvo3lpN0+cvfBA7Q8y8ww1O5LhxRp8sPjnj/dj6cqd0p3o*)
(*wL2m7777Ef7Gg8j7WEftohavdh9PaW4LcI1jhWjaqw3wYR0+rqbj55q6TLQp*)
(*kgH4vgyJNxtLKPRTSqrphK/vfADAR/N637UHfiCgZsDPoMJhD0oCjiEAAD8X*)
(*FqENXTbwkYCaAd+fNiCTTF72YueaAAAAPIuhLfOYf3leC3Mwd8AHAGoG/BCa*)
(*0AuKR8JpAAAAXpy+dAzDtCimoZvx5hwSAHgUUDMAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAADgx4D6dqIbaSV06KuzeYHWN3VN06NqeDgpVBeJY6iqFX+Hgj8N*)
(*1DdJ4Kg3LaqFDJ8i1SdWzZYuDRxNVVRV1Qw7Kbvju1Ffb8r4gjwusaHMIktT*)
(*dK94ODM/UsLAc0HNS9pMmU37BD7U4lH6Mg1NVTHD8sNecR/Q8H8SfeHezlGz*)
(*/qszekqfqSSvipM9lM5QGlO5vZNe8AdRBlO53ZyX+ylSfVbVSGhdDdeTG3g6*)
(*y7sSN7tdk7yML8hjEkN1JIqpufljWfmhEgaeyKvazC/Txg+0eJihCp/XwJ8D*)
(*NPwfBq1Q04uKsqqbytNY8w7zqq6qIossrOJa/vqe4VsbWJqi6PH7BixD4ToR*)
(*KeXQtk1sq9TKfYNyPwnUd00Zqeum/ZhUDxKZBP5+qPZacYP/aWJlxy6VoZ+1*)
(*2JkZOmkZX5AHxT7qcB2YyuMdx8+V8DWeoaUfm+CTEDX4LtBY7S9oM3ds2gew*)
(*rtanmM198Epf5RtPaODP4qc1/F89uavcrFT8W/p0YkDLhUYPuXZT0tdp7R9D*)
(*6Y8+sSsUusvcV7Nyn0Lrqp/UtFcCfxe9R3Lr8XFL3xRpVq5tMSrHNznZVLef*)
(*VsavhbblxzqOX7uEn6GlH5vgc1jX4HvoMuclbeZn2LQvqdZnNPDn8nMaPlD4*)
(*ll9MTbnwuGc4XetDx6tfKnbk2aA6IqMvX3R5feG92srIp9D72mc07a3A38VA*)
(*c+sVB8mgmMx6z+75pDJ+Oc/oOH7VEn6Sln5ggk9iW4PvQdjMF/MMP1wbv6pa*)
(*aWf9Sp7hD2n4wBaZZ/hdGKossgwrndZEUBH7pqHrhumFkW9bYSkpVVuEdA78*)
(*pphRksYxXlRhVo409jERyxxx4nXs/YB/MjCm7aaVvDm0RRLFyUic0OUaVCQx*)
(*uZAkqZh+wZm3Tbce78/HP0zDNN1wHt15esNRfoauijxrHAOgofLt8Vk7qaQV*)
(*vG3aa6miro5927BxnHmdhSQnlp/QKOghH3/DsrLDrN6rGqnA5fTju1zLsm3L*)
(*tNygmN3XVXmSRCZJyPCiNE3idDOXNTShxV6F78G3tKKM3nh7V/iOhcXhx+3q*)
(*0Rb/NKoOkXN6YOmGdpSt7cZjeZvxD3N8wnLTeiXevaqhkrHzHlXJqKuG7SWd*)
(*TOxU9nUeY3E4o4ytICm3Yquxbowar1uOZ+sXwpC+g4RpbkbZGvTmIGlW+dgv*)
(*BZekEY2D264IHKL9Xjy/BeGcmKPQxh+iyLdsvCy4p6VtmYyVrGOjMr4qntcz*)
(*0QSLNI3R8gS0IcQFK/dFtZdm5u1RNduXobwG99TyqPhXPMODx2npiZUjebTd*)
(*pGjO8z8Jf0+d5O7K3v27pnJo09AjvYlhjfWQM/u2U63S9vuooq5gnqFfjo8G*)
(*pJVZtp/P5LJXlnfr8Fk1nTf8KvFGETrRq+yaAS7yTT3DOnZuHL4mglIHN1nD*)
(*CaLA2YuPGk2pfluhj2VnVk7RLUOZ/aRMDRXVJDL/ZtiOyYIzb1ZUbfPW14nJ*)
(*bAfdyIPy0NWV6Urmmzx9zXXN2xzNG5vV6Q1H+UG1o4m7FXUqZSgb4S6s6Fqq*)
(*86RU07OndPG7wsQ35hdunjSRHYFvGU0LzfNo70wuLy9tWD43qSjmukRd7ik3*)
(*ZV5/mpeLMuqWtahaK5nUKaGxBIZj8yIpdrUx0ajNeM3eNMu11NscL+MWcadq*)
(*5pK5qSIvxr+NtsqMSxMQVVRGl8E22d26N9sLghJaPZrlB66omwPP8PUlTGkz*)
(*n6SjOp7Lm+OkMwelmEtYM815Zm5iC22b4HpTjCCKHPq46nU7WppT86gYfujz*)
(*nNgNqWJnqn1tZTRwX39R7WWZaR9Ts2MZbmvwn/3e70//zNSyGPaLTzXmzDM8*)
(*fhzv5yVXVXMc1TCt0L38ig4cqpPEM5TfP+ybyj6j1Wc4vu+wmsTBt7Jq/df/*)
(*Stp+H1bUDayzVvWFIb7d/KI7MPt/9W4dPq+m04Y/hOwJQzKsBV6Yb+oZdlWe*)
(*xt7C/cPhkWNz5yGUTXzbn+Ue2AzhZNOYlSNqnVZtW0a0nWmsCaAY677GN2mO*)
(*Ck9frslDdUhmFlJtIiHnOs/GwZloR6Mrm8S+aNbm6EKc3XCUn7bN09QXXYvu*)
(*+g5unLovPcxkYUU3Uu2LLA2EQ0gk07f51FUpZlK2XZOxK2aEpFUjE/gmIxl5*)
(*jRqzngOx+PbbbWajeo+tdR4oq1gPnepWyM4K0rZrY1YiXjtEVVQnoa9BVUgz*)
(*r7qbbYZ9nSaxw4087tCTZJLPzSR9027VxNkkGSwcZqiNv/g7icRor6razMai*)
(*OlZ59dN0q5AMGXSfPdBlrFR7nuG3kPBIS7e9mGypkzWcmxGUp6WguifU0/KT*)
(*pmsinhk64V7gEipsRgxX1vgfCxhbayliO3DZqiv14nBH3L+hLs9mrWzsC8um*)
(*5QH5Kq+CU7WXZ+YxNcMW6ViGyxpsS7laFr/sF5/W+rFneCA9QkK8CSNgdili*)
(*/hFxIY7zf6JOG89w7/4/iPdMZUUdGr5enFAd0/xeVq1Si/e4osq0hbulupNk*)
(*2Vwl6mHH7P9x9KAOH1XTacNnWjqJDvguXPEMu6Yu8jwvKnzK4dDUr3LYYUtn*)
(*Bllj7KkzpgZsJhyFmrLXwW2jCvkVW6yJEqPN+1nWoPS0LEdRFEWZBRZtEfIo*)
(*7iHXV1Jlg01+BbGx5zTr2PCun1ra4xvO8tPn9Gwig20sQrvLt5vx9VKq2MCT*)
(*ka/qiMF+Rc8rUCZZldSfmOS5TuQ0jDMjw1d1fuaDGJ5zX+haWMv2HnbFjnl+*)
(*ud9OLTCdatb8tCywLMsyZQNgRR5hnlBTq9ri6LKE23ysbydVw7Z4GNxR50Vb*)
(*Sqyjh2Bo841gBZvUo1NSrNsNZuenURnueYbfRMIoJl2PGfGkUGWxhlBfKgV3*)
(*SKbMdKk6a3rU4qlWyF5dBzeVOQBrLWWluLHlMd4kRcFZQ5gZjXRZBadqf5CZ*)
(*B9SsPZahtAYlanlW/BPP8PBxFqp3s4To6ojlsUInOnCmTuvSHd8vNZXU+N/4*)
(*3Bfbp8nrUVata4v3uKJuYZ21EYg2n3FfkfZ0krI8psOH1fR22vDppbZthxdx*)
(*GYDLHHuGQ52yuCPbsS2dW54XCTddWoDZPL9qull9lMmtTes3o/t5uC9vcTdF*)
(*VRiqNqKqeig92lTiGS6vsH/1eQw4HZ1hjwud3PB3vznJjwibPBup7fbya/u/*)
(*nV+dXdns7N5JZHfhid2/8mpSdiyG8B8e8lvEfttlXXTs4CZFWYhSUzUrkkaY*)
(*M8WYHyjNpjhuVlyfqUq/mXCTZLvPPUmr5OP9sQHyKW49n2XxMED9u0hYKp+h*)
(*74fLpTjOjDiNgTwQZt1s0LTV0q4uy3EkPLRpMK28HcyEr6rgdL31IDMPqNlv*)
(*D2X4dlSDS7U8Lv5p6Q4e39oQlsWZv7GT/1N1WpXu5H65qURdWZTdgNoydcSs*)
(*Gi+prOCrlz5BUbdIVIL3enbSvO2U5REdPqym9xQB+C4ceYYtGcKIwLY3fAq7*)
(*iZXqRWp9bd+adHGIt2oG7d6Te56hetRA7tgUdtUzXIi9SegKMolOPLzh3/3v*)
(*J/m5vG3wsmd4KKvNlTs9Q1TSYMpViYRy8hHoQ37LdGUhW/qrll3eZyhzwBqb*)
(*BUVlZ6qyV4TF9ZZp8rJVsmzjVbM6piN3cx69c+QZfhcJD2IJUqYpl0pxnBk8*)
(*DyIW5ag4g5zZCWmPn/pU1IobspipA62+1zM8yMz71exYhm8yEe2r5V3F375o*)
(*73F2TrJ0nf0k/6fqJHXSdu/fK0VfpxZJRzG90Fvk9twzfIqibpCpBEuETk7u*)
(*lOX9OnxUTdtSXygC8F3Y9wxZg1rtIewzR3NeZNe8xJqhtvCsWXyuEUmnsd/n*)
(*Gc4n1SlDU8nX1vmM3/yUyFPPcODrtu3ZDf/vWX6+mWf4Vosub36VR1y73MP/*)
(*OL+Fn+08MVSl/OgmmX0e6NyPk7ZnqnLJM2xiNgRYtD7uGTpZK222h3OG30XC*)
(*LZ3X0IPlZkbUpkmBLpXiSm+FitibmYlbWM9m2ictbVnCbLV3ONXquz3D/cw8*)
(*oGb/eChDmYjk9X538ZccPd6mdAuGsdr93hZp0R7n/1Sd5NN3e/dLS9FmVLxq*)
(*WJC1b2Z4r88ZPktR37aPSz1DN5vNxC4y9pAOH1aTzJqBZ/hT2PUMacDAttWj*)
(*/mU+qrxUyz7T+aLYONzj270M6ZFdYpJ8E2e4t5rM9qcsv1nZu6PBka6ts6DH*)
(*my+OzUGFzDNcrAbWkTnl4fCGfzzLz4t6htpewJWIZJ5vXeTKqYu4misHq97t*)
(*t/BA8MX8G1mts6WvkazpvLE4KDfvz1Tlkmc48P1Qi+6MrxyNSiXeMg/t4Bk7*)
(*Wk1+eQnLb64jgwTgXSnFSW+VuzoXWp96bOO/7uPKWmkpW7FVxLtEr8rUfLjo*)
(*Ge6q/VFmHlCzfziUoUxEMrU8Lf6xkTl+fJb/+fEOtYHV+7fHOnCmTmvP8Ph+*)
(*WSk6V1m0vkHqGS6qVe6OPqKoWySeIaqo0rA4w61lfkyHD6tpeEcRgO8CD3RZ*)
(*eCBvb+xDjYqd7Dz3CnSLfZRDruLhtgilZ9G80n1eogUNeA06TOuBtaBZhAY7*)
(*N5haZjR9J9T0025AqKdbyTT5YbF8QYSGf4wvjNj2XZ4f1oKUKcN8QoDFXR/f*)
(*cJYfZsrOz2Jl3wuYLdx0q92pIqlpYXx7pVhdWSeyFfgqH8zpxcHMs8Oy9IV9*)
(*FtHUhztnhbEaX1GHYTqMmVmVUewGIrmoxAdAFTPFu6xQk+Od6ctOeYKZ92nX*)
(*BhfIzcJ1dVI12429UonVbDvBZNK5kOmVNuGbSU2RUkrOrZifFfMdJTzbgOmS*)
(*w9hQlWDlsdP2WilqGo27l5li1Hg9Eq/LiNAWSwNcS//sL/+UpMRGl10Z6Uw4*)
(*TRGFY8fY0DX9PaNxQe0PMvOImh3LUFaDErXkuw92i8++gbITzHzy+G9zsYru*)
(*JtjrQF1Fco1XTI7zf6ZOa5t2fL/MVLIdtfw8hy6mB9doftvmYVzJqnVt8R5X*)
(*1C1bz5AtLvC9MNuynFbiiQ73R9X0dtbwx/+zwDEN04vhPMNvBWoDNrmmBMvD*)
(*LelgQXXSvUe/nIHp/M3wc7qTTqdtn5zj2dDlgGkyZIGI39bI0VBh/Qs/UmDs*)
(*Z6kl7ulpcqMIqGvG92Qt2A8nGwKdGyPbFudPUFQzGvjK4JhEhd+I8oDOB/J1*)
(*vbMbDvMzpC5z+JPN2bJzEP8wLpPhVqpviG9/M3M2V7y9MqTsLC12ZZPIVuDb*)
(*aeeWH8mnBHmDp4DpaYl6MPmsRUCTNYN8f9qaTxEomqbgcIJf+HkvZiD6a5aO*)
(*nRAnnO98XMny9OwIJyamss1pG3JYt3tUNUOTsopx07lmbiXWZnyLgRk0A36Q*)
(*dm9iFjqbzi/TvDDyFsfeKb7EtfsmEh4mn2eG8JBPSjGp9DYzZAclrT7DI9u+*)
(*UUMrMyCrZSstDf7NP+fi1E1jvt57I6d2sC+JYKPBGkK3Mhqnan+QmUfU7EyG*)
(*mxqUqaWYuN4p/sCLb+SyVaSzx3kM2yqLdCh9nP9DddratMP7paZyOoxFN81V*)
(*1vWg2lbrtv0+rqhbcpdVmxPm3TDU/MjHhJ9ctC3LWS2c6/BBNQ2nDb/PhFXy*)
(*N6fmA69J4W9qnCsDhh7H9HJfPmLw4TPHxGeTqqviaI7sEyiE2SGfdvS3/rLF*)
(*BHnuLNJiURZl7MxdvNGeHyyr92U43Tx6dw073sryorLtJ8dvhmJ406TC6Q27*)
(*+WmcpSNqRXI70xdLGepBu5bqv/wXy0z4eeEupexn+erKH0Z/tEyEnJa8ELjk*)
(*eHBSKU1gLtLS7VB8iSV1VmZNfsz42/wUWc35m79e60kR2/ML/JS80pm77+P4*)
(*Yv3VjYlpQmP2gJcshCytmiZxlk/Rkx9kykwSabNgIQ5FF9sTqIok7qwJ8/Nv*)
(*Fc0MEj6++Z4SfuvyuZ+rsImj81LwGZJZZpYy17x8ra+jryU+0LDW0i6c8qFF*)
(*hZh80pPmn6Ll+cQbo0GOZT5T+4PMvFvNrshwXoN/HsvV8rj4K39BNhI5eJxV*)
(*fRHOXTbFjWciOtaBHXXa2rT+6P5dUzkOkaas23GVs2R1lxyKuKzWvfb7oKJu*)
(*tQV1lW8ttELRHe7R7ZXlYR3eqaa1qKUNn69B3Nbr0cD3hY6blHD1oYI+t3ZO*)
(*8/hqEN5Mj4a2rquqqpvTo3VQ33X9vSUZurrGL2iuBFsObVWVVU2NQV9X9dRf*)
(*izDCbsxwJcnw6Q3vyM8Xc0ngfVuXZTkWt5U7N9feNOBX3ftU19R1g2V5/GIR*)
(*zjfg+sU1I5f9U6oGjWpDxNHIv5o1dA3+vcb9HOpGFTs/Uer1JUzf0Na0ZPK3*)
(*vLsUY86xmehIq6rrbq2Qay3tx//EgS+jeWk3T5y98EDtDzLzDDU7kuHFGnyw*)
(*+OeP98RIykt3ogP3qNP994/9ySzvYx21i1q82n08pbktwDWOFaJprzbAh3X4*)
(*uJqOn2vqMtGmSAbg28M/u2Ak/HOcQ5sby8N1gXdyGqkLobyvyut91x74gYCa*)
(*AT+DCoc9KAk4hj8IJD58hs8JxYYqLF/kmOtvDjoJNj6/AfgiWIQ2dNnARwJq*)
(*Bnx/2EYGL2vO7wW+G13bjLSX566BY9q6jD0W7aHZYbNZZTi9AfgahrbMY/7l*)
(*eS3MwdwBHwCoGfBDaEIvKL5BpBMAfD1l5OiGaRFMUzecZLjzBuBr6EvH4BVj*)
(*mYZuxptzSADgUUDNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgJ8G6lpOhxH/*)
(*TJf74aszeUzrm7qm6VH1nHyivk4CR71pUf0iBUdNkTiGqlox+sS3Dm0ZeZZy*)
(*M/L+jqf6KnVMTVFUVdVsP/l//sLXxrqxo+uibLO7H3kKH1HvfVOGrqmoVvlR*)
(*hXmy8n9Ymg+xUqruQjN4vVb8AxjKLLI0RfcKfuWJqvI1Vg4AAAltcjtDm+zA*)
(*S9JnKsmn4mSPJ1YGhii4m3ePJ/goQzllSPU+K0NDZCqi/rPLnmGbuTibpuvb*)
(*Os8zTUe9nkjuqPc+8jgfUO9DOCV5hwzv46nK/4FpPoBEqc6ch5drxd8fVEeT*)
(*Nrs5u/osVfkaKwcAgJwmsXG7Npw4K5s6ob245sRN21Rl5hr4QlS/+BiuDcZx*)
(*rKLHD0wOlKGftbiYQ9c1ZaS+UJ+CxhzFtkpt5qf5SqMc6jwg+qBdnTMcCmLe*)
(*7Qb/g2KLPP2f/le/M9aNk1yvmy4PtDsfeTcfWu/9KMPMu90lw7t5gvJ/Sprv*)
(*RapUiisV5wu34icgSvcchsJ1onu0cmjbOiADxskzfJqqfI2V+0yeXH0A8IGg*)
(*2ByNbsL0tYmpZ+jzpa/ReIzj8+br8vdJoFK73ZxM9CCdq75Wn9JlzhfYzKHQ*)
(*7/Fq+tylU8z89r5I07J9Ae9ij0+o9ztlCKy4Q6levhU/xLp0j1L6Y3ruvcmV*)
(*vr70DJ/J11i5z+HZ1QcAH0lj3pSUt8OKLcGYFR/ZdKmlWOlXZe6zQLGFuxCv*)
(*EN1Nj63mK/UpfeF9gc1E93k1qPTJ7f4L+4JzPqXeh1z/0NXkn85lpfoGrfgB*)
(*tqV7LLk6Ut7VVD/UM/waK/cZPLn6AOCjGTrRCnvS6G+KOYvhQX03vP4E+FBl*)
(*kWVY6TRXj4rYNw1dN0wvjHzbCssdYzM0oUUXnW6GF6VJnJat6FO8cnjrCt+x*)
(*TMO0/bhdPdrin8Z3GKbphul+99MXaSKIoqQh2WyLNIrxlThO2ZUy8WxTx7m2*)
(*3CCu+3kSc5s5FOND5NEM5/YNtUXE0kqKxXTKMMrBMjCm7abVhS5yqCPPNnAm*)
(*LM+ztiuh0lKjthwzFHkmVaAoGQUZ05wMXRV5luVlvG5oZRk4RKErAsfGsvXi*)
(*+TLLOx7BeejK0LVxxo1RekndD4iwU8xPqHd6N/UM9QK91UlgmSOWF+WrHuIw*)
(*TVSmoU202bLdOK9ZwdBcOJPyDy2WnmGPrXhsBYGN32iPlTF718kN70jzQj73*)
(*QHUeu5Zlj9VqWkFSTm14X6k2Qv6s2iT5GoWDi0naVFIsV1T6OvZxaWwLt+Fi*)
(*oaPnaoxwZrAFGH+IIt+yyWqvvHQ462noEXkzgc8KdVRfbRGy5IhU4/hkkbPO*)
(*SXl13XI8Guk58wyv296ByM0dc9niBE0i8MWASeoZHlhFDLYVtkGrL0iapXbs*)
(*VS7qxmqyiXze6iwkmbH8pKQP5eNvRGJhVi9ftmdOD2t2r/ok0HTsvEdVMsrQ*)
(*sL2Ev+PAkr9f4EToH6Cx53m+o+z7CvCcfuF+C/Aro8+IHb3ZyXdaPa5j58bh*)
(*c/UoJVsYDCeIAkc5jDXqck+5KWKvBVm2ykWfolvW/CfFSqb3JmSRSzUcm4dO*)
(*K3YlNbCo8U1VJGI4IfUDmyzUacyU4Y1Xco/65YYf+gZ7qy1qYmEzURM67KU0*)
(*8Bs1mWvp/Ao32qh2SSkM2zE19nYrqg6EiZqE3mh5o7Hgz8w8w71SoyaeSsh/*)
(*CP/D3zsiDRWvW80rSzPNuWzZngJU3/0Iq0ef3hKk6Vzat50VnM+odwrzDG+6*)
(*vpSQEXSX0mzpeE2zgyzxF0ko7t+ulH+U3nSHZhmLQmD7eXrDtkFdeOQ0n/vG*)
(*tgtIgsrYsdi8cnWPNhC5Usn2wH5ebY7FJBlWzdFJMnh+WYsb3U+ahGmNPRl7*)
(*p5c2bxfVuE1weRUjiCKHPk72YshL12dUrwzH9x2dp9Sc1xcLb5ij7y8KoIQ2*)
(*SM3yA3eyCMQzvG57M9+cHnXF36wwwk/aeobHVrHNfComx3P5r/qJsRrmFsb0*)
(*bPEPEWCY+Mb8ws0THceOOT2t2R3lXDNPh+/aw2/Ds4xHlvwhgX+Qxh6IS6pk*)
(*B2XfU4Bn9Qv3W4BfHV1KRa1+L6e5q/I09hbu35BruHr5IngT305WlAY2t1DM*)
(*pk+FMgdp27UxMyDcRyJpqg6Lz0RVyPbfursb9AqfOQjFTOuiscnqAfGI2NY8*)
(*ttxAW9zt5vMsbW1m4eEszZd1okVwOI3V1+KGDVxD1q603VAXVFEL4nNZZa5+*)
(*V6kHmkkREoa6POPtkVyklSXa5zhKb7om4rLFo9l3PIJhOec12Hms+hQ/iovd*)
(*CZHPqHfhGWJbFCRZEoiuyIzq0zTriJRM9+n7WdAdFURativln0vvRnygsmn5*)
(*Rgx1VIzTG7YN6sIjp/ncqwBq9lWbuWqo5q6gGYlH1kq1L+hPqM2E+JhGwM5q*)
(*4Pv3DVxCNrJWY+a4ILafguzgu6LGpEUrfJJobL9zp3pduorue+fLwQl9l+b3*)
(*1+rrolSrkFUry0bHZg80qaq87dreOs/iwOalx25MEvuzhsAchrWVO7aKLY2K*)
(*N9kKbcO2ThtBeVi5/67I0kA4hIqVVm3f5paoG8VMyrZrMnaFqeKuOf1f8ysG*)
(*aquca9pyEiYWGnOERu/o0JI/IvAP1Nj7ep/dsv+yqwDP6RfeYc9/fVCjtzox*)
(*oO+6rp8xvGaYREsHS8w69TlV+ICtnqBQUw6apCweiV2xY76aMNA0mcrRYZrm*)
(*p2VR5HlRlimblTiYHmG5Gg0XHze1tBX3s/RvbK2LBfhNWZJ5huuAn2IeAsQa*)
(*kZ6WJc5iUWYBXRrejYJmB30Y4dSPdyntb/JrpRaZnL+gTZdR5dzaT7JdvuUd*)
(*jwxlQH7XxRptHZHCnnR8n1Lv3DMMxIGGHZvtwf34SZpDQCfipmOjaosphijZ*)
(*UvlFtLBqi5Uw9gquKqc33J/mlXxu6OiBJ1o6u4UPoKbZSKlSyfjw2mSxeTdL*)
(*CIGp2c2q0FtGUlPnh7eI2TnqXZypMW3RqhWyt9fBTRVxgOvS0YHhjc9/0vA/*)
(*IaXTKr4kVX6STDCbp82OVeXA9nKbNk0ciTlh3tLXVu7IKqKYuOVseIV/rVhl*)
(*kCvHlcuCV1VHTD8yiSmTxEoqYSqiY3N6btMuhrz21NcxfNaO0OmrHxD4B2rs*)
(*/b2PvOzH3eLD/cJ77PmvDmbJ9cXRhUMWTEsTqspOrjJsv7hy1OznsWx3s+US*)
(*1XSz+rSSd/sUT/RrfB8BucCHHopA1TCqZh0dzszG9QpbDcnxzslpZaSry7Lu*)
(*0NCmM5nf5xnOrohJG0Vd5FFVdel6HG6YtNecK8CdpZaGCW0uHsv2PY8MbE1k*)
(*2uUxUMt/M3enq2bJfmy98zjDeWQh83+wJhynyUJ/Z2NY5oMZYblXiu100EpV*)
(*Tm+4P80r+dxIP5ed58OnBUQPcnlXwofXZi+bZxvG4TKa3rXampGyY1hoR3Oi*)
(*xsy7ow+EWbcI0NyUDnVlUXYDasvUETOEXEqnVXxFquyeleoeq8qB7RUBt7PU*)
(*2HTE6I8hea72rWIvm4XDtUGfO67cbVVur3SZKzJzZk5PbdpVz3BbqJNXv1/g*)
(*H6ix9/c+8rK/nXSLD/YL7+zHf1UMFfWuZzMbHFL706x4EdE5av2V9t+v212T*)
(*8sUs1mSCvZBf6eOSKwuVo79q2Z3ag+qQK/aYSmXgleR53EWf+tQ9V9yQnZH8*)
(*fs+Q3H/HFkJUU5thhrMs3VnquzzDHdm+6xE+tDR45pnrpQWHVfQp9b4p3Zvo*)
(*uHGzOkmTTQ3dzIo/SW2xP7XTdZ5PVeWCLt2d5oV8rmlZI116hnyKVTiZj3uG*)
(*z6pNNqkunYhGJV23WrU4KiVuP8/UGNXeIgRQDfIpBG/rWvR1SmOBFdMLvUXe*)
(*3qEDW+qYmqPF8OpUVXZtr6wh0NN0xZn2slztWMVBrDNKS3BSudsXHV85M6en*)
(*Nu0+z3BRy2eW/J0C7z5QY+/ufXbKTq/vd4sP9gvv7Md/VfBFHHMbe0ls/kK7*)
(*2JSsftztfiYSpUJt4U17KEbliPZnj97Xp5B47wVDVR6fCc4Dn8yoxgNSdSbV*)
(*ljYxPjM/XO2aZ1N8W89wvvLFsthUtXS+l/fIi+Z8Z6m/zDPEp8hy6xHneUxN*)
(*pXL2xa5PqXe5Z0gXs8aB+VmafcmWYXQ3L3Ma+KkshrQv4RleyOeaJmad1CKw*)
(*meuhk7V7r97hw2uTBTncjJW32xZp0f5Hm+2FWEQosX5Wddvz/FBQEXszs3UL*)
(*2QnS62dbdoK6Ghb4Cl8efaZnKJyEueqeqsrbnu2VNgS+qtvKc3VgFVs6haQH*)
(*y0lp1KZJgc4q932e4b45/XDP8NiSv0vg9cdp7N29z66IjrvFB/uFd/fjvx46*)
(*usSvWPH2t61nOBp1mwXHflYGT1hqSJ/pKo98q1O+bekgt3f3KTzydTGaJlPo*)
(*9nHL550LkbY97ZFk0++KWFwWTYBblp0dKHP/vFysJnssi4vlvB4fXC6f7WWr*)
(*yXwdgeaiuKvU8/WX6YZP8Qxp0OZNN3QNf1rXcoLyPODhU+pdZp9rGtiP4wzP*)
(*00zIvYahq4qq6YtzXaR5Hs68gtMb3pHmhXxuBMO6j6VlniYb2aukSiXjw2tz*)
(*1qbmU/21gXP7Wx7fb8+7GdbP6vM5il01Hv1pvobepx7bT6r7pawsnassRDcs*)
(*PcPT+hKLpwf2SpR3HhvGB6Q7qnJge2VhFWzj0o5De2gV5dVXRwYJdTup3Ls9*)
(*wxNz+pGe4fGr3y/w/uM09v7eZ6/sx93ig/3C+/vxXwtsk9fNSSWLrjLPkE/D*)
(*nhnrz4IFDLCVhSFX8ciFV3bPolL3cysUbMCddpgO3FWeliqEj0QaTCW+yqqY*)
(*adXhU1vySLtd+cB0JU4QmMd18+B25r52ZUT7R69oiijE57HRrwNovihEyUOm*)
(*aavpy4h5dnQMiKbvkJp+2g0I9XTrlrbnISd8Y5rJt17y7X4KDQA+LTWzKrNM*)
(*vonWPV1ky9Z7sn3XIzRK1szvC3/9lHoXJ11PYmejdWrQjtNsyIqeEeT7BVsq*)
(*P39koSr+Ynr59IZ3p3mYzy0stnlm+fls6uyKVKlkfHxt9tM2czfBziHqKpI7*)
(*POXF+lwcDz+dNUWXYrj/dqLGhave9Ei8LSOnq0yRnIvS/VlE0tJZuH4XO0xK*)
(*bZuHcXVaX8LtGfByZJhKv23XJny7qCmynJJczU7+uWx7WUNQpl/Hjp5cErtI*)
(*Vlbu2CpGf8hrQ3cr/ACqElwom/Rix5U78OPThXwkV4rZlRNzemqgtsopRbaF*)
(*+fjVDwj8AzX2/t5HWvazbvHRfuGBfvxXAGpDHsC8npknvL5nODD9uRl+Ps2i*)
(*j3VNzsRs6LLL0do3Hzsomqbgqfhf+OkZwkfqC/oF4ZudECPG98EtuSSQ1S5C*)
(*VgQ+f4JPdjO0ZbJGiYaYnaFgCCXnwbRjrk3b0pePqGE18I2TyywexH6wjV3k*)
(*NsuLwulMAJIvvz8pNTubbpT8rCWuc474FxiNrWzZFrP7H+mzzcF3OK5Y1cy4*)
(*PJoU+Yx653lTdCevu6Gv2YF44pOUh2nmjrxkphvTgq2Vn39tAffmrBZ4vagO*)
(*6SJOb3hHmuf5lNJmPFLdDJrhbWhSaqn96Vx6qVJ9WW2WoiuZwQ+Abfl5f0qQ*)
(*N7ji6dF4esD8nDM1pj6w4ZG92qihHjEP/F6V7k/+mBsJ3TRX9kIP/sNpfYk9*)
(*ApqOnw53Vs+y6ew/zQsjz1qYBL/o77C94vgmbXTkxntRHtD5K5fPR6wb/olV*)
(*/KWUVIaYATuqXJSxhXKhVNsrQ8rKzq4cmNMLNm2tnFJxj/pPM6G7C9fxyJI/*)
(*JPAP1Nh7ex9p2Y8V4P/+/x7uFx7ox382pb9tW8ZqwlvmGVJfXX+F1WThIDHM*)
(*cNjqg+bsfQKFMh2bqTl/89frBIvYnl9g52X1pcOPBiX6ZqbNNXF06fiYuY5t*)
(*6MLJ6mpRIUYzetL806o74occ9uHsgE83qXIyeld0K8rKnpieMnbmR4COTfhk*)
(*ga9O5q/SWWNUTCcomv6g1HxwNwOfF9oHS4/1T9I/Xdw2yjZx5hc079/f/8ho*)
(*bYZgZTZmhTjQ0k+pd3ykv74og+JEyzHpfpqoWuZqXnC/2Ch/8KfLM1+DfOWy*)
(*/Zd/8N8c36D/1d/cmyY+W/g4nwfSabNgeSy2LrZd7CjV19bmWxHOOxPFjWcr*)
(*y6gJlqfp6nZIT9Ncl0Wmxrm7tltONA3V56UjH3WZ5KbZccVO9B071vh/vFBf*)
(*8wOx7aPT74fEnZkEVWcWQTODpGj/r3ts7+xgT4FieHy2cpBZuQOrSGeR8rmv*)
(*qrDJQ468cnt/mQ8/L1aC97N1VdBZKak5vVKz2+rb0iyfokchCXYt+fsF/uEa*)
(*e7332S/7rgL8L795Ur/w7n78V8/WMyzJ0OOFT4NE+CQJNLR1XVVV3VwKGUBD*)
(*33V3DxW6pq6b8S3NXauYY8akb+q7Xhy7MGaobbtTHW3rqqyqljiCY4GrZpPw*)
(*0NU1FkRzdaV1aCqcZtORw/erapuJ95X646CfbtG9bEBD17YNZpQL/jTTbXZa*)
(*uPzZz6r3rh3litWx33lGlib9AoWRtcOYTVqysS6LjJzZfL7A+mk8lk/Uj7VV*)
(*Ytkcf6XtQj4+pzb7ljQReTR939YlKU27V9M7jJnHZqtridmqt+1uXTqET5gV*)
(*BgOrfn9Xp4ZwcheeGLoG10+Nu0zU1dXROWD7tleEvXUDKeFVy3xmFVFb09zJ*)
(*6/3JxupuczrxPuU8e/UTBP5xGvuIuKbs3d8tsnsv9wuv1qN9C4hnqLIIRNSl*)
(*9HgE/gUrAPhqWjpyTbdGFx8TpHyvb/rMYfuV9GT7UzgafftVhmbfJZ/AVyLb*)
(*igV8IL92gf/YfuEFGBJvWplQ6AcNFd2PC/AKgVdhCuSzo6xsxwHmgEexaUi2*)
(*b86+ofnt4Is1iuVF5TigH/CMXF2m5BuxSizdNfAVfJd8Al8JWm80Az6WX7nA*)
(*f26/AADABVDqbgNqyCSWG3/r4TLiUdnbksXVC5Xsu+QT+Crauow9FiKm2eFu*)
(*RAXwJEDgP7hfAADgIn1TRr5rmaaBMR0vLH5IIHFfppFrW6xglhOm+58V+Uq+*)
(*Sz6BL6CMHH1UCoJp6oaTgG58KCBwys/tFwAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAIDPoK9Sx9QUBX9c2/aT49M3UV8ngaPetAiO3QAAAAAAAPhZ*)
(*0I+0qqbr23wz+/6hRvMPpLo5nIkJAAAAAADwgxgK4urR762j2KKndrurc43K*)
(*0M/IF7qGrmvKSP0ZnuFQuE4EJzgBAAAAAABQ+twlh3563EHqizQt29UXOEvt*)
(*dnMy4Qd29NsO390zLP2xWO73LgMAAAAAAMDzQKVPPEN/P2QQxRZ2BL1C3NJj*)
(*l+qbe4aojpSTggMAAAAAAPwwUJ3HrmXZjm2aVpCUIoAQtWUcJ5FnkuVjM0rS*)
(*JI6L1Wzh0IQWXTq+GV403pGWrfAMvXJ46wrfsUzDtP24Xb54aPFPum4YpumG*)
(*x5/pRkXsm8Z4r+mFkW9bYUmnMIcqi2zTrd/e2nz8wyRJZav138MXIZKCgX+0*)
(*3aRo6NW2CFmpSMHjGC+VD10VeZblF2iofBuX6X/4n/+nKE5G4oSupaNilFFC*)
(*mL5kMYwStg0jqsck6tAbnzQsJyjJNp6hyX0s+fHl4Xy/TpV4Y3GdqDyuPAAA*)
(*AAAAgOfRBQaeGFN007ZNhX0c0WuId4iaWF1/OFEJq4Vn2OWeclOU2R2alwvP*)
(*ULes+U+KlYgH64QsUquGY/MdK4pdybe1oNTBGTGcIAochUcwZr4p3um65m2O*)
(*5rWXXtT6pPiq6Xj8V33M/1BsPhv5u7//O1M5JrH87n//e+wflfijKA9dXZmu*)
(*1Ikj7jVdV1vI0k4Sb5Vt7tMOIcuOUf4Kv9sJAAAAAMBXkHvYA1Jt5rChmruC*)
(*ZiT8kaHwlk7LloHNEBbiFuYZjlhB2nZtbNP/tZze0sT4vU5C34KqkDpTqpvJ*)
(*ks817Eal7F/y7OgZ1nkWB7bwqka/MYnFa8cSVKcvSojfagQFTThirjFzxhYF*)
(*R22epr7JXULd9R3suul+QbM3FQ2/NBKF7esiTQKRKyyNoc8Da3IX/aTtO3El*)
(*rFlO2U4fzYf9LwAAAAAAfAZdRhwdLZ05H4VPZ8uUiLkobz11kFRvf7V3G1XI*)
(*rthxzS5w94ku9NI5QM1Py6LI86IsUza3qMi2e/T0WTUo6EQgCjWFeaGITe5Z*)
(*1A98w64gn8PDHt3Bi1oaRnizeBbf6oi6ZxadUdwWnG3GuRk5nTdF1IPM9ZVn*)
(*yKYcxRXmOdsJW6p+QyWdEZzkgwrqPc5kOLRtO8CEIQAAAAAAn0Kfe7eVSzPS*)
(*JtSzEhuNhYO0P3m16xl6IumF+9R51A1SBKqGUTUrkmz3mK3tqqab1TPnkSWr*)
(*F7PHEnaujl2joxf9VjYXOvS9cMa2BWdXVvN4Es9wdWUjDcmV9mfs5gYAAAAA*)
(*4JvSpq7EM2RezbSw+4hnOF1ZOEv0Vy27vOm3YVkV/mHQSpLlNyd0iVnN+qMX*)
(*sRO591fJdz3DlSgue4ZH8vkRu7kBAAAAAPi+NDHzoBabdbln6GTM+fowz/Bm*)
(*xc0ynaEq673lU9QWnjXbwGGQSEiZZzjQY3ZUpz180T+mdG+IUS79xrZIC7LN*)
(*+E7PUM+H1RXwDAEAAAAA+DawHRYrx4kv3frsWJi3LnOf7hl6fKPLfOMtieKz*)
(*ZXGGma6y+MO+TvkOagOvIG+9MhwuaPIMH73oH9hi+s0Mq9nLagOXHSfH145n*)
(*cYZSz5CFQU4S49GP4BkCAAAAAPCNqNmGWMUWruFQ+KsrhUfdnINNssKrGR2q*)
(*OgzT4a2jLtm0W1lsyiAuXCW+rayYadWhN9TkkYa9sEKS/JCr06bd8W0p3TiD*)
(*N7Mwz1CZfn0b6B4aM6pPXtTnInzRTbBziLqKlNWhs6XCDxzwcnaY1sMgPfR7*)
(*4NtJ2AaTPmIHPGr8XMXt3u3d3dz8ypAFjmmYXgznGQIAAAAA8Em0mcv9pqAZ*)
(*3oYmNVbTX/zAw/GOvNtb6eVTc4qmKXid9xd++o3JD4Tpi0Bh7hPZjYuq6dyW*)
(*CW19RDWFun+ja1fjn5uMOGx6MLxNa983za16hI8TDOiEocvWwg9fVAq/cYbY*)
(*Qcx3It80HTttYf1L6tK36Um9CM0MdC5F29aVRWqqGf3SZvR3I8jZkTTTFSYf*)
(*1CR04tHwc/LuTByZ6JfwDRYAAAAAAD6JNgsWx1krepBzr4qd6zL/VX4YdR3z*)
(*85w152/+2l88YoZFbM8vGAGZB+tLZ+5FjY5fs+MCzdwk8Rb+CZRp3m9KyfDm*)
(*HxM5flERzj1HxY1nK8uodviL7eivnKUsrKievSGcfhx91Cajx+xYXvQ3f/5H*)
(*i8dGX3C5mwZfmZ2GTVLwe3bID5XffLEbAAAAAADgg0F9XZVlVdVN++7z89DQ*)
(*d93dpzJ3TV03dVU1h+9F+CwZNLT1eOeYScmpNXk3/lqtf734or6tKlx62Zwo*)
(*wqW6Mmk3kERqKsBRnnX/2FGEfdvUJZ5ItNP2/G4AAAAAAABAtjf5x1Dhk7eV*)
(*BBxDAAAAAACAK6DFxpYfRBuQPdhe1pzfCwAAAAAA8KunrcvYY1tINDtsHly+*)
(*fS2a0AuK3S0/AAAAAAAAwIIycnTDtAimqRtO8tMmDgEAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAANagukijcCRKs6Ib8JUizfuvztY1Wt/U*)
(*NU2PquHhpEY5JI6hqlaMnpCxB1mXC/VNEjjqTYvq05J2aeBoqqKqqmbYSdl9*)
(*dF4BAAAAAPghDJWj3ZYouq7ebmr2LVzDPlNppp3soXSG0hACUL2v96WW5SqD*)
(*KXdufpy71sUVqrqBp/MKjZsXcHUBAAAAAHh1+oB4D4rhVT12HlBXebpCvCP3*)
(*672jS7SBpSmKHp/PpMkYCteJiAs8tG0T2yr1DF/AKV6UC/VdU0bqBc+Q+pBW*)
(*3OB/mli55EweUYZ+1oJjCQAAAAC/AvqMzBcqUTO7iErz8Sm4b0LpjwKYfOAu*)
(*c1/GM9zSuuqpm9d75B6PxwL0TZFm5fsX2lE5CsjJvskoAQAAAACARxhyuuDo*)
(*F3PfoR/dIyttvyxXnwWqIzylpvmi8H3hvcpqsoTe1049w4He4xWPR12OoNhS*)
(*n5caAAAAAACvTZ/zGENzPq+UeXbybSLThiqLLGP0ZEWGURH7pqHrhumFkW9b*)
(*YSmZAmyLUGVReGaUpHGMl0yZZ0h8xTERyxxx4vUOjgH/ZGBM202rIy8StYXv*)
(*mLqum7YXRb5lR7OsoDqPXcuyHds0rSAplxLfluvEM+yqPEkik5TK8KI0TeKU*)
(*1WpbJp6Ns2GYlhvEdb9+MvJsQx/LY7pB0tBnhia0mIRwajgxPljo69jHGbct*)
(*nFyxWGum2bbzHlXJWAuG7SVjdqvEGyvEicoDWQEAAAAA8NUModjZoDr1d3EG*)
(*OXXsiH0ZfMUTpQ72ZwwniAJnN8puKPTbCj3vuWeo6JahzLfkxML5QTXZ33Ez*)
(*bMfkXrUVVfL8tYlKgjiDKHJY9KaYjewC8gpl9Bltk71M96g/LivX25ln2Pub*)
(*IilmOHp5ucdiSf3Q58WyRfhAm/k0Z47n8l+xKLrcU27KXAqal+N8Fz5L2xp9*)
(*Tfa7lzarbN9U8ahRDELNjPK76RgAAAAA/LoYSmvyJOwnHP3yiXRVnsbewv0b*)
(*8CyoYqfsjibed6VG95DOEE5RhcwzxKKw0qpty0ibOUVkdXV8m8a3+o4OD325*)
(*Jg3EKzycl4T9ND47/sdiGqm3ptoJ+62O2fScGSFpuUjuLqwm9x5bTeZlQmzP*)
(*NVsRps4qjh8gN7R0i4rJloubiDlwAZ3cE2vTPDUWmKrGDS+UzTIe1agtp2zj*)
(*fDJHdPQMqdzwZOxLBnACAAAAADCjL8xpqsf9bvGFLZ0ZZP4SWx9Xg4KWA4Wa*)
(*Mjk2S7ZRhfyKXfMrxLu7aS7xDJlbpadlWeR5UZRZwNxq6R6Ngrp/Vsh+q4Ob*)
(*SmIaO3oijZbO8lWwKT8lYlO3y3KR3F3xDNf3DCxgIGbyYJOl5AYUk9lKM+LF*)
(*RRUtj8WurFPLyHysOt+dJGZfiU8rtsAYfsGS5Pe1bTvAhCEAAAAAfAu6TCxF*)
(*qk56fv8LsfReZsvEqulm9VEQoPAM13OGs1lE6t1Rz7DPXTahqCoMVRtRVT2U*)
(*TbaW0/qu6oZZh5hj1Od0ZlJbHCbOZ/O4k7n1A9/lGY51W5dl3aGhTQNHFRN6*)
(*+IZ+PSVIJNj3w05q7F/mJ3NSdtQPnQ6VpgkAAAAAwIvTRn68cAjKgHsN+rfa*)
(*irr2hZrUvc1QzWBvFnTXM1R3PEPy68ovOgLV3iL2Tw1ynJeW5XDpGfJ94qqb*)
(*Scv1bs9wvJj6dC5QcUMW8YdvGMRC854Xt0yNHGe0lUDBCqmRo9GvZBIAAAAA*)
(*gBejSxTFWTkEpW/MuvjvgsQVQW3hWbMvuxiRdBnzfZ7h7WbVy3SGpqq7vYVS*)
(*VMTe/CMzYT00sU19wHTuPXHP0MnanXK9zzNsqePGF7WH2Q0tnUPUg+WWYdSm*)
(*SYEkqdU226yyOOuSeYYsDgE8QwAAAAD4fpCFUXPl4XDP5zt7hn2m86+39HXK*)
(*N/0a0llQsXa8iTPcW01m+1PMcO5KkeMfZXGGuauLpeHUY7Gcul8OfJ+LFc9O*)
(*GOfr4D47Y+d9nmG3Og2brYArYjOy8Ax7EROIzyyaObZ1ZLB4yJ3V5PnWZiGi*)
(*0b+UPQIAAAAAwDeA9uZ2Mu/h3zL6BWXF+VabULrFbtwhV/G8HHd0+lTd93WF*)
(*HzjgNegwrQfmR8220NJYQc0j+ynQ9G1l00+7AaG+iezx9ZrU8yxGL02PxL9U*)
(*vMTJrNnGlclhGx1Df3mlW+8y5t9AOQrh4/tNxD3sNG/uG3dlpLMbmiIKoz/k*)
(*q926W+EnUJVgmdjpat5yfLgOw/TvI+bf2pNPy07L4V7uZjszuZgFjmmYXgzn*)
(*GQIAAADACzIE3CNwonz0cN5QL7bZet9qtmdgns/N8HPsDtI1WcVMyWnOTebN*)
(*prPWiB0lmo69mbD+hZ/BYhY99S17euqgOOyxjqYzfgR7kYfU/TY8sgUZNXRq*)
(*LSCHT7cZ38xiBs3wNjSpsZgw3JQLJxCvrmzpioDeYwbsnmE6h0c3jfmyNk6p*)
(*/GXydWcI75RPKiqaptBF+dZlaShB3uApWhqBoAc032NBdOZpppPM+0zsfPEf*)
(*+FIfAAAAAAAfwlCM3bvp+bahLl0Czc+a88dfhqH0F9k3w2HmhPAyObJPoBBQ*)
(*LTbr2tHf+ku/KchzZ5GWQZ2aMnbm5z+Pjt+en5a767zMPwLSZsHiZ0Wn+1Ok*)
(*5fptsbzCPbF5YVJn5fjRI7g78SmTURZRUQXMF9TZx0663JrlQ2GTh4zp8OpR*)
(*jNSnQ01gLjKu2yE9CLxJnNsCq2LuqfjUzliUnVPBAQAAAAD4MlBTMQ9w6Nu6*)
(*qsqyrOr2R5w2h/p+QGho67FYVd2czn+ivuv6e+exhq6u8Qua3Y0nJOmBZKVr*)
(*SVbqbvsW1Nej7HE+P1b4/397Z68rKRDd+X6RfQXegXSTfgFiYlIyi2RFZBMZ*)
(*OWEdIFnCuxKSJQILrUSE1kJro5XQSlgiwQGWWAkHBATX9cn3R3ffe2d6Zv6/*)
(*ZO7QUFSdOlV1qDp1qiNFHIPREOE0q7wMDctHVe/Y0KQURELrBJuqYBlvuocy*)
(*3jV1VcT3aZ0aAAAAAAD8uZR0IV6JYRgCAAAAAPzRND7bJe7+Ur4KAAAAAADg*)
(*G6gD189PV94BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgV6PxDO1+18Ky*)
(*/4rUhiqPbV1VzWj4iuR26ZsidE3lpmfdt73jiib17kRqVvglUvvt+FqluqYr*)
(*E9u4K4qqqnfLi9vvU74fyAM69iOa2yf5LavmNYaujn1bvd3D6h26jTbx7bvK*)
(*Kka34qL92fnZ0DdJGGb1E7L6dmUbumbB/A1dnoSO7YRJcfDaIQv9MK0/nwuM*)
(*PuDb6VL1RlHs9LNJ9YV+k6ju93Q0fWgo8h339OdZhpnNxab+xDy8L1+oVA/Q*)
(*pA6tCcPxLE2oxhtbSo9zoWM/orl9lt+1al6g8KfqcrKfXl2Nc6c14/iurBgl*)
(*qt+mZvom9ize0dvpo7L6fmUbQuO2IqjYG4aKZ1dV6T+KsWOzNYlNfjLC6vP5*)
(*wOgDvp/GN8lHlha9/Bnb544dMg3tm6aOLJUPVd+ks33bVpnPWuH9J84ZtplP*)
(*pWbH+GqjTDrA+bRSPfNqNuJa7FN8iEymGorzumqsy/LT2NWxIvDShg93P6K5*)
(*fYovr5pfmaFr6yJU38My5GaqGbGaqSPlPXIl6PP7zPR6NFffr2xDHSq3JXeP*)
(*p58xO1tzc5IP976X7S6j1qoefEmHiNEHvD+FR1qCMzaDln24fe9Q1efaz7YM*)
(*wZyVDvxIuozp233Uty5PkqJ5vcv8iWW5Zijuy1mUH9HcXuXLq+bXp3HUd7DB*)
(*Opdlw5UdaFfnSVq8TcUMXU/Xuu/PWIbfr2xDZBBT08qbtqnpQnJd103Hv9Fa*)
(*Ic+cvjxns7Cqk82e7QNqtmr524gYgG9lqNhn1N0bVb7L3W9f3hpgGb4RWx34*)
(*oW8vvNvXvf3nluWKITJVNgBNufsRze1VvrZqfgs6b3dC6UfT82y472yp9Jn2*)
(*jGX47crGZ1aNcM93cVGt3DK8zyzDOrJu9IOu+aasgbekS3zHMHTD8rjHQZ3H*)
(*jmXSC074Po4bx/RlGpq6mTRjXoc88gxd03TDDULPMoNi3wJr8oAvjlC/ijiJ*)
(*IrrMJYYq1kJJOqZBsKO1e3NPf9IpRExJ+UDb76vQtUimNN10XfO2sgz7Jglc*)
(*lmfdtJwoqxZPZpGl6yGpnr4KXMsg99h+wVp4X2eebZEsWk4wW/mkMrEMh6TS*)
(*ZOQPUpmGEyx8Ovq2DF3TdNNh9ojJ39LmPkmTlMyNmqUCDG0ROJbGsun4cdX1*)
(*A+O05APLjK4xWcX5yoF5IKVzTNOipTD9eOH8LDLp5UNfeixHcdntXpRSzD3b*)
(*pLmj5U3WtUIftHT+qx9zx/BdHdhTKkZXRR7NLGkfpPz57Ne+obnSrWig6ufT*)
(*KjGsKD/rS4emiKI4dI3x7XFEnqDZaoqY1DOVM31PVK31d1+kB2V5RcibzHZ5*)
(*EguiKCHl6kryh7wSxqykQ1vKO+gEzkLH+jowRe50NyRFTYrm4+PB5rbhrL3s*)
(*3X5Yxv2GfFI1H8dq9oJmPqY25y3owb5oVoNxHIYx79ubPAkjUWfiypnuzU2I*)
(*PhcaEKWsKocmD0Vacb6Y7Hq+tzxuaG2ZkewbqlQkpknn1lRXJg7tNQ0vYaLr*)
(*69h3mKZZYba7n2Lor7kaGh+2DM+V7UQUspuysm4oYzLk6ZYbH7xMLk/zgcdw*)
(*l+l0cgV5mjOcLMM2ocI2o4vy8gwR6yGKV90CNXtTdjmK+JXN6EOVx7Op1pFR*)
(*Jww905r7w5zq/4F8mjyWysi7wSEfO6yZwpy+90+m9WYuEU6cBebCE0Hzi5+d*)
(*wzOqyB6zKpeohoR5t+q2H/r2mf+JWNJdFJe0DDFUKZqpz0WhTEbSUDGnjJtu*)
(*2YaUnhmWJ/kc6pjfaLpEiUeJS8uwS3lOdNvzbJEp7kJTxVMBDceZu6/cFCuO*)
(*3UX22UpE6o1OxnfHMVY3sB68sseEVLrsOBfj3TAWGjBzgW4zj9/iJ4lnqPO7*)
(*jr2sG4+JUTVsYpQJKbvj12jrs18V0i4t+V7NpSPUPJM3ZXrZf9m7qFHvlyrm*)
(*65K6LV9ERFTK3Depxz2sbdeRFatlzY4O/MP/3CoVy2vOi68YJhk4RRIuGWtI*)
(*Vqes3FdqE1aHI8hQRwshsvuDss+4T72ie4EnE7NmveGBSA/0+RUhaxtvIqLz*)
(*U+p3P6uJFTpdUHWf7VhsMl+k9Rd/+9+WOtZmrnJT5qK5MzW4bm5bjtvLnpSP*)
(*y3jckI+q5uNIzfozSR4+8pDanLagx/uioZ63Wd0OuB1YpwHXZUWnKnGlezPL*)
(*cKgDW+SHb9Qa6tQxNXnl+RxKDhsaz8BGyxXjzPmty2adJDF3Un/pa6dvN+J2*)
(*mX275NL/4XHL8FjZTkQx77Rv6lgmfX8atc82rxhFSn/2WV5t9snCB1DNy2cC*)
(*N462K6+oE296kSK6BaoqYk+N4v6v/70afShNrPL7w9DmxZwWEc70/0Q+XRVL*)
(*fef7XIYscOQtcufL2Xv/aCrSuytu22VTa9OsuGiIRS/2Dv2QvZkvQ74fk8hd*)
(*mH99dqf9biLuqKPzttmLKYupmYuhiiqMmZRNU4Rcke9CG/nH113ug+sD0YHe*)
(*D42joeT2mSezkYpRVliGJfPhGNcRYu6Tz3yDu4p86PtjSzL9pOm7zDfH6jK8*)
(*uOna8UpQDVWWRr413kAs5DiazH+D9MlDm6XStGMF52IcW7TpxXVbh5Yot5xq*)
(*FKXgvijUNUUkqnhhlB+M4zH70NB93sl8yH3Zojfmw5BqxUJOlewhjXAYmmxu*)
(*f2qOx4ah/2r+9+1F2omxilbteBAiD/ibVIcpcMN91A3RbdahEA778FnpwI5S*)
(*UbVIWXFVaYAMYuvE7RaWzSRPpjZxUTfSV3/prvOABg5ix65YKeN9F1EeIfYL*)
(*kW71+QUhy0FhxcD19KaHMuui3zDjZrpHo+bQsNEx/oBcBJwG1avmtsNJe9nL*)
(*9VEZ/89lQ94K81DN/jI6lOThI//4iNqcVvfTfVEu7Cotn7VXul9V81l6F7q3*)
(*XU3OWS8wX3nkOZRXnu8tTxraZC2LOa65Ih1QkhI5eVvMDErLT+quidb928TQ*)
(*kU40OyPNqsuAMk+uJu8o26kommLqpuhbhCV/YBmS9PuuqUsyNhiz+QVfTp71*)
(*hc/VLs95AxQVVAa013efcnuSn6h3d9aNsC7XJx/qez0D0yJFTncSnaFbb/j/*)
(*zvT/UlWYMbBYmxM9v7hy8t4/nL4pivajTcTXhxmMVSnMADt5f9eChs8MigbY*)
(*cWVQfTmPHdyVkw5k6+Ykr1jjAtWi9xO9pZYURZ5leV6k0io7mjcT0R70YLYi*)
(*kqhr/aTjq7ifd2JTlsR4asXyE0924FYk8zjkC29n4cc4+zYfP0vlpy4PQTB9*)
(*+W7TXGZSdB03LZM9TxWa665sifB5u5mjJMUjN5NO5bU8Msw9mT0vRy4xZyK8*)
(*sm+6eOlweJF/5969pMhptRRFIia/aUsfIoO72IziKkU+2JU9V7elUhFjnqW/*)
(*+FAa5+iIiUUaDK/lmdqILF1Zhuu3i97sFgn9zefjy4VIt6m9KuSzrNIJPXEl*)
(*4Hkdv/2ZFTQ2t7WO7XmpXTS3Pa7ay17Ot2V8oCFvFeNUzV7QzAu1uaju5/si*)
(*2T2SoVb2DA3/duaN/Ez3+PMby3Dtk8a16+Xe8rKh7WbjmL7ISElbsXqkmLm0*)
(*6LjNc1Ps7xrhnrQMt8r2gCjEThxdfso96PyV+3ItSfNHQ7JOfY2lptzNhHsm*)
(*MddE1ebTLEMeutQbStOdMDt/USZWt6aZxthczLKuegax58UMRNkr/6bS775z*)
(*/b+Wj6iCudfWwsP/6L2AIaYCFNnTflD58UlaNX5/w3DVS8zW1FTDSauLVjm2*)
(*x/Wc4czgmfd+svO/KaoiUO8EVdWC/ajI4vN28QG10tihLfKi7clnYGKPcwib*)
(*8XT24ba9stwzKNJfbCWLRRgEq1qaEIdvWWZSqsT0id1zl+njhYatJOlTXcc9*)
(*dOQqz3Ibjpym4APH6ITW7SQ7vygnMBVlUSt39W6G/Vi0fJ2RRYKL5aHV0CP+*)
(*uzJXEhFxxWn3Pvm3g+aZlGZvb6uiqNqhbxJ/Wm/kOTkX6Ta1l4V8QMX7Zc3j*)
(*Tib1ODfNlZ/ZbNPi45GO7ViGT8ntor3ssC3jIw15k/9zNXtBMy/U5qoFPdsX*)
(*UcQUqyKqKaMdx1RlJ7rHRXJtGX6ut7xsaLvZOGcoA56L2XAmVqUVK97e39ep*)
(*57reGa7rJxcmxKuW4aqxnIpit2d7COE2cLbdmI8pwirjBj8ZUl2Tf7idLiY2*)
(*MbfETT6b0dG1bDOevBJWhZ3N6KpOkLby4/RU/x+Qz45luLhy9F5AkV+R8xnj*)
(*5HyB5r1Y9xJ14txmqIZ/Yt4eWobqWV99OdxPDBW3yIxg5lqz0diuSrj7oWK4*)
(*gasvm8O2G7y6sm0RRCwxH8aFi8X1qL1KRM4n6LIgYurp7h91LWKy9GBSsRHV*)
(*tDRaZHfKV4H3bLYTQ+6e7vvYjGtk++p8bRkOBf/GXtV7LnpXai2fq80Ju29P*)
(*PG6CKU4glnB5Ts5Fuk3tZSEfIYqsWM0YcIYnZZGkapP2GZNn8hOW4ZNyO20v*)
(*12L5eKwhH+T/QM1e0Myr4p9X99N9EWOouJnE5wnpYqvmz73+DnVvVpyHLcOn*)
(*e8vrhrabjXPEFNZcjPLjaHedtGNfwcoxtBt0r/ysPmkZPiSKT2wVF+kfnrbA*)
(*rSax3CwiNDI1loE1ToNUDyFXHVaciurRwp9zU9hqjFfOH/MzOmif6f8j8rmy*)
(*DI/eCz7ohDHvB4zRV39cWPySaOffz07rGJrcnTZ6UM+oo4+B1yzD+fw2p6/L*)
(*fc8T2T8sFHipn03K01SDnK0Y8rm4s/H0FctQTPGpYvXkacuQxiiWQ0aUZRG3*)
(*CpST8+PEkgHpE5a3NHmSNwOPhEBysNhCLMXFIyQ8aRlutyH0ZVENHw2f/lhv*)
(*pxqaJKb+Vg/MGcoDApZut6IXUp3mVQtnrziNSFWscfTznJyLdJvay0I+REYV*)
(*Dsqa+r9aSSk7kDhxl9My32UZXrWXHQ6b+WlDPsr/gZq9oJkXxT+v7qf7omWW*)
(*aP9ObXt11kuc6d782bVlOFsQ+VRv+UBD283GKbW1+TYXrqqbjH0ln50zfEQU*)
(*nwkixHedGLv7uvnnw+jrK70Q3flE5flLR//hoCwdZe1uvddShjxyZ2P2Laj6*)
(*U/3/12v5yLWz0QNqb2Tcee+p3P4QxKYkddyyMS0BqJuoH+/JUlG7VJOLDl2V*)
(*yK2Yh36543z1xs/waDVZKLwRzM2MjojM3PecEavJs6WQlbdD6yiLsaP/Mstw*)
(*1iKoh4YxT/YFy5C7JN00XbvTYz3HyDlHzGQ1n5SoSKfsFX0vu47FoCmdATwW*)
(*aOhxy1Dun1ksbTNNttqDXyvyWcu8SrY6cLSavNynKXsh5qvTv2oZrkI9i9an*)
(*jC8aR+fuUqQfm7K8LORjFptDAzKy9unUry6PSPgey/CyvexlemsZPtCQN1G4*)
(*z9XsBc28UJvz6n6+LxLIAZcr2rSceq57/JbdHShzd7Xic73lZUNjtI8H3JYO*)
(*0vPhTCzxf+/+yictw62yPSCKz1iGzDNkP3wis6VnHpiiHsXc3YMvFa7aXMui*)
(*5VTcqqVkjib9TrvEFT6QGumezvT/36/lI9dDvTFs3TKS8NF7r0T3B9CKXn22*)
(*+0w6pGmHq4RvRrvYp8a25wfjLrZObKM4mvoeVbSny9BBUvUyFv20ks7n1cV3*)
(*8TAd9mp4SdsPQ8e38d6PjM9Ybpgy5AYruUOKtxcRaUpuCG0jHojj7jVNFkTl*)
(*3o7O7ZWlw4nolJRJDuQRdmmcB94UU6x6T2mO5msvb2AJZI+f8j7b8+7ELBhI*)
(*W7KGy/sc4bQ2G4mkN6O80u9Ff929WI6HuipGUpIsDnVGN9nxWsvHNQPNYRHm*)
(*hpIF/LGSxaTZqANrpRrtarpDZ3Kj4yLlJoqYez9Sm2NE3uSD0ulafMu0Rciz*)
(*7uZ1HgbFv5+LdFuW//eakE9oYuldKLqIKVTaalvBRsfGMYWGcgkC6ql10dx2*)
(*uGwvO+yU8YGGvKqajys1e0EzL9TmvAU93xeNmRqjWfmzOf8L3WOBNp3ZYRkf*)
(*43qf1KVObi0XRtfzObxsaKw6pQfUA/51qVhKnnlGyXlv71tPTZHfXw86AW6V*)
(*7QFR7Gz236Wr0sAPsik25RCz2DH+3ooPX3yfh9sSiiEmNx41y8f8b6NgrVp9*)
(*TlLUwvHX1JZ70E71/1o+0o9Ibt7sQhFSVdgDh+/945GynU2qy7Z8GB/szehF*)
(*b3bTvWzajkQ6YdYKar7wdGzljj7Sd41qRVD9h9z5buTi5KCOh4MjnR1vK3J7*)
(*1IIzdRKbfNltphsGU3wYmlPtr/9azrloxjyiAM94OTQyepsvdoTNrojRc4yX*)
(*SITw8TF9rpJslbQUQ8Y3o03LMX0k2ojOLb1B9pZjml0uAn+J3cpduo2IdaMe*)
(*5cZJXOJiHBZnjJusG+mophh+3X/0dcLvlp94fSLC+2jx1KftXpy2G6+qRXwR*)
(*9MVOPuTH5kYHhrVSsczKaJKKT6Pjdqmn8xpibxikPA25+bFdqc2RcojbFGFy*)
(*j7N8NP6gvlIH6qtzLtJtWV4S8inigNfZ2WRid9LMI4Xdt9KxaQJNud8V7uPR*)
(*Xza3DeNcyn572c3xbhmvGvK6aihnavaCZl6rzXl1P90XSXY3dF/q3tRLyHYh*)
(*t6GRKjUsU1s+ogZl/3wOzxsak5Hsmgz/YpPsKPy5Z5QU6XcuJVMjWYQnMsNH*)
(*5qD2lO1KFKQtC4VzLrbDZHL+jgYxi0VAst2oknyKdeN4w/tPNpXR8t0lDxzg*)
(*JW1jZz0/vO4ZuFWsuyyCwlBzG5m7OJ7q/6WqiCVRKlbL0pRFIqoR/tPxe/9w*)
(*YpNHSJgm1duULzSc+5e+C2O/JDCCfmvA3O2DI1AYszDFVvgv3rI79LPMXiQn*)
(*HB6KyJ5rGVGt8w6qr+K5fmui11UM28/rjnR0k+loRaUIKE3ae/z/82UBid22*)
(*3F9Dr8TLuKzkQ6zPVn30jUWylQ4Unb/8+e+Sv180GiNYpckcTnp/NVbMCnQy*)
(*R5EH86FBcZazOk3qLwSsaNIHuLaXDZlFmNm9KOkKe974yddBPctWm5mzNyli*)
(*8nCrA+WOUonban8Z31uzAn5gSriMDr5RG223F5VTNPPiW+XQBlNG72E+zjlp*)
(*sSzOmUiXZXlJyNck9P32rLune0+m4MasMlY6JsJEj+F5Savsuweb24qT9rLX*)
(*DM/KeNSQD6qGl2xXzV7QzEfV5rwFPdsXSSEm5Clj/fl/pnvdqi8S428XzErh*)
(*xGXGZtsVzQzTghv7T+fwsKF9sIMM1t3QSdxsacrOwyeKKa/vnBrqg7U5cxYp*)
(*+kzZjkVRr7p9GbdqlyZdjhp3M979nOdf0HsBoEQK/Jtuvbx7SEpr3lydWbLt*)
(*GTJnPWjbM3P6tLs7URX2Mmmf8yovaxEC0XTDounO3wtmiMhvK3+hX4qBbmof*)
(*+qaqyrKs6kccMIaubbtnC9y3VUXfUT+6utrXZVnQ+1mgprJs528kue6mOCp9*)
(*2zRPZ2j+Kuln2BI5lA/L4Qw+Lam5aT/Q3NWUqizosVe3pTfCDl3Din7gdT50*)
(*JCH6c31y7sWjtHVV1bRa9pIaGvamqt7m9lEd6JqqYJmVh9F/C1070waizE27*)
(*ztqZSPfK8qVC/ujqanH82fbCIUNPc/fZDHxhe3m6IVNO1ezLHpk4b0EvFYH0*)
(*kLvVcK17O0nRzPEWQXucbft6Poff1NCGWphhuwup78nXiKKnCkhU8KSl9FVs*)
(*W2520EN0Vea7juN4/FzLx17a7HW2a0ifQMfslg1WVbWjcKf6fyGfnj1b8VKR*)
(*brAa77p+L+DI6V8r/jWWksE+e3uTP4fwL0q2CdJdbMovslkJAPBHU8g4hhjh*)
(*AHiQbhPNGPySDKvNI59GrtErmhWmRdN2fU+/tJKA7ROdna0MAADvyhge+a1P*)
(*fQXgrRARQVUcHfgL01RF5Ao3l7sV1F+zFjNI7/o1mhPhMwIA8Asgw5hs9kQA*)
(*AA5p80DXNMOJsd7+61KEtqYbJsMwNN3+strs6iL0HJKoTjFsN8hraAoA4Feh*)
(*DSyDDHERohkDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAofZGG5l3Rrs6r*)
(*/T6a1Lvf75oV/sZezk0WaNri/LKuLtIkieMkr2b7/trU0Kyj0Kmv0ia+fVcV*)
(*VVXvurUfzH9iqPLY1lX1LLRO4xkaqbHwhwa/7YokMFTFCF6Luj/U1+UCAAAA*)
(*/miGKpydhPPTzsWWZ1ypv2tYyIwdT2kGMlxiX7n64pgh1QyEuTY0gUlDHjrJ*)
(*Vx1Sys/KVB3flWF0lOjoWIn5ccl7Rz4JxmiN9g+KctaXwacU9cFyAQAAAH86*)
(*fdNUPjvg7ydahm3m3xVF+7pwMW9FERj0lJxotPSazeGT/HzF8XTLIWam8uyR*)
(*T7ydneRq8vNexaGoNydbGkd97tghs8qJPtSRpXIL6thOb3yT1tiPi2UxdE1T*)
(*evrLijq07SPlAgAAAIA4/+gnWoa/MfyUHMWKxyslOzze8pOyzNz54eZ3b2ax*)
(*NMw2PJ7ce/j9LnuDK4/96+o8SYuVPVfQcw6maO0tPwv+/SyoTypqm9rvWS4A*)
(*AADgrYBl+G1UJlt0DScDr/M01UnHA9Zbd7QN9WBusAnzbHnxeXp+uJWbHyYz*)
(*VCGbifPGO7rcfc9V19z9lKKO5YJlCAAAAKyostAydE3TTNu1tLX7VlPELg19*)
(*T88GcfyomobSvsoiS9fDaiB/BuQmXTdtv2ip5dPXmWdbhmFYTjBbZuzLlLzL*)
(*qeguDPKHoRuGEyw8Cvu2DF3TdNNh9ojJ39LmPklTNyw3Wm3LGNoicCyaSZ1k*)
(*Mq66fmA8KIGhyT2blpEkHYaeaYWzLPV55Jn85BLLScqViXT+60STWMwUOTk8*)
(*cYgMvsB7M6bVZP6LcI0Lznd5dFXkOaZpWSatqnwmo7bM4jjks5K6GyZJHCXr*)
(*2cImD4RlqhhhnERRShIQFhSzFWlJSY0adrTYt8IryExmrzuV57JkO3f2eRxF*)
(*MSFKi4bfE4b8Qpw3ItfCMvQK8n7fNolWmJaXrY+VGZi+6RqrnTivJ1FtLcO+*)
(*SQKXtgOiQ5YTZZUUSyxfnrIiDjJ7cTyT4SdUCAAAAHgfhtjmp6Sbns8Pfl5Y*)
(*hhnfqaDoXsAdu+jiJxlfq9geVz4NZ3rwxpdLY3fhNnen42/qGVPyjrG6gVkA*)
(*lT0mxCyoKprecjek2cSZ7SptM4/f4ieJZyz89uxHjvhsYrZaq/thaGvKYops*)
(*qHjZdMs2ZN7MUJpt578u6P2Nyb2uiSoUWVeDo8fV410ebe4Jq84kdrwQlZtw*)
(*W6jzNuc2K8ZyBrLPN7doWSctKEUz9bn4FW6azytoEvWJPB+R/FAHttgjwne1*)
(*DHXqmJq8IgTILcObqi1073bz8vFVDVdZ1SAfPCJBzRWPry3DLuUv0G3Ps8W7*)
(*uENmV8VSp/iuqCELHClguU/qZRUCAAAA3omSbYi4aZ4YxdqUj13CgJFTVWL9*)
(*kQ9/dPDtuipPYn8clE0/afou881xgDa8uOna8UpQDVWWRr413qDbfhx5YwoG*)
(*GSuHNkulaceMybbMkmhaYjW9uG7r0BJ5lFONpSEyyf/fuiJRxQuj/IGQLzl9*)
(*QInlQB6RLCt8Zo/8TUb5u3Tw6wNhHd2ZEXT+65JeHkaf7ZhIfVOErjUzvFQ/*)
(*X98mDSGn2T7/QQ0blr4a1bIUlhBbOAXH6dz7XFA79GKGcJpJExYUFaeZlA3J*)
(*qZA+M7F4Ba12shzLc83JneynhSEdLvdG5ePuas2O09S3JlXiJY7Ztm7dz+eP*)
(*kwvFMCuXtAy5w+e4jB5z6Y3enqL67tkol5pv5BdXXlUhAAAA4J2Q4Tv82Rpl*)
(*ynY7iPFX2jMRN0cGMa0kbQDht2bFcpFOWpLTRtohX1hEMoVpzqSO5HyMGKOb*)
(*ZLk1YJtmm6izQbkvfG4fyCgwH1Vorsybc7iNMcWKqfybyiwEYQlrSVHkWZbn*)
(*RSoNXTo/dv7riloY1buWYRlMFrVEXzkDSkPovhvMh9faYkZxnAM0Qmkadry+*)
(*dvMg7th4Fcor1rg1emOzNbaysgwP5Lnh5M6tG2G+9IAVAtH9MeVU2orE9BUO*)
(*kzdzzLbQiptZ7lmGvFA3U2wO4t62kxz6TFtZhkK8o2X4kgoBAAAA74ScDpps*)
(*qo/NiNxWRVG1Q98kvj3O3UkbQFga7jRebq+IqCziETHCanOzh8/t3BSr2huy*)
(*d9JcDtO9WEWdTKa+4FeM4jE3w2JaalWdIG2ld2KXOfyqoioC9U5QVS0o+/Nf*)
(*16KWNx9bZX3qL+zD1Z2ysmbGyexHLqLVUnUiArOM83VPWIbrOcOZmb2x2dbJ*)
(*Hslzy8mdO5ahu2MZ3uch2aUxTD5Vttmmv3ddP1rJq5IObZEXbT80RWKPDgnj*)
(*rzuW4eLKayp0JBYAAADgp1BF5taC2o77icdvU5yAL7mtLcOZpXF1ZTvC0uk0*)
(*vsQsXLaOLMMpzVUicmJzjAHIJ5dud//RoXeoxpVJnhM/a8acHHkGnv+6e/O5*)
(*VfZBRTG57T1hGQ4FX09fZWYzzfgJy1B9wjI8kucOx3c+ahkuiixyotopj9x4*)
(*Mm+8U9IqMdnjiuEG7vLxK8vwNRUCAAAA3orRcpgbG8sBtxHebWKZrF/aAF9j*)
(*GYopPtXmNsHTliENHy1t1yjLIj5Lozx5WNuQR+7oqXajjpG9NMbMVYzpvi6r*)
(*djj/dZV6lz1kGc780J6aM6y4k+Jqf8rGNfFHWYaUHXkevHP/zu2U4OOWoZO2*)
(*wifhpq82YDd5wl1PV+VqUi5eNWAenoPQyZVlOJtd39Hkp1XoQCAAAADAz2E0*)
(*V+YuT3JEzj7GtTDFkn6Eo2XIh8OXLcPF+nUVGvNR+AXL8KOJWKq6dqenAY+R*)
(*cx4kczQpgS5xxaZpzStG+SwP5+2IUMy0Pf919YphOnBkYdgNXdt2C9sll8aF*)
(*v7RsxUTovp9hJ3fyWPX8EW4ZauPcabtY2d9jXITd+Bk+YRkeyXP7upM7hRym*)
(*zH8Ul5bhMO1FmtXOfBdwpd9uHjMWl+VqHe6VKDfw9CvLsBPz0kQp5LsWfoav*)
(*qdBRLQAAAAA/hyaW+2GNcbtqwgLHKMwVX7rxi90QbRFqYuSt8zAo+jFy8rTG*)
(*trnSLa4Io04Jpg2zPTd5jFBMqwhzdDoEpOJ+iFOao/N/L29gCWRH1mBXuDQM*)
(*n51UO0YVIScGkxaO/01tucNimA7YNbyk7Yeh4zuj71Qg57+ukEaLnUzrquNB*)
(*1bqbjE9kIsTJOqj1+d5kYV3TfTqjbSgi1YzWzrjsfrI3ebSXyNvrJEiqflMd*)
(*Mhb6NJvXrrY8H8pzw8mdYjlYfpV0ck/0OC+6tQzriEeMZGZtl42ru05MjcOh*)
(*LdkTYmpanIEiysV3EBNbjheqjXjgmrvXNFkQleNeLbnZqgtN7osoDPUXVYhO*)
(*HqaOZTr+73pIOAAAgF+MdAogeHeD0DXnwQCVv/kffyX/1Ax9FTdO/7//JkPA*)
(*+Rm3yYZmvCLMhqGOhROgJzY7i/H67pTdQEPD+cbS4OkjkQedW3rjbNuYZpf7*)
(*irCCmDHZpTsnD1NPf4MHZM6nJT5zPqU2wm0MYp6xYHU1N8F8NrMkN7QuGK2R*)
(*81+XiCjW86Pxxu0J7DErKcosZOaKYm5sN/H4YsPFgkbGlFT8rKZC8ZhJovlj*)
(*Sq2UmyHra8uYpTsLExhU/yGj35BvB/5Q5+ti6Zpb9734fKBVPFzJ83HJy21E*)
(*N+VuWOZo5XHUoOwzceC0YgdZ2/dV6vFsxfKIGWFbLpGm3UrNxknXm2YYK0XX*)
(*/HKMJ0mdEC1LUxY3qEb4T6+qkCyFCtMQAADAe9DHzmwAlXGDyXDsx8QWaIPJ*)
(*VryHeSkHW+0f4r9ZDHXEbkuc9ZXZfgqWgNf12WqMp+/SXemD1vnLn/8u+fvF*)
(*IGwEqzTZqnfvr8byCboJepxPOwr5IkfnCTuc1v6KyJ7ngYz+c7Pq/NeFoPke*)
(*amW24NuX9n1pZJAiutFexEM+TXp6dPJQ+8so35oVyGiOQ2KvZbQfbHmoxi3o*)
(*Vvgv3vIhP8vsxRv0f/5nb5l7OtV5Ls+HJd8Fs9DmTlxmzMJXNDNMC2KlDm3p*)
(*LS1GRbPz5bxxvggHpDgRL3K/shm9vCNm86ToVlSK2Ok3zYmFQVwEU27Id00t*)
(*Akiablg03csqJDc137MdwxkAAAD4OfRtXRZFWdGjxYa2Kqvl3oe2o+E++H+G*)
(*vmna1wex0c+w7ZuqJFT1Z72t+LSk5qb90LdNU1OqsqDHkfFBn95S1Tldatzd*)
(*vkHKRM/SIw/THFXVTvH6tiKUZb27YH3+64Swe73l7FnXVAV9bUkqoDtIgC99*)
(*KrNjXw7fQVIraHrNUVrXbJ0fn3z+Up4P39lQsZS8LFRj6k39UeFTRaqbg0m3*)
(*rilpGg9s+Bi6bqbpVJlWUuhZUhU3t7tqVl+fUKGetL0zGQEAAAC/MXt7kz+H*)
(*iJeYbBOsAmJMJfJwFzo3cxBv+cfBV8bvB0fFHcLLuN5mCwAAAADwazOsNo98*)
(*GulkqGhWmBZN2/U9nblJArbZlE2yyY0zZv4GcUJqtuau2vHDWRkiGpLm2SA8*)
(*AAAAAABvTVMVkatLV66gfn25c86QOFvXRe4hFokwOGXsBW/k4C92gpjhtanX*)
(*V0xgali8T/YBAAAAAL6AIrQ13TAZhqHpdvxlE4d1EXoOSVSnGLYb5PV7z7D1*)
(*pWe7l7OAfREYln8YIhoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/L78J68E*)
(*42U=*)
(*"], "Byte", ImageSize -> {477.1999999999995, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJztvX/I/Opd9zlbXZQilK6ssj2wUp5tfQ5Ls7rKObY9HpuqFI8c49naI8VQ*)
(*7Wkb0Poj1LVLWHExUmH8sZiKmOqRKBoQh4dlFB3/GVZmUQbW/BNh40KQbCXP*)
(*QoQs5PkjfwS9N9d1JZlMJsnMXN97cmW+9/tFOf3e953JXPnk+vHK9Svvfevn*)
(*/oe3vmaxWPz3/9li8b3lP8i/HwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwF9L10jRM0zQIZkP9o2FYfjr2+b1j*)
(*6vRzxnKVnPw1D9e6xv5suPv4qpTF3lpXZalEVuxNUAweWPgbuz5QX3kXfUu4*)
(*Xmr64XoNXXfq5MVbW2NpNnXdXGfD39u6djceTt80RHtXU6RFiSTp1nY42eW1*)
(*W1WyDXMT5tMl8QlShJZeBdu0NlPEOvV0ucwEsr1P2qXP3oS9h3uuTo7WnOsK*)
(*55Ugyz0OvNkp2lqaPhL/Z20FHpc08mxdVm3vqk89S1szwjQFBIBnItsrpO1f*)
(*qKbtOuaiRil/tE2Z/nu5HyvDWbRVqw/J+1N7KLI9LQjkz8v95ekqC+XiGGPb*)
(*X5L2ltI50vbOVzpFFru61HxEdfZpXtR/SvzNkhqRvotGrz3e16nsu/YJibfs*)
(*3qmuS1O+kHbd9GS2orJEFqlv1JduXRCr545DKCYg8Zw6j1gTxDrzrFZxy3aW*)
(*Wn95b7OYWvLtMjCy3OPDmZ2KxNGG4//MrcAjUcT+xlSrjKL059iRT3O2NSe0*)
(*64ebFhAwwqS19N2Te2U+dXxW2/q1ki1snz61paSAn6t4U6Mu971hz33n6oKZ*)
(*bMvjdXuz37pqY1v6uqfTK9mWf5dU3dDkg8kp9kX3Pz9cb/fpL16Xv9ycfwbL*)
(*ncoiFU9klsvs6uq1nb/RJEnW7E4PYbAq63G5SeTelJ5sq9oJxe3JqkwiX5Yt*)
(*n408cKsc6fjlj+nOGC19uVuVAdV/7H4yZLnbwJmdct8ejP8jtAKPQLjSF5Ii*)
(*1xX+1SLH19accJxvb1hAwAiT19J3TraTFmY1JJp7TRFuiu3OkIxdqwgXeUpo*)
(*x7euWMqsXspDRv7aloisrkCOC1eRdc/T+kiwspqRoGjNSrZkbE+PDByl/D37*)
(*unBdG6VsNyku8izNBktgqzdPa5fTrUF6ALtHj137NSKX0xh1E1WkdeTyfHCY*)
(*toxaQj7bOaCVjL5rjVgHY+uvvl3dajsof0Wuq+c7+9M5mLDOfa//cBq0Llnn*)
(*kxd8JD/+OvZjf6KOf38aiqNTDF/scSIvull1quq2oNPyXpcN2LWkgwkkf69O*)
(*n8VhEFYin9VNm+oE7OSnmScMgrjv1pEbkfTc1Colo3MJJshyD6c5Z+DjZSWQ*)
(*JH2x7i9NPSk6l9OuPHj8MgfCfiY7DdaoOUtTHjiDIndtK3CG3mzWuobR+5t7*)
(*ve1F/xd1LnmgrWFf2xNS9vl2YeurH3oKyFCOGuKSjHqamJO/9pfSlObikUzc*)
(*lw+Ha7Dz92i89rv67p8Gc7CWruFoMp53ikPM+4pwGaLq76lvaa1BTFnfJ1Vb*)
(*4TS/VupuMUlrZmKcFq482mpNP5uyDEbDX0QrNvHL6X0kLFq3s+lhU112yrQe*)
(*hjDWUf/Zk02rw68+JtuXv1xFrTOfv3Yicj4ZvZBk8kipBUW2Ki+STNwrg+HW*)
(*l5htLa05zXIdnAZEGhwXyDZL9ZAEzariVkTmYYh4caKUxd5WF4vuAU2rKmt6*)
(*fWHy6nAn+tPZPu12qdCLlUmHaBMcSdtGddkbCFpwiJLser5bXbkZjcU5XpLv*)
(*oZ+SNdNokmz6ceg0sZOXzU3ry2P9oei92JFEXnSzisjW67Ig16Xi0PJelw2K*)
(*eNeaBSCTZ5zcJ+mjuUvWXX/vsL//wu/9OjlCJgnXaI9cU/rIr+t/qUs2vSoj*)
(*11VepSJLslHqVXXVErlsRW8yhuTWE6TKFOqtnm9JUTVNVXX3eHLsjbLcaM4Z*)
(*/Hi+sw+TNMpS01RL/aXpupx2dbYcy2zDYT+XnQZr1HhnH266MtIjer4V+Or/*)
(*TtpWmU5FJmkL82ilk4tfLH5s+XZVF5DcpDZjKJq9a7XD5+9vddyAjHXoveST*)
(*zxb+2lJa1aPu7Jvr3B3SI9HhpNN8+4Nf+vRRARnNUQeuz6g9iTlfwZIej416*)
(*VDPQs9WVA70fSjNWJeluehK64xrs/D06/WwRb5/h7p8Gs6f2+A+/y9FkPGF6*)
(*izCjCFm4jU2YBqt6EoPLmoODyMnL7cZu7iTr4+oWrmRLM5a0jrJgRc+qOAMq*)
(*V6Rh04Sp4bn7U8SVldHOB4LXdLgNfkW+OhSgJWuPgvJ6qku7/NqZEiT1hAr6*)
(*Y7prqlwWzR2dbyIZmzwP2Dlt//CIbWyiItmr5PDTGqzYsDlGkhk/5BuDhXBJ*)
(*xn6LZLduYr5Q7c1xRs79jdMqXKv1hjzl+K3Coun1v+soDaSzG+7loU3XVu6y*)
(*/hJavsaCVlTpP0LepyMfKb9te/hMqQJq6wyqrtdXqLr01vfnsf5QDFzsQCKz*)
(*i25WPcFTXnn+qpGwuuW9LhukbP6StA7jdXUqMspTRBtp0aWsV5PdsoocLW4t*)
(*kVssV5vGB1TXp2k55Fg6L4I+fdR0M0aVEpLy4iGxG23RreCoLbtZlhu8KYMf*)
(*Z13u5e+TsOrYpyPOw6Xpypx2XbYcvMzRsJ/LTkM1ahGtqwONVeC5zRecGSQd*)
(*bAUOs+xkc8d+tSe5xyw1Na5zHUm/7S7rCy8z8+iF93CRyA1ccuezEQucZIZ5*)
(*2sTNoc5X9U9KZeKZOZQ1dm++7RSQoRz1TBm1LzHnKthWe2du46IetzLpTPKs*)
(*nl9B06c1FzXe3Fxwj/o/y333+4L5f/bdBZ4m4+kyInLZnsVRtspMm1d5u/KT*)
(*7rjevs5/VaY6Klx1FSrb5Nioym+rvoVsSSt7sHw+Pmct3tCh1bpCPvyGTJo7*)
(*LWv1lbVaOjonJCyDYLUz8IXXnp382MSTVrlNuWMzTyqB1FY5mdVZfWpdPpCE*)
(*jqSuOtJaxHU+pxVUM92l7kUsDhM5enQ3Pxr7pjStqrkt7TVrX9RwOruRq08r*)
(*s1Rs67JGMs9Y0FptumTu/a2pKpq1zUc/cgimZJBvC+q7pjokzZfmsW4oRi62*)
(*P5GX3KxwVX+Ojc5H1Tx/rmzA6sAyKOVnQ6caVCNtSmuGp7Ha71xTkbVNlHfa*)
(*subH8iJIWpqHi6o0decG+E47YyRmnfK0VZq0FZn2EFRHqn3DHzfKcv035T8N*)
(*fbxq7hdLEq+AfVIifQijpemKnHbdwWOZbTjs49lpOLf/f/UjqrylD6jN7eMV*)
(*OXKK44f03JEXBj37IZvpG3JkM9Jx5f19uEjkBgt457P1g7xc/pDvl+2LOhxp*)
(*rktPcBXSx9iXb48LyECOOk3iVRn1X/oTM1rBlkGo1LTT9Bik+7epHCQyYp5W*)
(*S+HYB/vrmcvuUf9nOe/+YDDHao8rmowny0gRfojpBh+y6W63zmEqGuvP7rQF*)
(*UT1XTT5uSmjhOuQEY2ktzaquGVoSlSf+8tBvWj5/DffKZSzx8uZ4ln8S+p4/*)
(*8jFySPPgUz4ahGRy+LJTf1187WMid1hOqBmWtaw6vKXyuzK79bShLtenfcP1*)
(*otRu61wvRRyfqtfz18OEJfKro+nTw+kcOm3VlId1y0ETORK0dpvedvOxjxyC*)
(*yVay1OvsmKJfnMe6oRi52IFEnr9ZjRgo9vHd4ckG9bWwq86jtW3ZK9o3cFCI*)
(*owecIZGrmsUiPF6adCJyRxkjb6c8XFUdQ6xyaI7sewq7UZbrvylDH/9q/Xv2*)
(*+B/v15bl7KPsTGm6Iqddd/Alme007OPZaTi3f7VzC8YWOxxl35FW4DB+oW+S*)
(*h3RT5lO2LdThStkjcxHUB5Jvv/z+9kS475ChAt75LBlZLisU1dzuN8bxyHL7*)
(*+b28irWfHMX2kG+PfpMN5KjTJF6XUc8kpr+CrWfUdJuefdbNlse3vr8Gu+we*)
(*DXyW6+4PFc/x2uOKJuPJMlaECf6aKY98HLFu2JtZtT1NSasbwVqtVu5qtV6v*)
(*Vpu+otCQNoM4w0vgqxpmuatm61w1TN48q9ZZ5XQ/vAuv/VDDnIpcsrfqAmCV*)
(*11xCrnxPnrUOf2KHm90dopox4v7W+RlEzqKtqt1qGkbSOX7azn0fDlqn2bok*)
(*zt1gNj9emce6aR652KFEnr1Zgduubx86Le912WDA1o4CcrxG+4zItdZZj4vc*)
(*acYowqrrgwnPrnr+6V3Nd6Ms139Thj7edOl3di46U5ouz2lXHnxJZjsNznh2*)
(*Gsztid9uTNuJeQaRa/mPslxZilSPsY7XSJff375TnaZwsID3fDbxmDo0M0Tr*)
(*i4qbZoVFcxPlffn2+EIGctQpV2XUCxNzVMHWjwyX9CF0HL63BrvwHvV+lu/u*)
(*Dwfz7GPgcaiHmowny1gRTutRHTKrZFUvm+obXmzGXKohmOO73Ew50EZ2+O3Q*)
(*DC6s6DzPIo2D4Ej92KZzxrpa6OpZ6rJeY5UmcRSfm/54eIIgpzmpXy6/9qwe*)
(*4uwpTWn9AKLVU/iar0+SNAnW7SmbnY1cmk7OZ+yR24+3qsp4OgdPW0nR0eys*)
(*kaC1v72dzcY+ck2LOZLHuqEYudiBRJ6/WWk9iFMP6Ndfeia8vWc+dBe7nY6v*)
(*TkCaKxwXuUMjqNPgXCZytSuGm+PZDgvJ7beCG2W5/psy9PH00IIcTZs5U5pu*)
(*JnKXZbaT4Ixmp+Hc3vy+6s9ptuawxhfYn3mcT1oTtw4rwk6a8uYwkgEuv799*)
(*pzplsICfBLz60dzERT0Cyy6qyJI0S9bmobSxfRdP8u1RARnKUadclVHPJqan*)
(*gm11rY/1yPWIXH8Ndtk96v8s390fDuZ47XFxk/FkaT3pdLw3rx/G6Z2Kqj0i*)
(*Fed4wn9VYzQxd+gc6OO73GzLUz7Ssac5Mo+x09UWbGzdWO4aWauePkinRDPg*)
(*3tz9PKxmOcqqytbrLeoZrc0YSjPZeIjmIV07OfKya++0g4pXkPlI9R9paaqf*)
(*p8qfqz6/eCNLVvqQluWTvhUjtqtZnt0d+YpoVZ/Jfzia1cPcdVzkmi5NxS8e*)
(*8jjKik7D0QzlWMlYOjt050Y2MSzv5mjQOt9+SZxPOqCaFrNnDGskj3VDkfzD*)
(*4MX2JvLhgpt1CKBGp881VS7dwfXKbNBajKPY7PBw627D7OoeOaYBuVcHYDwD*)
(*dzMGu/vhmhQoe7Mr2fsjb2i4UZYbyDkDH0/Cw5Rve59UmczdpuOl6Yqcdt3B*)
(*I5c5Evbx7DSc2/9j83uXrhMLV9XnzmztO9wKPFRJbgzi0GKehqWe3jWe53u/*)
(*/zjH9h0yVMA79UAzFFlWUPGmagvYTK1sby7U9QMdfm1NmDzNt0cFpBjIUadh*)
(*uiqjfrU/MWMVLFkCU10da3abnnY9bM+R6wyt0jqwtwa77B71f5bv7g8Vz+x8*)
(*7VHHc7zJeKqUjtQ8bJnHm+E2w9zHSAtJ9/NmPLHMJwmJJ7vD+prFMz3aav7w*)
(*gLmgg+YGuT/G8SS21Krn1C7XfpanG+r3Dl2M30oJnXCbeSw7S31bcFywarWm*)
(*mnjZM3N79Nqbfb8V1gXoN1lQN6vZmwu6HIl+h3V4mJUN01hU86tpgZWM8lGj*)
(*zpmnXUl13UUqz2JXTRzU65W8cfsJ6PTGbutd9TXypYqfHxYBWeUHimYUhnUu*)
(*DaWzG5hmtbKkOWG4a6bPlIkfDVqrRtodRrHHP3IYSqCVQ1Y/a7M7m9bPqufy*)
(*2GkoBi+2N5GX3azksMBstWkvpl9u/PzKbNBsBEeDodKFkNI2KVoBWbbT1ylu*)
(*rbEw4oFR3Zytqk0MUvsoA3czRtNgssd8hZ1ovd3ttttNyc6PeuYh3CzLDd2U*)
(*4ZC2gq9qdIyN7A85WpquyWnXHTyYztGwn8lOg7n9sFhMWW42rcKlLP1ksK0b*)
(*aQXqI6rxi/YNOloytg/39QJXNihz+f19aG8HSheM9DJ0yceZP21P6Gogm0M5*)
(*Pkuw7jLfI/Glj/Cn+bZTQIZy1DNl1IHEjFWwDw+Hrb+JniVbpRXwQ3cHXSTV*)
(*LKWRrf1wDXbJPRqqo/ju/lAwT+8CV5PxFMlWejfTy/W2M4Q8MJqFKFuv2YLJ*)
(*WPnVs4By9G4FxXCrtfz1sujqZtGV2v6qNSdN6tn4ZW+3hjppUkgXBCOpu7nI*)
(*ix4Oj2ZH1I+Kzei8vup/0WSLYl2eyuzbE2zw2vfuUTI1VqseelD0Q0wlfU3D*)
(*7LdXUWvVpkbZcYUjOV5f41jETvseyYaXVOX5+GVm2mkeLpJds72B46XN0BI9*)
(*j2Y2O1ctyB3KBtPZobXtTCv01c5gwxmm6SZluM2mVyN5LPfbkdYs5yh5S6u1*)
(*ecOZPNYJxdBNGUzkhTcrOWSDhVrFV1ZUzbDp5JfrskG0bddXyjpID49L1Snq*)
(*TVqOi1uZ7dnjsG62v1Bx2fNvs/qvPnz7v7Uzhn6UMbRVnnk9N5w0mrue3HqD*)
(*LDd8U4Y/nodWa6ctxVxXddpgabomp/3ef7g2W/am8zg4J2E/m52Gc7vX7BhS*)
(*/pZ9jmz1pdnbXok61wrUUDE46vw/XjtQobRfVH3B/S3N5MS8lHXU3ySfXvJp*)
(*W9M4oazbnreubcbws26CS1NKevJt0ikgRHiGctQzZNSBxIxWsOyL9k47Yobb*)
(*WdBEv8I026dxg38ZrMHO36P+Oor/7g8Es1N78DQZYJAiy9qblh+2kCzyalPm*)
(*NEkysln6eRsusiSKojhOh2avFVkaUeLkpI8pT+Oz094OxyY9ZxhI0shz6tC1*)
(*959obJfpIqGX1d6ZOs9IyMrIlYxvFp6VV5OSS7p+00NyCZfvmd+bzk5aDovE*)
(*c5Kw8lYdn/6aoPF/ZORcQ3nsNBRnL/bAxTcrK3NpkpBvLzPzyYmvzAZ5Sq+F*)
(*774zRSGvC0hH8vh5kqNFQa06e2AD9kfPcpwfT2NWkZzMmOQvTc8C32WOZ6fB*)
(*3J4n9GPkA8Uzbn1fZFVdGq/1hbY+SlzdlFNfzcp497UCz3h/e9Iz3og80Lap*)
(*VYnkreyYk2SQSp+Utu6Jz+XboRx1YcJP4tCbmLMVbJXYMmOQgn1xYkZrsDP3*)
(*qPezz3j3B4J5Ye3xmE0GAE8PrteTgbuFPRdL+qpsO8v/lYTeimYB/fKFS+Be*)
(*qaddbaLIOtkqtjUVk/8lp+CYu6lgcfcBuFvieuZDd+8+8FwSbdgW+uYuiFLS*)
(*kRXuVvS1TX1Dq+B5o958lcxGPtnhoZmPJ5tb1AWPxN1UsLj7ANwn7DWdksze*)
(*97lQt/OuasBjkHtru/0WKlnV3S16454I1dtppZPXWbJZ9+RdmHTPAGW5Q5Z4*)
(*Zu6mgsXdBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAp8Hd/93e73e7/ArckCILyv//4j/8o*)
(*OiF3BosYix64nDJuCBoH/0gRnYr746//+q//6Z/+SXRTBsDT5d3vfvcC3Jj3*)
(*vOc95X9ffPFF0Qm5M1566aXyv+94xztEJ+TO+MhHPvK+971PdCruj5dffvnD*)
(*H/6w6FTcH1/zNV/zxhtviG7KAHi6fPzjH//85z//f4Nb8rd/+7ff/u3f/ld/*)
(*9VeiE3Jn/Mmf/EkZN9GpuD9+5Vd+5fXXXxedivvjrbfe+pmf+RnRqbg/Svv9*)
(*rd/6LdFNGQBPl49+9KNl3SU6Fc85X/3qV8vn1r//+78XnZA748///M/LuP3r*)
(*v/6r6ITcGb/8y78sSZLoVNwfP/zDP/zjP/7jolNxf3zLt3wLRA4AgUDkJgAi*)
(*xwdEjg+IHB8QOT4gcgCIBSI3ARA5PiByfEDk+IDI8QGRA0AsELkJgMjxAZHj*)
(*AyLHB0SOD4gcAGKByE0ARI4PiBwfEDk+IHJ8QOQAEAtEbgIgcnxA5PiAyPEB*)
(*keMDIgeAWCByEwCR4wMixwdEjg+IHB8QOQDEApGbAIgcHxA5PiByfEDk+IDI*)
(*ASAWiNwEQOT4gMjxAZHjAyLHB0QOALFA5CYAIscHRI4PiBwfEDk+IHIAiAUi*)
(*NwEQOT4gcnxA5PiAyPEBkQNALBC5CYDI8QGR4wMixwdEjg+IHABigchNAESO*)
(*D4gcHxA5PiByfEDkABALRG4CIHJ8QOT4gMjxAZHjAyIHgFjuSOTyJIqSTHQq*)
(*eIDI8XFnIpcnSVb0/qXI8ykTcn8iNxi6IpswcvcncvOIG0QOALH0ilwS7CxD*)
(*XdQo2nLr7QxF8ydtjg6kwcZQ5TIl0nIvJgXPxoxFLt+7psxus6RYq91uZepu*)
(*IDpVFROJXBHahmGapmHQ/6v+xX5lrvzkknPEe7tMqu33PmgUG70sRVY4VfGZ*)
(*QuQeI2iMkdAV0br8k7UNHy/dY0wgctGWhs04DZthWusrojanuEHkABDLicjl*)
(*G1Oh7bq63odpmsaR71a/UfaC+sPi/crUiG4oltd7QBoGSX9fyCyYq8gVWypx*)
(*iukGUeRtbIneZmMbi05YxTQilwcO9Vh1aVvs6UXSlo5js2cHY3M+GvFuWR7p*)
(*BiPFI1+XLrfQvElK0AQi9+xBY5wNXR6uSGXk9Bf8x+X2Ipc5tCpV9aVVVaqy*)
(*aTv20qAPU8blBW9WcYPIASCWjsh5Nq1elGV07EXR1ix/6wnqkSspaMMxIHKx*)
(*vpB26dRJupyZily2JzdbtprGgLXOm3guTjyNyHmWLJlbes2FS6VkFdE/FJ60*)
(*kM4+vLDeD30TnfueZFmKsmxPkE8nELlnDBrjwtAlVFqs/c0jd3ORyz15IW9p*)
(*+WIV2kJbs7/4S+ny4Ya5xQ0iB4BY2iKX+Q57SOyTotyWFlb/yNEU5IE7JHK7*)
(*Zfk4q/hzsY8eZipyRUh6iSTz0B6QhkY7aySTMYnI5a6mV08o6Y51jFQRyH1d*)
(*dc7l+JQ++hiXBC31rGk6PG8vcs8YNMbloUtt8h3mrQN3a5ErH5Q0y2f/3i/J*)
(*xevr6up9Wx8Ylz9ldnGDyAEglpbIFWudjK1J+qbXifI4CFPylywOVlapANrO*)
(*39JPyOsoJ4+YG9adR89hb2mtFNuaqum6pi2DohSHlaqo5CdznR3Oo/tJ5BoK*)
(*G6nZhK3aLI8cvT4lG9ztilziaGw8cCGrqqKY242lki8sv0Q1VnSuV+qZWvkb*)
(*Vf2f/vjvdytdkTRn761MiQ0HWduml7FIPFOpzqYYziPOaJqpyOV+NSimr/Pm*)
(*VzuB3a5dJl7skJBu54VkbC//SB6S5wt5uWv/Mt67Va6VFVlSD91Tua+1nedm*)
(*TLnYgSNojJ7Q5XU9sJAURVJbhT1wSeSM9W0jN+Fih5hWQNLmqllxlBnGDSIH*)
(*gFhaIsce3xZaZ657kSVJSsiyrPzPf2KN0RHLfeo75Nfm2kvSslahJ1LdrPxw*)
(*vKfHs/l1RRKsyd9kOy2f3I8UTWezaxaKU4lEEdK6TttFaRpulF6RK5L9bufo*)
(*5Qcle7Pde1GeRTazE8WuZ83lW3Ii9Y//10+3v1CS6m+26TmTrUTOv4nTaMWm*)
(*rzzeKNhMRe7hIVxVN0E21/Pxt4ZpRa7Y0MeS5e6KxnVH+1Usr5VTSK9m2XQG*)
(*RZHtbI1MSDg8mlRTpNzgtsGeUOR4gsY4DZ1PKiAjSMtCvNPImP+hsGe+Teum*)
(*1U0DN5nIFdGaPgFb13vcHOMGkQNALAeRyz1mQEetEnkAXLc7xUw6MYPV3prj*)
(*k24sz0//n4109FTOnjcXJqnec9p4Nc0Z/VG2s+bfZR3Eus6qT6nsSJ927zXD*)
(*DfHG6BE5SkDO0pq/x6Z+1echc5NITUaSnXk2c7c9kbxiV03T1vy8oKfXgyzP*)
(*yv/RKSglziM1uLMVuTII+yoI5e3r74kVyKQiVwStJ46KNI7ipCSOo/If6Ul8*)
(*qmefdpFheUyvsnRqLOT2CdkcVOvGax6mE7m+oNXkUeDttjs/SsvHuagbvNPQ*)
(*ZeQ3ksHKXLo1JLM1Zyzz6HxO+6aBm0zkwpXWqc3Kx+W4ymolSZYPlcU5xg0i*)
(*B4BYTkWuT5YSi9UedX3tO2q7qyHZmYeuLQrr6qHPhtmxyGUtkXvYW8TB6l1N*)
(*qiPpl0SV1B3G/OwhkaPK1+73qOafKLZff1Bmf82qk1TTVOpmSN6lKbvAsvmr*)
(*uurKf0nK+pGGV2cscg/N2lWiH+uJ9iu4kClFrlqGqRzN74r2Lt31RrMdx1TJ*)
(*w4qzb084YjlWWreXBsWbSoy15S5M8uMd5HzaX6w6t93gZTKR6w0a+X20JWXS*)
(*sLe7rWOSQrbsTrk/DV35MMV6yeWlu0uyY5epaqfb7oA0lchlbHlIe1JcHnus*)
(*FOrm0jLpc7Jiej1L8ecYN4gcAGI5HVrtm+5SDQk1j4Edd/IspSNyOVs3QUZX*)
(*x0Tu+DytI9mD5EIP60opu0bkyudSNrhbtpdbncwvHzhJdV32nrQ7zQqyR2eG*)
(*Iue7TitiaTW7UbZmtfZ3SpFjfWXdeQUPuSOXubWeoE50vz3Drf3occB3D7MG*)
(*ZN1tD58xkRvaReexmEzk+oNG5162ZTV0dbO7gKondEXi6dIhcu7xgLU62PX3*)
(*aEwkclXlpnX6+7P9ciHZ1e/yiCzhWugnYwJzjBtEDgCxtFetevX0spMF62dE*)
(*jg2DSubBAJnIKcM9cmnPeU5FTt7VX3GdyJX+Rp9vVYM8rLp1x9qAyCleGhmL*)
(*ow7AB9LN6K7Hdga7gvmJXLqUjuv2hKqvctshmGuZUOSqPudVZ9sdOm7ViBz1*)
(*Fi0sWn89LhclRRrHWZHHvq1X/ZyK4zd/ZSJ3oouPzFQi1x80Om4oH5XHPPLC*)
(*Ts7qC12WFWXNsbGrwC3UQz9S3bN009mF04hcul/SS1l3s5pvlfFowlREq96e*)
(*zBnGDSIHgFiO9pHL64UMmntc7eZdkWNDq824JxthaVUg0ZqYEd0XlNU8tZLl*)
(*AR0HqHYLYUOrPSJXz7JT60awGlq1D21iA2scNymt0Zr6Kt7Uy1kPaxay7knY*)
(*t+hhkbPBjoVqV5uoZaQCXD/SjmqzE7ncVzpT7uM1i9UTFbmE5hbpdKMGmntl*)
(*zbItg25Jra7ao885W+jdHiPL9uZCrbp2o+2y8/RRz1R/LubIDQTNK/VOOtu1*)
(*exq6zJIWK3auPLQ6/U5sk5PnYo7cltaA5skuNB2RYx2bJ4+uc4wbRA4AsXQ2*)
(*BC7iXb1Pux3ULzbNoh3ruq8fD6vKpLVULXPoxyTdJUekHt2gbMn+vKeDBLJu*)
(*b7f1tgzl6Y3lNvp/6RO9XO9Am7ADt/RjbD4w0SxnG4a7enWlunR2nYdLNrCr*)
(*mlb5AfsgJ9XUkfYm89UarnpicEAn8rGtnKrHZPodmk6/WnUf6yl2biLHdjCg*)
(*K4LZopPI1vobF7FMJXIF86u+DknSIyeZmyRLo4C1wHrbwgKH9bAd7I7lMZtN*)
(*pWNLoQ8PDmz2Qu8+jY/JJCI3GLTLRO40dHTSfv0kVW0OWZfAjG7B19nm5dGZ*)
(*QOSKZMvqQPtE5i8TuTnGDSIHgFh63rVaxOvl6RYjsmGvY1I/pK52mJChuc3C*)
(*gdhu/X6hLJtHxiLa1H3+C2uzY/JmWH/8v/y3h8MNx21N85Doq2fynXVIBjuD*)
(*pOjurjshP63Woi5U62hr9IRMj1Pb3U6VyLFTVZboNZ1uwdo8JEh9zDdjzk3k*)
(*SFug6Eb7fpUWt+rp7RTLBCKXByu5HQVJ3R51w9Kh1boxLWj+ORrtYj0erWGy*)
(*IlrVYWV9yvZh4JGtp77xXhAPtxe58aDRR7DOm1aKJDlx5G7osmZokAXQ3h0e*)
(*K9jDmnvjt9XeWOSylX4UNnW5PcpqxyLHZqf07BI8v7hB5AAQS4/IMfI0CoMg*)
(*DKMoStLswiHGlC2hP62087T8LTsNnUN0afLKz5EEkA+UbcHwU36eZd2T0jeV*)
(*m0ePokzkVHufZc1pu98Xkx0AHrnHZG4iV2TVpedZGkflPb7ijkzJxBsC90EX*)
(*O9TLnFkXbqdZpCsgjjvZioIGNoqPCwLbQufWm8g9TLshcA85XQyurZqL9x29*)
(*d0/aTujyPC8jlyYkcse7ldAprLcX4Ak3BO4h3RnNYoecjYy0YthmbnGDyAEg*)
(*lkGRu1fy0Nvt/SjyyPNsZxp2PdFuihdJt5mbyN0LwkXOW9HRfklWSxTSelqb*)
(*kx1aivCi5pKNlE2S9wSL3APpJTfYvi26oSmK4Q5c9WWhozNy1RvPKyQIFLnE*)
(*W9M5mBJ9EY5CJqasht+xMrO4QeQAEMvzJnLZ/jBeeLLDbbRhrxPaTPwWA4gc*)
(*H8JF7lJSj70JabDNzOh7TKbKeOJFjpKltHd+vLP3XOhoL6i0iaaInNgeueuY*)
(*U9wgcgCI5cd+7Mc+/vGPf/i54UPf8d7/8p2LxTu/+Vv+/cvHf/nv/t03lzXf*)
(*O9/1rvLP73rh339wwkS99tprH/jABxRFmfA7nwc+8YlPlHH77u/+btEJuYSX*)
(*3v9fffP7v703W7383/wX73zhW79tsqS8+eab5QPaZF/3zAyG7uVv+3fvfNd/*)
(*/W0vf2iadPzQD/3QG2+8Mc13PQZzidsrr7zyla98RXRTBsDT5a233vrMZz7z*)
(*P4Jb8sUvfvGDH/zgL/zCL4hOyJ3xhS98AXHj4Cd/8idff/110am4Pz75yU9+*)
(*6lOfEp2K++NjH/vY22+/LbopA+Dp8rwNrc4SDK3ycTdDqzNjJkOrd8c9Da3O*)
(*CQytAiAWiNwEQOT4gMjxAZHjAyLHB0QOALFA5CYAIscHRI4PiBwfEDk+IHIA*)
(*iAUiNwEQOT4gcnxA5PiAyPEBkQNALBC5CYDI8QGR4wMixwdEjg+IHABigchN*)
(*AESOD4gcHxA5PiByfEDkABALRG4CIHJ8QOT4gMjxAZHjAyIHgFggchMAkeMD*)
(*IscHRI4PiBwfEDkAxAKRmwCIHB8QOT4gcnxA5PiAyAEgFojcBEDk+IDI8QGR*)
(*4wMixwdEDgCxQOQmACLHB0SOD4gcHxA5PiByAIgFIjcBEDk+IHJ8QOT4gMjx*)
(*AZEDQCwQuQmAyPEBkeMDIscHRI4PiBwAYoHITQBEjg+IHB8QOT4gcnxA5AAQ*)
(*C0RuAiByfEDk+IDI8QGR4wMiB4BYRkQuWuvycj9xep5L5iFymbe25IXqZWMH*)
(*FYlvaXKZ2oWkrf10qrT1I0TkronAWEg9d2mYFYZhh/ltktuHcJHjyEW+oy3O*)
(*Zc5bI1rksq1jyBJBVo1tOBaLWZVTiBwAYhkWuWRJ6gktKKZO0vOHcJGLt9ai*)
(*QhlrKzNPJU2D4cXR2iS33/ZEthECRO7iCJwJabqVFm2Wya1T3kKwyF2fi/LQ*)
(*ZZHcP12Ry1faooMbDIRjZuUUIgeAWIZELvNtVpkYm3j6VD1nCBe5PImSJKBV*)
(*/ojIFWud2IcbUncvAtqwGAJv/+Qid0UExkO6M6WF5viB7xH2QTypoAgVOY5c*)
(*FJmVuahPV+SSDfGxXVSQrOUZ7DFAcfriMbtyCpEDQCwDIlfWFfVjoWwJ7ri/*)
(*f4SLHCVzlFGRS2gnkmRE9S88i3xguZ+yM+mIqUXu6ggMhDTdlX6nWJs4E9Od*)
(*LVLkrs9FRHolTRvPnJMgUOTS/VK1g+bHPKBdlLLdU/fOr5xC5AAQS7/IJduy*)
(*ZnC2a5WqnBNMOL/neeQuRC7z7E4ngG+rVOS9qVLYZWKRuz4C/SHdmodhVcVw*)
(*48ltTqDIXRvDdE9GqLdJslKftMh1KXx1oEduhuUUIgeAWHpFzrPkhWSV9ral*)
(*XfySvsFEuWfhLkSONalKqzkIXK3zm4mZWOSuj0BvSPO9a5uGLh/mOhkTPwkJ*)
(*FLnrYph7Zfy0VVj+y37aPXIdWI8cjUyXGZZTiBwAYukRuSIoH/DMHemoL8IV*)
(*61fYYXj1GbgLkWMDNO11yqnXbTImZmKRuz4C4yEtwp3N+uYkc3uD9A4iUOSu*)
(*iWFOeuEUl0ruuXH/SZiNyLGFD4fB0zYzLKcQOQDEcipy8cYoq4V1EMdRlMR7*)
(*NrqqOsHQGcBZ7kLk6gGaQwPBmoynI3LXR+C8fmSBK00+0VSgyF0ew4hMw5X3*)
(*VVxS1iO3F/rAOBORS3ZLOqGlP1fNsJxC5AAQy4nIJVZrTKhF/+MhuIS7ELmM*)
(*Pte3n/SFz72ZfI7ctRG4pB8pd1Uya33Kriahc+QujGFm99czC0lfi5rIMQeR*)
(*K6J1GQR93TOoyphhOYXIASCWjsjlvlNWpdv2+qfcZ51yS7FPy/fMXYhc2YJ0*)
(*+o5YA2Fun8qq1esjcNGAoE+U5an0yF0cw2xtaKrWUA1BK6qqGitR46viRS7d*)
(*K2T4Y0zJZlhOIXIAiOVY5AoyN+NkaYNHK4qF4mDxKh/zFbkiC30/StkNT2ln*)
(*rFzPh2R9syKnR06+j9xYBLI49IPOCtR+kcvT1rYjdJsv1fFvnPIjhO4jN5qL*)
(*jvJbm5xF0he6qkqwyGV+mVUU+9DVFqxN3aVzWuZdTiFyAIilLXLJ3l707UeU*)
(*bKtN5cwtxld5mIfIsVd1yJuWjPh0ZlKjIhnpj13I5rY8IlyTqZKaK3Ju5PRv*)
(*dhiMAF1fSSJlt3tLekJa7aQt6xsvjPwNXU9oT9xXIvbNDiO5qJPf2h+q5sg9*)
(*1cUORbKvXuwgK4pMkGgnpe2TiMy8nELkABBLI3IRXePAaFcL1daUrb8JrWvv*)
(*EuEil7Mp9zX6qm5YLdZALKx63DzaLA+HOTux284IeddqfwRqkWuGtIZC+pBW*)
(*64Oq4mJtpu8pEf6u1aFcdJrfaooN2elI84V2+osTuZ73cxEkk72vYeblFCIH*)
(*gFiG37UKHg3hIjdIkedZqJcP/q0lckWWxkmSzWAcXYjIPQxEIM8yv2xu5Usm*)
(*GORJHMdJmgtqX4WL3MNQLurLb/NB/By5IeZdTiFyAIgFIjcB8xW5h3xHHvZn*)
(*uiRZlMj1ksc7lbx6eJ6hOmIOIjfArPPbfEVu3nGDyAEgFojcBMxW5AJHXSh2*)
(*NIOH+l5mJHJ07ba1m2dD2mW2Ijfz/DZbkZt53CByAIjls5/97E//9E//Ibgl*)
(*tm2/8sorX/7yl0Un5M5YLpdl3P7oj/5IdELujC9+8YtvvPGG6FTcHz/xEz+h*)
(*aZroVNwfr7322ttvvy26KQPg6fLRj35UluV3gVvy/ve/f7FYfMd3fIfohNwZ*)
(*r776ahm3d7/73aITcmd83/d9X5nlRKfi/viu7/quMsuJTsX98cILL6BHDgCB*)
(*/MAP/MAXvvAF0al4zvnnf/7nb/iGb/A8YVuv3yl/8Rd/Ucbt3/7t30Qn5M74*)
(*0pe+9NJLL4lOxf3x5ptvfu5znxOdivvjxRdf/O3f/m3RqQDg6YI5chMw2zly*)
(*M2dGc+TuitnOkZs5s50jN3MwRw4AsUDkJgAixwdEjg+IHB8QOT4gcgCIBSI3*)
(*ARA5PiByfEDk+IDI8QGRA0AsELkJgMjxAZHjAyLHB0SOD4gcAGKByE0ARI4P*)
(*iBwfEDk+IHJ8QOQAEAtEbgIgcnxA5PiAyPEBkeMDIgeAWCByEwCR4wMixwdE*)
(*jg+IHB8QOQDEApGbAIgcHxA5PiByfEDk+IDIASAWiNwEQOT4gMjxAZHjAyLH*)
(*B0QOALFA5CYAIscHRI4PiBwfEDk+IHIAiAUiNwEQOT4gcnxA5PiAyPEBkQNA*)
(*LBC5CYDI8QGR4wMixwdEjg+IHABigchNAESOD4gcHxA5PiByfEDkABALRG4C*)
(*IHJ8QOT4gMjxAZHjAyIHgFgakcvDta7phskwdIJhLm13vQ2TXHQy75t5iFzm*)
(*rS15oXrZ2DFbx5Algqwa23Ds0AkQInJF4luaXH7vQtLWfjp67FhIPXdZlybT*)
(*MOxwwjIkXOSuiaHIQHUQLXJXlL6rInxrIHIAiOXQI1dkcbjTFhTFWG22m7Vr*)
(*KOznhbkORKf0jhEucvHWqm7kQhkWuXylLTq4gUiXEyBymaeSxtHw4mhtkobS*)
(*9vpbyTMhTbfSUSCXya1T3kKwyF0cQ4LQQHUQKnLXlL6rInx7IHIAiKUztLoz*)
(*aMtk+81vghX91ULeCX7su2OEi1yeREkS0Cp/WOSSDWkRdlFBjvcM1r4qjkCT*)
(*m1zkirVOLtsNC/pTQJtWI+47dDykO1NaaI4f+B5hH8STRlGoyF0RwwfRgeog*)
(*UuSuKH3XRXgCIHIAiKUjcr5NHvUUy2sdEpu0VrGEPvTdNcJFjpI5ypjIpful*)
(*ah/6XfPApf5uC7zrU4tcQnuHJCOqf+FZJGTL/VAv0UBI051MCtEmzoobpnYY*)
(*kSJ3VQxFB6qDQJG7ovRdnUtvDkQOALGcF7lsz8ZXbV/wjKn75S5Erkvhq0+s*)
(*Ry7z7E43CCsO8tFzzdEnekO6NQ+jhYrhxpNLikCRuyqGwgPVQfQcuRbDpe/6*)
(*XHpzIHIAiKVX5OTlNiuKPM/icG8yjZOMUHQ1e7/co8ixPgFtFd44VWNMLHLp*)
(*3uo8xQSudtJB3aY3pPnetU1Dlw9znYxg2gn8AkXumhiKD1SH+YjcSOm7Ppfe*)
(*HIgcAGLpFblTLHTHPQN3KHJs6vVh+EYIE4scG6KSl/vmN6nXbTSPGQ9pEe5s*)
(*1uUkmdsbpHcQgSJ3fQwfBAaqw2xEbqz0cUX4tkDkABBL/9Dqckfm3OZZHOyW*)
(*ajX8Ye0Erie7b+5O5JLdsjzUEbpk9WFykauHqA5NJGs0eUWOHhG4Ej3plFMN*)
(*BYrc9TGsEBKoDjMRufHSxx3h2wGRA0Aslyx2WLLBD9lGrxwf9yVyRbQuj9PX*)
(*IgdVGZPPkbM6fR18c+SOyV116rIjdI7ctTFsEBCoDnMQubOl7xkifCsgcgCI*)
(*5QKRewgclYkclq3ycU8il5K1LaojrFFoM7HIlW1op1OIFQdze+Wq1WN8u3wQ*)
(*eio9ctfH8MD0geogXuQuKH3PEuEbAZEDQCwdkWPO1t5H7uEhsdl6B8XBCx74*)
(*mK/IFVno+1Far2PJfI3c/cPDfrA2dVfYXtCT7yOXWqTzudkyMaE/KuzHLA79*)
(*oLOwsl/k8rS1mwbd5kt1/IcJEbqP3FgMO/lNeKA6CBa5kdJ3FLfRCIsAIgeA*)
(*WI5FLnM1+rRnrKIkSdM08rdm/XIHF+sdeJmHyCV0iFzetGTErx29VJEi2Vdb*)
(*y8uKIhMkOjtS4LYz07/ZIfMdEgBzW8YoXJOtsDXWkuZeFSm73VvSE9LMp7tD*)
(*yPrGCyN/Q9cT2hP3lYh9s8NgDI/z2xwC1UGgyI2XvnbcHkYjLASIHABiab1r*)
(*ddXaB6CFpGiGtYtgcfwIF7mczSSv0Vd1w2pVmm7t/+PpG4Lo3TcF7hgv5F2r*)
(*0WZ5CJSzqzuPKpFrhrSGQvqQ7tsLvzVrM31PifB3rfbH8Ci/pXMIVAdxItfz*)
(*fq526TuKG2UowkKAyAEgls7QKrgFwkVuELJZYKiXD/6iF6j2IkTkHshAVhon*)
(*SXY8kyDPMr9sbuVLJhjkSRzHSZoLal+Fi9zDQAxP8pvgQHUQP0duiL5y2h9h*)
(*EUDkABALRG4C5ityD/mOPOwL3i9uCFEi10se79QyUpt5huqIOYjcALPOb/MV*)
(*uXnHDSIHgFggchMwW5Eja1sUO5rBQ30vMxK5nLwyydrNsyHtMluRm3l+m63I*)
(*zTxuEDkAxAKRm4DZitzMmZHI3RWzFbmZM1uRmzkQOQDE8v3f//2yLP/n4JaU*)
(*Fd3Xfu3XfuADHxCdkDvjgx/8YBm3r/u6rxOdkDujfDp78cUXRafi/ijz26uv*)
(*vio6FfdHWb99+ctfFt2UAfB0+dznPqfr+p+BW/KHf/iH3/M932PbtuiE3Bm/*)
(*+Zu/WcZNdCruD8MwfuRHfkR0Ku6Pz3zmMz/1Uz8lOhX3x+uvv/7222+LbsoA*)
(*eLpgaHUCMLTKB4ZW+cDQKh8YWuUDQ6sAiAUiNwEQOT4gcnxA5PiAyPEBkQNA*)
(*LBC5CYDI8QGR4wMixwdEjg+IHABigchNAESOD4gcHxA5PiByfEDkABALRG4C*)
(*IHJ8QOT4gMjxAZHjAyIHgFggchMAkeMDIscHRI4PiBwfEDkAxAKRmwCIHB8Q*)
(*OT4gcnxA5PiAyAEgFojcBEDk+IDI8QGR4wMixwdEDgCxQOQmACLHB0SOD4gc*)
(*HxA5PiByAIgFIjcBEDk+IHJ8QOT4gMjxAZEDQCwQuQmAyPEBkeMDIscHRI4P*)
(*iBwAYoHITQBEjg+IHB8QOT4gcnxA5AAQC0RuAiByfEDk+IDI8QGR4wMiB4BY*)
(*IHITAJHjAyLHB0SOD4gcHxA5AMQCkZsAiBwfEDk+IHJ8QOT4gMgBIJZekYu8*)
(*zVJXFhWyYW8Cf6UodiokifePKJHLIs/SZNX2zh7orS15oXpZz988d2mYFYZh*)
(*h/kNEjqAEJErEr8MGsn4krb2B7N8Fm4NVZYIsuFsO5G78CQ3QrjIXX35ebxx*)
(*lopEPuH4fblwEkSLXLZ1jCpLqcY2HIuD2AzWASIHgFhORC5xNInp23ofxEkc*)
(*7Nc6/cVCsYXVsHeOAJErIqs2ccUaE7l4a9XGrvSIXLqVFm2Wye3SfIIAkcs8*)
(*lTSOhhdHa5M0lLbX00rmobvooLnZlSe5HYJF7srLTz2XGons7IIsLyZL5ilC*)
(*RS5fad085QYDNa7oDNYBIgeAWI5FrtgYpN2W9NVxv0u+1suKFiLHiYgeuSyK*)
(*knBjnhW5PImSJKCtQY/I7UxpoTl+4HuE0uwnzQKTi1zBHlrckOpEEdCm1YhP*)
(*jtsai4XqRFl5WO65Omt27aor6dKT3A6hInfd5Sc7+hwhGUPOMiUiRS7ZkCy0*)
(*i0iWSjyjenZ2+qIiPoN1gMgBIJa2yGWezaqP/Wn1ke3KFj0U+bh8x4gaWs19*)
(*+6zIUTJH6RO5dCeTj2/iTMyNn1rkEtr9KBlR/QuPdmsu951uyNRSNP8QknxF*)
(*O7Et1ity6UluiEiRu+ry0x3tNpa3U/bzDiNQ5NL9UrWD5sc8oF2+ct9slhlk*)
(*sA4QOQDE0hK56kFPXu77Dix2ti1u9sp9I2yO3LOJ3NY8DKsqhhtPbnMTi1z1*)
(*INPqBvFtMoQlnwtg4KhNjxz3SR4RgSJ3zeVX/f+a4xVFlsRJNuH0y15Ez5Fr*)
(*UfjqQI/cHDJYB4gcAGJpiVy8ZJPjxFUIzyv3KXL53rVNQ5cPc3aMYNqmdmKR*)
(*S/dWJ1yBq10QwNwlDWnVX817ksdEoMhdcfm5pyw6SNY26h42IfMROdYjp63C*)
(*0z/NIYN1gMgBIJaDyGVVvSqwi/555T5FrqEIdzbrm5PM7aMncoSJRY4NUbV7*)
(*pFOv22ieUoQr4rib6FlO8rgIFLnLLz8PHGZv5mqf5pnnVFMNV5GwjrnZiBxb*)
(*+GD0Su0cMlgHiBwAYjmIXE478xcLve8xEDwLdy5y9IjApePu1pSr4yYWuXqI*)
(*6tBEskZzNIC0H1t1T8a5rjrJIyNQ5C6/fJY5F4pTe1s9tUOckMxE5JLdsoyD*)
(*M7D8Yw4ZrANEDgCxtIZWM5t2yQmsEJ5XngORqwYQp125PPkcOavT13Fu9lFB*)
(*VnMvjPbeetef5PEROkfu0suvRE5dNVMvw5Uutv6Zg8gV0Zo8Ta8Hn6bnkME6*)
(*QOQAEEt71Sp7sltIZm+XfuJt9rHo6cj3yXMhcmV7IS8Wz3OPXNmGdnodWRNp*)
(*Diyq3JPy0t1F+dqT3AKBInf55ec+HVptPRqwwdYn3SOX7kmWckaH8meQwTpA*)
(*5AAQy9E+cnS7Cdr0dxeu5mQikLTDqx24ECxyx292yOLQDzorUPtFLk9b247Q*)
(*7apUx79hck+YfB+51CIFQK7zeUJ/VNiPnbj5ZIa5sm9KRBaYquHnZ04yDUL3*)
(*kRu9/CILfT9KWRRDOivuEJlkS7Y9NHfChESwyGU+yVL2oe4N1qbu0j1JjuIm*)
(*PoN1gMgBIJbOmx1Sr5qBrBiOFyV5UeRZ4q3JnA1L6Obhd40okWOTbeT2CoV6*)
(*qeCx3SVL2jRsWn5XjXzJ+sYLI39D18XZEzex07/ZIaPdRGXEykCEa4OsHGQt*)
(*6VHcCs+pduFXFEUmSGy6VzZ+kqkQ+2aHkcv37SqK7JEhpuYmGWviv3mgLwZ2*)
(*TpsKgSJXJPsqS8l1lqJ5iu1p04mb8AzWASIHgFhO37WaRzujsy+ApG0CWBw/*)
(*Qt7ssGpvHCLVO4c0ez7UQzM5W8VQo6/qFiHdq63fa9Zm+hwg5F2r0WZ5iIaz*)
(*q9S2FbevMsU9wdzGZ04yFcLftTp0+X793jir7sr0V8YhgqodCd1yXJzI9byf*)
(*ixZbk2Wp07iJzWAdIHIAiOVU5BhpEoVhFEdRnGIX4GdFVI9cL3mW+WWzITsX*)
(*zHfMkziOk1TUCzCFiNwDGchK46S7P+01cRs8yTQIF7mHocsv8jwjI6p2e0lm*)
(*nsYkm4mvZ8TPkRuiL24CM1gHiBwAYhkSOfCIzEvk4p3a2vdszogSuV7uKG5z*)
(*ELkB8h3pXOrfIU048xW5eccNIgeAWCByEzAjkaO7BVq7eTYIXWYkcncVt9mK*)
(*HHmXmWKL2/H3DLMVuZnHDSIHgFg+97nPffrTn/4pcEt+9md/9tVXX/25n/s5*)
(*0Qm5M1jcPv/5z4tOyJ2haZqiKKJTcX988pOf/NSnPiU6FffHa6+99gd/8Aei*)
(*mzIAni6f+MQnPv7xj38/uCXlk/573/veMtSiE3JnlA1rGbePfexjohNyZ7z5*)
(*5puvvPKK6FTcH6WQlAIsOhX3x3d+53f+7u/+ruimDICnC4ZWJ2BGQ6t3xYyG*)
(*Vu+K2Q6tzpzZDq3OHAytAiAWiNwEQOT4gMjxAZHjAyLHB0QOALFA5CYAIscH*)
(*RI4PiBwfEDk+IHIAiAUiNwEQOT4gcnxA5PiAyPEBkQNALBC5CYDI8QGR4wMi*)
(*xwdEjg+IHABigchNAESOD4gcHxA5PiByfEDkABALRG4CIHJ8QOT4gMjxAZHj*)
(*AyIHgFggchMAkeMDIscHRI4PiBwfEDkAxAKRmwCIHB8QOT4gcnxA5PiAyAEg*)
(*FojcBEDk+IDI8QGR4wMixwdEDgCxQOQmACLHB0SOD4gcHxA5PiByAIgFIjcB*)
(*EDk+IHJ8QOT4gMjxAZEDQCwQuQmAyPEBkeMDIscHRI4PiBwAYoHITQBEjg+I*)
(*HB8QOT4gcnxA5AAQC0RuAiByfEDk+IDI8QGR4wMiB4BYGpHLw7Wu6YZZYRiG*)
(*Xv60tNz1NogS0cm8b0SJXBZ5liartjdyTB7vTVWWCPJy5RcnB3juspUr7DC/*)
(*XXq7CBG5IvHLoJXfu5C0tZ8OHZaFW6OOm+FsM66T3AjhInf55YdbR5EWFNl0*)
(*99nIobdHtMhlW8eospRqbMOxYIjNYB0gcgCI5dAjV2RJuNNZnSqpS9txXcdk*)
(*dQWpZQ0PNseLAJErIkupbp1iDYtcuic3WFKU+j5rq/D4gG3VzFYsp8wFAkQu*)
(*81QSEMOLo7VJgmJ7Pa1kHrqLDpqbXXmS2yFY5C6+/HBF6hvD3ad5Fu5s8iFz*)
(*O3Fi2wgVuXyldfOUGwy4nOgM1gEiB4BYOkOrO4M2/bbf/CaLtnUFowcT9sY8*)
(*T4jokcuiKAk35qjIFWt1IS13tBeu2Nukceh03+1MaaE5fuB7hH0QT9plMrnI*)
(*FWudeKsbspAENOcb8clx27KYqE6UlYflnls9/dh+dtVJbodQkbv88jO7dBDZ*)
(*aSqVrVF+UPHE9cqJFLlkQ7LQLiJZKvEM9vikOH3BEJ/BOkDkABBLR+R82pp3*)
(*m/50x3p3JHM3dfqeC0QNrea+Pd4jl0TRwc3Trdy5xelOJh/fxNnpiOsUTC1y*)
(*Ce1+lIyo/oVHuzWX+043ZGopWmsQOl9p5HMW6xW59CQ3RKTIXXH5mU3+ouyq*)
(*v5R+Qno2AzF5jSBQ5NL9UrWD5sc8oF2+st3T0TaDDNYBIgeAWC4SufL3jsoG*)
(*kNApx4GwOXLnRK5Nult2RnO25mFYVTHcePIWdmKRyzy70w3CioN8LoABLR2s*)
(*R477JI+IQJG75vLzlVp19XtZaTIWPWw/aXKPET1HrkXhqwM9cnPIYB0gcgCI*)
(*5UKRY3075V8ET0e+T+YvcrG3op2uVsvT871rm4Zez54jwzcTa/zEIsdcoh2u*)
(*wNUuCGDukkKjsZEu3pM8JgJF7rrLT/dqa0qYau/E9cYR5iNyrEeuO2GVMocM*)
(*1gEiB4BYLhW5wGGVrSV0Vu2dMm+Ry9qzrCV9daLqRbizpWpsfdK56BOLHBui*)
(*kpeHTqHU6zaapxThijjuJnqWkzwuAkXu2ssv/OXhOWHd4y1TMhuRYwsfDoOn*)
(*beaQwTpA5AAQy8U9ck7VIwePu555ixwhT6OVWU2E3PSNoWaBK9Hxmynv/8Qi*)
(*Vw9RHZpI1miOBjBelnFR3ZNxrqtO8sgIFLnrLj8P6PoGw9SqQXx9FfQcNhUz*)
(*EbmETnJwBpasziGDdYDIASCWC0WO1S0YWuVj/iJHyekQzVCnKx1AlO0p7//k*)
(*c+SsTl/HudlHbH6+0d5b7/qTPD5C58hdfvlsjpzqk+hlK71aqOmJm4U7B5Er*)
(*ojUR2uHOyTlksA4QOQDEcpnIJUtWy+prsZNY7pQ7ETmydG5k9Nwnu0U8zz1y*)
(*ZRva6XVkxcHc9q8H3JOeELWzXca1J7kFAkXuisvP6WZoqluLW0oXsTa7uAhA*)
(*vMile5KlnNGh/BlksA4QOQDE0hE5tv6uvY9cWeFuRgfdwFkEi9zx1nBZHPpB*)
(*/430SVN62MgrT1vbjtDtqlTH7/vcrZh8H7nUIks75F3VRib0R4X92ImbT7ov*)
(*WzMNssBUDdq5NHaSaRC6j9zo5RdZ6PtRSqOY+3SO/mEfOdbX9HRFLiMBUexD*)
(*V1uwNnWXjjW34zaDDNYBIgeAWI5FLnPpZBXZWEVJWhJ6m3rVoroZfWUMGEGU*)
(*yLEBcbm9QiH3mJRTu6MboMmas/XTPAs2SzpJqRrTYRK4kPWNF0b+hra59sTP*)
(*/NO/2SGjc0HLiJVNZrgmu2NrrCU9ilvhOdX6EEVRZALtsK53hBg8yVSIfbPD*)
(*yOX7dhVF+rBQrEkUJbd6Z0zqDs/wnwaBIlck+ypLyXWWkg79k8dxE5/BOkDk*)
(*ABBL612rq9ZGEy1k1VphicMzIeTNDqv2xiFSvXNILSR0aKaaFFejuPvW9vDH*)
(*W0No1mb6PCDkXavR5rCOUnfqDTFacftqtRVPF3MbnznJVAh/1+rQ5fv1e+Ms*)
(*VqPkkcNyqUT/S94DKLLPX5zI9byfi4bFZFmqGzfRGawDRA4AsXSGVsEtENUj*)
(*10ueZX7ZbFSvRirSJIlLkrSvLcgT+qdcUDshROQeyEBWGidJdjzr/jhunCeZ*)
(*BuEi9zB0+UWeZ6G+WNitJZl5SnNZIr7DX/wcuSH64iYwg3WAyAEgFojcBMxL*)
(*5OKd2tr3bM6IErle7ihucxC5AfId6VwSOX46wnxFbt5xg8gBIBaI3ATMSORy*)
(*8uofazfPBqHLjETuruI2W5Eja6kUO5pBJ1IvsxW5mccNIgeAWF5//XVd1/8F*)
(*3JJ/+Id/+MZv/Ma/+Zu/EZ2QO+PP/uzPyriJTsX9UYrchz70IdGpuD9+9Ed/*)
(*9LOf/azoVNwfH/jAB37nd35HdFMGwNPlox/96Kuvvto7eRs8Fu95z3vK/774*)
(*4ouiE3JnvPTSS+V/3/GOd4hOyJ3xkY985H3ve5/oVNwfL7/88oc//GHRqbg/*)
(*XnjhBfTIASCQt9566+d//uf/D3BL/vIv//JDH/rQn/7pn4pOyJ3xe7/3e2Xc*)
(*RKfi/vilX/qlN954Q3Qq7o/Pfvazn//850Wn4v547bXXfv/3f190UwbA0wVz*)
(*5CZgRnPk7ooZzZG7K2Y7R27mzHaO3MzBHDkAxAKRmwCIHB8QOT4gcnxA5PiA*)
(*yAEgFojcBEDk+IDI8QGR4wMixwdEDgCxQOQmACLHB0SOD4gcHxA5PiByAIgF*)
(*IjcBEDk+IHJ8QOT4gMjxAZEDQCwQuQmAyPEBkeMDIscHRI4PiBwAYoHITQBE*)
(*jg+IHB8QOT4gcnxA5AAQC0RuAiByfEDk+IDI8QGR4wMiB4BYIHITAJHjAyLH*)
(*B0SOD4gcHxA5AMQCkZsAiBwfEDk+IHJ8QOT4gMgBIBaI3ARA5PiAyPEBkeMD*)
(*IscHRA4AsUDkJgAixwdEjg+IHB8QOT4gcgCIBSI3ARA5PiByfEDk+IDI8QGR*)
(*A0AsELkJgMjxAZHjAyLHB0SOD4gcAGKByE0ARI4PiBwfEDk+IHJ8QOQAEEsj*)
(*cnm41jXNMCmGodcYBHMT5qJTesfMQ+Qyb23JC9XLLjzc1xYL1fZvm6hRhIhc*)
(*kfiWJpffu5C0tZ+OHjsWUs9dVqWJlCd7ygI0A5ErfBIZgrZcJ6OHCgxUB9Ei*)
(*l20dQ5YIsmpsw7GCek0uvTkQOQDEcuiRK7Ik9i11wWpfd71eURzLKH9WhDbo*)
(*945wkYu31qJCuUzk8pUmkaMt79ZpG0GAyGUeKQGS4cXR2iQNpe31t5JnQppu*)
(*pUWb5bjMPC7CRc6zSRSNlRcHaxJE1RlUDaGB6iBU5MoSt+jgBgNl9eJcOg0Q*)
(*OQDE0hlaDRyValvQPiZeawtjP3nSnh+Ei1yeREkS0Cr/IpGLNiZrStSnJXLF*)
(*Wida4YYF/SmgTasR9x06HtKdKS00xw98j7AP4gu7QR8HsSJXRGsSRG1Fg/gQ*)
(*uiSKxqY3ioID1UGkyCUb4mO7qCBZyzOY3SpOXziuyKXTAJEDQCwdkfPpo3S3*)
(*HyYLtnuB9cTdI1zkKJmjXCZyCekk0XTtyfXI0QtfSEZU/8KzSMiW+6FeooGQ*)
(*pjuZhG4TZ8UNUzuMWJHbmhI1tzqK2Z4ESbZ6gig6UB0Eily6X6qtx+c8cImd*)
(*yXZPR9vVufTmQOQAEMtZkcv2trUXPAfj3rkrkUutsp0wdmnoPjWRyzy70w3C*)
(*ioM8GIT+kDKTqYZdDTeeXFKEilxmk5gsbL8OSu7RXyj7k4wnPFAdRM+Ra1H4*)
(*6kCP3PW59OZA5AAQS7/ILbdJmhAiv3zaW0Lkno07EjmfHKSHZfPr209N5NK9*)
(*1bnkwB3vluwNab53bdPQ5cNcJyOYdgK/UJFL6CKHlrZVY3+nGU98oDrMR+RY*)
(*j5y2Ck//dH0uvTkQOQDE0ityHSyhM2mfA+5F5HLaC+fQKdbZ0xM5NkQlLw/T*)
(*QVOv22geMx7SItzZrMtJMrc3SO8gIkWuCPWutqX2mYwnLFAdZiNybOHDYfC0*)
(*zfW59OZA5AAQS6/ItWqJfKPLJnrkno37EDnaBEtWdetTj4mcyEUuE4tcPUR1*)
(*uGTWaPKKHD0icCV60imLkEiRy+mCynZMsmpodbwrWEigOsxE5JLdsnmeOuX6*)
(*XHpzIHIAiOXsHLk82GxGdzQCZ7kLkcu8Zj+NDtI6EjN7afI5clanr4Nvjtwx*)
(*uauSWetTFiGhQ6tV/9uuEbJa7U7nyB0jIFAd5iByRbQug6WvewZVGdfn0psD*)
(*kQNALBetWiWDblt319vTD85zFyKXBytVUbUaNnNJkpTyl64vpnWdWOSqfTNa*)
(*nUKsOJjbK1etHuPbZSyfTI/cQ7Ghm2McVkjldN6+dH6DuOkD1UG8yKVkha/q*)
(*jCnZ9bn05kDkABBLv8h1t/+NDTJTDv1ynMxZ5LI49IOe9YJF4PTlhEmZfB+5*)
(*lE7Ul+vepGrePvuxL1D9Ic3T1m4adKq/6kwaRrHbj7DZ+E2XUUoHCqsx+iIL*)
(*fT9Kq/AID1QHwSJH36Wi2IeutmBt6i7dk+QobmO5VAgQOQDEcixyxcYglYKk*)
(*u3HKlq0mUbinr3sQueHkvTMPkUuWtP7ftGWk2hqibD66nQCZ9+QWOzyQtpTo*)
(*q2xuyxiFa/JOE421pP2B6gkpWySykPWNF0b+hq4ntCfuKxH9ZoeMbitOw5KH*)
(*dIsRLaAR8u0qiqX6ziFQHQSKXJHsqxc7yIoiEyS6/IPt4tKO28NILhUERA4A*)
(*sTQiV0QbZWCOVG9DDy5HuMjlbCZ5jb6qq/3aT04nmbMRHLE9JELetRptlodA*)
(*Obu686gbqMGQpvv2wm/N2kzfUyJa5MhUjGVTm8j6Lq52FfGt6rdk4HUGgeog*)
(*TuR63s9FkEz2+HwUN0p/LhUERA4AsXSGVsEtEC5yI+RZ5petiOwI3cGrHyEi*)
(*90AGstI4SbLjiFwTqDyJ4zhJc0Htq3iRIxQpicHxqHOR5xlZHG1XSzIFB6qD*)
(*+DlyQ3TjRn/Xl0uFAJEDQCwQuQmYtcjFO7X9QqU5IUrkeplzoDrMQ+R6yXek*)
(*c6l/hzThzFfk5h03iBwAYoHITcB8RY6uKLTmuh55RiI370B1mK3IBY66UOxo*)
(*Bp1IvcxW5GYeN4gcAGJ54YUXvumbvuk7wS353u/93lJIfvAHf1B0Qu6MsmEt*)
(*4/bSSy+JTsid8frrr3/rt36r6FTcH6+88kpZVEWn4v74+q//+k996lOimzIA*)
(*ni6f/vSn33zzzf8Z3BLTNMv//uqv/qrohNwZv/Zrv1b+9xd/8RdFJ+TO+I3f*)
(*+I0vfelLolNxf/z6r/96GTrRqbg/Pvaxj33lK18R3ZQBAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQA//P8xR*)
(*vtI=*)
(*"], "Byte", ImageSize -> {558.9999999999995, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJztvV/I/dxd6Lmp3s+N74tFKUzBYpWm4vSfSts3ba1ai8HSVmvTUo82tQVr*)
(*HGttpsWRyFxsR8GAMulhIKCk4mwP79mtNlfhYBANDJkOmYHcZCBTSEdzIAM5*)
(*F7kIwzNZayXZ2dlJ9t7rffZayS/fD/X19+wnO8/KN+vPJ+tf/ut/9zsf+Xff*)
(*t9vtnur/+4H6H/jfAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2yI/*)
(*7nVN13UNoXe0P2qaEeZz3/ctXcXf0/aH7OK3ZXxUFfJrzfbTu1KWBkdVFoUa*)
(*UTKdqHqOIzvi415RT9erqarVJi91TYWkWVdV/VhMnqPqXbud3vJXH0ni24ok*)
(*7GoEQTXc6WTX1240ydZ0Jy7ZJXGDVLGhNsHWDYdFrPNAFetMIJp+1i99phOP*)
(*Hh7YKjpase4rnHcCWe55oM1OiWso6kz8X2sr8FxUWWiqsoCrcnV/uKtSfS1t*)
(*zQxsCgiwPgpfQs3tTtZN29J3LVL9o6mL+N97f67YFIkrN18S/csGuyp8nPfQ*)
(*r/f+7emqy8HuHM0dz7y3H3mertRWhe4rsuXnZdX+KgudPZYQ1Utmrz312789*)
(*du0MSV1y72TbxinfCd4wPYUpySSRVR5q7aUbAZM6cVmcQsGALLDaPGIwiHUR*)
(*GL3iVniG3P7xYOzw3BAfl4Ehyz0/lNmpyixlOv6vuRV4HnJPGlTlknnPNVK2*)
(*NRf064eHFhBgBqa1NA1lUGcNKyQVXNha0M4M8bNJjsrUtbou19qMPnqlZdgU*)
(*dmm89h4jc+vjVdPxXVvuBEc9jjyF3H7kWMq665XN87Slx/pD57qClVZT2qWA*)
(*510uzKaAK17oKPUzm2IOHtmiQ111il0ifV3YbEM2CMXjKZpMIpoM/mYZ2U2O*)
(*tMIn1Bxps6WvtJsyIIfP3RsEWe4xUGanMjQn4/8MrcAz4KEcIqia1jcoM7zj*)
(*KmnamgvO8+0DCwgwA/Na+n4KT9jpzVhbGXSlpispniZoXq/UVGWO6F9SW5br*)
(*3FW31wX6bb/dLtoye56fq2J4nt5XooPRDTEkR1LnCppLcWRVFnkxmel9oyum*)
(*Sr9ouBrqvRoePXft97hTiWM0TFSVt5Ery0n1q6OWoe8ODuglY+xaE9KN1vtt*)
(*aDa32ozqj9B1jfzN8XROJmxw39tfXAZtSDH45g1fKc//HPlxPFHnn1+G4uwU*)
(*0xd7nsibblabqrb6HTR292UDci35ZALR75vTF2kcxY07F21rIlsROfll5omj*)
(*KB27dehGZCM3tUnJ7PMJgyz3dJlzJr5eVwJZNhbr8dI0kqJrOe3Og+cvcyLs*)
(*V7LTZI1akjSVkTXpTve2AlcYzWa9axi98DKUdoJDsm0ZN71dV5xteMkTbQ35*)
(*syMhJd/vF7ax+mGkgEzlqCluyaiXibn47XgpzXEunsnEY/lwuga7Xgbna7+7*)
(*7/5lMCdr6RaKJuMBVKfLHCs1daqa3+ehofQeCETVz5rq2eo+ltocLyjdqPpl*)
(*fi4TV+n6iKR9NHvFVXIgk3isaw8+l0fmbf+2dkzGv5M5vc6q9pjCrz88JL17*)
(*c/3akTuFqFtcEMX620pUFYf6ItHAfR0Mu73EwjWU7jT7Y3QZEGGyw7lw9vIp*)
(*CYrRxK1K9NPY4+7C4irflHe74QFdQyYqanth4uF0J8bT2T+tu5fwxdZ3XJC7*)
(*4AiKm7TZfSJo0SlKoh2EdnPlejIX53SP/g7+lqjo3YOpqIdpbHWxE/fdTRvL*)
(*Y+OhGL3YmUTedLOqxFTbsiC2peLU2N2XDarU6w0vi+hhoQxR+nDuElU79C3y*)
(*+9//9/8jOkJECVdwv1NX+tDH7b/kPZkqU6Drqq9SEgVRq42muWoBXbakdhlD*)
(*sNvJLnUKu8tCv5BkRZFl1T6f6PigLDebcya/XnrmaUy/LjVdtTRemu7LaXdn*)
(*y7nMNh32a9lpskZNPfN006WZfr/rrcB3/xNqzkQ8qxSlLS6Tg4oufrf75P5/*)
(*buoClJvkrv9fMb1e03f9/la9Gtdtj7Um+p1GL/miranCoyH1qkfV8rvr9E7p*)
(*EfCgyWW+/cX/4dfPCshsjjpxf0YdScz1ChZ1HTjyWc2Az9ZWDvh+SJrSZAFB*)
(*tfOL0J3XYNfv0eV3q9R9DXf/Mpgjtcd/+J8omgy2jJYaQhWTK9ScOI8OTXgk*)
(*m9TAJ3cS965jdsEjPTnD/Jy5+F4Kx6SIDviskjVhT1Ued62GHM+FZPzIoOtW*)
(*mvwT5eGUZ/ekCYjq62ku7fZrJ61w1g6O4x9zr6vlSDQ9/DQlaE5ZRuScuEe6*)
(*eZDUnKTKfBkdftnhXDlkvoigp0+lo5EQ7tGgYpV5xy7mO9l0zvNOGTpWLz8f*)
(*jg5y+bCXPxW1/XcbpYl0DlKEG472HAd73/4RnKXnglY16T9D9POZr9R/zT19*)
(*p2595d4ZZFVtr1C2cakcz2PjoZi42IlEFjfdrHYKnngIwkPnPW1jd182yMlc*)
(*FOEYp8fmVGj4oEocYTekrsoyb99EDhe3njvt9gena4JlO8RpOeVYPOCOhb9l*)
(*mDGalKCUV0+Z2ZmCakRnzcfDstzkTZn8OulYrj/P4qZTGg9lTpemO3Pafdly*)
(*8jJnw34tO03VqFVybA7UDlFgd3/gyujbZCtwmjEl6h75yEe5R6/NMG1zHUq/*)
(*ae/bC68z8+yFT9HdaGV85c/EJQ/amoQETtDjMu/iZmHNanrhhDrxpLGua+zR*)
(*fDsoIFM56jVl1LHEXKtg0e+bGkB306odc9HxXN+iHbjH6VO6i5pvbm64R+Pf*)
(*pb77Y8H8X8fuAk2TwZQZdyp8knTRqPNJ2WSnRgmGA0Z+e8ub+3iWn9taSzTR*)
(*sUlziw9jS2+y3h0hWWtq/tHUkanTTvYwL7N3e2W9xgWP78d1EIx+nrnx2ouL*)
(*H7t44lquy+pkFkHjbMqhRJPimm8da+2OLUE+DCqMKm2zFq4TuqkLbV9ZdRqU*)
(*H6lqyrNBVUzXkOluLYxF/6Km0zmMXHtakaTCbbM3yjxzQes1o4Luh64uS4rh*)
(*lrNfOQVT0NBfi9q7JlsozbfmsWEoZi52PJG33Kz40H6PDPsmzTRpqmxAqp06*)
(*KPV3Y6sZrUHVeG+2nnbwPVuXRMVJykHz0f1YXwRKS+fzTRkZDjqHVj9jZHqb*)
(*8rxXmpQDGiWPmiPlsX71B2W58ZvyX6a+3rSwuz2KV0S+KaAn5dnSdEdOu+/g*)
(*ucw2Hfb57DSd2//f9qlQdPEzYXf7aN0JneL8ubi0xJ2Gz37KZqqDjuz68++8*)
(*vy3NNerjq34mC/gg87fPzmL9Q+nv+xd1OlI/1k2zLaGetLF8e15AJnLUZRLv*)
(*yqj/eTwxsxVsHYTGBgdNj4Y6ObvKQUBDsXmzkoh8cbyeue0ejX+X8u5PBnOu*)
(*9rijyWDJTKl5Sk20CYCo265rtXPDm8I7rH6TY3OAeF574/x8Cr62N/Z6U7yn*)
(*FnGUWbg/dcjVTxnTc0smjsziMAinv4YP6fS+FuAYza3dD6qMm699zp1OC6AU*)
(*zTD2TU+qUP+twuw5tbw/XnY6tsvohg1iu3hqftrVyG9Pk0/QR2ezT6fTOXXa*)
(*pvWM28oaJ3ImaP1mtF83zn3lFEwJf9KuDCJWfHMeG4Zi5mInEnn9ZnVtsWSe*)
(*3x2abNBeC7nqMjmahnnAT8CnVvvsmWLKnZq2vorPV3ZcuNNZxij7KY8PTfcH*)
(*qRy6I8cefB6U5cZvytTXv9t+Th5yU/9oGJafFFdK0x057b6Db8lsl2Gfz07T*)
(*uf27g1swN1f8LPvOtAKnXnrVyZ5yp86npF/odKXkKbWK2gPRX7/9/jZ3GZuk*)
(*oLkT9fZkAR8EHA1Z1hWKrLu+o50PWfYfmeurOIbZWWxP+fbsk2IiR41cwl0Z*)
(*9UpixivYdqrGsOnxi2G2PL/14zXYbfdo4rtUd3+qeM7XHnc0GSyZKzWI8Egs*)
(*QzxP5PBKu0mJI7V372HZOBwO9uFwPB4Ozlju68i70YFr62RvP/KM7omsvTuX*)
(*+1TdeO2nQn3pTplvtHnOqK+5Bl25j54oTr8ih+vDnVu6wcfxBvE1uJOBGzKz*)
(*VxvPpHP+tIP7Ph20QUtxS5yHwex+vDOPDdM8c7FTibx6syK7X8U9DRq7+7LB*)
(*hCCdBUQ6qyuuuFNvZei8O11mjCpuHvCJY3jNI8fo+qMHZbnxmzL19a47erBp*)
(*yZXSdHtOu/PgWzLbZXDms9Nkbs/CfvvVT8xrcKeeckj7gyEJ7eDdfI10+/1F*)
(*f5/0s4nG5Crn6QI+Mlc8C0hr3c32ay8q7RoLEk0nKcfy7fmFTOSoS+7KqDcm*)
(*5qyCbS39lsf2gTaP1mA33qPR79Ld/elgXn3yOg/1VJPBkrlSk7fDBWiGwKFd*)
(*6DE2btV15jd9++eB7YaPJwayx+h6rQ94mlyVp1E0bluDI1G6szRJr80eO3ky*)
(*upMXRfr2ay/asbORDJy3mq1Ygzl4VZblWXTsz3gb7PbQdeW9xn4nf74hk+bT*)
(*OXnaxkPOZtrMBK3/1/vZbO4r9zRSM3lsGIqZi51I5PWblbejA+1IcftHr4R3*)
(*9MynTlF70L0zCEh3hfPudGp3VByc29yp1bPYOR8c3wn2eEP8oCw3flOmvp6f*)
(*Ku2zKRBXStPD3Om2zHYRnNnsNJ3bu8+bXotu/b4xvyT4yhN01puEc1pQc9F6*)
(*doehDHD7/W3mSQp6M2c19+WRbawmC/hFwJsfdSet2qE9clFVkeVFdtRPpY3s*)
(*h3aRb88KyFSOuuSujHo1MSMVbK8Dea7facSdxmuw2+7R+Hfp7v50MOdrj5ub*)
(*DJb0fH5gd2X7yImDkzQLSCXrfL50U0i7y7TwFNLzwHbbZdQPLuSZBU0DG3QT*)
(*RY6panuv86PGsdGjdzd4SgI+c+RTb6irm6s5Rfcoqlwcedu1D5oeKah6W72R*)
(*jtP2qaH+uenZSh1RqGuGvC4SeE/21GwmyQ13yqqSQ3um8OlshgbZn2Henbru*)
(*OCmsnso0KapBXd2NERjZXDoHDOe5dTGs7+Zs0AZ//ZY4X3SzdI3UyODITB4b*)
(*hiL7PyYvdjSRTzfcrFMAFTwVqqvlcCtwZzborWWQTHJ47NpuXNzd70Ra3jJo*)
(*AzCfgYcZg9z9+IgKlOl4NX44sz/4g7LcRM6Z+HoWn2bMmn7WZDLbzedL0x05*)
(*7b6DZy5zJuzz2Wk6t3+v+9zGIhIfmu9d6ZOfbgWemiR3jfapkboMSztVZz7P*)
(*D/92uxpClCVJJF1Fsn2RiMkCPqgHujGuuoJKnaYtILNuCl/fyccnPK7Xm/x2*)
(*mW/PCkg1kaMuw3RXRv3ueGLmKli0gqC5OtLsdv3Jatyf7zQYs8N14GgNdts9*)
(*Gv8u3d2fKp7F9dqjjed8k8GQWku6Rwr9fF/IbsjyHGEnqGHZDVTVtyZDl0CC*)
(*qh7JJeRnGx2fHqN2eABUQyHRzick5UY7JXF/DIsyd7DFWnjFbi8lSljOHfl0*)
(*0zq7lmbe2sjE19lr73adlcj2J2F311W9mfy2wwso8N8wTo9soqZru2Z6Ki4j*)
(*glYLdZsZLjtM2uoC1VeV10ztUtsVhWnf8y9vrNvu6aygPyqF5WnZglF/oeq6*)
(*90kXylQ6h4Hp1lcKihXHXjcVok78bNB6lYB3Gh6d/8qpjxqXxyLoxg7Qnc3b*)
(*J7JreewyFJMXO5rI225WdloSc3D6K273TljemQ26DZpwMGS8dEtws6oXkH0/*)
(*fYPi1htkQeqVtC1I2zGbm2cZeJgxujaKPMxK5ERH1/Nc16nxwmRkgPthWW7q*)
(*pkyHtBd8WcGDN2jfttnSdE9Ou+/gyXTOhv1KdprM7acVNNLecXqFS9qH2WTz*)
(*MtMKtEc0vfT9G3S24saP/XZJHhl6uPH+Bs23zrdcGVnHOnnJ55k/70/O6UA7*)
(*yFghSbBqE8VCfxE/NV/m20EBmcpRrymjTiRmroJ9ejrtgouMKHOlXsBPPQx4*)
(*jUm3EkE0/Oka7JZ7NFVH0d39qWBe3gWqJoMRxUEd5jOx3Q4CUUZaN3XeDbqt*)
(*UbRD2BivpHb7SNRImt0s+G3XTjbxwcs5w0NvfpEwsiGDb/bG0HBS0IM2IWs7*)
(*c/Dm4XNH9gZn1cP4y7x6VMf6mvSxvXomr923z/64QiqyUz+BeoqpoB5xmMP+*)
(*Ukul2WykOC/jghWMtUdVavXvkagFWVOEzt9Jo1xmmyrzujXQVpB3Yxb4PIre*)
(*7SiD71Axmc4Bvb0pTkjNjj3TGabrDCTY3WY0M3msDPuRVgzrLHl7o7fC+0oe*)
(*G4Ri6qZMJvLGm5WdssFObuIrSrKimXgiw33ZIHH7VYR0jPLTE0pzinYnh/Pi*)
(*Vmd78tCn6v0/KNnkKa9br9Qe7r7azxjqWcZQDmURjNxw1E55I7n1AVlu+qZM*)
(*f72Mjd4OOJJ+bOq0ydJ0T0779//h3mw5ms7z4FyE/Wp2ms7tQbetQP0p+R7a*)
(*gkcx3dG5RtdagRbcFp91cZ9PvW6Q+i8DvXp/M/dyz43d9Oysy0u+bGvibtWS*)
(*agbBsRUILSyGCa7lJBvJt9mggCDHmMpRryGjTiRmtoIlf8i3+jdMswfrQfCf*)
(*0PX+aezoP0/WYNfL4HgdRX/3J4I5qD1omoxlURVFf8vc025qVdlsCZpnWYG2*)
(*6r3ufFWRJUmSpvnUTKSqyBNMml122eZpbwrT3JHo2Gz089EkzTyNTV37+Inm*)
(*9jitMpzY/r6oZYFCVkeuZn6r2qK+mhxd0v37f6FLuH3H5tF0DtJyWklaooTV*)
(*N+D89PcEjf4rM+eaymOXobh6sSduvllFnUuzDP31OotenPjObFDm+Fro7jux*)
(*ArRZdT6Tx6+Tna2p6FWTE9v/PnuWo/x6npLq4WL2G31pei3QXeZ8dprM7WWG*)
(*v4a+UL3GjZeroqlL06O6U45niWtbT6yIRR3vsVbgNd7fkfTMNyJPuG3qVSJl*)
(*LzuWKBmo0kelbXjia/l2KkfdmPCLOIwm5moF2yS2zhioYN+cmNka7Mo9Gv3u*)
(*a7z7E8G8sfZ4ziYDAJhA9T4aYLWQpz9BPdTNVf2/mjg44Cyg3r7uA1gr7RQa*)
(*J0mMi10Te9Pq6F8kB5yzmgoW7j4A3EPavWHcSaHtfPFJHLKBs+5FSY66a2Lv*)
(*gN/TMTZmB7xotPsQorewXCwD7+ZWifrUpkzAvaymgoW7DwA3Q16FJojknWo7*)
(*2V126QaegzI4mv3XjoiyarvQ57QRmjcAChevDCOTltH7xvArx6S9B1niNbOa*)
(*ChbuPgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAvPN77xjT/90z89Ao/k29/+*)
(*dv3fb33rW7wTsjIcx4GgUVDHjWQ54C7+4R/+oQ4d71Ssj6997Wvf+c53eDdl*)
(*AMCUN77xjTvgwbzlLW+p//vSSy/xTsjKeM973vPyyy/zTsX6ePe73/22t72N*)
(*dyrWx5vf/OZXXnmFdypWyZe+9CXeTRkAMOXzn//8pz/96f8PeCT/8i//8kM/*)
(*9EP/+q//yjshK+PrX//6W9/6Vt6pWB+/8zu/84lPfIJ3KtbHBz/4wT/+4z/m*)
(*nYr18YY3vOE//sf/yLspAwCm1OL0y7/8y7xT8YLzz//8z/WjWe1OvBOyMv7y*)
(*L//y9a9/Pe9UrI/PfvazH/rQh3inYn287W1v++pXv8o7Fevj+77v+/7u7/6O*)
(*dyoAgCngTgwAd6ID3IkOcCc6wJ3oAHcCNgi4EwPAnegAd6ID3IkOcCc6wJ2A*)
(*DQLuxABwJzrAnegAd6ID3IkOcCdgg4A7MQDciQ5wJzrAnegAd6ID3AnYIOBO*)
(*DAB3ogPciQ5wJzrAnegAdwI2CLgTA8Cd6AB3ogPciQ5wJzrAnYANAu7EAHAn*)
(*OsCd6AB3ogPciQ5wJ2CDgDsxANyJDnAnOsCd6AB3ogPcCdgg4E4MAHeiA9yJ*)
(*DnAnOsCd6AB3AjYIuBMDwJ3oAHeiA9yJDnAnOsCdgA0C7sQAcCc6wJ3oAHei*)
(*A9yJDnAnYIOAOzEA3IkOcCc6wJ3oAHeiA9wJ2CArcqcyS5Ks4J0KGsCd6Fif*)
(*O5VZVlSjv6nKklkq1udOk3GrCnZhW6E7LSNu4E7ABhl1pyzyDE3etUjK3g08*)
(*TVJChuWxTx45mizWKRH2Pp8UvDYW7E6lb+siuc2CZBw876CrdsQ7VQ1s3Clx*)
(*TU3TdQ2hY7Tm35puHLObz5P6Zh1FMxzV+8pR64JkxExKEAt3qmIcNf0yanXY*)
(*DuHtYZuLW5Uc618Zbvx86Z6DgTs9V2Z7WlLcwJ2ADXLhTqWjS7gplY9+nOd5*)
(*moR284nkc+r1Sf2DrqAWXjKC0QPyOMrGH/cXwVLdqXKxN0m6HSVJ4JgCvs2a*)
(*m/JOWAMTdyosnLtldW80+VzUTcvca1gptRtjkXr7+mg7mikh5bHWp50SPL4Q*)
(*MXCnMrKwb8t70yBPWYKytyyTPONozq1Z6GrcyviA7o41XvCfl8e70/NktqeF*)
(*xQ3cCdggA3cKTFyipX1yriKJq9efBpz6nWoqXFdPuFOq7gQvZ52k21moOxU+*)
(*utmi0dW/pEF00qVoKAt3KgNxJ7r4kkke2ylH8ptwL9zYz0ke81UnuXZgtq/1*)
(*VDQfnVUZuFNgiILu4oxS2VieDuTqq0DYCTc+ZN0Ytwx7guE/vIQ/3J2eI7M9*)
(*LS9u4E7ABum7UxFa5FFozENKU9gZ4+MRLCgje8qdvH390CaFS2nwR1ioO1Ux*)
(*6ggR9FMVjOp25aoBMIOBO9W6qBgh+be/Ry6pHpsAhKY6MQA3IMcPHNotccsD*)
(*g0HP3uPdqbQVtXmSyj3SZ9JcfhmqsnVbNXF73HIT/Q390f2hj3an58hsTwuM*)
(*G7gTsEF67lQdVTRoI6jOqIaUaRTn6DdFGh2MutVVvNDF3xCPSYkepBzSaYXP*)
(*Ybq4IkhNRVZUVVH2UVW31QdZktFP+rE4nUcNs8TWJDIE4MS9CqRMLLU9JRk1*)
(*HLpTZilkoGknyrL0S//tf/cb6M/VyLJOZmeFB11RVEWS7f/ze5F3UCVBsfzg*)
(*oAtknMFwu760Kgt0qTmbpFnPODVloe5Uhs1oi3osu488jp2LQ9jOFU9xnhCc*)
(*uyadoMERZPXi3ut91ObnnSBJgtzPtGWo9E3jMbCcK56hHumdoLn3fvGuuEU2*)
(*Cpt2fKzXM5wrTpnZnhYZN3AnYIP03Ik8pOyUwVThqsiyHFEURf2f/0Iq/zP2*)
(*fh5a6GP9GGR5XZDxiWS7qL+c+vh4MleqyqIj+p1o5vXz6ZkVqWSmxE6ymra7*)
(*inH1onhJnseONOpOVeZ7nqXWXxRMx/WD+P/yTHI+028etsrEqU8jm97/bp0l*)
(*XBDav2zic2augM7vpHlyIFMRnm9sZaHu9PQUH5qbIOrH5ShTB0t3qpIjfg4w*)
(*7m3NPNyBYASnzBKigqRFeVkknoJO2c+0zYwXO3pgvBm6U+Xgx6e9d7cE3BW3*)
(*IsTlWjk8NJcycyfqzPa0yLiBOwEb5OROZUB6IfqlEn0cH/tdPzoeZCcVpmKF*)
(*qLMmCPP/G/lJ79mTPFXtdFSjlrixkNopsvhH0Sy6f9fF/hD1viWTI0PcidX1*)
(*Y6eONuJOmAid5TQXyzfQF2WzOTLz6udihSw4KQJiVpKPZpZXXjPLVQnLCp9e*)
(*jYqyqP+HpxPUWM/UwC3Wneog+E0Q6ts33t/IEZbuFB+UqQw2S/PE0Ss1BfpE*)
(*0EjeyV1N0M/msZAphcYjp4yzc6cq6j0Z3cWdcSsCPDfPfOikAWbuRJvZnpYZ*)
(*N3AnYINcutNYic4MUmDbKjK05J4OET9pO3AwpEMDPwEV5+5U9NyJeI7Ubn3Q*)
(*HIn/SNJ41GkwyZyqbbBlnRLTTsAg3y0s8fQgVjQnaaYctDW/6OU5uUBBEJoO*)
(*qfpfgnR8pnG7BbvTU7faDrnjkdGi5hth6E4FmfDcn3OSp0ma1aRpUv8jnxBL*)
(*kmmF42lxRe3hpE9T3NteVrv4+TdDE/0l2XrgRhDM3KlZbSeNTnAqkyjwXC9M*)
(*8qpIk2H87oxbUzs9dpsUVu40ktmqos5nJLfVZMNM0/vuAuMG7gRskMsxu7Gp*)
(*C81AQ/ewM9CVAHf19N2pJNPO0bDdnDudn6d3JHlc2qlxWw8Ut7vT05OHZUC2*)
(*46fcqf/RTSq4OElzXabvov/frnl5dhboTqFt9SKWNzPVRGNRqxXZuVOT35R+*)
(*R2Pi23hPMcW0LF1GHauWfznrti/8DVUWqO2IcB1T+7wjl7gTVZ/DrTBzJ9KH*)
(*NhzlR9qECpSkma7nWjp6QNkPV3vdGbfGAR67TQojdxrLbGUakCcYVd8bOg6D*)
(*pAcjG68sMW7gTsAG6a+zC8ym5+liVesVdyLja4J+ki7iTtJ0v1M+cp5LdxK9*)
(*9k/c5U5k8tJOkDVF2Mmnsf4Jd5KCPNFOXVXtOTz7OLddzx0sz53yvXBenWYu*)
(*3unpsX3798LMnXJ/j1uz43lbVaJOS7NdGIW6Ji/neBfmedF4Qn0IRVWXAMds*)
(*uvN2cv+pn7jTpW88I6zcqemOPgw2NMFrEPoda7Gt6sO1u3fGre0/eeQ0MUbu*)
(*NJHZnor6c8Fsrq9M0OrhnXpxvUuMG7gTsEHO9ncq23ngin3ehpZDdyJjdt2A*)
(*Gum675XZ5IhkBG+RRwp7a0FlhDuYmy0FyJjdiDu1M6ZkK2yThrWnbcj6kMbI*)
(*yXEl0k40b/uxzyqZYngS8lfUuCpJL/pONpvNjQpU5xyfaaejxblTGUqD6cop*)
(*nuL14HkR98LMnVycW/Th1gFoJknnTriPRYmHOaIkq1N74y+FIewO5ExlbFz0*)
(*ErRzfdc/3ylz8BPKcAk8nswjnl1fmQTx4HrvjBsZiH8h5jtNZLa6djLqfNFd*)
(*YJUcxvrrlhg3cCdggwz2xqxSr90l2Izal8cViUf6hNuC3JTf3uKawsJfE1Qb*)
(*HZEHeOOgPfm1j5+gRNV0XbvbxEDR9m7y/+DnVrHdjDEjB7r4a2Q6JTIby41j*)
(*r10PJu8tb/AIRUYMZd2ov2C2PtCsZDnvKGhWnbTzKiM8KYtssdI8DOK/oaj4*)
(*T8v2cz2rLc2dyDJnvIaRzNlPTGW8PucLG3eqMpdkS3PoM1j7RcUwDQ1vay8f*)
(*RuaDRRbpR4pP3xJPEt5sPnbKSWRkfHQLtWeDiTtVRAIv+yqDulQL1wd/74pb*)
(*gffFOluY/wAYuNN0Zhu6E+m+u+xpX2DcwJ2ADTLyPrsqPe4v9yEQNfOYoiKZ*)
(*28ppcF2xu3nXqdn7fCftuwejKnHazuSd4XjElzTjr//7Hz8drll2b8hewO8a*)
(*KD3jlAxyBkFSbW/YfuXN6rmdbPQXNGXoBWLnM3IbdyKnasQs6DoSoqN+SpD8*)
(*nK8eW5o7oepXUrX+/arF6TDSp8eXx7tTcVDFfhDkvdvrWEKtkqA7WZEnEekt*)
(*UEe6i8ij/WkIpujGTkh8Ta9npGQv9wevGX+0O5XR4Sxqguz2emhvdKe74kae*)
(*j+wHvw7wwe40n9ludacFxg3cCdggo+8CRpR5EkdRHCdJkuUT74a/ICdrRbKL*)
(*BqbM60/Jaepjbj0d/h5KAPpCVZ9g+riiGJwUDUINX9RC3Ek2/aLoTjv8eyla*)
(*6vLMnQJLc6eqaC69LPI0qe/xHXeEJWz3xrwEj9m1jVeFM8/FGAoCT4U6dSWV*)
(*ZVlVdc5F6/MGy8vIVhsP3dzpie3emJfgHuNB0atG6oQ74oanIz5YOJ+Y7o05*)
(*wsCdyJTR0c3GlxY3cCdgg0y60zop89jz/CRL0H66F7Mx20lTLN6P2Wdp7rQW*)
(*eLsTnive7mhBRnjHH+Gr+KZGivQkPD778XWnpxJv/aEculY/tNTxra1vixue*)
(*XSkzeIcyX3fKPa2bK16SuRO9GJ6xsLiBOwEb5AVzp2DfjUMJl++0TRzy/giH*)
(*8R7a4E508HWn4IDn3wmiXCOhJ33Dmd7/Kg/I2y8mW6oCb6TPJO9xdqcnFA2N*)
(*7O+gaookafa0Ll6LG1ZWwUlYFFmO7pQFRzylTsCvsJLQbNHD7NuRlhQ3cCdg*)
(*g7xg7pS6BtqIR1SO0XBsJTAV3BKK6FX2GtNXkIA70cG73+leMltVJsbjCksS*)
(*NFYzyvi7E6bI8fj99eHgybgVoSmIeji1L+lzw7ff6X6WEjdwJ2CDKIryyiuv*)
(*vAw8kp/+6Z/+gR/4gR/90R/lnZCV8fM///M/8iM/wjsV6+ODH/zge9/7Xt6p*)
(*WB9vf/vb6yzHOxWr5NVXX+XdlAEAU77yla/8+q//ugk8kj/5kz+pBfUv/uIv*)
(*eCdkZXz1q1/9xV/8Rd6pWB+f//znP/3pT/NOxfr4+Mc//ru/+7u8U7E+3ve+*)
(*933rW9/i3ZQBAFNesDG7ZQJjdnSsbcxuKSxkzG51rG3MbinAmB2wQcCdGADu*)
(*RAe4Ex3gTnSAO9EB7gRsEHAnBoA70QHuRAe4Ex3gTnSAOwEbBNyJAeBOdIA7*)
(*0QHuRAe4Ex3gTsAGAXdiALgTHeBOdIA70QHuRAe4E7BBwJ0YAO5EB7gTHeBO*)
(*dIA70QHuBGwQcCcGgDvRAe5EB7gTHeBOdIA7ARsE3IkB4E50gDvRAe5EB7gT*)
(*HeBOwAYBd2IAuBMd4E50gDvRAe5EB7gTsEHAnRgA7kQHuBMd4E50gDvRAe4E*)
(*bBBwJwaAO9EB7kQHuBMd4E50gDsBGwTciQHgTnSAO9EB7kQHuBMd4E7ABgF3*)
(*YgC4Ex3gTnSAO9EB7kQHuBOwQcCdGADuRAe4Ex3gTnSAO9EB7gRsEHAnBoA7*)
(*0QHuRAe4Ex3gTnSAOwEbZMadkqMq7n3G6XkhWYY7FcHREHdyUMwdVGWhoYh1*)
(*aneCcgxzVmkbh4s73RyBKkTxRCj7Y3bx68Dea3qDpplx+cA0D+DhTlei0VHE*)
(*riaLAkLULHeYGfNgr2mnqDnxQxM9YAnuVCRBnf1kM5g/yrW0Joiy5sazRfrx*)
(*gDsBG2TanbI9qgqVqGKdpBcP7u6UusauQZpzpyKQkTNoQZocdXT7zYCnPnFw*)
(*p5sjEJjoQO0QpNERHSdbZ8flrrDrs5/RiWeHvTtdiUZLGdu7AYrdz4+eLvZ/*)
(*qXssw8bbnarEkNpSasy4U3lQhlG0I576BO4EbJApdypCk5RKzUnZp+oFg7s7*)
(*lVmSZRFul2bcqTqqqMG3Y6zLVYRraI3j7WfuTrdGoEqO6DjlQB4sYlsZlBRP*)
(*F3aKFUZhgPCjlGnTxtidrkajw9WQViVFfWAZ2CqpYcywDQ4WTtMNQhw2P2At*)
(*BLz7nYokyWJHv+JOmYOC5iUoiFmgEUeXLI7yBO4EbJAJd6obkfaRRjQ4j9ys*)
(*H+7uhCksadadMtxVImhJ+0GAH4P3PtNn/z6s3enmCLi6gPWgPbDwJVxSmuNy*)
(*T0TNn5MWfDptGbvTlWicyA1JCU8hKQ8K+qLR9uz5qKdbdsKUV1c3b3dClPih*)
(*dcadcn8vm9Hp+Ah35Ykmx1oa3AnYIOPulLl1cbTco4ztyYoYztV4EVmFOxWB*)
(*OXiADfFAjDg3fPBYGLvTzREoTOm8w6QM8AeSjz8gLtEMvmg2exVg605XojFD*)
(*ZMmnL2b9UU7J9jn0dy7BnYpr7jSkCmXodwIA5oy6U2CIO8EoUR87fhBXHZj0*)
(*9FpYhTvlvjGotCM8+HJHNf7cMHanmyOQ4VnRPTdoRvdIbEvfNnVN7U3c0Rg/*)
(*fLB1p/lozFDaqNVXyABpmXjGXlflU9jUA9OJ4k/rdCfS76Qwj1UfcCdgg4y4*)
(*UxXJ7SzNKj6Qx0APxu1eA6twJzI+1V9ZmQdDl2AMY3e6NQJVrA7dIDdHYlvF*)
(*nkn6UgTdfXDaz2DqTrdG4/J7h7ORvu7zIjYVEjbRzZg+tK3Qnci8cW0YRLaA*)
(*OwEb5NKdUkerS+MxStMkyVKfDNvJVjR1BuAqq3CndnzqZA7EJbbjTrdGoMRr*)
(*8fqRLJpRqsvYFpEtMJ80yNSd7olGj3Rfx0W2pwaQD3jSvuEzfWZbnTtl3h7P*)
(*qYA9CgCANRfulBlnq4RP4w58H21WzSrcqcB9LP1el+3Nd7oxAk2/yqkztvWH*)
(*sRk+eGRKNFk2b2zH7O6KBoEsRdFm9ryqImvXm0bOhnW5U5Uc0cjmkedoHQHc*)
(*CdggA3cqw7rKEtz+CpkyJF1Pe7bPgC8Sq3CnZqV5r4eEmIPubmWd3c0RqJxB*)
(*rwgpI8L4Jk6hWT+NvLj9TndGo8ZHvXlX9mitTyIxr3PW5E45WswoW9yea/qA*)
(*OwEb5NydKjR6fjEznGx8t5MsWG5Hx3LdqSriMExycsNz3OUoth0IzRxgjlPd*)
(*mO/vNBeBIo3DqFkzR2aVdz1UOR46kdrBvjLv7U2AJ07LVsjuIpjvUTAfjX7c*)
(*akI0/V46OVER6bIWligr9sMWo5pIDtnWOAtyp8G+4mflFB2EgmieOkijo67a*)
(*3KZVgDsBG6TvTplv7sZ2s8ncZrMn3YWBOxqW4U5ko3jR6a2ZD8ny8laoCtTr*)
(*uBN1tz4iPqJpbwq/CvmJx77ikxFo1t13jVqBl9fjYJYx3pOg2YG/2VRWVJ0g*)
(*TkIHr9MzGffcMd9XfDIa53GrAqvZEVuSJBEhkIeyoj4Dniqgmk6cJq6p4I4s*)
(*1h2eS3AnMoVJPF9c0C+nVeY3QRTbIOIonvaIYA64E7BBOndK8BRxQr/FbPZe*)
(*6/2O88TEFcLdnUoyY7lFPTT3N2xfAtENuCTO/nSY5fHdm4LL++zGI9A6wGlE*)
(*r4z37Rs0alPy0raLJG+WVzTFxXDY99txeJ/dVDR6cftu+6qCAbqLtnJqOrcJ*)
(*gupEHLo7ebtTcejvbCGctrboldPvXb6QBR+sc9z/H9wJ2CAz7wIGngvu7jRJ*)
(*VZYFWmNu9pbqVEWeZlmxgAFaLu70NBGBsijCut0S+yPXVZ6mWX75MFFmKfpF*)
(*yUk9ebwL+GkqGmNxG6fMM3wCbjmPtztNM1ZOlwO4E7BBwJ0YsFx3eio99Ei7*)
(*0EWUvNxplDL15LH9iBYIJ3caZ0VxW647LbucgjsBGwTciQGLdSf0UgzJTBbQ*)
(*xTTKgtwJrx0zvGW2XUMW5E6ritti3Wnh5RTcCdggX/nKVz71qU99FXgkmqa9*)
(*8sorX/va13gnZGWoqvoLv/ALvFOxPn7zN3/zk5/8JO9UrI+PfOQjn//853mn*)
(*Yn2Iovj3f//3vJsyAGDK5z73ufe///3/DfBIPvzhD7/00ku1PvFOyMqo27I3*)
(*velNvFOxPj70oQ/VzRnvVKyPd77znZIk8U7F+nj55ZdfffVV3k0ZADAFxuwY*)
(*sNgxu4WzoDG7VbGgMbtVsdgxu4UDY3bABgF3YgC4Ex3gTnSAO9EB7kQHuBOw*)
(*QcCdGADuRAe4Ex3gTnSAO9EB7gRsEHAnBoA70QHuRAe4Ex3gTnSAOwEbBNyJ*)
(*AeBOdIA70QHuRAe4Ex3gTsAGAXdiALgTHeBOdIA70QHuRAe4E7BBwJ0YAO5E*)
(*B7gTHeBOdIA70QHuBGwQcCcGgDvRAe5EB7gTHeBOdIA7ARsE3IkB4E50gDvR*)
(*Ae5EB7gTHeBOwAYBd2IAuBMd4E50gDvRAe5EB7gTsEHAnRgA7kQHuBMd4E50*)
(*gDvRAe4EbBBwJwaAO9EB7kQHuBMd4E50gDsBGwTciQHgTnSAO9EB7kQHuBMd*)
(*4E7ABgF3YgC4Ex3gTnSAO9EB7kQHuBOwQcCdGADuRAe4Ex3gTnSAO9EB7gRs*)
(*kM6dyvioKqqmEzQVoel70z66cVbyTua64eVORRIYiiibwcwxZerrsiggxP0h*)
(*rC4OCOx9myt0TTNjhnmBiztVWVgHrb5fO0E5hvnMgeHRwMftlP0xu/g1x7jx*)
(*cKcr0egoYldr85tmucXg13mw17RT1Jz4oYkesAR3uqXM1ke5ltYEUdbceBhF*)
(*xoA7ARvk1O9UFWnsKbj220nawXGdo61J5Oedfox4p3TFcHCnKjHaeycZ0/Vw*)
(*7qP2TpAksTlYOZy3Vrkr7PrsZ5rFZ4eDOxWBjAKiBWly1FFQzGBcnwITHagd*)
(*gjQ6ouNk6+w4rnFj705XotFSxvZugGL3G35PF/u/1D2WYePtTjeW2afyoAyj*)
(*aEc89QncCdgggzE7T8Ml1wy7T6ID/mgnejOP4MAsPPqdiiTJYkefrYero7wT*)
(*9h7ua6p83PwNHng9XdgpVhiFAcKPUqZVNHN3qo4qUh47JiGJcBulpZfHJUcB*)
(*iybppottdKDmnA7kGzfG7nQ1Gh2uhrQqKeoDy8BWSbtvhm1wsHCabhDisPkB*)
(*ayHg3e90S5l9esocFDQvQUHMAo04umRxlCdwJ2CDDNwpxA3oeclNdVw8jYkH*)
(*cOAqvMbsytCcr4ezJDkNJeVu/cwv6N7p17knoq87aXE5lMcC1u6U4c4iQUva*)
(*DwLcEbD3h70fLi4SmtMeWPjoONFojuMdN8budCUaJ3JDUnqjwuVBEfoVi7+v*)
(*wyY7YconavzdCXG1zOb+XjZPowBlhLvyRJNj7QzuBGyQ6+5EasL+4yFwJ9zm*)
(*O12rh/vk3n7Q+U/axGYQQbPZN2mM3akIzMEjPCkO4jCAhSmdl4gywB9IPv6A*)
(*e9zYutOVaMwQWfLpi1l/lFOy/ZFuq0ezBHe6q8wiqlCGficAYM6oO4l7t6iq*)
(*sizS2NeJOQlazOtpcP0s353S4IDvs9Gb0Vz6tqlram8CihaxXTTA2J1y3xiE*)
(*K8LDTxcBzPCs6J4bNKN7UoA+4R83tu40H40ZShtVNgqpWMrEM/a6Kp/Cph6Y*)
(*ThR/Wqc7kX6n4TRFtoA7ARtk1J0uMaDT6TWwbHcq+lNPBfVwcaer2DNJn4Cg*)
(*uw9L7AiM3YmM0Il7v/skD4Y2hahidegGOe57GdgCt7gxdadbo3H5vcOuP9LX*)
(*fV7EpkLCJroZ0we2FboTmTeuDYPIFnAnYIOMj9nh+cOo3yny9nLTlW6wXfPy*)
(*IrFsd0KUeXJoexidsUGmIrIFPHzFcloFY3dqR+hO7kRsahjAEq/F67tB0YxS*)
(*XdoCl7gxdad7otEj3ddxke2JQ4oDnrRv+Exn8azOnTI8zm5xXWT3BO4EbJJb*)
(*5orvST+6aELfEx3LdydMiUeophYF4BEWtnmA+XwnY9DvNDHfqelXOa08bf1h*)
(*bIYPh7ixHbO7KxqE6oj6qrSZPa+qyJrOio9iXe5UJUc0snnkOVpHAHcCNsgN*)
(*7tRM6eS7lGPVrMSd0BKemQYrNGuHfpH7nZq19r0+IlIcdHfQ41o5g16REs/X*)
(*FcY3cWIfN7budF80anzUmydfmQ1VhhJa4QjuNEGOlvDI1s1Tyh8JuBOwQQbu*)
(*RDSpv7/T01NG1tHsJAu2F6eDszudb9lUpHEYja/9CtGdPg21lHlvjT2eACxb*)
(*4dj3HgXz/Z1yPO2528qsmQVNfuzHjcwq73qoyBJFqR3s4x43xnsUzEdjkN9C*)
(*1LkpnZyoiHRZC0s0z6kfthjN45FDtjXOgtxpsK94VcRhmORVdxAKonnqII2O*)
(*umpz274Y3AnYIOfuVNh4lqaoHZIsy/M8CV293erWhunitPByJzIdQuxPVG7W*)
(*j5PKGW+wIyqWG+ZlETno4G5xE6nDd6LqBHESOni9mcl4xhv7fcWL0CIRq1up*)
(*+Ih2hVVIk3QWN3QgfsgQ0dywMsZ7EihRRc7AP27M9xWfjMZ53KrAal9cIEki*)
(*QiAPZUV9BjwxQDWdOE1cU8EdWawnWC7BnUbKbPNQ00whqzK/CaLYBhFHkeMe*)
(*MuBOwAbpvc/ucPY6hA5BUjTDS0Cc6OGyr/ihv0peaJfJt20ZHplqJji1nG+q*)
(*k/v9JZeK4bAfseXyPrsEOyRBtbzmUf8sbuSTeN8+VtSm5KVtF8kC4sbhfXZT*)
(*0ejF7bvEKi/QXZTrgv4KX0F1Ig4TBHi700SZrd2pfVmL4X/v8oUs+GCdw35Y*)
(*LeBOwAYZjNkBj4BXv9MoZVGEdf0rkhHYKs+ytCbLx0bxygz/quS0tRcXd3rC*)
(*w0dplhXnA0bncWsOzFF4Lh8rOMeNx7uAn6aiMRa3cco8wyfgNjWAtztNgzbb*)
(*Q3tBmLyX1I0C7gRsEHAnBizLnVJPHttXZ4HwcqdRVhQ3Tu40zoritlx3eio9*)
(*1PXEeR+nKcCdgA0C7sSABbkTXgNleMusg4csyJ1WFbcFudOq4rZYd0JLeCQz*)
(*WepaHXAnYIN84Qtf+LVf+7UEeCTf/va3f/iHf/g73/kO74SsjD//8z9/61vf*)
(*yjsV66Mu1B/72Md4p2J9fOADH6jdiXcq1scb3vCGV199lXdTBgBM+fSnP/3O*)
(*d75zdA4n8Fy85S1vqf/70ksv8U7IynjPe97z8ssv807F+nj3u9/9tre9jXcq*)
(*1seb3/zmV155hXcq1sfrXvc66HcCtsaXvvSlz372s/8b8EgOh8M73vGOf/zH*)
(*f+SdkJXxZ3/2Zx/4wAd4p2J9qKr6mc98hncq1sdHP/rRP/zDP+SdivXxrne9*)
(*65vf/CbvpgwAmALznRiwoPlOq2JB851WxYLmO62Kxc53Wjgw3wnYIOBODAB3*)
(*ogPciQ5wJzrAnegAdwI2CLgTA8Cd6AB3ogPciQ5wJzrAnYANAu7EAHAnOsCd*)
(*6AB3ogPciQ5wJ2CDgDsxANyJDnAnOsCd6AB3ogPcCdgg4E4MAHeiA9yJDnAn*)
(*OsCd6AB3AjYIuBMDwJ3oAHeiA9yJDnAnOsCdgA0C7sQAcCc6wJ3oAHeiA9yJ*)
(*DnAnYIOAOzEA3IkOcCc6wJ3oAHeiA9wJ2CDgTgwAd6ID3IkOcCc6wJ3oAHcC*)
(*Ngi4EwPAnegAd6ID3IkOcCc6wJ2ADQLuxABwJzrAnegAd6ID3IkOcCdgg4A7*)
(*MQDciQ5wJzrAnegAd6ID3AnYIOBODAB3ogPciQ5wJzrAnegAdwI2CLgTA8Cd*)
(*6AB3ogPciQ5wJzrAnYANMupOSeDsVWnXIGqmE4UHSTJzLklcP8twpyI4GuJO*)
(*DoorxwX2XtMbNM2MSyapG4OLO1VZaCgiyviCcgzns/xkSO85yfPDw52qEIUC*)
(*oeyP2fRxRexqsiggRM1yh5HLg72mnTKfEz800QOW4E5FEtQ5RzaD+aNcS2uC*)
(*KGtufK1IPxhwJ2CDXLhTZikCMaajH6VZGvlHFX+wk0zORXS1cHen1DVaE5au*)
(*uFPuCrs++5l28NFwcKcikJHwaEGaHHXkAmYwbj5zIb35JA+CvTsFJrpi7RCk*)
(*0RFdsGyNXnAZ27sBit0PnqeL/V/qHtPcx9mdqsRoH1glY8adyoMyjKId8ayb*)
(*wZ2ADXLuTpWjoZZTUA/nnQ3lUa1tCtyJEu7uVGZJlkW4XbriTp4u7BQrjMIA*)
(*Udszz3vO3J0q8pxgxxX+KcJtlJaOHTod0jtO8iAYu1OVHNEFKwd8wU+xja5Y*)
(*c0au2NWQViVFfWAZ2Cpp982wDR/2dtMNQpz7/IC1EPDudyqSJIsd/Yo7ZQ4K*)
(*mpegIGaB1jzYWhwLKrgTsEH67lQEJimH/mU5LLy6TSWtAXAv3N0JU1jSNXfK*)
(*PRHV205aLOJOs3anDPe5CVrSfhDgjoC9P9X7MRbSu0/y/DB2J1cXsCy1V1z4*)
(*6IJF4+KCc0NSwlPOKg+4i9toO+X8fZ37ZCdMeWU+3u6EKENz3p1yfy+b0en4*)
(*CHfliTwnVIA7ARuk507N87K498cOrDzz9IAI3MVa3Ik0gs2ogWZza8NaGLtT*)
(*8+zQe4QP8VCUONmQjYT0/pM8P2zdqTCl8+6jMpCmHsHOiSz59MWsP1gs2T7L*)
(*jrqGJbhTcc2dhlShDP1OAMCcnjulezLRiWElvxFW4k6lb5u6pvZmnGgRv4ni*)
(*T8zdKfeNQbMV4eGn6YZsJKT3n+T5YetOGZ4j3jOlZpjy2sy6p9JGrX7Tm10m*)
(*nrHXVfmU+9QD04niT+t0J9LvpDCPVR9wJ2CDnNypIE+LTAcXNsJK3Kmjij2T*)
(*dAIIussgZVMwdicyuNbvd82DoQidMxLS+0/y/DB1pypWh6aUmzfktCo+nI30*)
(*dZ8XsUmWq+xEN2Pa9blCdyLzxrVhENkC7gRskJM7lbjvl8fj3gvP2twJHx3Z*)
(*eATX4DiPgrE7tYNrJ+0hInSXO91/kueHqTuVeFFhPwjNU9h8TsO93LI9cUhx*)
(*wPMHDJ9p7ludO2Xevj7Y4rrI7gncCdgkvTG7Zt4Cy0p+I6zRnZohFa6LK5nP*)
(*dzIGXUZU853uPcnzw3bMrull8jrNaW1qer5Thdbt7rSZrcOqyOpPI2fDutyp*)
(*So7oUffI/1EX3AnYIP11duQBeSfooz3AWeD4KdfpL6tlne5UN/pi3Xxtp9+p*)
(*WWvf62oj2qO7d6yzu/8kzw9bd6qcQR8R6cEWJncG81E9c22P1jKU0PwBcKcJ*)
(*crSYUbYW8ZwL7gRskLP9nfASdVxyh0vtSjQ5QfBgY3EqlutOVRGHYZI3s0rK*)
(*vLc3AZ7xK1sh20SewXx/pxxPexbbfN7MgiY/FmkcRoOlh6M6OncSNjDeo4BM*)
(*j++62nI8kNTVIYO4hWjmvHRyoiLSZS0sUVbs574YzeORQ7bPagtyp8G+4ufl*)
(*tD4IBdE81dLRUVft6IkT4E7ABhnsK54HVrNIWLOCJCurqiyy4Lhn33/+IrEM*)
(*d8r2uE13eu1/SIZpcetPKu2dqDpBnIQOXhtm8l02wH5f8SJE+V/U3TpG8VFD*)
(*K5hIk9Ssux80aiMhnTsJK5jvK17gzQZwHMoYb3ShRCQkZ3GrAqvZEVuSJBGB*)
(*54Sj9fWFhR/bVNOJ08Q1FdyRxTr3LcGdyBQm8XyNRr+cVpnfBFFsg4ijyHEH*)
(*GXAnYINcvs+uTDyte5cdQVCcCMSJHu7uVJKJ3y3qoWnKw/YlEGjAJffl3jGK*)
(*4XC/5VzeZ5c4+1OgLK/tkmscoBuMmwrp3ElYweF9dmW8P70AU/W6wf1e3L5L*)
(*5PwC3UVbOZG3urQVjsqlwuHtTsWhv0GIcNohpFdOv3f5QhZ8sM5hP6wWcCdg*)
(*g4y+C7gmz5I4TtIkSXPYEPO1wt2dJqnKskBrzM1mqU6ZpWma5SXvXTEJXNzp*)
(*CQ8fpVlWDN5LVBRh3W6J1o3jSKMnYQOPdwHXVDnKO8Pq4va4lXmGT8BtUiVv*)
(*d5pmWE6XBbgTsEGm3Al4RpbrTk+lhx5pOe8PMwUvdxqlTD15bD+iBcLJncZZ*)
(*UdyW607LLqfgTsAGAXdiwGLdCb0UQzKTpa6eXJA74bVjhrfMtmvIgtxpVXFb*)
(*rDstvJyCOwEb5Pd+7/dqd/pZ4JH86q/+6k/+5E9KksQ7ISvjk5/85Lvf/W7e*)
(*qVgfH/vYx37pl36JdyrWx8/93M994hOf4J2K9VE75ze/+U3eTRkAMOVLX/rS*)
(*r/zKr3weeCRf/OIX3/GOd/z2b/8274SsjN/6rd8SRZF3KtbHpz71qY9+9KO8*)
(*U7E+PvzhD//Gb/wG71Ssj3e+853f+ta3eDdlAMAUGLNjwGLH7BbOgsbsVsWC*)
(*xuxWxWLH7BYOjNkBGwTciQHgTnSAO9EB7kQHuBMd4E7ABgF3YgC4Ex3gTnSA*)
(*O9EB7kQHuBOwQcCdGADuRAe4Ex3gTnSAO9EB7gRsEHAnBoA70QHuRAe4Ex3g*)
(*TnSAOwEbBNyJAeBOdIA70QHuRAe4Ex3gTsAGAXdiALgTHeBOdIA70QHuRAe4*)
(*E7BBwJ0YAO5EB7gTHeBOdIA70QHuBGwQcCcGgDvRAe5EB7gTHeBOdIA7ARsE*)
(*3IkB4E50gDvRAe5EB7gTHeBOwAYBd2IAuBMd4E50gDvRAe5EB7gTsEHAnRgA*)
(*7kQHuBMd4E50gDvRAe4EbBBwJwaAO9EB7kQHuBMd4E50gDsBGwTciQHgTnSA*)
(*O9EB7kQHuBMd4E7ABgF3YgC4Ex3gTnSAO9EB7kQHuBOwQTp3KuOjqqia3qBp*)
(*mlr/tDfsoxslGe9krptluFMRHA1xJwfF3EGxa0nCDiPqtj977MPh4k5VFhqK*)
(*iAIgKMcwnz12MqT3nOT54eFOVYhCgVD2x5n6okx9XRYFhLg/hBXVSR7EEtyp*)
(*SII658hmMH+Ua2lNEGXNjfkWU3AnYIuc+p2qIos9lTSbgrw3Ldu2dFL/o4ZU*)
(*C0CgaOHuTqlrNPdxJ824U3xA91+z/bwsYs9EGUF3GSZzCAd3KgIZXbYWpMlR*)
(*R5nfDMbNZy6kN5/kQbB3p8BEV6wdgjQ6oguWrfELzn30W0GS2npFOcR3n+Rh*)
(*cHanKjGkNksZM+5UHpTdADviqU/gTsAGGYzZeRouuWbYfVIkbltS1ajkkcT1*)
(*w92dyizJsgg34zPuVJj1AaLV3WRXE+Zd69Ewd6fqqKJONzvG3SFVhHO+lo4d*)
(*Oh3SO07yIBi7U5UcBaxBpBMpttEVa87lFVdHeSfsPRIXH5tS18Fy80keCO9+*)
(*pyJJstjRr7hT5iAb95IKZcJAI73EksVRnsCdgA0ycKcQV2jDkpt75HlI0D3W*)
(*6Xsh4O5OmMKSrrkTPsBrOhhrB0CNWVRNHf9wWLtT5gq4vyhpPwhwR8Den+py*)
(*HQvp3Sd5fhi7k6sL2HPaKy58dMGicXnBWZKcHr9yV+xVKbef5HHwdidEGZrz*)
(*7pT7e9mMTsdHNh4XMFkPDPcAdwI2yE3uVH9uyaSLHbqeKFiJO5UHuelgrI/J*)
(*fQO3XT7LJA5g7E5FYA4e4UlxECcbspGQ3n+S54etOxHl3plhe8VlgD+Q5mfL*)
(*5d6+N9hEeZLnZQnuVFxzpyFVKEO/EwAw50Z3Ik9DjKuyF4aVuBN6ppV7kyhk*)
(*0+PX54Rg7E5EF/uZP8IjR9MN2UhI7z/J88PWnTI8vbtXMzTDlHM5LQ0OWI2M*)
(*9lGM5iTPzhrdifQ79aeNsQfcCdggt7pTZJH21GA76/XFYDXuhJ5i9507aUee*)
(*FfITc3cig2vi/tTVlgdDETpnJKT3n+T5YepOVawOJSc353Ja0Z/qLKiHguYk*)
(*D2GF7kTmjZ8GiLkA7gRskJv7naym3wnU6X5W405lhKeHa7rS7FOgHqLpox8O*)
(*Y3dqB9dO2kNE6C53uv8kzw9TdyrxosJ+EIpmuG0mp5V5ctCbSZROWtGd5NlZ*)
(*nTtleNzT4rrI7gncCdgkN7oTKaQwZkfHStyJzHeSQzSOUhzUZgFPwG+GG/P5*)
(*Tsagy4hqvtO9J3l+2I7ZNR1EXvdU1YrQtbqixIOZpCub+iTPybrcqUqO6OmG*)
(*d+fwE7gTsEluc6dsTxpS9ch3AsxKWYc7kdZKtltXyofTd5nD2J2aZfKi0TXg*)
(*pDjo7h3r7O4/yfPD1p0qB2u20XVJl3j2srC/esG5v2/dif4kz8ia3ClH6xBl*)
(*i52QzwDuBGyQgTtFeD1df3+nuhZz+r3rwP0s152qIg7DJMe3tQzxnObT/k6k*)
(*C2U77lQ3SHjGstj2fjQTmMmPRRqH0aAAjOro3EnYwHiPgmZJZtvVRhbQSe2o*)
(*5VjcGkJk50305k/ChgW502Bf8X45xQcp6JhTcKKjrtrchtfBnYANcu5OhY0n*)
(*uojaIcnymjhw1GYHYNnhvfP/elmGO2V73Kb3BTgkXUtN+1UdkTwJdrODfG7z*)
(*nobKfl/xAs/rE3W3jlF8RBvFKqRJapbMDxq1kZDOnYQVzPcVL/AjF45DGeON*)
(*mtptwc7iVh7q6kVULDfMyyJy9nhCXXz9JKxYgjuR2RHi+X7+/XJaZX4z116U*)
(*JBEhCJz7h8GdgA3Se5/doX1PwjmibBxghvhrgrs7lZEt9G5pNwM8bF8C0YyV*)
(*lIlFXFnA/0Uv4uHZ08jlfXaJc1ppqFrtLg2tA3SDcVMhnTsJKzi8z66M9+37*)
(*RHai6qVt5+VZ3JoJTi2S7ac3nYQVvN2pOKi9OljQus30euX0e5cvZMEH60x3*)
(*YD8H3AnYIIMxO+ARcHenSaqyLNDycLO3VKfMszRNs4x/NyMXd3pCIyQ5uv7z*)
(*prssirBut3rvrKE4CRt4vAu4psrrbJMPs8153Ko8Q7mrPm7CJ8dPwgbe7jTN*)
(*WDldDuBOwAYBd2LAct3pqfTQIy3n/WGm4OVOo5SpJ/dfGrJgOLnTOCuK23Ld*)
(*adnlFNwJ2CDgTgxYrDuhpQGSmSz1PTsLcie87Mvwltl2DVmQO60qbot1p4WX*)
(*U3AnYIN8+ctf/sxnPvO/AI+kdoCf+qmf+qu/+iveCVkZf/RHf/SzP/uzvFOx*)
(*Pr7whS/Uz0S8U7E+PvKRj/z+7/8+71Ssj5/5mZ/55je/ybspAwCm1HXsu971*)
(*ru8HHslP/MRP7Ha717/+9bwTsjJeeeWVl19+mXcq1sd73vOet7/97bxTsT7e*)
(*/OY3i6LIOxXr43Wvex30OwFb43Of+5wsy7xT8YLj+/5LL730b//2b7wTsjK+*)
(*/vWv//iP/zjvVKyPL37xix//+Md5p2J9vO9979N1nXcq1scP/uAPvvrqq7xT*)
(*AQBMgflODFjsfKeFs6D5TqtiQfOdVsVi5zstHJjvBGwQcCcGgDvRAe5EB7gT*)
(*HeBOdIA7ARsE3IkB4E50gDvRAe5EB7gTHeBOwAYBd2IAuBMd4E50gDvRAe5E*)
(*B7gTsEHAnRgA7kQHuBMd4E50gDvRAe4EbBBwJwaAO9EB7kQHuBMd4E50gDsB*)
(*GwTciQHgTnSAO9EB7kQHuBMd4E7ABgF3YgC4Ex3gTnSAO9EB7kQHuBOwQcCd*)
(*GADuRAe4Ex3gTnSAO9EB7gRsEHAnBoA70QHuRAe4Ex3gTnSAOwEbBNyJAeBO*)
(*dIA70QHuRAe4Ex3gTsAGAXdiALgTHeBOdIA70QHuRAe4E7BBwJ0YAO5EB7gT*)
(*HeBOdIA70QHuBGwQcCcGgDvRAe5EB7gTHeBOdIA7ARukc6cyPqqKoukYTVNb*)
(*NITuxCXvlK6YZbhTERwNcScHxU1Hp6GzV6U62TvZuu0bzw8Xd6qy0FBEdOGC*)
(*cgzzmQNDFE+Esj9mF78O7H1TmlB5MlkWIB7udCUaHUXsarIoIETNcodZKw/2*)
(*mnaKmhM/NNEDluBORRLU2U82g/mjXEtrgihrbsyrgDaAOwEb5NTvVBVZGhry*)
(*jtR/9vF4wFiGVv8smSHvlK4Y7u6UusauQbrBnTJbRc2gqNlRWlQM0jcBB3cq*)
(*AlQCBC1Ik6OOgmAG4/oUmOhA7RCk0VHEhnl2XO4Kuz77GZ14dti705VotJSx*)
(*vRug2P386Oli/5e6xzJsvN2pSgypLaXGjDuVB2UYRTviqU/gTsAGGYzZRZaM*)
(*TSnqH5MelZ3mM0/aiwN3dyqzJMsi3C5ddaeUVODqIZo/jgHM3ak6qkh57BgL*)
(*YxXhNkpLL49Ljug45UDEMrbRgZpzOtDThZ1ihVEYIPxaQRldAYaxO12NRoer*)
(*Ia1KkI+Xga2Sdt8M2+Bg4TTdIMRh8wPWQsC736lIkix29CvulDkoaF6CgpgF*)
(*GnF0iVvn8BO4E7BJBu4U4ufHYcktItcfqQmBG+HuTpjCkq67k4/NSdRdVqma*)
(*g7U7ZbizSNCS9oMAR2PvD3s/XF3AetAeWPg4akZzXO6JqBA5vDrtGLvTlWic*)
(*yA1JCU8hKQ8K+qLR9uz5+zpsshOmvLo6ebsTogzNeXfK/b3ce7YtI9yVJ5oz*)
(*o8uPBtwJ2CBX3anwTcPnWC5fBNbiTk0Hwk4J8qrIsyzjPI+CsTsVgTl4hCfF*)
(*QRw2ZIUpnXeYlAH+QPLxB8QlmsEXzWavAmzd6Uo0ZiC93M0Xs/4op2TzeFhb*)
(*gjsV19xpSBXK0O8EAMwZd6e9m6GmM8uSsH7y3oM7vTbW4k6hKe3OEWQj4Tfh*)
(*ibE75b4xaLYiPPx00ZBleFZ0zw2a0T0S29K3TV1TexN3tIjtSgu27jQfjRlK*)
(*G1U2ChkgLRPP2OuqfAqbemA6Ufxpne5E+p0U5rHqA+4EbJBRdxpgTEyXBW5k*)
(*Je5U2OTmS7qf5EXqN/NR1CMve2LsTmSETtyfpvblwdCmEFWsDt0gN0diW8We*)
(*SfpSBLZjoEzd6dZoXH7vcDbS131exKZCwia6GdOst0J3IvPGtWEQ2QLuBGyQ*)
(*UXfqNR+lo4o69Du9NtbiTu3gS9NL0g7hXR98eRCM3akdoTu5E7GpYUNW4rV4*)
(*/UgWzSjVZWyLyBbwSVkWIabudE80eqT7Oi6yPXFIccCT9hnPFlidO2Xevj7Y*)
(*4rrI7gncCdgkV+c7lZHj8N4/ZO2syp1Ep5ugM9KlwBTm852MQb/TxHynpl/F*)
(*6xr21h/GJBOPTIkmyxCyHbO7KxqE6ogyljaz51UVWex7vNflTvWjDe4V5jla*)
(*RwB3AjbITevs0MYsru3x7RheMWtxJ3xA3WB1R5Rky4qN9Ds1/Wy9PiJSHHR3*)
(*sGKscga9IiWeryuMb+IUmmJ97Avb73RnNJ6atZzX9mgtQ2nHeqblmtwpR4sZ*)
(*ZevmKeWPBNwJ2CDj7jTcCTPVzppU4D6W7E5FGodR09OU4O4A6dTxkqIVY8Ke*)
(*1/4UzPd3yvG0Z7HtQmlmQZMf+4Eis8q7HqocD51I7WBfmff2JsATp2WL6day*)
(*jPcomI9GP241IZp+L52cqIh0WUOjxFXRD1uM5vHIIds59gtyp8G+4lURh2GS*)
(*V91BKIjmqYM0OuqqzW1DNnAnYIOcu1PlaKi1EFQ7zclCuyyJfbzZ+MgOgcCN*)
(*LMOdsr14PiT31C0n7+rqBC+vF454NCU6qOznnPRhv694EaKhIlF36xjFR7Sj*)
(*vkKapGGgCtwjh4NZxjhoSlSRM+CNDkTVCeIkdPA6PZPp7tgc9hWfjMZ53KrA*)
(*anbEliRJRJD5dFZRnwEvsFNNJ04T11RwxmMctkW4E5nCNNhgrV0Aix58qsxv*)
(*gii2QRTINEVuz7bgTsAG6dypSpzhAvUew+cg4B64u1NJZiy3nPYMb5u200BV*)
(*Hmi91fWGy3Oglsv77BJnfwqU5TWieRmoMt53BUZUvbTtIsn9/lJVxXDYqyeH*)
(*99lNRaMXt+8Sq7xAd9FjWdBf4SuoTsTB2Hm7U3Ho72whnLa2CNuXtRj+9y5f*)
(*yIIP1jk+24I7ARtkMGYHPALu7jRDWRRhXR2LVn94JM+yNOX6KjsMF3d6wsNH*)
(*aZYV5wNGY4Gq8jTN8svn/RKFL8tLTgHk8S7gp6lojGawUco8wyfg9tpx3u40*)
(*TVWWBVq4YfJeUjcKuBOwQcCdGLBod0o9eWybnSXAy51GWXKgBnByp3FWFLfl*)
(*utNT6aGuJ877OE0B7gRsEHAnBizXnfCSKGOpKygX5E7LDtSABbnTquK2WHdC*)
(*L6+RzIRbh9wVwJ2ADQLuxIDlutOyWZA7rYoFudOqWKw7LRxwJ2CDvOlNb/r+*)
(*7//+/wp4JO94xztqd3rjG9/IOyEr4/3vf//LL7/MOxXr473vfW+d5XinYn38*)
(*2I/92Ac+8AHeqVgfdeX2B3/wB7ybMgBgSv1o/+Uvf9kCHsk3vvGN+r9//dd/*)
(*zTshK+Nv//ZvIWgU1HH7m7/5G96pWB+2bdeh452K9fHZz372n/7pn3g3ZQAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAMBz8v8DXPcVzw==*)
(*"], "Byte", ImageSize -> {535.1999999999997, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJztvV+o/Vxa57llQPHGu7pXBEHBiBfSSCPMBuemeqYyPYLDSGycUoOCM5O5*)
(*jKANuVADIgalDSIELwIt6WqIU68RrCAdsQ3dHWQCTmowNikxY5mCvJhCchGt*)
(*M8n6k///9jl7n3Pe9/f9wA9+JztZf571rGc9WetZK9/x+f/jf/r8f3O5XP5d*)
(*+++ftf/p/v8EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADePUXkSJKeNezPMo08tyOI*)
(*+msdriqqTtSspfA2NFUxULYUK5TNU5PFvi5fr6r3jgo/paly39avF9HN6rcu*)
(*yyplYOviVbher6Ks+Ul5ewpv0wp1kbimKlzkqHrFXCcUliKJouSm77Nl3x1F*)
(*aImtvDT3reRVpYGuiAJRds3yy3drNT4wqjxxDEW4qsmrakadhO3QJ0hm/Jq5*)
(*3sqje82zDGmVBI5yFRQneUyhNmmq7H2Pp7cRWfLlcmm9L1KZytXEywhBtnJu*)
(*o+rUFdpLkpG9D6tVxcblmH/2P/b/vZrP8C1egcSW+zIa0TssY2F0SnE1bFPi*)
(*euHltyhBnchv0Aq1qwg8VzF8KyetCq9UZHr4RiX4hBHpVGDXN2myIuysylUx*)
(*LI0r+zt+uftgqJ3BgrxeX24yd8jViF4p12fxyF7zHENap85bie7dj6e3kThK*)
(*WxHNy9ifpHaiatiW3vtqkp329ze536mCoL0HP42WVjHdOEmzPDVZia9OlGZp*)
(*GrevP11Z//sv/dfc067UPXiz2ZRdmqrME/f6XpWKyln18u6P3BPOl7OODd0l*)
(*Mq+L4g1aoS7LLLJJgcU3nEmz2/dwQfI+Fe90jyBxrLAYDEoZ2Z28dP8N5FXH*)
(*xL5rRNcbTyW6IxjP152hC4AXUbV9OTQvr92XW8OV2cRFOe9pzPT5dXhor3mO*)
(*Ie3WuVJLvk10L6EXe1va9zye3kQVW8Th8tnfdXwdOWxPVSSvucFFoHdPqf7T*)
(*WxMZwkUN+j8TS2JduFfTOhIvQlA9leTt+N06aYTCuL5PpapMUjCTd84qj4Pw*)
(*1IJDYrV+s9HX521aoY6lN3bSwC5N0mqJHr4Lta8ioqJir6JVHARJ8fxxb9YF*)
(*wIt4o75MR5aznsZ70ud78izh3ya6lzAXe/lex9ObyFTylugO61ZVmuTjO2Ky*)
(*unWdL9Ow6ttvHWMTW6oVDxoTm9xJG65Vjm5mTWtqTeoevOMGqyzxfSpVTQtm*)
(*xrc1d5ORxXHR6h97m1Zo4KS9ZxqPzHffql0Pokmsy1RpX5TaoguAF1FH0usu*)
(*d1Ju8TTelz7fk2cZUjooP95JW4r93Y6nN1AEGhkx997yfLI+ZS6qmdL4ANl5*)
(*V4q45qQxmHtArGXsWarSonvz6Pe6+0nuUDQjSG9o3DqPfc9neK4fF+Ryk4Tk*)
(*suexK3UROKYiS5Isq5rhRdkojbFS1XH3TPdkmHQPNkXsuvRCm9JY6s8v8yjn*)
(*zLMMVdU0VVENOx4vPKWR77sK8cll0w0C3wtOzaEVsUNnmy+C4vqB53Xz0I9u*)
(*hVEamWtqrZglWTVNda4V263QlK0oNFnrYpCy0NEURVZUy6dRr3XU/taVWXPC*)
(*4ZG6SNu8jG7+OW//o7TFVo0gG6tgnYauKqvBIFh6RXbb94cytvX2KUUzvdkK*)
(*SVMmjqFJpJiG7WdV3RBuE0WZElG0xVLaRPJZ4203PS+kFlVN6lttvTTT71Sz*)
(*S1Bt346aOrVIwf2UVna/4Zo2tfZ2ifzqx+RlsM4dlalJp12dcnXazrIww5k8*)
(*ssjrytqKS1FtP5mUtWsFlTRcE3s2bSaPdcNTNEXSdjnXVHqlbbsg62t73Xaj*)
(*ahtd4Lgim+I9S5UGBlFDK2BC9m2D9DXNjfKjp4eCtIXUqIrWmUMUW9XthGyi*)
(*qPPI6grfVteZrOGvC6qKA783jq0Bq3lBqZHzvODs2iBz0qS4ecp8m1RKNd1o*)
(*ptR1EVu6KlGdd4LnDdJZRNpUklTdpMGJU09jTds39Hm3SOu97DmGaNFrznWK*)
(*3W67b0hPwJw0K2krautqVw3NipgZupNirIudjadmO16VnfC7vmR588rfQ1Ue*)
(*Rm2vKN6EKrbJtMfKlpY6sYlIru+qVsdOmiCpch8A2f09jItNRmLjL7KmKzwa*)
(*T3XTeUIb5IF1HVKV7ZCGtOQOiz0WzNZgViH9Q9YtS2cxySzQi5RxcNLaB3UW*)
(*+kijzZs8NFSJX+FN9rIyU0qy5N0NJKqmSEw4JjXvbZF46PRQOeWEZ84mxsdI*)
(*baM8uhVYGrlPH1XN1v/oIyu5Vmy1QpMNUZhXxZxun1Ed35LHF7o3l6YIFd7q*)
(*omqo1+kNYWcPMk/vr9Cp+PEVUVHGghgHqJcRbRfRDgJLmSR9fiWlCC2S/lU3*)
(*DS5yqe8dO00/LuTl2pfxx/7P/6G/Kgxlkpz6oOEKGppyVdoBj8lRaiUYmcJF*)
(*GEtA/DdfHLXC+P2xtEkKgqRoGheaZHaLAG3DDUURZ6rlno6dbXJv2oDd405a*)
(*H3Xb9aptdYGDigxKNxXvyTp0y7XmSJpGFNoTBbvIyQl5ZP7Q+ophTDeSab5v*)
(*TpLsl4a3e9Y4Cd1jWtEdKUALJ+pnW4k5aRdJmraVbPeqkvk0pkLWeXO0ZU5v*)
(*e7NpfNoSomrZQ9mHsXJD21f02Yx2inTcy84ZoqntIr3mZKfY7bYHhvQcbFC+*)
(*SpNqXC5WXN5LMTbEzsZTSVUnlR+Fad1DVR5JF6zVsToZWOUJe6MkgkqWjcJN*)
(*kB7c8K76aI6dNNJIQVoUiSsOrfnEI4RFvmOxdphWizdEFnCZiGO3Nu82B9mk*)
(*4dn0I1/7oLOU7Z999MtsejYmGyHGXrQ7iV+9R5mrkOR55WNOw2L7L5fR6FaZ*)
(*bLnztjf6ms2bDRFor9EKTUoV1+JiDI2JVmy3QhWHgd2bRFLCqogG10tQ/KQo*)
(*85BdUdymytq3Np27N51z7vtDChelbfYyjQLPHG+1oFf6VNvX47zM+Zbqfh2H*)
(*1YLLvOSbYgTL9eKT8w4F3eKhsBfUnO1Tk23yPr7b9EUyFLsruUM9kR//vS+N*)
(*PEbJsMirhGT9+X7D+cRMyjbrF3ynGHUY+sV0UtOmjEKexUhzIhp3waNnm4w7*)
(*VG0rjB8hDecnecHDhq83rrMslXa/2+5WbSW13YoUUbAq3vMnP6TtA0ZcJqOX*)
(*K80O8qrw5gq2R5XFgW/3eqzaQVFXka32aSqWX1Rlf8XJDu0bVwlBGw8YbveE*)
(*dsMQwp20Ft32w1EhFZfMKeVeJ17dp4rYpI7A1OCGjdUp2UzXyp1ZkDJksjtl*)
(*eKf6vFukjV72v37hP9xoiJa95lSn2K3IkSE9SdyfByDpfhiOzSPRmjspxlLs*)
(*fDxlClwOXYCV/x6q8ljoJs11J61yus1olwFBm83v953lXe1KPnbSrkNFJi5Q*)
(*QaUhBUkSR1EcJyG3PzfFf0bsxUDpX1d9dYiTpzleuCfPDOkQoLV00uar+fE4*)
(*NOIeZQ7J69Yk5rCfAWj7/kbBTrKMQHuFVmCbr2VntGQbXEdasd8KLCTpqvcT*)
(*JSlNcNQFEpoCf8SnL2FXrY/Q9Lm3wy1GoQtTATbsQJJhk860kHymWuoXcjKX*)
(*iEI8v+ei8YjDwAav7kJKpamSKyeanm0YkbmTQEXKQusvMitb0+w3HIvLuqi9*)
(*AFldLip5d1nRLro1adhgUtIzTMRgVPmY+SFsWoA100i1AlLBWw3UUml3FOao*)
(*aovUTlRkRbw3UCdR2mZD9a0dmmN+xBtzPAT99MDHRj3N511hqbRNPH7TP7Bv*)
(*7JVhNAlJrsjOLfPkfNyx+5iLkk3fUW+QNboVJHGniUkSsGkU4fTeDX5Y0Dji*)
(*Ohzr0oGZmuvzUZHWe9kzDNG81xx2it2KHBrSk7BBWbZ7aYbcbWPm8S6KsWJG*)
(*2JVBXdnEFHtPuYOqPBhuCvZG3jL1+1lSaz6bxmZXPmFO2miMG7tAvTSEq8C4*)
(*ii3Xq+TctDmi8Jm+UctWRdf+/08kxihOyropkkDv33GGPnXCSbtzmVmOs0YM*)
(*2EEZxpb3eJJ+hJrPpD2wFbhajiczebAx04rdVliWcHlltkeVVWGc42B2WEzO*)
(*lgHpN8zOClmzhchh3qOmRnvk/x+KYvFq2SVTVfX4192mX01hCCwcRLTbcEsB*)
(*snI0k3KOtWumOXwJb9qv2RDDHPjlnNXzIpaXSrujMEdVe05FluK9lYadTyX4*)
(*g0PG4haGjfzHLFR05cp0Q/qBfevPM6HHmzxFXV+9cTsPj0kbR6HFvG55P+Es*)
(*CBNFFK+ievaIVz7bP83iBjM10+fDIu33shsM0VJ19zvFbkW+dmxIz7FiHvnL*)
(*IPf/76EYN9vYO6jKo+kXng5G3iLYWBVdN/Jvy4mZtA11Jb/eoy6NKw+mKevm*)
(*/ydBIFUW0LV9QTEdU572oBudtJeXuUnohPYskV6M3EO4t5P2uFZoMtrdlfFb*)
(*2MK27LTCmTLPrqw5A7nGQsHoPNWmARmuzArJoxH610k2Eon2WQPCJwTWF6lP*)
(*Nf16u28JZKvh2Cv55hzgsZNWBMZKv+aTKnR5Yl+1zrPipG0rzFHV7lORW2Hz*)
(*+eNScT/QvGHkO6G0iyu79m04GFbrQuMz5TankbDmJzBXpFNaWh4xfMEom3l0*)
(*NmnyNnSLmZrJ5LBIt/WynSv3tLfnDOkZ1rohq3I/jX8HxbjZxt5BVR5NH196*)
(*NPI2NNDgQ3DSxssWlDpPsxs/CdN7v06aGsIkJKZgJzFenZiEdrIJ7SMnbfQO*)
(*cu8yZ1NfYpJLW3T+Iv6qTtqLarS6Cj+1LfutcCcnraYuFY/YvN1J6w5mpIOF*)
(*YHhR5NHBXbjlw1IFjRyW7OkHWZoi8Lu9cSea/sbhY6Ph2CpM+7YyLXsRByS4*)
(*7thJyz2NNtlkmxJva51s0Hick7ajMEdVu09FboS9IIyHVxYttmigXW520o7s*)
(*21M/mnRGjfirNx/itO6k0YyMkpdntK2D3ZImZ7cmrA4it5ipVSdtp0hv7KSt*)
(*V+T/+0+HhvQkO06aMQSxvFgxnumkvUhVHk0znBt/IHG6HD9/H++D5D8dThp3*)
(*WaefGKtadVFvPpOQBSARhNGO39IQJlpRHztpdHfKMHmS3LnMfWilNtZUJsYh*)
(*32eeCtjPzy9i0h7XCmy5c7IxcHIG40ErPN9Jm2yCZtFfvHM9x0l7KjzSCrIk*)
(*dl+Q7E8/OE3FNydM5gQyV75crfpU058ePnYbbvTrOMgkk7sgiuXy0EoWfKpk*)
(*alG5CaKRGPWdnLTFect7CnNUtXkXOFORFzppa/vu2crO4rjLfW510g7tG7mY*)
(*0uJdZpbhdPVW/ISMhtuRvT+rOk/W9bSzFoS36TgOlvfxM2Zq7qQdFemBTtp+*)
(*p9ityF8fGdKzrHTDZrYriqT9QsW43Ul7uao8HC6o6fbMpsiyvBw5sXS5c3mW*)
(*Wr+7M3xHuzv5niZpfm7OU3+Q+BDpwc4npGNrM3xZUrGCsm6aim64E59xJGHm*)
(*8o2xk73zbOWd79UqPbpLXbSKInK63ccswKNX3YRHirLjMPheSGZs71Hmvqja*)
(*+CQQaWJs+6W3W3d39kaj7o4ocYKsfoVW6IP2Fb7hju9qpA7zQSvU/CzTwdAt*)
(*r8STK8yxGfZZ9PFjKn8lKxfbY9lqwnClN4A1v4EkGr3g296jfVUGOWqrScnh*)
(*CRrp8ieafrlhaiKQoU32G64aduQZfufMNGVKiqZP5+vqbrx1gnqlt2YsoFkY*)
(*XErWCvxKTleptlTrVqEN6ewqzL93d6u27AL/72FFVsR7CyFb6xyFtPH3ceu2*)
(*r5IvW39zAx25cmjf+CNcZItJjDOF4ofZDlVhc8J0LE77jzYKSpC2nafJo85s*)
(*3qAGPK642xbNKxqQEy7Y6Q0HZmquz39xUKSDXnbeEC2t60Gn2K3IkSE9y9JJ*)
(*Y/PJ8yPNX6YYK2akNKfj6czG3kFVHg7b/DVe/O2/Vy6qZpikSUg3OIv+4lPa*)
(*fFvTijv0ZjSFzfa/C/bivD5+vEDb79geNXpaUevx0JGUb8ua8Mx5Qu7BGpP5*)
(*n2FHsKT0Z9LwK3baz23KVsR2RLOx/iKIiqZK0yeuTlrfo8wFP6lGsLuDLquQ*)
(*nsIj2X2/LmN21JJiR7dN5fDAVJGckeNkX3+NVmBbkJgau85w2EVXSem3fmuv*)
(*Fb7Mdx713lGzuFIH7EwidqX3heg5P00RUTXsX39q1lmGlh3amhvAiguZ7UXi*)
(*32Sf0MW2Kouzf7cZf9R+oHcPDpq+zgP2zmMEo15eB2wnvuSPDuzdb7jx946H*)
(*crCwYf5KK4hit6er9XVrjx0uIPc+Kv3oeXeXYud1VzaaIt/Q1PBHFL6fsZyp*)
(*1jn4U0Lf3Afddrdqyy7QHFVkXbxn4Rt4hy29g/BvWuts1ZgfesZ7/egKU9r+*)
(*HK1WsQ8F1adcsU0x8nOO5Of9QpD0KCvrKmOH1Gk+Pyc4XVHEG79QEA6Hjomm*)
(*45qTAxAFK652tX2hz7tF2uhlS7NzaIiWvea4U+xV5MCQnt3YEhlMHLoTlXWd*)
(*8ZMbl07FixRjIfav88NtlKWN9UlXuIeqPJrZG1xH4c86l6jaqx+Fpg65oHqv*)
(*V9xdYmthKgfjPFgPih1F+mQIZCEliTdaqOzOLg6ePYsRdimps/eB1tsZ1F7z*)
(*UnZaads9/Y+ZfnLYQFk5o7NO21d1su2lOwvWDRPq5tyhzE1uT89KlTSnPxo9*)
(*0GcaccvRsqMDFTX3/361Vqgzf6wNksy28Si6HefVdit88XemjrAVxcbUVbLC*)
(*aHalfU0bJqwGBNNnQ2LvaTMU5+vcZ+uvxKOzQy9sVaW254IfKnSDESuj8Qgj*)
(*sCm1voE2mz6fFomfKZFP2oaf5kHZb7jYGVtEwRimVkZHeop6Ulf2VJz9xt4i*)
(*tCdlFSQ7om5w7U6PBF6olnRmgaaZtcuFnWy5022bo6pNuwA/q3OzInviPQN3*)
(*/sfnCrJYhZvedKqZOWrdMrblYXRlpiGi9ddHguKl7N4dhNvWXoeHU9+SJlIS*)
(*dHc69VEl+vgOQQnmn9k4pPaNkQnhB7G2L8u2Hx8a3qk+7xVpo5fNjxA/Y4g+*)
(*/y8mfzrpxyc7xU5F9g3p2QYrU2s6w9A62PHqAsGLFGMi9v/yn+dWN2bhoLya*)
(*7KzIl6vKo2H2cDIN3tRFnrWkafuisjU80oW58Uc/Py3UJa18/oJlJpJOka2q*)
(*cVNVVX8MQptbUVQHWlFkaZKmBTENbarpMtl7lLkqsiRp88mK6r5t2lRleVTF*)
(*BXeoUZ2nndzI2n3TJjVew39GK+zQx6vUdZF23LrXZAU6RyGZYd10pcs7Wj3o*)
(*vt/Sddjb1p2bToWSdF0h79v0+w1XFaRNVuTT1J2aHKffVKQqbV3OfkfoPhwq*)
(*zHbV1rvAa1WkyZnn+UrfWT7Rs0qy2+L8lyBWKYucdLV8S2fLdhTLO018vgUp*)
(*c9ptavKRprZtl3dsafuqPr+8SI9ir9vuGtLbsuhaLC82u/nLFeOsGZnl+27b*)
(*hULfvG6M06N7muTZrjEAPkge8AVhFp0YLO1N5rQvR+/qW2zgPZMMZ4i9NexU*)
(*XjKz94JT4MCnDSjGETmZx+4/jnBIk3n0HPP3Ni0IwJuQWPd20obAG80Nk6Ks*)
(*6rouiyxwyP650fc9AdilPyjpjb90k9HFJkGUuoChm/eJg08rUIyTsMjwEwft*)
(*ZkG3WUlQXbi7ADzVRRJ5/KscohPda7qi4dHjcyTDQ9cDZ6n4B5pvPkfozowj*)
(*qK4a3jIAA4pxA3Vq6eZh2ELqW3ZwWywrAJ9aqkSXZUWlKLKkeKvbbJ6Xdp64*)
(*lqEqityh6KYTv7ugVvDOKR1Nke6qls+jKWND6bqK5Z/+rBn4AIBiAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAA4BYKS5FEUXJf57RGAAAAAABwhv5Qqed+TgIA*)
(*AAAAADyAwlZFQZDefJs5AAAAAAAAAAAAAAAAAAAAAOB1qWPPUumZ5poRpOTr*)
(*IVXqe57P8IKkbMqEXvA8Ly7oqmKdhq6mGNnTUxG1/1FkRTGccPTNmu4GVdai*)
(*qkl9S5FlzfTLnUwJTRFbuiJJkqKZrmup2vD9qe2faEZqUIxPLG6yyDNUVdPb*)
(*oqn29DTjukhdsy2a1zw1sWe3dyiK1lZsdEvh6G2N9KjEKcgAAAAAeHWazCCf*)
(*dpM1XRHZ97NUN23yUB0+qHXRguKpDPjvkp/XoaXwH0XDUC5jRLPovpqqD1eu*)
(*Av+fHNebmXblKfwuW0G2XVeXyFNXkzlwGz+NM9KH79OVNvmeotA6dJrCspfM*)
(*vOly14eqiarcl6273c2YS1ZFBiv7Hb+aDQAAAABwisZTWxdF9HLqmdQO81hE*)
(*4uw0nsa8GTOqnppY5g5YSxaFnq31zo2s275ncYfrorhpkUSBZ/YOkOFYJO3W*)
(*SdvLNDbbNAQ+3dbe2f5l0L+2firTISMjYj9HZvdx6qvms7sz78pL1jRlFAaW*)
(*wh01QfWTvEjc69Qla3Kfpqn59/pkNgAAAADAOejc1EUKkiSOojhOQludTkll*)
(*KndlrgKfB+tpYmk8CdaSc1/oapKFyMokf8tWzJ44yjSmzpXqMGcrsy9Xi+a5*)
(*81ObqC6MnLSSnsghBqOV19iSxnNlqS2Tcmr9p+IDMr8mjubNmqrIi1ESAAAA*)
(*AACvQr+i13pgjKvYcr1KDj8Vtk7sfrrMTqYHXNQR8Xuksefmq8RbEjTiClV0*)
(*cs2Mq5OZJsyVInNaTlg2QzzYzk99RtRJqyKTTs1FYw+LOYfM/6xjco9o9rdQ*)
(*J1DE4iYAAAAA3pqKOCqHbkmos2VMMyonPzAnbeIL5T5dA72S/QMT3+lUpk1m*)
(*9r4YSceOiuOfphkVgbHipLHSth5e2BeDz/h1wEkDAAAAwDuBOSoXNZter/M0*)
(*67c01vFoV8B0uXPNSasTizg/OvGfNp203Uyb2DPFIdOLMxxRu/XTJKPcY45i*)
(*MHYquZOmh8UTnDQAAAAAvGP4suBFcZLxZaN1oVhMWmV3nosSxu4QeN/fyJc7*)
(*o5HnlrnKyPlZc9J2M40MiYfDVYHJ3EPJ6u7c+WmWEVvKbBP0RjH/NYugs5Jq*)
(*uAdOGgAAAADeIU0i8ykpxQrKummq3NVad0ekM2Y02J6GoiWOMvd8mJMmOFnv*)
(*uNU0cExxM/bnIiZtP9PYuF4kt7+XrrRSx2nnp6en0pxkxPc7CFrvpdWxNb6S*)
(*e+QW0epLRmPeRDPmF0rP1FSN+nQAAAAAAK9K5vLtmyOI59Ok5PwxgZ9i0d7L*)
(*1z0FFgzGFxDbB9KqO4Assuk0mkFjxeo8oDdIRlCfypRNZ8km2ZfZ5DQIjXqJ*)
(*Oz/VmUuPy5CtiPqLRci3Jyh2XnclkUfTaOQEDzo1qMRsjZWdq3a56tTlHM5J*)
(*G9w2AAAAAIDXI/H08XGurRfU9KFlBJPEnCW2PLrrIprR4KSNEGSThonlvj79*)
(*RU2bg0yfujXN6/Spi+6yVdGtn8ZFJW6XQx3CIrQnDwgS32hQu8o484sdRfrk*)
(*Vqk7Fi5zWLk9nJMGAAAAgDeiLrOWNM1v+gRSH5NW1kX7cJpmeXn81G6mTV3V*)
(*TVOXJL0sK0cTcDs/bdJUWZokXcGKZ3zbqcrTJHvOgwAAAAAAb8na7k4AAAAA*)
(*APDGsC8OiNGZSS0AAAAAAPB4iizxTBalJmpOXmFVEAAAAADg7UlcXZIVlaAo*)
(*kqz7mE4DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANgnDMPfB7//+3/5l3/51k0BAAAA*)
(*AMD40z/902/+5m/+qdfh8//LZ/+7z/2rV8psj5/4nz/7z//bz31+evGjjz56*)
(*69YAAAAAAGDouv4rv/Irr5FTk2rC5XKRk+Y1cjugDLuyKG791gUBAAAAAFjl*)
(*x37sx/7wD//w8fmUltR6RVJUPT6rc5SR2RZINMK3LggAAAAAwArf8z3f89Wv*)
(*fvXRuaSO3HpERlg+OqObCPVrWyorfjeOIwAAAAAA4W/+5m++93u/9+HZVKHY*)
(*zaLZ725tsY4731HQi7cuCAAAAADAmI8++ujHf/zHx1eqPM3KzaCxIkuiKIrT*)
(*/DisrE40UfKyzi+jE1ZasOoKNfWEO8erVWmgyZJBs26qPMvKqacYGZ3/qPr5*)
(*ffPtuUFiHYfSeKy4AAAAfOg0haNJmpfxP8so8NwWL8iqWwedOk9j33NtJyif*)
(*nlxVVJ0I49Z5fumXfulXf/VX6f/rPDbVLm5MMKKVW+vUkLpYe4ZkZLuCLkO9*)
(*TckvutmqLtHLNVhb6vTVUZrbtz2TMmy9Q8kM8iLzLZaTNl1yrWKTZGvcfyH2*)
(*Rok9nZDGY8UFAADgA6eMyAKTGhXdjEaduuJk0BHM8OScRh05OhuxrpJmOHnT*)
(*pSacGw0B5Ud/9Ef/6I/+qP1PQsL6KeKKk1aapJ0UO27/SF2NOjbbq4SNp7QJ*)
(*WTXz1jaWFHNv5nPcd0m0jq0uY9uSB6dGS2YBaHQp9iK4q3NdxMOUDTe7OWzt*)
(*VomdkMaDxQUAAOCDpk6UbjzUMv6nTJ0C2zaU3lk7cURDk5nUp7iqYT4ZPpvc*)
(*v9Is4Ked4Lu+67u+9rWvtf+pi7xqal+7rjppuadSH4NP25TGlXggbva0CvFt*)
(*FDJZGmi0QfzlXWReSAmSNKHE8c5K67MoqXsmqZppOVG66iIVe3VpMp0rptK5*)
(*ameLd7PETkjj8eICAADwwVLZnWd19flQGZvtuDV4UxGb8BDDg1mLnIQ4dc7E*)
(*6qRbEehkrm7FKwBjvvKVr3z/93//+EpMfN+Fk8bcmPH13glZ9XvKrgmuZF0x*)
(*U7dm5wpf6Jy34AY/o3OZRHs+F7ZJGXZLmWa0vyLYuAqZoJKdrVmpPPbU21y1*)
(*myV2LI1niAsAAAA4Bx2kBNXrr3Qx6uPxlgUvHThpdGZm98QtNmthp+90LajO*)
(*I9vQNU33U1KHpgjd9kKLFeWvV2bXdX/iJ35ifGXdSSsDKnFj5O3UNJRr5HKP*)
(*aFyZr8RVEfVutEVkvs/akfhHunuq3lV0nRZj/26rvVthvnpT12VZVmu5xHSp*)
(*92ruO3957KuiwAvspDuzWDdL7FgazxEXAAAAcIqCBpDpOydlFWSlUrR2xuA6*)
(*deg4pa4OdRx6KtfO3MgbUiV2P9peJCuJnGH07bxY49UO7dI07dd//dfHV1ad*)
(*tCqi3sXFHJ0nVkXGZeGHMOrOMVM94pUxx7u9rZrdM6k1cc7dwymy+iYnjawP*)
(*XlXHsRSR5SboK0fXxmztXE1PzFIVc1dtRcWeIbEDaTxPXAAAAMAJauaZ7MyS*)
(*0cVQMd71q/g0mmC6jqbIkiTJCp+PWsnuHe59y+RumM4jcwjUVy0vKxKNjvwr*)
(*8zm1Z2iqto2q6s/a0/ojP/Ijf/zHfzy+su6ksSmg6dTl2mQRpQi0bq2TzhHy*)
(*WHdzPu/ZVGWRpbFnj3dArs8yDdzkpDW5MfNsBNGOV57lTtrhOvtAlbh9mZdP*)
(*3SqxE9J4lrgAAACAE7Bx8GqujJFNlYSuwsdT3Us2U2lSsu+AjbiSLPfjlR5M*)
(*V9P4BI6+fjbXG1JFQdw6MswluyhRwdyriEbaidbSSXNVEnu/RffUmmCP+M7v*)
(*/M6PP/54fGXVSasTiwp84vGWgbjuctC1TjaH2c8pXZ2dTbu1b3CXVXb3vM0m*)
(*EbvpqeP50Trzu+IJapAWTVNXHZtP9U7auU9WNVnk9pNpiukvJX+jxOZPH0nj*)
(*tLgAAACAYxoWUSOuhP3UiSMKk6MF2ErZEh7gJBs+CwjKfR7QLU+G7jpi4+7q*)
(*kV9vTZMuJ/p4qLkZv04Z/uqv/uoHfuAHZhd3Z9ImE02bi3ekjfqzYfmzy5m0*)
(*GVxDpueVNWVkqBxNU8kW4KuskunD7pKqqO5iHpVO31017+TE2GknrUlDR+Zv*)
(*E4rp5Rv33yaxtYxWpXHLDQAAAMBJSpMObTux2U3pm/w4q43Tn4YRf+SQZa6y*)
(*NvZV9JSq9+mkheSU+3E1m4zG2gnOax0d8oUvfOGnf/qnZxd3Y9Ku41nJLe+r*)
(*8LWJt8NOITvhmbA7J45NnTrjOUTuxU8mERfuX2kIt4UjnljubNJgcM/U1j3b*)
(*Tf0miW0ksSKN224AAAAATlFZ4pGTRgjooVSrq6KjYW4y4q+H+rAc36WTxk6l*)
(*UL3hyCy+HLx6PkPtGaqibqGpqqLbezFpX/nKV37t137tn/7pn8YXf+EXfuE3*)
(*f/M3Z3euOml9XNl0r6K15tjUTnf2qzMUhk9pzjcOrFWza7L9qSEWk7aXVBka*)
(*7EsHp+mFv5Z1657ZPAxMOHTP2DM3SGyLQ2mcEBcAAABwDJvXOnTSGrp5c8NJ*)
(*65c7x5vmRm7AJ8NJ4wFL48E6pyFqkrUaj1eNvgawwUZM2j/+4z/+xm/8xmc+*)
(*85n2lt/93d8d//S5z33uT/7kT2b3b5yTxiZCx0uxqUMmMGcRdFX3GabJNzr7*)
(*dWfzqCFoGOH+DNiJjQORcb11h+yek1aFwi3uGee0xLY4lMYZcQEAAADHNB79*)
(*5uBaTNoEOi22NZA1CTtAfuzM8D0C1uTIgvjdxqTRr433ofVPQ4ia4J38Cvdp*)
(*LMv6qZ/6qY8++qhN/fu+7/v669/4xje+4zu+o6rmYqYnhi3j4thBrMOnnZhX*)
(*OduXQW4To4nfwDzM+RJqFrmOGw9BXbVHgqwOJHDspDHnXLH8NMvStDuWPwrD*)
(*INw5rqK2qY+mBWs/Zq7znC3CBxKrEquLpzNC4vkdSuOZ4gIAAABOwCLHrpMP*)
(*ODZVkWWT+Qm63Dk6S60OHUPVjIAfepvY1E1T0v4OetrGbBqk390ZvrPdnXSD*)
(*6vRw14iGqD1g6aooWPV/+Id/uM3hS1/6Ev3zy1/+8g/+4A8ubi8devb+Vc/m*)
(*EzQVFbxstb5WHdDdhfIsdJB4O4v9hqzJpv55xD+7qhi277v0PH/d3/xkEi/F*)
(*8UxabE4/BtujehsOTabtneBXhY5lbmMY9kJW7MEdiWXUheNe3KE0nikuAAAA*)
(*4Ay5S4f/UbBQxXYTtOO3G6Zp7Gjd2CPqow/fkOWzy+QM0pyOV1fNrcjuP+JW*)
(*CO704wJNRrOTone2GjQUbHBZWIiabG+fPfJi/uAP/qDN4rOf/Sz98/d+7/d+*)
(*5md+ZnxDPT5ilzk1Mx8gN4cjTy6S5s7d3zoSZmudBL4nYvJJ1iIwxnkJkhYs*)
(*NmmuQHxva/8Q1yJYXxze8oHpEcpbH7Coow2fr2cnxmxTYrmvjR8/lMYzxQUA*)
(*AACcgi17aYOX1gT6bAAU7WDqGPSrluMFuDo15PGRHbK/+PxTQjIbf4Lq3dKf*)
(*u/vQg0m/8Y1vfPd3f/c3fdM3JUnnCv78z/+8aZrPSKfMsyzLi42PVxbZ6mct*)
(*i/WvdNU0sbw8/dXy09Tdwa8tSZJmeVmQuDhpfQ2dfun1ojzqwLENidVFWed+*)
(*655LbKfyoTQeKC4AAAAfOixgfnq8Rl22A3sXPNSOpatjTzs0tQPtcj6sKroh*)
(*K8uKtaky6hUI7ichYoetdR5G672Y3/7t3+48Wllu///Zz372z/7szx6c4QD5*)
(*3vobxgcm0vZ3xGi0pPMGn3ktuoXZjdNmAAAAgNel8cmAaOx8vvMe0LmRh64e*)
(*3g/2SdNXKG1d15/5zGe+9Vu/9atf/eq3f/u3/8M//MOjcxxB4/nFB7f8iDoP*)
(*PC+I0jwNuxB7YXOtU3iLGdcydsixvBo+vwkAAODdkJN5o6v/sDmuJiNHVCnu*)
(*J2OCggfdWclrlPcXf/EX27x+7ud+7od+6IdeIbsJOWuX15ncjIzRgrigbmw1*)
(*oJ+L3YhGeyR56Fjue4uXBAAAANgWwuXXfF5OFphkTHY/OfMTpaOrsmK8zmrb*)
(*3/3d333Lt3zLt33bt/3sz/7sa+Q3JfM0Mmf4Gt+9qhJPUxRV1W1/60ufdUBe*)
(*GMyTn2sHAAAAPgwy3zLc9Pi+G0l9a771AEz5yZ/8ydYz+eVf/uU3yT1xu4PU*)
(*Tnwg/eHUaRchaYY7n30HAAAAAHg9/vZv/1bTtL//+79/qwLU5dbe0Nemfge+*)
(*IgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAPigaKrMt/XrRXSz+k0KUESOLFwUN+sKU+ZxFKXF*)
(*ekmK0BJFUdLclxf0LWpdWIrUFt9N30bOd6EuEtdUhYscVW9VhE+MGO+orico*)
(*A1sXr8L1ehVlzU/K/bvfvNeDTwt1ErqqKEhm/NYlAeBTSGLLF44RHRj2h1CF*)
(*18tFceKqzBydFUbQo9V7o3ZU6biGL/MQ3qbWpKakduEr5XhnalcRuNjEFzbB*)
(*8/nkiPFe6nqCwhC7jAzblFgDCV7ebN399r0efCpoMrdXJNFYN9oAgJdQl2We*)
(*uNe3M9e0myu6LvLOLkj61hxJGdmi0P7uP+/lP3GssOhGrjeqdWGrXfG9T+zc*)
(*RSu3LLKJoya+4UzauxVjr2CUF6rrDfkSp0v18u6P3BNWFbuODd2ljfba+j/K*)
(*+hOfC5hQF0Vmk3c3OGl3Z2ZPwAdMaVzf8J260shgoRqW4wVp/jAr2yStH6iH*)
(*fR3fttafWOpYemMn7b0yV7BXozKJJpu8Sao8DsJk5hkmVls6Y1S419P/Rdaf*)
(*4FzAksSS4KTdnzezJ+AdUlnim7krZWi0WVvxo4f8xlO7McmM+7HrLWv9CaaB*)
(*k7bKUsFejZpq8k7WTeaSyQ5rdMcr6f9a1p/UXMAqcNIewBvaE/BoqjjwGZ4X*)
(*xMVTlbb/4Vdcv73Sxeen/I72jZuZa7P9bxlbuqrIimZ5xTTduuh+kiRZVhTD*)
(*CUaWvU5DV5W1qGpS31JkWTN9/msde5YqdyiaEaTL4YCML1rA/qjKPMuKanOC*)
(*ty5T11RVM+zvaLpSKZIkKZrpupaqra131Lmj0rWdi2y6gd9Wunh6aa03ZO77*)
(*ruvTaKAiDlyPSZlcoYJSg2EGu2nlo8ht8orpuJamOsmo+F1lNZlmbfv5pLM2*)
(*WeQZqqrpmqKotp/wFOuYNbYXJgWVj8sK0bZ8fSrfFQFmpCTt/appqpeZk1YX*)
(*gWOS1GRVM7woG0pZZp6lyZrXFi8LnbassqJafkIfi9rflBbNCYdH6qKrteG1*)
(*V/L2P606KaoRZOPizcVIHlFJLm29bJqmF89askmCtgBdKWkh64ayXuEtlS4S*)
(*vy1UJ4m2WLbHyrWuYCvqutt221StGLsnNLXLNR6vqKZRq3HKlWdN8p6Z9SJ2*)
(*WOEExfUDz6NLKHfUf1KrtZ64mjUTixU3ddpqQJvtFz76v7iS0rI1cW+zZtVZ*)
(*6xTLXP6fP/dPJLjZyudrvcra400W+twKdwahaFqFZF217Zo1e/BA+Zei89Pq*)
(*qKU2O/u+8dwXQha5pDdJqm5q0s0xaev96KjAN6Yz4YRhedoZsLYl37Ra1ImC*)
(*POLH+bkEqe7Jbta0vc/WSYqmx3r2hj3ZsbRMcGXiGJpEfm97R1bVMxv3QsUG*)
(*96HJDB463PYbO8pbCzZcuMp22GlREdnMqnVDGzPXkqr2ceHdT6rfp5r5Bn1c*)
(*13jIsaClzVPm6cMD1/5puTM6bUlIsrKmKzzgTHXTWXnDLrhaMk1D6h8XjJWu*)
(*1mRD1NqVL2oUfqfKgmy7ri6Rx6/mUvHKyBQuwrhqohk9vaDWi7LllnLtU5B1*)
(*hzppeejQQgmy+Z++OAiKz2A3AQksl3XbtfVZHFERWrQ+umnIrHwS94tKm1wS*)
(*WuOq8VB+yewybfLR5ouQFC00VIlfiQ7zXRF87lPBq2brKPRtwJ20KpRYrS1L*)
(*Zxl1wVGT9lJMrf+D3OD4ljy+cDGjsinCXoqiaqjX6Q1hZ6bG+taJsc1luE1U*)
(*5UlLdgaQUVh0HNHs0LcmCQvzBbIdlY5oVL4gW47Fs9LyVQX7N19cUdf9ttug*)
(*daBoQRW1HY3YE2ZAx4LKki4zBMWZeDVseXoMVaT76f/TRk9cyfpf/u//Yshq*)
(*aIh/+a//N/YH3WTRRI7B6zpsu1jvFMVKBf/kL3xlN8GdVr6h1mtsPN6EljqS*)
(*st5qc2gwFZGMoD5U/nGHGotO6pp7u8zbnX3XeO4KofFpUUTVso3BIpx20rb6*)
(*EU38vHXaTWfgjGEh920MWHuSL2jGV6V1VZmgJDPaT3Cse6KijHtfazqbrQFr*)
(*y9JyyogaCtEOgvF4dOEjzgsVG9yVxqGNILvsQh3RRlX9YrhH6tSMNBEz190N*)
(*dlCUhceGVD4Q517XtrpP27NJHao/VyMskijwzF6dDNZZWlvXeJ3tF/kWs9ph*)
(*vUicrLHX2chW0j4g2dHsbZ7mWkYh1z3RpOWKzbacAp+2a3NcGXP7nPiSUO8A*)
(*Pr/WqxnEbLyU4pHau0p7wW7IjEcvKGZz6qgrPZ9FpNlx+0ljvxX2gp2zLVSy*)
(*3c1BUdN01dhg2mQe65CK2wximdhMdxzZu5PvithThaRt8RtC9g7ApJRSVePL*)
(*TL5GG8iqnqo4DOzeNxPUIC2qIhospKD4SVHmIbvSFr7K2ndGnQ+l3fDh+0MK*)
(*F6W1J3MxjrWC5OInecFD4q9cAplLKiFZzK+MDN7wlh/MJ7I2VfrrCe1VbAGC*)
(*jnHDSv1UwdbU9UzbzalCkuqVG+PG09gTIxe0Mue6PaeOzVlJ7qv/Oz1xknVT*)
(*ROMRRDIs8k4hWTFVy8kMLVN7fmW3U6xUcDfBzVb+r7f1+jm7Qhuam5QzIS8q*)
(*zEk4VP56W3Q7mW539j3juVuL1GG9id1chkxvTjppzW4/Om+d9tMZc8KwEAls*)
(*DFjFpuR98n4j2+zsEb75XU52E/yjqNO93hC2Rigvc5f3Pv5KMh+wti0t+125*)
(*jO8vTVY/wXK9bu79xuEMPJqKmqyL0K9eOCJrknE35A3KzLXm8elTbt+owtBX*)
(*G9EKkjiOojhJAvbuzTo1i1uWLaarnRqwLiMFSdI9EyehzV4k+0jIOiWD6VWL*)
(*yJzzzuJTTxEQn+7aO2lkyFMdlmJmX65bQSnLCJwX1nqZA3287bN8trCgFqY3*)
(*GgV9M2RlYPdfbbYw1ziiQFqk8UhnpwfHkV9SKju1vVLSAyjEYGSKuH/I5o6o*)
(*WMY2Mx4HjWzmuwI7q0F2RgtsAS0ArRZ1CC98+oVGp/Sv5E1CXu6uev++l9IE*)
(*Ba2fqU9oCvwRn1req9bv8PW5W8ILORVjn+Z1SJO1HZNAbdNptOEcp4zK09iM*)
(*q1tTaaYeF9anWGxeX4yVEK+Zup5puxlknrmV38iQ9tNTg193HF3GDMJknvme*)
(*+r/TE5dZcydZjugdtNezF8nxMvo4+nG3U6xW8CDBp9VWvrnXTzl8PPOYGRSu*)
(*ZL7ITsaPHyr/quj2Mt3u7DtNtpdgzVwje7QDP5x0tyP2+9F563TQH+ccyPZo*)
(*wFpKnoVBXtTe7GQuU8nO69tPkHuYQ++b2tVlp963tHVCl8akqJ4Whr+2vFCx*)
(*wQNgw5BkUSOQ0x2ULQ7RUdLi/cwwj07pzdnEvnGfXOi5ih1XUaWndFaLSaph*)
(*skK4Th66XiVagPalUiCO/U1hkb0ppjklw2LP1XDCcs/H23TSnlvrFVivF5hg*)
(*o2773Hj6fVqG0WLQVTHCbFGwiWmqq6rLtoqo+z2N2+dvkdSerDhp4yub+a4I*)
(*jQpBHB9TORv7mjKJk7JuiiTQ+5dN3kDVYn5jeYXuHJk53pMc2RTKRWUGbd6U*)
(*y1mUqQTYmuDonZG5bbIzGSLHFV9rgqcyS5KsbOoisIdV1h0nbaauZ9putRiz*)
(*4S+gajasot7gpC1n0u6i/zs9cZk11wFrItwVn2p8Za9TrFfwIMHVNJ/T60ec*)
(*ebx2+oV+2Zmleaj8a6LbzXS7s2832V6CX2Ov/4Mz8LRmcA7EtNOPbrBO+/1x*)
(*zr5sDwespeSXpuyJaiRdnTpIcL/3Pa106l1LW7OgiOH4ypq+IF8UMq33QsUG*)
(*DyFm6/Va0Y+DtFW1dqjK1U7d+hFqoQ8r5lEMN9tyc3ja7raFIazYqEPmprjJ*)
(*+rM7aeXWl0rXC/nCWq/QZA43FG0SqdwtdY5j8OY55oExKb1ik3Dzfhp/5f2x*)
(*YI9MB3q+nE39kAMnbSvftfrQty3FGdViMfZVWUBD1QTFdEx5bLg2B+jtK2sG*)
(*P9dYKFK4KsZlmrNE2EvoRWHV4AOBNQ+x79lye6qARRYJhsMG2/NO2pm2m9Ak*)
(*dAlj1o9Y1x4M8ouctPvo/3ZPPKMDi9wXV3Y7xXqap520hU24rdePS3HqcbaE*)
(*PVox5Bwq/3Y7bma62dk3m2wvQT4TqIyjBG510nb70WnrdJTOjH3ZHg1YK5Jn*)
(*qwxTJ212/3aC+71v7YZdS9vPK8rcVrMpetEeTaQ8W7HBY+BnWjppbpMdlCnv*)
(*X35gdtEIg+qfMdeTGEV6U5pkzerjw3qrOtt/Uudp++pDncb5RrITrNmoJvb4*)
(*8jut7/oZp89z0nZqvV5AFuejuFlXx+t0PW1FUE0Rm+qo+LLbPBX0tVCaLoW0*)
(*twZ+/BWPzoleJztz+ECvk/iW5Tvj0kCt5buAJzsxNVNjUoS0oa9O3BWIr2/e*)
(*10mrqb3Rg/EgcoOT9lQlbKVBMqIkolF1wt4r5KrbU9BBja8Q1dN7jp20/ETb*)
(*Tcmm3umkdq1Xxx94nJN2k/6v98QbnbTRFM2kPHudotlz0rYSXJXb83p9z6nH*)
(*E1vpRSRZ8fi+Q+XfacedTLc7+2qT7SX45/wFYWzZbnTS9vvRfoFvS2fMvmz3*)
(*B6ynNcmzYIaLPHvVK+IgLpqjBG920vYt7VN38i33V70o8qijK/Bv571QscGD*)
(*mOz8clpdqcNB7yezWAfmmsc4Tt6eyHSuVq4+PqzsXJTJilLVPqOGZbcOuLqF*)
(*87BK057SDrd8kagKTIXbvdU1rJudtKNar8N7Lukhmj/9cZpjFUp8xap9ReKb*)
(*fOS4Xs86c+XL1fqY9f1pdxumhmi0CclGsvsmTsYGajPfFaGZs1DGIS+2KGYI*)
(*k8LU93LSJt8BTKchZBvLnTtO2tOTT7RDlqWrcBWlw4MvVlXaoI3K5d4PCuul*)
(*WlatPtF2q8WY7VljTtrQvsfH0vZLM8uYtLvo/05PXGa97qTxkM5BDpMT+fY6*)
(*Rb1awYME1yTw3F5//vGKLEspTthvAHFGwV2Hyr/qpO1lut3Zt5tsL8G/5oZ9*)
(*vDrPi33KSTvoR6et01F/nLMv2/0B62nVcA2PjJdLMplM0R8leKuTdmBpO0gI*)
(*9EWSJbH7fq+q20k52lv0IsUGj6LweSQas+d0v8m8i3UL1vTE8n4poR+IyWNp*)
(*/6U/QQnStuGbPHLFQeGXGyeHrTedWlhBWTdNRTewiK0TQu9XTC/NsjTpIhnD*)
(*MAiCqDzy6VnH5IEBcTs4SW7/a0h2Sm+80PU6321Yd5ygfmmtt0j792R7/nWr*)
(*crILr46unfPcR3+zwNGw6tezupkfchhPk/pdl9e6t+mMRx4PAzcLSOBXEh6c*)
(*z45pSFzmatEJme18l/SxtQrfwcS3yNE9KUyj+IRA6dG94aJVFJHjpcySjAI5*)
(*Vq7Ekyus7qPdjjy4QuVFLmebGXM6RTxKk52uyVuK3iDb0el3xhWV5nHCbLwo*)
(*E5c2khnnsesk9VLB5up6pu1msH2pXYBx/zt7+Ro8Pb7SsbO7sx9i6m45yQm6*)
(*CZN76v9OT1xm3evA9KgQHkrtM7V12b5fppm7nWKtgkcJrrbyQa2rxFQVRdEX*)
(*52ude5xKmL4g87Xs8SaaQ+VfFd1epjtGZrvJ9hIsfL5JUunFFpBnx4e37HDQ*)
(*jz4+a52O+uP8/gPZ7g1YG5Kvon4WxPA7P60pU5KJTkzjfoIskmSr9y0GrD92*)
(*dy0tty3K1iC6r5l1Hhqaathv9kHmD5c6ZoEcvXfOwguV8ekoNd8Y3g/EVUy/*)
(*z9jaN2I/+EaqKazj1HlAdbU77WeUOd/qMn2GGIF4MsU+4iBKrfaYmZWpKtJ+*)
(*J5tkt1yT015orwca8VcJQRS7cDj36y+r9Q6zfTcjObtsh7YV0d2CEu0yxODn*)
(*dDabutP10MFHsHG84BGGgmLndSd/enM/Y8CNT1tXRVOlaSJX5y/+42a+S9ie*)
(*I1Jz1XSdYed4l4b0W7/FW1JSlFmjSvaXQzaw9qajWVypA3YIkTJu0xbdI3av*)
(*iOjbNF/rXIiRH83djRosTXYWWeuVUmMf6eNS88ILV8XwVt8iV1W6nwfrzjiT*)
(*Z3WVk2auYM1CXc+03YKCH0Ql2FHeTTTQA+Yku3+g5HqrbHuhfRizKHXJtYPg*)
(*C3v9jJ2euMj66wE7xUXyp2cU2xKXjab15yVQropb73aKZQUPE/x41XDt1npk*)
(*uNRVp3rn8aZKiRoOcSbdNCArn01PMT1S/npddDtl3jYye8ZzVwjhcGqYaDqu*)
(*OTl3TDj8dsxBP/r6tlW8KZ1FTzg0LDsD1pbkE3tFJflLwV6CDQ9Gkpe9j2+P*)
(*mtqTf/s7e5Y2bQ3Duo0TFS8pD9s0MtipRfDSXp+gaxh9NBJ1Wwb4oaYd3G3j*)
(*KE7saeMLbJN4lehjM9d2InLYd+7PzjlTx+5f4ulj09gaBD4XEs5cB8baUbR9*)
(*Se3pM05ac9Ua0N2t/Xqj4ytF/b/85xfV+oAyaJ9Rpqv/vePU51gvu5WoD2N1*)
(*GY2Nn8BmDxhFaE9PZJ0dLlc5oyMS27e8iAwugqS6YVJ9vJvvgjrzx5ZIYvZQ*)
(*UHQ7zqvWQxi8OM1L2YGK7cD3xd+ZtpcVxbPmssJ5A7bvlcOEyah6pp9tiNH+*)
(*d9PDIO1o5pF1B7c26fSpcdWnQUFPeypdOkOTiG7cv5tK9OD7sYIl9Yq6nmu7*)
(*BU1uT4+mlDSHf3OgCfT5+87yvGhy43Dqr+amL+z1S/Z64iTr/6hPnSXVHWJ2*)
(*qsQZfhSNNGdnxLUvB0lBFHSnU0wreJjgf/jCpL4Tw7Vd635ic+9lbf3xetAH*)
(*Guw99zk7Rd1V/nxHdJtl3jYyB8Zzr+lr3xiV/SoxiyAqth9vfy6mZ7cf7VvF*)
(*8+ks2DcslI0Ba0/ysTP2fQTDSw8T5HOAnLb3TW0OXTie2pOnbUtLjz6r7Y2Z*)
(*j+7ozvqgTflWXzE6Mb6BO1PlWVHvXriB7qNNeZamO+ejL6jLrKV9Zj4N2xRZ*)
(*Gnck3Y9l2s0YXNd3ymzR1N13L+qyTSlNs6w8qld7f1ne/KrwjFoX2c73SYbi*)
(*VKT4RUaKny/9005ESdL+tJZYU5Ef21+L1YJ1z6Yp/cZWm8foy/WH+S6p8zQl*)
(*7VR3NiZNJ6Ju06uGwxDa5iiq53f1Pr6lrou0IztcBD+CHpAuh0Xdtn9R5C1t*)
(*1eOQnN46OwjiiKocVbWVYTGVxEkFO2q7lXyLLCFP7Hw07TjXtnC3t8wZ/T/q*)
(*iaez7hq91XgqllZK2aK6O51iLZfjBNfZqHWTZzlxaA++XfscU/li5V/LdLOz*)
(*nzGeO7Woy5w2Q2cRylaut0U2bfej26zTfn8cc1a2mwPWTiGIjt0xQc7cnmxb*)
(*WvpdGMkM665JiY1rGy7pvkl1mR7wu9GmrYVPjkdQ8EHTTfHJztokAPiQuH07*)
(*/wFsK4e0EjDTfXRDw4Hb4CbKbtZh89DsF3F35Qc9n2rZFnRaNFi+OHSnQgn4*)
(*SCd4Jk0Z+X4Yp0VOO9B8tzL4AEmsO9tSvqwjdKtmWfvq2c2nZUlAvv4oeOsH*)
(*tgCwAo9OV+MXT++ucnflBz2fZtnyNWJB0twwKcrOyJVFFjhkSyj5HigAz2Aa*)
(*oiQFt60MgE8ddZFEHv9QsuhE66HZt9Lw+PBlqIaXIkwW3ECV+pbzmNjqxyg/*)
(*6Pj0y7bh+xoWNs7wYOPAs6lST5VlWVFNd+WLOOCDo0r0Th0oiiwp95vmqpLA*)
(*NbQ2UZlonO4Emx8bAOANeKDyf/B8GLKt8sS1DFVhRk43nfjMNjcAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACfTP5/*)
(*N6JOnw==*)
(*"], "Byte", ImageSize -> {385.39999999999884`, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJzsvd/L/cx2H7b74+8o9Ko3RfeFtqD7JAJftmpIbCxKCq1wSovcpA6iJagY*)
(*u8KQiFCzjzmoHBCYKgTkJJaLhX0i4iM42YktHyMf5AN6D+gFvVTvhS508XRm*)
(*1ow0kmZmS/vZz4/vOfrwfXmfvbc0s2bNWmvWzKyZ9R//4v/wC7/4H1wul//w*)
(*37tc/r9//3LBf7+cOHHixIkTJ06cOHHixIkTJ06cOHHixIkTJ06cOHHixIkT*)
(*J06cOHHixIkTJ06cOHHixIkTJ06cOHHixIkTJ06cOHHixIkTJ06cOHHixIkT*)
(*J06cOHHixIkTJ06cOHHixIkTJ06cOHHixIkTJ06ceC+MXdO0w0fUPDR1O35E*)
(*xbvR11XdfzQRMgxdU9Xd9LFv67p9FbHDq0s48TwMT5a9oavruvlM/ftxlue1*)
(*+BnTlM/ZnLZRjA5jUzdvLDpj/7QKkKRj5evffbQbqtg2bcd1XccJ82b9k2W7*)
(*GLblXBtG29hVkW9rFwrD8tKynd6qk8BxcGkE5O35g+P6yTe4WGv6xWaAR5JK*)
(*xdO+LnxLN4NC0R5SvSuu3nF/9w9+37MNRLbm5a/h23F06dXVMdf0/NNpEkFf*)
(*x76j4y7VPimFL31A6Auroc5jx9Rf049dmbyyBDXqdFYEXg6JFsTt/QLeqcyX*)
(*kVOZZaGo1Oj2YKkH0aGW7ZC9IQ9dHeyOZvhRlkWuHZaiJ8fiajMTddHtsBM9*)
(*9J7oq+yDLM9r8daa8s74pM0Zm8BEknoViX+fhZ6hvbllHusY1eGn1WsLavPZ*)
(*P7jo4e19lW/s61vCCNDieuR/asrUxF6Lf2s6cDXq1Ac6r+mtbduqiC3yrhVk*)
(*8OYtwGpr2q4fBKDCF8NGf/seqUTzu7Fvm5tvQo1WGMcRwdV38LPBTUJn7RvM*)
(*ifLlLk1fEKthuj6uH96wPT/wfcfE9bvf+b89x7xTyFtgqCPfJWJpFO/gMIxt*)
(*WR0TpLG7XX0YL96FwkfQh7jr9LQdb0noWvpr+rHJo/slHGfjROqVCJ+JhM8F*)
(*MdTd4Bp4MHA7zf0S3qfMl6G8EtU3vYAqpWZ512sAZt9JHiv1KBFEO+7I3pgS*)
(*8TTcsKzrIgnAaDmpgMI289BPEZoftRkpVss+2qdp8vhjLM+rsUdTuqr85KvP*)
(*Ez5lcxoPSbMZimUfuRqBZ77L2DFUEbYw19eIaIvbYkXDy5jBCOx+hOvY53Tu*)
(*c7Fui2WSITQuxpXOg7oiIM+Y+cI+NOBsmFfsjRSebkU1/DASazl7KW2iax68*)
(*Wl6JdgeLGVYTWxdH1vy+rtsqce+5NKghNq3+ZSRDgHFjwpk6uotMW5tqH2NY*)
(*KD3v4DA0iX1xsuPvvR+Fj2IcptVCkK5X9OPdEh5lI9KbQkeuF1nZhFouVgy/*)
(*3DztwenhW5SJFNbXNTclTB2Jx3ih6jsW2ruu192TvT7Hv+v+9Ds4Y0mzHXvA*)
(*9TUKYsr6KgujD/doCD7M8rwW9zSlsT+B07gfn6w5Y4Jn806tfCh1tfexzDAd*)
(*8PMH2z8sBv0+i6Ks+ojhZLixJRBMDd+YwjM82rraJfMiO1rznk70LjoSgzIO*)
(*b6wF/S1YSk6fxTl4TLdANGHpyzRXzQqHdYEb9LcwntykfmUkhyrL6gEaq3+A*)
(*YVnT81ZoU12x3qUCo/BL2O1n0vVAMymGMlSJ0+NsxBphMcJyMlWxY6o1t8AO*)
(*bo9IwFuUiecslk27u8tgtYcWOtxsU7gM/kYYqB8iq3Ks8E6S5s7WB/t4lmgg*)
(*WM9lPgs+zPK8FmpNyTz9M3Jbjk/VnJ4sFEy6LAMZMd9nstmR/X33sfXZsQpV*)
(*uy3vBmwcjCiBRZiL7qbTL8ilcYlLAyMI+C0bkLWmTUM2Ls2MrUvT58Fdz1BR*)
(*oPBxsQsx4M0p83prihDWpkwv4cbwsQhdthFnXDOBpDWpb5oWDgCyTDfCHtRQ*)
(*Rvgby3Twzj4ODGB7ibpzzVnhMz114hn4ecuLK/R27MDbdlz2ajKaPKTOp27o*)
(*mrmdRLfF9cLeMg3DIeS9dGVgG+xrJ5W6zUChleSJTeJ+0MMZF5I2tgVsnuFm*)
(*OFdZ3FNXpg57TDfdqQQZ8WXizwESMbYlfVNGPhrBrOyWkg1LPa6Hrr6FnoW6*)
(*CzoUhMEMkpRGTWgcq+WkDvXVnv13mTi9jo08GtKLWvLMmJS3KBN5cC5hYnr/*)
(*UQFEMj/2ZRbZyO0Isa4ZTNd4rtXZlTEU/mdKjfZwo/tidjxMX2Vr77svY8vQ*)
(*+K4jy85jmQSs1zU7SGklQKGBpCjLiBTpbiISarEyyuT8RSTShF615VlXeou9*)
(*qRAvTIsiz/LbT/5KoBqyBqrszN3e2aUp7dWaOGAaf+NXfvWXwDLapunCgv8t*)
(*ci1UqWGG/+4rwm3NuuZFBPzULD+9r7NLCNnOLIZ9a+vQgc1GM+E19NnN+e0/*)
(*/AGOKdXsrMyBbE23eZuwrzngyS9GVaGdJBEdZoFaZ0+tm0qUa99D3C5DZGYv*)
(*jtTLkmjTULpI4TRO98Rxbu8CsqaNFK8ibblgp5HGCE0uTU1Wx9AvlcB9pbv8*)
(*xjJw975L46Vt12LUN9+4eO/l0phTd7g0jOha0h7N8H69mZRNXUTQa36xpmoc*)
(*2pjG6Whsn25IbDyFRKYC9tScuBz6CqIT2Ayap2fIr5jVMGVDBSYkTmCqS0wG*)
(*7iZc8jj2WWAJnfa2LNLkqhNRy7K86kZk+HFNmls0bc1s6VUcstVfJ9bobCty*)
(*GmXosnnSdHUEgQ96ICgFhh7MiqGCyCuDTPYlxOdk29JHtqAtwDXxv/9H1mUN*)
(*7w+nLw3epVkRSyVQRupYEd22srrrqgQYK3ZpXsVGTlTqmAw7/hO9j7coE69+*)
(*E1XwskdKFcp8Gc4ButhwuDYwbVpQApOC3Ilu6BKqUKp5aBXRAnU3lnkCbZml*)
(*aUyji8Iky3BlN6Jrbly0HRrvyG8kbqEMBYK27VGJMkrkXCjSoNdKy7NmKaHN*)
(*S5Ad7kI2zl4uf+0XthTnnayBCjtzp3d2asrY5tgZxIqC5hZ5Uf1lRrUyYOvt*)
(*Q51opJd/eF1wW2NtuqOzKwjZPtwWjTFsiARDP1HmPr05v/WdXxI2ZhLgnc2B*)
(*pVH+J4mdhBETV2U6EBd6MUJonVj7XsFtalpxPIwAUmFD3EO6F5DFVCtI0/TW*)
(*fFwEA3FpiDc4JszduxLZ5lwal8qP4H02FC5Xqu+6NCtsnYd1NU90aTQHdLch*)
(*k1OTxAuNTXIh7tw49MPYJ6Anpqhnx5JIjMG869a9gEs2RLh0EzxCEDbWrgU9*)
(*w3I/Fz7CkzIyvoYlSlgxeOkc2eGpEa9vsxWzMcUdqk1hng30o+aJhi7qmtoJ*)
(*8c/b3KK9WrINXxtZkh79I7HxF5FBHkmAmUbbVRpMWXoh8U08axkJxCIihp+B*)
(*Eda63vB0orh12JHuA46BzKVxIKQ9D4BY6zZISYXY9WlIbchzUnF6nI0zqsha*)
(*VYGj4xvsxTdNjf544NTktswJaK6KbDIyxf04NM2R3XAmz7NE4RPQlFCEtlMQ*)
(*KpV52ClGE0eqa4RpJrAUIvlne1I79wMgx5ydK9CcRL4zMBAxNuniSIPHIG71*)
(*Cda4Li44b00M5xtu/dhVt1u9mb9IlPFbiZwrRFpheTZoySoPU3DShIlXa9X4*)
(*K1UDFXZG0TuHNKXE7J53q8Gjm86lthkq1gLZ6Gk0ppHj6Nsxo72p0tl1d8jY*)
(*Tjv9QhdUKRNM5g+8RXNamOTrPg5jG5uMjYEHrGVfEK+MdyckRh5GTHvROgh8*)
(*lWrf49wG3dQDgS6qtWkbQPtRmF2aFxx9Tee8uFtLn7o0dEbD72XPYKs0/rFV*)
(*Gn2OaRwSW3ffceNp4jkfn9OBgGGXVgO3VtM1TRJRUBBRB9tFCKNhyUNdpNmt*)
(*bWvwVy8Sl2bVFvgIT0rJINb1Qs6kZFU7DJJRhjSQbdmTWHqeCWNpg5wLWtXT*)
(*sYAVDJsRpJs6WEnXCFH0L82IBcupfYH987YuYjrxM4hqiIiHefccB4JGFXYz*)
(*ye263TsWMXDWHVAu5GTKSP0RtXLzvoVSnB5n40xwuFimI6U2BZkoa65/DTxc*)
(*humlR/waQZkEZM1cs8MkTULMAM07ELNBw+G4CcvY1+kVGz40K/R9OHChB6J9*)
(*2BeFzHe5TNdgAOW6b2ekGT33dOFWkjdYFEXGoMUCMkgd7Vky61fEt8htgljO*)
(*FSKtsDybVi6layRLE2zgW6mGuoEKOyPvnfqQphCHges4GpQFr/dXfWbvOv6N*)
(*OtK6XGd3mxfqexjMdlEZIAx8o+YAzbPzA3scupftt5bAEM2OZ/9cYuSBKlHr*)
(*pNr3OLfpcuLqrBDGHW06PEa/GRYuDZYaOhcyvKtDw4PZpFgxFK4tw6FYmqFM*)
(*knvBCU90aYRdAF5KVO+LDCNrd+DJJNZFn2dbfeqTPQr7moTO5bhLoyDjFi5u*)
(*2xAvEfANBH97wQTaWddyy+01x2inm+EA503YERs1+iohK+X6NYnx1Jt5+1vi*)
(*Yfbki4axtWHZkLcNPof93fAHqZhUyop55/SOOD3OxlWN1mpy1ufuRQvgO4im*)
(*CxSF7CpzwNMuzZ+nBG1iWtH+CMeC8M5a7X0PhYZpo5TmRGcD8VKqRObv6Zod*)
(*TW6JyqW5hVfu+45u5Ou+ZAq0KIqfetBm3a4g1T2jUGFSFMoolHOFSCu4sX0U*)
(*wik8utISkj6P2NmKhWqoG6hyaWT0HNSUraqSrTpUf/XS4QF6Cvra6iwoUZBL*)
(*dFYEqXlZkMHJwFs1Z2MtC48YiWu/21oKKREaeWnryEeh9j3OberSCMb6O9r0*)
(*aV0aEu86cZWqZwc3PMxLTDOgB8kdaIuvj7g0tN4qDSUzQXWBwsePujR1vL0b*)
(*pwmDRDLeDGQH4OJcA32O7xpjG8QGc2nklnnVIzIIBjwpI6PrmgbvKNwCm62j*)
(*XUXre7yVHkCddS6UdOHhqzk2T2fGmqyymnw4ZpuF8WYshvuaLmZAKiSrwcTm*)
(*jCLiQQw0LhwdSZ5HIiUecGnor52E1B+AAOvZ0mFTuzQPsZGiy4mJs+LVcNjf*)
(*/MmlgYVc8Qi4v8wu3xQyFsn+c6iwzbEZuEmrue3gxhU1RyXz91wabp1W4dJ0*)
(*nrbkMzmMNk3PN1gUBT4GL2Oga3zPKlZppMookXOFSB9xaXDIJ6iJacPc2pkW*)
(*flaqoW6gws7cc2n2aopAVWG6p5kOcj64jfvDOrvbvGzI2Lo0T2/OWmK7lO1n*)
(*7baWdG+I23gS2klV6+Ta9zi32SrNNs7rjjZ9MpdmdXiARgtwNg2as41LhN3G*)
(*i70x3WTNVuXSrHfcGkdp3tlew052dYHQSC6Xf/kuYKfR52AwvMZrJWp6SNvZ*)
(*zj69648GGcIZf7wKPfTjakQmwjyZ9CqaLaeMDDy7N6lrXaeeVHI4S9V3X9H7*)
(*2WbnB+RZeEZvvfEEi4oujiCByHxsTOhFIGQpL97cCgJDlUeH05YciMTbGV/9*)
(*4a9tiWcM1NjJ/yFxNB1282F1fekjqzaeYFlVQ+2SkfpXsO07sWJYb109i40U*)
(*JPzm4m7ugiOUa64f+C4xRhoNYuyb6lYKrlm5WybIkvgc99iTCBFlqS0J1dA2*)
(*bSGRinyEW466U9usjShkvst1TmF5XYNIEmQ2mXoOoK2Cw7Pk7HPIm1cSryLe*)
(*6yf1bIPWeKkGL4XeIkg2nhRb/zJllMr5n/wjmUgrLM8WNeaPkVZNVZbVMixq*)
(*pRrqBirszIu0d5pDmgLGPOmwsLHYsDkmk5cfyWaxXY2vNS/9MMLGk2jQf6Pm*)
(*rK+8gG16svC4tzk01J/b8JUZeerSLDeeZodNpH3fPMxtFrS81a872rTxcD4M*)
(*xAu9bkwiDd2fO5HF3ltBDckbxi6FoCPD2y7NZhCUIziagSSExBPYYdPBkae2*)
(*riD0T3UJKvQXf8ZcBboHuj7EATo+HQWlZXpwo1rLzl5edNOy6M6CItKBnl7n*)
(*dh9gpLtYfhT5NOZc0zUyEBAFRDN9kBxKnh4kaUgvg71ohuVds0FCBhgEaloh*)
(*ZF2olbBoppm+ZyJl+RoWBrGNxf0Iq5qSgy2dT5rjxSU+SV0SdTOputH1AUKU*)
(*BTNHM9yyBkLvLpoVJRGLuccHktzwN0TEN+xw7MVy4FJPuORqiAUHcBYMpJF1*)
(*hlfi8boja9BUhmWkVowi+5pWVcbOz5iE509kI8bYptCpwcZFx6s0F7dEkl+X*)
(*cNzAzxq2EKTy2GVlgkhv9fdlmoYob+Wll3xuFz02Lg2+72vr0shl/sc57qMp*)
(*lJfpL9E1Gi6CVTEtq5wdPjIdL62Xm2pkb44cV6GhA4El9hXZCyWRBT2dNghM*)
(*qCeESDVyJIPGdQ9VdO/4mFgZZXLu5X8mEWm15VkBNFHDR7BZfgo/TMmVtlvV*)
(*UDVQYWd+Ku+dQ5oCbobp4r5n25RssF7eIEenMJoDT5VkxgRXsrzSvHj5j33e*)
(*ujJbATLwNs2h+zgO3ITWw6kr+sDO5rCrCexyuSm2sZMwPdciug9CW0fkSqp9*)
(*P3mU22BaJZKpFDbmM1Md/xhMgdCkWX62dExwVp1l1O5YRN50Yg3gXLONMSwd*)
(*nX9Ej9igP9b0DJ0QcnveRzZXIusmGcrIWVRvR3TKBLvStDIncGdaDI94Sn3p*)
(*cfTdTXhR43Bzl7eH806o4acJSI6RVD/hTmJqIebGkLBAR/RkRp7UTSfKaxkZ*)
(*Yx2xImDWEUiiflp2FtvMiBFssoDvMjeWzknr7GpyjxpuxDetjN35N9MX37TQ*)
(*F1OCDy9OYQHPcJNvZcR3BScqRlS0y1Or+N4M1qiZgVi1h/rq8OfmDD4hkYTU*)
(*IWNaj7kNZRl2mAl7+WE2LmWVBADzHUVcmukW3A6pE777l7k0khARZZkkpHC1*)
(*Izx02NW7sTwiwkufhjJaFKqZKT+RXLs05LI70VEjocz/Lt8FhhMGM+c1C++8*)
(*j3U69x89ZarZXrgKqcOHOAzbsRZWx43EzB+bhG8R6luyNt8E/OuGB95fm/nc*)
(*s4JgSMZ7kU2QyDkuQyDSOyzPiqWByEya3/mOQDWkDYReFNqZ7/4OZyEFvXNA*)
(*U9it8kjP+CusW/sy3zxPGTlfvEAvIrKvxSROrzAvv/vrXOuda8jlGKLG9g2a*)
(*M195wYJs7ZzLo7CrOezazGnPV2Tke/6yAcfnBuyLgRRWMuL0D3MbnLpQRrFU*)
(*2MZZ0gh/wwfv/3wmxnG7T96LzpniRKZVVX1Iqs13AFk5alTnVieM/fZ869h3*)
(*XcfW07tukLOow0d5iRqM3TZlsICMcRx6nOP0bn7hvl/2zNDB2eEd/TV2Lc6i*)
(*Kn4UlYPP9arDNFAJHRUbxItJgKTEjy2kbb1L2rYm3K66FmawlZA6dC1r3di2*)
(*9w7ZPc5GKfCeu+ZT9jQ4LAQ2JgZkhCIcaH78YPcI96VPFnWoY9Mmm/7jMPTY*)
(*FTkQgTyXind8fDrSt8RwGrJTiftlfomhZd0n0iQomXKbCA8yOg/aHNpzj+Zf*)
(*FtkEiZyTzw+LNMaAl7CcqEQa05F1bCTkOZplC5bIOArlDVTbGSkV+zVlWCsK*)
(*2RxcpxVg12Pmfd+KLcxrzMs9PLs5dJs+b/v2oAlagGQj0vmEJruN/PyGSPse*)
(*5TZZ9pFcSjPhldp04sSJnw20RQybEYZpWhZeeDLZUthArrZwkjtXo0vQJx45*)
(*6WvhS60Ni+2S4/mpcTeDjKi8EhbBEKGoRByz4Fw/JFvLzyHIEo0WLb3QMjQf*)
(*cnffFUNXZVletzVeWNhEkg/HgiE/HsrmPC19TE0CfCPZqsijeIzbJFJLfon3*)
(*iRMnTuwB2VX35cf99gBN1toGzWC51W+8axPUn3wgPLHEdIu7Zliu5/s02bqZ*)
(*f/p018UclaBtM4rCfa2ao0gD8bmgas4I191AQorX4oZ7XIufOmd4gNsk3kZL*)
(*Tntx4sSJEyeehrHMQsecs1W51/TTuzMYTYrjmjXdisv1bktBwnU0HWeP0x1p*)
(*SotPBWlzuhyHk2j42sVneTVtEdLN4mfgAW73t0DT3Zv6dOSJEydOnDhx4sSJ*)
(*EydOnDhx4sSJEydOnDhx4sSJEydOEOADcJ/6qNpQT3nxJA80VdXuPlV74h3R*)
(*3+u7g8Dpsw+c/XxVVff14pWC9znl9q2pGpr6i4iaeR6OCO0OqfvM+JDO/Zx6*)
(*dOIDUOexY5IDt/ylAZ8IXRrAUQhNkWmIXOx20f3P2YSfV/R17N/vuyMYi+si*)
(*293uBE+H0ZXJHr14peC9Wm6HxLMtfO2u67hhI/vJsoJMcWH506lSoEuvrk4O*)
(*0ewXiTq29U9qnSiGKrZNC/PaBX67xRyAekBod0rdZ8UjnfsUnPb/rTC2ZfV2*)
(*VvZNqr4lIVxo/vEZK4QY6siHS0gV193Ta0uNnz2R/kCJejXG7nb14apNVd/t*)
(*B9xmj6+2aCE75/qWsyeiyaM9evFKwdu+3lXloSlu39ZpwLIuLC897rsGMrl4*)
(*ye3uXW18vW+oTaDO2iGRgIvxrfIzT8FH1A83ev2y5uRVM/H7kNDulLpPikc6*)
(*90k1v7v9P6qnXyiaxL44H5P34TVVQ2LTT6xEozx/MffQ8EWcmDyGD5SoJ2FX*)
(*3+1DT/LQ0Vu/+ioLo7fzaDB26sUrBW/5emM/5KflLJmBFS4u5x8r1ARzhzOw*)
(*rvcttemYSEw33k9JAz8tyus2T/Fhof301liNJ+r7wYrf1f4/qKdfGNpUV6a7*)
(*/bRVs+y0H0H5LgzULHy528uP4QMl6ml42u2jk7UUpLF+G7Cp3/sNLiQH7iMN*)
(*LK9zsqSAT+cw5Ibu39Wbh+t9CP2RUW+Mp00bcV6wTwRIb70UmMNC+/5S91Qc*)
(*6twvFe+rL1I0echS5hm6Zub9S9+UkW9rmp2VOayXabqdzncbjkXoTtdAXbkr*)
(*T8uE5a3VDD/GLWuLK7t/0TANw/neD8osso2LGWQZ2Uj9z/6bX/rrpmVblhfj*)
(*tOyxY+JPph2X/cvYl1nsGHiG1VWJBTllraDBidcDqMhwpDuw66ojMk3rysCe*)
(*MtI6qfLCRpYmI0npnq/mXHNuCJLygUedeIasgRL+qwuvM2am6c/y+6vH7paG*)
(*iG9gB6BbLxf71tahA2u9ZqLkQFemDrvxSzfdrLkzAG8FAOgokykPn2YHaX+X*)
(*M7jrcapGK7w1BeWP6SX9DonS/8Hv/LqFSsIwTReSFN0i10KFG2YoynbUt2Uc*)
(*ODh3Yd8lHtzdqgdZ+zLWAYidZoQsgaOAJ2PtH6yRmTgryRNbh7zLDsfeXaL1*)
(*QhKmW/OVbJgfNCmTSM4fYzjFUF/t2T24M7i8UvAWr7dXa+I2aqBbDjKVEaDw*)
(*dd2LrvQ6Xn3Oy9nnhuZNpkMk55t6v100CggVCvY9ZuIoOHYvrc6ZlCOjXpui*)
(*R69pDEkMr8s8vgqG3+sLgeDhlGE4LwYCEp2kqRKbyI3pRDvH55VLIxXaLVRS*)
(*J9MRwff3RjQhxlvsTdbMC9OiyLOc3kU3toXLmoBzhUz0S8eXTeeqRiJR1X/8*)
(*z//hLx80MuNaYncqzl0hEYm9QE8/BiTfrhOX49hn+MpBo2hvXObPKUnu3B0Z*)
(*jgIwk7KpiwjaBel6c5LB00d90xY2+74tizS56qTlWZb/83/yy5c1/rd/QSyO*)
(*Ttg+Di0k9ETvVouE2prjubxwTx+tSJwve1V1hWRxIE3T3KJp6yIEmbnepFMc*)
(*Lpmppk/5bFnWDBkftizOJQ0U81/J5DrBPEHDdzegwdfg+2WLkplyLNLDbQ7F*)
(*w1/ZEG53MeSJY8gt/YhdZT9UqQ8PK6yAUABecN4QTIYbF22HFAQudycpkuWc*)
(*KcMFsbZLE1EHt36HRP3Df5PRjgtyuiY/1IlG+CbKwlpOAwyhzXF5Kzp/tKtR*)
(*xpOxPlQjxpzJd5Yt5p3uFi0k5FmaxsBUJ0yyjKS/lcr5IwzH1YwVGSSsrO7Q*)
(*5MKYhEqCVwre4vWxzbGvijsczS3yoh4lKiMEcmk0vMpaMpvmVODUYJeGLW4I*)
(*+3RT77/lqSKQCbaambALg+gf+grSKlMmH3FpULsg+WlKZFezuWAhBcPv9YVE*)
(*8AY0wtK2xEi8K4twodyV2ZcwaunSiIV2C6XUyXRE8P33/0g9oglRkrQUXoIG*)
(*ly6cc08TDW1TnCbWT5qujmAU0oPuRaF3L+vOVY5Ekqr/63/2e8eMTLmS2J2K*)
(*c09IxGK/1VMpa98WPcmlbsMKxkvn0JDsFpwJiJQeSUI9TPi1HJuECHY1Dv0w*)
(*9gk03owGnKt0Hu4L4mPSbOwkpe+8TdDEpJPQjHjsqtut7oblJil8pDYcWR5M*)
(*B3X5+pwYHPSxnz8qZ4t81SNRf23aeW5IFoyL5rUy5lCXxoHuyQOQEAt5yFI+*)
(*iMpRNFDIf2nhfUHUYvIraudeyBlNXkarHmB9hy5YvTTEYkgXecYqwuyh75bG*)
(*pLlCyASgwUqnOen0HMyg3KxVcwYoR7NYsHfQWSZ05T2JemH+lcnoaTP0uiX2*)
(*fYFg8jzSd/Kpg8Umd/HRwF0j58nBGsHEXWzIU9nm1l0VkxYF3WqyRTGVnD/G*)
(*cJJIcRp50U/OHb17neBtXof9IxZ3ITZZYmCXxiP+Wx2zRU3iTnOrNIo+5etd*)
(*U6UWbCkzhwgbU7Oi5Zuzrdvv0oylySoC4tFbywAGBcOlP6kF7wYuuG6TQwnH*)
(*EqGKNp5WQit8Syp1MlK/lTZBOqJJKm+JyjPRIn3NDO9ICLGRA9yjf3UMYnUt*)
(*v1WOL3znqkciRdWHzRovsUcURy4/SrFf6cvHgMgAZqflZVU70FAiasMn2iCT*)
(*mu5lXeHD4xr6R9qCE12Y1x/ijFez+L2gsWW6c2PAA7E+yTOZE+mcePdL8wUf*)
(*p0WMxeDV5fzH1YsCLKpuvJUDMJZE5A3p+htNZjrFbED3Yesh44N4j0HRQBH/*)
(*ZYX/iEg+R899G7iqmmiEwZZ56etywe6LNL3heURM55lGIHu2kggAUbpFQlh4*)
(*EjpFxZllXy9Gk3sSRV7PYP5AZLi/6psHliD2c+KMmFGEz3KeHKuxpyZ9OgCS*)
(*ukTF8kOitSHvRS3nDzG8pgZNOLLLaHqV4K1fh94pmJEXmSwxJpfmhR2xYcUW*)
(*3MaTtE8X9S6pUgu2QnqHukizW9vWMTuQddSlgcE9LpumrtsmF47OCobLfron*)
(*eK3PFi/jTUpKNUQuzd3GqqRORupPpE2QjmjiyldDw0jW8aijS+c7GqmE/qUZ*)
(*cfVj5fjCt1c5EqmqPmzW+qUTvl9xZEKiFvuVvnwUbtwyqW6HG5eSfC6INTCu*)
(*GRHraLOqBB61L2zMegAiXsoRl2b1rr58cq9LA0scC4bTmfJVHO2wLb+HHcSw*)
(*7AsJH/aUs2igiP+ywuF7e95oO+zSLEVux+tVQhY+9WsS44mFLnVpZAIANPMq*)
(*MNxIMAyZLO/v+l7l0qwlCkCWoFE91UuHdTmRLcYJOKNilIInR2rcqBjM683w*)
(*+0dES1CUUs4fYTgt0K6mOJTjLs1hwVO9LjRZYvAuDf4Y0N0+LwwMY46qlfWp*)
(*wqVRC7bSUvWpT7Yd7GsSOpfDLk3L4tVWWKycKBgu++muTRsKF2oKD8ZJPOLS*)
(*KKVObSFFTZCOaJL6Bwg68ehiMo5MvlhkwQo2DqxYQrBsfOEIuPOkvGqCQ2Zt*)
(*rUe7FUctJDKx/wwuzdg1TT8OzS2g8xPUybetAHQpXfSrY/LH4rBJEwbJvwpg*)
(*Ozqdvx5KzyU5QFcjzmo82rAdWLRYpXmdS8OPg+htTgbuzBa3Ls3EFhkf9qzS*)
(*8A0U8l9WOPiT3OVab+vSjLCmagaEYWQpUuXSiAXgT4irw38PzTdEqzTbrle4*)
(*NAqJoiBb3hfNdNBwpdq42XJGyqg7PDlQ45r50yT0kGgJilLK+SMMpxZYz0Qj*)
(*u5SmN3NpJCZLjJVLg/d9puAEjXacok8VLs1NKdhy6aUnlYKcbBvxm+z7XBpS*)
(*i5a2i6/AUfO4I10PuDT3BK+bQkLnkKR9eIVLI5Y6Gal/Km2CdESTEt2l0FTT*)
(*JnvCbA8RiQvZwzL57ZU2C+MfZsrxhSPg7kgkq5pWdsCs8Uw7pDgyIVGL/Wdw*)
(*afrcvZjU4axTj9G2PmEKq+J2VMHm+4WLUMJ7rFbCwk60kHJ/SBxNB9HitLvv*)
(*elBAXupgj28aqSEqmD6w2lMYFkEUbGNo1ypN330FnrA59yMIpyu71mG98TSW*)
(*ENPVsCCELR/E5cgbKOS/rPAmhVmSxWRmIPKlOjS3YhEsJ+4cWcAh9+gmPbnX*)
(*i0xqetH12jIBYG2Zd1jAHMFlGqqu73Kdo1y2SiOUKIYxYYG/svDaCSRUYHZu*)
(*4WOx2Xi6x5P9Na43nmD91k2aQ6K1Io/7KJbzhxhOt8unAof1hqyIplcI3vZ1*)
(*GBOTDh8m+uoPhSZLjBsOD179WtPzMAZdzFf0KV9vPyyoUgu2lJkwUrM9L9gL*)
(*w9u1Qz/ucmnGyMIBWCsNpKtPXMS1guGyn9SCV2Bb4zT04gh+UBvbukJjpYJo*)
(*6tIs76W511iV1MlIlTdBOqLJqq/xA0ZaNVVZVg2vy5QDyAem+299YeLNuG+U*)
(*48ti81o9EsmrBhwwa7zESsZ6Me4JiVjsV/ryIYAmUwGAQO5gWqVh0ZI9hEDD*)
(*wua87KmblkWXy4ZJAvGI68BFj+zKHVip00zfM5HSfVNFZInXn11Uuj+oB0ka*)
(*slNNmmF51+xbCOpjFy/QGD+2CteR8ODV1aDL5i2q/hqWyPCwS07ikFU4WN8T*)
(*vw07s4ZX4pN7HVmSvlzpkC3jgwjyBn4t5r+kcLrNites07LKQxrQbjpeWour*)
(*7ojNZNFcsAusJ1QV4fZRPZUwALbsL5oVJRE7MoAP5/CTQf5xiQDQoz0aXHje*)
(*kcNQU0i2nDM/XXYuGH/dzbbdKpAoBhYUejeaEc2d8YOsadRosAX2mW93ebK7*)
(*xs4nz3kxvu+tL8lbJiyDHxGtl+nE1tyPvULOH2J4xdpqX9OqymxGHHpLRtZr*)
(*BG/zOvU6TBdv2Pyf8W+JVEaMFAklPV63KJ0sd9KlGEWf8vUG5bCkSiXYnZSZ*)
(*MHhdLD+KfFqbpmsXfPyKsiWRR6q0eUCkdM24NqV94qb1PYYrfpIKHoyAdEMH*)
(*uIfdb3LEm85lpBPDF7ZXotncoe+N0G6hlDoZqbLvFSOaEKCeGr70wCFwXT9M*)
(*4V7cLqdBWfhOEVhIMcNBrXfLzlU+qaoasNvILPRIMtZLmi8VEpXYr/TlHnVv*)
(*grGOpnVY0jUBEdv5hCmLgLLziad9ya7kxPBT5uh2hTNv8hpRMQlry0oz/+k/*)
(*/c35TXJ0iGCAw6TkPT9LiPqbzvf+2e9w5flFHs4fdScKvbmkrdXaVJ0R+pss*)
(*4A/surFqpolvRXBM7nEjunEaKOODqCBhA6O8lvBfWvhYpzNB9DSiZnuh8IqF*)
(*Jp1ZpNnf+3Wu5c41tOePmvhag76YnvHiFIIDDTeRSqpMAMYmsLi6DY9bRxVz*)
(*5ru/w53fN5wwmE9hahbq67sSNaG1L+zknRRj6s50e0kRcc1wrpFnzsRf8+we*)
(*T/bUiFFnV5Pnihtx69B7RQv5WHxghWFTRZDL+WMMHzJ//gbe11BlmZiwVwre*)
(*8nW8ed0V9Piq6edSlVlzJuXYa6ZLP4GYdxYeLJdzvt4tVTLBpnEaEmb+qyme*)
(*wfDTBJ40kuon3HFdMVvgAgcAfxkyDbeYf/ttT8rw//Rv/ifKvhAJ3rT0AasK*)
(*bebzZNBQColLg2hbBv7ocTXIhHb7tkrqZDoi/l45oolw47bZZrCNnjJ2uS/9*)
(*6V4aid51285VjETqqgl2GZmVxH67T3EQr3y1wsrtOa8vatreFuM49F2zSIdK*)
(*V8Xztm/JD9umdy1Cs7mZYMTP181WRPteuTSJCmwaWtHYPTeb8LrqAVWFqb9D*)
(*EMOInxcz4UXKB9GTsgYK+K8ufJg6Zezb3ZdDPIaxa1kanLG/mxBHIQCU6aKe*)
(*fazr70oUBj5a/vQLupU8OVYjKgrzSyiL+0VLDLmcP8bwoWsZqWPbvvuFtQPX*)
(*4XKVkWAUBIx2/LvyPh3uCJpCsKXU9F3Hah+67rPlST4qeKgn9hrT41BLnYzU*)
(*zff3R7RlrXg93IlKJGioq3BZTZ1H9kXjLmpG+oW/3yjC/vFF+OSeqh82a4cV*)
(*Rwqp2N/Tlw/CE29rP3HivTF0VZbldVvjrTkrfgcFe/8aT5w4sRvHRjSyTqJF*)
(*y7WyMjQvuvxi0idBUfU3p5F5GCNE0OmxJELjxInPjGJeedcUkQlfdI0nTpzY*)
(*i4MjWsXCFDXDcj3f9+glueq9qqdAUfVpZB5El+ONMg3fUXR6NSe+RDQp3g3W*)
(*dCsu32l/5P1rPHHixC48MqKNZRY65pyJyr2mb+/O3Kn6NDInTpw4ceLEiRMn*)
(*Tpw4ceLEiRMnTpw4ceLEiRMnTpx4HYZ6SpopfaSrn3GWjStw97HwnyeMyuRo*)
(*O8to6uaM6HoAQ4uPvx596b7urPFgBw1dU9VPjAoYmqpqX3ciGl8a3365sjZ2*)
(*cIXCaYdkeLrZP3HibdGlAYSIa/I8v2NxXWTver1VbcitnsHtDTWlKWLb1HHS*)
(*V90IkvKO0Rq7Ig50SAcve6S9BbapkRJtLxJE0PdVYGkmf8Pkutg+NHUnKuTE*)
(*jAm+E2q+iuog+iz0SJycojdPCNCViWOSK1u9/Xde7dGdFV7TQX1AKgsfFY51*)
(*cTd8BZz+6B1ffZV5tnGQY58Jbc5diabDtbQnODzf7H846iTAlws77JZhjOmD*)
(*4/rya1Gfjb4ufEs3FcmJTgDGtqyOiN5QRz7c8y7NHgKXk0fIkLZws/drr2Jr*)
(*SIHiC3ifhCqelZFe6piKLyAf+ya5TqkJ5ClU2K3m3CWQAc+GsSY3fOoeDDiy*)
(*YtsCEsUq7MNAaLcO5TLrqpLcJFjHAdzd+/EJ678sNHkESSnUySUX2KE7a7yq*)
(*g3qSK0d/1kkSuETXOOrSMAvT5LHnbLMrfilo8QFfnClmzODyXHfJh6OG9Dio*)
(*zn5WPN3sP4CnswjuGTZt1w8CcMgvho3+9j3i3vK3870dxtpnY8mXqTvvigZN*)
(*8p3s4EujMiEaGFJ65xKamoXRq0Qb0vjayd1sG69AixOz2kGSp+F8x7stumpp*)
(*rJAo68Z03bh0oMmwe6LZjsM7NvMqU5eT68Ntmm9XWWxL04jIM22BvdWD3Xxu*)
(*bM7g4DQ9p0tzHJDl+aCRUeuOGK/ooPG5F+c+sMu5sDCQ+OYLNMuQs4Cl7Omz*)
(*KMqWKVIeMqSHsNDZz4cnm/2H8HwWFZ5uRXToGRcygIQ50Vl21DdGX9dtlbin*)
(*S3MfbarfS/grwkClV2xjqdFWZK8+go64yffTh70GfRn5CctgQhOWzRn9hG+w*)
(*JCESJuCE5uyypqGacv6wvK6g/hcrXGXwkRVLE1YqEoB2JAGobGVphYzkQp46*)
(*iGR3PV2aw2CrFoeMjFp3xPiCO2hlYbBe0AzvXxbGKrwoTOWDhvQAVjr7+fBc*)
(*s/8I3oJFZRxO09A52zv7Iovzd9t4Gta1fyS6MnXYvT666WZcoF+ZsLymmuHH*)
(*c29Ivh/LZEq4pdlBCsyuEw8nFbUsL67wNoRj4k+mHeMEWH2ZRbaORs9bU4Tw*)
(*ruklPd7RuLKSDNMwnAhSdI1F6E53EF2z2ZWosyvLKwz/E4SR9GVszTcY4VJJ*)
(*lkMx2ZQ242IGWUY2YfVNxsaBWBLd46Y/Qx3SlQ/NMDRz7mIZ5dIWCcFy9mlX*)
(*VVr5/qp2aZY5b1KWGg6SjIN5RO9uoiOkxZZw46UuX+ccbuSJu75fe7UmUUQd*)
(*5JYDLK6aRVuHsLKqmckcfbGDe5J+HNvCZcJgONe5yK70LSrdhu3fppXirgzs*)
(*KXW1k7JZcN+WceDgjJl9l3jASj1A3t1YB1COZoSks/Y/KW2aXF8Yn+urvdhR*)
(*nIyMtL37dAcgVHxlB0n51tW3EDOBq0vG+V293N3SEL09tbfJKX/w8qJmbkN9*)
(*BBZmKAySnBHxVme8nUVNzkDKRoWhU5G02wIIOTmULqJe4xrCZbTcNvPv/Nqv*)
(*YrJsRJgV5ZkHH9BHwyR552vfRl+YpgNZsyW2ccnIhc7+jV/51V+iZZqmC2lk*)
(*b5FrWaSKf/cVUUbNuuZFBK3WLD+9w2SpUV1BTK3E7C8g6BpqNw6S+iIU47VZ*)
(*+8GP0TQV2SIru6U2u9ZYNhBD9sm7YSoblwajTn3aw5ZJx9CuwJ2BOud//u4P*)
(*lA08NDYJa/8YDDc8LdPcsh+qlKRYNa4gCTnZIfOR5rQFRHLALF72/e2KrbQb*)
(*F22HJBBucYYUq0NOfoLpzzi0kAsYvVWGixAR27VBFIIbMv9Fmlx1IppZllcd*)
(*tm8kSb2ZlE1dRAZXNeSoRWNWN6DBAn4RjOZtmaVpDKQ5YZJleAiXkV2G1mWN*)
(*9ToebFv7nHdxwyGPTtkNfZ1Z3IxPRrnsexHGrprSQJuVytu/79LwxSY08bQF*)
(*MccZXbU54NKwbLyKUE/6bqjOOD+2OfY7cLcHSZoXOFUsWQQgWmU6Dmy8GSGU*)
(*sod74n6kWwxJ09URxI/Avhjssxt+1fUFCCd8Dy6Z5hZNW7Px7nrr0IDi8Pl0*)
(*TcflPYr5o119u/vJUdo0hb4Q7lXEAFlZ3XVVQtUAJFDW3t2686JQfHkHyfl2*)
(*Y73C6pJxfmcvX2l5tL1DgfUwLsexz3AibKE12FiYoWDpmjXEW+iuK0isnIEc*)
(*pIZOQdJeCyDjJFIZZNQCzDHNCtI0vS1zxq6a+ec/+UvoLo049n2TA+OQI0cd*)
(*VKwvRkoOvclNOoe1zlZ/mdF0zEFOV2WHOtGIjP3wulBGbQrOC1RSKjOqK8io*)
(*FZr9JW8FXVM+RKpYjFcs+v7v/fJlDe8P/0g2EBcwjdADtS0XOhVjX1PtNAI2*)
(*RRjITrH53d/426oGHhubPpFLM1YRbg6lpDSmrsG5PufWFR4JNbyW8u+x0HK7*)
(*IXQzwiWbEcNyWx8+An9gweqiOyBnDdmSo6dsRrwOPK2Xjk1ywSEk1Tj0w9gn*)
(*YFXNaOgLgxMAZKQdVbziAClZqQIryUaNJZ/QtBq5E7fb+sBpB0c2uI4mhzg0*)
(*B6xglzoaCdKTUf6trEUiuiFkhRNBV76Lc8ilAXZdXLorRBslstjSYkGeL8q9*)
(*pyIA9+8+QSWuZk4wByOmTZfpoIMsNM+SysO2xHU/tmQYt5H16NE/Eg11wYPX*)
(*t6QQtm7Q52AWb8OYYh5pCeM4SOlF86C1BRnrkUkEBoIFchcfqX+480lF0xT6*)
(*ArGCU0BUQxpJlG6UtHd42a87MsWXdxCqV8k32MeEukYJ5w/0Mr/03RcBR1Ln*)
(*XHTxgaylhaEujcZ4mxLe4jbKGbiiQW7ohCTtbt0dCVzHUaibCerA1lTrGHxa*)
(*oHlAo5cJO85q27jESmfB+50WFtoMUWvBNjbwAcs5OQCQ+TDiIoGRMflroVFd*)
(*4w61S7O/hExajpMqMyACFiXEZbauN7zcU9zaP5cMxNgtqeIwLO5dkyB1Kvqc*)
(*mO1pObT1cCB5rWzgEeuqrv0D0BfYsUeef0ynfAb2BqvI5s0jXiEgt1XIvidC*)
(*O1u8F/YkeNSr9sJH6gl0Oa9uiy05sg48+eQQj0HcSQ1cSpy0w7z+CAKTZnXu*)
(*1eHB/K9qsmEJS763DkVpcT2vkCd0Kq57YdYicR9VlP9E8r1s1B/amzfP7Pl6*)
(*hYQpmDDjdgUrnrKy2LvGdlJw36VRxCHAwEcGiHskBQZfBXxka8W0+5DNkXFV*)
(*0OJ1P1JfQiOv0r80I/7zH9rLhuN7U/AVFo23GujH0r5cJkdlSSHY8zXBxZEn*)
(*VU2T6gsk5jMnm8n9JGlvNTS7dUem+IoOusc3ri74XsD5A728MDLEIOOHLS+r*)
(*2kEWNry0MPBRxFspA1U0rAydiKTdrbsjgXcGlFUzpyVTQj9YALo82KXTefw7*)
(*tnGJlc6+dBmM5kQa+6s+v8VIZSI3lrBpnXUyJn8rNKor3KNWOShIpOUwqVID*)
(*ImARYTtPj3gg3g+FDORk2ADBJlKtFwux2TbwiHW9V/v7o68SstGnX5PY0egC*)
(*100yp5Z9D9NPXqLoZgRZ+lNp+lLderlLA1VEm3EcvrejKZb1gEujJpuauDsu*)
(*zWKDBnnci9shSBvVlG+/V6Kbdou9XLYMuNelGcgaHWIxt+DD3hWsc0qLbVO6*)
(*IaIQaXBp9si80KWZbsKZuu8A91b9CNMWK960D5YsNg2H75f2B1hxJWESOwl+*)
(*TtNk+kKJtKcdSe4nSXuP6I5M8VXtvcO3zZMiG76/l1dG5sZt0ul2KF49FLk0*)
(*It5KGaimYWHoRCTtbd09CTzo0tAVPN1D35Rsr+3iFV0dmReTHqW8YxuXWLs0*)
(*bP8aL/h02GFIWAdso1ihIUGeypgsNKor3KNWPSiIpeUwqXIx3rJoyzHhQLwf*)
(*KhnoUvAw0XwSm2q2liVt4K0/OjZ9HpcGziBfzIB0Ilmdoy4N7Oxxx2qG0nPj*)
(*P5F+b6y+B4kyRKs08NNOl2Z6CxZIl4urTRgkGWG+Pl+QdcCluSnJ3pqCVVHg*)
(*XfA7jGPfj6iMJGCniPCqo4zyP5V8r5Zk2Csk8kaD55qqrBdXnop9j7FrypK7*)
(*GHasyAa8SwfBLjfxWvRjqzQ0luauS2OFD67SbEdMGVdFqzTLfhxrh3RNwfGs*)
(*zcL4h3BhhZ5w418ZeZHg+4U3+3SXRtW0Oy6NnrHC559k7S2p4dqjOzKDMCja*)
(*OxRKvqmfJJwv+/29zJsOfAlwPw7NLbBZoOZVtCmz8nVlvJUzUEHDy9LQCUna*)
(*27o7nNzl0ix+pSGUToi61YxacjhOMyyT81rv2MYltgM0RJvg+Co0TnMbFpJh*)
(*1ED+lIzJQqMqIkBBrWpQkEnLYVJlBuT+xEc6EO+HWgZS8DAd7CtNEY/SBh6y*)
(*rjtqf0+ATfPoafmWnDPDi0tf/ck/In2rsUNiQ+JoOvLe6BbD+nvYNeaFDXji*)
(*kN1f2LObLGcVcezqcp3zrmWrNH3XsyrmqDO8dmclsOXNXeY2wB695LjcQrbV*)
(*ZIPiyw8/DjGZPHCXBve+domAuqHymc2RUS77flVNmQS242WTM0L3RiGWZkxZ*)
(*TDoXeTv5HrPSjWSvmXwHoZuUeBxcbxi6PkXTsZPamreJ1REUS3+YYmmkC0dT*)
(*KDVpxdiT0CRxD8HomXTEQRyY7m92Z3Zyj7R11Y9wVBkbEHpnco+DKOLmG2i7*)
(*ZtF56IjDGlHVtOHmPCyCTaPhTLCGPC3W0SVl4cbTvidVTZPqCw0emIik+ya4*)
(*1bL2jvt1R6b4Ly/SDpoERsK3xZMSzh/oZcoKwpk+dy8mnUTX5MCI2NguLcxq*)
(*44njrZSBaxrkhk5I0u7W3ZFAhbMhaCZBSg8FIPM1TMKDLN+k9Xds4xIrnSWY*)
(*duEXk75+FksAVG1Xo1QrhUZ13cQ71KpcGpm0PECqTIy3LFrqvnQgJttsOEeJ*)
(*xFhyrSBbRVIZmOw/FyQpb+AR67oo6uNdGliBRH0QJRGL8MbDm5f/2XRXrOXA*)
(*RaRwTVAj+b6HLVkNLpruyJkIFr3Gtlb1IElDl46LaFLgXbOf5rgjpovaIAhW*)
(*d8mxaBi7NdP3TNS/w0vLTpCiYdiy6LrrwLaVcd1pWeXshIvpeGm98ebpERU9*)
(*pZSpyB6qCOLoZDGv5RVWHuZ1ezyRYHJOLyLAJEgol37Po/MZw7341uNjKfid*)
(*K73wvJtKmMNUxmo6XBMwY9LTvdELRH8VNJ6fP4RDBbKiDNyov6hYWjgb7xJB*)
(*WgXaCjLF0kFlb9RtElsY0G7T9REdQflTmH5FdGZBlJ2Ws4d7GNt+7PIp1lq3*)
(*bNJe4um1dIjHX7sOOWJCTuizZSgN7pmHZWoWCz2Cc8jcOWrJmYcJHaQTzux/*)
(*Utq0Tq4vFdNg+5pWVWaz94mWidt7RHdkit/JO0jNN/okyIyM8/t7uaNXPqYv*)
(*TCCpNYbDKcKJydLCfE0cEs2OB563hAyZwGyJkBm6r8Uk7W2dkpPUd6Jm814z*)
(*6doujFksSBgO+JiLtSylSV9iqbPMp6GXaC2ubqC2goX7liTixY5rOZNlRnXd*)
(*SBW1a7O/4q1YWo6TqhDjFYu+oaaA9aB8IO5osJMluluVA+GMYrSi1ob3SBUN*)
(*3C+ZAGaIFLelvRf6eZvSi1O42diAC1i6gjny+LuoYKySfT82gcUNkYbHHZYb*)
(*kulCN8PPEtJ80/nu7zjc804YzOfmiKPb0si1i5nBCbS+5OJj8XlSWnOdmvOb*)
(*9I4G2wuXN2jilYqZcFShTXxpCdlt5nPPWiIlYhZsFrZ+WhuFEoOMyY+Ecun3*)
(*HPJgcZzwotvp3DB2/zkaU/AY1EfLa0nw4w7pzZZlQLDjEdaEN6CTKRqoT6+p*)
(*ASqlxQKFQIM8Hp5FI9AHbuwGbV+0qtPROPyL6f8BfwLb8f25ly9GimzcDu7J*)
(*+rGM3flrc85CdQtnmTScaLIPTRbwTHNjMP5j6s4y5SVFxOmGc428+brny//0*)
(*3/0XO5/EnBc1rS+4U28CfRkyf/4GSteQlGeVor07dQc6ZqP4/Z0OkvINqfb0*)
(*NXWHZJzf08twdwctzo6/pdc3XagimoEkKGC2ML//x9/leRu4c5WGlyoYuITY*)
(*0EV5PcpI2tE6tQQmnATiq40EmeY2hpSU5+Coismq4yvKk9VwqDLpC3A6yx9H*)
(*anGGt+WJgGlFlzECeeBzkjgRk+VGdQUJtWKzz78n6ZrjpGLIxJhj0b8MOTqt*)
(*kPSjfCCGibP4ungActj4Fl70SJSdh0Q8mrxXom7gbsnsI5uXQEd9Uce7YOza*)
(*jq4Wjj37i/7UQmrXzSuS719wJlsMAUvRT3VDNGrs9udC7ft1XtkOl990mwOU*)
(*mCRS/ti3m1/vQEG2Gjn2ZfXpmuthGMZx6Agp26VCCeXS7yegbqkJhHzDxO9J*)
(*vjvgB/fEexUBPQa141m8egPDWiTPPwhzkHlrbByGHkfyBLLEWMO226W4yz0p*)
(*EEPQm83arULyg1m9LXGgYvJumY4faBoSvhrn38Z60Lbd6jdhe4/ojlTx1TTt*)
(*5JuU8w+wAulh3zU70i4fEDUpAxeQGjo5SXtb9woJ3DYTiQpfIRoFhKXutY1b*)
(*ncUH/9cpAGAYNYO87ydBXZO1YrLaqD5I7QqirnmAVFqY1ICoZU02EA/NE7Kr*)
(*k3sSlut49xv4Gut64gvFWOHR2pIvUHyR6GBmoPBSJoD/48TS2SULZeG3WQcS*)
(*1P22iSROnDjx/hi6Ksvyuq3xCt5mu2T4NEEXd/EFkSrHUBVZfqtrcon06gTT*)
(*z0QDT7wBusIig/rhJZ5PjRbCba6FLJIIYYQ7tdhlcSL0N7xBy+1SvcBSqhFs*)
(*A51OnDjxpaPw5i3FbXBdTa5C0pYG4XPiCyJVij6ft7g2mYV/Fhp44q3QhrZ1*)
(*57b/Lw9jmYaxyqUZ8ijMa4Ur118NzYlkR8ZOnDjxs4YmxQcaNN2Ky/WOTEGi*)
(*vzRdx9euOPFnNpdfEKkqjLWPg9Y0y4tXnfEz0sATJ06cOHHixIkTJ06cOHHi*)
(*xIkTJ06cOHHixIkTJz418PWGP1vBsfcwdLIj1Svg27bbT7dR+Y5UjU39PrKB*)
(*KrqXrfazY2iqqp3T8vU/d2r1ary/ug04N+GdY92HylvKwF58DjtzYCAY2rre*)
(*f9R6trcP8kdR9C6adxv8Q3i7XnuyWL5N8z8lujSAa3607SXVL0MVOI7rug6B*)
(*S+CwD+i/ZMcZ4dejr1LH1HGuVE13rumeXhmq2DYtSrHrWJZbzBcijMV1keNM*)
(*mjyyyjxyQ53m5ZJHPgDvSFWfh56hSWTjqRVl71TR26K/4VsBdT9Hvkzsy9Xq*)
(*hAgfpG70IrjwSaZsloH9r3wKO6McCFaPlgkyyLsJXtjb/9L8m0f582qa9xr8*)
(*Q3jjXnuiWL5J8z8vhjry4Z5N0eX2kEpPM13fDwJ6E6Ht+YHvO+TuUF+UU/XJ*)
(*BFbhZQVLkEl2DXxZ0o3dy+vkVTPdewQ3P+MLW+h9vOu7pLqqhPvsmjz2nL3p*)
(*p98cY1tWJKHFu1E1NvGVhNvfSwj+aPm0Rfji9cB7rKKps94H6uoGkj3Q8POx*)
(*u119uBP2IdZNnPk8uEfS4x3x/oK9QE/S/ejpk8RokoH9r3wKO6MeCJZo8ggy*)
(*auwheGNv/6Oj/HklzXcN/jG8k7huxPJRm/Dk5n8ZGKUZwfDV+na9fGzKiJc6*)
(*uvv23EkdnLmkxvciDgXLIB/I7vVeAm6iXmaHAVGh6caQpx1GqzY0Nt/pkDHk*)
(*E7g0TWJfHHZ15DtSVW5T9D4JixbhVLPa8YqWnfXmuF/dOEyzKrla3a1myZnP*)
(*gHskPd4RHyXYHMZnboMsZGA3PoWdOSCxY6nMszlDYG/bB/gjJ+QezXcN/jG8*)
(*o7guxPJRm/Dk5n8hGGirBS7NLZwvYVvnQh2qLHvz29Y637C4tMJDZB1YHYLc*)
(*qUuRWztmK9CsatOvw23KgfuRaFOd983ekarbG7k0qxbRzjpW0bqz3hgHq2P6*)
(*clRFNpz5eNwj6fGO+DjB/lz4FA2XDwTbR+li1F2C79jbV+MuzU8l4KPE9XGb*)
(*8Nb8fxN0ZeoYLPG46WYkxLJvysi3Lxf71tahAwtOZsKlsquzK0s0C/8z70my*)
(*KL37WPuWadkYpulCSsFb5FqWbRnmb//hDxANmmZnZe5CqMQyY2MRsuTAmnHN*)
(*dl2uDwsvO1dpVi5NX8aWMVVoGoazzGXZXq2JjehXF1+8N+CtN/N6a4oQMnuZ*)
(*3nxV49gWLivQcK7ybU9xS4Ud9zL2ZYaTTJpBlpE90P/8v/2VC090VKqpQmTF*)
(*Hk1GqFuObWh2VNWJZ6COsiwPJz4YYsfEn0w7ZkmaxMQsXJoh8WzU15ZlGiZh*)
(*jqRdTR5S0dINXTO329xtcV23iFZkFkhc7UlcBzltos7aoit9i2ZkM2z/Nq3i*)
(*dmXA8nhqhjPJpFxr1tX94MfwpJXdUpKuTo+rn97SENXG5A30xUryxNY1qAi4*)
(*qugLIWf2iFnflnHg4LSefZfQ3teDrEUaGgAHNCOcJwJjmQQso51mB1x82sAa*)
(*jl4wNNMvhCTxnSnqCHn5ajFQC/ZOi7FpAn1ZxMauvoWYXcz6id49wNuxW8oA*)
(*RpmwlMia4ceSsUXVcBwxwq6Q1Z1rTjNxk3BBy6SwLGaEe/WIwEksmZAeGAiG*)
(*+rrMfss1U9A1Anv77YI/9wYpaXfvpFli8MXCKePPhKPiunN0EFpLXiwftwlP*)
(*bf77geTfuWhu2Q9VSnIWG9d+uM3xQPgbG6K5psT0NclCiAbNbkBKCu2765yL*)
(*XBqk1RlNBkpzu2PBTxBLzN/6zi/xNGjTvc60hAzHGphJ2dRFBBTsWHsBn9yq*)
(*9vmcK5emLbM0jSGezAmTLFs6RmObYycC/awFSZoXJJ3GULDcxJrt0lSrNEU7*)
(*XXVMmq6OYEdXD4QNELdU2HHIAIbLtN0Y//3/k1x1In9ZllfdqKJqrIj5w9W1*)
(*VQa/EQ4MOUmQAHOKcWgh/y/luYSYF+bSgKJB0mo3ylsSmSRpV6Hj5BLlOPYZ*)
(*vt9SIFdtWaSrFrHOwlSYDkRqXYxwkNEm7Kx1NWTv2PCrrqdbltBBw41cu+kW*)
(*TVszW3S94R6Ras2quu//3i9vOunv/r2/Rd+bXJqpk/Qp0S3YXmlfCDizR8yG*)
(*chrzSCWOyw8980cbFOdGanfjou3QUEJoM0PW3bj3ym7o68wiFAo7S601ivLv*)
(*iIFCsHdbjG0TSGUiNoIkkE4DKRW8e4S35dVaysALJBzxkdPcFracZkXDYRKH*)
(*FGroK0iUDhO6vkC6oF/jFLEuz1jAoRX2khFha1a8vDswEIwVcS+srO66KjGW*)
(*zRR2zdbe/oDnz71BStbd+2kWGnyxcEr487i47hwdhNZyKZYP2oRnN//dMFYR*)
(*ZigVrdKYWzeAI8tmVQ0RSGJRIeiXjVlIRpxdkZlClwYD1NZkybPazMVeB/kT*)
(*0rRDfPvYZCAA5rUcm+SC061X49APY5+AcJt3ckdCY51kb7JE0cYTsMWULcSV*)
(*V2OxWQBCqzng/TSpC/TjvKi4bTayGz36V8cXXp55miUt/VbacTgBLtEONCsc*)
(*u+p2q7uXEa9wcgueMqpoX8RshKd5zUgtw3L7Gz6ClZBLEV08QSoHJU9Z72Xt*)
(*+rrANdpU6jrnoosPI6xaxDrLXoirhaYVCtrWnbWsgJDEpm84Koz0+zCmWNy1*)
(*hDrgLw3Jk3LRPJI3Qq41m+oSYsOs6w1PmYobtnAct5m+XGwQ1za3mPCr+2LJ*)
(*mb1ihlCQDnLoTnEHSwPu4iNxTRs84+CytEMbL27W0nMWmgPFd4hTbi7srBUW*)
(*nFGVv+2lvYK922IIm6BgYx/MZk3S/P28XWocyWQ9ZxUsPPLcVZRPTdrwIcI/*)
(*mBXlsznJSZ97uktLLmmQoV2OKn1ZS+w3BwYCYgfm5fGGMBSaqeyatb1d6ohU*)
(*3aRlHh68lgQohXOr0WvsFde9attLrSUvlo/bhCc3/53QF2l6w/PN2Ia5oBEA*)
(*G8gYZLC9FeqQII6BDecMlNRXWVUkfazLYLwgNq1HDiXbXqTKPo0CFVmC0L2s*)
(*K8j0Aa/daLB+o+maZl6VJDQ4nZpouieDyKW509h16AhZWpx4xekjNWsaaQH9*)
(*SzPizQqgvKXSjoN1icUWLSFj/kZKVe1cFh57zxmQfmFM6Ec2Z5QSAzw0yQSK*)
(*zwMrbRexRReSlSSr2kEWCrhqEeP8VlyVtMnjfMbS5lmKCG4qco0GkSL+LXiS*)
(*DUkyrdlWd7uug396gUtjTpubLbF4OjnyqeqLBWf2itmGgeKG4Elf5vLjLEIV*)
(*YQaQGpG1hLmm7oVZiyzmKO4sYdXACmX5G+wVbIUerSBsgoKNvEGQNH83b1+W*)
(*PQsNn3fJ0QRFdoOKvOFDXaTZrW3rOKCrGkxnx5GQB8MialJEpUKuL0uJPTIQ*)
(*1NTZYBzY3TXrMleSL1M3WZk/Ojx4LR5QC+dWo4XdtENcd6ut1Fou2/WoTXhy*)
(*898LfZWQ3Wz9msRYI3WhwZ+bBjMOO6qmAl7r0tBFQuRuVC8d7qOkFb/SFx5R*)
(*sWsGU37RdoEEY0wSQh86pv8sl0ZfDj24wD4ngRLxXRoKeUtlHUc15Z5LI6IK*)
(*pjDzOL7bpVFIEVtbxbPUSWZU7bqFi2sQxFkzJS7NVlyVtMldmg0rFt8v3qLL*)
(*KVeyAKUgY+3SbGoXuTRrY46UZNjv0uwWs3vkrdWfN2vD7QqE9WSP3p73WfRQ*)
(*4GXdqVpd/ho7BVspbysImqBi46KbxM3fzdsVzbCy4e8Kt5U2HH1KfbJTal+T*)
(*0Lmstq56uvfB2fO9+nJgIKBaY087/ru75o5Lo5bSbZnHB6/FA2rhvH8UYq8d*)
(*PqK2Ymspd2mOFP7k5r8LRlh3MoN52XyfS6PPFwQ9waWB3T0cBoF0aV4NXr/S*)
(*pXS5so7JH4ul7CYMEhkJxJm/G8C8xhu6NCNZD+GmLS/YBw6naNsJspZ28o4T*)
(*jCArJ0ft0mhuM713mzc4VsYEfqIbT3ekyIwTGjEVsgZK29U1TT8OzS2wWVzu*)
(*VbRhsXHbZOK6W8IF5aNHE86jKiMv+mG2+V6xFPNMl2aQu5d8Xyw4s1vM7pE3*)
(*EwPjrOZOi88LIRn7Hm+gJQGL/iGrTFsfW161uvw1dgq2XN62jBA04VsFG5cu*)
(*jbD5j7s05ooVL0PpuaKkydKGw1TuEuRYXkd+gxKjg0BPzY7ni0R368uBgYC6*)
(*NHom8kyUXfOgSyMrMzs8eG1VWCqcO12a++K6W21HqbUUuDQP2IQnN/9dAGLp*)
(*0bPmLTlMiVf8+gGCHwTSAlt+yM9jPw2wbXfvnFcXqIRnWrPlNW59jhXW3pGP*)
(*DcEDFy6oGK96WYmw6BverjLmYKW+dE16WGkc2qpqZIRTl2Z5L809lwa/knTE*)
(*uk3GnJXA6SMEKmPTQasn06V4Q4uspYqOg42nBdmc7vRdL6cKpH3anEWWwZ6H*)
(*UbJAPVmDKpqNhoIYWI0sX6bQR+pYytrV5y7ygGjtqacey+YWTQq1WcxX0bbq*)
(*rAV6au3ZxYwjjlpH5dM1GXN2tIBp1A+Uac1WNug6LVcv7YhAvPEEa7wuCeJR*)
(*9MWSM+1OMXth68ZT5NKSvLkhrONmwmD4cDBhva9dImDEUPmTp7fprHXVHGfa*)
(*HyrK32CvYEvlbVOisAkKbeW7WNL83bx9WcoAXZe7aCHdexqQkdSFIUmyhtNJ*)
(*ikeln1ybhneyBnxRV0FXUB0WXNgFdvD793R5ktgjAwENupi0hvrnhGBl10hc*)
(*GrZQIFM3WZnHB68FAUrhF2i0sJt2iOve0UFuLaWrNIdswpOb/y6AMC1kuKMk*)
(*YkHL+HyFl/+Y7LjpCW0pkW18G+EUPICd+7SscnbExnS8VHFuiwbMIGUR7ySg*)
(*2YG20K+XaUmfhtX1EOIOD7TsZONFNy2LPCYKcBqLKUjeMHQMOAvDb9RKrCXb*)
(*DtPsaLbC9PwC4YMIMICaLl7qDcoBhh40CQLKwKToHr7yqMu9C2uBZRMiyZ7C*)
(*BuKWyjuuG6qI0OhzCwlksVEzfc9Ebf9aTtW0T2Q4nu8uz1/QHtSDJA0hTh4f*)
(*7rO8a/ZjKTE/AfUhi+dDBIvyGhzUFbcL9JoaIojMF9rwZYsG6jBP8QBUXJFh*)
(*VjBq1VlrvlPrh/vHdcjSPWFRD2uteKDBZh8WfplUd1KtWcvGNzHhBq8OHekI*)
(*Fn3X+YRbXlzigbMk2mGy2A95XwxLzvx0r5iNlB7q+tMpRkjZwreLHsXS4Gr0*)
(*jpzEodHRJD6WmUp628yw7aw1lpz5Wl7+HTFQCPZuiyFuglxbaRcDZ8TNP8Db*)
(*lQw07BDyxXLgwl3xhYRyO0MnKZYfRT4Vfw3ZQM3/ccGOmhbtOPQIVeaj7/9M*)
(*qi9frSX2yEBQscLsa1pVmc16Akusoms29natI1J1k5R5dPBaE6AQ/mGr0Zt+*)
(*2iuuO0cHubXkxXJd726b8Ozmvw/6efPXi1NiWi6G+7u/zh08dK4ht0GshWU/*)
(*1ukcIUGPV2u2F1aCGRhGGTkXDjrvJMxo7csqnn8+x8oCmex8uhukL+kJPAI/*)
(*rbYlsmnOGm7a0PLBpUnXLs1QhvriDT2uhrFJ+C8NW7C53zFDYfo5XCfFnnYC*)
(*dybX8LBKlrE7P2D60jgfYUvFHZf8JPM5Gi3mTreMk+bv//F3lVR1kTO10g5D*)
(*Eg/GzhfAYWHyqJ8lRAFNJ8prMTH/4Hf+d45f6LnYnT/7WSNs11hHrCSY1wWS*)
(*8Ie5RVn7DX9y3fH9WTgvRvoX/1rIqGHZWcI6buEst4YTTbraZAF/MNeN6WKv*)
(*r9Qarrp/GVrzb1aIX29Sb36aWLk6u5pcgYYbccZC3hcLzoz7xGxMua7xkoKT*)
(*AdSQyOPouN7weZLA4inzWARrP+24wM9B1mw6S9Cd646Qlq8Sg3uCvctiyJsg*)
(*ZGPL9RByp78WvXuAt7/5f81V0JGuK7jHjagQjBdqOzPHWhh+moCMGUnFpuor*)
(*GEEvNizRdzYSizvqwEAwZP6spdAmDdnQrJJ1zdbe/mihI99TD1Ky7t5Ps9jg*)
(*i4Wz22r0K8V1z+ggsZYrsRwesglv0fx3w9i1HV14H/tuswQvwdA2ODfnSFaL*)
(*u9cvN+ETi6s5CF17z9t+qmuFrkVoHq8dJxh9dpIfPOXZXeTQNagBzf0j/KKW*)
(*Huu4/WRhdpMEsdt7y7umoR0xdsvErI9JkahdI5o1ds2OxK+7WySn7V5n4WRf*)
(*iJKthA04hy7C/q7eU922/g6Lfi2sRt4XG87sFrP9oO1f1jsMA+o9QnOzOsV5*)
(*p+UbzgjLF+IQT+9aDEUT7rJR9e7jGIkINA8HKSCR79h+39B1O9I3HNLlAwMB*)
(*Yg0T5rFt12x8rTEXQVLmawev/cK5xQFx3aO2D1vLV9iE1zT/Zx5DV2VZXrc1*)
(*nmhb8coKPngn/IknYVjuXJ84ceLEiRMnZCi8eYksWUUojXCbwcddrfxzj5pc*)
(*46A5yReV4uPEiRMnTpz4ADQpDkDQdCsulytgXY535zR8Q9Lp1XwIqD+j4x6Y*)
(*Dv6cOHHixIkTJ06cOHHixIkTJ06cOHHixIkTJ06cOHHixIkTJ078nGFs6uaM*)
(*XLkPfAD8/tG516GvZYnqFO+0dS2hasDJF/mYpaHhzrBvft2Doamqdse50A0+*)
(*hZgNcl6dkOBTdNx7YezgAPUZH/+WeMjyiMo51fnEAn0WegZJtpSfcqHCWFwX*)
(*ycKeed8HoK9jHy7ZOtAXdR47JOe15gnvjqPXiIX4ZqUuvbrkKmUuH/38624y*)
(*b/hmP11yVZ3spc8gZl2ZKHl1YotP0XHvhzZf5KC8PV/LTxA8YnlWeIo6D1Vs*)
(*W7aL4DhBWkueSdCv+BHL8iXPnPhwdFVJbh2q4wAus/z45FOfGXBzNb6VsYUk*)
(*huJbyl+Dsbtdfbh19EBf3JIQrk2XpAjsyZWheoo6e6gj3zUWfc39qgSVFgK4*)
(*udQ45NJ8DjFr8kjJq58bjG1Z7RPfz9Fx74UWXy9hRcPLmMEttO7p+r4RNpZn*)
(*v0wyPEedx76+xewa3zlvOP9EzOayfvoKD+wwYYcZ8lzwNv9LQGNzg3KK74L5*)
(*eTBZDwMUkF4A2FdZGD3dowGM+1KcL9/Z3Pe7+p3bI9qWP+7YQVpIC3nnEc3+*)
(*DGJ2j1c/F2gS++Jk+5//DB33DoAMfSxjTp9FUSZL93LiCVhYnqMySYt4kjoX*)
(*LKWMIPdfk9B1O5ad/H3wGEOeWL/9BtP2twNNr8YkiiQu/Nk3Wa8A9QTuZR5/*)
(*PR65PJmlc92TZeNOVnEhVtLyMD6DmLElpp9jl6ZNdVliUAk+Q8e9A8YqvBzk*)
(*zInn4LhMAp6lzuV1ytTlrXwaYv0gt9E7ujSPMuRZeJbNfxe0V5ZtSjdNw8Ap*)
(*km84pbFZtHVow6aKmcwLbGMRstywmnHNxDuJfVNGvq1pdlbmsLeh6XaK5zhN*)
(*YJmWbVuWV47IaESmYeJPbtyzty4XK7ulNlwaXH1dZpFtaNY1LyKoV7P8dB7h*)
(*uzKwpzTETjpNo4Y6dAz6taGZs5Dvol9Rcl/GljEVgDjm3Fb+xtgraBa0sSaZ*)
(*lJKArXZqdpCyZoDLYSV5YpOoF0RJNgdmdmngsK1+3bnmtAri0phBktJoH236*)
(*qatvoWfhzu358unwtPn1pclDSpVu6JqZ9xtp+ba7paGlL8xImbAUuJrhx1I9*)
(*UIhZV6aOMVXksiYPiYdkxTIB6C8byY7pRqWYFbQjECuyjLBCJ6kqkWxcbS6b*)
(*ncoGijksk64Nu6hACEVO+LDgS9yKGNVmhWVXJRak37YCZGnrlOZINJw5lGts*)
(*C5exznCumKPABx3nkmsKWr7pJajstrgyoSOiHPEZY6VQ2gcBx5rUN7HST52F*)
(*hp4If2OZTliKaT7UHVtsOqhOPAPXaHlxhVMGO1C/HZe9QE7+13/y9xE7NI4z*)
(*hE6JWGJIZH6XtakZf5BpjPLMo8yyLcMkqbpr30ZfmKYT9WI5r32LvmKaLjFH*)
(*fexa1vxxn9FuyzhwcKLbvks8yC+pB1mLyg9A7DQjLKigyVkx3mJvYoUXpkWR*)
(*Z/ntJ38Fds++taxrsNiwrPKc5VnJ5N/5X/5Hacexvpar825rv0ThG7rtQuJH*)
(*ljwdeJTjjOQx2Xp6wKWRa+ILY+t20NmppGN78yzKeMP207zI8+xWfSW2gRLO*)
(*iLpV4CEIX5cMbe+Osc1xWxErNDQG5gVO40lmYSB0jgP9atDM4xkO7jCTsqmL*)
(*CFjvF5vVqOHGZUWeUp1eyNA59k1OfjWIDR+RGpEU6EG3eovg7/69vyUsiaYc*)
(*glc0t2jauqCJs68khO+Gjb1TdkNfZxYOXqVCvot+ZcltmaVpDGG7Tphk2TpF*)
(*cHkVtx7TLGojUpkbecWNi7ZD+k6KNuGq3jkRuaZPOVGpy1GS35y4HPoKMk8H*)
(*hBYu+fj80rJ2Q+DSbH8dCp2UP459Flj4+24tLf+WNXYyIzlJ3OsjbWwLW8Fh*)
(*hZgNN5Mwv+yHKiVLwMYVuIF6VXOCNMuyvJjSC4dlL2RFGQqY3Y0VUUUrqzvk*)
(*IRhL4leQcVgsXVt29XKREz4s+rJapLDXHM/lzff00YpIluE2xXtCftJ0dQS/*)
(*6EEe2twbF9u1QShQW9qySBM8I0VuNOJptS/PosI+CDk2Dm1MMyJrzP8fEhu6*)
(*WEyzUGJk3SGicNtBQ05kFToLkQR5zFFfiOTk7/8LpOQB5ptmBWma3ppeLpZS*)
(*md9pbca+Bo5qZLhhFvJiXqlrdMMUGmktlnMymtHwDzehY9NQx/hjXO4lYygn*)
(*V4nU7bi8nzB/JOElclYAM72kWqZm/mv/Fc9dw4Y4XvQW6DtveTYy+a2s4wjv*)
(*VOq819pvUPi6HhQFGF9jlsYbNpde25PmH3dpSrkmvrxIB51dSgrv6l7Vj91t*)
(*Tsv+13/xFzay7XVSoyTqVpGHIHj9+38kHNoOcuhpKHFPzbsbYLJs6g02IDPI*)
(*Fo1Ngr+Pq3Hoh7FPoH/MSOSKtWCI4SDM2GRgBM0rKnNYbnaQj2xfMiHunXW9*)
(*4ZlbcUO91xcwQBs5CV/OQJMxPWOKlVCbdjsbcnv/RfNaiJ/XHOJPoomNo7lA*)
(*xk76FSVzNF9M2QKEnGZRG/8Kb85qTsreBoZfXDQ/oi7HxQZL1U62DrMxwqWa*)
(*Fe1Bc1JY5tI4JMv8Sx5YXO19sGD+auNp8Su0golB57CDUStpoXktwYzgXOpz*)
(*jsuCTNeMq3haIRWzKsLMpnapxBTRMa7zNIPOzJkZJEO5lBWIHg3ajjS9ut3q*)
(*jqwwzENhkzgXqUsjK1YsXUJ2yUTua9HDMoajuSFhAsyP0CdibXQX5qnwkTRh*)
(*JK2xkUXq0T8yqCFcywH6CE3rod0gzyasY48345GNJ0HHqTpiLGEiw7bjW5da*)
(*PCnNu7tjC3EHDctAC/gok5OXKTCDcUYqlhKZP2ItGQG6D+2pY4d0UEEbjmbZ*)
(*oVLOX16qEMY0Gm7RZi4MXofIKIhv5sRUAmHhyV18xFNRuYa25BkmtxB2Qr0d*)
(*sJkXZyE2ptDyrGRS0XEKdT7G/zUfdM2/vfQZ8ytI+USGrbgB8h7beJJronLQ*)
(*uaekXe6R3qfh6wlxTynZG9mWceZbabcubL6Csdvh+6NABGPeHIePbD5FRz0k*)
(*pR2NmsIJf2DxAadfMq+inqXyPw18nMath1Hepbld19v068gQahv1rGu81cmL*)
(*sSTcRaSOCZ1y6F6YtchWEt7upl9R8oInsnACOc2CNhLjs0h1XUVkhRCLVk99*)
(*J8bGNnUn0R3qIs1ubVvDdPKydGk4+QfrAaOJiPmyj0R0MZcsL6vagcUAr6Sl*)
(*51waoHyeOyMdkl+qIxMz7B3geTGaqsR0GsOsxziCknRXOmWkBkrGCph36LPH*)
(*UlNDKvTHNpAUK5YuIbukIifkrYThL0OxMGhdzn/k+E/HII3URv/SjLgaVq8s*)
(*Wk0K14+EH8g7Tt4RbLgEOSc028RNl9O8tzu2EHdQv+xr+CiRE8HzMrGUybzc*)
(*2oxNVd5KitutIjfe0MkLnGK+0cVZsiTSpdOReRUHwO+lTkIfaGjwxQw+YrRX*)
(*PQurT+uOLhQaurKTI5n1s2FRWJrYoi5lUt5xKnU+1PAVsEvj4UKoIJnRiF0D*)
(*vKtS4kWq4rFVGgypJioHnXtKyg0ZGODuhuDTb2Rbzhmp4eVtvoKx2+H7oyB0*)
(*abbDHBilqN7je60H/b7wCIsw31QuzZKSF5FhAd0Pcjg9zT9Mf7qWPXISFxdK*)
(*EMXfS39fKEoWtm5dgIxmum2xaCNv6gHDjWye4r2nDRvByTdhnb9PfbJUaV+T*)
(*0LmsXBqudgjTCTHxR1wavOK9uHsHFqkULg1Mmvx9Mi0TM/yhSsiitX5NYmxU*)
(*locLioAz+IwKISuoMzCxgvbs/OKGVyuIixVKl5BdCpET81b05dqgyQw+DGpW*)
(*LGiHYox41KWRiZC4I17oBhN4MomFupbM1hU0CyAvfAlhByldmqWccA/wXwrF*)
(*Uibz8q7vvMsCGZ2w4xbpeCQt2W7zxSu6OjIvZjwJrIIDKdmRsePmpY0n5+GI*)
(*0d47EMhYgfgIASIeXmGmwbrkFPyd0h50aZTqfKjhK0wuzVhHpB+0pK48PHzd*)
(*gLzHXRqp8ioHnXtKCitX6AliMQbYSqWX/GxkW8EZmeHl+05l0zbD90dhpyTD*)
(*cuhy+asJg0TUgvXg2KXTkqDYpelElLxI3QOjaEEG9KR9Wf2El0Z7NPUZbknA*)
(*YknwQsde+gdVycLWrRsvo7kXtBFMouZOG0/UpRHxivfq6fUIQU4WJrnFWGXt*)
(*B1yasWuafhyaW2CzqDOi0UqXxly1BSmb58bCxV6ZmI2w+2AGoJ68x/syb+pp*)
(*EReyLmPF2hRQu6FnIuI3kBYrlC4hu2Qi14keljF8bZRkVnGsyW6vyZ+Pa7Mw*)
(*3pjErUtz6JCIfGySdwSpKSKW1rkivtEVSxXNu7tjC2EHrfoatEwsJ1suvUjF*)
(*UibzP5Jam6GIw2sIuIYxazqNZHBCVKAZtcQf0AzLnP2lOxyA/aCL4QaOprEr*)
(*dI4Y7b0DgUpD8ZoS+dGGlWnndq80wcelTEo7TqnOhxq+wuTSYPdg8i8n+/8W*)
(*Lo160NmhpBkN9bAg6GmOIt7IttQoybuV7zsFYz+TS4O7KOmILRgYYZv1RuoK*)
(*Yp2iG354oclKREWuTx/DjomNIx9g0YDJIQ1LowfE6MoVZ98k2yjIM6dOrHmd*)
(*fgLz6DYvva9dIqBxqHwmGLvpV5S85okQcpoFbWRUzbtLIDPkSoT1xhMsMLro*)
(*J1BnzQOLBlf/4VWgof9mVTtse2lA/AGXps9dND2kJKXeZCtW0sIaO20o4MpC*)
(*asiGxNF0yRawTMxgFuDRMa8lxwfxqibeP+gLMDBOTMMg+9z3f+//lbFiJMPE*)
(*piPmnh3WPcX3oozDX/2mSLqE7JKJnPBhGcPXS8fDYmOd4z8zv2bQjLQJ6IsY*)
(*fehynVsJlK3S9N2R5bXtfoRcJkeuXgw7mW5qlNK8tzu2mQrE6g/O8BRvAHHX*)
(*lI1rOYHvFiEcMrH86k/+kVDmj1hLitShLliAFb5hR0qcZi8HqOHC6skYeIgM*)
(*ME3TvdBLS7VLQ2ts5420aqqyrJqFwwkbT0dXaZBMyjtOpc6KhvdNdSu3Esbx*)
(*YXZpZqGd4pTgSPXk0vRl4uDjZRac5rtTuFQTlYPOXSUda09D5aQNrn0ZQbyR*)
(*bRlnFN3K2/z2h1LGbofvjwK0xXTxmmZQ/hSWDdgsmDSNzqpadlLxopuWRZfF*)
(*hA2gHUQjzfobmV44MA7lUKIdpCk7snrRLMdL629isl4M65a0IJAoFuxXkjHd*)
(*JiNaDxs02JiQUDGyaE/eJfGBzEjSM/XDAfrlJRNQN0xP2+2rd2jG5xDXbaTH*)
(*mjTIqtCRQxM0FLnz4SBhjLdw+5IEepmwHQwCf7H8KPJpsLmmaxfN/wnsdRpe*)
(*iSW7i/lQMdabzOKpPkIrqNzCsRSiF0tpGTpiWll482SHL5YDd3nKLmjqZGIG*)
(*K/BIIqIkYlH0+OSWl/8FPehuXNtx6BG6Cn3j5f9GxoqvqgiiLideV6xI+5pW*)
(*VWYzafCu2UYOZBz+P35DJF0SdolFTviwjOFoUszHjtKPbD2/I+HBmoOdBIgS*)
(*hNosmCaTPUr+mRc2GuouMdGw9aOZvmfSEyh3IO04hUxOm08kYGDawAX6xTRv*)
(*cLfwCRL17yDaUw+SNGTnxjTDQl3/zUZOXtjQSbn0ohDLP5PI/H5rSTFtH7CY*)
(*TFzPZoxTcQB6dsnA/WSM1DTRgyo0JImGZNCoJ2wc5Kz4sQ9XTZiW7RC4rh/C*)
(*lcDz60AViA0zoUtDtJJJecf9qUqdJQ2n6yGLvf4l8IuaO91rB5TPgbsQ/Yi4*)
(*DIF/qMkxakUTmeiVe4UrNFE16NxTUojr0HQDuVaU8Z6f3Mj2n0C2xZyRd2u3*)
(*tPk/kUjUdmj7MHR0Mf9i+n/An2h0fH9edUO+N5K3vvSM+Ss/rSRFzqePWdSf*)
(*nbP7lMc6mQ4k+0kGou743/H/9rz/bYWLSSgtiUpvMTmhTRbwRw/dGN7qpxVn*)
(*+DXIpvWVnfTLSsbx3jr3vWGHW6dZTjN/sHFuIyo04L5H3si0WltnV5P/xY0m*)
(*cZnjLpB3nsC4YOCrHob66nD9djGiG7zUcmWhIemnHDFaWP54+SuacUXsM8yF*)
(*gnpcSUvepHNcgGbHEBHrzAwyokIo3r1KzP7iX0+BEF6c+rDH7CbfVPPhRB5B*)
(*0QlZ8b3v8TEL1nR8OPPnuoFSDfViJpAECYe/EkqXjF1CkRM+LP6Slzc0ncvD*)
(*+aPuRCHXRnLwv4xd7hsf+R00jI2W4ITB3HzNQq+0TFXN7P6N58qOa0apTDLg*)
(*yJCLu5KJLc1C3C18IlKi/gOc/4USMlKCbjq/HfzaXDuVk3F+Epdi4BWYvhCK*)
(*pUrmd1sbhgYNKs40UyKbONxOxB4OVBY9LMnzYw8ZY8o12UuKiGuSc408zgxd*)
(*80zGilvA1TT36Xd/nTNizjXkIp0EludlLZPijovy+o46CxvOvI7JdeSBHABe*)
(*v2BbD/swFoQz9ZHNm/+LE/2QTMuNa1q0eLdTVfg9TZQOOhuGbOkuRHy//OPv*)
(*/Tr3yZqvUBNyRi7hvM2XvC4Z2j4QeNa7N5KqaxGaTjXhoDsmedu3DU5WvS56*)
(*wGV0pEYSQSAviF4cl/c4vXTdbh8dUAGYIP6XYRjGEdWB694eJdtBv7TkPbhP*)
(*swi0MkEa2ZE0RFDO2HcdW4ccuo6/UXzExIs4fwiIiX3XbLON35GWsYXkxa+o*)
(*uEPSAR2EGtnfXzxQsGILJBmMnyMSw6PFSqVLxi6hyAkflpdwAKjrUWWNql0r*)
(*HFD+e7jTEWPfChVvH807e1mh/lgrQCnG7jiTFWIplfm91gYo71r+QVTdhn93*)
(*ONC3rbCqQ2TsgIgVAz6k40QlZn6HK0TMziNbtJJ2HyuZVHScWp23DUfW6xbh*)
(*CPWnMGPsa+Tw4YGczOleW7h80FEoKdkIwBcxIesB7a3L3Ll3M4xIJOQSvrH5*)
(*z5aoT45HbvIXYuBCNb4UfIk0nzhx4sRrQJZotGgZ2l2G5rOch2dhIPekOclT*)
(*kmi3gYO3+Uj6DKsan1v4PpAlGs2OF3zvb2ST6BOE6v5sYIQbA55wJXJNbhzS*)
(*nORTKYUaXyLNJ06cOPEaVGxXUjMs1/N9j96Enn+qFM4kXNbfnRzhHvDk/f9n*)
(*721arleyQ7H9SzLNIBfNE3BAPyBocMkgQblgjAVJJpokRgnEQcQEgbEjPIi4*)
(*YORwotBBYFBzg67vtQwWdls4R+Sg5CJ3R2nUDermyqAGnYEGGjxR1aqSSlJV*)
(*bWk/+/l436PFgfNqP/pYtb5q1apVaymG41qa7qTPfvkxIHXP8P6VZbuua0FH*)
(*cu9qHP8k6DK0q6agAjyv9GpyvNuoqKi/kWrxzwJ/NvgScb7gggsueDWMZRpY*)
(*+tIDz/aTT+XOvA2gPU7+duq7YdCVgWNptPuOathJ+fE5uhdccMEFF1xwwQUX*)
(*XHDBBRdccMEFF1xwwQUXXHDBBRdc8NXB2NTNl5sEMnRNVR8/NTg0VdXKD/1e*)
(*gGCoxT0ohc+06HTlkTtROwD+8dNnwZct1RdgeDttfUS8v/xPi+B5yjJ0NS1K*)
(*cNIyf3lw3Nxd8F7Qp4GDs7uU7C05kweOZROwLE9UXOvUnRRIoa3gwK3o7sLF*)
(*hZGu5HAJdIkHhxdOSEVXxpaOy246d2jbV6ljakfufBSeIdVD5aFiqDatimrP*)
(*/7bQP+z4mLy9DvrEt1TUq1pRdSvhVJn7yuFttPUR8X7nTw9VZBrmLHYmBosI*)
(*5BGreByeOAWMuc+2Yf3TPzpjmb8sOG7uPgfU5k0T1HUXwRA7pmGtZHC68vwg*)
(*yT8jR7uqRKnpYx15UCfyLZtPdQlbI/F2c4TJ2cfvXKDHXWNUNtWejI4H0C5W*)
(*u1waCQx16EIh8hNS0WQhVIcXdlsb27Lq8J2Rg8sdn2qeCCDh7MtzpZp02NFt*)
(*1/U8UjvTdFzPdS38alELxefBEBq3DQQfWHeCsu894U209SHxFoFcIB//9Ng3*)
(*ZQL8120/ChEEvgt9k5/iiT19CoBq/6gacJviMf6T/+4/3lrmrwaOm7vPANDF*)
(*Rg/K+7cy0HdtSiseW16YJHHgWtRhtT9ZCZzGZHrxJKimzBu6NOn0fsMvyiJH*)
(*kJXiKrPH71zDuI5Mr0bHu/sT+pifDUZ5p07+M6Uv0fEmNm/W0glOecSlkXP2*)
(*qVLdZ+rNpPUmCDUKKmaJpdon1zynoY1vqLY/arMwtLkFvr7mf5QhWbHvHeFt*)
(*tPUR8ebBHVPzyk+XuHugV7AUqIzpi08QgqdPAbC0JNVW+yoNwun141e8w3/C*)
(*3H0wzO1NrdMFdEjnBX02fbTjIdsV6+OBdHajSOK2m2/m0uAeZJoby7ognL1T*)
(*CpvRXfAQDMRAnZEKuqbm6TjuZrv0h8XdpdWTLo2cs0+W6r4IonlRs23FPlRp*)
(*+uqqknLoMkf3llUV0Pameh+z8Nuw74uHR8R7Dw+ZmhOfhobIm3hgU5avl4E3*)
(*mAK2bv9XDyfM3YfCWIfLtoe0YwIHhlzfBRXbBJeWNcPPERpofdptStV1TbPL*)
(*Aepa63lbBzjD4aboc55AVyaWNt9vpziDrG/K0DVvN7OYHrHmR/j6kNjLVpJm*)
(*BZIW78fvZKGri8AxEP49f3QrGLsiCQx1kcMmo83BVU1V9H1Elw7WSIvEXCok*)
(*j3lgzwWmfKZ6ZBnTtqWK5kaMfnelZ85dZWlexNiXaTSR0AjKrooNaEBreM3L*)
(*S52QXnwTKbpTd9Kh7jG8y7g6pe48eVKfJXlsc5tKgmb5y2bqUPvmqoXaXsfb*)
(*nLSnRz17Nc0KS3D+db9octKWUXeW2ss8qZNz9pxUS9gngK1Lg2iVuLpuoA1m*)
(*Q0cjQnjntjH9ouu/9823aWhqiuFneQgfUgw3YVA+i8D0RIFnQn6UZi/GwGtF*)
(*MdMyA8Ypqslk44gR6ErXICKsmW7Rjlv2/ejbEo3upntpinMn/v3/7Hf+o4kU*)
(*huFEFerPayHCGLoZ4dh035aRZ6Emen0XOxDHVr20nUytBx9StIC7i3deW18E*)
(*JouwTCzeYvUU8ZErkEKqyj4thoJEaeitTWSye3BcnIUma4bnK0tfRsZSbw/J*)
(*SDGsLHPDKIuNlWUoQ5ASC++GCM3LGsa2cBjhTLI8y9Ki7kVWuozntpqK6SWY*)
(*QI1nIFQmaS3Hl7EKdU1HVzbqL3B/ajtv7v6L3/9vnm4ojijCDAlSPj/GsiTo*)
(*ei8GnkuTkQ6XHxYxXsHYZsgOTVKhePEkESisDYqDuWdBnsBNwwPH1Z5vil32*)
(*Q5W4ZBRDsWSAYcGCLCluD/TpFVng2RbbzdTiN7o/cSf7UEHTDTDNeaNjofSN*)
(*lRwO+XSrFZXj2ONNw906ZXn/ApOjm6JGsXpcNnUegmjBSgp47U7Gpc1N5nfy*)
(*HsXOm7amk7hfdFVoMS9WLMdmtWW+NMLq+J2AOAfDn/yNnHE17jU/zVPdME09*)
(*2kLVl3mfKG66OoRPQbhgrLC+GWndTY6WxtKWgbbMk9hXsVlJ06zqRqopaCym*)
(*TfrB+sBvrtTJOXtKqrnEuZMYw3Fpxr4mX9A8miwwYLdc/+aPfpulNK3xuXQB*)
(*O48AWRLO/F3/bSfG7VpuZwzoEIQIQBaE5lZdn0MbaNX72Zp9f/HPf/e2hf/h*)
(*X2HNgrDbOLTQSRm9k4apCeiWzc4Iy6VZ7ZYwp7X1RSA8+C8y8Rao54wAh488*)
(*kRNRVfZpKYAMm2GOGkI2VWAqqkOVS4CzyGQtL30DZWnLNEkiyHu2gjhNi35t*)
(*mSeRiMjAFbqNNsQmcEpsXnbMxULmVP3k7AaLEP3J/84dcoHZZ0d5203+CfRq*)
(*CHqUpZTh+zXsCYyTx63CF+9ObQ+Zu3/45f/3ZENxRBFmQBvo01PDSxuDyxQd*)
(*DBYQTIlLk9T9iJpkohwiQNKK7jaafz8okYFeWkxSxYEodwNcmwRv8mARCQjL*)
(*Sm2RtAGWHNbqEfm6Y6xoI3XFTqTYHb8ToPfW081mdBsgLSbxoHrcQp0OvLME*)
(*eXcxnnINv0Bribxof4GSHMyoGod+GPsY1EAPhyZipTF3cPKYP718TJBZV+KG*)
(*vLDBPaFuCk5+7jNMWBJ26DNsh2nyFVwSrTl859gIMJQwDrJhF8e7tpaMwRGb*)
(*ZHOaJvrpvzoCkZ48ELy4W1aRDb6PH4kd0U4Ts/GENUWx4NEGRzJ1H6/XhFJ3*)
(*h7NHpVpIHAlwXJqFI4vktw7yOnBADIsWMps4BTN1wag9jACkCvO3wgVi3IIT*)
(*DMeFRtxcD4gsRmDE/6bDwcYQbaMPO/Y1kQLDmSaXqijqbljnFcDlPPfl2NW3*)
(*yEZeB3FMe3WpcVXvrLYKhUcq3hL1lPDxZS1yQqrKPn0HZk9jBmpepCZlZ7K2*)
(*7b3fRFnAtjBJFxvLTDoTzeduWpv4WkLzsvlAl6EcV5WeMIoxHX1qfLZD/gWa*)
(*wRVrnkFgUDc7bSmqMwvwper1yyj4U9vj5u6phuIfj01bAKiL6M3GUjGGkFx+*)
(*6ojWsvbcgPspQjQUMGsWnYJL6jwT642p1OdJUqBVQESiJxrwHcIR3Edk0JcB*)
(*pun91vPH79xPN5vRbe9mjOQLlhlkCQwnrdpBkIhY+KuN5i534SFl+g8cX1VR*)
(*dP871PCdiRJPxp5Un2icjREbS/NGKYa3YBbh7zL2coXt4TtFGPZixoFJZDZ/*)
(*WaqSOUjB7yP/UrSo+inRd0o2dgLaAkZ+SZ5Zj2X9oFDq5Jw9KNUS4ohB4NJM*)
(*9MRrTxgIHoUK91B2UHoSe65O9vwBBOAsiS86Y8AXY+IqzNyBJoOqkwoRALGk*)
(*1EavaCpSdmPLPhQMYVOh+jXr4XJ2ada84Ashl63ntZUvPFLxlqmnhI8va5ET*)
(*UfWnsk/fAZJLk4GfMhaBrtgwH0lNys5k8d78dGXZj2v7C3i24JVhwkL6vci8*)
(*bPlbYQM7S12JxngLqOezGXKb2vO3do9vEOsZl0YytdWPm7vnGopj0xaGGnld*)
(*Vty0Td20ub9yyA8BjdKk7eRjoShNGjp0g9D9PG2luPK84i+97KsYPDs/jpBT*)
(*rHInl+NKilPjVO+ANh+/8xUuzXRzwBZSCLg82rwQFDPcbmoRH97dfxiWaRxl*)
(*x5MUb65X11MD69IcuVOE4W4sC+ngEXPZ12CoCksMIxKMa9ky6E+6NPxhHpU6*)
(*+dDujJRLHDGIJbxLIJQxLZmSSZToqnBHCsLxyeM9i8CI162mNMzLE+Mtzn3u*)
(*YDH0UxECJJ7AUzquR3rSpTlicLYYnddWrvBIxVumnhI+bgYiYqvs0/dgmx48*)
(*VEmO4zJyk3JPU/Y3PENZ7rs0sMEEnkxsTBzCcQaRedkBhP4mKcR8H6AN+Fz0*)
(*hmulWZdmKPDjaO9J5tIIhfM15u7lyYbiiCK80LjWHszo8Mknfnowee3bF7I4*)
(*CgflGWzpTfdAhA7x/f6n0c7eEUIcvvNxlwYVsO3HoSk8msKj+cX+kc0L6wjH*)
(*G1fZ7E3gxX/nwTY+s1k2lI4dDeQcnBovksc4/5vZ4Z5Lc+ROEYb9PdvFxCQZ*)
(*qo7Y1WeWJy9oERRE30L1CXU+UnpXx48gf1jqtnBQqiXEEYNMwhOcN6JbaP6c*)
(*DazAUp1HAMfidF92NEwgxlucu4TEyYUIcAT1pQydkDreIvbtxwvTx3NdmiPa*)
(*KhIemXhL1VPCx81ARFRNJZ++B9wTT3hkUpPyPJfmjKwecGloqSXLn4w7iXQJ*)
(*zQsvJpmSzVQDMrDo9pBoRCtrDDKpiaM0nZQU1KV5yNxheJah6I5NW+RV66PW*)
(*BQRqDm1/kIHsXZqXsdQ/nUuDMIrRNmbfD5SJuzgw2AGHSF6Lj/2hkGM/jBCd*)
(*O2KUho45ko2javpM/7HH+/Dj3Tv7pipKUVbT3qVZjW57N4gQBD8z+6aT1UGN*)
(*PU+ufJKQ5hxvLElCu5c1yw1GDG+e1Cgge09DbCmqN08uzMAhHniz0fObGP6w*)
(*2oRlsT1+pwjDFxpW3TMOslmmxdK8vwz74HhnHI6dopmC8KBHch41v4Dt6Xlc*)
(*JBLLPbrITIJ91282nvYhJq7UyTl7UKolxBFD54kl/KWJ6QGSJaex35ICNuXR*)
(*Eu8EAj3Kh9S8Ze+7jGxzVy9LIMZ0yJRQcPTSDCsxApD8cFOMAAY61tPQ8Bu2*)
(*7EOiyDIaUgLmiRuy2ecbQIPmjem1Qh1waQ5rq0h4fhr/vli8Zeop4ePLWuTa*)
(*7/hUlWoWyputKmG+Jt142k8cUpOyM1miNz9VWY64NC/USE4kjOmoReZlR5Wx*)
(*diZxdJMGTQfVJkFIYKX1eZMFPAQLpR+BnFPnhGSwE46Ip7bmcXMH8CRDcXDa*)
(*grPb8YaMXQbE9pcEidUsvBtIQVwaRpY6SOOkIUHp7PxOAIqv2+5kML3y1+DP*)
(*hsRvxHYAu9CQ/jQZuDCe65iqKsrp+jne/VQpucgjyS7+RQRYNeO8qovYwMyb*)
(*7yrIATskMLI7yZJkFUVkgHx95t16dLscM5yWAGlj8FEiMJB1z5HPIcKJZ046*)
(*I97Sc9o3VTcMEu8dZplH9suC0pKkmFUPMU/k7aBrCBvCC6d1JZs1RC4NkoAH*)
(*wqNY8XjmTjGGnZBxZC8epeknZZUFhOG65ST1wAQwpwUS/hM+DFhRuTD9pKpS*)
(*k37S8dMt3SG8rOiuo0+zDGS4KWZEZC6FxD+0oBBLXSfn7EGpFhNHDLhi0loG*)
(*WBghU9GakzVnyVfIqb0S7+PTeO8hBMY2I8NXNU1FAPvpS7LW+ls7MSazHknK*)
(*7eE0ByQYCxFoyfyL+Gxb+EgNZsqGfb+pQhDFhRyERKoXJwE9jadoBpaEkWgQ*)
(*mZoJuWgWxEYmN4Q/p61C4fnbTCLeEvWU8nEjcr/kU1WmWf9IeMRIDjt64mFa*)
(*nFMSEpx5JmsLz1cW4hiws8DWMpMfFXjJIsYi87IdMt45VVTNwL0hUHsIx40L*)
(*0ZB7CEgoJi5t0eEjqDR9OgPMTC9J6GnoSWgQR34tmdoeNnf0r88xFMemrRbx*)
(*VNmnu5BTA5O1rYlbvszCe+jJyTI1yOtugrae1JvgBAufO7PzO0FHsqxvuvtX*)
(*VMOwZrkuk96sJT/7e5PO0U6UkMPo9p//IXMq0/IDc7lUtgXbqU9IaODG7Hqj*)
(*cIk0oWWI5E5KNF64rPX1+fNEJZnRbVO7m2TZW5zm0+/rkD4M/re327fsAmMZ*)
(*nhFQyelLR5t/Rqe2Z8payyl0LcwXgWroMS4AO0KvGpuYud3Ns2C5VK0wYHZC*)
(*/+nv/dbBO3UsaRwMe1fKuLFOFhaQ84SK6QRQlaGM7OVh3aVx0yF1FwEClBTN*)
(*DNJ94kdLctNu+l/+7TfLqzTLY86ja04yWS6e1KGqNRLOnpDqyViJ2MeDcnV8*)
(*fjKD4V71W7Q7rrOWflmN0kokpp8zZ0HuIsDphoDfZe8nv5Evxr0/D5skF5rZ*)
(*XJpejEARLOPVrJBK8MK+H//4jxmEjOVMrk1FUnPTGPuouhVmVWIvourEecho*)
(*iOWHzqK/zMoRw3ltfZEIj1y8uep5l49bgRRQVfxp6nYmW64OJaPgiJT2/pC7*)
(*AGeByVrDc5VlZcemx8zJBHEsM0AdzmdwFhCYlw1RcgaRBYLq1/whj43H/D4Z*)
(*lyUyUS8Iu3EKbozlfvP7/x5DCs7U9oi5S5l+EE8xFAJ9ZwnFHuRnk4H7YG1V*)
(*Jo1bzcLrt0QWl97Iv3IDuv8mm53fF4a+P1Skd+zajgT5x77bh/sPfAnVVGg7*)
(*TmVsdNC9MtEyoZffOSFbhCif7Ojnj45uwgGncdPWsaegaydouv3yukGtaDmv*)
(*G1Dz6QleVx35BAgwlMDQYlqMOJS+fXDCHxXI2EruMPnuqCEteqhtZXJ9nCtC*)
(*qZNz9jjfHyGOCPDZ5/WeNVgq3cv6fibO2yHAFWOYLvWs7WeeHkRgxDjv/3CX*)
(*uJN8kw+N3QMKdR8OaavEZN0T75163ufjTuQEVBV8GvWtfkUPpNeYlI9RFi7p*)
(*AR++eZkBRzCsskPlUQCfusysexVxCYH2AjOgd0CyA05OOYr+K8zd8wzFK6at*)
(*LWxn4dNwenb+mmHAuXP3G08MuKqGFZ/uUHHBBW8GQ5WnWVHXuFjo5mDCwCZB*)
(*fQxsc2kueAA+AR8vwICjAYoZreZdnGz28Fz8XvDJDcXRWVj4/DU7U0CFBTTv*)
(*fqscnKHkHikaf8EF7wZ9toSlrXizuKpxNRLFij/MoRihjMamGP4F5+Dj+XgB*)
(*ACnYcsNJL7bruhY0wvae2qX9LeBzG4qjs7AIrtn5ggu+DhhrF2ULKIYTbaLP*)
(*uYcTa1UVlUWxog8wVl2GkggUBacUX17Ng/DxfLyAgbErA8fSaNsA1bCT8vMU*)
(*exPDZzYUF1xwwQUXXHDBBRdccMEFF1xwwQUXXHDBBRdccMEFF1xwwVcBQ1vX*)
(*b3E49GVs6ubayjwPQ01ac5555slMHJrXHIN9IqADufePVaLC/u0laxc8Cx7R*)
(*wU8LA2qV+k4FTt7zWwC91PQNbfN+BT7uwjFr9rmgr2Pf0Wg2tqpbcVFGliZt*)
(*3DDEjmlYlg1gWZZpmpbt+kGSlW9qp7sytnRckHfbGx2jZFoUI5MAlJd0k3tI*)
(*9WkARFDudhK/gIEu8aBo2gm6iZn4KA6+reJzPR/NuzH3V43kuCrUV6mDm9M8*)
(*afg/XBiazNZpgxvTTfPU1q07/YXHysOGC9sFar7g35YdFo8kmtYJfqW1f+Vk*)
(*eaK3T129r4MfjeFZ6D08noBfa+8TfGtgpGhNUkxmOxa8rc4iienrq8TG1YEV*)
(*bscoCTpYEVDrckV1wkLsD/WJb5H7dCup5ObykDX7bNBmPvgylheXddPUZeyR*)
(*Uch7UfVdm/pLTW8/CHx3KQ9qBm91vr7JQugxsO9nMaFUJqTrhO2HBALfktbl*)
(*6KqyhTYDHlQwPdRI7gICQx26UPb3BN0kTHwch0/AO2jogEqkttDKkzTCIDC2*)
(*ZYWumyxyLP1pw//EQJTrbWBsoKmxFqRlXeUeqfHKqavMAumYo+iORwrkKobj*)
(*+x5MNIKWBHKgjZZMh6jCTbU933PAzbAeeOM5uK+DH43haehxvyc1eY+w60Pf*)
(*guaVim67rueRyr4TdT3XtfAsIpo9iziQmL46DW282DlnGboMO0maRidgI+QW*)
(*QueUIt/W+WfgjjX7lEDaA63rVL8gDxQ1unJ3TWS2gBsmoo5gTOHmhFaKNnZt*)
(*9Z4FYzm3Ut3/jXTXWvuptTGxgz+axmQ4laASHpdLcxbG4z2Fl2ckTHwvHJ4N*)
(*YBuJ89xXaRCubEATmzeLlgyFnixfuUuzUq6nA+lNuQQmcN9DS954dHpKVewE*)
(*ekVCn8QQammMufJYhHbI1WlCxM2AQKpvBmkmWDjKewXipPL/KTA8CyOnzvzn*)
(*+VY/eREmLcJCiD9POoml2mK5l5u+84ZxjHTUgg1EOsN9SHVuyb42nv7kpajG*)
(*39DmFqwAcDtXHtyxZp8SSL9djdcoJ7MVPZC1vEFAG45v7EBGnFb1jUgwlIGQ*)
(*6dwe6C8vVZpya3KkuEfvLIq4L+3l0pyFgQj/GbrJmPgIyPo4vxdsLdsKWhRS*)
(*WPrK4eWA+lW7NBvlejpAF2m2WmnhqnooL/Y1BIZJArakwyYtlzoUpi4y79I3*)
(*lr7hEraC6ZvbWRaeue8u+jYg08HPgeHXBX0RRPOafWt8BtF8Qx7FhYIpRwR/*)
(*PWEZ2pr5WIfsjLLutkD+kjm6t8QZwAKz3cDXILVmnxLGOpI4HmOTuOG9MIvA*)
(*f6C/8wM1XZlYNHFH1e0UZ+P2TRm65qRqRVsH0CRL0WN2p2+ofXPVPEvq0ujM*)
(*NlM3aS1viK1vzGjommaXA3Qj1fMJB3PGYX7RmAe0w7ai+bwyiXQURlok5lKy*)
(*VfhgGdMOq4rmRrPsjGXszW1hTS8hVBj7MkUNxCaqdlVsQMNjw2vwRjm8R7Pw*)
(*dufxO+HFbW5TjmiWDyO+y5E69WmjZfifTsVATKi7TBxr19ANnAOl6zZOiugj*)
(*2zCWS5Q2MKd9WX5G2bNYlTp2tOkdhuFEFe65pqMr3YyWECsfwyaj3XhVTVV0*)
(*/oK9Kz06BEVbNqP7MjK0+ZWTOK0yOtrcv7F/mzQL13XX/aLJSV9C3WELh94T*)
(*NsTi0NQUw8/yEO5UjCVhjEcl8si0gktTvEWuQg9Qrj62ZeRZqNVd38UOxF1V*)
(*L20nBnkgT4oWLKH1PbYc5eIPiovVQEUOBdMVXWDeS9IRcAkyD02eHy4nCN3G*)
(*ue2tH4UGD0+JT+em8KX6FTr4dAz5ciISKq5J2cFYRM5sAJ0gyfMszYpufOnq*)
(*IkBSh4YzTUQ6mARDt/GUNJQhqLSF5xfOtwArFXWunPRLo/rFV2jmW6ceZEC0*)
(*nhKwlbRzihOSqaIwdmzv0tyfd1afxLtFku2kBWBHgxelEVgzycTEkYH3B9gp*)
(*28dYToDIpaFbtxyvA5dNnpzIsh8qyHuZSDqtj24MaCbsay/d2McKM9VI626a*)
(*o0kTc5lLc5tEEjf5aovY4fcGHdsMcQC5tJNwZTkKx8G6D1sOC7ZEbxrpbp+i*)
(*RCE9Lps6DwGB7W7pqu0pASfrRA9mOGzuTpNim5vM7wXOULKjvO0mO4bpgHtq*)
(*V6tO0Irl2KxzMF8aYXX8ToQ22QGJm64O4S+T336PI3WMPjHJcDdMU96qK72Q*)
(*UIeYOLZFBH+y6ep7wL63jddEMItZUTn0FWRC0DUma1WGDNMQYiDj0EJv6Jlf*)
(*fAxRcB69eRz7FBXz5C14gcWKnTdtTV0Rv0Cvbcs0SSKSmhDEabpa+rZlnsS+*)
(*ig1BmmbVZLWpoKLfbJIF4tPWvHeFrfRXskYLqZIeMVwqlQFHPDu+PpazIUag*)
(*WzbriC6XJnSF5mD79z/bKxd3UFys/gb53agvYV+nhiSWNZRUStXodB7pGGOq*)
(*O+nTcmPJPr7qnn0jX6pfoYNPx5BvtyfMuULFNSn7UeNnnbhaNw2fVpSzIUXD*)
(*mfQ3IqNTlm7vJiDDN19ZsKLcpF+gqpx41LD6Vnn8wRXwXRqRsWKabivq3LWe*)
(*bhVtXJr78w4DDbnHPaIMEKXhZt1wrZloYuLLwAEEng6wE/2IeM8gdGnGCIz0*)
(*TpJHnKVD07lLbblnAC/IIqEhWE2QRQcOnixy1WBdlrs0K9A8kUSW6KtL5jC4*)
(*NOYKB9STfWzQLqQZVePQD2Mfg+Dr4V5ywE4afoEWD3nR/kLwYBOxYpzjxYrm*)
(*l9PYlNXKEXC42WB4+wxTDNa80xW2LaoNLjlcErIcvXPEtDQnS9VP/5HAHcyt*)
(*Yo5Aatzi3tcWTc2VEOo4EyusI6pDYqdtalMdGUK8UVwR3umMgq+syrDej4ZL*)
(*uFOE4T/mHsP6zuIcnhoTNE5lTiBtcFuWm+JQDQKK6fxQ7Yh2mpiNJyyoigX0*)
(*aHDEQPdLCYYbYetzMIxahrPbU5LrOomrmEoN5M4ZRT92VVHUnVgfiX2wSHS9*)
(*g3iivbpEqyEJtqxyyQa1xeqXyKNRLBDdbiK6LU72aFOq72pUnwmRk1ZBr1jQ*)
(*7aDCyZfn91IlUv2IDr4BhhK7vWdfKzYpLLRYhKiWYbvHDAeSIuhwKLPohkJr*)
(*k77bQvMFXSBvKtUvrKr6rH0rWH3rzIPLG3gujZCt1KWxQGAzz6Ca+/KydmmO*)
(*zzvTc2zqr2KGdxNh8f2SJpVrayafmHaG5c7H3wYKErY1y4c3y+5FaVROlk6f*)
(*J0mBFrkR8YCpv4GjFhr1w4mQYIGviSJTRg6S3cYdStMaX1WETiOeZ5eb4XKP*)
(*Q5fDQappNazAihh1zeHtvGOqLi8UPfhdiKRzcf4nQcA1JfD0verHWuE7yUIV*)
(*71Ys02KXsZcr9/7onWSqUjCC5F+KBmteEUdAzZeXMxotJtQZJoI/Rhza3lNu*)
(*RjRHbPIkLdq2jrbn8lZWZbPSgUu4U4ghth43fP4lrdph2JuNxtnMGiNECeZp*)
(*UZrPgzmyBBzWDGKpcVDYtjvyxOyjfWQhlfBaex30EOrjWhf4wiDl+Eq5ZIPa*)
(*YjXNU7BmV50gbae5Sm6gyLknZJ+rw6aMnHtaR927pm5QZLdpUCGO7qRdhHRK*)
(*/oq+b8osTbO86sehabbWSCzVj+jgKQz7abAw5AnaTry6F8rJjn0yk7LARndg*)
(*E2RZAm+HAw42GEYs+ZCaK/7W2uLJrM3mWyceFLyBgoitRHMX3oF7QBy2/rwp*)
(*WL44h6rQyksmv7BH48v2p1aDujcx7Q3LBwD1FYWnm++D0KVpHQjS8MbYVzGO*)
(*Mqp+HCHTpa5MaL6fHWA9QqPcL7sJ6x5KfRwkIs5xXZo9DqBQ4YFl4OaFogch*)
(*ZOHuCMdqLhlQgW0vDvFxp0V1PXGzLs39O8F5oMcfpGPZUsNcIpYHCHWKiejo*)
(*GTJVZtS8tBE7sc5H6hTTjwPrdt6lkbCyYMLOqhlso5dkCCvRAtedWobTLg2X*)
(*dweFbUdAggyesARUAj9qTfNj+viIarCPyAa1w2psc3PZ+VKDfaS9z/1wWTh3*)
(*JGAFK/dDkGMF3CT71RneTFQMz/dt3GHQzw6fbybiYWyjEZBWpJhBnMQBmoEV*)
(*Zy/zIql+RAdPYVjnIexmOa4Lh4sNQeqISE627JOaFAYGSFWBjT+SqmrM8Yfd*)
(*cPAGE3gysTEhUd75lsQ27ka2+taJBwVvYH7nsnWvuZChAgkwD5iCzchhI0iy*)
(*PwVptGYkP/6zGtSRienjz292sBa+2fxSDE0cZXecHYFLA3l3mBfbF5CcZN3D*)
(*8wUObR11adT5FPZJl4Y8lAR7dI7a7TrCuySr8GMTeBzd37xQ9ODfebA1zaQm*)
(*DqVjR/8nFm72d5CcVezlsEtz/86xxmk3bDb15JAHkEkrN6fqcvbzAKFOMZEG*)
(*um+a7VkKs+8wRtjp8DIkPiOznSR3aYCGcKcIw65rGrSELjyTlm7z19HmgQyB*)
(*Sa1kY4lbHLZwmHcHhU3g0kxfF1Np41ad0MdHVIN9RDaoPVZ9P05Miz0aftE3*)
(*1fP63L5pq4ksWadL3QPY9dhPFoOvTgQgSGboJklkfgVdhlMTjWj9xgHtjChM*)
(*Ll8b60a4vkci1Y/o4FkM2SH3ZQj2Z0MXiZxs2Sc1KWuEEsJdE+KLFhs92g2H*)
(*1FSx/Ekq6JEWybc+3qURslWsudsvHp93WABGC3UBz/u6f9f9WGFVHJiYPjxK*)
(*84IO9JHDFrvFzRAZaJ/sBYVMq6IUxLAGUgSGlaiBZn6u5msKpJQEkcgWn/JE*)
(*YbR+GCHEynFp6LadTqeYYRu4u4MS+lJi3RRORg0kz8QdNqMDNSC76DoJUyP5*)
(*JO4f2mAyOBUwyMbTvL0ieJCGyJSAqPFk+pTJsND7FxsOUk0qgG3ie8MqPYPG*)
(*M3mRQOGdcPYTGSvC4x75hBG+EHGkIS6rQf80wGZ0MUoIdYaJy+cQLBFUUt6K*)
(*bCNC7BQnUk4z4Nos4GX7bPAhXxq+JeRIZt90MkvWicOzY7Re2eLqgEWda7sd*)
(*jdL0Xb/ZeGLt2EFhE4Svzeo3YiphqWBpLtFHkOQ51WQt2IdUg1Wu9jvxoLZY*)
(*9a5yC+GuoXJXTiNFZhI4mrcPAMl7JOw59pAoxGMDDBRnbij7onyokOw8v+NI*)
(*joHiindfiEqRoFfayfqVXaZsg7FjHq/PmMqk+hEdPIchDJkR9Y0FI6QQy8mO*)
(*fTKTwkKNhqAlVVOVZbXdjOOo0pJVa8b0XeJv4epzopxb2bdOPDhD5+0VX8zW*)
(*32w0F7aMqTSyZvz4vMPC2g0e27pq+iU4jk4+eEtCSBnZJr+CHCc7UT4xiY35*)
(*e0JLT05ofpy3k4COQ1vj0gWwrUlWpquI0ww9RAtRZLjuJmiqufKw6OAbJIXe*)
(*FCOM52wmlPTtZD+HbDE6f2GtQRUd0UVF7zX9pKpS8g1Vd/x0E3eZiwdilPCR*)
(*p6bOIucmqAsKqqrbKD7olb8GV5SeCSU4YD1u6XHr6bOGQbYb9kGsIdoeoxA9*)
(*2NCDeTfDgogvFCXrIcVJgerTHT4MRRNQ5wMLHXtJo7UdTvpVrHg8cydZu2EE*)
(*DVgu6TBZdEKOjPSkiWImZZXRjHfdcpL6lyJCHWciIRycyNPZmQtciJvhhiGt*)
(*6KioCl4FE/QItqTkiOrFSUDPeymagb/F5whYEmI64BjFTkN7iLUiRxSfTcMb*)
(*VQuvyUEhIrRbgCC5oruOPmkbZCMrZjQwg6UZ0YeEjVh4mkZb4q1tXG9ESKVf*)
(*VeHmwItYH1siyWS1Q/JbAoIGKxtCbNfKJRSMYYsVLlBPJylS3GY1ejKRGR6J*)
(*+dWpx7ooBTlpKgpZjCmcoOGcGsBbAKrheq6FdVLHOzv3XjhNGwnc4a3vANf6*)
(*3nkZiVQ/poMcfRJhuHdpYK2xycQQy0m3Y5/EpLDQuZhnqN4C7SPgBnMF37U6*)
(*v9AfFRCbZQiib7Em7mXWL161ls23zjw4IwHWZnN6TsjWX0KGjOaUyEnu8Dbe*)
(*zadCAqewVZKIe8QUDKGhTKP3k6Ib+jJGj887kiTbGS+7xjYjeKiapiKA/By+*)
(*fG6tmWxi2svAh8KQ+uyZX+BCTJxm6tLszkEPkaXdOKDolptW4vBvv+ySO1EC*)
(*h640+8//kDk0avkBs5Ou4B3GIXWXfG5gsqKZQcruBg6xzUUJgF9mZN6F192/*)
(*Ys+iWa7LnJzSUOHNvnSY17vJfiOSPYqIKhvQIQse7HJLXT4R5lQcxsZj3jNJ*)
(*Pkjc2MTM7W6eBculaoWBszzyT3/vtw7eCafwIpv5xcUOXe9KOTLWyUIfcoRY*)
(*MZ0A1cwQEuoIE1mojDmjnsKS7qK5SUyqEMTVLxnKE4GJ5+4cmpviO1XdCrNa*)
(*xJGxDukrIJzkcXewG5g9KdhRQZnGcGf6phnsxK0l+fg3/S//9hvmVstj5FZz*)
(*EpnMMMAcBSVVSUw/H8VU+tGPGL7T4xUCffwXC/XQMds8ZCTV8kNoHAKATLEA*)
(*W0a5MtGg2tTdYdXPG07wGS9dL0bGUkcHbC2W4BPSBbU6hUs+4+6jz2W4ekrR*)
(*k9WkiT6t2HHbd3UJUQ1zcgEkL5weCc3VK3Vn2bUBl8a/V8tOINW/elwHD2Mo*)
(*cGmU7dF2vpzEv+SwDwHPpOxG7fHMNTrOM2nKos5sZfsaHSKyN6jtv9XnjKhr*)
(*VuAtZkcxNoq5+tY30R8cfpB+fVUx46YyR40EbO1ReS6LPZirzZ3FusJnpxCc*)
(*W3PXFAzrU9RawCSAkYwX5NJwuiHggXEaiPCtmWBi4qnwJ4Chq6uqxpn+mxag*)
(*Q98XIcrHeh6mY9d2Pbxu7Om/juDY1qh/KQpCtO3zjolNIzzc9hQHfhrJwYCT*)
(*D45tg9qc7pWlg4MI79b/dOgadOzhFFWHFp8MwYH57WEJEaFOMbFvOR1QJ5Hp*)
(*Ohpt7zrJcZiJhoAeanq9oyQHw3Ec+q6523Z2IMx5oFnuCVG7J2y0YFfW9zNJ*)
(*FzhOpYf18RC2O+U6okHDgMLFHRYv3m7PSPUC3VNV1ZZf4zD0lYlCQ2fVZzW/*)
(*j5jCKE718AvxMbqNWz6xYz+mM/xavUyig8dg69LgsJjBOzt2Uk7kJgXXFLLC*)
(*EjEax9MnZc1Cc5V3xEFBMMhHzNd7gIStIzIjhHd34Z7WTKxp4cza/m2TRXti*)
(*X+/3npjeAIYm1ddVxy+44IIPh4FNnbpgBUOK4ghHM3vZB1GuLD0XD3t5uEHz*)
(*wy8coW1cRieuoY50k1tX5KNgNeQKnw23397a4xCNEq5dxDLQn7p2vuCCHeC0*)
(*H/deEeYLLrjgnaGOoZ7/x9Qe/8yAyppp3uHGCAvkIc6qUFR9AtTVWHVRbdvH*)
(*X4ihjx1cc8VAJf01w5PWC3lvmIeMeo6oyk014/I9Yh0V3SxRNMN2XJf0BNez*)
(*92i9fcEFF1xwwSeCHO/yK6qKCoRY0eXVfHIY+65t2u558f8vH8YyDSx96SRk*)
(*+8nlzlxwwQUXXHDBBRdccMEFF1xwwQUXXHDBBRdccMEFF1xwwQWfEsambq59*)
(*+QvWMNS4pSb/b11TfUDf1V6GUts88dDic2Do6rtnw8/DiE5UXvr6w4UP0r7P*)
(*DzKTdefJHxBJv+7pvk8DB6dqKdySdIdgqDxUA9KmxSDt+d8W+ocdcysuvQn0*)
(*eeSqpJWzFIY6sOfcezNIElc3H6fA1wZd4sFJBJFUkKpowVnOPiwqfR25QpT6*)
(*KrFxhU3lfLeRoclsXUWNfBXVCSV15U/ciWHM/VU3zKeYy75KHRMKru+b3R+G*)
(*z6GwE9csSk/LF3aYBaizwCBVwBTDCZLIMT5BZ5k3gCF2TGNmiglAGOPFUG/t*)
(*Ue17IpZHdaFPfIvcp1vJrhrg80BmsoYqMg1zFnSGpoioFVPm8Usg6VlDxMIz*)
(*pvvPCl1VtlBA34OaoPL29FIgXS1023U9j5Q8NB3Xc11Lhw4s7+H9NslczPDe*)
(*WMYKyny7cVZVeWDrh556FAipvyAY6tCFyrYimvS4NL16+qzCo6IydoXvQmVb*)
(*Dkp1Gtp4oj/dExY3dpmcWo0WzTRCQU3j43digILqqAJqm+JhKulrlGBsS1ya*)
(*u8kiBxcgfVX320+gsEMV3DYgKNP6gs6tW9iVcbOyyhPS3uet+v9SUn8U9F2T*)
(*kOq1uh8CBC62UbQy3qPa9yw4qgucurXB6SqIx0Bussa+KRNCU9uPgKa+Cx3G*)
(*8eT+pZD0tCFawVOm+08KjcnYWKgK9QqXZiKySUvYjP66jVpiqfarrPlRGNq6*)
(*bUs87d0ZCzQuYWt7Ypupvg2XV6T+cmC81+F3PFzplIFXiYoMJeh4e3KaGyP9*)
(*pjgp/v6Y4WaLOr+E3fE7AcBCkiaAfZUG4atEoInNm0XbzUAjqle5NB+vsImF*)
(*ZuwabRQOOS0gL2iK1OBCPM6irmNtv1n/3xWpPwpG3IRXW1Wfqyf/gOlN/4j2*)
(*PQcO60KLSih7KWowMrS5Bce2cdfLN0JMbrJKjKq3KtxfGZNxpn0evwCSnjZE*)
(*HHjtdP8pgbSEoxzEnXNf49IUQTT39Ny2Uh2qNH20WNUDqNybiBFAWz1j1Wa9*)
(*tW5q+gZc3pD6y4GBTMrPpcmrRIXez7vlWOfcLbQ1870uUVHnE/50dvxODFs/*)
(*4VXQJirbTBN3V3/VhP7xCtu5msEQBzfgE0WHoO/nzWD/2KWWYr1i600EG1J/*)
(*FAw5Vr51e82hKT40fDTDQV3oMkf3ll7PAzQ7hrbIbwJ3TBY0iN/IWFO+S4XB*)
(*e/BmhogDr53uPx20Pm1Bpeq6ptnlAEWq9bytAxNi5DqzmT7mgT2XRfLv1xPm*)
(*ORVj7Rq6gXcwdd0GN7kIbcMwDU3/07/+NnRNRTHTMrNhn081mV3XUwgccmna*)
(*hPQ70+xoXvrlUVTjjillGpqaYvhZHsJ3FcNNFnK0uU3LRGmWv9CpK1262a+Z*)
(*boECmFtSf/vzchrpZJzTIsHN4P6D//w//U9QbVHDKceXsQp1TUdXdoSbhU2Y*)
(*oB6hRlB2VQzvVg2vmdZrCenvp1miDA20s0w7jamWn5FehQ0gYBYTr62Z1wux*)
(*6tSn7avhf/yspK4uAscgfwWKqahfZ5MH8LioIfsxZvGRp/cbcRabKnTztVKa*)
(*5rZzac7KLemEeyQwLr+zLyNjKSQ28d3CAj+W8dyuTzE9kjpCOTKLhBqt3Yk2*)
(*92/su8ISWsrqPqK2SqnNPPMEha0TVwd9NXT0RTTmHKnrpL6/9823UgV5gPIv*)
(*UKdXEqWhCje3+ZvoEuKmlkBAsfU4obBbUv/oW2wKplVwmuK0KNX+X/8E2zGu*)
(*wvZtGXkW6t/Xd7EDuxyql7aT9fPgQ4oWHNzR27k0sbVk+q20j4yxcJixJFme*)
(*Zelf/C826nY94RpVuN0wYqmhm9Ekt8TKsUMDEXpDrZlDT4Jb39ZkvVCXZpGx*)
(*JjJd4hUfJGlR/9STCABflz/MEKEhZgFtP62pCungLJ/uuWZqNgjT6MMsdYh1*)
(*QNN3gPqD166JjYMVfoCjNLYZkmLk3HnxxCg0jQOv8eAs2Ey/aaQpfIo2cvS4*)
(*bOo8hJHe22fnzlNjnZLmvB7tFjrU8fQl/U/+7HduDChzx0/yhpMIHHJpaC4N*)
(*+ZAXL7HI0je46JCWOiTmHzddHcLOLSw6IF9Cc6uuJ1H06fcNqX/yL3/3tgX7*)
(*X/wr/D0NC9s4GUWVvrNadXpVLGfVbny+5G6kwgRhReXQV9BZHCnyUJjMGyZF*)
(*tXRITiHxbchYmKxcN0w2WWO5sIKhoDRCfy2D1VtNm3T/FUxP95nFRx7up21s*)
(*FXVuGEus0MalOSu3DbnNvRueuHtnW6ZJEkGqohXEaYqwL7Bc2VHedpNlhhrw*)
(*Qb9QcgFn3fS5LfMk9lVsX9I0q7qRzHeYDBO1QUL9cnhs4FwujH1NTILmzU2K*)
(*cLxa/+aPfpvFdqsgjyDwQtfX3J6JCEAyqdh6xXxcY0PAnfU4pbA/W5P6L/75*)
(*Xl//x182GV9hh3KejzFzLUju2l2aojGu6YFZrNpFg5oSVlmgkJSPrfYtv6hO*)
(*1Y9dsWQo6d5PMix1ENAbhxbarE/sKAOO3HVvqTUvNEojSvx4W5OFAaY5M8xx*)
(*p8cqMBXVyU+S9O97oQDwdfkDDdEkRSom6Tj2KcrOIqOTTPd8M8UYBAW7vpQI*)
(*aGEF4lwgidKSB0+bPQFKZMWWAD7lNQQJYU2EeoWPuJ+sGVXj0A9jH4N46fLm*)
(*a0KnIsPbPfPGX5vayIjhf4LBUrHPPOJ2mZhc5XkEjrk0L/jQB9swXVlWdn0O*)
(*3he0nBtTUDBEkBErkFn2Qz/9V0fwqF9+jxGjHn6fgSiAn7QhdYynIMMv0Oox*)
(*L7pxWCOML1W6OoOQu2rDfNVnOP95uuyXS95WyxDiLVawHWArqB7B527WitcY*)
(*c0gZXdZQtSXLIus9Bm1opDgtrcD1aHATIv1+9J7LLAnycP/NhOZ67axWaCys*)
(*S3NSbHo2iVExJQuN43cCnXWi8A3y3hUroX8lYQfI5tqJxO5lI9ppYjae8Hyn*)
(*UGrjkCMQ4ZkKS7Z75nVr66D5CFFerCCPIYBWu7d7HXKrxGVdhnn9KLEe09Vp*)
(*hd2QuokUGNo0tVVFgQ75yhQWdrQtsqnXufi99upSO3TSZPFaZ2AZtNK+LkNL*)
(*dZWegIux3vpYOIZ1ghlcEm3aDe3NtIZ8HN8vagD6DiZrmcoXmi5ZKEdJKheA*)
(*jS63v/hIQwR6Sqf1zqJesWi6l5spIjAqaZheR+BMAgGHybvSg8NZym8AOPS0*)
(*sB4uaaiCmLhp+F0OZ4imxY8CCyBFVRRdnt8ldiq6FEwHnt97f2ltT5R9nveh*)
(*tZnqpOcROOzSYKizgJVyHEObJ0dq1sYSi4+adsRGKRgd8i9Fi/7hO/O2ihKj*)
(*Cge0FMmW1P5mH3ODcL9yafAWw2Jgu4y9lGSPDHWepEXb1pFHVjnz0gA7lhxe*)
(*gx/CZBHIKbn+6xqx4WhaC/8TYuR74idQOYENRLA8LDUekNthXsXflFjaX/DY*)
(*nauhYe991Tu7wr2eQf53IrH/ZL5KnllLxfC6gcvWIHjZCx/CX1HXAbG9gjyG*)
(*QOMoZDF4B/qaHk7EYMDUILQes1NxQmG3pEZ7Jeu0JZnCrg0pX9cOmSYSpSFp*)
(*J2NXGKtMv9WrWFl6of7A2pSRP8El0abd0N5Ua+AAoC/eInl7k0VzaTLYuxyL*)
(*QFeWdOujJL0jAGtd/mBDhH3UG656kFbtMAyUDnx6ys3UvKKEc+4FiZjjqGOX*)
(*fPipcK5Ls+IRvoRFR1ifynGUyRWOwmF3rkPUjlv+I32O5H9yv9PTCByzG31T*)
(*L4vhPvVpWBs7/DtXgbDSyxKcyhHt3gaLBY/7TSmp9whzXJrNXKauDZTAc+gT*)
(*F/c3NP04sFj7IOe1uYSFz7g0JxATv+Q+8js5geiQjqKm7Ecfkls0DIjHH9oo*)
(*uXPnClXAh7UVQ+ED5j1HJPZfOyoGT1ZYnHw4YTkt55LJttHlm1BBiv48AmOE*)
(*rKYlLwfS1ovJ7uvUoruOeEdSaD16CDSdUliu93jSpblrV+/DLpemSlNm1lq9*)
(*CmIvE9LYmhLJhHlH6tJsh/Z2WjPi+JgZyVfxb22ydunBQ5XkDfdZCUlPCcCH*)
(*G6KCyQpQzaDlILmlp8hMvdCTwni3rpyXFk4+uVb6TY8+9gTMQdWD4NI6/78J*)
(*PHnmp1Su8NY22sMzFCb+tn2kSyzQxPMIHLIbXWazqfjopQk2g3hZJLDY2sQ6*)
(*7Pro7ImbNg2i76DwiBovp0xfytAJ8ZLkMZeGCOjG7Bz1HGCamHwwhNDIRpvv*)
(*ybPq8JctO3g7l0aC/O5sDvMh9qMPyS0CCDgfqcpy784VqpjmN8WeI7rEVgC2*)
(*B12aI2LwdIVNYA1iocj7XIVMqCDnLQZegN8tjNk5qrE+O1Y76mzJhdZjmkpP*)
(*K6yU1JvBLpdUYd/OpVnD9lUp2XszIGGH7tFsOQVSx7o07NDeSmtwCFf35dbg*)
(*HUwW/8ST6FkRSU8JwMcaIlRjvB+HpvBMmufsFzskl+HIzRRcw5Z3MFFSD1uc*)
(*HKVoho4Q+NAYDWVu3KG8n36gY9wFSImzyuT0onCTEUvf3XkyuRpjmkXHcGF7*)
(*OBc2FCb3+zwCh+xGX7i3m92sfsL76XijkNiBRQ5hS9GsxoFsU+keWTH1yPJE*)
(*zW8gR1yhtcJGlPlMhrMlNUQmFxsLe7g0qkySDOnh301weFht9FM8d7aCFFJz*)
(*gL4Q8sW5dqgICERx9/LckFNgxrxHDHwUHEPebjypDCaHXRqeqMiQ3248QVzU*)
(*jpsNNR6SW3zb2iKNQ1tV/ODvPT+Et+hjMAdbZ2HMdyKxA2b26bt+s/HEUvv5*)
(*Cou317FtX87eihXkHAKQUrhkQ/elrVsFhw69p9ysZKWvOd4UW7k0O+tBs47P*)
(*KOyW1EgB11OSTGGBlXMEfs3ZlUhIRAu/ttCpOeLBWvvG2pmwd5OmqYqyYnOx*)
(*IJtinvThxAEZzm5oT9Kasa2rZu5L0qOkWc1bjtuXkW0G5fYV72Gy5o2nAy6N*)
(*mKRHBGAWxY81RH1m33QSoqzxmn21hhJO93wzBZDQCCku7zMfRbRWyvkRAP6t*)
(*bqNIn1f+GryzkKzCWrwCUnG1rdalMV5VN3DJ+eVsBR9IwszNYQrZsTDWkJbG*)
(*5omRwDVJq+shyx1uOIsAQV6+C0k3LNyiQaIwObKQ3Q2hUfJXxYLvlHjeNCOE*)
(*DrjEgI5h4pAf3vWYT4VPP9sWDp86KY/Uv4lw/hhLnAwwNr0koQfuJltrOUk9*)
(*EFpRy0YuSQrBhIyL0Yx3Q4XF6c1ww9ClTR9U5aZM74Hsgpk+hFxJi5ZGJEap*)
(*mElZZfRMhI4xkdN5gwlYJPVutQS+qEiRx6LjROWIJkBMDboxDecZVbI5clBs*)
(*cDkU1fCTohv6MkZv2MWxQaPld+5fDIYOExZeBecFoC1Cl5u3uXbcsBeJLcAG*)
(*iqK7jj4ttP4Rz1OKGQ0stYm8PV1hyRqENWsSBTmMwJjTo4WapqkI4OQFN82A*)
(*MMKNCzxVjvT0uoVPD0msx3mFXZP6N1UICsiSRqyw3xNWkkmTkI7mYLCqx4oW*)
(*jyckB0Nkx1baBxttiqoZuMg/qvPvTKRqGeaqXpwE9MTktKx2/JQ3tCdoDTkp*)
(*gBeMI03gv6mUx5jJvLOQ72CyOuLHLumvD5FUJgB78/6Rhgj0lHhTcPQPebCd*)
(*eLqXmCmKKN2SAxGHA8K6X7x8NHTkzMI0q/8Ve57Pcl0m/U5LJv72paMtP7mJ*)
(*bD+0XJ07npjOzcRuTWS6WEd9OZxLs/jMbC5MfRiBoQxWZyLC3Vpg/t5k6GhE*)
(*cQY7zMlKjmglRgRe5eezZZlWGcszujvnABQBc87UCmcxYEj9rwPmjJUREDGY*)
(*VojzgWQ3TkF/LTesfrr8jtzrLFguVSsMZlvNSa1ctlCnlUYMd2px9Sv20Ijl*)
(*B+ZyqQRlP9bJwn1yHlYxnWDXmKX19flJ5ZvoD5aXalbgLfKkiEvcS0RFgDz6*)
(*e50yX55+tQmdu8JnKdsfFZthfZhVCzJ2iqGWBMUH5HeuYGwYxk23mhifsVmd*)
(*sNMcbNc7rkjsoKUKov/l337DUttjTvZrDrbVz1bYFqXR6KwZlivIEQTYN7Bg*)
(*J1yqTpPaNGWsz8hqdk4Wz1LrcVphF1L/+Md/zHzPmJeuAoX90f/23y5sd+I8*)
(*tJZLyw8dRnD94leMaG1pE5qs+Eyu2oaAK+1DExOOLO0BbxQOcHAbD9JNsTap*)
(*uvWn3u9zh/Z6rSHZF8il4XRDwCjbXB6/qcmapoYVTVV7fZT+FElFAvBn7m/z*)
(*dPkDDVEdUoTw/3WvHvs70z3fTLHQWAgTqi4oMfgWi1dj7wpD3x9uW9y1EzTd*)
(*keoDd6GJbtsGAWRDIWv7tkF9i/doPRMBtAXUwqsG9MGqqupuZ7F1L+v7tq5r*)
(*TnPnoWtQaYNtAHPE93OwvEvqAY2vw/fg/c9HBrVDpus6GpDtusO1voeZBTOV*)
(*3h+kyI8dQpHHlx0cEJvpbahKRdNyDk/jPtqzNErvPAaogTaCR/adT6jrM/Vl*)
(*RCdP1wG3+wryZIUdW9C1cRLOBqlry6refetxVmHvk/r1CrsSrVcBjpJZZTcM*)
(*k9ZgstdlZjEFjiYMCVnG7khT+FdqTdcc0k3OSz+NybpL0rMC8GGGaBynIWDy*)
(*nLA5cjM1DZ0dR/cKe/hFw9BVaZrVbY28RGOTHS0rdP/+MIhyVC644IcCQ5Wn*)
(*WVHXuKDu5sjGJ1OQz2U93htwPEExo9X0gzNYvDdqEPnVw0XSCw5A7iyRve0G*)
(*8VjbvFLwHwU1LnegWPGnwOaCC94f+myJPu+StT6Xgnwy6/HeQIoC3XA6h+26*)
(*roXL+LMZuRecg4ukFxyABhf/VFQj2nQJ6zK0d6coOHXs4+1SjlNBFJytqFrR*)
(*D9JKXvCDh7F2UXaBYjjRZrfmcynIJ7MeHwJjVwaOpdFmEKphJ+UnSW74UuEi*)
(*6QUXXHDBBRdccMEFF1xwwQUXXHDBBRdccMEFF1xwwQUXXIBhbOrmjfahUVnm*)
(*9sva4x7Rsbf64NnMNyTdVw9DW9enTzQPdfVxPew/JTxExgt+cDCg9pz3a+zf*)
(*eUnbPHZG+3PD0DBn6p9CqPllcnvVf1rlRSfHz53+/hzQp4Gj4cZLT++k2Vep*)
(*Y0Kh6y8nV7zNmGpOalBIBPsNSffVQ1fGlq6elI0u8aB+GZ/gdexZlm1bpN4n*)
(*hvnCst13PaHT17lrqPobn3S+S8ZPQpO+SiY8UR9sRbX85FKXj4Dew8oTyFuE*)
(*Sp6vEhsXwFXu9zr5gqBLfBvXrlapVXktoZY3y+1VFp23ge8DY+6v+l0+y717*)
(*U+iqEhcnqiMPClse66d2Bposcizcfu2LUYEWnTVHHQfGFGo+2hxhewfSffXQ*)
(*ZKENRyOPy8ZQhy5Uy+UTHNqu6abteh740jfNnP7tOthLVUQdc54NY+3SeqFv*)
(*Lfl3yfgZaDJUwW0D4rLS7wRjW1ZfhJ1+HayG2eOOV2ryaIW/Og1tLEJfjj0/*)
(*AGBVVmb8tYRavVlir+LgtA18F4AeK6iKcgsNXjelcT8nNCaDZ4IqO7zNvAyt*)
(*JT4Zy0QADSxoK7c+DcN01wzg/Uj3tQP02z0pG6OkLWnuqEZYr14+d+VrY5U2*)
(*xXt76Ou6rXDxlneQfDkZPwNNUGds3a/RbsWQ07r3vEY/7wdNbN6sez3IvnzY*)
(*DXM8XJKXDw/p7OeHvVV5LaHEb17/+TPSEzw6Uruyr9Ig/AI8mhS1qlo6luIW*)
(*pW8zL+Pm0ernYpkQRrycXDfe3cL7ke5rhwH3pj+pzgNRNx7ByyiY58ldN/A+*)
(*jbL33HgajrYjf/WHpGT8BDTpXM1gmiPjvnukifYHQZuo99T8a4A3GOZOhL4O*)
(*6OWOxytAZq9eFnp+KlEkbpioofnng9anfalUXdc0uxwgOq3nbR1AaFrR42Ub*)
(*ccwD2kJc0fy0Fr54qANLI/dpig5ij4tL635Bm+fedGfevkdbjTRvRbV8bF3H*)
(*vkxDU1MMP8tD+K5iuAljePn4NBltiqpqqqLLklu60qMdKxXNSiAOM5T2RAzS*)
(*90yb/mkF+66Xb0M6MuSb7qUp3sFUbUSisc1tgtBNs/zlrV3pGqRtmma6xRwd*)
(*5Y4LpZ+VkWeh5nR9FztQF1P10vZlrD14j6IFeH45fqdwdDAWFXVtmziuUY4v*)
(*3Bhqf90udDaPwvHibpV0YPA//a7x4dreOnF13TAnMHQLupp2uW1Mv+j6733z*)
(*7UOCdwoBHoi14CEynkNprF0DKDKRwIb2hUWISGJo+p/+9behayqKmZYZsEZR*)
(*zYSJW0pYJoESN4aURGn2utw3pRQTMWt2ytLm/o3eidT8R9/ytI/HlLtwUpGf*)
(*OMwypg2fFc2N0Fy0HWZYdnURIKVGutMwimBjRRjKEP0y6QWxe/xvLSIklZzg*)
(*XuMAGOntZhYtnTWQ5VxGWsbe3OTa9Gjy1Z7C//2ff5dG0wuMoOyqGFitGl6D*)
(*lB0yYlArXWqzRGxduTQsoUSckrPjuL2i7dLihOSuKICVzFJZ3GbQFIYmCVzL*)
(*cuK8SCM/kHat5eBTRoY2jwkJDubsYXbYH1FRfGwz9P2J28pEyCxH7VtwqAHE*)
(*yrKgJ6kWAG4pauSqx2VT5yEMSrS8KpAEoVZffZ0ac2RmyPWZFDZJvIXu6mDZ*)
(*rKgc+goagk5WDpqVz0DLNy4NZfj4DLmKXzWOfYqqm4r97aHAxU/tvGlr6mX5*)
(*RYfIkiSRh7upG16SJEWze8XbkK4M9g1rnY5s2MVNV4ewH6t66GHY3NTcqutJ*)
(*DB9+F41rKGcdxrpl2exUuFya1feH7xyFoysDk3nFbeI4YELmr7HCJsBI626y*)
(*P/AUmWFF40UJrqhj8qQ13TA5WuShx1yasa8JuzSPeoID3jrUv/mj335E8E4i*)
(*wOE+VwseJuNpmox1Sppie7Sl71DHiCJ/8me/w6XITHwxy6QA61ajEq0B97rc*)
(*FnyjQDERsoanLD8r8yT2VWya0zT7i3/+u7ctOBmPKXcHdk6RnzfMDGduuZPr*)
(*0+Ym/b1dD7P61f9lMG8bhzYiqqTQNtwD6k+q2KX0W4wIiSXHS+/Ma0Oxkm/N*)
(*hCzZm+bDgwWeBewob7vJ4cF/0lHyFY/CbIdtxXJs1tGfL40QzexcXcMfZFya*)
(*oWAJxRdIKYlO2SumJb2izi3TvVxiqdL9xDTTtYpwV3A7DMlrFfvc7mpbptM0*)
(*CCS3gjhNEYHOsOPdNve3UCIWLo3eYF42wRt8acBgTqI+NjH6ParGoR/GPgZB*)
(*1EOexOIsccXC3srkDVsKJNaCS6NYIDtNghIMdL9E8Wf0B70i+OiL1uTADi3D*)
(*Obgp6X8uw+cf8SMU/85actc3MCZo2lZi2o+9wQkPN8WBatfbZIN3Ih3qTq7A*)
(*GPuxq4qibrFamGU/9NN/dQTi4pff4/dQn7/PQLyK4c64cmz0Jq0E+sCKzl5d*)
(*akCxg3dKRgcbLtMaiHAcY6JjkkKq6jw7NHiQYB4F4x0macDGxqf8rK1j+dhC*)
(*j6LPsJWZ102tgyweWmE9IHgS033MpRFqwUNkfJAmMCfOh7Pa1EYuB/6nhQeq*)
(*ukiXxyYFimD9FbNMCmMVIgGLhTGunq/LQkzErBkFyjI9j3bDFzXfat+vREy5*)
(*D0cVeXjaMJvoxjjeuYNV1Mev3QxzMtHs9grpZKTRPInWpp2mJdK+ESGx5NyF*)
(*AQIZ1spyYmY1yC9SrGSmKYRC7LTlUbgjGq3aIHp95t7gsl8uMcJCXdttPK0I*)
(*xeWUkEQn7RV1aSxoDJt5xmxzJJaKD22KeK+TxPsY+x4Pbe8Ca3Sy8XSWHR8E*)
(*2CoudIZL6q4T/k6M63IsHmjBoMCiATVT0X0efyYTB8sK1QnSdlJgIAjeeJrV*)
(*ik0wGOo8SYu2rSE2ctsuBKgmEtVTJ9UT4oMF7IZ70qRVOwwiu9o4GwEbS/xt*)
(*MqEfmYbegHSILvoq44j4Egp+mvxL0aJ/+M7E9mt+CSqfgOoG3BnXGkkwRFuc*)
(*8zN3ykbXZQKO18Rq0ZczfxKMtxpgKmfN8sFdbwkrM7x0gndiHNR8xf0zgvcQ*)
(*AiyItOAhMj5Kky6F6R6/s5/W9lQUiRM7f6vC6zLVSSUsk6KABVWXHnfi67IQ*)
(*EyFrQAU4ykKM0qJuW+0TM+UuHFTkiUpPGuZ3IcJwCSJNE8tcBWUzzJ3uwPoF*)
(*3CEsGybMlxJp34qQUHLuA9e2TPYK+0WrPu8VHiMN+2+ZtZliNorTH5hx9i7N*)
(*6pLHKRGJfnrSXhH0lvvBYSB+pshS8aADN4w6qD1xSx7ZB1rhfJodHwTceXnP*)
(*UJD5sD5Wcq7NVxVdQFrWarXWiD5x8W6J6ceBdePENll8kNpK8CmYWL1qBvwe*)
(*Y+BCrwSMvNzHPv3DLs0rSUe0cv4u+OdGxMefsdIHx3UQ5+eMTsRxgqQ57zgw*)
(*fxKMl1pdM5xXfk9waV66BOzwtO5KJqmhC5DHBO8RBNY3crXgETK+AiUcRZ98*)
(*jeqlQwY8JvqzpXafO1jQ/F7MMjGMEdJR627KDU+XhZikItaIlOVl79KstQ8/*)
(*zGfKXTioyM8bJoTsXK4+3HNpYOsQPJnYuKk+yR6USPtehASScx/ktoWdQ4cC*)
(*5wWBJ7xnFo+bp2acOy4Nj1MiEp21V3ubAzkrJBlJYKlE79H92a/DW66GLIws*)
(*hhXOp9nxQXBw5qojHNNebcQ0gRdz+TP2/TgNN/boliB2EYUCBvbt5mVIB2DH*)
(*R+rSyPDpuqbpx6EpPJOmAvrFyx4GmA5URu+W1QHv0+9Euq1WjjWOPy8r8Rfk*)
(*LQfRd+kO/5cydELO76txPd2lkY3uzlysprO5ZlIN+eMtiS+hLqWonuHSoKP3*)
(*2A5bKLA4F9R6QPBeHaURasEjZLwHsjthdlN0y1CYDbUttbvEussy0dfxqvx+*)
(*XvfI12UhJkLWcJQdK8uE4cYOb6d+MVPuwkFFLvtnDfPv8Ma3YjOT3VA6Nu6Q*)
(*vp1u9rozhDgQafmT0Vbnk7oSaeeIEF9y7oPItoCTxo4I5lCNOW/CidLcd2kk*)
(*bJW5NFxOiUiUnrRXEpsDwLVUPGIiMZi3ffGx3JsZNaL7pbCfEc6w44MAKBB3*)
(*2BEZqHTt9hegTsuNSQArfP1mxLxX9q5yC+GuoXLn+XQdFdxaZloWA2r7oPDp*)
(*0P+GH4tDy1IRPn1m33SyFKoTR2zhybp78WZfwObYBPHifpWANyAdCd8xQ4YU*)
(*SrRL3cA6oEcpSVHzG/DhFVqpbET5eNPX74wLfZq6N/PlHufjd8pG12Uq49Uz*)
(*Oks2YWckh4XRovGOkHw1rTeojg8QX717wLDP5z10HuANYjzjLRmtgiCwTPBk*)
(*CJC3SZVdrAXjI2S8A1KazBvH7PRNOU5NaYvZgRehQpZxP12gDRQtW15c2rrF*)
(*jYoLdFmIiZg1vUBZVna47/qt9kmYMv2xqYpSMMiX44o8PmuYNBlDoWf1h4mP*)
(*KiCwGSZvel3SU814aQcglnaeVHMl5x6h6MbT3ougX182TcB/sCBTcEvh3d7H*)
(*UHBmHE8244xSl4bLKRGJztqrrc2BzW7FXnwRnqXaAbim5CtNTBKLk6ouK+S/*)
(*1alvGqZh2GGSJGl513aywz/Njg8CWPzqNgrDeeWvwRELiRPYYhcPnPaWHg68*)
(*qbqBi2GLMgBxejDVXFK8ZSC5VYoZkVdjQcJ78TDn3gw3DF2SOK2oyk1xfwla*)
(*RjONS7xzZ0awzcvHBwSDSBccMRAQuYegGbIAaHgQUXRSspCrQoSUKs0SfwPS*)
(*TT5giAtyu/OCssucG316EkYsU+ggVUtUBv1sW1j8ETHl45qWJ+j1DplRiAkK*)
(*Snb7Xo0R547fKRxdh/PxFItYSMJxTNIqJIw2/aSqUpM+7/jprwXjpUlBSIaS*)
(*sspojr1uOUktWxHCOoUl6RrI0Kx4MR79ecGTIEAHLowVYxBqwc8fIqN8jSyn*)
(*yVhDpp/FJCASV5mki/dwUIXcIBLR/YtzeoxR0zQVARwM5GciCXRZgomQNSJl*)
(*IftBiu46+oTGb7baJ2RKRyI/Qk/1uCI/b5gNPUh8MywoRksLga6HOVDrFK8c*)
(*DVwvne5Qzz8KtRvkcL0DwpGce4RaG5OX2XImiHA9Tt2dNB4fvu7wMS560mFP*)
(*YfJ1ldTBJpd0z4UxR2K2bimzuhRwSkCik/YKVhk3zSm76VtdhI2Svzpex7FU*)
(*OxhjbLcN2/McegpJ0SdhQBuCbTzhOHk7Pc6KceN7Lg05JAu8OM2Oj4KOHO64*)
(*6e5fsSexLNfVlystmXjal+QgGgZXeM69nzecQMO8tIEiYPRllsccsNOcZNmg*)
(*1NwkBsXX4qpnzrWRV5l+vnCBh89Yhwr7hO5Jsh6a1GMPK9sROD9jbDPnARUt*)
(*EBzbfDrp2tRl0DFmZ7iM7OVn3Z2DjkVgMUQNZ1kSjSthxuXEeWgtl5YfQkcH*)
(*gP/6v/ytg3cipeONjmz9U+QCbyEQXiwPqbv8Am9XNDNIK8l4xzpZCEtOtiqm*)
(*E3DqOgNMKsme7LypIW83pEWb0zrrlTwgeALoQ5OVJUvi+3C14M9ZUpwk4yto*)
(*0po3eliGDsSfSU+SIM2MqRIvYtmKFgxVWbATvokW6LIUEzFrBMrS0rfpP/7x*)
(*HzNIEe0TmaZ5pp4n0BX5zijyM4fZ5QxztTCfTcIyzLT9lb/o77wEQ1Cjg0D2*)
(*dkrifasr/MUErFpa7CRHSigI6c9g+QGThKmgNJKx8QzmDs0pej6FxyZmhu7m*)
(*WbBcqlYYMOZID/6Oz9ZfBsu3pq//fEMo4eQiYMc5ezXUvsXMGxP7ii0r9pZq*)
(*D01KR6o4ZVuC0OtuOhKbjBO/uwQlGEvfs6LnhI2JuXyYHR8MQ98fbqjatRM0*)
(*nRTnYRjGcejapq6b7tiLx77rOhqh6zo4JEWrD2U96lFac7u+cvCZvt2jBtqH*)
(*OocOqDv4BA92lH026cQf6iY0m2ZrFUZMGc5LXzmu8/DA6CYRoWwd27bb/I07*)
(*3hfU/hexdsRjf5CYK8AnfNfhuAcF7/Wo8LTgLsjI+Big48CbZi7k3ETW9jP9*)
(*93gIWPYK4OjyfUxErBEpi1yHRUyZVL8IUSrtORHgUumZwxzR/TWnZMl9UyXW*)
(*qKPSzpGcRwnFfh1s2VM7QT+ma5LJRUCic/ZqRHZboF88S8UFNPVSOzD9e/kq*)
(*Tugy/Dic1rZ0u+QBeAt2/EBgOJKEcMEFj8BQ5WlW1DWurbo5sPDDFLyhq9I0*)
(*q9sahRyNaG1Ut6kdHwefBZMB14qR1NV5HXyWYR4BqeS8NaG+epBZqpNvKkxF*)
(*DydW5TRQ9P3/G0fpv/1i+h188VDjo/2K9RGllS/4uqHPlvipFW90+ocpeLmz*)
(*hNnjTTrnCDVw1EiatvQe8EkwwcmQ7r1eGI/DJxnmMZBJzlsT6qsHqaU6B2i/*)
(*aQEzLH8BxRRkyTkXPA1ynDag4AxC1Xo8SnbBBRwYaxdtlCuGE212Sn6wgtck*)
(*KK9BUY2oXJOky9D+uYJKiH3wJPt5MHlT+NKGKZScC14PYkt1FqrIMnCa0zi+*)
(*DE2s4bT80jes5N8+BdMLLrjgggsuuOCCd4AUBf40xw/jyDc1zcvaXyT/k+HE*)
(*3380YhdccMEFF1xwwQVnoEc9uT3P86OSm4B8wQUXXHDBBRdccMEPGIa2rt/p*)
(*CNjQVFV79ITe+8GAOuftt0bHDg5gjpJfLvjioK/nBoJvAOe0aehqcgT16aox*)
(*HBymQPhfCWNTN5846eStDdHQ1F/9wltAw0Wkz7zr/eagt4MPZPonnVhnyAPH*)
(*sglYlgfll7oihFJDmh3uSgKiM4YPVD/uytjScV3LpfnFG0JfoBJAqvsO3xpi*)
(*xzQsayaiZZqmZbt+kGRlu6uEAdUIV6062mzV67PoOL9c8GVBX0cuFD9Tsjcw*)
(*nye1acz9penef6j/s+epRpd4x4fJE/5XQZ8GjqY8i8iLIlt20Ij+ZBheeuKc*)
(*yFsaoi7xbVyGWT07/Doy1Xexw08BHg1XIq1CVdt78M5z0NvA40x/CrzjxPoQ*)
(*dAlbbPZ2wyWOcbN41YmrPLjN9cMp4Ersj/Qrb7IQSnW/T8tOqFqsvQvl+65N*)
(*/aXqtR8EvruU6zWDVXtf3PBFTRYXG1cjR7W7xxQqUdrx7pe3HUVXfaL91U+F*)
(*zMMwdgWVgfvtNR+AU9oEnRRQtdgWepv+O09TjaEOXSgIfmSYe+F/EIiQjHXk*)
(*QUHr5xC5b+vEo8Xs18dm+65JcGlwJy66/o75Y2X4DQ0REP+R4UO1f+Nup59P*)
(*Ansa7kR6W+WPC+88B70JPM70J33/HSfWBwAlQht+URY5gqzEhSebGJVS9pDX*)
(*gntwqN5CuQb1jj/akXYH0Pn03cRpHN4xGo0bpSFnj6men9CS9UbAVpgf2aAd*)
(*dASjUa8+DcO//Iv/efNLKqz7/xRozGMG4V3gUyHzShgPdgx/8O1HtQkcCVK6*)
(*ra/SIEzbZ6rGqWGOz4hYr4Qkwac5nkjkjNa4X6vty1j5qCj9ffy3MvyWhugR*)
(*GZv7U3xBZUnWNOSI9EGb8c5z0NvA2xqW+59/z4n1FOBojObGm3QNqDbm5nPb*)
(*Vp2SrkU1CO704JMBdfC+aHESwJDjLh3aJhhIzaMqUrmxChgHhv/LmwLpLvo5*)
(*1mufCplXw9uWgT2sTcQAvhlVBzK/vJeB3QhJ4enP/XrpL217vIzR2yHTVPfu*)
(*d95Xhjmdte/BGM07NvzuS58fHhfpr2IOeoDpPwhI7GXTSbOCufQj9A1HLddf*)
(*etRjWnHAlS8QHc3qrBQNtW8ynb0WcUK78BQD1fIzMPx9W0Ye6kdR9F1MOoqq*)
(*Xtq+jLVnwKa9FuAwUd+UoWsqipmWGUTiFNVMIKAxdkUSTLfDt+DOCfmirQML*)
(*4pR6zIQ+xrZwDLJTpJlukuVZlhan8jqpS7MVM/I7WfF1dRGgQWEvcShtXdNI*)
(*TzNt+qf1Z//H9hf81NjmNvl14pSPMhHGvkzDia66l6Z4T1m1oeDtmAeUr4rm*)
(*49Kd4uG3Pu1EpurT12x5W7SJleTx6dWaok+0JWgohp/lIXxXMdxkfg0Hcwpl*)
(*TNvYKpobTcZpi8y3Pwe0jbRITFpPtSsTS5tvs9O7aaEIw2jCeqJ/V8XAZNXw*)
(*JpGuE9JkdaIyNewcmawTV9cNcwJDt0K8bO9y25h+0adrqYiA5THiLDbx5rei*)
(*WQzCHE7dB6E28Undl5GhzR9BAlV8f0o1hEjWKZ34yZ/1uwZ2JfwgOerEl6LJ*)
(*A3iV7sT33sGR2AIZKT2f8Ddn/F9F5NxVVSekO8lqMlvGPtMURyIqHPTW1AaU*)
(*ytijLFRML4Eh32ME31o+Mru1qJCsn0Rglzat5CVonBeVIbYNqjpGVDWJYyK1*)
(*0fSA10NWCBtjvhfpu0uGk1oj+l0249wbQxE5s7lzgiTPszQroA2i0Eh2pUfR*)
(*nkwH86Ed04V3Cqa26t+4hDOTFbNJn9YQWTVDzp1xK89NFtDmpJqq6B+S3kNh*)
(*yALPtthuwaRZ8FhHyLx4xaTC6K8m6twxVuFt233+AIwVlnIjrbtpQtEYcSpx*)
(*g1grKoe+gvbVyIkiPc0p6JbNiuJyaVbfF0wH7LnbKWF0Se0R+tZQmOydmgkZ*)
(*YjeNNlMb8KtUp+onhi19w/VTjX5ELg0RP4IJxRnfNrZZkkR4714xvCRJil/8*)
(*fPtL05Ne9m7cdHUIaQuqlwWr0WNAxjZF6Rt6XDZ1HgKl3J/8jXD4EwLIIZou*)
(*FS+ehP1OE5ECuQBW2Q19nRpohZfPdN4wgfRI4mEOM0Lmokt30r02B/Tcv//Z*)
(*Cpmf/Mvf3Y/wr/8GEVmxy36oEhdGIZfIKrSYFyiWY7Ombb40wkokk2NfezoZ*)
(*FU2QGPByQE85HQLXrKf9dRV11jMy9XM4dXc/V6xNIlK3ZToJFOTvWkGcpsW3*)
(*Z1RDhGSN96Ynd7obpnUHQeTOrLoW/jJYfdm0iSHyCulbeBJbEPZME6xlkVMN*)
(*gRx/OUwujeIWkzhQhC2yjkMuDQlr8M3XDr3/m6U2hgL/Ykd5202OAR60HvT3*)
(*GMH/HMbprEszje6muNNrE2xqFZNJGZKg8ZCoDNN8SgTfnBYRFbZaTnxn5bSB*)
(*ck3DvUjfGfp5reH/PshmnDtDIAOfjEzHtPzGpkCEA3xOsfOmrXPSW9wn50TW*)
(*TJfcKZza/r5Oyeajl5HNx6GOFazUEu5seDHNeioWy3HsU1R6/ZMEjsYq9Uhg*)
(*gG4qlfNEoNrYi2nsOcm5r2PfdbzwSBInXkAtZgqydDA1BtTN/qZDL3ZQ2Nna*)
(*5Hi+mwiFrzpYzNurS9jfaQFLQGzELdLQS3HlZ9J/kFiSAfwKssqehqPc5sml*)
(*yxzMdpLvFGNN9+8pyhaELs0YweElMpvjwBdz27jKpdn/MmKamdMk3k//YW/z*)
(*BmurJsLvNaZZt6uKou5GnOlkRtU49MPYx2CD9HCQDh+H2Y9sjuDjKgrxe7vJ*)
(*IOKk5T4H1dAynK+ZuiQoVQwyzG9Ma8gcWz0Nc22DTIxJZ/gFWsnkRfsPyK9W*)
(*CE9LbaGqHPFMA0mGpVbmMoJNLu/IJLyB2YF1kBd0d8lPvFkT2va1mUHlU8wp*)
(*GYi1SUxqBMD9JcvroGoIkexzLMKzM1lbR5MVV8IPaNxUCwbU4P1u/cB+60ZI*)
(*wKUxV/hP4ifG/977kUvjIOJMizsaggpwnGKO0sjM1wa9FbUbNGso1rx3D9je*)
(*7LSV2ijJ5066NGOpk8+RVer07HpPXIbGaVF5WcLUpovMuhk90vJpLbEve5GW*)
(*wHmt+V6sTbIZRwwtnrPoASUsA1R9hDhgh1OZc51AO24KPr+zYvoouVM+tcG6*)
(*cl65t+n0oFHdoyfLCzD+VPU664MOYXGhLwMc2me2Voe+6+nY0aRjI5oRh9Aw*)
(*8Wp526dsCzWReZ52D3WepEXb1hE9YjDbBCyE2hxOxJSfL1luEvdmfj+sAlR8*)
(*RKtfawH3JUD/KsQbN/ROsBjBuZXE/SgNPfW2NUH9Vls3vxCPTpkWBbAumP6l*)
(*aFE1QFc4lXmwy/FkfcO3wr2qouhIdyTDB2ofMIljTCJoqhOk7aSBI4stnYlG*)
(*WNuqaSfEHAi+rMcnj4xWNdkgU/ibNIk+R5GraTESkVW95t1HfEBT8OI0dhl7*)
(*2R+TSciJgqewGKtHZnBieKkotYkNFkbCKTFItEksJAsaQpETyYYIyZ9im8k4*)
(*4cdn1fWda0bspi0hbIXEO4f/XTRnl+aFnqyhiOXzxtNd88WlNp41Vn3eWeMj*)
(*UVLx5865NDChR2XT1HXbZNwZWYLGWVGhfIa/oj3YQ1juYGckj4/6Aa35tVib*)
(*ZDOOEMYS84ymWY4FPvYHazERDj93NsuE1UvY4TeSO+9MbTiZlhKn99XVbCKC*)
(*fu2iA2MVw0mrdvhcacM4x0/lTBB9AZ3NEbZ4irlhDUAHfBR5qjCs5pj0m7Vk*)
(*kgNBiunHgSWxCetLlps7W51j+4Md4I0WiF9CzhxN7GyBDnhKPl06Q+jStNCr*)
(*lkrLSZcG4gNGxP2itn4QolvcHvSS4R92aVCkZFUtBzKa+Nbm5mWJCHNYN7m8*)
(*T0pZj99exThwq/pxhDwsnsRuARNq0db15UGZfOkSUP9J9pPJTlhHkuT5vJ6W*)
(*/D8Rc0r8MrE2SYREjMZd1RCJE/xuhpXo/ZIxrAPmEkbI4KB9kKiDHFiXBl3S*)
(*jS0n8DRtXvQdNV/suAAl1qUZsHWFKJBEScWfO+XStDR9bQMWGzo5bCuOk3og*)
(*fqEePDbnPe7SPKA1Mm2SzThiGCDdxMHBMchPxjU6xN8iaK9Wc2BXce4Hg4b0*)
(*zrtTG94unNhSvXTIOYl3Reg4JNhYD2YHWTWDAy94P8CZErsE+LEyEccKeg+N*)
(*qUKajTxhnlBbTTnaTbLuvQyHQDHlX+/SdMkcVDzh0kyQkniiYa4iq2dA4NLA*)
(*wvxGfcLTLs1YY9R0dmOoTYNoEuzNTE3zutdHpZrAi+XW8oRL0/fjZINjj9pF*)
(*FH8QWptOiDnsFKz84aF0bNT5Wu7SQJbXTfdAQ9GHDrs02n2XRiaTLyidHqu/*)
(*hTypYx7vltfzClHCKfHLxNokERIeGgdVQ4RkiucvplDbJ3VpHiEyho1Lg/Z9*)
(*5vwHBeTthPlixwXOPCv54NIwf+UqqeRzJ1wa/C0laVc/gbvmMAe7HnBp5KTu*)
(*yN409i2iuzsbHHi1S3NGa/6ffyPWJtmMI4MuIRbThBg22WwV4vAdFNtRGR+D*)
(*DZcxaAy59M57UxvO5EFZaJOEH9iTfVnzYuyaph+HpvBoTu7sKnwIDB1bfR/t*)
(*F+g7fNCErCx+C4g0otURl4buFM+vJSYdJR5jRtAoLkR3cXowQgm2G+ZdObL7*)
(*wNl42h6SBf8B1o+E8nRBBCFTvksz1o4y8Shpmqooq2611BjbujrUk4AYh1VS*)
(*ykCz0Rgjtp/mtnUS1r/ACVk0j5Ndvh75TlEzwhdZM0J8cibjC5EOB3slwwcH*)
(*I+6wyyKT6d5VbmFDBuZSrelnnhIApk/LIiHmtCyGEhDFHmJLUfEbNsisWU8W*)
(*gw7Z+8flwiAiJ691stmhwxWEthtPk5xIZRKPLKanWQ4k8Cx0XjaeIA5sx42E*)
(*U2IQa5NESBY0dpPsPdUQIdkQL92gjwyQIXMgsWG78aQyaJxxadZCMq+zjuF/*)
(*//0oPXiDRk0O82iY9XLztUaPpTZFaREJcAagPoxQSWWfO+7SjKhIqhlvuERi*)
(*UPNZCamtOCsq+C4UiLCSdqggPVVdfKqxhxzAu6hvJPaMI/eA1nwv1ibZjCOB*)
(*Gt2mJVVTlWXVsMZDhMNvINLCzMjg/OD0D84kKLhTNrUBzOkER8vNsbzoM/um*)
(*R3SMzkH9fSMg04pqxnlVF7GBsdxEjWAPlE2Ygc04bzJeI9YyfBhKArjUMALT*)
(*T6oqJSEqVXf88L8Cs+iGIa1Hp6gKdp9IPi1dOBCa0x1A2HxU40XAaCJxDzn5*)
(*JIjaYcWnmXjsUy+0eCZRLggeKqpmmKaFwXbcuMBBQjL52ncrUvUlUdggr7sJ*)
(*miqmu97ro6nk0zNV4UiOai+7sZtfIMULXm6Ak4/jt0MVQvoTw7UlsKzqhkHC*)
(*j4N8+OAn6DZigyfLIMLpwVT1SPENarHntOESz9qQBCjCfLYzSAAsKOdJSpOt*)
(*kfkNkYSUDBEyAW6KEcZUsG7oKBG7xtwDSfKk7je5NMiSBIQcl4oFU8CVSfIm*)
(*EMXDBco6Fw/TiVB5tr7E39UhRi3ilAzE2pT+WkjqF3qKcJlKDquGAEmyWY92*)
(*QZKymg/f6ZaT1PIhrISfoTz+G8aKVQQRrIXk1xD5CEncjHwCi9MjRH6B6haQ*)
(*D8xChxfOJCooE5WNQq2pTQ7BKVDAv8PH/UjOp4QRks9t7YmQ9BnSUyfb7gy0*)
(*CWGmnRDDKUbjAVGp0T16CA+QIl2qDTtUBTnLft8zWdOQI9ISeEBrxIZLNuNI*)
(*0HehhINu0AnGdgNSQlv0Lcj3wOs+JCmwv0Mt4YrpkjslU9sMNAf+7ig4vADj*)
(*T/xYOLr1XuXUeJhl9IApKEu8nRV6dD7L2PifY4WUS9Gx0N7Xo0n4UqqD6AEg*)
(*vWYGabXswU1OZAxs1eKqS5ZOAjcnzkNrubT8EKqfA/jFr+ZDsjS3ysTnbl6a*)
(*ZJaT6bcf/SFzMNzyAyYhRAnoDs4egmogO913XJohsrgvUHTLTSuWrq2/4D8Z*)
(*4e9jZrCo3k7R7X5B2l5G9vKj7uIq4O7yCz7fQblWOgwublJBdEUy/DksrN+p*)
(*cd3PG07wAuh0M1cinX83/XwWiz3mBLqcYawW5i39eUbmXzOnHVH1EozCkszj*)
(*RIkLu8ikIA8fxiZmvuPmWbBcqlYYLHIyWZK/48vkYnCx/dePZ47XKcPw27pj*)
(*GodTd0GoTSJSr4Y/IWAGPz2lGgIkxzpZrAc5zaqYTiAt0bES/m+iP2DQsgJv*)
(*GZdi7NyJNTBC8ldsMQPLdRmbpqF6MieJPDYJwy89Wds3LOokVCIwX/0avWxt*)
(*iNDW6vQNz2BlwsEqfkdJBZ/7JaMjiqScCBy6B2BLIpO8juVvf+oI0fgn/+zf*)
(*lWHIIzUNQRAD1bjLDeiXgl670iXJhobf70T6nkN0WmvEv/eiGUcO1HlbA93o*)
(*EeHQ0JPIAHYE3kK3Z7rgzhfJ1MZg1+LckkO5Flte1OG8I4uR985nrj0XhrZp*)
(*mrbjh+2HOo54R7Jw7YU8y7hhLP5nurZGvU/RId+2XaR37Luuo8HrToCGDEhg*)
(*P2v7tkENWR8jJw4soHIrw4RPO0FTl5lF1/5dA5h/NAxdM2HWHIoNwii646l4*)
(*Q98fGOMwDOM4MRPRemY+uDS6l/X9zOWDmI8ttBo/h8zYtbTHziRA97rtnAWp*)
(*TI7odOqBMMLmlZhifCk6zSmxNsHfjgvJcRAgOcxKN/btqSE8AY5JLMADRMYw*)
(*7j/Qd4u0ykTlHnrdZHcRHErqvf+5TwPnSD1OJhflanpny52dh0e0hvP7QzPO*)
(*gKKaVlgi44lnmKaps2nSUdjzxWIcsKTcF3benfKpjQAqqfGKHjTTqPquOd8P*)
(*/QIePKPgPPZjJ4dzxY++MN5F0b4C+P/bu18lR7EojuM8Ee/AE/ACaHQsFofE*)
(*bOGora2oKBQKg0rVFAaxGASGnSoEAoNAZLn3QEK6O+l/1TPpqe+nRnRoSIhp*)
(*fnPvufeMT6e5/zxjXeTHsmkKWfr3kM8S4PsZdan5W6c8HsBHnjh6iMY8XD9N*)
(*qr1jWPHX/j/g7qNt7Os8PzZdo8Y53VcKSPCLTFKzp/bJ/8SbnPcINV3PD8PQ*)
(*k1at0YN2Gn000hHM9O7N/nxvw/EyqOs9ra4E8DGqMtOOPvPH+1f70BOnXidH*)
(*Tdv1gzAMlj2j3zJj9Sl3H23FZYrx1f3l8Ev0RzWjaKotnT6Zaqa+2geevW5w*)
(*bbl+Vj3U8vrHVegSCNNSHYwsL/lGf5zeYWpCVWBhukHyPXv8Afi0jz9xpirf*)
(*e86lMZUfZ18dZ5YPvv1oazNVvWVablLxVw0AAAAAAAAAAAD4443N2gDxhqmX*)
(*hcPUQwEAgEfUZ5FUkps3+5t3x6uuiyVlUQAA4ItNXVW/J3KMzSH0n/Uk3dId*)
(*sdU2+FMu21z6LNMGAABfq013hvfubVrv9DKTxmprB4ohPxzyu7u3AwAAfFaX*)
(*WR9pgCUtRV6ONJPuA/s7m2oBAICv0VeZt27/Yzl+3l72DqrStbGqaYdJOb1y*)
(*fKrSc18ucxdlkimaNFC9R103SGrd29FRr5xdUg2naajyw85S7QjbYi/XSsfq*)
(*rojXd7Id2/YOqp3W1BX+equ2F2+bbjV5bG8aZ81v8zTSjJU/v5G5eU9p3NZX*)
(*0W691PayddBmaKtDuDMMNy+z3ed3JwYAAF9qLNWQhulXw1hnuq2zHctD/agb*)
(*pIbzM74rpP9rWPR3jpex2kLWT4qub/bLZs/SHXU86l9ZoWoANI2dtJmer6rO*)
(*jWW1nb+TpBSVQ1cVWRpbOhvluW6OKV3Lw7Ttm4PUy1iR1NlIh1knyvuxT4Mb*)
(*reqn7phlSbTTG0NHWZaV7TB/fb3vrV+0XVMs3Znjsl+OXwvuNooFAAC/0VQf*)
(*1CM9lG6DlX3OCaov56ULYRHorhBxdft4qvZV9rL1jVvdBcPwc7Xx8lLBsnzK*)
(*8lKCkLQ7NCyv1Amk1a2CHJkYmkr7Mkk06diym6PXMP9rEokZcTWeBt05fU1i*)
(*c8DxzNsTT1e1NFOmTjXTdr1p/emGGchu0akenXHjUg0PFeWbW44DAIBfbyjU*)
(*eEXXFMkyRGJHcxaoVTtyNVqynDX1td7p5dbxLveN60bMcqaMzAzSpnmNNPJS*)
(*Is2pP25yy9rQWc7ULUSt5ape5rpM0zSkV8X8k2kn9Sg5ZFMeM9wpD76+kzZ4*)
(*En6mSg8b2bIAvIyd2yunAADAYxnq1NW1InGaqEELS0Ua3Ql9Th1PH+e3jhd6*)
(*NmobacYyPs893Ys0V7nl+sztrwaVfAw3eX7/8tG7Q33+Qm+NNDK8c3WmXGvE*)
(*ugW8/rJEGgAAvoFJZnCcSE+1jOqBvkQaKbHJLqeOVeAnP24et58cl0hjvzRK*)
(*I796Y6RZfp4aT99osSnR7fJ9Ug0SaazgvL3MmyPNKJHGSi8Nt5drl1EaIg0A*)
(*AN+E5IEgl8LXTpXG6KKU/378pWehzP0yxzSmnmlFpUSC58elPGaOHOUaOZpE*)
(*ZRBP16kMRbRNHfXBu0wV9UdrM7xza5Rm6Du9NFulr1ZqWoZiPpC0U5vpAhjD*)
(*XbPHqOOVXb5U+rINWucxGSc+T1pJcPKluGaZeNqEqGns6rqlpgYAgEfT6qJb*)
(*w3QP6WFd42NZanXPv/7aNcD1fFfVsZg6+LQ3jg+xjhzmbq9e9Xox1Fpne+pz*)
(*XQhjRWm2988rpt0gzn8e1TIr00slJ3R5oM7z9fZ6MtlkOmHgzEHr5zEw1jt0*)
(*d67Maqm4sRTAqM/Oqvq4X76H4wXZs2XXkqaW91cJKl4Tml60pVdgBbnc9Zjo*)
(*8uD15ekcgbxzPTEAAHgQQ3FueBQkWSjFJX6qokBfeNYaIgz7UKxP9lvHpzZy*)
(*L82TDDsoL1M2oyzc1sfDPNW5xfH++dvbnO/to8vKadPdD6dOYtIcT/JORZ4q*)
(*8S/nO+F5X5qpyZzLlcvWM7tgf70x8HS5B52oZKCpzaPNTRt+IiM2/X7zXdz9*)
(*stvwEmkyIg0AAA9o6rt+kHgwDetPy6866Vj97JIbx09923bKCwUo86+aVkeT*)
(*qW9fOuFFw3DdLnucr+3a9vkWMaO6Jf3+09D179oVb1zu+vXG3GPfNB0TTwAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/lf/BtWBg=*)
(*"], "Byte", ImageSize -> {500.1999999999999, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJztvc2r9c6W37chf0cGGXpgTTOMNQmYGAt7YIgRaWKwZu6rWSOICVGSgYzB*)
(*2Rl0i4CRoVEwqNtGuI2aENm0sJ1N3MJYwSghwogGdYMukUG/gQYanEj1oneV*)
(*tN/OeV6+H+79cR5tSVW1qmrVUtWqVf/J3/jVX/0b/9Hlcvnfuv//+e6P/u8P*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPi2KWNPVa28*)
(*Ha/UVTmlqvvffEMxvLhdPNzW5Zqqapb3vZ5ZJquOrYz0OW/zJLQ0WTaC92eK*)
(*0dZF6FryRfHz5uUvL2+Ooiiq6b/01U1662pYUu1kSMfR1S4dP3s+nbb49CoA*)
(*4DuirfMo8D3P84Moyav+ShHf8vq5l5aeqZpBPvy7minM4V/9H7/7q7/4q7//*)
(*v5f1i/VVV67nNOFadZxUJnUaebos6V76ULqP8Y5EX6iHN1lr/jWfJ8ymTH3b*)
(*kC5azNv+e8a7b4vY0S6XS2dfDWVsc/+yQPO7603mS93f6nVqsDWpKy/vZsiq*)
(*EaTV2zJe23sJT5D+h3+ojRmy35ebKak7pnmNX59mbNGSy7fnlPTAtMaVa8yu*)
(*1jeajGTdnnp7k35+FQDwHZEF1lJxKar8ZNer4r7fSUZcctVehsca8z/9rfx1*)
(*X0rPasK16jinTJrM21Bob+Zdib5KD2+xrfnnfKIwG1+XhqSG0e3l4923Rurp*)
(*XfEmn0sdbTCKgmEnrPxtEfYSkcxFVy0jpkZ0J8rzLPKs4RXXqHxL1ml/lHT/*)
(*lmRZnt1s1jUNr/tXliaBbZBm86/KsghMmXbbz6nGtq6K1JcfVj4rUs+5laPE*)
(*q9hVJEm1wtd9HTRlmbuk3icdrXSNPp3g2Qm9tqo+uwo+mUUFgW+Hb79q6tSh*)
(*w6wdZeRCm4VXpjxvj2qPJtWpop5cK0Kzv6ZZwS0t8pCqaMUKirLI0ttV6y/8*)
(*+S31/jBN9aQmXKuOc8qkX6PJHG2h0N7M+USb5Gr5pzXhq/Twdla2NP+cTxRm*)
(*12Dy2CUtUxlmw94w3m3wVYqiThzS58LZ1aI3jw0/qaqyKMrOhun+O80ctbgk*)
(*I5y/yl4YbPTl1DTL3lE48o0QDj27TVSqVSYzq4ktS2b/BVHdrp9uA5RX+UVm*)
(*WJsql4v1sEI+Teqo7+to1c36Yc2wz6ogcDffQ9XEV4V8UAbTi5nXfWXK0YMZ*)
(*r92+K8vh7Au4+77uPrlDpoyLgJphTsoGt8406BR/sqXen6N6UhOuVcdJZfJW*)
(*hfZMoqnT1fj122mU5/L8WcJs6FA+mmGfwZcpitwgn2B+MTWS2sDoe6cnWkxk*)
(*3cqdLFUPZtikr9V9WyO9JSjeYIc1iaG7Y0U1MTPDJu2kSb0rmehj2fvUFTFW*)
(*/KfNsK5GZGLfvn1h/K0dbaiCH84M+7wKAnfyfVRNYhPVpTrTXNa9UWQ+tpBQ*)
(*BAYxpYLFZf0iRbz7ZWy5cPxGriJDMqJN9f4cz2rCteo4qUyoYD/ZDDtMtM2J*)
(*b4/ifDuN8ozm/zxhtp9vhn2Zoigjk7TkmU3e8k8kZtEEyab9RL7ULhfNGzK9*)
(*aYZdue/W63r0Pltm2ADLHmn5SeAYeoe18ltr+p+0Ht28RtkppdGUiWMZqto9*)
(*o1+96cfrhvIp09A2dbW7WzeubjB3v2271HWt/832fMc0vLT+aArPYELUbD8K*)
(*gyjtFXNTZb5tGPZtXjttdvPN7hUk/2FSnMl/HpNHVNWwbFNdCLDpXmhoRjTO*)
(*hm5lkt9p6te83+7R/aETacxW8jc0Z1NGnk3ephnmNYin6yeHxdmrrCaPA1PT*)
(*/Lzt/vQ6cXcvt9y06ovQFLFjdbnrnvAWE/z79UiFQF5YJW73eJegHTCR7FTQ*)
(*JqzWnKRtMoe8JsxqYVmeEjgReh44V8MwTaNvcMlsVltYLpp2L5O+uXY/+L5j*)
(*mNNllHs7y1MF2a8dQi9YU6O/umFBa3a7amipzbhus7DLj/Zbf/vv/q9B2BGE*)
(*dEWiTcKAXAjDiM8TPdqoTkJnw3qTaOr/3Cnoa/TI6z5K6hGy/rRvqtGQIQNv*)
(*PwU3Vnhb041Va/V+jr0qZprQ7sRZ9fXYtzQnmPUToSp41gxz0q7aXZKuYTpx*)
(*sSjWA2q/7dpD36/6ejfcMJ32K3GiZeKxRinpfhgFAVsHEw4NSz3clL0m0cyu*)
(*7jqZu33j080gWWieg3IJNf+9wqyTKOR03YdbM3VGO1MQRAfLfU1OunBXfsMm*)
(*3kRTM2w13i17sWkPy2LCUt+hKD6Hxt2SfMIVwohqr6eymtQlv41z5ltmWG4w*)
(*k+5TzNozZpikGtrU7U0aR502p0XXTEvnMjD8TJxmTl04ZM0yud+oZPKvy6UZ*)
(*FtNvXklzPIfnwuS2RRsRL0TNcn2XudV1D1axLV2kaY6V3/4Da6iimQld0pfK*)
(*etepNF514i+XNqTvUgzHHSueCjCf+Axzfb6dyZujj49eh7/pBXto0EvNWd9o*)
(*fWmW41gqE3gw2FrC4uxUVh6Oedav86YsmWFoL/I2tMq9epwKQdHnHpNkl9ZG*)
(*BW3KvM3HWrtI484S1WtEDe8pgVfMK0Dq1KWusjzaUbGo3M1ykRqgXqCa6/sW*)
(*fXyYTL67szxVEGEv63dR0cxZ9pV3K7VTOOuq+c//1m+O/5CHX/6S+p+xS8T4*)
(*a2PvyqXVX3m4UZ1n6gJthfnxA+K3MeWsiPyZ6xstiBlufKyt1fsJtquYJkY1*)
(*oWoYM+U7rHseqIJnzbCLrC5GNSfhBXtE7VcuaWdS93Vi8r4zGSVFibLltil9*)
(*WxUMDUs93GmSUX0oi+HMz08OZyLN/4gweXIsnwFLqI/AwB0QBd6GbRHSpw27*)
(*+2gcs9ObDVPNSca7qUAmvVjrLT9hqc8rim0d/g6amGZzOVHcNnVV5unNnWrF*)
(*9WcRb04Wd7+fmGG0Z1Q+tzAv+qfEKDhjhvVN1Yiyskx9ZSZwuhSr8MXTxmP1*)
(*pIjWiouAVCrztWgzT2KNhe5nmZthLdvgw6Y96RjXt+GaZl7plXo0fTOvmoZ9*)
(*SybMQTW+RY4u09wPWigkGk5zmV8c32+ipfuiz8jujIvqsCJWTDNTAVZZHAX2*)
(*TJ3uZDKPb90H2dhYLDcMnKHr6LwXLDQn++LmM/Mh9blVnPq4OLuV9c/+bfdN*)
(*5g5JG25UNnXsGkPedCcs62q44lHVsF+PVAiD2jOcsKgK32Ry4sPcvII2acs4*)
(*4rXWy/zqWBqR/b8RNbxnBM7GWZmPZi3zar5cOl19plyJ3SfOPzLbfplLomb/*)
(*/Z3lmYKIe1lJZ+919vldsG1fmpuuq6ZMxybdZ4ANeVryH6gynHwtsvf0V+r8*)
(*oUZ1J6wzEsyjrz8xfLgUOWBUbEfVjqG1Uu/HiDTY4J1CpFeVAW9pVOBiVfDx*)
(*vBnW9zQrvN1cc2xcuVCTCNQ+NZlk7lDd5oHM22t7KtFOunRphmdeODQs9fBU*)
(*/1+ILZsWJd8EIV9PDWdizf+oMHkq0mwl3e/LJlxbbzPa9B1uityu6tg8VuPd*)
(*bi9uhKW+R1F8HkV4vHuliofvZDddLOEsbZ7RzukrYjQtZd19h1/YBmfMMHnc*)
(*N0RGGX4za/lqlKZJHCdJZ4YypSrw2aNff4oTpUn/UJpG7GOPjVZzM4zbvWwu*)
(*nm8oYL/W9FfZZRPLradIvElsLW5GMw9V5mxwMYbS5T7Nv7G7OYLv+56uF99o*)
(*iSY7Jeln7XEmeXHGD66CayeeyYXmpPK/8C9i6pxAx46D4hxUFutQ42c+13Lj*)
(*duA2mX6DHNTj+vEqokqBj9pnXV/qmG5/01homLY9KMsTAqdVKU93uA9f4nS8*)
(*OCoX1bqy4bFS5e5FJgPlA53liYIIa4ft6db9oWYz1lDYlXXVsCg3msMsfDKA*)
(*xEtflKWT8N2N6gESd7TEmP3T1lVV1ROa9lCZttyMEZko9DNn11QT6tJtTmiw*)
(*UVZMGU4N/m1VwN79pBmmuYOOu3Fbos/bAy25orEjlGiScEIzzCejDhJdOyqL*)
(*h4aeuR4e/Pomw1k0Vd3icp3S/PcL82MwdSYzmeSK5ok+K1hIE82bBAJYKNjl*)
(*eLfdi0WlLu9XFJ8BHxGO0q1Zf1R5eYcfaNdZm2GaEyW3KOgIo7T4RNvylG/Y*)
(*2G2nDoeDNCRZYshKhyyr3q5XW0UlcJGk2TOKrBg0ytyyZqs8TfOqbcrIHeeV*)
(*uZE2TlbL+vWWTytlo4UstNC6dP0re6W9Ky1eX2o8Kd/KCXNhSe5nkglfnXo4*)
(*MlXPN78vNWdbpUlaNW2ZRtbwcUd+FRfnqLK4I8o4pq6vTDexnq3H8fHlqH3a*)
(*DOMOimPOxGV5XOAsS4u+ELFt/rPPhL1ysdGQPuDdKm4APNJZHi+IuHbqrW/Y*)
(*vqUMAl6bYRuPbJhh21V8ulE9SGyPcuoMsaa4XY0hSpYk0yUYSbHcaF+xVmyW*)
(*U2Si0M1Zl/1wnUv1fswJDbbbg/ZVAXv+Sd+waTF5PjuL+oGWXMdUbc7dbPj8*)
(*FTXexIluZl40NEwEOFxZzqfdM5yd0/x3C5P8m+3v63ou/XfcNyOxSxJvabPX*)
(*LvvjSmIbvVhY6l/fryg+gy1Xrm3oBOaqgpZ6fh2w4rM5NRu2027Jr3fuAaES*)
(*UG67bqwbQ0DkUP0nXT06ET/+WkTXywRZd8vd9yyLwz4o7vFLyQOaE326anlg*)
(*hgkyuR7IeJCiIebehi7NI+oIIOm2Z49FEBfnqLJ2R96dK/fX45Nm2Go0ETS8*)
(*BwVepfpWX+DLCnQW4qhcbT4aBeS1blyeyfMrC1ILa6cZVnP2Gv6ZxnCHGXa6*)
(*UZ2liv0gnQ0NHje7+MDU9q8dPSpZiKeL7u2Uma8A7psoTUZdv1ZrHKuX3FXL*)
(*d2iw9Ti7owrYr6/cKckyI1u3B1pyyco4Ny340EMXysWJ7mReNDSsBfjMcHZO*)
(*829wWK6PSTBYs/dmyPV1OKwFLXMg16czZqfNsPWYuF2ERxTFZ8Ct+uN0GxJa*)
(*kC+hji/YM8M+uSAjT5th01Uw9soiy6u9GSUmgakrKX0oS9n0z7xmS+aywVZ5*)
(*mnW9t2Vijw6K/ckFW+/ZKA6Pnast1GqZRMnOBpVhRJ7qk0MzbDeTW4MpbTld*)
(*Fy0388zC7cpeQpf+nOFXcXGOKusxM+x8Pb7eDBM3vIcEnpvSTD1SuNfQtTxV*)
(*rg+y982epH3x8uahzvJwQcS1U9K5A3WhndoyCpOdviMwwybzA59lhkWGZC7W*)
(*v5qEDhm8G5LpgvmQTXdXTVZY+uPk+Jc9m14QmCh8EU0QzvERM+zjvAabi1eg*)
(*Clhu3mCGXW/VAy25CNgHwsynjg891q08THQr84dDwyNm2F65zmn+DQ7LRWiZ*)
(*Edl9RRCT9SBIwuao/YQZtlPqP71fUXwGQ2CKq3DG8IO75ThL37BkIb3v2wzj*)
(*Run8wKy6j2a46xs2HKU0+6wgU6Pm2jeMTZlKw9bIoa/RqaKbyrc9dh+G3CWP*)
(*7P44syg55n+6Cp9r64ob88kemXpB8GnnHTNMkMn1QNa3HH2WyVmeqyt1/+LD*)
(*azPRveLiHFXW3WbYXfVI8vo6M0xclscFPjhFm1PzhcencjcXzRfliq8qbxt1*)
(*ZDO3JdVJH+ksTxREWDvbv+a+xtzYThpLzK+pa128ZpaRi95khvW9QPMX48bC*)
(*BKqdpRnWad++s8hW7w9PN3LS5UqyQ40vDO3OjbNVy1VUsVkC9/uG3aPBZi1N*)
(*pArYu19ohnGHcDupH2jJDR/mZt8FXFy0/YgTHTOvMN+wg6HhY0OAzRPD2TnN*)
(*f7cwR2HwudZpGfcZvhomu/5X4VtPmWGiUv/J/YriU+ACnO+FqePA84Kx+tlO*)
(*UsFOyRtfW2DncXzhouRGFP0B1tQnbjksYB29uR3PKdOdqGratqYbxxRBOLds*)
(*OC5N0qOs+3xqi7jfgMkzwHxFqEC42znVSx9V6qtMXEXie+l/iOXpHqua+SjO*)
(*F4+6J3PPi5p1cbgLX39b2JsubZWRTmPtblEpQ76PQh9qLCJ7gycBtJlnjs23*)
(*c+5mkulVabJNrHHm3+ws8DXLMxssuM9hFdCN6opTlrH3j3xRcQ4qa73nZX1l*)
(*5lpwVI9s2nx8fNASzext0wrahPWRadhGcVmeEDizZHq/6GG8YKGi+AhyUK6k*)
(*a76qP+T0RtpGr4Qf6CxPFERcO5PdW1cSg63NSAQJk6m1ddVsbYniaxbcxaXm*)
(*u7wFm2EPGtVHndp9dEIrEpzNTcsuW7OZPn6A4KwIC3uD1pRsl/2GL9bsySxE*)
(*/zc3Ynf6PvejFu2CXKj3c2XZ12DM8NtpaUJVQEIfzFXHx+aVTdaWA5vOou7x*)
(*j6h95lY3sZqYVTxcOUh0YlQ0/Uqu98//5e+JhobmY6mHeXjeB4ezU5r/fmGO*)
(*1INX6WoSe4OQ7+DW+b54vo1RGkLLrYbvrV4sLPX9iuJzYJuMZku39Y1VkKS5*)
(*QejT1WrJXE8rcqNi+IZtYx4CqBPml5zfViYu20Gle6uFuIbv1u8aHv2tprFf*)
(*OmVFNQffizfj4GOQ77ZYPERV9zDfqDlxO/mM6sPNaMr8ES39hSjkbqAhiq6g*)
(*s/R81oJZ8pKiSHSevwnYMKHFfPJ8eoTuwGZQoIHbGJBFsT3fHgKMkMScpG5Y*)
(*LbMisFFjM5N8KrITWdZLuI3pti+2/kWqYJbncQ+7qusLcahuJi6OoLLakscg*)
(*cmMW4mC8wrr5EKamK9cd9cgfr3lL4zu/1hW0SROxjdhqOBnORA3vKYGXPJKP*)
(*5MZF37cdjT7OPL+OykUVl2YTb/C2oGqMehPd3VmeKYiwdmYHPY8MQ+Syan4p*)
(*IlYH16mmZUEU+yyaJg8axpB1/5f7G1UyruUae51w+HS9KFZMF9TzGzcAeTCB*)
(*bTOM2m/Xf0EGPElRlf5/cr9NrOxHMarawrWd1ZYe94FfLtBM75qr9zNlEVRx*)
(*w0M66OuW1gdJO1AFK9XxsXVlm/jKz8T24qppch45KuS79x9Q++WNu4LrbtGZ*)
(*9UVEW+AwlXqY6OBMrpAQXO4f/jZLeHNo6AMGz/UwD/neD2es+NVdw9mh5n9M*)
(*mAP8HEPtVEx6ti+S5Mawfc+e5UbtTK9ldTfbvVisS+9TFJ9mwyxseEIxd8qV*)
(*jDE47Qxqe9Np7YZH8pkW/T2HkO7QKepVDiZREMduTnHj2JrWNPdBSgNr+ppu*)
(*ADquizq1plq700IkMu/kPE3aXLqxr/LG1q74yfCVr/bBfPkn8ESE1rBCMgas*)
(*6y42tTuro8uwqSfxpo1QugaH0Yea8Dppmzwun6TobpiU/9e8CLrXCDLZxOpl*)
(*iaTZvBU0C6uq6+lV4o7iMIMsZsmpVxYhSlyczcpair0bI+duw/2VSTROkjb5*)
(*wtqpRz4ejUJYPE6n8ecVtCnqwpo3UWOyFLXb8B4XOKEtXH32AtVkXyhnyhVf*)
(*l4lbfnqc502eLMhO7TCqeDqMSOxrlzGtmj8K5lU/CedSpxMl1hmEBYu61g0L*)
(*f/xHvzN76Fyj+nf+GJl2L4xqf7CgpDu2uRCOYkyD/GyYYXT9RTKjpBs8pPXC*)
(*HJuOMOd2WOqsByJtcxFmqt4/JjOrgrLsVfGyS3YtLTCnFzQ3FaqCteoo18pk*)
(*J0/9LLpjzIc01UrmltsDar+8ufL8pXT3ytlEJyFYSYw40dAw2upMgO7vzcMt*)
(*r4Yzle10FpVLpPnrnfKfESa/tbd5pLljqoAmD6dVqjJbVNItNyn+dDHe/S+/*)
(*+z/O/j0PyiQq9WlFsbtz5S2wAX3hPlSVRZ7nRVHt54Uuty0Oo/whaKqu7HmW*)
(*FcKPrAVVJ7Cif+jwmbqqx12ybVOWg5BbEhOoKfvEs7xYKsc+qm61q20mCZRZ*)
(*lmYHvtIzmqrI0rRLsg9CXOVZLlgc38/k4OFTdb9mm0XYft9EHk01+hmfKs5D*)
(*lSXgfD2uOVtBe2yX5QUCr8s8TXsZlnvqdYeuRH3aFXl9nm+ogzvk/4KCCGun*)
(*7Z4lrXijCs5WTUMaW04N1brrCXcKbJlskRfE5NjdsN9WBc9v0yndrgBdEVbV*)
(*tDbD2BKVmzYkIIA0fIhlrkmnK9nYrboPjSdr9X5clkMNdsChKniGvqH2Taso*)
(*d3L/gCZpa9LiupLubII6SLQPCTct4v7Q8ATCct2j+RfvFAqTBwf274tj3BRE*)
(*1xO7o+1SeLz8olK/QlG8HLowcexHN4NuZFvtnQQ/MVv73cAb+WEE/sMUZIOq*)
(*n1WSnzzBuSE7JdkSbVOy4+Z0t5+G5e7Qsh1EoWf28czZUy2NvXYVnQKyzY56*)
(*f0lZwA8NCy1IjoY/ctsDU2iwl+GskEPaPKDhaNEfwUi78FoHb+aHEfgPU5A5*)
(*3NHa2F61OfuWxBqdhSR6OImsWdMDi1N/WOOTvVkIsoIYbBuuOwI21ftrygJ+*)
(*aHK61tz7KRL7/6sCJny3VNRh0ji2rPKI+CQYPgxdMFDmaWCztX3F9Irn1nLA*)
(*IT+MwH+Ygqyps9DxRGdrv5J+DW9zzbnyiB+Rn53KyJ56/9SygO+TqSupbH7K*)
(*KdI/Hk3mWLY40FpH1x3dKD+4CfxkpL6larpB0HVVs8Ifa2Ljm+OHEfgPU5Bv*)
(*mTx0rufOCod6Bw/TVslV17re7IQpbDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AOAboIpcS5ElWZYVzQzTb3aja+no/aEh/uFOhs+iziJLVyQiOdMJz+wmb+s8*)
(*dC35ovifdcxBWxfvS7G8OUpXJeZ3Fj7lrTIR8J2KC/xAtHkS+V6HH90SEqKz*)
(*TaKDoHFl7KmqNUQDbcnOUErVUc743V/9xV/9/X/+y9sLspHNLxogOpGGlibL*)
(*xlv2J941ymxptrZ4Z/Yo0GzPQU++k6/ucIySFHybwfn5aR3nz2h4K/RoM1m/*)
(*OuZ4kKpYcNODGj8nrsu7U+THeMjf0Xb6z6+Fge9RXODHocmsxZGJF0lVZXGD*)
(*jMkZTIY3BpYL12fXrfkvr/cFcX+eLxkgpkclLo/YfgF3jTIbmu3N2Rv4vjVb*)
(*k1ytrwwCRiuOncPOzxr+ViK/LYVTukb3UaB+6nGZezQJad70PNA2oHpJum5W*)
(*Zeo5N3LgRlNVRerLnyjktn5piqvmWsVuXyXfVaCDF8tEwA8hLnCKr9bkJ2Bn*)
(*50maTc5w788otOlRofJ1rxukXn+cJT1rnlOQOKGy5QZpXkTsCEElSIsiz27+*)
(*tf/33/zv/0Kfkvm5ltgnDhBjdTdlWQT0VFJ5fbros6mcH2U+tjVb240578re*)
(*hO9as/Vny152u8D7Ycea23xOui6S6Pa552ru89XCEVHH5HBhZWjYdRJFabkl*)
(*uTbtimGNZ5pUNMzeJ9q65atS/JZr5E5eJhMBP5C4wAHfQV3X9LR0yS8mF9tU*)
(*358+oseCS2Y4vdgW/nTFhNkG4+mZjS1djLCgRzJJRvjxI7Ko7orMWb3czrlj*)
(*lBnZ0GzVzXq3Gfb90uY+OVDyC48JaxzSM+3kG7G8Rr4B4Yho6dG9x9nrPmHk*)
(*uYRrKvNPNMNek+I3XiN38vZa+LHEBUR8H3XNDg+9ODNtX3cjvRGVWw/kBjPb*)
(*ZlNaRaBLJjfbWrbmpXlDfNrSvMhR36vY96b7zbjyvop1ddeJ/Y5Vv9OjzJQN*)
(*zTZkD2bYgjLx2NkDku6HURD0y1ZNlfm2YThJ22SOqWu6GWZs4jPybF1TVU0z*)
(*zGsQj1PETdk/ovWHF7RJ4Jp6hxkk027VXXfIs7rt+Y5p0IPPqiwOQ18nmdBs*)
(*P4rCIBrmwdo8Dq6GYVrd+wx3HpV3M5NtlQeOSbLxkd+87jEazpc+EXe/kYx5*)
(*t1mM6DINbVNX+6wZVzfIeSvZFE7v2XDzDa3TGdPsCLN6LJw9dl/blmkQhL6t*)
(*D9kLg+6VWx2lKTyDlaOXcC/gcugmdifsKnEso5egEyzy1JT9T3196/rVi070*)
(*7qarZUPr0c3r9My7zY65J3lSwC7p/ifdtH3fMcx+7n2nRnhjsG8zTd1fNDWa*)
(*eTcsjpSIIDM0R129dw1NJUULk2L2ozCtfTFum2F799/bMe8TV931nb6tmUZf*)
(*/mTWvGmb1/y87c88s0jadlAerPXQp8y4brOw6/uaaYfVgUC26/2DdaKubF3R*)
(*iu4PEqj7Gi0r6cluuK2jxJWyw96rGtKKrnnvcO4TBdW9benJcpDWVmM7qcl/*)
(*/5/+Ez8IO4KQNoY26RRHSBgVb9OJ0aTV3eQekbZhuSlxy26K2OnF23UC75Fl*)
(*tzrmfmH6dMHjZpubp16Wkbm9Xtk29ZBdaifMTbWmYsc6ZZ5GTbSTmS2T8ISI*)
(*dhvq1gBxqvu0VepdTZV04q5a87ppCTuZ3KhuZucQe6nXw30Lt4LlZjeBil4i*)
(*HGVEfe0OM2xH7TRFJ3Uq9DDwO1m2+W24EPp+RKq608nkIs/VSrO9XvKvp0m4*)
(*v93AX/nN/2L4WxpPh1K9pr7RmzXLcSz2XO/N1ebWeJ9iaFO3Sclnq/JtRG7S*)
(*LNd3rYnrV+2sciDptL9ULnmV1DVzU2cvVe1e+F2Ko4fnJJP/Mf9D1m1z5gNq*)
(*eKGjTS9cbN48Ypt5Kjiew/NOFsE3hKP+wT+yhn9MF/hEWT0Wzh77r+3n5AP5*)
(*skDytr74qtiWLtI0YcWOh26iGjM/1+nsfR7SKW7NMrnsJDMTZLnNyT6Li2Za*)
(*Ohe/MZ6fsuyYu5LvKEOZ/OT6vsX8Ruxqq0biatIYJrq6vDn0Mcu+8pergo1Y*)
(*osyQ99Grsm7ZXBpqL8bjtIRi3FBW2/c3O21e0DHvEVeVsIFMNzpLlJXBjnoB*)
(*5MHY5hVdn7YWgZvu9KmLPDykJY1QIFv1XpY3nRdYMa7GvN3bt8GOerIb7umo*)
(*w0pcs/2qm6MPebhe9csUxR6KIU5ru7GVpzX5X/lv/xb7B3VjbmPvyiu8v5KH*)
(*Y8Xp1+tMjUpmGNqLbN8/s9F4gyqWrSOvrYY6kinXWHBTTLMpmcXWr03q0sTO*)
(*fEZ+9HZBqAtF1LOpoObNng4QJ7tPFdMOqLhR5OizJj4ZaIYibXXtmts5krpo*)
(*4aPZcaCil+yPMqKxiUrxjBkmUDtFdB3lZrhFU3rmWGjNdEm/LlyDFkMOsv9n*)
(*odneIvm30TATmginLeNpZtSrY/V9RnUS9k3BZyZD6m6nOHVbxbfJI91AnhYl*)
(*99CTafdp+i8gyYxYkkUwr6DaZouSY5+mw6LM/QHanLcH3W93MvmX/pt/4A7W*)
(*l2REWVmX8ai0JT1My6q4sSvdez7G2Wy2Wkc7Vz9hXm8Ih8zdRYG9UNHCrJ4Q*)
(*zg6i127WnbCSnaWEWTfpm6QblVUZMNEpzH4gdSRbIRuiMk9ied7b/kNdNxXu*)
(*rdEpW+Y0y9vyvGMKJZ/0DUJiUyf9m3uP0GqzyFMJDxdLustDZ+sevRtJj+am*)
(*O3k/aAZ0T5bmJvSfPuvTWv8FKE7rQIwrZbV3/98L7u6Y58XF3HXkoOACN1lC*)
(*nYlC2/zQjQwnLKrC561lb0dSmY49pS8gM2615N+LBLJd73XefYRbXEv3Y18Y*)
(*jj39olMT5dluKNBR9/aFnVfl8S1wTZ7t3kgLA2csBh0NxWkJG9tJTU6zN/b0*)
(*8T39lTpPotAdctUrh6aOXWPItu6EZV0NV7wH3N+bdHxd/4khuJNNnQlX7Utq*)
(*Y8tWtP07N1qs7UVPQbrbIvrYV1DrAeJc98moUc71c2WzCpAcP0h2Jp3Xyp/Z*)
(*ORc2/HUtnCXDPhgPVfSe/JYJnRibTphhQrXT/ztzF20sYR/L5lCR9J5+xXml*)
(*2d4n+XewXlBmLnkXje0NJrNzCc0fny1J6TQWfyqje1Rlc1jto9+D7CuGTUTL*)
(*LlsCaD1FWpsEY5VVdM+vEk2UfMImztjX62Ym2Sq2bA2fRSxj0pixlBaE5px3*)
(*c7Ya17IOO+Rka7W9pN+37J4TWT0QziYnXruTvU3WnYJdGTcfcc1D2yfLoROl*)
(*SRLHSZpGbNZM2nEAZqaLGqVp/0CS3rii5t8U8zwIJU+7m2x4fDLCvcjMzNgs*)
(*MnXE5R28DYiZpPu8aG1Gs2L4OwcWCzPDfDAuxvBw7rP3Ze1BWkdiXNaL+P4H*)
(*OuYJcX3cSKLy1EF6+Nyef62MraWKaPsURnpiW280h5mv7VEBBfUe0hzI46gd*)
(*cqXda5Lnu+G+jrq7LwjUHW9a4xTEMOFAqkOY1kFjO6nJuXfWpO5YdQ9X2Feb*)
(*GXI9um4AbXLCQNqnTsbZQPm6ax4V4fFW4vJoZz33RhNPqW09sisiQUNdDhAf*)
(*x92Hz9epQzAOpmGE39cb1c2ujC2cKgdW8GMVfS6hU2PTsRl2rHb4/My4RpMz*)
(*w+zKMtz1iO4VzpCRhWZ7k+TfwXqqcFhinuWkrdIkrZq2TCNr+MjiT60NZtpQ*)
(*WQOYTKLK+vWWLyp9WWV1TK36uZLncxS0zWxmst77QJhcWWwnqfI0zau2KSN3*)
(*XLhYm2GTVGa5PZPVA+FsVsqJ1+5kb/t9e2bYsDt1rnn4R4E0ICs9smJsR8bj*)
(*Cv8iybMnZFnlS6XLPAgkn45r1fLVu1WTZfrNIs8v1qupv754dS3yDRFkZt2E*)
(*2Ovaw7QOxbiQycH9D3TM8+JatMaI7S6fmYs7rWWPtXAOCiiod9Zl7GR8PR9/*)
(*jSB/QTfc1VF39wWRumNyU6f+6Sz+VR9XQZzWQcM+q8k3bIzFlVV1b1x5epNv*)
(*dRultDORNWgVQSq5Tw26cSRdv8beauEijkQkaKj3K9uuvbB1sWFumXu76en+*)
(*fMx+dW+38BMq+lRC58amQzPsjNrpvlGooajxZQo+max5dC5G6T9Ai50k3iX5*)
(*d7Bbm6vBvc4juhIr6bZna9MaXz+ysDSmS71EO7mTL6BllZXs5nlF848aOj9/*)
(*Ynw5eaWOHFrX0tVjbgvnzbDHsnpohp157Z4QttjVDOOVWfukvyq30y64NCdC*)
(*RbeRh13Jt/kQxpeW2I1LQZFnF5thhfGuD5rdzLBohJvfRwdpHYpxIZOD+1/S*)
(*MZcXSayAdd2x+X+moMSt5WTpTghkv963ukxhMjep20u64Y6Oursv7L9qW24F*)
(*G1zkWy1M66hhn9Xkp80wkbp4ZJNv6TvBrH7YXMRlYZcuSyRKhXuajaEqNl6z*)
(*OeKLOBTRfkO9X9mOs/HDTk82uaQICnWqumdm2LGKPpXQubHpyAw7pXbG15ph*)
(*OWx6pelEdfcdpi9azp4Z9lrJv4OTnbe80R4hewlZqWHLf2fNsA+ytcQ2Ji6f*)
(*2u46chEwvTRzquQ1YhGn3BeZYSWtdj693Czn5Y7MsMeyemiGnXntnhC2eMwM*)
(*4wF1JznI0m1fEK4wjcWyX1NkebU5TX0gebLXzJ40lwvdl3Wi3pmviLrwBGvL*)
(*KEx2PnFEmWET3RdtEcmuTKKk/FNhWodi3DTDdu9/ScdcXcwHY2aaJNOHbMHo*)
(*tWaYuF1t1/tWl2moyrSi8lXdcEtH3d0X9l+1LbeGu1KUB2kdNOw7zbDJ9NHn*)
(*mGFVKEnWor2kbOvUxMmwrcuypDN8fOJFsODIJh4noSrWPGyGCUT0sddQHzHD*)
(*+vi0/BswiOOA2jmS+Dikx8wwoYo+ldC5selwNuyM2ulhc8WaX/TdRArzlCav*)
(*u2Hf/c3ZPOrdZthDkn8Hw0zmaol52nmrqzTTD81c2zdiFVffVD7N2H25800L*)
(*Grdjl6FEG/4RNFNHvMc5ZOv3S8wwNk87brEZxt96drMyda2Z1eyZrB4IZ4sz*)
(*r/24I17f3WYYd22czc0ScZmbCnFQmLo3HSNIOKCtaWqx5OOrOkxuRzbzIlGd*)
(*/s1bNbKc7t7MfO5rE/+NReZFmZkUbarqc62viF8L0zoU49IME9//QMc8Iy7u*)
(*Jj7baMb0IZtkeJkZJi6goN43FiU/mGdUV00v6Ia7OuruviBSd+vxfVhW6zMm*)
(*TuugYZ/T5B9DyIhBjXCPtfeaYaQU+sIG4LYBM8PoPk26s9YKsnY8UWVnApAt*)
(*tAlPvuPN4A4z7EhEgob6mBn2UQbkFZqq9Ic2DuFBRHk8Ud3zRclDFb3NYpQ5*)
(*NzadXZQUqh36YrpKSPuQ/zFsjCUsllMfMMMekPw7GHLe9HPpXpQ3zUa4NnaE*)
(*gcq8bauAbo1XnLKMvSBja7gTJwS6es7UZhPL0z01NXOTGyYeqVgnk+058x2c*)
(*7EFm1cGvbGVyvFgLriTjFe59zQzCKvVVlpMi8b202RDO4CvCc3uc1QPhbHP8*)
(*2o+h0S58PzYYWmOX/9zzoqYrhTyX+eCDSkSRDeeCSXqUde2yLeJ+381untvx*)
(*1DDdiaqmbWu6LUXhxjZzJqEpiiXv/135ovrDu2/W6Gi6VSNDnGcmh2RYMFCv*)
(*JLBWm5GN9ubOVqmDZvDreFh/uIa9JUaOX+n+ZZVHaR2JcSaTw/sf6JhnxMW9*)
(*ay7mqFdZJBmuaXP6SbrXWnZY7889KGBy3a13JufpNmHmxWEQvfJ0N9zXUXf3*)
(*BYG6Y6OANNlgyOb0qOP9gXyEje2cJh8XN7kHfu2z3ePDlNS64na3WrMrdWr3*)
(*YaqsVSS3EZp5M5xN9NEqvkh9VyKB8am6oEuNSvIL28i2t8mRu9VZoj2Qw05J*)
(*MlGTBbau6ZYbiXTmkYgEDXU1QHyc6D609erxPQbAuroX/fpj0cKPVfQ2q1Hm*)
(*zNi01GwfQxT9O9QOhfkedLh0QaLwefiQ5R6ZlQTeIvl3MHjuKWrferz8l+hK*)
(*m60a5stO11/V9dEYpVfc/zvgYSASVhwWV4RFhqHKp1Ms5IUFXUbhFm+VuFSq*)
(*uhsPsqBniZKH3KL5aIqINiFubDdbmWxvTE0NUl1faSIWXqS/Mhj2fQAUbVGs*)
(*PhzBSjhtw4bsi+aw3B5ltT0Qzg5Hr528RzpsRfw7WlIUqf+m+IVvMdZ5EIaa*)
(*14IZkg9Wvglrzm6Ago9x/+D8Af4FOnzYUrmJJe//dl9rmk1UZVvQOqR9cF0j*)
(*3cu4hDUmh+lJsiPbYYU+jjLTNYPpYbXj66iKFqclFONCJkf3b7Z5ccfMTomr*)
(*05nsScmNi342hy4VqW69qLt1awl2Np/2ix0Ry+41GtW8UCBU4W/W+2CBWAGx*)
(*hMuYzjINA/Sz3VCgo+7tC4JX8bWbrmOQExXb2KVTYXwVRpyWsLGd0+T9W1yV*)
(*i8o0h0AgFFn3fyl5JDqukNvxCmsAbREypxqHGslD0zN2etmQ6MXy484G+Gjr*)
(*YacejeJI3XKkLvf9/+R+T1/JNocuTjKiVInH864Kjr7jH1lkBrJJxowuV343*)
(*c7ston+931DXA8Rx9+Gngc/oPej1VfDVkXV184APesIi19aLgUasonfYGGUO*)
(*x6YNzXa/2hng3rmDccWUnr5ciV4m8SbJv4VJbEPT/1fWvMkNe/w7Y2nIsGIG*)
(*GQt61unY4B/PQ6O5cWzNyqbGf7oqrGKRGmsjazF0jFu5y5s7e0pSuRtksZXJ*)
(*ZSRYJ06u81SdW7y4Yid/4o2RxRQ/GT5GVRaceiacjH+Ac1ikWUFWG/9QOPuG*)
(*zf5rB90y/VUUW3WMZadYf/yvl6VIAnN6gcW8qlNrqoC6YeUoEn0azGqmU1NM*)
(*HSTzFPuOVgkkv6ynXnXzifR5jXzwk4IH2DR1FU/jfEps9mAPUWboHYk31WDS*)
(*NZhoAHFaO2Lckong/s02TxLf7Zgk9tRJcbWFOw9dqJoejZqzbGlda5lE+OwT*)
(*tTfUeDG/hwT3OBDIR7/csFvv40TQ5Ek7nB+H8Uw33NVRB3neYK3bh1c18UYx*)
(*NHsWjl6clqCxndPkJAVv/LEzCAsWwcmw/T/+o9+ZPdYNYPPtBv2VReUqzr/z*)
(*x8i029YpsX902zG1hWwU51bwKpa7Kq2Xzy2XAOjVtTmqbrXDDz4jJBkBEVE2*)
(*ZFQctlEgorSs9xrqeoD45VT3adzlMDgWa3eqalbd/9aZv2HVwplr656K3klh*)
(*d5QRjE1bmq1ZfMiykIz7amdGGV7mUTXKsI/UNm9pS832D6Pfe5fk30VbV5Vw*)
(*Qz+7q67H/dFNxT0pz7y/PyCgKfM8y7K8OG1ntnWepWn/yBsjqdXVpFRdJstq*)
(*XqqzwnlLVl/32rbpy3HvU1WR50VXawLfizlNled9NRcnpnn3JN8fVNI1l6ok*)
(*zSWvlsI/VyPdRzyRXV6cKvVRM+juKLOsr4qtkh2kda8Y77v/oGOeFFdXvjwl*)
(*ba2s3z5Fv1lAQb1z37C4abpayHZq4Zn+cqyjTlfK/qsG37CqIYXcVYbCtASN*)
(*7Wxd92c7dY05p1LqhJY/V+dtkRfka27PXbAtMu6+WPdF71taPqujmMREHbx9*)
(*Mtck80tseHUEE14i6OrYeM5RW/U5NaWLvGO2jeyL6EhB3QedWlTtW9O/six6*)
(*ugruDx26TIJIbz56trqn3KOihfl+zdh0Qu10jWdxcFad56eD8e7zhOQBAODn*)
(*4nBXy/fBqa0N3ylVP+20swvmDA2Lmi7bQRR65ujPT5eWlEdOrKbbnBfHZ9Dp*)
(*Gjv9RuqAuVFtOKvlXmdAnjyDCdwPJA8AAGdhzsbfuxnWntna8P3Bd7UYyXMT*)
(*LKk/eEfI03PVaRy24Yynk7R5QE8dmK7p+mQPi+EJtkd9LnwJW1JN/5aWVd00*)
(*/TRb5JE90PvHtoJngeQBAOAMTZnGAT+sWPFigWf1N02Zp4HNXGQU0yvev/L7*)
(*adRZ6HiC7Tv30K8ObSxPsZ1ceycXrMijfmeEZPjzXNWh4wi2c34FLd9JsXJO*)
(*ugbfVEZ/OCB5AAA4QZ1amqYbFF1T9SD/LueSUt9SeTl0XdWs8LssxhfSZI5l*)
(*n4ys2RmGbrS7jfdboy5S37l2zULr0S3bS472Q4GXAMkDAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAODbo3T0/jAy/+RGGgAAAAAA8BKGUGzW7auzAgAA*)
(*AADwU1G6hiJJ6ncaUwgAAAAAAAAAAAAAAAAAAACAH50mCRyDRvM3r1FGThav*)
(*szAIQkYQpVVbpfRCEARJSdf+muzmm/o1//go4+4PXdP16+xwsf4GQzPjus1C*)
(*R9c00w4rQaKEtkwcS1dVVTdt33cMczwXbP8nmpARldPTyNo8Dq6GYVpd1gw3*)
(*TKe/NWXm213WgvajTQK3u0PXza5gk1tKz+pKZMXPnVcLAAAAALBNm1+V3rld*)
(*My1dYUdbGn7WFjdDHg+7NKPyo4r472pYNDdH5z8q16t+maLYnTWTB9Z4RZb4*)
(*X1rS7Cba56cM+2QlzfV9SyVPyTYz0XZ+miZk3QZzrnLJecBSZ7KZOktetYu2*)
(*T90ai6YY2pC3/nY/Z0ZXHV9Z3q/x51cLAAAAAH502sDojBAlKKjt0XjMJlGI*)
(*OdMGJrNX7Lj+aBONm1gdeXwLXHMwXzTLDQOHm1QX3c/KNI4CezBxrp5D3t2Z*)
(*YaJEE7t7h8SnzLo7u39d6b/2fqqyMaFrzH6O7f7wdNkM2d15IPOctW0V3yJH*)
(*56aYZIRpUaa+PDe62iKk7zTD4u31AAAAAICfDTq/dFGjNE3iOEnSm2vMp5Vy*)
(*gxsrssTnsgbaRJ1OZHUU3NqRbbJcWNvk35qTsCeOEk2o+WR4zJzK3Yvs0DQF*)
(*P3UvtaSJGVbR+BVKNFkfTRx1Ot+VuRrJp5nzGyIyR6ZM5r7auizKySsAAAAA*)
(*AF7EsO7W2VgMWemQZdXjcVCb1B2mvNx0Hg6iiYllo05ts9Ag9pBkEmOnphNk*)
(*dlKfTDRlxhKZl/JuVTv6ZQl+GhKiZlgd23R6LZ7aUMz8YxZmk5B7FHu4hZp5*)
(*CpYgAQAAAPB+amKKHBoeN4stNtpxNfuBmWEza6cI6UqlTDz1Z9bRqUTb3B6s*)
(*LfIeNy6Pf5onVEbXDTOM5baz4W5DNvisXQ/MMAAAAAB8GswUuRj5/HpTZPmw*)
(*PbBJJv7380XJLTOsSR1i3ljEQto1w4SJtklgK2OiF28Myrr30yyhImCmYDQ1*)
(*G7kZZt3KD5hhAAAAAPhS+OLdRffS6eVrZyQx37Da7W0T/Zb4o4v7cCNflIwn*)
(*tlnu6xPzZssMEyYaX1XullZHNjMAVae/U/DTIiG24Ni9MJh41zfMk81J6/Ee*)
(*mGEAAAAA+BLaVOPTSroTVU3b1oVvdgaNQme9qFs7dQlLPX1p2zAzTPLywTRr*)
(*qAOX7ufsnyvfMHGiyVW+qP5wL10PpaaR4KePj8qeJcR3FkjmYIc1iTO9UgTk*)
(*FsUZckZ9zxQ74ReqwDYNk1ptAAAAAAAvJvf5VsgJxLZpMxKPS+IxH7p7+eqk*)
(*xJyy+DJf90BW9wG5YpdOhV2pz1ZTRPQG9Ro1pxJlU1KaTfY4tgV1BqN2oOCn*)
(*JvdpcAnNialFWN74RgDdLZo+J9pkKozEu6DTe3rCVkJZnLGLbFGjcowbNhpm*)
(*AAAAAACvJA2saQDTzs5pBxcvgk18v1JXm9x1Uex4NMMmSJpN3bWK0Jr/YmTt*)
(*QaIf/cqjPH/qYvls7XLvp2lWiWHlUZOvvLmzBySVu/Q3vj5N/OLGsTW7Ve3D*)
(*pOUey3eAuGEAAAAAeBtNlXdkWXHXwT2Db1jVlN3DWZYX1fFTwkTbpm7atqnI*)
(*+/K8mkyiCX7apa3zLE37jJUPnEhUF1maP/IgAAAAAMB72dopCQAAAAAA3g6L*)
(*oq/EZyamAAAAAADAKyjzNLCZt5hiekWNtTsAAAAAgM8g9S1V0w2CrquaFWJK*)
(*DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOA8VZ4lSZpXzVdnBAAAAADg56H2*)
(*DenC0Z24/eoMAQAAAAD8DDSJ3Rlft6ws0kDrzTH5Vn91ngAAAAAAfgLywAkL*)
(*9nd9u3Z22DWuvjRHAAAAAAAvpk6czsgZ1/8GFPtt80+1razTu1xkM9taeqzj*)
(*zgyTbrDCAAAAAPBjUffLfxdZMyxzimFcg7d5xrexdzWMaXKWocmd5be58ngz*)
(*LxfNh5s+AAAAAH4wqBlmJ19s5rRplw05Xplhbe73jmGYCgMAAADADwc1w77c*)
(*84pkY2WG1bFyuTgJvPMBAAAA8APyuBnW1FUtpKrPR5nYMMPa3JS6jLFLVVEi*)
(*ZgUAAAAAfiQeNsMic8Ovf46WnraclmZYk1vy5SIZQRj4vu+YykVx4R4GAAAA*)
(*gB+JR82wglhhkmF7cZoFBttd6SdZniWBY5DfwjuzMZhhjactTbor/MMAAAAA*)
(*8GPxoBlW+J2d5edstiugEe81j89+1dfLxYzKO7Ox4aIPAAAAAPCj8pgZljnK*)
(*xbixf7QpnbvS/Xy4olzk2z2LiDDDAAAAAPCz8ZgZVhdZwU0m+obLRQoKPhnW*)
(*1ll2x1TYB8wwAAAAAPx8PB+wIr6SmPiSdZ/htZENmGEAAAAA+Il42gwrLeIX*)
(*Jlu343sPsgEzDAAAAAA/Ec+aYUVA41bYz5lQMMMAAAAA8LPxpBmW+zoNEfbk*)
(*aUgwwwAAAADws/GcGda4KrXCvCdjq8IMAwAAAMDPxlNmWBOri1AVT2UDZhgA*)
(*AAAAfiKeMcOq+MpCVTyzSXLMBswwAAAAAPxEPGOGhTR4vnx9/pwhmGEAAADA*)
(*59GUcRQGQRjd4rzsR9+2TNPilac3V6mv63bBkqurWkhVN7mvqtf0c44ufEHx*)
(*K9/S7YiWrxUXjhSvDUzNCtLFWx42w6rE5Wd769npI7z3gBkGAADgS5mOqh11*)
(*Gt/CjiguTwzOzc7o27Qfm4Pv15KHVz6CM2RNV/pplfhVSSRuv4NPc9iJOpG5*)
(*SHCNlraVS07lceKn19iEvKD4dUI2KOoRtdzK8LB4qpt2hhMpqFPO3nS/GdYk*)
(*q5O3L5L+lJc+zDAAAABfxnxUbfJAnY/SXiIaJZvM3Rt8u+F1c/D9QpqU5la6*)
(*BimZRKljz6S5tZPXDMOZb3RvM4LBb7wgVphk2F6cZoFBU1P8JMuzJHAM8ltI*)
(*c0dPqb7ecyz1Xbyg+G1KSmDyg7U/irB/g6SaXhhnqc+KZ/l5nie3wOyD3EsB*)
(*MfDb3O+Lp1yH4j0fRf8lwAwDAADwNSxG1TYjJpls2rahDpMchmArWmjKO1aY*)
(*lpIZivXg+4XQs28kI5heTJzO8FRurxiFqZ3DzSpC0Vkmks+tFmpoXTSPWzH1*)
(*tZP+aHflxGaTo/cYJk8Xv/G00ayiBHpvdLLiFD5tNC5fKWxi63KxhtIUQW+z*)
(*yVZE//lnv/8b3T//a+/PninUXfySOF2KvxP/Mr1YJ10lyC9pAAAAAMBplqNq*)
(*anc2lZHxBZ7IUujcxu4IVcf9epbpJnlRVlVZdv+pi9t1MdYvBt8vJLHVuRXU*)
(*0/SjsPUKw4dNfPnF+PrMUS4GP2qnTemC2hhjoU2VzgCYrKiVkUXveNrjaYMn*)
(*i88mvqZWXJ9/KeLNI6ULq10T4r+njiJZ0+XO0iJmO7VLf/1P/2b392/+4edZ*)
(*6L8kv9Ol+D/N59+azFNkI32lbyAAAABwwHpUrfMkmw5QTawIzbA6tiRtaTBk*)
(*ZCy+3qYvmg2+Xwg7CbozFCbBpuruqvnUoYQUZkHN9+7VRVZw6dE1OGL3cjm0*)
(*dZbNjZCW+j5J75DVc8VnBzha05ptqywbXQodes72tEVNik9hppreT6BtGkVv*)
(*5fNTBAAAALbYGlUX0DP7FOee5ZrqKpMVybkRMR18v5A6dYZF0+vttZMwLKi7*)
(*Yu/6ujMrSLKECfP3vG7LwMAzxed+ZequD1V9o0aeKfRta1geetseZhgAAICf*)
(*k+NR9aMmppNy34F9xDto5hzFkhsH368lcceddlb4bAD2ETZzeLnuCpTZvbJ1*)
(*MPXElg43ImK1sWdpughNs8SLaw8Xn+VKsXeLRycDuyoW2zg8+n1n/8MMAwAA*)
(*8HMiGlXbOosDg61fXezojsE63ViRJEwG32ey/RJiZzRF7FeNyEUoMzNs54V0*)
(*arFP8cAS5UuHa5O1dlTpIu0jdylohzv+Hip+y/ZiyLtmGNt9sG+n8UIwe1W5*)
(*xjDDAAAA/JQIR9Xyps1DQVlnQyhsr0j2TAbfJ7P+EiLuJXU8e3OOmp2ts2uG*)
(*5T7ZhHrRDmcXh2ml94VQuL/4lU2tTNnevp3tsb2ozmGYuJI0kmMz7Dd+4zf+*)
(*3Kv5O7/112CGAQAA+GqORtWPPtZ6YPEQYis//G3IhM96RZIwDr6P5vkpqtgP*)
(*0qlZUztD4Vy2sa+tJ+Huq+7PO5Zjufv93nQf8/i6aMeBRvmrXmmGnSm+OFMO*)
(*9+7fLh5b47642XH56KsOzbCuEv6/V1P+n/8zzDAAAABfzcGoOjBMmp0Zt9iK*)
(*5PYYNw6+j+T3aSJDMhcGEncpH7IUe9YQBE2W2Z+aYSflsRFax7ZoNoyvyer+*)
(*8Qovn1hbm2Ft7D7oG3am+OJM2ezu7TVHtsYtDDHHqexzZtg7wKIkAACAb4CD*)
(*UXWAudafMsP2VyTJr/ZXmmHVVbrowcJG2MhSOotl2iQ+DTKvHq7csSi1Oy76*)
(*FbOspODE6m7C6ma9e6LxjU7EAuewzac+zhdfUL5AF7h+0arfmwidMyxP2zDD*)
(*AAAA/JyIR9UJNC666h6vz9EVSXNnIJ4Mvg9k91noZJQ8jxRRRWunemICzaah*)
(*cnr+0EQCDYlTuzQ2uXPU5qJkSN3XNzY/bpA4B3sS7+Z08T/2SvfxkXn6bhFK*)
(*tvvg1P6LJlG5vQozDAAAwM/J5qja1mWeF1OLKyLLdJORurl5jm07t3xplwlX*)
(*JGeD78vKcJpmiJelWnHR57DObwa1QlR3muO1GcZj41PX+srrHpPok1o0W6xk*)
(*lq1sLg8LqBKX73jQs+PlzdYn71Gd5NHiLjldfEHpPtqCnhcph4sJvbb0dFY+*)
(*3T92M2tzj9ytdvL8s9//r7q//pr7J68o5Sk2zTDijGecqBoAAADgNWyNqjXz*)
(*278odnDLssQlBzOr12gcoOobvUVaBr+iPv+7ZsZ08P18Uke5SIZjL8+/VA23*)
(*mN+5ZYZRr7Z+pTLp/lLJbgXqWDWfJKzJeYWz6KxNol2WSLrQS5/Zq6eWL09y*)
(*svji0g3efdPorImzUT5P6KVP5/ro8uWf/f5f7/7+q+6/f1lRj9g3w3CmJAAA*)
(*gM9kPaq2/BDJcaB2b3OHIj6ppdizuZrOyuqv7rsGTQffz6etCn6kTlMWeZZ2*)
(*ZGW9YTIKzTBipkqKqiiqqvQrsOrifAG2/dB54njCikSreK2gzhX/sHR8Vu3M*)
(*CvUu9FgrdpzTN2WGfcU0LQAAgJ+XzVG1qcq8I8vyYsNBiNxQpNlySbKti25o*)
(*L7YMG8Js8P2W2TLDcuLYpSZNbUsXfbkmN6Nlxz+d2li6RUEi7etfccz0cen6*)
(*hVcii4dj3tKQaJrLYovdZYZVeRqFHVGcFsd37wAzDAAAwDfDs6PqSRaD77fM*)
(*2gxL3d6JTr7e2MLruOZYOYaztlqKqN8UKVtLD7ET0OqQ/JXf3adwqnRd+Ujk*)
(*VyU8EcRjQZvTsHLjuaJnzbC2dI35PK1ipQ9ZTTDDAAAAfEs8PqqeZD34fssQ*)
(*M0xm67RtFdnE90m90mm8mIV4MMPbzdEvkrl9OiTzyTf8O8ypJruS3Yz+cfjT*)
(*d3GydL0nv07MxXuymoXEOjWD6TMnzbDIpFsAJFWdGGPy9QHvOZhhAAAAvjEe*)
(*GVVPsjn4frPErjEc4kTOZ+xHfjtIJgZk6ercz1255gLLsskcy75Dok3m2t7X*)
(*TIONnC7dx0ceOXZwJvw+Iwtd77aM7XrKDGtTrZ/9CtgaeZ0ODowP7LqFGQYA*)
(*AOAb5N5R9SSbg+/3Tk0ia311Lt7FZ5bujBlWJ50lb84yxMOU7UZH2QdmGAAA*)
(*AADAx8nZsKYsqsUsITsDYhl4tsxu0Ta3lC1gwgwDAAAAAPh4OGBFS6OxTTfe*)
(*tjd7HcFsAg8AAjMMAAAAAOBjMMP+wX1mGDtFXRuj4NKodLJCj6FXDdPUVYn/*)
(*beia7mfMxqJmmPV/wAwDAAAAwE/Nr/+gn8L6zT+8a8sjPa9hPP2Bhr9zk/qj*)
(*CiV+riU5ov3irg51aP5fT/3L/136y+wizDAAAAAA/GwQ++c+T3saxk33xu0k*)
(*bV0WZT8xRuJa6P2GEHrWw+oUAGE2YIYBAAAA4CfiXjOsIsuRshluxNIo+6kw*)
(*eh56ERj9ymN0dpINZhgAAAAAfjbuMsNoHODL9sHo9AAChRzPXV2Fp8zvZANm*)
(*GAAAAAB+Iu4ww6obXWec3lpmKVmNZKdl0QOk2swjf/dHANR5mm2fjLrOBsww*)
(*AAAAAPxEnDXDqhuJRqHFZdUHl+0o8sjrTS8vb6vEobsiqdN+5unkEICoykP5*)
(*cnFOnGQAMwwAAAAAPxtnzLA6D+enek9Q7KpgEfXp9FdHfB1vl8zwdDZghgEA*)
(*AADgJ+KMGebr0o4RdjH8nAam6Oyt4QTMzONxXFW7uCMbMMMAAAAA8BPxQMCK*)
(*JU2ZJmk98/9qsiRJ8ztikcEMAwAAAMDPBjXD7OTYfeutNDDDAAAAAPCTQc2w*)
(*iyQrM2RZc99mE9WerizSI6ueNNgFAAAAAMBPQZP5mqJqC1RVt6PTQb/upfbN*)
(*LoV1mmb6xXNyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAADwGfz/+8Zc3A==*)
(*"], "Byte", ImageSize -> {405.79999999999995`, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


(* ::Section::Closed:: *)
(*Response spectra*)


(* ::Subsection::Closed:: *)
(*Available spectra*)


$responseSpectrumAvailable = { {"Eurocode 8 - EN 1998-1:2004 (Elastic)", "responseSpectrumAccelerationEurocodeElastic2004"},
{"El-Centro 1940 - calculation by N Fares; compared with web-published displacement spectrum", "responseSpectrumAccelerationElCentro1940", "responseSpectrumVelocityElCentro1940", "responseSpectrumDisplacementElCentro1940"} };


(* ::Subsection::Closed:: *)
(*Eurocode 8 - EN 1998-1:2004 (E)*)


$defaultDampingRatioForEuroCode = 0.05;
$defaultAGForEuroCode = 0.35 * 9.8065;


Options[ responseSpectrumAccelerationEurocodeElastic2004 ] = {
"designGroundAccelerationOnTypeAGround$ag" -> $defaultAGForEuroCode, 
"eurocodeTypeOfElasticResponseSpectra" -> 1,
"eurocodeGroundType" -> "A",
"dampingRatio$\[Xi]" -> $defaultDampingRatioForEuroCode,
"lowerLimitPeiodOfConstantAcceleration$TB" -> Automatic, 
"upperLimitPeiodOfConstantAcceleration$TC" -> Automatic,  
"valueDefiningBeginningConstantDisplacement$TD" -> Automatic, 
"soilFactor$S" -> Automatic, 
"dampingCorrectionFactor$\[Eta]" -> Automatic};


responseSpectrumAccelerationEurocodeElastic2004["constants", spectraType_, groundType_ ] := 
Which[ 
spectraType === 1,
	Switch[ groundType,
	"A", internalGroundTypeToEurocodeParameters[ 1, "A" ],
	"B", internalGroundTypeToEurocodeParameters[ 1, "B" ],
	"C", internalGroundTypeToEurocodeParameters[ 1, "C" ],
	"D", internalGroundTypeToEurocodeParameters[ 1, "D" ],
	"E", internalGroundTypeToEurocodeParameters[ 1, "E" ]
	],
spectraType === 2,
	Switch[ groundType,
	"A", internalGroundTypeToEurocodeParameters[ 2, "A" ],
	"B", internalGroundTypeToEurocodeParameters[ 2, "B" ],
	"C", internalGroundTypeToEurocodeParameters[ 2, "C" ],
	"D", internalGroundTypeToEurocodeParameters[ 2, "D" ],
	"E", internalGroundTypeToEurocodeParameters[ 2, "E" ]
	],
True,
$Failed
]


responseSpectrumAccelerationEurocodeElastic2004["constants"] := responseSpectrumAccelerationEurocodeElastic2004[]


responseSpectrumAccelerationEurocodeElastic2004[] := 
Grid[ {{"Eurocode 8 - EN 1998-1:2004 (Elastic)", SpanFromLeft},
{Grid[ { {"Values of the parameters describing the recommended Type 1 elastic response spectra", SpanFromLeft},
{"Ground type", "S", "\!\(\*SubscriptBox[\(T\), \(B\)]\) (sec)", "\!\(\*SubscriptBox[\(T\), \(C\)]\) (sec)", "\!\(\*SubscriptBox[\(T\), \(D\)]\) (sec)"},
Prepend[ internalGroundTypeToEurocodeParameters[ 1, "A" ], "A" ], Prepend[ internalGroundTypeToEurocodeParameters[ 1, "B" ], "B" ], Prepend[ internalGroundTypeToEurocodeParameters[ 1, "C" ], "C" ], Prepend[ internalGroundTypeToEurocodeParameters[ 1, "D" ], "D" ], Prepend[ internalGroundTypeToEurocodeParameters[ 1, "E" ], "E" ]},
Dividers -> {{Thick, {True}, Thick}, {Thick, Thick,Thick, {True}, Thick}},
ItemSize -> { {10, 10, 10, 10, 10}, Automatic}
 ]},
{Grid[ { {"Values of the parameters describing the recommended Type 2 elastic response spectra", SpanFromLeft},
{"Ground type", "S", "\!\(\*SubscriptBox[\(T\), \(B\)]\) (sec)", "\!\(\*SubscriptBox[\(T\), \(C\)]\) (sec)", "\!\(\*SubscriptBox[\(T\), \(D\)]\) (sec)"},
Prepend[ internalGroundTypeToEurocodeParameters[ 2, "A" ], "A" ], Prepend[ internalGroundTypeToEurocodeParameters[ 2, "B" ], "B" ], Prepend[ internalGroundTypeToEurocodeParameters[ 2, "C" ], "C" ], Prepend[ internalGroundTypeToEurocodeParameters[ 2, "D" ], "D" ], Prepend[ internalGroundTypeToEurocodeParameters[ 2, "E" ], "E" ]},
Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, Thick,{True}, Thick}},
ItemSize -> { {10, 10, 10, 10, 10}, Automatic} ]}
},
Spacings -> {Automatic, {{2}}}
]


responseSpectrumAccelerationEurocodeElastic2004[ T_ , someOptions:OptionsPattern[responseSpectrumAccelerationEurocodeElastic2004 ]  ]:= 
Module[ {ag, TB, TC, TD, S, \[Eta], \[Xi], TBAuto, TCAuto, TDAuto, SAuto},
{ag, TB, TC, TD, S, \[Eta], \[Xi]} = {
OptionValue["designGroundAccelerationOnTypeAGround$ag"],
OptionValue["lowerLimitPeiodOfConstantAcceleration$TB"],
OptionValue["upperLimitPeiodOfConstantAcceleration$TC"],
OptionValue["valueDefiningBeginningConstantDisplacement$TD"],
OptionValue["soilFactor$S"],
OptionValue["dampingCorrectionFactor$\[Eta]"],
OptionValue["dampingRatio$\[Xi]"] 
};
If[ TB === Automatic ||  TC === Automatic ||  TD === Automatic ||   S === Automatic,
With[ {v =internalGroundTypeToEurocodeParameters[ OptionValue["eurocodeTypeOfElasticResponseSpectra"], OptionValue["eurocodeGroundType"] ]},
If[ v === $Failed,
Return[ $Failed ],
{SAuto, TBAuto, TCAuto, TDAuto} = v
]
]
];
If[ TB === Automatic, TB = TBAuto ];
If[ TC === Automatic, TC = TCAuto ];
If[ TD === Automatic, TD = TDAuto ];
If[ S === Automatic, S = SAuto ];
If[\[Xi] === Automatic, \[Xi] = $defaultDampingRatioForEuroCode ];
If[ \[Eta] === Automatic, With[ {v = Sqrt[10. /(5 + 100 \[Xi])]}, If[ v < 0.55, \[Eta] = 0.55, \[Eta] =  v ] ] ];
If[ ag === Automatic, ag = $defaultAGForEuroCode ];

\!\(\*
TagBox[GridBox[{
{"\[Piecewise]", GridBox[{
{
RowBox[{"ag", " ", "*", " ", "S", " ", "*", " ", 
RowBox[{"(", 
RowBox[{"1", " ", "+", " ", 
RowBox[{
FractionBox["T", "TB"], 
RowBox[{"(", 
RowBox[{
RowBox[{"2.5", " ", "\[Eta]"}], " ", "-", " ", "1"}], ")"}]}]}], ")"}]}], 
RowBox[{"0", " ", "<=", " ", "T", " ", "<=", " ", "TB"}]},
{
RowBox[{"ag", " ", "*", " ", "S", " ", "*", " ", "2.5", " ", "*", "\[Eta]"}], 
RowBox[{"TB", " ", "<=", " ", "T", " ", "<=", " ", "TC"}]},
{
RowBox[{"ag", " ", "*", " ", "S", " ", "*", " ", "\[Eta]", " ", "*", " ", "2.5", " ", "*", " ", 
RowBox[{"(", 
FractionBox["TC", "T"], ")"}]}], 
RowBox[{"TC", " ", "<=", " ", "T", " ", "<=", " ", "TD"}]},
{
RowBox[{"ag", " ", "*", " ", "S", " ", "*", " ", "\[Eta]", " ", "*", " ", "2.5", " ", 
RowBox[{"(", 
FractionBox[
RowBox[{"TC", " ", "*", " ", "TD"}], 
SuperscriptBox["T", "2"]], ")"}]}], 
RowBox[{"TD", " ", "<=", " ", "T", " ", "<=", " ", "4"}]}
},
AllowedDimensions->{2, Automatic},
Editable->True,
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.84]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}},
Selectable->True]}
},
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.35]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}}],
"Piecewise",
DeleteWithContents->True,
Editable->False,
SelectWithContents->True,
Selectable->False]\)
]



(* ::Text:: *)
(*Plot[ responseSpectrumAccelerationEurocodeElastic2004[ T, {0.5, 1, 2, 5, 1, 1} ], {T, 0, 10}]*)


internalGroundTypeToEurocodeParameters[ typeOfElasticResponse_, groundType_ ] := 
(
Message[ shearWalls::noEuroData, typeOfElasticResponse, groundType ]; 
$Failed
)


internalGroundTypeToEurocodeParameters[ 1, "A" ] = {1., 0.15, 0.4, 2};
internalGroundTypeToEurocodeParameters[ 1, "B" ] = {1.2, 0.15, 0.5, 2};
internalGroundTypeToEurocodeParameters[ 1, "C" ] = {1.15, 0.2, 0.6, 2};
internalGroundTypeToEurocodeParameters[ 1, "D" ] = {1.35, 0.2, 0.8, 2};
internalGroundTypeToEurocodeParameters[ 1, "E" ] = {1.4, 0.15, 0.5, 2};


internalGroundTypeToEurocodeParameters[ 2, "A" ] = {1., 0.05, 0.25, 1.2};
internalGroundTypeToEurocodeParameters[ 2, "B" ] = {1.35, 0.05, 0.25, 1.2};
internalGroundTypeToEurocodeParameters[ 2, "C" ] = {1.5, 0.1, 0.25, 1.2};
internalGroundTypeToEurocodeParameters[ 2, "D" ] = {1.8, 0.1, 0.3, 1.2};
internalGroundTypeToEurocodeParameters[ 2, "E" ] = {1.6, 0.05, 0.25, 1.2};


(* ::Subsection::Closed:: *)
(*El-Centro 1940 repsonse spectra*)


(* ::Subsubsection::Closed:: *)
(*Raw data for response spectra of El-Centro*)


elCentroResponseSpectraRawData = {{0,{{125.66370614359172`,{28.16631631942772`,0.0003252064121996001`},{25.255705809807438`,0.043783656276644906`},{25.542968630033354`,5.90534803355716`}},{62.83185307179586`,{14.134766183082577`,0.003526978179452605`},{9.655836043946989`,0.2452993616132212`},{14.134766534803203`,13.923959167789013`}},{41.88790204786391`,{4.8908204535557465`,0.01268115412673232`},{4.775982381997891`,0.5818334918121507`},{4.8910458717632554`,22.251181289091114`}},{31.41592653589793`,{11.538739884022535`,0.017042050721120236`},{10.391377855404212`,0.5427403517375546`},{11.5383791260569`,16.816935392828373`}},{25.132741228718345`,{29.106374498923103`,0.02982556214364288`},{28.794349612186185`,0.753837304527479`},{29.106298912314326`,18.838936697912473`}},{20.943951023931955`,{28.99353666795248`,0.03688873132688972`},{28.166601020692973`,0.7488812245768283`},{28.993538487005672`,16.18119127028237`}},{17.951958020513104`,{11.609641801588037`,0.05579803730973454`},{11.701389271239169`,1.0042075072918701`},{12.664673495450325`,17.534498296418025`}},{15.707963267948966`,{30.45641463950588`,0.10916762852136147`},{30.556502312979884`,1.7146961512831433`},{30.65579712860561`,26.9020849112695`}},{13.962634015954636`,{11.551348682099064`,0.10062724010185253`},{11.437582168493313`,1.3262327201653148`},{11.551348945155917`,19.617800087853585`}},{12.566370614359172`,{2.811203402757392`,0.081670562741579`},{2.691077116764632`,1.0071514882246273`},{2.8112035796515915`,12.896898121824044`}},{11.423973285781067`,{5.16543682941433`,0.14216499044278194`},{5.307174017290374`,1.563811401637257`},{5.165437439212842`,18.55355171718381`}},{10.471975511965978`,{26.708750579336108`,0.15485567502682338`},{28.661015851184615`,1.63992962795615`},{26.70850830644632`,16.986822854799808`}},{9.666438934122441`,{25.324274906235225`,0.13671412348853496`},{25.166761775964332`,1.318346405860858`},{25.324290681550607`,12.77458469445744`}},{8.975979010256552`,{9.563553564239262`,0.14806155205210367`},{10.086115559952612`,1.37493882804544`},{9.563589080444576`,11.928933186898007`}},{8.377580409572783`,{29.735222010353777`,0.13520222269329618`},{19.026177502758163`,1.1379091384459696`},{29.73486680665803`,9.482802805729948`}},{7.853981633974483`,{5.728021413955173`,0.10942397638349424`},{6.330665808909197`,0.8586229241039957`},{5.7280214706290895`,6.7498210038135555`}},{7.391982714328925`,{27.523262643579315`,0.3272393467042734`},{28.16507514477718`,2.37542142687426`},{27.52326298922477`,17.8808188234095`}},{6.981317007977318`,{25.78771406644347`,0.2574540403376049`},{24.676895490224254`,1.8244778413788505`},{25.787624944433073`,12.547920011562036`}},{6.613879270715354`,{30.3413358137889`,0.283328339220434`},{29.628707322526132`,1.8770385669698169`},{30.341359446018753`,12.394047591833159`}},{6.283185307179586`,{4.830688315729515`,0.18864105484488414`},{4.607410417274327`,1.2728934567768977`},{4.830691564572274`,7.447250354608738`}},{5.983986006837702`,{4.43556775297075`,0.168708403532935`},{4.643925809999789`,1.1070086411820608`},{4.435576694637336`,6.041125651576433`}},{5.711986642890533`,{4.50623886509594`,0.15044952551452814`},{4.287853035803823`,0.8677659180312416`},{4.506234817772001`,4.908687000605067`}},{5.463639397547467`,{13.926506001453816`,0.21089576545937982`},{13.633014977071216`,1.2262261745640404`},{13.926508375621214`,6.295524386509608`}},{5.235987755982989`,{29.82615775166394`,0.26751491587341375`},{24.75433015783728`,1.4319279002611536`},{29.826193805473793`,7.33404010001721`}},{5.026548245743669`,{7.306244370241474`,0.14353311710256908`},{6.987421175076548`,0.7404511457287619`},{7.306243674394907`,3.6265346357107515`}},{4.8332194670612205`,{29.763151355190132`,0.19379176373049808`},{29.438450410065624`,0.9263277616470565`},{29.763101834838217`,4.526987805785862`}},{4.654211338651545`,{23.090157846895504`,0.18198062816442195`},{24.74507530259942`,0.8942983523073179`},{23.09015924909071`,3.942005975858274`}},{4.487989505128276`,{29.890941693552584`,0.18700291000641572`},{30.241369890420653`,0.832018039563208`},{29.891087184758554`,3.76793906262929`}},{4.333231246330749`,{14.001884103920002`,0.153033576073831`},{14.33342337508077`,0.6948047755565702`},{14.001884164795637`,2.8734950885744883`}},{4.188790204786391`,{30.128180017649925`,0.19041371759125245`},{29.753624959697063`,0.7881778663563699`},{30.128153401677658`,3.340976670942857`}},{4.053667940115862`,{9.310608548206131`,0.18070719630324014`},{8.906588668681767`,0.7427488622826095`},{9.31059602408129`,2.9694180658837954`}},{3.9269908169872414`,{9.462003244046144`,0.20509914971542048`},{9.87835748158938`,0.7889742241327369`},{9.46200479003668`,3.162885942170186`}},{3.8079910952603555`,{26.19130947539261`,0.24826521353431996`},{26.565142571113444`,0.99174165534761`},{26.191300725118264`,3.6000386612115474`}},{3.6959913571644627`,{19.14617218986029`,0.2638386290937275`},{19.577261297461863`,1.0180775110052678`},{19.14617270789474`,3.6041284130577234`}},{3.5903916041026207`,{20.349401820051785`,0.26172305320676326`},{20.820700826712496`,0.9837701344409164`},{20.349432574434317`,3.3738551445663165`}},{3.490658503988659`,{26.98952287317934`,0.2603218210826254`},{26.540537185719547`,0.9522073114523943`},{26.98952625994719`,3.171943571449683`}},{3.396316382259236`,{24.740460166566717`,0.23146667675327223`},{26.102649278448958`,0.8154787907290219`},{24.74085038374863`,2.6708342635463573`}},{3.306939635357677`,{11.933575862738971`,0.23286988108655246`},{11.626208231812148`,0.8152612607002601`},{11.93354917205983`,2.5466299650438464`}},{3.222146311374147`,{12.00710712737481`,0.24413925160767652`},{11.644524141217468`,0.9316339082411571`},{12.007072653303826`,2.534707484565872`}},{3.141592653589793`,{12.135798367410404`,0.25184999978469325`},{11.6688564632413`,1.0056252689697136`},{12.160408916051065`,2.479336233391083`}},{3.0649684425266277`,{24.724526404899688`,0.30471621222781387`},{11.697377751849368`,0.971802139204974`},{24.72450134271498`,2.8625138843761135`}},{2.991993003418851`,{25.06839106375413`,0.33727967630594013`},{27.741591142858258`,1.021507033551751`},{25.06839147486749`,3.019335129845942`}},{2.922411770781203`,{26.601141240590454`,0.3048808255597061`},{27.102660316937072`,0.9155421976436362`},{26.601141819299055`,2.6038318039139337`}},{2.8559933214452666`,{6.46432982525794`,0.2718242348031398`},{5.893139105211799`,0.766415673388886`},{6.4643258528217435`,2.2171881106572915`}},{2.792526803190927`,{6.521539381749087`,0.2984185634924954`},{5.921882072192372`,0.8127168090407504`},{6.523056306012744`,2.3275075697082603`}},{2.7318196987737333`,{6.578445504452053`,0.32211616750031524`},{6.053993790251653`,0.8622639078954921`},{6.578457963235768`,2.403901304689179`}},{2.673695875395569`,{6.632530257161158`,0.34174911508923705`},{6.066741816806533`,0.9081768299705612`},{6.632550450487418`,2.443044690257595`}},{2.6179938779914944`,{6.6977517092065995`,0.3576490393666992`},{6.079862830187795`,0.9321847522464434`},{6.697754313035053`,2.4512878702211536`}},{2.564565431501872`,{6.761115398252852`,0.37042645047002587`},{7.373159818389868`,0.9456492579879671`},{6.759999999999994`,2.4363965693998555`}},{2.5132741228718345`,{6.827229843072652`,0.37997380987285784`},{6.192215946384127`,0.948441917410735`},{6.827235570766336`,2.400122361922385`}},{2.463994238109642`,{6.914702176778398`,0.3878236045799387`},{11.645120277152229`,1.0891207135378267`},{6.914690516375835`,2.35458088618851`}},{2.4166097335306103`,{26.750992375994887`,0.42581515650379254`},{11.67194220562625`,1.224874185285292`},{26.750923495286212`,2.486761569715476`}},{2.3710133234639947`,{27.125932943500132`,0.5167083545595259`},{26.47179965610552`,1.2766365101820019`},{27.12593605968777`,2.904781516777605`}},{2.3271056693257726`,{28.89268332066937`,0.5689953812291244`},{28.17343047172891`,1.3188749877877242`},{28.892682815962015`,3.0813494213660872`}},{2.284794657156213`,{22.444271046720036`,0.6110862059532002`},{21.80955150597806`,1.4641332282295638`},{22.44427096010116`,3.19004512248321`}},{2.243994752564138`,{22.73531345671152`,0.6352050225317732`},{20.66197088617488`,1.4332415942987953`},{22.739999988320058`,3.203317026148034`}},{2.2046264235717845`,{21.60309911211455`,0.6410942463594796`},{20.949746666691205`,1.380437115724735`},{21.602962076040182`,3.1159708724852875`}},{2.1666156231653746`,{24.805300349406576`,0.6162587334841668`},{21.19416701427904`,1.381078583345315`},{24.805285729157095`,2.8928561238369817`}},{2.1298933244676563`,{26.645569430887043`,0.5958632089456126`},{19.95637033876469`,1.3038113676210328`},{26.64546985745689`,2.7030990433184465`}},{2.0943951023931957`,{26.965690785767116`,0.581965328166944`},{26.319818727581904`,1.2021733172139208`},{26.965644440198105`,2.552785383580132`}},{2.0600607564523234`,{27.30365548830863`,0.533006778677156`},{26.51926690054161`,1.1480819132860947`},{27.303644544980553`,2.2620009887015327`}},{2.026833970057931`,{13.773655072011296`,0.4946821116116192`},{12.92444227043683`,1.040872649816617`},{13.773659894121527`,2.0321817885192495`}},{1.9946620022792338`,{13.888669131311136`,0.4529607753311181`},{10.18963880435078`,0.955595532834192`},{13.888669168189416`,1.8021843919231026`}},{1.9634954084936207`,{9.441644928383285`,0.41991204700849794`},{10.205307846685118`,0.9218858780866248`},{9.441331519752632`,1.6188994018945393`}},{1.9332877868244882`,{9.507795680261`,0.4046749300672676`},{8.756948235387675`,0.876401121453082`},{9.500505877063398`,1.5128785644447917`}},{1.9039955476301778`,{9.599983958907755`,0.3851639371565919`},{5.444553346904767`,0.8476582782240975`},{9.599999993349446`,1.3972479238578641`}},{1.8755777036356975`,{9.69398188809889`,0.36713127209921054`},{5.5610629762120665`,0.8074057440597848`},{9.693980676464168`,1.2914913731673765`}},{1.8479956785822313`,{5.034362497671189`,0.35896781595297694`},{4.325187853560199`,0.7850307338367354`},{5.034257909179212`,1.2259073500956221`}},{1.821213132515822`,{5.049474540558119`,0.3596668310193156`},{4.327547806362082`,0.7850220037087249`},{5.049280599227627`,1.1929518788764002`}},{1.7951958020513104`,{5.0621564663857175`,0.35916555372220604`},{4.329770529786237`,0.7831430480021583`},{5.062160908905648`,1.1574928755439426`}},{1.7699113541350948`,{5.074457356202768`,0.35750161769369915`},{4.331863007080836`,0.779590554668232`},{5.074473042447986`,1.1199046356291489`}},{1.7453292519943295`,{5.087230392548921`,0.3547738416536851`},{4.333800996192867`,0.7745338921979437`},{5.087346160869034`,1.0807039612525855`}},{1.7214206321039962`,{5.100628076250672`,0.3510949004649566`},{4.33562776830874`,0.7681499823599867`},{5.100628698404477`,1.0403956462511996`}},{1.698158191129618`,{5.114910721349933`,0.34657351357310656`},{4.33731264190932`,0.7605888777971899`},{5.115088883268454`,0.9994260469761127`}},{1.6755160819145565`,{5.130577542301043`,0.341322399094393`},{4.338871805167975`,0.752001928196259`},{5.130597859245255`,0.9582142368647208`}},{1.6534698176788385`,{5.148576374116758`,0.3354646039043783`},{4.3403111420607`,0.742521536973919`},{5.148226475923766`,0.9171492673814503`}},{1.6319961836830095`,{5.169879187910777`,0.3291406172748425`},{4.341637646721678`,0.7322695930248214`},{5.16988757611632`,0.8766369192190365`}},{1.6110731556870734`,{5.187636824326213`,0.3224058312282085`},{4.342853822463703`,0.7213674240596023`},{5.187646233641077`,0.8368226187167684`}},{1.590679824602427`,{5.202153979511764`,0.31520508130583047`},{4.343963724956049`,0.7099204516408398`},{5.202140315084816`,0.7975515353090386`}},{1.5707963267948966`,{5.214402793905132`,0.30752545765814954`},{4.344979877631965`,0.6980223515570638`},{5.21441306779916`,0.7587886530807912`}},{1.5514037795505151`,{30.014548558215218`,0.32671615220952416`},{4.345889295421081`,0.6857553097341929`},{30.01275790440665`,0.7863541543648416`}},{1.5324842212633139`,{30.26049545829948`,0.34494938423267274`},{4.346714739182303`,0.6732213743395695`},{30.26158881042522`,0.8101076361658394`}},{1.5140205559468882`,{30.503829591840343`,0.34754674922525775`},{4.347467881665697`,0.6604629439808624`},{30.504458572428394`,0.796665029971099`}},{1.4959965017094254`,{30.74854768520128`,0.33504167843336763`},{4.34812798571883`,0.6475651731008045`},{30.749950201334375`,0.7498351766568846`}},{1.478396542865785`,{30.999077460315835`,0.3087863397292399`},{4.348724596558738`,0.6345641906522786`},{30.99569157840405`,0.6748923734214839`}},{1.4612058853906016`,{14.355569329101796`,0.2889356035367961`},{4.349236281144281`,0.6215567099413146`},{14.355559508764076`,0.6169128036774341`}},{1.444410415443583`,{18.951404447277927`,0.29990960157024055`},{4.349682315386385`,0.6085475811258`},{18.951407764391938`,0.6257078342925289`}},{1.4279966607226333`,{19.12322539812873`,0.31304039969540987`},{4.884005891659584`,0.5985131824643989`},{19.123221497476976`,0.6383439889399101`}},{1.411951754422379`,{19.220639606840223`,0.3204095301029276`},{4.884513844808229`,0.5961429110999479`},{19.220639558028267`,0.638770924558197`}},{1.3962634015954636`,{19.39592534197567`,0.32413933004232215`},{4.884992662437064`,0.5930560289326304`},{19.395637346982085`,0.6319287435589592`}},{1.3809198477317772`,{19.588893388013165`,0.3259672306279019`},{4.885441834508824`,0.5892933576576143`},{19.588256219607292`,0.6216104010471275`}},{1.3659098493868667`,{19.68157233528033`,0.3269535885927733`},{4.885862834009246`,0.5849380624515818`},{19.68487845736638`,0.609988725122127`}},{1.3512226467052875`,{19.755063395299196`,0.32020338199535486`},{4.886256826000475`,0.5800598032991012`},{19.755064646069332`,0.5846281804909526`}},{1.3368479376977844`,{19.838527313314472`,0.3062463574488286`},{4.88662513136117`,0.5747146676971139`},{19.837186633337637`,0.5473103596111639`}},{1.3227758541430708`,{30.065823740967005`,0.32982107381406156`},{4.886968709905556`,0.5689601977903127`},{30.06329661649733`,0.577103877370104`}},{1.3089969389957472`,{30.26989298675921`,0.36043505361004763`},{4.887288840580568`,0.5628521422636104`},{30.26991568241256`,0.617597867805478`}},{1.2955021251916674`,{30.458222808870506`,0.38315362600832326`},{4.887586558319293`,0.5564388427691112`},{30.45745264412629`,0.6430562872377044`}},{1.282282715750936`,{30.634125993298703`,0.3972653083862175`},{4.887863001749326`,0.5497607754674513`},{30.63581943564514`,0.6532312569367701`}},{1.269330365086785`,{30.79903249489891`,0.40265267230385454`},{4.888119537839989`,0.542871370753297`},{30.79840308916633`,0.6487585230808909`}},{1.2566370614359172`,{30.953204852148776`,0.3995650762747579`},{4.888356368990984`,0.5357867146557577`},{30.949071246895993`,0.6309722860206955`}},{1.2441951103325914`,{31.09565201941787`,0.38875397759952235`},{4.88857554670509`,0.5285560289377286`},{31.096023323899466`,0.6018034770809637`}},{1.231997119054821`,{31.18`,0.3707344668567453`},{4.8887776481353695`,0.5212109402388329`},{31.18`,0.5627070397116264`}},{1.2200359819766187`,{31.18`,0.34224530795558195`},{4.888963295680206`,0.5137761457138142`},{31.18`,0.5094279645811057`}},{1.2083048667653051`,{31.18`,0.30815321936549916`},{4.889133953398316`,0.5062790926451904`},{31.18`,0.4499039008963884`}},{1.1967972013675403`,{3.9732616869222688`,0.28330450886428327`},{4.889290487953189`,0.498747513168806`},{3.973261665665218`,0.40578371757729215`}},{1.1855066617319974`,{3.9837830886231314`,0.28236801168512377`},{4.889433416557933`,0.49118612131496353`},{3.983783005379865`,0.39684735791456655`}},{1.1744271602204834`,{4.004459673300688`,0.28141689916895685`},{4.889563625223943`,0.4836377547315621`},{4.004459828930802`,0.3881524628074712`}},{1.1635528346628863`,{4.021349252967155`,0.2804963390169612`},{4.889682910842402`,0.47610539602900165`},{4.021351721845979`,0.3797514267678835`}},{1.152878038014603`,{4.031818704796113`,0.2795530157460612`},{4.889790272463546`,0.46860457184290116`},{4.031824558806177`,0.37156167661389083`}},{1.1423973285781066`,{4.039979353725221`,0.2785628752126395`},{4.889888301480345`,0.4611486092359044`},{4.039617303299738`,0.36423046883625304`}},{1.1321054607530787`,{4.04768304121923`,0.2775352630423741`},{4.889973112053952`,0.45376255751356387`},{4.047682962509408`,0.35570661518708935`}},{1.121997376282069`,{31.18`,0.2948879333695268`},{4.890051441105877`,0.4464442332687236`},{31.18`,0.37122796492500343`}},{1.1120681959609888`,{31.18`,0.316666731729912`},{4.890120849271338`,0.4392116316081999`},{31.18`,0.3916203767449446`}},{1.1023132117858923`,{28.80132357490236`,0.34848656033917685`},{2.926296462256954`,0.438410472431536`},{28.80133341711884`,0.4234444009900862`}},{1.0927278795094932`,{28.861357517976906`,0.3807986723815653`},{30.358866899795803`,0.4465131525023842`},{28.859999867934086`,0.45470469396460067`}},{1.0833078115826873`,{28.972408952944026`,0.41145130390240037`},{30.451566011485774`,0.47845543879727187`},{28.97119516673454`,0.4828624333559191`}},{1.074048770458049`,{29.146770700826124`,0.44182432220392404`},{30.554724523414347`,0.5068515707082463`},{29.146771375010978`,0.5096800379753554`}},{1.0649466622338282`,{29.237345359902953`,0.4711336028331701`},{30.666215999973282`,0.5311169978691893`},{29.23548198513946`,0.5343202087893548`}},{1.055997530618418`,{29.34276106000557`,0.49668558702141963`},{30.78456806742644`,0.5507872108719625`},{29.34193951699449`,0.5538763661033418`}},{1.0471975511965979`,{29.454499466750793`,0.5182167732432678`},{30.90887850881108`,0.5656316403787431`},{29.450921672212132`,0.5682861734175818`}}}},{0.01`,{{125.66370614359172`,{2.385457414864702`,0.00025841076895110915`},{2.402177207337578`,0.026631728497942177`},{2.3853001084534173`,4.081059431158834`}},{62.83185307179586`,{4.780372895679909`,0.001594041915805217`},{9.457735522540874`,0.06433247087343089`},{4.873787321783348`,6.345541547879676`}},{41.88790204786391`,{4.66591916156131`,0.008577174499670524`},{4.780143179225581`,0.36909174815109613`},{4.665438266756355`,15.052156447867`}},{31.41592653589793`,{5.713977391155923`,0.009213221203042965`},{3.2316733984534403`,0.38906838453673953`},{5.713308568372026`,9.09443806031449`}},{25.132741228718345`,{2.4976476622543418`,0.017519464048421123`},{2.7977560722497525`,0.43623325515956235`},{2.4971086362468395`,11.066125106695194`}},{20.943951023931955`,{2.546136690755`,0.019495349748779433`},{2.4761620330471943`,0.40051686244151585`},{2.5451632401082827`,8.55337503052368`}},{17.951958020513104`,{11.62308512164398`,0.030497696212519194`},{10.494370318170732`,0.5062421104866088`},{11.622001688084534`,9.830567326549112`}},{15.707963267948966`,{5.051457287705296`,0.04817952769467565`},{4.95184443776301`,0.7155532172211923`},{5.050181276922707`,11.88982477429957`}},{13.962634015954636`,{4.774251014212992`,0.05881926619665364`},{4.668121732016121`,0.8163598583262496`},{4.772685204189756`,11.47406774338799`}},{12.566370614359172`,{2.81029129540006`,0.07233591115675109`},{2.6900604332890907`,0.9031464268774526`},{2.8086956348191974`,11.42507701481362`}},{11.423973285781067`,{5.170451267327102`,0.11274557290028243`},{5.313183076863256`,1.213414506989959`},{5.1686980293586355`,14.716952269171378`}},{10.471975511965978`,{3.9492212758937817`,0.084627152181968`},{2.294823221130462`,0.9675345595668977`},{3.9472954455934204`,9.281859692833251`}},{9.666438934122441`,{17.18765435877359`,0.09447901302860774`},{17.681005222969993`,0.9067909531278431`},{17.185556854279568`,8.8298356984632`}},{8.975979010256552`,{9.218616823363122`,0.10326722156021453`},{8.696662813746947`,0.9557198844100259`},{9.216427635201109`,8.321803654416266`}},{8.377580409572783`,{12.461876700914635`,0.10572464747186008`},{12.277607011593133`,0.8922082905023038`},{12.459488748397273`,7.421653209014173`}},{7.853981633974483`,{5.744494687409291`,0.10046323606088015`},{6.3422166726499105`,0.7533289881667922`},{5.740288696185816`,6.198717307483873`}},{7.391982714328925`,{5.841118185842177`,0.16821552931351078`},{6.044722014016828`,1.2114626960970447`},{5.8380691427519045`,9.193871081843577`}},{6.981317007977318`,{5.9577251842399805`,0.18436773131647116`},{5.733155035226524`,1.2725318926154885`},{5.954879326636738`,8.987707464518452`}},{6.613879270715354`,{4.755171659503363`,0.1680591550728218`},{4.943401945721021`,1.112826505367984`},{4.752133797927566`,7.353025680831531`}},{6.283185307179586`,{4.826491916851905`,0.16872416062553766`},{4.605291460864713`,1.1592103517446826`},{4.82323437766694`,6.662899370472793`}},{5.983986006837702`,{4.430522606255935`,0.15350581974092778`},{4.638609444368936`,1.0181144284852817`},{4.427159382565686`,5.497998159547604`}},{5.711986642890533`,{4.498250360918927`,0.13698631676300135`},{4.284503806325774`,0.7900947969232269`},{4.494774368610245`,4.470501841016093`}},{5.463639397547467`,{13.387380844511691`,0.14772053976807065`},{13.635075593883613`,0.8431066903675783`},{12.20051910345561`,4.394095561940075`}},{5.235987755982989`,{17.867430022212773`,0.16233255110269834`},{17.56086567669101`,0.8494214959142282`},{17.863617498896446`,4.4513423661373475`}},{5.026548245743669`,{6.047854082503453`,0.12460509771632272`},{6.980424821019064`,0.6538560476410292`},{6.043934486941268`,3.148821934911348`}},{4.8332194670612205`,{18.050973103149733`,0.11236037653515472`},{17.73228315908787`,0.5570255190546579`},{18.046816519872472`,2.6253096945639776`}},{4.654211338651545`,{14.363381411999333`,0.1271546219043293`},{15.382525165741`,0.6144067301843478`},{14.359090914998001`,2.754953470583676`}},{4.487989505128276`,{14.491109222921644`,0.13457348328917493`},{14.134856587410995`,0.608945573505769`},{14.486571006935511`,2.7111589807116507`}},{4.333231246330749`,{13.994378458957616`,0.11886958208130242`},{11.639026406270704`,0.5883833989339033`},{13.989845352043831`,2.232708652814706`}},{4.188790204786391`,{8.408867839498583`,0.13166395187623522`},{11.680254475828916`,0.6257600121282723`},{8.404081466197526`,2.310692240368391`}},{4.053667940115862`,{9.317219626431363`,0.15358165818914624`},{8.907044559653041`,0.6419356519188089`},{9.312113021808258`,2.52421188958114`}},{3.9269908169872414`,{9.464559134144611`,0.17492072076244455`},{9.120087691860173`,0.6784072781145446`},{9.459364028460671`,2.6979614546743402`}},{3.8079910952603555`,{9.594450544557938`,0.18675644285997853`},{9.188259210206272`,0.7274324363288366`},{9.589266409963733`,2.708793834204564`}},{3.6959913571644627`,{14.028522969255322`,0.19197697301952282`},{14.403255137660516`,0.7042780065103318`},{14.023059855331457`,2.623232101618341`}},{3.5903916041026207`,{13.34407427338231`,0.1938640353135541`},{12.908508075352264`,0.7492501431022607`},{13.338758173414334`,2.500705378968128`}},{3.490658503988659`,{11.810582147638554`,0.19302451416388558`},{13.93512090388288`,0.6941016843267543`},{11.804912039436761`,2.3526531348245454`}},{3.396316382259236`,{11.870943066278144`,0.20223029274557539`},{12.239901246705054`,0.6346768630749499`},{11.865029623323428`,2.3333822635663424`}},{3.306939635357677`,{11.93273235410495`,0.20935398674994135`},{11.628979120884214`,0.7561704151340745`},{11.926668444939379`,2.2900830946884874`}},{3.222146311374147`,{12.004272359640655`,0.21446718865765987`},{11.646345829617477`,0.8511160957295099`},{11.997997088479424`,2.227160187558409`}},{3.141592653589793`,{11.191190505726654`,0.2149657716741619`},{11.667833945073525`,0.9002671050006327`},{11.184631394463105`,2.1219784156191173`}},{3.0649684425266277`,{11.349249375928782`,0.23224050386472841`},{11.691744171910406`,0.8596342510554684`},{11.342677722944106`,2.1821132875223164`}},{2.991993003418851`,{11.447259887827633`,0.24128191766920828`},{11.771183359674993`,0.723402521925948`},{11.440587654083952`,2.1605788528011693`}},{2.922411770781203`,{6.424308009392592`,0.22848084368472832`},{5.886791932102186`,0.670404247202518`},{6.417472079009358`,1.951741848043054`}},{2.8559933214452666`,{6.472773619750169`,0.25422648128919395`},{5.8938775034141155`,0.7267330926205297`},{6.465754880428119`,2.0740673083504233`}},{2.792526803190927`,{6.528048962363015`,0.2777846100363978`},{5.92237613975635`,0.7666874023261405`},{6.520985584265401`,2.166637436017916`}},{2.7318196987737333`,{6.58190958410863`,0.2987530539010967`},{6.054868208734165`,0.8118712684115245`},{6.574679029547215`,2.2300537999953165`}},{2.673695875395569`,{6.6338599146522075`,0.31601981721055455`},{6.066554040708941`,0.8526795758044198`},{6.626297163274959`,2.2596106440870294`}},{2.6179938779914944`,{6.697518560331951`,0.3299381908980414`},{6.0786229521916075`,0.8739467845865847`},{6.690119706920235`,2.261812146578001`}},{2.564565431501872`,{6.759097863918758`,0.34105311476227623`},{6.174210001985157`,0.877837364986905`},{6.75127440080937`,2.243565995994919`}},{2.5132741228718345`,{6.823328813511696`,0.34922394934485484`},{6.189834554608177`,0.8858012934093605`},{6.8152455452302485`,2.2063206446446517`}},{2.463994238109642`,{6.908954878273324`,0.35577032518662954`},{11.650926782170636`,0.9479539921575049`},{6.90089345272784`,2.1602405307755017`}},{2.4166097335306103`,{6.993431394287635`,0.36383140440845574`},{11.67310338459486`,1.0598366665727912`},{6.985266402969271`,2.1252427018479687`}},{2.3710133234639947`,{11.191407870340798`,0.39695004883762874`},{11.696382960204645`,1.0743409779643025`},{11.182656837010725`,2.231912847354422`}},{2.3271056693257726`,{11.353354058885088`,0.4390360622640367`},{11.78241560322211`,1.0226584133337593`},{11.344821595036976`,2.378031638732595`}},{2.284794657156213`,{11.445674077214035`,0.47401470547687935`},{21.812430919740347`,1.0733220434914357`},{11.437203469768821`,2.475179928988075`}},{2.243994752564138`,{11.520536073297174`,0.49124163397818565`},{20.6617558237228`,1.0607925333330408`},{11.511669478358046`,2.4743868304877683`}},{2.2046264235717845`,{11.586933369068861`,0.4888456036755562`},{13.906203357038262`,1.0872025984265439`},{11.577810145836027`,2.3768436255442458`}},{2.1666156231653746`,{13.231407781201531`,0.4888774158537622`},{13.93264592276927`,1.113187086544158`},{13.222448596253074`,2.2955236888902713`}},{2.1298933244676563`,{13.34195167664555`,0.48213572464895904`},{11.285764700233855`,1.0455438751420738`},{13.338337092556543`,2.1877513117816303`}},{2.0943951023931957`,{13.46349307146561`,0.4630539412657888`},{11.317104991196027`,1.05203542670434`},{13.453622610091488`,2.0315529056757136`}},{2.0600607564523234`,{13.63752133605337`,0.4443054320238306`},{11.345981698127988`,1.0132822449047356`},{13.628152123050619`,1.8860561939033484`}},{2.026833970057931`,{13.739813641075884`,0.41711291881166646`},{11.371463038426418`,0.9361688499002939`},{13.719959724779933`,1.7157008331126955`}},{1.9946620022792338`,{9.35317830790081`,0.38684004821283097`},{5.435278327899166`,0.9120675175594142`},{9.34378062169659`,1.5396440217912408`}},{1.9634954084936207`,{9.421423180780698`,0.37604156612791256`},{5.4379819596256125`,0.8856742634227079`},{9.411798850236142`,1.4500044608644993`}},{1.9332877868244882`,{9.492027085280577`,0.36261267970237865`},{5.440376589428504`,0.8556959384910385`},{9.482023513304778`,1.3557098014151938`}},{1.9039955476301778`,{9.556509395264317`,0.34483394763368996`},{5.44247181305671`,0.8228356130772276`},{9.545210799552134`,1.2503491768689716`}},{1.8755777036356975`,{5.010313391122076`,0.3414321729392526`},{5.444276990068557`,0.7877330004229179`},{5.000622443150652`,1.2022084108701536`}},{1.8479956785822313`,{5.029951695673103`,0.343408006913458`},{4.3241460056596575`,0.7625708917670414`},{5.0199999570894445`,1.1732139018906391`}},{1.821213132515822`,{5.045238646422138`,0.34431648164585893`},{4.326423925009726`,0.7632540566850776`},{5.034863390873597`,1.1425651427306027`}},{1.7951958020513104`,{5.057991017242283`,0.34410163184467774`},{4.328577112565306`,0.7621419123874165`},{5.04742341878846`,1.1095448657354252`}},{1.7699113541350948`,{5.069578804695147`,0.34277539406859797`},{4.330601398616691`,0.7594016937587651`},{5.058102154008511`,1.0744110051891274`}},{1.7453292519943295`,{5.081514981708786`,0.34040822868383924`},{4.332498884489562`,0.7551850523671283`},{5.069639665156295`,1.0375323991622958`}},{1.7214206321039962`,{5.093954631366913`,0.3371316466628637`},{4.334278553835702`,0.7497060397891911`},{5.082014099805144`,0.9995528815917933`}},{1.698158191129618`,{5.1070424543992585`,0.33301412026198596`},{4.33592282315501`,0.7430558907399922`},{5.094621704175347`,0.9608088315174628`}},{1.6755160819145565`,{5.121104751806296`,0.32816240118784523`},{4.337462408084212`,0.7353836760830084`},{5.108666347732625`,0.9216876434601919`}},{1.6534698176788385`,{5.1367466331475296`,0.32268187065816284`},{4.3388699166504665`,0.7268331123192752`},{5.123615595582211`,0.8825582755964003`}},{1.6319961836830095`,{5.155127661602155`,0.3166931982586236`},{4.3401802340841575`,0.7175168262029111`},{5.142302267461763`,0.843764553946188`}},{1.6110731556870734`,{5.17523106241941`,0.3103166269705992`},{4.341386238219734`,0.7075378132915053`},{5.16372147530253`,0.8056941730076512`}},{1.590679824602427`,{5.191160554210459`,0.30355070761057545`},{4.3424956624629605`,0.6970061064034357`},{5.1794009056886665`,0.7683575510642013`}},{1.5707963267948966`,{5.204307526911092`,0.2963538287313758`},{4.343504569817466`,0.6860090854888402`},{5.192339662491138`,0.731554254420734`}},{1.5514037795505151`,{5.215519489939567`,0.2887375618223926`},{4.344433540206185`,0.6746367311783189`},{5.203334569353498`,0.6953090576329504`}},{1.5324842212633139`,{5.225420666704878`,0.28070616407322885`},{4.345271526656489`,0.6629559635632617`},{5.2128413519972945`,0.6596233854839431`}},{1.5140205559468882`,{5.235388836630135`,0.27230854367608875`},{4.346012847154831`,0.6510452080143269`},{5.221419121409645`,0.6245707949723844`}},{1.4959965017094254`,{3.8368601602387473`,0.2678575985340987`},{4.346691301656886`,0.6389655283582835`},{3.8265297890796695`,0.5995757003020868`}},{1.478396542865785`,{3.8510322051622294`,0.27002637927989065`},{4.347312766543681`,0.6267700340143347`},{3.8396357759167166`,0.5903640370909502`}},{1.4612058853906016`,{3.8613061410479377`,0.27202980136788385`},{4.347847686084543`,0.6145154186280232`},{3.8495670746603228`,0.5810436680944566`}},{1.444410415443583`,{3.869668563983802`,0.2738400368323357`},{4.348329603704579`,0.6022509638365553`},{3.857953147067402`,0.5715915093128656`}},{1.4279966607226333`,{3.8768209961829534`,0.27545154991912524`},{4.348742996432333`,0.5900072365787569`},{3.863676229188874`,0.5620052265594373`}},{1.411951754422379`,{3.883119602729074`,0.27685830623835994`},{4.884170578216907`,0.578808368442232`},{3.870171792981849`,0.552281916728304`}},{1.3962634015954636`,{3.888749418411098`,0.2780630416698896`},{4.88463769213469`,0.5763740333575023`},{3.8757340813773404`,0.5424628189442651`}},{1.3809198477317772`,{3.8938596314692933`,0.27908015298204697`},{4.885077399522359`,0.5732910457263884`},{3.8806418300453456`,0.532578019427542`}},{1.3659098493868667`,{19.671135829764356`,0.2782725200220592`},{4.885490968526334`,0.5696113526912336`},{3.8851398925056193`,0.5226354697311493`}},{1.3512226467052875`,{3.902900411578924`,0.2805519161652868`},{4.885878879173191`,0.5654047174654572`},{3.8892125533137967`,0.5126633690716842`}},{1.3368479376977844`,{3.907287004410471`,0.2810260261737596`},{4.886242469277723`,0.5607271695033084`},{3.893009330686034`,0.5026840262939889`}},{1.3227758541430708`,{3.9117230047848484`,0.281333826548744`},{4.886582535832737`,0.555631725342278`},{3.896527197359899`,0.49270805135294116`}},{1.3089969389957472`,{30.317697426014277`,0.2889968906947967`},{4.886900128871584`,0.5501795067742665`},{30.29999998539902`,0.495292002493637`}},{1.2955021251916674`,{30.485223940048602`,0.3110681985796336`},{4.887196761455576`,0.5444085581655789`},{30.46943858459077`,0.5221680179594427`}},{1.282282715750936`,{30.642491091836597`,0.32611140557330914`},{4.887472766421412`,0.5383583158031282`},{30.62932283966019`,0.5363027528793425`}},{1.269330365086785`,{30.79033994502661`,0.33415540833900176`},{4.887729704230519`,0.5320814845333183`},{30.777790483573824`,0.5384920419888497`}},{1.2566370614359172`,{30.928575343446326`,0.33555989925419066`},{4.88796815558159`,0.5256021959105966`},{30.911322233136335`,0.5299928881856621`}},{1.2441951103325914`,{31.056251886623773`,0.33097229739996653`},{4.888189294271608`,0.5189609349027406`},{31.041084285904965`,0.5124451030026546`}},{1.231997119054821`,{31.171670977168546`,0.3213956746109876`},{4.888393767694823`,0.5121884963596365`},{31.153032645640174`,0.48793915545941174`}},{1.2200359819766187`,{31.18`,0.30609570030128797`},{4.888583115378983`,0.5053096408881524`},{31.18`,0.45666222354772573`}},{1.2083048667653051`,{31.18`,0.2858806717407655`},{4.8887574784944885`,0.4983522699606592`},{31.18`,0.4192193141348343`}},{1.1967972013675403`,{3.9637763432941475`,0.27763584081393666`},{4.888917838830891`,0.49134253604543027`},{3.94252048631069`,0.3978997514707039`}},{1.1855066617319974`,{3.9713967049846515`,0.27677172683935325`},{4.889065904289707`,0.48429183290709743`},{3.9491219886599396`,0.389179826588958`}},{1.1744271602204834`,{3.9808582940417048`,0.2758595778690228`},{4.889201007742484`,0.47723119328989`},{3.957299163255379`,0.3806525026719456`}},{1.1635528346628863`,{3.9963684497128993`,0.2749165183702002`},{4.889323673724713`,0.4701714928665089`},{3.969539532199363`,0.37230947016836446`}},{1.152878038014603`,{4.018014907854728`,0.27400494629007577`},{4.889436461899683`,0.4631260484075793`},{4.005794630917307`,0.3642449194529441`}},{1.1423973285781066`,{4.029147578761072`,0.27308662523400806`},{4.889538934686581`,0.45611182897395575`},{4.015537160544673`,0.3564867272214611`}},{1.1321054607530787`,{4.037547829803292`,0.27213265927509184`},{4.889631747478477`,0.4491485201138781`},{4.023192570691679`,0.34889554367738074`}},{1.121997376282069`,{28.78610090492582`,0.272519049232257`},{4.889716408324446`,0.4422354192010639`},{28.76737294950081`,0.3432125338050235`}},{1.1120681959609888`,{28.808382194733873`,0.2954320606985714`},{2.92564142701687`,0.4379318656518686`},{28.789438098547805`,0.3654931090348778`}},{1.1023132117858923`,{28.849305883671494`,0.31904999173836956`},{2.9257595505436957`,0.43580107233576276`},{28.829778458159407`,0.38778078569476243`}},{1.0927278795094932`,{28.932462769328716`,0.34232430685467163`},{2.925871935794278`,0.4336794753188833`},{28.91452291764541`,0.40881629911784934`}},{1.0833078115826873`,{29.06028329343106`,0.36522909256459474`},{2.9259785185880123`,0.43157276223522306`},{29.038412019406444`,0.4286522861622776`}},{1.074048770458049`,{29.18535822160187`,0.3891839418169978`},{27.7708882817149`,0.4520432975368318`},{29.16211255091273`,0.4490828568405105`}},{1.0649466622338282`,{29.2743455489827`,0.4108428706788442`},{27.77981122552461`,0.47266830075214616`},{29.259999940113687`,0.46606089705285475`}},{1.055997530618418`,{29.370696187589004`,0.42953862916658786`},{27.786430560171038`,0.486461252359786`},{29.349014938820545`,0.47906833832233053`}},{1.0471975511965979`,{29.473518522837292`,0.44500455100880193`},{27.793491301296537`,0.49220340837315885`},{29.448932625866746`,0.48810224947112263`}}}},{0.02`,{{125.66370614359172`,{2.209026496829623`,0.00022594125576410237`},{13.928384122010296`,0.009345343178236784`},{2.208680882970617`,3.5689164865380754`}},{62.83185307179586`,{4.780080790041601`,0.0012322562453514444`},{9.458051016417286`,0.0528700708350439`},{2.44457431707407`,6.237106110118127`}},{41.88790204786391`,{3.5331018265197476`,0.006277520575208196`},{4.783496848496078`,0.2615814533714341`},{4.821863081264537`,12.301752447396922`}},{31.41592653589793`,{4.9997215441095975`,0.009140022846574954`},{3.231613970810846`,0.30761915324019207`},{4.998448278998562`,9.027778473022442`}},{25.132741228718345`,{2.5000652783942328`,0.016065070273654627`},{2.798087852666568`,0.3697393979173594`},{2.4984321469765916`,10.155516313933386`}},{20.943951023931955`,{2.547865230230855`,0.018995067381732587`},{2.4772302211857142`,0.39754116180755106`},{2.5459543788705066`,8.338586020295732`}},{17.951958020513104`,{2.616374906695525`,0.028064661940969696`},{2.516107060337245`,0.4851000966030611`},{2.614195855166249`,9.050220849784981`}},{15.707963267948966`,{2.670565170650894`,0.03591378936469735`},{2.3864062478077623`,0.5203908473446878`},{2.6680267652414584`,8.867739703347215`}},{13.962634015954636`,{2.7295608699093368`,0.053082444229912956`},{2.398475912842853`,0.7309303790495026`},{2.7267011373652554`,10.356751425413673`}},{12.566370614359172`,{2.809222165862366`,0.06428057095875443`},{2.688963690578556`,0.8122226350178925`},{2.806019829691716`,10.158755888824276`}},{11.423973285781067`,{5.175419965838375`,0.09251443425972405`},{5.3195446980163394`,0.9760981095542981`},{5.171907959514976`,12.08303230689914`}},{10.471975511965978`,{2.163783055485474`,0.07894808276041539`},{2.2923111129304465`,0.9161700779847683`},{2.15999295401017`,8.665861754314893`}},{9.666438934122441`,{2.193187891373454`,0.077699965087393`},{2.3215971865952056`,0.7614287836421019`},{2.189084747408462`,7.268188429940822`}},{8.975979010256552`,{5.709820295678981`,0.08574227348808122`},{5.514522184747688`,0.7158706631180835`},{5.705396796828184`,6.912884966020435`}},{8.377580409572783`,{12.454637489431573`,0.08854204780561752`},{12.27068312608979`,0.7557635992260373`},{12.449866406875213`,6.21919030870177`}},{7.853981633974483`,{5.757779209740273`,0.09374717609383013`},{5.965780665736123`,0.7097740304894834`},{5.752665254672652`,5.787309719250456`}},{7.391982714328925`,{5.844634775020227`,0.1473106426172378`},{6.046061846690536`,1.0421923613634236`},{5.839334352899078`,8.055581983965418`}},{6.981317007977318`,{5.953362282801988`,0.15882015915047643`},{5.729102652762047`,1.1082863447436593`},{5.947621077461413`,7.747086684299723`}},{6.613879270715354`,{4.7547836381297595`,0.15118180961055783`},{4.568795188501614`,0.972296941401525`},{4.748775720442922`,6.618911978115694`}},{6.283185307179586`,{4.8224718714047015`,0.15161317636056432`},{4.6034335643498565`,1.060201747029494`},{4.816160257220068`,5.991950946649675`}},{5.983986006837702`,{4.425772679866802`,0.14025577872505973`},{4.6338195157613`,0.9408603696211749`},{4.418988646160251`,5.027053268179452`}},{5.711986642890533`,{4.490350264452681`,0.1253924696537903`},{4.281589622897019`,0.7215727970710591`},{4.483480165196418`,4.094950488100569`}},{5.463639397547467`,{13.407854911603671`,0.10917231524266928`},{11.972124505875044`,0.6222760683667132`},{13.400595360340537`,3.2614221867069677`}},{5.235987755982989`,{5.959099087624516`,0.12081563958700611`},{6.249377006754729`,0.6103924682252512`},{5.951477485110143`,3.3150790178782583`}},{5.026548245743669`,{6.036038502511754`,0.11480654746651657`},{6.975137248715735`,0.5818143347243702`},{6.027952396666901`,2.9026333947427205`}},{4.8332194670612205`,{6.0881377287830745`,0.1004137948889286`},{7.063435723493433`,0.48382108417044645`},{6.080120122676443`,2.3477016959533334`}},{4.654211338651545`,{14.370371414634429`,0.1064672744469015`},{14.685527073049004`,0.5152628956389315`},{14.36183253145838`,2.308198661114157`}},{4.487989505128276`,{14.483625410328111`,0.11216372667425775`},{14.130054640890911`,0.5157622741248719`},{14.47436949791683`,2.261333882058848`}},{4.333231246330749`,{6.0957227909973986`,0.10364283048696085`},{11.64233518110591`,0.5194650461699474`},{6.086823375320349`,1.9479111554895971`}},{4.188790204786391`,{6.119163521756227`,0.11997851936641647`},{11.675156581816712`,0.5298143731384034`},{6.109354352800246`,2.1070981774827544`}},{4.053667940115862`,{8.50864773281522`,0.1327667214430195`},{8.907352325797067`,0.5599064166431089`},{8.524146308785307`,2.1825166789434647`}},{3.9269908169872414`,{9.468226662306899`,0.15059698570026`},{9.12319453492073`,0.593543372345818`},{9.457707478623018`,2.323952159919547`}},{3.8079910952603555`,{9.592535356027104`,0.16241744225792784`},{9.18677741165022`,0.6422422837278061`},{9.58233863025919`,2.3575347572995313`}},{3.6959913571644627`,{9.69107324745799`,0.16042071617115086`},{9.217490390627942`,0.6082654740905112`},{9.679592552505927`,2.1926983169641603`}},{3.5903916041026207`,{10.741737568133482`,0.16119246815612334`},{12.904871690010635`,0.6357323676455183`},{10.730283586675819`,2.079420773453718`}},{3.490658503988659`,{11.812778088880409`,0.17063560242918505`},{12.156892724470287`,0.6057821787682947`},{11.801584718060088`,2.081741592748958`}},{3.396316382259236`,{11.870112699020614`,0.18186757690316557`},{11.617419743263804`,0.594839092763499`},{11.858176265742062`,2.1003348143340124`}},{3.306939635357677`,{11.93100782092525`,0.1878387950724072`},{11.631489564700805`,0.7005394876948182`},{11.918974134139564`,2.0564561597807285`}},{3.222146311374147`,{11.999157180281516`,0.18901017848551663`},{11.647551792429978`,0.7795436731707948`},{11.986240486930546`,1.9642850288334`}},{3.141592653589793`,{11.193194820757986`,0.18969988120269743`},{11.666463071186616`,0.8125730465348782`},{11.179639134374758`,1.873951300901353`}},{3.0649684425266277`,{11.352393535818482`,0.20234294863265306`},{11.68659735612296`,0.7704755299460482`},{11.339954193776775`,1.9022698141727319`}},{2.991993003418851`,{11.442123354337637`,0.20768484719170457`},{11.747790739677757`,0.6431708540669416`},{11.429080131284959`,1.861344409928637`}},{2.922411770781203`,{6.43404803169639`,0.21570811631012593`},{5.8879827533998235`,0.642469914982656`},{6.418814073303125`,1.8438550287398154`}},{2.8559933214452666`,{6.4805903910029246`,0.2383920317987062`},{5.895269870800667`,0.6906700311648387`},{6.466521969839643`,1.946061458677831`}},{2.792526803190927`,{6.534024047930748`,0.2592273198969606`},{5.922471534766821`,0.7252401939246037`},{6.519999992758013`,2.02366815269006`}},{2.7318196987737333`,{6.585038873926339`,0.27773706853446173`},{6.055600731359208`,0.7662833613603763`},{6.570736013526035`,2.074603657860798`}},{2.673695875395569`,{6.635007046162356`,0.29287088957666707`},{6.066338291942745`,0.8024523259368767`},{6.619621412061756`,2.0955114202858103`}},{2.6179938779914944`,{6.697185286481852`,0.305014598305771`},{6.077455401365314`,0.8211978602607284`},{6.682916921086637`,2.092131543366068`}},{2.564565431501872`,{6.757025485156518`,0.31464079909054`},{6.173142368030453`,0.821557258151605`},{6.741344829412046`,2.0711053250938605`}},{2.5132741228718345`,{5.646815447701023`,0.32337972020493727`},{6.187647481456746`,0.8288917101818819`},{5.631482807728444`,2.04549132105054`}},{2.463994238109642`,{5.669862443291152`,0.33483619802243286`},{11.655790119644678`,0.835082279695967`},{5.653676965143718`,2.035994272931008`}},{2.4166097335306103`,{5.696119756573712`,0.34264372116747793`},{11.674097572607524`,0.9261806299000486`},{5.6784985034376945`,2.003717796908844`}},{2.3710133234639947`,{5.729596133709675`,0.34730080253905143`},{11.693571189154946`,0.937428692674115`},{5.711128728160023`,1.9544333742363307`}},{2.3271056693257726`,{11.367802807431673`,0.38320965065718493`},{11.77463698102388`,0.8885652289353845`},{11.351022718229652`,2.076914849609503`}},{2.284794657156213`,{11.449824699518357`,0.414681081983551`},{10.694762716375196`,0.8862110997719719`},{11.432980152014482`,2.167192589762757`}},{2.243994752564138`,{11.517819255734466`,0.43010097839977507`},{10.793467626404695`,0.9067156250100405`},{11.50017589743991`,2.168441836380145`}},{2.2046264235717845`,{11.579010887969964`,0.4283059340090463`},{13.908320983957871`,0.9176329254326129`},{11.561748317546762`,2.0848030314865182`}},{2.1666156231653746`,{13.226711079025225`,0.4162867696080655`},{13.930227409395254`,0.945256547203176`},{13.209512662054776`,1.9561980831545949`}},{2.1298933244676563`,{13.328318916600882`,0.41110986356222895`},{5.420436550885311`,0.9259030065609721`},{13.310550066335805`,1.8665294832975297`}},{2.0943951023931957`,{13.438788568963876`,0.39472575261116577`},{11.313418336955928`,0.9319889603739006`},{13.419999995641481`,1.7351350067388762`}},{2.0600607564523234`,{13.621484034091862`,0.37689930677403877`},{5.427527385946633`,0.9138684491012767`},{13.603838096658052`,1.6008967155610052`}},{2.026833970057931`,{13.70839260252543`,0.3548421857496709`},{5.430686655056401`,0.8991706941965493`},{13.686621669799111`,1.4592825840140278`}},{1.9946620022792338`,{9.344879452144143`,0.3471777871767554`},{5.43356796312822`,0.8796396218307139`},{9.327800791264961`,1.3829123682752105`}},{1.9634954084936207`,{9.396082096124607`,0.3379101130442408`},{5.436167587542021`,0.8559780702700402`},{9.367682956282387`,1.3043405777772876`}},{1.9332877868244882`,{9.476476944782643`,0.32585105025350874`},{5.438485418375274`,0.8288751158344594`},{9.45741186493734`,1.2191948855764847`}},{1.9039955476301778`,{4.9804066941022915`,0.32376274898622653`},{5.440527713702154`,0.7989599992889526`},{4.9577216378876505`,1.1754244455454015`}},{1.8755777036356975`,{5.005174312773138`,0.3266477666723087`},{5.4423038358025995`,0.7668393960800456`},{4.981723079871174`,1.150420518041197`}},{1.8479956785822313`,{5.025624993161429`,0.3287209034627137`},{4.323178392225047`,0.7411179612755915`},{5.007084405987427`,1.1240923351871739`}},{1.821213132515822`,{5.041170868313618`,0.32981007962212977`},{4.325377477624827`,0.7424300642938239`},{5.021681077872529`,1.0957481233696669`}},{1.7951958020513104`,{5.053989563019615`,0.32984526451522406`},{4.32745884982538`,0.7420019931374164`},{5.03415514135705`,1.0651065304073293`}},{1.7699113541350948`,{5.06516583512054`,0.3288304513500668`},{4.329416379455971`,0.7400050663103767`},{5.044792535991274`,1.0324304485587332`}},{1.7453292519943295`,{5.076363858184036`,0.3268186536699985`},{4.331266185995901`,0.7365916088493172`},{5.053818172466202`,0.9979933930697129`}},{1.7214206321039962`,{5.087937856405155`,0.3239012937094768`},{4.332994644459707`,0.7319102830669034`},{5.0628037405182775`,0.9621432300016859`}},{1.698158191129618`,{5.100024186761425`,0.3201673848290444`},{4.334600603900322`,0.7260988606174307`},{5.0743167609451785`,0.9254075716294863`}},{1.6755160819145565`,{5.112824066316289`,0.3157082730714823`},{4.336120549344149`,0.7192874419757878`},{5.086440462503761`,0.8882198854551742`}},{1.6534698176788385`,{5.126672860071068`,0.3106139787369782`},{4.337499461401072`,0.7115990844958436`},{5.099432561158112`,0.8508905478012607`}},{1.6319961836830095`,{5.142252269201129`,0.3049782578833952`},{4.338794362325261`,0.7031438361777044`},{5.114230948659346`,0.8137152921181883`}},{1.6110731556870734`,{5.161115111031295`,0.29891798780854806`},{4.339988537936837`,0.6940362903013699`},{5.130912263019942`,0.7769975498467545`}},{1.590679824602427`,{5.179267128086418`,0.2925217883976646`},{4.3410870392042495`,0.6843620119533379`},{5.155098228707109`,0.7410753623014734`}},{1.5707963267948966`,{5.193690403570544`,0.28575484038807647`},{4.342103183462786`,0.6742046934486955`},{5.171563855363553`,0.706136822134592`}},{1.5514037795505151`,{5.205691252677369`,0.2786125450091931`},{4.343025156179941`,0.6636712813116427`},{5.183015669522095`,0.6717722007361226`}},{1.5324842212633139`,{5.215964344345498`,0.27108671186512473`},{4.343865808679468`,0.6528101183588787`},{5.192821915919283`,0.6379472145666244`}},{1.5140205559468882`,{5.225058655561699`,0.2632048135889337`},{4.344638893424042`,0.6416987362454323`},{5.201316516197473`,0.6047179925500215`}},{1.4959965017094254`,{3.828995951588865`,0.2605958149728339`},{4.345319402575789`,0.6303952286741343`},{3.7964951346224165`,0.5835026677091828`}},{1.478396542865785`,{3.8461296926141526`,0.2627799704112849`},{4.345937051814524`,0.6189593116559695`},{3.8280482674296414`,0.57483144624195`}},{1.4612058853906016`,{3.8572827926652824`,0.26482429581215533`},{4.3464954733145245`,0.6074356100825546`},{3.8372552387467325`,0.5661237519347146`}},{1.444410415443583`,{3.866093326059323`,0.26668691017139046`},{4.346997250609064`,0.595872999889697`},{3.8445614130437398`,0.5572509756789575`}},{1.4279966607226333`,{3.8735141201327465`,0.26835965698753683`},{4.347448218560825`,0.5843089600753106`},{3.851615015197812`,0.5482255692501246`}},{1.411951754422379`,{3.879969384627106`,0.2698367514176765`},{4.347835531732451`,0.5727787336420131`},{3.857493663302572`,0.5390718119580981`}},{1.3962634015954636`,{3.8857285948551485`,0.27112436686787245`},{4.8843091558515495`,0.5602197548764796`},{3.861917723764205`,0.5298015260117382`}},{1.3809198477317772`,{3.890925124429468`,0.27222419029740247`},{4.884739163336836`,0.5577554512191679`},{3.8667116493502003`,0.5204358380452674`}},{1.3659098493868667`,{3.89567022022742`,0.2731409941077519`},{4.885144154167347`,0.5547023419877185`},{3.8712686609057454`,0.511006740945021`}},{1.3512226467052875`,{3.900018291486081`,0.27388046805563776`},{4.885525442084953`,0.5511199638734708`},{3.8753861561612704`,0.501535240041898`}},{1.3368479376977844`,{3.9042197225191955`,0.27445140235702603`},{4.885883593136474`,0.5470673093381228`},{3.878907451979387`,0.4920473485738335`}},{1.3227758541430708`,{3.9084433289665936`,0.2748619658782135`},{4.886219551196843`,0.5425908280364118`},{3.882323157635797`,0.4825518599262728`}},{1.3089969389957472`,{3.9127152796031686`,0.27512213149551934`},{4.886534264646704`,0.5377487251102773`},{3.885372426526345`,0.47307819466700907`}},{1.2955021251916674`,{3.917038245240031`,0.2752414074605999`},{4.886828689789856`,0.5325799067651489`},{3.888278307047978`,0.4636374090342459`}},{1.282282715750936`,{3.921448570162437`,0.27523092119320003`},{4.88710386650425`,0.5271281875869344`},{3.8909752857236612`,0.4542512618720371`}},{1.269330365086785`,{30.791147891795653`,0.2830259777510306`},{4.887360429591641`,0.5214294065781211`},{30.759999842740818`,0.4563740705729746`}},{1.2566370614359172`,{30.91471580287217`,0.2871500795004055`},{4.887599545998994`,0.515523251211767`},{30.879999984264714`,0.45380956696506297`}},{1.2441951103325914`,{31.029315285790176`,0.286682733618616`},{4.887821897857202`,0.5094417120562758`},{30.999999787973437`,0.44415554552540965`}},{1.231997119054821`,{31.133589083862468`,0.28242165015018406`},{4.888028471810697`,0.503209798066785`},{31.106399948118412`,0.4289709082202539`}},{1.2200359819766187`,{31.18`,0.27495761520889883`},{4.8882200066727695`,0.4968609124178628`},{31.18`,0.41019521209559767`}},{1.2083048667653051`,{3.950479042852529`,0.27284624415523606`},{4.888397136280636`,0.49041690212130756`},{4.054258516361409`,0.4139900717542465`}},{1.1967972013675403`,{3.9562043071860873`,0.2721392459739701`},{4.888561306413837`,0.48390647183804597`},{3.912959931797375`,0.3910851102028081`}},{1.1855066617319974`,{3.962460930119685`,0.2713598709110828`},{4.888712233701595`,0.4773501356828315`},{3.8997369290089554`,0.3831122377257554`}},{1.1744271602204834`,{3.9695401533207697`,0.270521964084784`},{4.888851663469331`,0.4707522802259833`},{3.922410490978884`,0.3742243059193462`}},{1.1635528346628863`,{3.978093438967945`,0.2696357979994624`},{4.888979459301982`,0.46415180414303414`},{3.9269779582893847`,0.3660290717956973`}},{1.152878038014603`,{3.9904207819492057`,0.26870314572482906`},{4.889097441181592`,0.4575404222286678`},{3.9361811883068665`,0.3579870547904771`}},{1.1423973285781066`,{4.013950966941941`,0.2677963859500933`},{4.889204799262455`,0.4509495841526135`},{3.939999982972926`,0.35012765863102224`}},{1.1321054607530787`,{4.026181791592963`,0.26689855562624293`},{4.889302679526388`,0.4443941693091947`},{3.949926485889973`,0.34242354563422217`}},{1.121997376282069`,{4.03492109256323`,0.26597092217751506`},{4.8893917354148915`,0.43787174995049255`},{3.958441380816586`,0.3349161286493265`}},{1.1120681959609888`,{28.843701327625826`,0.27704532921412817`},{2.9251081801772623`,0.43518954547753635`},{28.802345474646852`,0.34306474639512774`}},{1.1023132117858923`,{28.9013717305327`,0.2936188577515875`},{2.9252319170740875`,0.4331567355532458`},{28.85999977603458`,0.3570697283277155`}},{1.0927278795094932`,{28.991250115590812`,0.3105053914337923`},{2.9253493419600884`,0.4311329354222746`},{28.9533466088968`,0.3709994793783331`}},{1.0833078115826873`,{29.155912109089748`,0.3284581728400319`},{2.925461006489051`,0.4291217175641537`},{29.133436066083323`,0.385703604377431`}},{1.074048770458049`,{29.22148087412646`,0.3460904101774916`},{2.925567470484921`,0.4271229636749746`},{29.184192098584443`,0.39961170049964606`}},{1.0649466622338282`,{29.303114434523305`,0.36178246117088086`},{27.781101646151935`,0.4255711712706599`},{29.26089102136495`,0.4107226814905694`}},{1.055997530618418`,{29.391744736305743`,0.37511309808798643`},{27.786521889557843`,0.43411783946043403`},{29.35163321677765`,0.41866025389314376`}},{1.0471975511965979`,{29.486481369196078`,0.3858414363774825`},{27.792312350950578`,0.43634592169382197`},{29.445079316467556`,0.4234988488390024`}}}},{0.03`,{{125.66370614359172`,{2.4228113246978262`,0.000268150200657977`},{9.383307016222124`,0.011216625117244606`},{2.4223460302825304`,4.237105392752461`}},{62.83185307179586`,{2.445947847080056`,0.0016111609960436208`},{9.457688843496284`,0.04753849491389794`},{2.4449535332049885`,6.368771845594211`}},{41.88790204786391`,{3.5352481248513548`,0.005330015475172835`},{4.78584102410115`,0.20218439799754964`},{4.824430150947972`,9.830585063131705`}},{31.41592653589793`,{4.995500973742406`,0.009091276317264056`},{3.2312447731781266`,0.24850911861027924`},{4.993590156333822`,8.98810462823423`}},{25.132741228718345`,{2.502174983196738`,0.01486402471951471`},{2.798111316127939`,0.31658209247307706`},{2.4997906972891193`,9.405197071452232`}},{20.943951023931955`,{2.5489939201700778`,0.01839067221171403`},{2.4778239835124807`,0.3915518947937777`},{2.5461082138648994`,8.080559350064611`}},{17.951958020513104`,{2.61548000348093`,0.02620171159323831`},{2.5143939722057587`,0.4603574572357201`},{2.612142627332147`,8.455854363549914`}},{15.707963267948966`,{2.6715157038402992`,0.0339028502119849`},{2.3865786645053633`,0.5101055852994246`},{2.6676429559175023`,8.378926071055801`}},{13.962634015954636`,{2.7303541882602618`,0.04887033133302098`},{2.398693921331213`,0.6979389450050367`},{2.7260096405975367`,9.544329355466981`}},{12.566370614359172`,{2.8079895861695006`,0.057311992562428325`},{2.6877913347886744`,0.7324948258683464`},{2.328500434155318`,10.159007016799144`}},{11.423973285781067`,{5.179942761670917`,0.07833229267861808`},{2.2565670981431976`,0.9067741681160024`},{5.174662325775047`,10.24028595081751`}},{10.471975511965978`,{2.162619194183361`,0.07519676754490486`},{2.289921897228261`,0.8690763334669265`},{2.157145286929845`,8.259938293262968`}},{9.666438934122441`,{2.1912420526808973`,0.07440656825857397`},{2.0619530043073326`,0.7246460415240301`},{2.185105488907064`,6.969581965328523`}},{8.975979010256552`,{5.708445280425448`,0.07495923282037137`},{2.0793710216143895`,0.6865537183500359`},{5.7018651699439555`,6.048625718761103`}},{8.377580409572783`,{12.081523475128868`,0.07698859703378397`},{12.26617768341277`,0.6532554667426217`},{12.074326962985122`,5.413854455987521`}},{7.853981633974483`,{5.768422110373694`,0.08823308662675292`},{5.973427607996324`,0.6618936118871889`},{5.760721552624188`,5.452079859152271`}},{7.391982714328925`,{5.847718552276889`,0.1303324317142845`},{6.046802257465571`,0.9058953158693345`},{5.839546677242356`,7.13400099188377`}},{6.981317007977318`,{5.9488092367461665`,0.1382027112704303`},{5.725226662312253`,0.9742117212268194`},{5.9402172307827135`,6.748377715869472`}},{6.613879270715354`,{4.754487454572823`,0.13658337788071623`},{4.570366224640867`,0.8899381958035385`},{4.74557099934057`,5.986445115952473`}},{6.283185307179586`,{4.818629611042935`,0.13686587618229262`},{4.601811796331225`,0.9737462945053625`},{4.809156159342668`,5.416703412978832`}},{5.983986006837702`,{4.421349246950587`,0.12867718700821598`},{4.629519339428918`,0.87338807193668`},{4.411090198862278`,4.617953149585341`}},{5.711986642890533`,{4.482516696245574`,0.11535800408569001`},{4.279084436533791`,0.6608319936961671`},{4.472334901802983`,3.771253865600375`}},{5.463639397547467`,{3.5150140376248262`,0.09769628320349182`},{3.289896496357979`,0.6045254478333016`},{3.5044661209767596`,2.923971683600288`}},{5.235987755982989`,{5.957232786236411`,0.10944807181074968`},{3.301963102537048`,0.5726108831439006`},{5.945798180508569`,3.0064190167225573`}},{5.026548245743669`,{6.026163082047163`,0.10660020499346741`},{5.726967531629017`,0.5232076113979092`},{6.013873020479925`,2.697557862266566`}},{4.8332194670612205`,{6.078059083818945`,0.09661929398261546`},{7.029216214224037`,0.4467819808412926`},{6.066254190294898`,2.261014360541022`}},{4.654211338651545`,{14.377447552101453`,0.0911317350831405`},{1.8460533406638373`,0.45005117317671806`},{14.364639990363413`,1.977850666771788`}},{4.487989505128276`,{14.475768908737171`,0.09504151692925009`},{1.8499875707693374`,0.46239831555744154`},{14.462063925406735`,1.9189524723914928`}},{4.333231246330749`,{6.099913946535151`,0.10132803440788117`},{1.8538929453394668`,0.4720956856010813`},{6.08681293305114`,1.9066925938524713`}},{4.188790204786391`,{6.122570896047371`,0.11464563753691318`},{1.8577093129941864`,0.4791822763882747`},{6.107595866673156`,2.015811208157144`}},{4.053667940115862`,{6.16387978831209`,0.12481628572657509`},{5.816493480021293`,0.5028774949073511`},{6.148256589840787`,2.054275041798357`}},{3.9269908169872414`,{9.473305388441819`,0.1308111571850831`},{9.126161962451475`,0.5244940068367816`},{9.45701679952559`,2.0201990713803095`}},{3.8079910952603555`,{9.591709435920315`,0.14239670859513157`},{9.185938288875104`,0.5716031030061764`},{9.5767091526985`,2.0695164400444597`}},{3.6959913571644627`,{9.680445949206174`,0.14231331354248639`},{9.212929620020384`,0.5512972440624406`},{9.66266056025137`,1.9469640519123579`}},{3.5903916041026207`,{10.74218560355124`,0.14218842657984027`},{12.043334391311872`,0.5495096498024128`},{10.724650167162942`,1.835944763289275`}},{3.490658503988659`,{11.816365183659219`,0.15158792353521808`},{12.150699881831056`,0.534188044374181`},{11.799675700294545`,1.8524813406057696`}},{3.396316382259236`,{11.869996558808229`,0.1635280635100003`},{11.621123915386534`,0.5523162956701914`},{11.851920109867375`,1.8915955431700264`}},{3.306939635357677`,{11.928769725416457`,0.1685523639475181`},{11.63376319559457`,0.64974938218155`},{11.91077237045174`,1.8479876614856119`}},{3.222146311374147`,{11.992558427948914`,0.1672718610536494`},{11.648351224987248`,0.7165183821243722`},{11.97285070330827`,1.740893041581349`}},{3.141592653589793`,{11.193046422447567`,0.1683233144873824`},{11.664940616622212`,0.7392486265624402`},{11.17340742677116`,1.6637419650968792`}},{3.0649684425266277`,{11.354406944712899`,0.17775125548488577`},{11.68195157930306`,0.6990206654323792`},{11.336173578139537`,1.6725926224564436`}},{2.991993003418851`,{6.404705172744173`,0.18308561943463478`},{11.696194274767675`,0.5898547578740823`},{6.385210355059774`,1.6418347858788973`}},{2.922411770781203`,{6.442858889417567`,0.20409593208267976`},{5.8889179937532345`,0.6170054297241396`},{6.422184815332967`,1.7463297396381476`}},{2.8559933214452666`,{6.4877812804240875`,0.224048936205839`},{5.8950263491858115`,0.6586502491109993`},{6.466622859232819`,1.8308174140639468`}},{2.792526803190927`,{6.53943622651284`,0.24246180664003855`},{5.92221612241279`,0.6877868985155595`},{6.518675770032732`,1.8940489119294597`}},{2.7318196987737333`,{6.587821363507193`,0.25876247425791044`},{6.056203972577827`,0.7248744370768522`},{6.56663732031714`,1.9350934699849356`}},{2.673695875395569`,{6.635937112514282`,0.27198992517893555`},{6.066093477447108`,0.7568693784388781`},{6.612436587551538`,1.9483958787261548`}},{2.6179938779914944`,{6.696726817905889`,0.28254060132845726`},{6.0763471640536695`,0.7733020563468685`},{6.674785514821338`,1.9396922801636565`}},{2.564565431501872`,{5.624086129073023`,0.29270764425687146`},{6.0865985900974255`,0.7738580028637025`},{5.602189870785765`,1.9305003313477578`}},{2.5132741228718345`,{5.647166871061226`,0.30662123482310677`},{6.1856365832732525`,0.7770660326587724`},{5.624693158885429`,1.9428625693366925`}},{2.463994238109642`,{5.668896871784232`,0.31716092278231417`},{6.312088958066808`,0.7841534352487148`},{5.6454179272522`,1.9322593868301654`}},{2.4166097335306103`,{5.693605166991271`,0.32431113736326056`},{11.6748891013806`,0.817618603473393`},{5.666360224539725`,1.9001834701588438`}},{2.3710133234639947`,{5.724670222979875`,0.3284813581367349`},{11.69115285969152`,0.825603377236579`},{5.696056327143039`,1.8514495706585405`}},{2.3271056693257726`,{11.382301313168151`,0.3373068477980239`},{5.274872123751375`,0.803289459904693`},{11.357908948773861`,1.830138995754246`}},{2.284794657156213`,{11.454211836926643`,0.3653616512116244`},{5.404100681038635`,0.823757345489414`},{11.429148335402266`,1.9122835736690482`}},{2.243994752564138`,{11.515618830030949`,0.37905772754731426`},{5.408082431324338`,0.8512901035063009`},{11.48898148495833`,1.914278413474521`}},{2.2046264235717845`,{11.571923928669241`,0.37769147206274356`},{5.412010863917587`,0.8708737943404974`},{11.53996605182621`,1.856093785856144`}},{2.1666156231653746`,{11.62407789911324`,0.36096789982488847`},{5.415840469310128`,0.8828842996097013`},{11.593039494208561`,1.7001297667659667`}},{2.1298933244676563`,{13.314539967838376`,0.3531441779510791`},{5.419497157648327`,0.887822014161431`},{13.2825769754883`,1.604959695776431`}},{2.0943951023931957`,{13.416173624512139`,0.33921615076868594`},{5.422968272237707`,0.8862573094022468`},{13.385635119168576`,1.491028786730955`}},{2.0600607564523234`,{9.13550089178299`,0.32517060393155206`},{5.426215146960819`,0.8788154411480467`},{9.102151454377774`,1.3838456490544264`}},{2.026833970057931`,{9.2019474557843`,0.31837060234984416`},{5.429228465694459`,0.8661463503070654`},{9.170147232752148`,1.3108346289952817`}},{1.9946620022792338`,{9.33663900355446`,0.3123717063794811`},{5.43198595401479`,0.8488987781483871`},{9.314093789756528`,1.245363793789931`}},{1.9634954084936207`,{9.379042455750097`,0.3047289895265519`},{5.434484339231243`,0.827721016542093`},{9.348835469687986`,1.1793631188525024`}},{1.9332877868244882`,{4.9572150963347035`,0.3060119351288667`},{5.436724484283608`,0.8032296575433021`},{4.922401517522415`,1.1485434025427237`}},{1.9039955476301778`,{4.976544700286264`,0.30981319198120805`},{5.438709001012002`,0.7760151906470355`},{4.940402276047158`,1.127288369367751`}},{1.8755777036356975`,{4.999871733776165`,0.3127114143113656`},{5.44044819212329`,0.7466347344218606`},{4.961497410514644`,1.103446233380346`}},{1.8479956785822313`,{5.021355421949363`,0.31485259778925573`},{4.3222793701128985`,0.720629311703982`},{4.990417076356709`,1.0780836823803999`}},{1.821213132515822`,{5.037208659130674`,0.31609480814205926`},{4.324399995892104`,0.7225009403381459`},{5.010556230844309`,1.051941749603006`}},{1.7951958020513104`,{5.050117035590702`,0.3163531596864798`},{4.32641157664555`,0.7226954917893356`},{5.022271229943892`,1.0236565751245519`}},{1.7699113541350948`,{5.061120274608805`,0.3156216881832196`},{4.328308455627883`,0.7213771798289405`},{5.032542630972474`,0.9933642373179767`}},{1.7453292519943295`,{5.071652244229067`,0.3139254609000209`},{4.330105881042295`,0.7186765383223591`},{5.041508109248494`,0.9613312697299659`}},{1.7214206321039962`,{5.082481714365005`,0.3113504802337898`},{4.3317898509212105`,0.7147408301956701`},{5.049229867410365`,0.9278822742827226`}},{1.698158191129618`,{5.093715227608799`,0.3079843074025982`},{4.333366869486893`,0.7097089291522842`},{5.05619698681923`,0.8933303256357807`}},{1.6755160819145565`,{5.105450535718106`,0.3039001145560011`},{4.334840536512578`,0.7036898572777904`},{5.064313299780104`,0.8579638969148813`}},{1.6534698176788385`,{5.117944008018341`,0.2991831313726008`},{4.336204035916717`,0.6968038578232146`},{5.07546641573097`,0.8223115786575317`}},{1.6319961836830095`,{5.131594516453766`,0.29391108429708374`},{4.33749817232817`,0.6891584415823419`},{5.0872103735739715`,0.7866763319104706`}},{1.6110731556870734`,{5.147127188030407`,0.28818791002186417`},{4.338657980737716`,0.6808593263373086`},{5.100655485605832`,0.7513347545612628`}},{1.590679824602427`,{5.165939366026634`,0.28209991096358855`},{4.3397479642343715`,0.6719888792012254`},{5.116690980978209`,0.7164908491047801`}},{1.5707963267948966`,{5.182239796848036`,0.2757118244651868`},{4.34075118970339`,0.6626373284252149`},{5.13629677807077`,0.6824038817566861`}},{1.5514037795505151`,{5.195370867999603`,0.26898736859454736`},{4.341684499533524`,0.652879736636521`},{5.164353557795466`,0.6495602136224309`}},{1.5324842212633139`,{5.206375083479612`,0.2619202243189515`},{4.3425281183407884`,0.6427897129179027`},{5.174428268461799`,0.6175231446173927`}},{1.5140205559468882`,{5.215827176687946`,0.25452778335125364`},{4.343292074096776`,0.6324410539006451`},{5.183075298727457`,0.5860560384314178`}},{1.4959965017094254`,{3.8157476319302357`,0.2536235606634591`},{4.343998217963394`,0.6218713280797431`},{3.75803178275092`,0.5685774095911363`}},{1.478396542865785`,{3.8407691002367543`,0.2557982794026764`},{4.34462084087528`,0.6111514961735137`},{3.8209043077675817`,0.5597680122661424`}},{1.4612058853906016`,{3.8531550522371707`,0.2578693855118906`},{4.345204313497902`,0.6003239548354402`},{3.8287083791489978`,0.5517174466215538`}},{1.444410415443583`,{3.8624923203558756`,0.2597788641203764`},{4.3457129073817375`,0.5894352815325473`},{3.835588794978784`,0.5434800985849721`}},{1.4279966607226333`,{3.8702119007676212`,0.26150654701625947`},{4.34617285137899`,0.5785213087521331`},{3.841982619581285`,0.5350595653259755`}},{1.411951754422379`,{3.8768681266168885`,0.26304992248012815`},{4.346579641019752`,0.5676194386456698`},{3.8470001229126947`,0.5264834661527003`}},{1.3962634015954636`,{3.8827599996938664`,0.264410061764881`},{4.34694572149179`,0.5567618504530857`},{3.8516472638183576`,0.5177814369001575`}},{1.3809198477317772`,{3.8880565606648996`,0.2655855309109517`},{4.884424783579266`,0.542688269438232`},{3.856621319349622`,0.5089747263486131`}},{1.3659098493868667`,{3.8928681139334462`,0.26658309686862275`},{4.884821119280068`,0.5402124120060832`},{3.859999981962839`,0.5000819882303753`}},{1.3512226467052875`,{3.897283836469902`,0.26741184198076173`},{4.885194919857741`,0.5372137112835508`},{3.8635828591737096`,0.4911176358315339`}},{1.3368479376977844`,{3.9013787579930908`,0.26807372879696606`},{4.885547244238919`,0.5337413999719762`},{3.866966522565533`,0.48212447722625673`}},{1.3227758541430708`,{3.905423472333441`,0.2685795741224371`},{4.885878558840393`,0.5298481354688309`},{3.870224230528529`,0.47311658246623467`}},{1.3089969389957472`,{3.9094906070094613`,0.26894275712693383`},{4.886189579244621`,0.5255884069042088`},{3.8733295102045897`,0.4641269015559655`}},{1.2955021251916674`,{3.913603941792259`,0.26914913530686285`},{4.886481415813424`,0.5209735761062535`},{3.876107694613111`,0.4551217450161329`}},{1.282282715750936`,{3.917765085599451`,0.26922912311863867`},{4.88675485352159`,0.5160752617176005`},{3.8787020770836014`,0.44617100143371946`}},{1.269330365086785`,{3.922006543184942`,0.2691958339756748`},{4.887010620891108`,0.510932240930441`},{3.880976945505916`,0.43728501562985356`}},{1.2566370614359172`,{3.92629918150431`,0.26903963279114046`},{4.887249614657846`,0.5055634387520431`},{3.8832245153880383`,0.42844970512134184`}},{1.2441951103325914`,{3.9306758578994456`,0.2687808241044065`},{4.887472485332913`,0.5000106759247663`},{3.885357666777866`,0.4196975830929568`}},{1.231997119054821`,{3.9351851094393235`,0.26841916895240775`},{4.887680395707503`,0.4942972587359095`},{3.8872325652718813`,0.4110302637150971`}},{1.2200359819766187`,{3.9398462322902272`,0.2679663402944517`},{4.887873792551105`,0.488452636513234`},{3.8890567371746503`,0.40246094737499405`}},{1.2083048667653051`,{3.9446949191754075`,0.26742241635838143`},{4.88805335594093`,0.48249888220003084`},{3.890780786314976`,0.39398891020497984`}},{1.1967972013675403`,{3.9498013845358866`,0.2668019612833517`},{4.888219814691905`,0.47646482853795197`},{3.89239214523598`,0.38563279496107716`}},{1.1855066617319974`,{3.955228980841166`,0.2661061340426511`},{4.888374014961462`,0.47036235982747304`},{3.893894747939532`,0.37739059746218295`}},{1.1744271602204834`,{3.9612035763549738`,0.26537736705650816`},{4.888518976393728`,0.4642128193476259`},{3.8953524045289254`,0.3693150974791115`}},{1.1635528346628863`,{3.9677067491844937`,0.26453179801434545`},{4.888648845938881`,0.45804987269363145`},{3.896661693002765`,0.3612895814981987`}},{1.152878038014603`,{3.975478170999074`,0.2636644417590038`},{4.888770165840556`,0.4518652360212705`},{3.897903949689611`,0.35343188804457637`}},{1.1423973285781066`,{3.9858369372321136`,0.26276192947952276`},{4.888881861437846`,0.44568401813455905`},{3.8992563958585627`,0.34792214389266385`}},{1.1321054607530787`,{4.008506974741335`,0.26185264132404124`},{4.888984698387958`,0.43951828460763004`},{3.9006430799675007`,0.3381203275002398`}},{1.121997376282069`,{4.0228296457717425`,0.26097243580957213`},{4.889078386720774`,0.4333767821964092`},{3.9043385918970723`,0.3306766064854836`}},{1.1120681959609888`,{4.032095575457256`,0.26007534534240595`},{2.9245841816884917`,0.43241450343219995`},{3.9082851716092724`,0.3233891270592155`}},{1.1023132117858923`,{28.95049053348453`,0.2712026258154951`},{2.924713477941194`,0.43048229847961506`},{28.89999999999831`,0.3364392365778155`}},{1.0927278795094932`,{29.10815795066233`,0.2835061621154834`},{2.9248366120078497`,0.42855602763145334`},{28.978705541343484`,0.3390523211843864`}},{1.0833078115826873`,{29.179902711519084`,0.29738636918702666`},{2.924953558856359`,0.426639247267574`},{29.144918074562927`,0.3498231868799629`}},{1.074048770458049`,{29.248362228111322`,0.3101003711852459`},{2.925066475297454`,0.4247302755950841`},{29.19236634061264`,0.358479900768554`}},{1.0649466622338282`,{29.323962234977394`,0.32123762931182465`},{2.9251721117746485`,0.42283438277645696`},{29.26692866697387`,0.3650791150399309`}},{1.055997530618418`,{29.405806087231586`,0.33050514128901115`},{2.925272877219749`,0.42094821120329345`},{29.34880942464173`,0.36932131507570853`}},{1.0471975511965979`,{29.493502459114136`,0.337533870638798`},{2.9253686700698953`,0.41907457826666544`},{29.439999825854567`,0.37093136709408187`}}}},{0.05`,{{125.66370614359172`,{2.4244239184243135`,0.0002613056293198825`},{9.043301755521002`,0.007932322817640463`},{2.4236428448601184`,4.13341244832334`}},{62.83185307179586`,{2.446884553010839`,0.0016116781338517054`},{2.472928345753815`,0.07274949065727768`},{2.4453942183777624`,6.391299643392479`}},{41.88790204786391`,{3.5389196690237315`,0.004125797501019983`},{3.4985526971045355`,0.15144522945677028`},{4.827114705719995`,7.327085736876173`}},{31.41592653589793`,{4.9914205945195045`,0.008150476106233496`},{4.665359128477336`,0.1860989556647202`},{4.988237985500175`,8.08199771217645`}},{25.132741228718345`,{2.5055268597971923`,0.013000709417238457`},{2.7973933883132345`,0.23848758953374205`},{2.5016153661230027`,8.25207370083131`}},{20.943951023931955`,{2.5502031935281066`,0.016991659836317053`},{2.478175679603303`,0.3735500445430082`},{2.54535050240235`,7.4885557715274125`}},{17.951958020513104`,{2.614387881846197`,0.022915108180293405`},{2.5114658432335357`,0.41535938430667685`},{2.608842000592335`,7.412228247221195`}},{15.707963267948966`,{2.673267026054229`,0.030178608132840647`},{2.386817517654351`,0.48798349510700034`},{2.6669289436192507`,7.47754137983374`}},{13.962634015954636`,{2.300406452823821`,0.040398302930722836`},{2.3988851937560267`,0.637211795472592`},{2.2932849581857773`,7.915703164800338`}},{12.566370614359172`,{2.0925546418661685`,0.047789025489369356`},{2.2247333360328625`,0.7015975194887967`},{2.3264867229283963`,9.0573624875811`}},{11.423973285781067`,{2.374673925833525`,0.06421521380294279`},{2.2548223677888726`,0.8156326828978864`},{2.366003047030923`,8.435625661706307`}},{10.471975511965978`,{2.160495445169332`,0.06850064797800624`},{2.2854818198117894`,0.7859605725736298`},{2.1511331255265858`,7.556927969485827`}},{9.666438934122441`,{2.1876557338622145`,0.06843199583790789`},{2.0589961603867204`,0.6746473845880697`},{2.1774891530094656`,6.437841466964624`}},{8.975979010256552`,{2.208873529495691`,0.06414000079564759`},{2.075548102722942`,0.6478928994241366`},{2.197649956213258`,5.207904359833158`}},{8.377580409572783`,{12.077068565717179`,0.06271001293471107`},{2.087980511340285`,0.6061652369020499`},{12.064999668843763`,4.425694364553025`}},{7.853981633974483`,{5.783478227826377`,0.07889107899608876`},{2.0968945705969215`,0.5651543212224567`},{5.770578775910308`,4.889265595544428`}},{7.391982714328925`,{5.852381459521681`,0.10483616990882604`},{6.045426985532976`,0.7038370226529718`},{5.837818242706497`,5.755480397912258`}},{6.981317007977318`,{5.939424880394503`,0.10785506376867296`},{4.884677438645949`,0.8015490647171852`},{5.925117975220261`,5.284097931989236`}},{6.613879270715354`,{4.754131526624404`,0.11291290299310029`},{4.573394254169501`,0.7565633273198418`},{4.739464897010825`,4.9660469757797365`}},{6.283185307179586`,{4.811495469028014`,0.11304786308221376`},{4.599179933997619`,0.8316051039408547`},{4.796079062875509`,4.4940271615052145`}},{5.983986006837702`,{4.413485718106045`,0.10959604427968504`},{4.622221941082482`,0.7618955269438574`},{4.396390372564633`,3.9510884057989895`}},{5.711986642890533`,{4.466781707546793`,0.09907865211173672`},{4.637924121238973`,0.5985254804187295`},{4.448414735626012`,3.249497589069937`}},{5.463639397547467`,{3.5069049770244347`,0.08673141854514559`},{3.2874077600688127`,0.5459302018568271`},{3.489985617715679`,2.6065400770232037`}},{5.235987755982989`,{5.956250980809945`,0.09220318933124035`},{3.2981408828252894`,0.5239515664862637`},{5.937263086100237`,2.5416231903042865`}},{5.026548245743669`,{6.012015339904417`,0.0936154772188132`},{3.306360438299228`,0.4793272825609053`},{5.991051377516649`,2.3763840120446083`}},{4.8332194670612205`,{6.061686654588296`,0.08962365835323657`},{5.732574624688074`,0.43137975346071217`},{6.043104835045203`,2.101877544619779`}},{4.654211338651545`,{6.08336481249889`,0.08662592236066433`},{1.8445768703194767`,0.43641788231896356`},{6.063944341469404`,1.885657758444638`}},{4.487989505128276`,{6.09290349155052`,0.08895488480711783`},{1.8483155480908728`,0.44789604518150666`},{6.072729556140103`,1.8013638118827187`}},{4.333231246330749`,{6.10472972778593`,0.09649080711158689`},{1.8520362154955694`,0.4570228452579007`},{6.083536402881583`,1.8225766612696817`}},{4.188790204786391`,{6.12683925187166`,0.10556453739177195`},{1.855673357017894`,0.4638290575262907`},{6.101321441406461`,1.8663267824450378`}},{4.053667940115862`,{6.16370458763061`,0.11284465436150574`},{1.8591817816450464`,0.46841418741561536`},{6.1361950723990235`,1.8629438412802088`}},{3.9269908169872414`,{6.202602676708524`,0.11693653242848147`},{5.83276876936425`,0.4780848351478667`},{6.179182190384583`,1.8125499263153722`}},{3.8079910952603555`,{6.239703991028027`,0.11731441338798297`},{1.8656545081577336`,0.4715756599227043`},{6.211739714750061`,1.7099752606068546`}},{3.6959913571644627`,{8.833216658205444`,0.11611445110676047`},{1.8685819769888499`,0.4705519049506701`},{8.80954796194638`,1.599617580164436`}},{3.5903916041026207`,{9.785822290579251`,0.11400967368247993`},{1.871302684660667`,0.4680626363573817`},{9.760436758551638`,1.476002939517756`}},{3.490658503988659`,{11.825484050167642`,0.12192643805670444`},{1.873796354365064`,0.4643131570663345`},{10.806315763925632`,1.4999951123523725`}},{3.396316382259236`,{11.871047492640841`,0.13304392653982214`},{11.627864307595017`,0.48493135265092646`},{11.840264507105124`,1.5479438628489897`}},{3.306939635357677`,{11.923422229811475`,0.13656240852164125`},{11.63762660365393`,0.5641815172047789`},{11.899966860959225`,1.5077075759324037`}},{3.222146311374147`,{11.055909269999244`,0.13271447381801663`},{11.649223236848192`,0.6135017600829693`},{11.945821772586749`,1.3927670214051453`}},{3.141592653589793`,{6.368895025754073`,0.13653295715181232`},{11.66188967062435`,0.6257964570693175`},{6.340727683324142`,1.3557786979519413`}},{3.0649684425266277`,{6.3921292363735605`,0.1514483052501484`},{11.674192483591547`,0.5937929606089276`},{6.356789907539633`,1.429746085420787`}},{2.991993003418851`,{6.42196347441094`,0.16753386872048145`},{5.886145505278904`,0.5346035202079382`},{6.390055544696391`,1.507201258744235`}},{2.922411770781203`,{6.457779737612189`,0.18367102355772727`},{5.890148644194168`,0.5721725427672324`},{6.42314467276594`,1.5767883234930333`}},{2.8559933214452666`,{6.500436408521237`,0.19909174941563404`},{5.895185212707869`,0.602531055223559`},{6.4647188200385575`,1.6321166161784941`}},{2.792526803190927`,{6.548525952120998`,0.21340535846827371`},{5.920597292559707`,0.6229529181233078`},{6.514217865591948`,1.6722304984300815`}},{2.7318196987737333`,{6.592300659503356`,0.22596224878462107`},{6.057052841057853`,0.6526177781166659`},{6.557975757825385`,1.6960389673504055`}},{2.673695875395569`,{6.637067783500638`,0.23597584693072185`},{6.065505393961039`,0.6775169517706788`},{6.597905654967045`,1.6993774304672011`}},{2.6179938779914944`,{5.605350544542947`,0.2508974183193176`},{6.074280592884172`,0.6899626785709961`},{5.571631074096689`,1.7311755583092614`}},{2.564565431501872`,{5.627278449951173`,0.26525349026579814`},{6.083073804790951`,0.6895789241883938`},{5.592423862545484`,1.7580843056170155`}},{2.5132741228718345`,{5.647724379011094`,0.27700509329397377`},{6.182066133341345`,0.6865652785084349`},{5.611816054757296`,1.7649655495790835`}},{2.463994238109642`,{5.667130982916939`,0.2858906873415405`},{6.310744461238905`,0.6876828995510694`},{5.6299460342145995`,1.752487727709613`}},{2.4166097335306103`,{5.688916565397094`,0.29186869170932633`},{6.319904161686225`,0.6935482464699982`},{5.6469185820618195`,1.721879313143667`}},{2.3710133234639947`,{5.715768263687149`,0.2951955646525019`},{5.267225120641917`,0.7152974643147015`},{5.664636174121803`,1.6747433880802862`}},{2.3271056693257726`,{5.752747062871284`,0.29645479167435423`},{5.274084554969863`,0.7378969175325725`},{5.697051654479697`,1.6162937677501568`}},{2.284794657156213`,{5.789271889034689`,0.29617427817264336`},{5.404366585567773`,0.7561057665976836`},{5.74933042338371`,1.5549213592998188`}},{2.243994752564138`,{11.512327126863559`,0.3003786410654019`},{5.407826510664691`,0.7815824681561531`},{11.468270519264436`,1.5258506338774962`}},{2.2046264235717845`,{11.55938174962959`,0.2995316152806197`},{5.411264599543458`,0.8003329201845275`},{11.515804123196506`,1.469344798883412`}},{2.1666156231653746`,{5.899701032317616`,0.2857337863222077`},{5.414631392500956`,0.8126142600065611`},{11.555348134805365`,1.3637555093010834`}},{2.1298933244676563`,{5.9546570352006345`,0.2803057897810598`},{5.417884917180797`,0.8187935542498667`},{5.90807022277963`,1.2769826099431576`}},{2.0943951023931957`,{6.003693215055721`,0.2747016214682179`},{5.420984168919828`,0.8193409057301939`},{5.964380807955253`,1.2106074590235396`}},{2.0600607564523234`,{6.039115364083404`,0.26822101086829186`},{5.423906921760213`,0.8147242323070301`},{5.997744250791704`,1.1454724420174633`}},{2.026833970057931`,{4.908678618503959`,0.2625590582082492`},{5.42663632579336`,0.8054804083796323`},{4.882641550252675`,1.0841421694172453`}},{1.9946620022792338`,{4.923341201526819`,0.26968908288773435`},{5.429167728567592`,0.7921391655825423`},{4.8925416807268745`,1.081746816618682`}},{1.9634954084936207`,{4.937426625439702`,0.2756181037184873`},{5.431472253508755`,0.7752342569505359`},{4.901002844868286`,1.073741368140352`}},{1.9332877868244882`,{4.952837485902064`,0.28042892151320675`},{5.433558377687949`,0.7552913886581321`},{4.908214949456693`,1.0606996048957908`}},{1.9039955476301778`,{4.9700783577297765`,0.28422974128660217`},{5.435427441032078`,0.7328084238110882`},{4.914684877752805`,1.0431663259669868`}},{1.8755777036356975`,{4.990314669182677`,0.28715437846951575`},{5.437083181142322`,0.7082543625249034`},{4.9215785503640825`,1.0217248309098343`}},{1.8479956785822313`,{5.012951231546662`,0.2893725004373396`},{5.438540542725893`,0.6820712132541326`},{4.941082729197274`,0.9977553313582463`}},{1.821213132515822`,{5.029600669861097`,0.29084582699842687`},{4.322635906400176`,0.6851845758297691`},{4.967579777527905`,0.9726368251868354`}},{1.7951958020513104`,{5.042769903137433`,0.2914620895802094`},{4.324512387806199`,0.6864398099032697`},{5.0036298757490325`,0.9478894385494041`}},{1.7699113541350948`,{5.05382954821403`,0.2912021091128161`},{4.326295858032483`,0.6862818177819949`},{5.012742503153818`,0.9221773854351967`}},{1.7453292519943295`,{5.063503381202304`,0.29007501073418923`},{4.327979781251689`,0.6848369552138941`},{5.0205920743340435`,0.8947561816169075`}},{1.7214206321039962`,{5.073060379399488`,0.2881224762497878`},{4.329579073467004`,0.6822224990664172`},{5.0279016359492354`,0.8658881372473761`}},{1.698158191129618`,{5.082833358383073`,0.2854195511953742`},{4.331081627891935`,0.6785611617145155`},{5.034258912701647`,0.8358908287540918`}},{1.6755160819145565`,{5.092936449857479`,0.2820328157629161`},{4.332491691129355`,0.6739545148918609`},{5.039758235173905`,0.8049912883009662`}},{1.6534698176788385`,{5.103417067567748`,0.2780309500181215`},{4.333812879053163`,0.6685100348455189`},{5.045102990626052`,0.7734748233158109`}},{1.6319961836830095`,{5.1144472217202415`,0.2734821092988248`},{4.3350462089712005`,0.6623238399937613`},{5.049726547949559`,0.7415442472292586`}},{1.6110731556870734`,{5.126271735681785`,0.2684524902291443`},{4.336196521698947`,0.6554844234521185`},{5.053840405334173`,0.7094125855668705`}},{1.590679824602427`,{5.139378916041307`,0.26300799507272493`},{4.337264756357254`,0.6480767900376834`},{5.057557528538139`,0.6772677538898559`}},{1.5707963267948966`,{5.154745127992266`,0.25722460936345126`},{4.3382633844424925`,0.6401774821703244`},{5.0626200365523335`,0.6452865428692434`}},{1.5514037795505151`,{5.171903544702521`,0.2511862778810054`},{4.339172235225133`,0.6318588919314568`},{5.0725521258016775`,0.6137764811651278`}},{1.5324842212633139`,{5.185450400317088`,0.24489396521622453`},{4.340025182887012`,0.6231863214696289`},{5.083644024266906`,0.5829056696478443`}},{1.5140205559468882`,{5.196557830254157`,0.2383394432204971`},{4.340793748399153`,0.6142162581116519`},{5.097066372786016`,0.552814344514287`}},{1.4959965017094254`,{3.7913573544121117`,0.24054111819764706`},{4.341507155134241`,0.6050142460882522`},{3.7093281335946946`,0.5432600125045889`}},{1.478396542865785`,{3.8263966029698135`,0.24259158994848903`},{4.342158548084726`,0.5956242337007995`},{3.7133648555028334`,0.534405287742294`}},{1.4612058853906016`,{3.844230562820256`,0.24468814658841698`},{4.342744949728581`,0.586090160754099`},{3.7171445896266366`,0.5253665368639454`}},{1.444410415443583`,{3.8551376858925863`,0.2466665284328128`},{4.343286513141657`,0.5764569828861228`},{3.824362279265473`,0.51702682473288`}},{1.4279966607226333`,{3.8636461281097043`,0.24848394281142877`},{4.343781218803573`,0.5667562561176487`},{3.829115208613364`,0.5098664066799032`}},{1.411951754422379`,{3.870763575011606`,0.2501337338562724`},{4.344220574899161`,0.5570301486267045`},{3.7145841369094144`,0.5097030186663358`}},{1.3962634015954636`,{3.876961283498661`,0.2516208704558484`},{4.344616936817622`,0.5473041115264091`},{3.8371166100692444`,0.4949702735712189`}},{1.3809198477317772`,{3.8824739376405906`,0.25292678328181784`},{4.344969286133343`,0.5376019724939138`},{3.841275171030271`,0.48726673837892914`}},{1.3659098493868667`,{3.887455599446756`,0.25407369852905265`},{4.345277330516067`,0.5279568678859743`},{3.8441302205218766`,0.47946550475373634`}},{1.3512226467052875`,{3.8919920111876034`,0.25505541616270666`},{4.345549417728097`,0.5183825074827412`},{3.8475275252166283`,0.47155461038242824`}},{1.3368479376977844`,{3.8961779278217628`,0.2558811626351797`},{4.8849378594907895`,0.5081092443450056`},{3.8500472526015357`,0.46357936005979095`}},{1.3227758541430708`,{3.900049908564112`,0.25655550572189084`},{4.88525789366655`,0.5052578994508397`},{3.8531904532494`,0.4555556689832777`}},{1.3089969389957472`,{3.903764345448889`,0.25708595137457213`},{4.885560370527749`,0.5020282233286324`},{3.8558724467191077`,0.44750647943238`}},{1.2955021251916674`,{3.90751296127336`,0.2574773672527904`},{4.8858452682300255`,0.4984561918257361`},{3.858063716675592`,0.43943617154471626`}},{1.282282715750936`,{3.9112888540460604`,0.2577397668762347`},{4.886113637005801`,0.4945814365016066`},{3.859999993848151`,0.43138496038491103`}},{1.269330365086785`,{3.9150992779259752`,0.25788378545485907`},{4.886365881340576`,0.4904429691931285`},{3.8617842337153405`,0.4233441123594006`}},{1.2566370614359172`,{3.918951214680228`,0.25790819686150224`},{4.886603076808022`,0.4860625326933887`},{3.863688032024537`,0.41533970379523255`}},{1.2441951103325914`,{3.9228739355387487`,0.2578271364435143`},{4.886825407610007`,0.4814795668774074`},{3.865615468055851`,0.407378716119315`}},{1.231997119054821`,{3.9268113020444324`,0.25764507450312`},{4.887032823152001`,0.47673142831937354`},{3.867224311226026`,0.3994752524017955`}},{1.2200359819766187`,{3.930869244156564`,0.2573716104189489`},{4.887229000778304`,0.47180746971018034`},{3.8688849941886962`,0.39165269951765547`}},{1.2083048667653051`,{3.935011882920085`,0.2570043048861829`},{4.887411327486832`,0.46676294670575647`},{3.8705596552670083`,0.3838969028221124`}},{1.1967972013675403`,{3.9392791168856776`,0.2565585247469901`},{4.887581714632668`,0.4616140575714903`},{3.871917114658387`,0.3762300031736501`}},{1.1855066617319974`,{3.943699873851543`,0.25603568717825453`},{4.887740601977471`,0.45637804874654714`},{3.873322250230201`,0.3686628369572591`}},{1.1744271602204834`,{3.948327628492468`,0.2554430256739135`},{4.887888596599`,0.45107549610421505`},{3.874568335369687`,0.3611898355809302`}},{1.1635528346628863`,{3.9532023109647643`,0.2547824368460166`},{4.888026105178703`,0.44571766708827565`},{3.875729320111186`,0.35381644869831663`}},{1.152878038014603`,{3.9584225679508935`,0.2540664290199169`},{4.888154024993542`,0.440328621074703`},{3.8768190964192377`,0.3465564260916356`}},{1.1423973285781066`,{3.9641370805214313`,0.25329297093914355`},{4.888272627286063`,0.4349102179293545`},{3.877922468351222`,0.3394000646872761`}},{1.1321054607530787`,{3.9706222295770828`,0.2524734186448008`},{4.888382593329767`,0.42948538180436324`},{3.8787990750945576`,0.332365414814481`}},{1.121997376282069`,{3.978482294068672`,0.2516138882705575`},{2.9234243087431815`,0.42853600848792156`},{3.8797542011608837`,0.3254406845059241`}},{1.1120681959609888`,{3.9898975012033318`,0.2507297829550863`},{2.923570584850371`,0.4267954807556545`},{3.8805423298279016`,0.31864456991573453`}},{1.1023132117858923`,{4.013992229041004`,0.24986202226418297`},{2.9237112831520133`,0.42505249712843035`},{3.8813694419056834`,0.3119620568540915`}},{1.0927278795094932`,{4.025524736935268`,0.24901297993968602`},{2.9238460015226617`,0.42331704691480965`},{3.8822886392149423`,0.3054057996369026`}},{1.0833078115826873`,{4.03364314392735`,0.24813536019628277`},{2.9239749639387194`,0.421577519847615`},{3.8827539011927774`,0.2989667099264466`}},{1.074048770458049`,{29.279269980689477`,0.2533498881801191`},{2.9240979852875446`,0.4198528322859463`},{29.170372841101834`,0.29404850961159196`}},{1.0649466622338282`,{29.344986498416276`,0.2585153458455437`},{2.924205891852171`,0.4181277652331086`},{29.256414421094377`,0.2949589854110224`}},{1.055997530618418`,{29.41562161511373`,0.2623286345160282`},{2.924315697046106`,0.4164122984210085`},{29.319999891188164`,0.2943022712044804`}},{1.0471975511965979`,{29.490886982287645`,0.26461059817101246`},{2.9244238680537875`,0.414695377233278`},{29.397023350905496`,0.2919015886689016`}}}},{0.1`,{{125.66370614359172`,{2.4266811464122746`,0.00024946977721267946`},{9.043541310297655`,0.007425563019466034`},{2.425113170384428`,3.9653253806673727`}},{62.83185307179586`,{2.448182816801859`,0.001496509095693822`},{4.896943265675953`,0.037023015578902994`},{2.444922529557232`,5.983560943438524`}},{41.88790204786391`,{2.6300921305766067`,0.0032254188044243707`},{2.589024063176541`,0.10557415652295349`},{2.6253453075879127`,5.737971680852358`}},{31.41592653589793`,{4.986904649566479`,0.005931618794528131`},{2.630327277236537`,0.15023707278207188`},{4.980605804580146`,5.954080152741516`}},{25.132741228718345`,{2.510680247111129`,0.010038303991117289`},{2.4519674933930373`,0.24648955658757365`},{2.502836535412944`,6.468895669128981`}},{20.943951023931955`,{2.5505555747075217`,0.013360625433263376`},{2.477137698204798`,0.3166677197119238`},{2.4055074594097583`,6.181936341468463`}},{17.951958020513104`,{2.2703607622672664`,0.017382315077914844`},{2.3728957854798334`,0.3381028605500623`},{2.4238048815655673`,6.150162710322591`}},{15.707963267948966`,{2.285834527867731`,0.023647750487595914`},{2.3870518650477446`,0.42886526323146484`},{2.2734436093727313`,5.945094006923512`}},{13.962634015954636`,{2.30602991049584`,0.033722442371918834`},{2.398397897646898`,0.5127809210570878`},{2.2920589336721333`,6.712162420764993`}},{12.566370614359172`,{2.0992328005400993`,0.039687312983358154`},{2.2267220486625208`,0.5714678996306947`},{2.083885496302259`,6.378403507571231`}},{11.423973285781067`,{2.3694999728014956`,0.04712255006715764`},{2.2509627616445957`,0.6446832518285475`},{2.1114488248380163`,6.646744480099904`}},{10.471975511965978`,{2.1562541389379137`,0.055403902457857215`},{2.2760005994046737`,0.6274241128782385`},{2.1378520943092236`,6.220228667093058`}},{9.666438934122441`,{2.180128370274114`,0.0563691903430136`},{2.05310467162292`,0.5721090536810669`},{2.1602373073180625`,5.4110972118426375`}},{8.975979010256552`,{2.199203625480687`,0.054203329804369725`},{2.0676206464375246`,0.5650079844512622`},{2.1779154349306578`,4.505026080295979`}},{8.377580409572783`,{2.214804574585234`,0.05046332216510026`},{2.07917751412498`,0.543307682942088`},{2.1910576630979754`,3.670235479178018`}},{7.853981633974483`,{5.801223167529459`,0.06006580300996874`},{2.0881037235411717`,0.518262240643034`},{5.774782956905453`,3.7727066421546676`}},{7.391982714328925`,{5.856159540910083`,0.06871032504988565`},{2.095040393658383`,0.49572077865443226`},{5.829309889864773`,3.824231449879732`}},{6.981317007977318`,{5.916556760962996`,0.06802369552670719`},{4.883543493532401`,0.5624710974629674`},{4.661349314285168`,3.3319481674035285`}},{6.613879270715354`,{4.753687433366891`,0.07529038724491838`},{4.579528772364576`,0.5456507024055627`},{4.725968267932496`,3.364205357047172`}},{6.283185307179586`,{4.362052210388244`,0.07643952455315592`},{4.595121354086329`,0.5992140695182494`},{4.767093888159707`,3.059843614048498`}},{5.983986006837702`,{4.3993952722917475`,0.07810619978295517`},{4.609786210058844`,0.5748688524335239`},{4.3687601793884845`,2.8729882026362747`}},{5.711986642890533`,{4.432801683570472`,0.0731131965794149`},{4.620483411278131`,0.49840896832943465`},{4.395126519882271`,2.458954511019706`}},{5.463639397547467`,{4.469021888212387`,0.06423264785271744`},{3.28324921225276`,0.43358682182743097`},{3.459476812415346`,2.0275033677705387`}},{5.235987755982989`,{5.9623260109908465`,0.06814237975292663`},{3.2912862086015138`,0.428716328376904`},{5.924614020056884`,1.910443565359822`}},{5.026548245743669`,{5.997126929314497`,0.07288943010519022`},{3.297732784771111`,0.40822355704538377`},{5.953745118648861`,1.8823064436082928`}},{4.8332194670612205`,{6.036190672430333`,0.07493338074697699`},{5.7239233025681315`,0.3815837329365533`},{5.986865379846146`,1.7813943941147565`}},{4.654211338651545`,{6.068677127582771`,0.07690351484537605`},{1.8409539184427082`,0.4062639832458699`},{6.02831762958806`,1.6898593518980012`}},{4.487989505128276`,{6.089026742301503`,0.07990235681659077`},{1.8443178126882098`,0.41591992888246127`},{6.0535656773963495`,1.6388398717937245`}},{4.333231246330749`,{6.1064510567212915`,0.08395072440659719`},{1.847657528262474`,0.4238320734334221`},{6.068483119920466`,1.6111585945051532`}},{4.188790204786391`,{6.127827492543599`,0.0882344628524399`},{1.8509236738196237`,0.4299798768371122`},{6.08314657356762`,1.5868329934980516`}},{4.053667940115862`,{6.15795691937696`,0.09192787132944984`},{1.8540931941718362`,0.43441126781826434`},{6.097691400530752`,1.5465295039307034`}},{3.9269908169872414`,{6.190939489277185`,0.09471089707982458`},{1.8571235943064974`,0.4372197374540926`},{6.132936891417286`,1.4868706887405014`}},{3.8079910952603555`,{6.217961740000689`,0.09630149697037403`},{1.8599942214787795`,0.43853051356229955`},{6.173245042217864`,1.4251705431105244`}},{3.6959913571644627`,{6.246650630688451`,0.0970456506564593`},{1.8627078593072792`,0.43850242520120175`},{6.190777528947334`,1.3550795426923954`}},{3.5903916041026207`,{6.278237849876928`,0.0977316515354451`},{1.8652360556948404`,0.437223588616022`},{6.209102893913093`,1.2845559676982388`}},{3.490658503988659`,{6.313240306589878`,0.09922567529059835`},{1.867588745942232`,0.434899130039602`},{6.238661872902453`,1.2275179512894212`}},{3.396316382259236`,{6.33458157249564`,0.1019975548495013`},{1.8697672315945886`,0.4316508395294197`},{6.2828786487890484`,1.1921255118566954`}},{3.306939635357677`,{6.350789863384564`,0.10620863182423489`},{11.643618882733707`,0.42916847944908687`},{6.308966819565534`,1.1812837939193248`}},{3.222146311374147`,{6.369479589018379`,0.11192462208602003`},{11.649625284805396`,0.4549203010529753`},{6.319311676922625`,1.185526004779626`}},{3.141592653589793`,{6.393181605748924`,0.11898938031144664`},{11.656027078273581`,0.46207127477642074`},{6.3299612786471116`,1.1997780613746118`}},{3.0649684425266277`,{6.419038895392902`,0.12701495897968235`},{11.661988713766924`,0.4507956041761985`},{6.340358271346354`,1.2177292064182752`}},{2.991993003418851`,{6.447980531783259`,0.135474719943487`},{5.887442774168763`,0.4683592490181676`},{6.386265304605172`,1.2373239489618792`}},{2.922411770781203`,{6.481868493319737`,0.14391133774533738`},{5.89058739902855`,0.48512534088039705`},{6.413012359006318`,1.2550665727715387`}},{2.8559933214452666`,{5.547584212527662`,0.1544102102627075`},{5.894232550258744`,0.49768756622446486`},{5.456735672502795`,1.2972894425272923`}},{2.792526803190927`,{5.565358566886164`,0.1676999181325746`},{5.898252830708518`,0.5044276736457871`},{5.4667828267540814`,1.341603449787958`}},{2.7318196987737333`,{5.582818762003676`,0.18057528751940408`},{6.05758335885864`,0.5168142806327366`},{5.495617528641802`,1.3774761671106135`}},{2.673695875395569`,{5.59991918462431`,0.1926199540011679`},{6.063551455481546`,0.5298110414607538`},{5.544466878474024`,1.4090110140530028`}},{2.6179938779914944`,{5.616549541362977`,0.20347025429913818`},{6.069715969091459`,0.5354533732666913`},{5.558166335804199`,1.4321574804255994`}},{2.564565431501872`,{5.63262157128328`,0.21282351204919966`},{6.075878584945356`,0.5334163091437696`},{5.571597924065457`,1.4425180872885495`}},{2.5132741228718345`,{5.648065012678065`,0.22044461606798413`},{6.081900487395777`,0.5237630826776003`},{5.584824068553825`,1.4399873798906673`}},{2.463994238109642`,{5.662889644862363`,0.22615599100064102`},{5.258358311834927`,0.5450588541234092`},{5.5975325989952385`,1.4249419071359013`}},{2.4166097335306103`,{5.678856340819615`,0.22988322294180522`},{5.262935957514073`,0.5712104533082196`},{5.6094061630051995`,1.398028169273216`}},{2.3710133234639947`,{5.697638291741884`,0.23170481062648168`},{5.267759423916308`,0.5931608388013779`},{5.621061839713765`,1.3602679347602238`}},{2.3271056693257726`,{5.7211273006151755`,0.2318163776832693`},{5.272726714896215`,0.6107630363279568`},{5.631729902254673`,1.312847934089731`}},{2.284794657156213`,{5.754365783338741`,0.230612506026628`},{5.405088754234873`,0.624552865784855`},{5.641600848730132`,1.2570480627191285`}},{2.243994752564138`,{5.785974019674352`,0.22840230052167917`},{5.407564764970359`,0.6450911177596814`},{5.650856764725756`,1.194211243492832`}},{2.2046264235717845`,{5.813877985932539`,0.22504672232564824`},{5.410057401883476`,0.6611586626217331`},{5.65922883835591`,1.1256786719053342`}},{2.1666156231653746`,{5.843817640039005`,0.22060539363610626`},{5.412533513939862`,0.6729263866894217`},{5.762200905722521`,1.063846695798321`}},{2.1298933244676563`,{4.5714549255994505`,0.216890265500816`},{5.414960443529516`,0.6804746153948806`},{4.503076206186106`,1.0359098550957566`}},{2.0943951023931957`,{4.581796502332562`,0.2170388060467347`},{5.417315030810211`,0.6840595525368754`},{4.508784003144177`,1.0063512707234183`}},{2.0600607564523234`,{4.594213740915634`,0.21634098857371004`},{5.41956805264762`,0.6839546738571317`},{4.514046462803348`,0.9739875676764091`}},{2.026833970057931`,{4.69310303361063`,0.21470008640996013`},{5.42170873408724`,0.6804578308392597`},{4.518953026464696`,0.9393019968175056`}},{1.9946620022792338`,{4.9226681953172`,0.21802632884884982`},{5.4237187226635495`,0.6739010266094764`},{4.52324035895065`,0.9028111290806946`}},{1.9634954084936207`,{4.933893519923424`,0.22341031271524237`},{5.425596417867744`,0.6646097093607638`},{4.8881845512447315`,0.8880215110914937`}},{1.9332877868244882`,{4.94602401728257`,0.22791035784137395`},{5.427335443868822`,0.6529163908668817`},{4.892114462119834`,0.8837831055610488`}},{1.9039955476301778`,{4.959317771009761`,0.23158923663875688`},{5.428925390747113`,0.6391484214726092`},{4.895786781821296`,0.875672822278945`}},{1.8755777036356975`,{4.974315850414192`,0.23452077084475795`},{5.4303635295979245`,0.6236208689729997`},{4.899164546212932`,0.8641437534246431`}},{1.8479956785822313`,{4.992064053973245`,0.23679163169885242`},{5.431666043297916`,0.6066291024800887`},{4.902508442832396`,0.849611839768051`}},{1.821213132515822`,{5.011805194209892`,0.23852005788556613`},{5.432832625708489`,0.5884603621146149`},{4.905388301548635`,0.8325160711111105`}},{1.7951958020513104`,{5.026203714437202`,0.23967451975572193`},{4.3207031833801315`,0.6081313488121778`},{4.908120396771083`,0.813202398208541`}},{1.7699113541350948`,{5.037620532751988`,0.24019256978113415`},{4.322209847430143`,0.6100187136922004`},{4.910676473306133`,0.7920578849612581`}},{1.7453292519943295`,{5.047246802910346`,0.24005654897727163`},{4.323653587042181`,0.610827504766833`},{4.913001775723726`,0.7693899937967505`}},{1.7214206321039962`,{5.055600784197172`,0.23927414563265306`},{4.3250316057396665`,0.610643238065263`},{4.915144555573831`,0.7454928133688004`}},{1.698158191129618`,{5.063088361175727`,0.23787618498086568`},{4.326346133034089`,0.6095538799812755`},{4.917042508257783`,0.72066348513856`}},{1.6755160819145565`,{5.0704617588611`,0.2358930724196959`},{4.327595402939608`,0.6076398888196857`},{5.0045191065747066`,0.694396194273862`}},{1.6534698176788385`,{5.077923350626204`,0.233372479537375`},{4.328778153843101`,0.6049745505826883`},{5.008286386677422`,0.6723930220059563`}},{1.6319961836830095`,{5.085473800575696`,0.23036046390440115`},{4.3298980805582055`,0.6016298768795643`},{5.011751164632179`,0.649761408793016`}},{1.6110731556870734`,{5.09317722930092`,0.2269036825327745`},{4.330954961404323`,0.5976766462479446`},{5.014889131503951`,0.6266815588840755`}},{1.590679824602427`,{5.101038759549191`,0.22304273315456438`},{4.331950019125785`,0.5931788827501526`},{5.017863084518677`,0.6033110750768743`}},{1.5707963267948966`,{5.109113584060005`,0.21882275011186442`},{4.332885197315162`,0.588195226655571`},{5.020183114616064`,0.579796730336063`}},{1.5514037795505151`,{5.11749591893241`,0.2142817796018532`},{4.333762289202767`,0.5827777484931982`},{5.0227231530650664`,0.5562590219497479`}},{1.5324842212633139`,{5.126343084545109`,0.20945591838375827`},{4.334585202265584`,0.5770036547820121`},{5.024857124443694`,0.5328126971514706`}},{1.5140205559468882`,{3.7431541402359563`,0.20993968007756428`},{4.3353534748020675`,0.5708961878087986`},{5.026757067623359`,0.5095647105871974`}},{1.4959965017094254`,{3.756417414138927`,0.21192214827048503`},{4.33606939064862`,0.5645083848311387`},{3.6870876393361094`,0.48739822940207567`}},{1.478396542865785`,{3.7738619323472884`,0.21381957628530646`},{4.336736864475378`,0.5578819231418691`},{3.6897416089468713`,0.4814987534359935`}},{1.4612058853906016`,{3.7975829104084555`,0.2156808811699451`},{4.337356403818669`,0.5510581680957232`},{3.6922499714697845`,0.4753330789940178`}},{1.444410415443583`,{3.832849573150508`,0.21761777184405173`},{4.3379264749493895`,0.5440737378558267`},{3.6945848170752367`,0.4689496524971138`}},{1.4279966607226333`,{3.8464923119061845`,0.2195454171759505`},{4.338461696013829`,0.5369512854078866`},{3.6968169347757494`,0.46235154025933534`}},{1.411951754422379`,{3.8557038617160235`,0.22136383981776073`},{4.338952790956767`,0.5297303689367175`},{3.6988747614878377`,0.4556034398159551`}},{1.3962634015954636`,{3.8630760356269853`,0.22304930366246647`},{4.3394060463351956`,0.5224373311029602`},{3.70087037731824`,0.44871907486182944`}},{1.3809198477317772`,{3.869328213570606`,0.22459720473325465`},{4.339815716512354`,0.5150966559710385`},{3.7027327505026824`,0.44173401253985184`}},{1.3659098493868667`,{3.8748083377307787`,0.22600370191475758`},{4.340202857551582`,0.5077269088207835`},{3.7045064084087507`,0.43466490427284693`}},{1.3512226467052875`,{3.879731266345605`,0.22727319054532927`},{4.340551355866336`,0.5003526233744559`},{3.8287972780003985`,0.4260985580937994`}},{1.3368479376977844`,{3.8841882574857123`,0.22840576379975466`},{4.340869511392445`,0.4929899312406919`},{3.830632431502688`,0.42054720859282124`}},{1.3227758541430708`,{3.8882666700357684`,0.22940606791845`},{4.34115742544947`,0.4856533881506834`},{3.832288133661877`,0.4148692974966467`}},{1.3089969389957472`,{3.8920352027248684`,0.23027803335198962`},{4.341418611706808`,0.4783607584324006`},{3.8339163292351413`,0.40908545322517265`}},{1.2955021251916674`,{3.895537718791282`,0.23102063271779325`},{4.341643695159985`,0.4711248382630744`},{3.835462544743692`,0.40320727117227473`}},{1.282282715750936`,{3.8988060725432154`,0.23165548852031298`},{4.341868208116413`,0.46395881522467575`},{3.8368680663004064`,0.3972790602963107`}},{1.269330365086785`,{3.901898959600412`,0.23217156113245896`},{4.342058782606121`,0.45687411642761716`},{3.8380955049366943`,0.39129553738682765`}},{1.2566370614359172`,{3.9049945621485063`,0.23257754781262524`},{4.342227103286834`,0.4498677934611359`},{3.8392369941327553`,0.38527136393012057`}},{1.2441951103325914`,{3.9080895915798926`,0.23287483008727666`},{4.885475871255565`,0.43754176930627275`},{3.8407119253103317`,0.37922094117866767`}},{1.231997119054821`,{3.911198140473258`,0.23307914144929293`},{4.885677906983395`,0.4347454832546711`},{3.842150620857142`,0.3731809715668039`}},{1.2200359819766187`,{3.91432391525131`,0.2331855574173463`},{4.88586929024431`,0.4317631323559067`},{3.8430549382820263`,0.36713023150406565`}},{1.2083048667653051`,{3.9174691952026577`,0.23321092060721132`},{4.8860501066977555`,0.42862214635680873`},{3.8439907249264986`,0.36110223576037465`}},{1.1967972013675403`,{3.9206631922975452`,0.23315037152693882`},{4.886221558838663`,0.4253352196904733`},{3.8451179163703246`,0.35509223639349574`}},{1.1855066617319974`,{3.923861543352931`,0.23301369257446836`},{4.886383517002557`,0.4219252342806246`},{3.8457753712702174`,0.3491186367431783`}},{1.1744271602204834`,{3.9270986761588795`,0.23280127339303572`},{2.920071470964189`,0.41999103573941887`},{3.8468848773208535`,0.34318000036458735`}},{1.1635528346628863`,{3.930370091934707`,0.23251949258220464`},{2.920274997302479`,0.41878073081026274`},{3.847753100476062`,0.3372855526344875`}},{1.152878038014603`,{3.9337149793926507`,0.23217394136887448`},{2.9204703545882174`,0.41755214284425096`},{3.8486319741866164`,0.3314529024213559`}},{1.1423973285781066`,{3.9371186767020743`,0.23176238048935177`},{2.9206577526033732`,0.416294800070356`},{3.8492076973487337`,0.32566743337616294`}},{1.1321054607530787`,{3.940625790574804`,0.2313012466927315`},{2.920839980854733`,0.41504066148637964`},{3.850024192539988`,0.31995091462828007`}},{1.121997376282069`,{3.9442250452187837`,0.2307836436771422`},{2.9210126869325888`,0.4137645739138157`},{3.8507911682609723`,0.3143033564066441`}},{1.1120681959609888`,{3.9479714611616554`,0.23021599365492582`},{2.92117888507952`,0.4124759147029985`},{3.8512314474297016`,0.30872571591453124`}},{1.1023132117858923`,{3.9518595878240754`,0.2296011838178635`},{2.921339470692776`,0.41117756526959875`},{3.8520382911962563`,0.3032104690246844`}},{1.0927278795094932`,{3.9559517679699523`,0.2289432052957512`},{2.921493967404488`,0.4098701516500698`},{3.8524964695619217`,0.29777567231781177`}},{1.0833078115826873`,{3.9603343814248513`,0.22824697516767892`},{2.9216423167399483`,0.4085570302547162`},{3.8530841920331618`,0.29242943256981113`}},{1.074048770458049`,{3.9651149990913304`,0.2275144291077506`},{2.9217856703908702`,0.4072410291662761`},{3.853687123099292`,0.2871471969703374`}},{1.0649466622338282`,{3.9704727697505557`,0.22675113298160596`},{2.9219227052413306`,0.4059183134490769`},{3.8540601885676136`,0.28195044916594647`}},{1.055997530618418`,{3.9768221694619803`,0.22595858688905482`},{2.9220564354702363`,0.40459213171517877`},{3.854636941221401`,0.27684222592812646`}},{1.0471975511965979`,{3.985364210262953`,0.22514673203813912`},{2.9221746532211332`,0.4032659491976367`},{3.8550350749969517`,0.27181527023917185`}}}},{0.15`,{{125.66370614359172`,{2.428221459501672`,0.00024015486219821993`},{2.405245333151792`,0.016226363984757193`},{2.025673199668023`,3.196818088021665`}},{62.83185307179586`,{2.449066111106108`,0.0013621985824121964`},{2.4237925349764353`,0.061183197558370074`},{2.4443243040273805`,5.538404642582575`}},{41.88790204786391`,{2.4717153205653823`,0.002832481741928735`},{2.511000280721948`,0.08933984159967151`},{2.6252512629951488`,4.733263531571164`}},{31.41592653589793`,{2.490929378391457`,0.004990591766171743`},{4.662602756431237`,0.1182075793289346`},{2.481741549814706`,5.122366138466201`}},{25.132741228718345`,{2.5131080798687995`,0.00814286899924727`},{2.5624158510506314`,0.1524956364698919`},{2.5013510184416154`,5.382137486260582`}},{20.943951023931955`,{2.4154165007388695`,0.011843271707764476`},{2.47541848347988`,0.263994935305657`},{2.4028412934950727`,5.481505201474089`}},{17.951958020513104`,{2.27155538305904`,0.015661097934692565`},{2.374418218889472`,0.2931178611332064`},{2.255904431953828`,5.240198776196572`}},{15.707963267948966`,{2.2887394493445252`,0.02118825589420266`},{2.3870156009772003`,0.37209654206912124`},{2.270485829380111`,5.451567837190864`}},{13.962634015954636`,{2.3094361736098317`,0.02826350463647122`},{2.3971806868833414`,0.41988172938502766`},{2.288883279913048`,5.776121813563917`}},{12.566370614359172`,{2.336002650163679`,0.03429352151262923`},{2.227546217677584`,0.47856123907456743`},{2.0820130756753077`,5.553414144567131`}},{11.423973285781067`,{2.3646925312307383`,0.03587754021055402`},{2.2475879500034375`,0.5273815183948679`},{2.104310031630303`,5.661723147559938`}},{10.471975511965978`,{2.153096511421388`,0.04595737914936537`},{2.2683435115182218`,0.5166984320141295`},{2.1261224427545704`,5.309524278595993`}},{9.666438934122441`,{2.174209542457248`,0.04731914481545555`},{2.2868552114159955`,0.464030595556727`},{2.1451518108239656`,4.693242257069615`}},{8.975979010256552`,{2.191632903929165`,0.046338129681399755`},{2.061567117265715`,0.4979087680669737`},{2.1606422855774867`,3.998100804307696`}},{8.377580409572783`,{2.2056525824885584`,0.04395417537807816`},{2.0721664755186455`,0.4888476964111835`},{2.1725789749874496`,3.3390078951045536`}},{7.853981633974483`,{5.808035681711697`,0.046585426613132405`},{2.080803412177866`,0.4745487819681523`},{5.766909660757882`,2.9910416537542464`}},{7.391982714328925`,{5.853723906785792`,0.05068271448661507`},{2.08785860720845`,0.45950011490626413`},{5.814064793160696`,2.8813105420324785`}},{6.981317007977318`,{5.898967969440643`,0.05056751729051622`},{2.093773640473614`,0.4454448858499743`},{4.653105171620219`,2.5972814304528633`}},{6.613879270715354`,{4.752724565146703`,0.05470743798746064`},{2.0989376116340077`,0.4323726772842976`},{4.714514042812785`,2.5040628505041345`}},{6.283185307179586`,{4.3633612307099465`,0.05763239382436614`},{4.592985160514558`,0.4680135542831395`},{3.3285981800532443`,2.2952747693157165`}},{5.983986006837702`,{4.3909113180843615`,0.06001514816292248`},{4.602610460374356`,0.46324318525911085`},{4.348364106649432`,2.27534918233523`}},{5.711986642890533`,{4.413221617002562`,0.05837677485595357`},{4.610246361489713`,0.42847142619390277`},{4.36741668702683`,2.0401102252333496`}},{5.463639397547467`,{1.980930034281312`,0.05510742811510024`},{2.115313587969069`,0.3726469720216619`},{4.380397007346127`,1.746933661329049`}},{5.235987755982989`,{1.9874207675777973`,0.056803469589497696`},{3.2871791350947848`,0.36010549349706256`},{5.9112935210199025`,1.630974607749852`}},{5.026548245743669`,{5.994151282225434`,0.0606516352514022`},{1.8312890519820524`,0.36047397100995227`},{5.931559285458908`,1.6134595199042017`}},{4.8332194670612205`,{6.025890527156499`,0.06363674862610151`},{1.834351031731899`,0.370995034921915`},{5.950250469296716`,1.5593744599475758`}},{4.654211338651545`,{6.061711928088776`,0.066453726653987`},{1.8374506511183422`,0.3804944733829688`},{5.974624493072001`,1.494262633561942`}},{4.487989505128276`,{6.085074056079678`,0.06939616002518276`},{1.84054961514522`,0.3887726333522349`},{6.040296748960958`,1.4449460193026216`}},{4.333231246330749`,{6.103480691046019`,0.07235490445913766`},{1.843612229925128`,0.39572398894321054`},{6.054438415810316`,1.4178931923227824`}},{4.188790204786391`,{6.123326060678607`,0.07509634231716739`},{1.8466087206109272`,0.40131196104496114`},{6.06704175315021`,1.3863582383530288`}},{4.053667940115862`,{6.149183290617374`,0.07750118775018468`},{1.8495104486368616`,0.40555312907168267`},{6.078604078692274`,1.3462744317018889`}},{3.9269908169872414`,{6.18117582995079`,0.07965328768675897`},{1.85229962387362`,0.40850688512800365`},{6.0891039454579685`,1.2959600667424418`}},{3.8079910952603555`,{6.205483848114342`,0.08148519232221324`},{1.8549608826064916`,0.41025404965496304`},{6.09839873888554`,1.2372847614496345`}},{3.6959913571644627`,{6.2297748978413745`,0.08301133999494384`},{1.8574824978845719`,0.410887552172962`},{6.166569148604269`,1.1849304910783016`}},{3.5903916041026207`,{6.257984443445116`,0.08456193674733921`},{1.8598532721635568`,0.41051561101607803`},{6.179017170417618`,1.1437401882523623`}},{3.490658503988659`,{6.295423329727855`,0.08655310124491186`},{1.8620868394324026`,0.4092413121539105`},{6.189669956198378`,1.1049385306977435`}},{3.396316382259236`,{6.3293022631726155`,0.08935600527927445`},{1.8641620557919587`,0.4071759122678707`},{6.199428705766347`,1.0712831813812544`}},{3.306939635357677`,{6.350306720723538`,0.09272211589052477`},{1.8660900966511322`,0.40441253617832673`},{5.441789736688994`,1.0843537494650204`}},{3.222146311374147`,{5.527102664153941`,0.0975800885453415`},{1.8678788546162137`,0.40105261219342625`},{5.4418600917741395`,1.0903104678233513`}},{3.141592653589793`,{5.5316959372360905`,0.1040972914577326`},{1.8695219169561834`,0.39718420030832635`},{5.44209428042102`,1.1051253033415538`}},{3.0649684425266277`,{5.538809660908928`,0.11155483934413209`},{1.8710444832512545`,0.39288508854723886`},{5.442834115477263`,1.1264883066824556`}},{2.991993003418851`,{5.548723081855934`,0.11976770102662358`},{5.886289278757334`,0.4140629852464531`},{5.44411348841537`,1.1514398675516424`}},{2.922411770781203`,{5.559797738316862`,0.12849084323448023`},{5.888951473443558`,0.42076955170639085`},{5.4460491510933915`,1.1768138311984946`}},{2.8559933214452666`,{5.571678503415791`,0.137442437183515`},{5.89182869907428`,0.424670712787076`},{5.44865164114248`,1.1996715617461073`}},{2.792526803190927`,{5.584051469653762`,0.14633263200638602`},{5.894861915548309`,0.42493888052242584`},{5.451844964038999`,1.2175393436235065`}},{2.7318196987737333`,{5.596744057168846`,0.15488008264374434`},{5.897974087739927`,0.42099779217691635`},{5.4555243236413204`,1.228511426599609`}},{2.673695875395569`,{5.609499351579213`,0.1628249338956357`},{6.061224712976225`,0.42881760270159835`},{5.459740688168841`,1.2315640647782282`}},{2.6179938779914944`,{5.622157423194228`,0.16994397113345353`},{6.065771934587197`,0.43096348688571146`},{5.546806015615466`,1.2335653868096275`}},{2.564565431501872`,{5.634609068153509`,0.17603931113616572`},{6.070300883664415`,0.42831812764418403`},{5.555738355750696`,1.2344754599197079`}},{2.5132741228718345`,{5.6467272636717984`,0.18095921183200342`},{5.25794170277708`,0.4497588822597047`},{5.5645355025464855`,1.2270964086358864`}},{2.463994238109642`,{5.6584240298214326`,0.18458742859380325`},{5.261033091271156`,0.47135345758673836`},{5.573185414024986`,1.211562002902207`}},{2.4166097335306103`,{5.670298430814792`,0.1868550534602305`},{5.264414118881519`,0.4904759452427303`},{5.581856626137637`,1.188272019107084`}},{2.3710133234639947`,{5.683688658955185`,0.18777052219217963`},{5.267987469069697`,0.5068797950873873`},{5.589889778683792`,1.157828883542444`}},{2.3271056693257726`,{5.699207739037714`,0.18740617776028815`},{5.271677365501946`,0.5204187613085746`},{5.59773551658928`,1.1209425789602947`}},{2.284794657156213`,{5.718256109777656`,0.18588637838898328`},{5.405690587573249`,0.5307646287322442`},{5.604715952052224`,1.078409506541998`}},{2.243994752564138`,{5.745874190176766`,0.18344050462213088`},{5.407511938442858`,0.5471394463254213`},{5.611457705690893`,1.0311035372441346`}},{2.2046264235717845`,{5.7748616258191205`,0.1803487311046378`},{5.409360704264867`,0.5605476774896344`},{5.617720540831649`,0.9799133828466384`}},{2.1666156231653746`,{4.55535075940832`,0.18168054363730193`},{5.411217351534184`,0.5709998640155155`},{4.4761145195820005`,0.9339340997534696`}},{2.1298933244676563`,{4.562234139646606`,0.18275094191231006`},{5.413060558272952`,0.5785543029634408`},{4.480378409525505`,0.9151387558022676`}},{2.0943951023931957`,{4.569432870583099`,0.18307168454763972`},{5.41486256130434`,0.5833250654780024`},{4.484378471387999`,0.8936299701128024`}},{2.0600607564523234`,{4.57737862076684`,0.18269197085877467`},{5.416617063624451`,0.5854565441598948`},{4.488148868960083`,0.8698049945328932`}},{2.026833970057931`,{4.586393672514247`,0.18167008784009908`},{5.41830287177055`,0.585124200849423`},{4.491657907681222`,0.8440425982313732`}},{1.9946620022792338`,{4.5973568380376815`,0.18007605620975045`},{5.419912581835941`,0.5825231150201067`},{4.494910382650453`,0.8166901651748403`}},{1.9634954084936207`,{4.933554924177819`,0.1839387686034445`},{5.421434262198384`,0.5778484118734113`},{4.497996928848261`,0.7880867869474211`}},{1.9332877868244882`,{4.943270027156028`,0.18801458655584252`},{5.422869393729902`,0.5713178705104652`},{4.886751392534079`,0.7516348920720166`}},{1.9039955476301778`,{4.953815480430193`,0.19144102863125076`},{5.424201458239113`,0.5631394930532703`},{4.88880435944604`,0.7496514118609139`}},{1.8755777036356975`,{4.965449850019722`,0.1942608655294826`},{5.425446355469152`,0.553521192751179`},{4.890818023336108`,0.7448119518495945`}},{1.8479956785822313`,{4.978604606204676`,0.1965215456132946`},{5.4265806708720925`,0.5426608591171918`},{4.892691306796124`,0.7374246053883677`}},{1.821213132515822`,{4.994307093712505`,0.19828773920456227`},{4.316577591517731`,0.5406687088721298`},{4.894431390690973`,0.7277768096703927`}},{1.7951958020513104`,{5.011351725842871`,0.19963509062775983`},{4.317885025461987`,0.544646483510012`},{4.896135893285091`,0.7161636834955731`}},{1.7699113541350948`,{5.023696113997654`,0.20053912587517028`},{4.319152496873069`,0.5476825755996009`},{4.897730617459203`,0.7028528964307925`}},{1.7453292519943295`,{5.033587977067523`,0.20095123552839117`},{4.320380572963768`,0.5498249963129656`},{4.899203953343955`,0.688048176129192`}},{1.7214206321039962`,{5.0419528559137845`,0.20088750490021498`},{4.321562596422672`,0.5511661703558064`},{4.900739689099095`,0.6720569369893845`}},{1.698158191129618`,{5.049253111889706`,0.2003345917201153`},{4.322701411348861`,0.5517328632642378`},{4.902049046739404`,0.6550280686290889`}},{1.6755160819145565`,{5.055745087612674`,0.19931897774231191`},{4.323789796265778`,0.551595791740886`},{4.90323222176499`,0.63718418109275`}},{1.6534698176788385`,{5.061592074481802`,0.1978573495144014`},{4.324841189297977`,0.5508042098938694`},{4.904336104466549`,0.6186865758968662`}},{1.6319961836830095`,{5.067266277399951`,0.19597908127356423`},{4.3258405601996355`,0.5494179205246835`},{4.9053025938267805`,0.5997039806812485`}},{1.6110731556870734`,{5.072979711550136`,0.19371784806627695`},{4.326795416647831`,0.5474870293213437`},{4.906297851086434`,0.5803874356554721`}},{1.590679824602427`,{5.078675443380427`,0.19110050652348107`},{4.327703765398804`,0.5450581659463571`},{4.907201449501073`,0.5608513742861561`}},{1.5707963267948966`,{5.084365118061784`,0.18815615999995672`},{4.328560772006184`,0.5421784489515207`},{4.907967864868427`,0.5412064742849543`}},{1.5514037795505151`,{5.090093161236828`,0.18492109557947115`},{4.329387253712812`,0.5388943551954759`},{4.9087094484739495`,0.5215750903864167`}},{1.5324842212633139`,{3.72135253201346`,0.183744326214425`},{4.330162052575166`,0.5352449533074652`},{4.9093572083739705`,0.5020364537127104`}},{1.5140205559468882`,{3.729517174091271`,0.18588777476350893`},{4.330895335891362`,0.5312610718199725`},{4.909937946092768`,0.4826580109539462`}},{1.4959965017094254`,{3.7386511256015824`,0.18790901729690107`},{4.331589208676793`,0.5270042050973085`},{4.910449406975233`,0.46353825875103327`}},{1.478396542865785`,{3.749369962136989`,0.1898108441885294`},{4.332242708426618`,0.522486066844434`},{4.910902279532124`,0.44470592571884593`}},{1.4612058853906016`,{3.7631395799866914`,0.19161830142081246`},{4.332857004619254`,0.5177465910565588`},{3.6829630758196563`,0.43036718890583636`}},{1.444410415443583`,{3.781227795990311`,0.19333992224019214`},{4.333434875888451`,0.5127979717736243`},{3.6844530091688377`,0.4262784482097811`}},{1.4279966607226333`,{3.810936250421767`,0.19511205487542072`},{4.333979587786256`,0.507709779003409`},{3.6859793777055643`,0.4220655039518221`}},{1.411951754422379`,{3.839043446611507`,0.19694702527842672`},{4.334490552421529`,0.5024718342197891`},{3.687279240655155`,0.4175611968788797`}},{1.3962634015954636`,{3.8493149566402707`,0.19872215379299685`},{4.334966886400648`,0.4971155561240597`},{3.6885754724654696`,0.4128644240428888`}},{1.3809198477317772`,{3.8569359350031873`,0.20039266665641617`},{4.335413404645297`,0.4916653673518458`},{3.6898916273287097`,0.40800118500347776`}},{1.3659098493868667`,{3.8632263163711875`,0.20195027636102814`},{4.335832788418228`,0.4861394871581873`},{3.69112014174006`,0.4029960463870069`}},{1.3512226467052875`,{3.868649443596526`,0.20339169636004414`},{4.336219302341866`,0.48055725416697204`},{3.69233777169228`,0.39787146165773163`}},{1.3368479376977844`,{3.8734559334031875`,0.20471919931174654`},{4.336583168680406`,0.474935273388122`},{3.693418669080152`,0.3926536169961832`}},{1.3227758541430708`,{3.877790924733708`,0.20592671812591248`},{4.336920539784745`,0.4692915552781303`},{3.694453394113888`,0.3873388428622929`}},{1.3089969389957472`,{3.8817619426729495`,0.20703367744277443`},{4.337234052203469`,0.46363202947900645`},{3.6955218929729248`,0.3819783905082219`}},{1.2955021251916674`,{3.885417214048918`,0.2080238383536867`},{4.337523149305006`,0.4579752069463301`},{3.696487034505785`,0.37655787449717804`}},{1.282282715750936`,{3.888817497339989`,0.20891084187042527`},{4.337792532984277`,0.45233268580767916`},{3.6973989095426028`,0.3711074628257827`}},{1.269330365086785`,{3.8919809336889486`,0.20969379732989124`},{4.338040039834886`,0.4467157045951006`},{3.6982655815719663`,0.36563239465266795`}},{1.2566370614359172`,{3.8949333157554142`,0.21037854068057046`},{4.338268923299829`,0.4411272739853633`},{3.6991068448614106`,0.3601476936708514`}},{1.2441951103325914`,{3.8977187029374307`,0.21096843034554486`},{4.3384790005656955`,0.4355815465703861`},{3.831049214699049`,0.3516135069980814`}},{1.231997119054821`,{3.90034399705867`,0.21146804362823193`},{4.338673714534928`,0.4300869296602754`},{3.8318196905541666`,0.3471959406241424`}},{1.2200359819766187`,{3.902914382481614`,0.2118768039915676`},{4.3388500897348194`,0.4246451820382714`},{3.832620278177811`,0.34272749552919224`}},{1.2083048667653051`,{3.9054883113747936`,0.21220381180088393`},{4.3390126482773566`,0.41926544735697086`},{3.833336545663569`,0.33822660655941905`}},{1.1967972013675403`,{3.9080604959940892`,0.2124499054607235`},{4.33915955124237`,0.4139515713761997`},{3.8340223377981304`,0.33369623914621127`}},{1.1855066617319974`,{3.9106332979586313`,0.21262459537967054`},{2.917599078476457`,0.4037707413032549`},{3.8347201043704326`,0.3291563598158337`}},{1.1744271602204834`,{3.9132151101893387`,0.2127220449890978`},{2.917823012989392`,0.40302670859675355`},{3.8353562333352764`,0.32460012553619483`}},{1.1635528346628863`,{3.91580341844726`,0.2127527553855336`},{2.9180343874033863`,0.40225416206132925`},{3.835910451725733`,0.32004515510360576`}},{1.152878038014603`,{3.918403336782519`,0.21272001954045594`},{2.918242689748524`,0.40145576256156057`},{3.836484932949805`,0.31549886463544907`}},{1.1423973285781066`,{3.9210321457915316`,0.2126259573849907`},{2.918443646892574`,0.4006252915577729`},{3.8370102961701593`,0.31096281389575253`}},{1.1321054607530787`,{3.9236605326907843`,0.21247309993240962`},{2.9186384738305846`,0.39977979053768986`},{3.8376805333947406`,0.3064496816445599`}},{1.121997376282069`,{3.9263042106681345`,0.2122642833666751`},{2.91882637467123`,0.39890827803410955`},{3.8381943720116674`,0.30195558573218756`}},{1.1120681959609888`,{3.928960898451234`,0.21200699022520364`},{2.9190112559082086`,0.39801909689691767`},{3.8383309405712867`,0.2974908985861252`}},{1.1023132117858923`,{3.9316627678307112`,0.21169651307680978`},{2.919185746659771`,0.397109871781739`},{3.8389888449016425`,0.2930600768510354`}},{1.0927278795094932`,{3.934401338502805`,0.2113448206932271`},{2.9193552518581303`,0.39618894423138507`},{3.839313342264161`,0.28866519641427413`}},{1.0833078115826873`,{3.9371794867809906`,0.21094216589035497`},{2.919518968620617`,0.3952462883262167`},{3.840265839822182`,0.2843061447440034`}},{1.074048770458049`,{3.9400095135761934`,0.210502144556468`},{2.919677348769445`,0.3942947212973957`},{3.840533003244286`,0.27999113374912`}},{1.0649466622338282`,{3.942898694365563`,0.2100233659381841`},{2.919830359806381`,0.3933309704473176`},{3.8409411105357583`,0.2757318741940139`}},{1.055997530618418`,{3.9458631947284424`,0.2095072437468507`},{2.919978329514422`,0.39235722141747614`},{3.84138307054498`,0.27150774484077717`}},{1.0471975511965979`,{3.9489284323136578`,0.20895839030436622`},{2.9201206259979493`,0.39137604893139893`},{3.8416732436776115`,0.26733578382313694`}}}},{0.2`,{{125.66370614359172`,{2.027876066153988`,0.00020060854285409952`},{2.405504978579378`,0.0151047589717294`},{2.4263384088952478`,3.757136811492339`}},{62.83185307179586`,{2.4498113007509263`,0.0012397020773774808`},{2.423859198648456`,0.056999659210940364`},{2.4434452993112568`,5.144225712656108`}},{41.88790204786391`,{2.4720236082035734`,0.0025880896178584888`},{2.5110537784311067`,0.07616854234792345`},{2.4625809097541342`,4.8106888638613485`}},{31.41592653589793`,{2.4916179210510583`,0.004425645294993267`},{4.662419232567279`,0.10113635758713047`},{2.479364476011947`,4.67533498471763`}},{25.132741228718345`,{2.514292104965017`,0.006737148581514286`},{4.675072960325241`,0.1060749287114193`},{2.4990465014579666`,4.6120505800392975`}},{20.943951023931955`,{2.2560150235141276`,0.010041287246366102`},{2.4736034366390522`,0.22136506989711494`},{2.4004198151095157`,4.89461552334113`}},{17.951958020513104`,{2.2732069666565553`,0.014133561443290065`},{2.3768275535923102`,0.25695333721209046`},{2.252269035890822`,4.859582698698938`}},{15.707963267948966`,{2.2909827299993966`,0.018770554093010046`},{2.386847731546381`,0.3221880113284848`},{2.26704560131661`,4.986140035620407`}},{13.962634015954636`,{2.0894070176707076`,0.022331228764840776`},{2.3957162983984195`,0.35008676800325`},{2.284518729871162`,5.053213839257042`}},{12.566370614359172`,{2.3353893385302578`,0.027597574869061767`},{2.2276160798691924`,0.4091129108440253`},{2.0792942657882234`,4.9631221007352515`}},{11.423973285781067`,{2.129653320649064`,0.03521399754254518`},{2.2445508700537298`,0.4430587814282084`},{2.097620015253206`,4.9748983105990945`}},{10.471975511965978`,{2.150654156242123`,0.038903494583179314`},{2.262026204261963`,0.43626601288538974`},{2.1156998255657617`,4.672010434226948`}},{9.666438934122441`,{2.1694615135974264`,0.04035501776370942`},{2.045778050883488`,0.4324573999863343`},{2.131932714409086`,4.182820586943748`}},{8.975979010256552`,{2.185396598520404`,0.04002545513372262`},{2.0568861988633493`,0.442938083896408`},{2.145396458276055`,3.6307748033839395`}},{8.377580409572783`,{2.1984660984561994`,0.03849447427375822`},{2.066523935747755`,0.4418295879413232`},{2.1561731715157593`,3.095690651919071`}},{7.853981633974483`,{5.811815413027196`,0.03741005862044745`},{2.074706577883171`,0.434810765214378`},{1.8826573033615448`,2.6592615963533377`}},{7.391982714328925`,{5.8501775589314216`,0.04027951768049481`},{2.081632222938955`,0.4253262918866975`},{1.889661711935117`,2.457209790413237`}},{6.981317007977318`,{1.944141460204691`,0.042115835998862775`},{2.0875795076628365`,0.41499945978`},{1.8955330130832413`,2.2886975980355295`}},{6.613879270715354`,{1.9513096227157023`,0.04375489446589864`},{2.092788958073185`,0.40424567832732256`},{1.900221169640677`,2.148627433061775`}},{6.283185307179586`,{4.365831121323412`,0.04635251828211254`},{2.097446348235849`,0.3928551316556662`},{1.904739917484236`,2.0301459072435275`}},{5.983986006837702`,{4.3858714534469305`,0.04891554434711019`},{4.598222528956287`,0.3914458151158557`},{4.33414191971637`,1.9248497875685642`}},{5.711986642890533`,{1.9708946309398057`,0.04894437570313063`},{2.1054562930512524`,0.3665869535955258`},{1.913414777357639`,1.832379938824292`}},{5.463639397547467`,{1.9771923479744895`,0.050472203490418005`},{2.108867650747556`,0.3511843918964021`},{1.9173707334834662`,1.7432110221163035`}},{5.235987755982989`,{1.9833962883348626`,0.051755879867395944`},{2.1118747698675597`,0.334237085923361`},{1.921448711589653`,1.6566728225771354`}},{5.026548245743669`,{1.989474441516007`,0.052731933216964684`},{1.8282047011113918`,0.34078450175254865`},{5.9082883758932825`,1.451418725452083`}},{4.8332194670612205`,{6.02118512671958`,0.054887237323623446`},{1.8311530338215503`,0.34980055579134334`},{5.926220413631402`,1.4050022561766764`}},{4.654211338651545`,{6.058218512624558`,0.05745105081588337`},{1.834085060673862`,0.3580123398369107`},{5.941250536098889`,1.3508917494389545`}},{4.487989505128276`,{6.082141828035291`,0.06004026051358439`},{1.8369919669101353`,0.3652657842764378`},{5.956022010054594`,1.293985149085163`}},{4.333231246330749`,{6.100205266601349`,0.06242973982109085`},{1.8398484269640547`,0.37148301680382695`},{6.045242083245904`,1.2499393354138402`}},{4.188790204786391`,{6.1181734721649095`,0.0645184967739339`},{1.8426355828347416`,0.376621834085377`},{6.055577749083952`,1.225447109914788`}},{4.053667940115862`,{6.140837846509141`,0.06633261860317619`},{1.8453361168011646`,0.3806863927869231`},{6.064906371087303`,1.194008408835934`}},{3.9269908169872414`,{6.172352857410039`,0.06803727612990956`},{1.8479330213785365`,0.3837123061682296`},{5.426437493423013`,1.145146312882461`}},{3.8079910952603555`,{5.493358667650021`,0.07046383425166534`},{1.8504209580657163`,0.385751783102149`},{5.4280878213283055`,1.1363583516401667`}},{3.6959913571644627`,{5.499798393081404`,0.07376760246558203`},{1.8527916073961317`,0.3868742969552075`},{5.429549069877936`,1.1252718636390566`}},{3.5903916041026207`,{5.506204249224031`,0.07710817890334391`},{1.8550363341448102`,0.3871551978471235`},{5.430831157740997`,1.113671549134518`}},{3.490658503988659`,{5.51250634070949`,0.08062999281628272`},{1.8571551818527716`,0.3866695739101296`},{5.431866448395966`,1.1035581274401645`}},{3.396316382259236`,{5.518800889952977`,0.08447424673653056`},{1.859140120282479`,0.38550018509111406`},{5.432700223525471`,1.0965804878393755`}},{3.306939635357677`,{5.5254850195177445`,0.08874986483825469`},{1.861009291024566`,0.3837244134901588`},{5.433471023756009`,1.0937260875376393`}},{3.222146311374147`,{5.5331853025009305`,0.0935162684992255`},{1.8627449024863034`,0.38141488806936885`},{5.434192302097316`,1.0951990834167111`}},{3.141592653589793`,{5.5427381257969115`,0.09877855993052007`},{1.8643706670205091`,0.3786439332771731`},{5.435046519745067`,1.100448813186447`}},{3.0649684425266277`,{5.552654617817129`,0.10448636276019851`},{1.86587443272465`,0.3754717746041205`},{5.436119888508441`,1.1083695334668024`}},{2.991993003418851`,{5.56249478818033`,0.11053086503241591`},{1.8672728050896257`,0.3719623972694917`},{5.43743378534029`,1.1174950090014935`}},{2.922411770781203`,{5.572450712395202`,0.11676894096485518`},{1.8685607201750418`,0.3681708855938414`},{5.43902247314146`,1.1262226824956494`}},{2.8559933214452666`,{5.582602144641924`,0.1230379481593518`},{1.8697641578281607`,0.3641410030892814`},{5.441008002140254`,1.1330668037993672`}},{2.792526803190927`,{5.592928021001588`,0.1291667838790332`},{5.8913200938246995`,0.3679996925316619`},{5.443238269373502`,1.1366415761644642`}},{2.7318196987737333`,{5.603305978530801`,0.1349883749913722`},{5.893758575442063`,0.36275082800075026`},{5.445644299946909`,1.1359212344966059`}},{2.673695875395569`,{5.613696736079429`,0.14034571350081068`},{5.896160176970313`,0.3546302751305209`},{5.448282861810008`,1.1301303379305603`}},{2.6179938779914944`,{5.623996465926862`,0.14509561678294555`},{5.2559122764871535`,0.36571344318756316`},{5.451061839129686`,1.1188070558256382`}},{2.564565431501872`,{5.634119404352466`,0.14912068616818225`},{5.257823201119463`,0.38403998019517344`},{5.453913976046511`,1.1018115796355774`}},{2.5132741228718345`,{5.643998219578967`,0.1523243944939267`},{5.260003249716153`,0.40127601998641926`},{5.550134799095121`,1.0802673945606576`}},{2.463994238109642`,{5.653563589728505`,0.15463116036374983`},{5.262414507024369`,0.41711291581381116`},{5.556160415789928`,1.0655168439050586`}},{2.4166097335306103`,{5.6628084281644275`,0.15599447558588359`},{5.265014664727088`,0.43131288551393393`},{5.562037697425649`,1.0456253511590936`}},{2.3710133234639947`,{5.672620629338705`,0.15639387345584152`},{5.267762236054762`,0.4436909145283467`},{5.567833838110648`,1.0209059268508682`}},{2.3271056693257726`,{5.683464592887935`,0.1558685729197771`},{5.404754582201878`,0.44641450772193375`},{5.573271835858263`,0.991880276860825`}},{2.284794657156213`,{5.6956515667217875`,0.15445905184721662`},{5.4060874196459014`,0.4614986134222968`},{5.578465091054543`,0.9589650981877497`}},{2.243994752564138`,{5.709861796183412`,0.15224570141458504`},{5.40747317899221`,0.47462683808849937`},{5.583565188382911`,0.9227867897596572`}},{2.2046264235717845`,{4.543485563001004`,0.1538605089515491`},{5.408884015565678`,0.48572770796249304`},{4.372384658611753`,0.88563683202375`}},{2.1666156231653746`,{4.549693809016761`,0.15541341300771566`},{5.41031073579153`,0.4947861727041323`},{4.37481365595715`,0.8671443906882134`}},{2.1298933244676563`,{4.555560947735144`,0.15638005079345388`},{5.4117357264741015`,0.5018212093987093`},{4.377161595987249`,0.8466439809480188`}},{2.0943951023931957`,{4.561128204251432`,0.1567724531966785`},{5.413140005878699`,0.5068842991093255`},{4.3793969959924`,0.8244316904033763`}},{2.0600607564523234`,{4.566803016541673`,0.15661205397250447`},{5.414522173985111`,0.5100529389102424`},{4.4135376493332465`,0.8310239962863744`}},{2.026833970057931`,{4.57292242027682`,0.15592858008989366`},{5.415873492133692`,0.5114212982287732`},{4.383482873082191`,0.7760146898948006`}},{1.9946620022792338`,{3.1644598567974658`,0.1576804069240204`},{5.4171687877241625`,0.5111126308352966`},{4.477373163999896`,0.7510332464617696`}},{1.9634954084936207`,{3.1733663324155623`,0.15893082386743113`},{5.418411368784204`,0.5092432318200764`},{4.479625850289079`,0.7293468132187015`}},{1.9332877868244882`,{3.183957626371637`,0.16004820513000068`},{5.419595352495642`,0.5059492413293345`},{4.481735642939385`,0.706763059154183`}},{1.9039955476301778`,{3.198170970650503`,0.16106318299697212`},{5.420717193837805`,0.501366495391065`},{4.483709388785348`,0.6834864533323151`}},{1.8755777036356975`,{4.960726523043691`,0.1630455020309223`},{5.421771979178362`,0.495630767693007`},{3.059999961968904`,0.676473175600254`}},{1.8479956785822313`,{4.970998156422508`,0.16521684565668673`},{5.422756367110836`,0.4888761820337124`},{4.888449313780813`,0.6510267614028068`}},{1.821213132515822`,{4.982668262902417`,0.16697113510564185`},{5.423673889131932`,0.4812379092851354`},{4.889515222356327`,0.6462655394402606`}},{1.7951958020513104`,{4.996713187559985`,0.16835070716335954`},{4.31573205269025`,0.49299174404182844`},{4.8905676626317405`,0.6398085966984034`}},{1.7699113541350948`,{5.011242907825978`,0.16940503733637335`},{4.316800977896652`,0.49660475759898665`},{4.8915802018814025`,0.6318593754475115`}},{1.7453292519943295`,{5.021791790794874`,0.17011074839176224`},{4.317844076706926`,0.4995004431190777`},{4.892570686944583`,0.6225914072127428`}},{1.7214206321039962`,{5.030322327950213`,0.17045026916397119`},{4.318857136270888`,0.5017292892220383`},{4.893477583821849`,0.6121884619673832`}},{1.698158191129618`,{5.037609375379496`,0.1704159519871519`},{4.3198407807615995`,0.5033222710741453`},{4.894379304170089`,0.6007937584107598`}},{1.6755160819145565`,{5.043996983006841`,0.17001913432325472`},{4.32079342332573`,0.5043260724984107`},{4.89519212135435`,0.5885661514552984`}},{1.6534698176788385`,{5.049696060611934`,0.1692680078969991`},{4.321713521716777`,0.50477340397506`},{4.8959636047235815`,0.5756325595615573`}},{1.6319961836830095`,{5.054849400355296`,0.16818244813480476`},{4.322600081355815`,0.5047101328879049`},{4.896705455060908`,0.5621303800125703`}},{1.6110731556870734`,{5.059512280175057`,0.16677618586862702`},{4.323453271212507`,0.504169367627381`},{4.897362034250186`,0.5481668775375088`}},{1.590679824602427`,{5.063941532948547`,0.1650704163423727`},{4.32426898339834`,0.5031925977881612`},{4.8979819328710335`,0.5338483792054882`}},{1.5707963267948966`,{5.068317894193232`,0.16308546116070696`},{4.325055797107425`,0.5018121924759703`},{4.898587833265166`,0.519290591240355`}},{1.5514037795505151`,{3.272612493164673`,0.16259614702056394`},{4.325814895211487`,0.5000594827812668`},{4.899123490254175`,0.5045477996629952`}},{1.5324842212633139`,{3.7145731255050345`,0.1633347310339293`},{4.326530818566619`,0.49796650325975406`},{4.899618845584992`,0.489714955967658`}},{1.5140205559468882`,{3.7216118807439926`,0.16550057005478222`},{4.327219078671499`,0.4955756344414864`},{4.900208327634595`,0.47485314249515653`}},{1.4959965017094254`,{3.7287254989798426`,0.16752223217782627`},{4.327871089768563`,0.4928925987866502`},{4.900621617736338`,0.4600400066346051`}},{1.478396542865785`,{3.736632098466921`,0.16944223620486457`},{4.328498182930383`,0.48996564885352256`},{4.900947294729822`,0.44531244701604167`}},{1.4612058853906016`,{3.745711492753499`,0.1712561219922461`},{4.329090426700782`,0.4868110961862994`},{3.07610485398003`,0.4397141557113332`}},{1.444410415443583`,{3.7568841357556497`,0.17298308359596376`},{4.329656935061204`,0.48345548092148355`},{3.0763194426784812`,0.42936365678292043`}},{1.4279966607226333`,{3.771800588389016`,0.17464466026077013`},{4.330188747212363`,0.4799219727975182`},{3.0765804757201347`,0.4192452888471697`}},{1.411951754422379`,{3.792726346721161`,0.17627301123524403`},{4.330698799930056`,0.47623299677573694`},{3.076946835495491`,0.409398211682921`}},{1.3962634015954636`,{3.832593389245152`,0.1779582275686195`},{4.331183240451588`,0.47240168000954086`},{3.07717493643218`,0.3997704517979688`}},{1.3809198477317772`,{3.844465300826326`,0.17967159074288924`},{4.33164038897143`,0.4684481429989813`},{3.0773765101741812`,0.39040718134310703`}},{1.3659098493868667`,{3.8522859745780047`,0.18129281189594498`},{4.332070488824654`,0.46440380281376276`},{3.0776183670113064`,0.38130087219218545`}},{1.3512226467052875`,{3.858522549671159`,0.18282847025042823`},{4.332476847803038`,0.4602705370675549`},{3.077814498033126`,0.3723986141414172`}},{1.3368479376977844`,{3.863836080210389`,0.18426349893729307`},{4.332862481991002`,0.4560594541989964`},{3.6866507124642838`,0.3661078913903939`}},{1.3227758541430708`,{3.868500490204933`,0.18560529035935308`},{4.333223691907192`,0.45179449500140567`},{3.6874093143786917`,0.36238249868644135`}},{1.3089969389957472`,{3.8726873104903885`,0.18684840973825073`},{4.33356712129484`,0.4474821357244578`},{3.6881293065551715`,0.3585469856344329`}},{1.2955021251916674`,{3.8765024803688863`,0.18799833234322658`},{4.3338906447595145`,0.443137325030682`},{3.688826096955803`,0.3546233692845091`}},{1.282282715750936`,{3.8800101130710907`,0.18905445863675385`},{4.334194817215439`,0.4387696921739374`},{3.689558990621229`,0.3506193707692089`}},{1.269330365086785`,{3.883267952688108`,0.19002392974267454`},{4.334479183516544`,0.4343879624016079`},{3.6902149685035055`,0.34655966046175934`}},{1.2566370614359172`,{3.8863096073892986`,0.19090084666881177`},{4.334746658717532`,0.42999978514536485`},{3.690793424899396`,0.3424381238618539`}},{1.2441951103325914`,{3.889149642771123`,0.1916958427557153`},{4.334999703366619`,0.42561801615511`},{3.6914459544957143`,0.33828172261365985`}},{1.231997119054821`,{3.891830175968608`,0.1924074194442502`},{4.335233348526958`,0.4212459344842251`},{3.69200469218425`,0.33409575333134967`}},{1.2200359819766187`,{3.8943512137473655`,0.19304019686972634`},{4.33545405444557`,0.41689123296325065`},{3.692579327351187`,0.3298788693115349`}},{1.2083048667653051`,{3.896755268798315`,0.19359688207628714`},{4.335660372194076`,0.4125617387675201`},{3.693098381782963`,0.3256539314211649`}},{1.1967972013675403`,{3.899016004263732`,0.1940782375129129`},{4.335854015690018`,0.4082597841558554`},{3.6936030182891066`,0.32141951506491684`}},{1.1855066617319974`,{3.9011808139939155`,0.1944887670932187`},{4.336030895158184`,0.4039930340936888`},{3.694087952994247`,0.31718555979168106`}},{1.1744271602204834`,{3.9033380087548264`,0.1948298393355384`},{4.336190786778916`,0.39976273102561577`},{3.694522483337938`,0.3129597110213464`}},{1.1635528346628863`,{3.9054921327033028`,0.19511005912524157`},{4.336357673678233`,0.39557947729672444`},{3.6949938880515942`,0.3087474596982124`}},{1.152878038014603`,{3.907646446498894`,0.19532886663081603`},{2.916244161100072`,0.38568201291304294`},{3.8308969154212846`,0.29827394276887476`}},{1.1423973285781066`,{3.909792090206812`,0.19548215586935272`},{2.916453578381559`,0.3852161071319623`},{3.8313346936562334`,0.2948290028338394`}},{1.1321054607530787`,{3.9119413052872516`,0.19558279089116684`},{2.9166566143258534`,0.3847245580611383`},{3.831782427377433`,0.2913763348529905`}},{1.121997376282069`,{3.9140912141485833`,0.1956289247172067`},{2.9168535193874243`,0.3842060533370847`},{3.696588148456929`,0.2920982104205162`}},{1.1120681959609888`,{3.9162447805018497`,0.19562663261019042`},{2.9170445332886334`,0.3836643181179671`},{3.8325363091532054`,0.28444682729022636`}},{1.1023132117858923`,{3.918398409362863`,0.1955717089902942`},{2.917229874047629`,0.38309483894828683`},{3.832931478682406`,0.280977737230259`}},{1.0927278795094932`,{3.9205807205333745`,0.19547001425568555`},{2.9174097325956514`,0.38250342246530517`},{3.833296223162803`,0.27751414137564157`}},{1.0833078115826873`,{3.9227431069558345`,0.1953259869549789`},{2.917584129557548`,0.3818931434204107`},{3.833617335631067`,0.2740620257301737`}},{1.074048770458049`,{3.924915395517901`,0.19513923236426833`},{2.917753330055559`,0.3812648603142256`},{3.8339098080857985`,0.27062253264029057`}},{1.0649466622338282`,{3.9271007751773954`,0.1949153307221958`},{2.9179183938528763`,0.38062463589998596`},{3.8342500524947205`,0.2672014590962247`}},{1.055997530618418`,{3.929282789452541`,0.19464956025325858`},{2.9180734830760744`,0.3799607419835919`},{3.8345523148368867`,0.263794856862441`}},{1.0471975511965979`,{3.9314976549886986`,0.19435083264762879`},{2.9182284464240453`,0.3792859133157255`},{3.834838098788585`,0.2604137441780684`}}}},{0.25`,{{125.66370614359172`,{2.4305506410497144`,0.00022485477078452773`},{2.40585174869329`,0.01417172082358054`},{2.4266238398702105`,3.6843449335900296`}},{62.83185307179586`,{2.0359625594757857`,0.0008015678147095542`},{2.4238537109871574`,0.05315913191549076`},{2.4426245058626446`,4.813224203944979`}},{41.88790204786391`,{2.4723452583080907`,0.002360390863790455`},{2.511327621890455`,0.06506188736091856`},{2.4605696635727914`,4.522225659496059`}},{31.41592653589793`,{2.4922553667501814`,0.0039299865955086275`},{4.662352928014522`,0.08859680156573846`},{2.47690411639363`,4.302081183942824`}},{25.132741228718345`,{2.403614999126461`,0.005820606768203985`},{4.672775208169793`,0.09703053617651078`},{2.222738776410335`,4.075353287162026`}},{20.943951023931955`,{2.257914598776418`,0.009220706762661257`},{2.471750565136055`,0.1877786179639253`},{2.39825313941016`,4.431410981120624`}},{17.951958020513104`,{2.2749236663909262`,0.01275393196428478`},{2.3798877093292568`,0.22713505389071506`},{2.249290444042374`,4.5365946320044905`}},{15.707963267948966`,{2.2927579578692376`,0.016559972510380973`},{2.386610142563357`,0.28001096281899723`},{2.2633530821939325`,4.578276347648027`}},{13.962634015954636`,{2.0940716410920466`,0.020329780631816133`},{2.3942440568632715`,0.2970050472499172`},{2.2795787095482822`,4.496780704806646`}},{12.566370614359172`,{2.1111406427401103`,0.02584043957042852`},{2.227218616248872`,0.35543998881962124`},{2.07607300948134`,4.5278452541153476`}},{11.423973285781067`,{2.1300844718480136`,0.03043849307097557`},{2.241782801362988`,0.38011572317463543`},{2.091320955583034`,4.482061965879967`}},{10.471975511965978`,{2.148683049137836`,0.03347860373575184`},{2.256703924350557`,0.3758647875138112`},{2.106487895962469`,4.2151663642606545`}},{9.666438934122441`,{2.165572179000947`,0.03487882451691843`},{2.0434916962029974`,0.3836600854165686`},{2.1202336333941125`,3.814050557056252`}},{8.975979010256552`,{2.1801789563337173`,0.0349014106884933`},{2.053221134323367`,0.39742588534140066`},{2.1319507367201758`,3.36313457469828`}},{8.377580409572783`,{2.1924371887100533`,0.033907914053284784`},{2.06194091925283`,0.4012680791605727`},{1.8611898693015065`,2.761599065693007`}},{7.853981633974483`,{1.9225280865237184`,0.03620478288632475`},{2.0695890392379654`,0.39919775471238794`},{1.8694082959815228`,2.565916962477021`}},{7.391982714328925`,{1.9317538091057742`,0.0377191300418215`},{2.0762473441823786`,0.3938507858357998`},{1.8761597365170877`,2.3925200721759197`}},{6.981317007977318`,{1.9399703655829934`,0.039231187098819405`},{2.082066586124319`,0.38666047376930074`},{1.8818029685511315`,2.2422395350482747`}},{6.613879270715354`,{1.9474009145573379`,0.040763723744958416`},{2.087218453975054`,0.37822032565726055`},{1.8867342176286737`,2.112394849737019`}},{6.283185307179586`,{1.9543216948239526`,0.04229670023519303`},{2.0918141624148014`,0.3686619598961397`},{1.891288456183797`,1.9987733392950333`}},{5.983986006837702`,{1.9609041781761853`,0.04378344256264248`},{2.0959408197930847`,0.3579193988245685`},{1.8952813646391404`,1.897034179132262`}},{5.711986642890533`,{1.9672517114675558`,0.045163754752960084`},{2.0996560139768774`,0.34590983576628453`},{1.8991792061020154`,1.8035720075816952`}},{5.463639397547467`,{1.9734202130796403`,0.046378019488780675`},{2.102970810148707`,0.3326221880404953`},{1.9028066014234242`,1.7153684648416185`}},{5.235987755982989`,{1.979400738913044`,0.047372812330522394`},{2.1059019212265353`,0.3181407482213264`},{1.9065356935594124`,1.6305704260935436`}},{5.026548245743669`,{1.9851883438576856`,0.04810516441007346`},{1.825209534551169`,0.3228085391581804`},{1.9099950381831245`,1.5479613825955936`}},{4.8332194670612205`,{1.9907511097363615`,0.04854515584007382`},{1.8280653464630567`,0.3307724257793497`},{1.9131965394166381`,1.4669087541511734`}},{4.654211338651545`,{6.055991933331601`,0.0499775230863342`},{1.830871920513527`,0.3380638742558685`},{1.9163290652750282`,1.3872433071473815`}},{4.487989505128276`,{6.08003797759233`,0.05214141403574564`},{1.8336385884111082`,0.3445763171834243`},{1.919201737801153`,1.308972792240298`}},{4.333231246330749`,{6.097476790433224`,0.054109811034150516`},{1.8363394054007`,0.3502430652147097`},{1.9218664392025202`,1.2323304906240977`}},{4.188790204786391`,{5.475945508757696`,0.05673824178185982`},{1.8389634160227721`,0.3550364329689151`},{5.418830332188371`,1.1306388104098133`}},{4.053667940115862`,{5.480928243558524`,0.060042348459254546`},{1.841505951508785`,0.358955510683434`},{5.420018696177452`,1.1281824708801467`}},{3.9269908169872414`,{5.486330949908128`,0.0633086899389124`},{1.8439477936592026`,0.36202140327335586`},{5.421259917416475`,1.1237924752183042`}},{3.8079910952603555`,{5.492051831301632`,0.06654806291316669`},{1.8463019994112053`,0.3642714544288729`},{5.4224737206958284`,1.1177806920415247`}},{3.6959913571644627`,{5.498076670861545`,0.06979569754058197`},{1.848545094903917`,0.3657552576987819`},{5.423644599385067`,1.1107889598565088`}},{3.5903916041026207`,{5.504446561925395`,0.07310402286358335`},{1.8506757359857187`,0.3665255340813316`},{5.4246909126194645`,1.1036445769302972`}},{3.490658503988659`,{5.511244147211421`,0.07653389566536363`},{1.8527010089253162`,0.3666432798588773`},{5.425681616726313`,1.0971811495572956`}},{3.396316382259236`,{5.518658899638525`,0.08014063699260741`},{1.8546149653598392`,0.3661689823135466`},{5.426621019954435`,1.0920617303311562`}},{3.306939635357677`,{5.527067275225875`,0.0839642535113849`},{1.8564185904755783`,0.36516228850746363`},{5.427516419512735`,1.0886576930534106`}},{3.222146311374147`,{5.537258791385329`,0.0880242742957972`},{1.8581102042421198`,0.363680922819916`},{5.428436530838832`,1.0869735159712572`}},{3.141592653589793`,{5.548826095348744`,0.09232000842860358`},{1.8597064932904845`,0.36178145901816583`},{5.429397482915704`,1.0866865312600553`}},{3.0649684425266277`,{5.559193700413753`,0.09680585614066832`},{1.8611968791025097`,0.3595126311003623`},{5.430471942312737`,1.087214952911971`}},{2.991993003418851`,{5.5689166835657735`,0.10140672330744882`},{1.8625843819002068`,0.3569261520077573`},{5.431663313039755`,1.087796522823328`}},{2.922411770781203`,{5.57832557628603`,0.10603155573459078`},{1.8638848549754594`,0.354066167997002`},{5.433025787229801`,1.0876195006143798`}},{2.8559933214452666`,{5.58759383190384`,0.11058103818259826`},{1.86509844012765`,0.3509738412894789`},{5.434518445001624`,1.0858769783386304`}},{2.792526803190927`,{5.596722450571681`,0.11495350383752401`},{1.8662257492559233`,0.34768410633976793`},{5.436127747410339`,1.081856447078971`}},{2.7318196987737333`,{5.605762399586768`,0.11904545297366372`},{1.8672780597521736`,0.34423351080601705`},{5.43784546658354`,1.0749674499798862`}},{2.673695875395569`,{5.614661862367554`,0.12276308922306074`},{1.8682550091523287`,0.3406395779596918`},{5.43967265115451`,1.0647912925667682`}},{2.6179938779914944`,{5.623413673418885`,0.1260196860289878`},{1.8691545054039023`,0.3369616367720682`},{5.441679921774784`,1.0510671289023317`}},{2.564565431501872`,{5.631979868978173`,0.128743362282095`},{5.259080985976058`,0.3507055029818389`},{5.443629151215621`,1.0337072492093107`}},{2.5132741228718345`,{5.640309062035769`,0.13087254250363708`},{5.260893335168003`,0.3636006125049903`},{5.4455761375108676`,1.0127299342443892`}},{2.463994238109642`,{5.648366861836683`,0.13236443182173446`},{5.262869692454464`,0.37552035132474726`},{5.447513039251886`,0.9883177308606372`}},{2.4166097335306103`,{5.656115841974617`,0.13318767414013155`},{5.264952367315543`,0.38630187835845403`},{5.4493969639496775`,0.9607024898663339`}},{2.3710133234639947`,{5.663616685378508`,0.13332813501923743`},{5.267155411108902`,0.39582576138017495`},{5.451238473808158`,0.9302389152874186`}},{2.3271056693257726`,{5.671553141280645`,0.13279087898051664`},{5.40524820664649`,0.39658337293244333`},{5.556700442503277`,0.8999681168296425`}},{2.284794657156213`,{5.6800582542784`,0.13160316719605736`},{5.406297460246111`,0.4086136079536603`},{4.355125054052226`,0.8712764866937563`}},{2.243994752564138`,{3.1158450776574895`,0.13105683201463175`},{5.4073825664586375`,0.4192845637053995`},{4.356952120319235`,0.8598174985199069`}},{2.2046264235717845`,{3.1205465354713575`,0.13345259819535019`},{5.408501686881692`,0.4285412660678821`},{4.358636359729262`,0.8464190443718524`}},{2.1666156231653746`,{3.125292569674561`,0.13565620218385005`},{5.409620750531136`,0.4363567575789932`},{4.360492165137057`,0.831282219906033`}},{2.1298933244676563`,{3.1302444161084706`,0.1376744216240669`},{5.41075019099763`,0.44273335346258125`},{4.362140918020884`,0.8146153705364791`}},{2.0943951023931957`,{3.1354271221030676`,0.13951417283058343`},{5.411869721601437`,0.4476931989199134`},{4.3637588639066385`,0.7966239093031722`}},{2.0600607564523234`,{3.1408514243581145`,0.14118388719113475`},{5.41298457909741`,0.4512768703875018`},{4.3652815173460136`,0.7774986282962695`}},{2.026833970057931`,{3.1466024027059287`,0.14269170687640303`},{5.414071705788499`,0.4535407438859698`},{4.366707059798302`,0.7574357101674287`}},{1.9946620022792338`,{3.1527336962397117`,0.14404711611943657`},{5.415129938850811`,0.45455240434304134`},{4.368077048368368`,0.7366209728105784`}},{1.9634954084936207`,{3.1593570590499556`,0.14526017556128953`},{5.4161538389651`,0.4543895023768981`},{4.36934116718552`,0.7152076426562152`}},{1.9332877868244882`,{3.1666401157919215`,0.1463420330133605`},{5.417137733689199`,0.4531365029583257`},{4.370558435481581`,0.693363091274386`}},{1.9039955476301778`,{3.1749019241701997`,0.14730640231606376`},{5.41808039202802`,0.45088650131184693`},{4.37170034263011`,0.6712478457222395`}},{1.8755777036356975`,{3.184792251150932`,0.1481664118828206`},{5.418978605526116`,0.44770985180296885`},{3.048488673500602`,0.6561867836588358`}},{1.8479956785822313`,{3.1983439854356392`,0.14894980328826127`},{5.419831076992972`,0.44371838703491995`},{3.0497276009694456`,0.6451304878538049`}},{1.821213132515822`,{3.211599144124213`,0.14968605994244585`},{5.4206338912437015`,0.43899394185825513`},{3.050822372155194`,0.6339766511186999`}},{1.7951958020513104`,{3.2198001395361775`,0.15034302792452084`},{5.421389426555768`,0.4336274428846077`},{3.0518840302571815`,0.6227537738502706`}},{1.7699113541350948`,{3.226202395489525`,0.15089792943790553`},{4.314927809115078`,0.45455653073915697`},{3.0528054828148483`,0.6114896253724084`}},{1.7453292519943295`,{3.231571868981761`,0.15134385308564988`},{4.315817277313574`,0.45780901805494556`},{3.0538838194293443`,0.6002150994532958`}},{1.7214206321039962`,{3.2362603925479707`,0.15169477145879895`},{4.316691074341138`,0.46052832845791286`},{3.054816206703445`,0.5889956485373163`}},{1.698158191129618`,{3.2404249265713356`,0.15193734822180477`},{4.317541695035541`,0.46272406752309575`},{3.055658686342342`,0.5778164141049056`}},{1.6755160819145565`,{3.2441845474843864`,0.15207815889381116`},{4.318372258363047`,0.46442942174896273`},{3.056453984047367`,0.5667073953610697`}},{1.6534698176788385`,{3.2476259410503188`,0.15212330666415555`},{4.319180037333914`,0.4656750187164168`},{3.057296715316155`,0.5557155485710306`}},{1.6319961836830095`,{3.2507759711165285`,0.15206930144694256`},{4.319964611153396`,0.46648243742453593`},{4.891895625806626`,0.5296274473019846`}},{1.6110731556870734`,{3.2537071438866256`,0.15192661367154156`},{4.320724676398348`,0.4668855704285409`},{4.89239269961738`,0.5196305843557691`}},{1.590679824602427`,{3.2564176095298625`,0.1516972950822108`},{4.32146070674923`,0.46690852138734307`},{4.892864024075093`,0.5092240403140863`}},{1.5707963267948966`,{3.258955688674197`,0.15138482960693575`},{4.322171834754077`,0.4665765023953498`},{4.89328430689544`,0.49848862570220726`}},{1.5514037795505151`,{3.261351289530154`,0.15099451470868516`},{4.322857479347859`,0.4659190701036948`},{4.893687143491244`,0.48748754240232023`}},{1.5324842212633139`,{3.2637537429672325`,0.15052875779706665`},{4.323518884285987`,0.4649544641113599`},{4.894053344518133`,0.476288021376377`}},{1.5140205559468882`,{3.266191538719982`,0.14999820073834297`},{4.32415488837401`,0.4637173219883881`},{3.0612979939984757`,0.48248983459260586`}},{1.4959965017094254`,{3.7230338441310056`,0.15011015288951815`},{4.324763269214953`,0.46221123348080584`},{3.061707472570559`,0.4726662969842787`}},{1.478396542865785`,{3.7293611429825972`,0.15202250796447705`},{4.325351022402272`,0.46047443469742283`},{3.062134555340696`,0.4630530833455014`}},{1.4612058853906016`,{3.7363469817741213`,0.15383581084615738`},{4.325916383779334`,0.4585195405242383`},{3.062600375235588`,0.4536132765685082`}},{1.444410415443583`,{3.744287006686749`,0.15555977628444018`},{4.32645675174886`,0.4563699509293732`},{3.062944873588213`,0.4443802824494964`}},{1.4279966607226333`,{3.753836809997947`,0.1572037508632293`},{4.326973767991751`,0.4540403481553391`},{3.0633022413333073`,0.4353234691977104`}},{1.411951754422379`,{3.7664997663673443`,0.15878456165205446`},{4.327464504179555`,0.4515503797592505`},{3.063599259703993`,0.42645479052337765`}},{1.3962634015954636`,{3.7835826020405947`,0.16032373763840563`},{4.327941523251474`,0.44891470061599903`},{3.0639060347526588`,0.41778347185925274`}},{1.3809198477317772`,{3.8269243898858734`,0.16187745893094996`},{4.328389816712726`,0.44615080580669514`},{3.0642397011473466`,0.40930590968544894`}},{1.3659098493868667`,{3.841164246489371`,0.16350728039285836`},{4.328827614067178`,0.44327071569649834`},{3.064486055898186`,0.4010035899379822`}},{1.3512226467052875`,{3.8490362584898765`,0.1650719398677899`},{4.329237044414319`,0.4402903407032968`},{3.0646775588151223`,0.3928962133071248`}},{1.3368479376977844`,{3.8551203639043883`,0.1665602216719833`},{4.329626931775933`,0.4372204908395612`},{3.064932364898319`,0.38498060306311926`}},{1.3227758541430708`,{3.8602330343481936`,0.16796829220003995`},{4.330000819463163`,0.4340739229282494`},{3.0651416195196304`,0.377244714378304`}},{1.3089969389957472`,{3.8647027650747074`,0.1692912634290549`},{4.3303586839037616`,0.4308584196991021`},{3.0652628938319104`,0.36968330136328037`}},{1.2955021251916674`,{3.868699374167416`,0.17053920876824824`},{4.330698335449688`,0.42759186563664425`},{3.0654389244191163`,0.3623033438410134`}},{1.282282715750936`,{3.872330334497821`,0.17170449717573438`},{4.33102085903481`,0.42427642406220084`},{3.065586264119785`,0.35511011440200785`}},{1.269330365086785`,{3.875674748721462`,0.17278881630428136`},{4.331326611895073`,0.4209227528499232`},{3.06581015091956`,0.34807921842628436`}},{1.2566370614359172`,{3.8787654367724755`,0.1737971509199661`},{4.331618652530032`,0.41753908635271364`},{3.065855178136893`,0.34122930845477784`}},{1.2441951103325914`,{3.8816645567466597`,0.1747290624827461`},{4.331895167053065`,0.4141353543392349`},{3.0659573165830265`,0.3345396628067905`}},{1.231997119054821`,{3.884374694037766`,0.1755896052018932`},{4.33215773934346`,0.41071553599004906`},{3.0659950361402375`,0.3280096512314041`}},{1.2200359819766187`,{3.88692122427726`,0.17637685350988652`},{4.332404864690681`,0.40728785865699`},{3.0661352994133333`,0.32165066042479495`}},{1.2083048667653051`,{3.8893347443854536`,0.17709759296652283`},{4.332642185841981`,0.4038573798407466`},{3.688182456610167`,0.3122192529382326`}},{1.1967972013675403`,{3.891621510759646`,0.17775037412305375`},{4.3328674079391485`,0.4004287355751732`},{3.6884980394041023`,0.3089830167415284`}},{1.1855066617319974`,{3.8937961395837215`,0.17833922620677142`},{4.333081597201263`,0.39700958527178953`},{3.68892243408982`,0.30572100460815627`}},{1.1744271602204834`,{3.8958608681635396`,0.1788658658373606`},{4.333280380313809`,0.3936014301251972`},{3.689296698487715`,0.3024383454136572`}},{1.1635528346628863`,{3.897840810668863`,0.17933299563152302`},{4.333471828222499`,0.39021053395350874`},{3.689652240574526`,0.29913993324115695`}},{1.152878038014603`,{3.899738727356415`,0.17974246929799512`},{4.3336524643576455`,0.38683973553578926`},{3.6899843424961793`,0.29583134765602914`}},{1.1423973285781066`,{3.9015420222523494`,0.1800931455643817`},{4.333823726113559`,0.38349067982267737`},{3.6902947919532494`,0.2925125927179205`}},{1.1321054607530787`,{3.9033632054833762`,0.18039195947663567`},{2.9148667709653076`,0.3700396827410954`},{3.6906304162334433`,0.2891961858592685`}},{1.121997376282069`,{3.905181237765097`,0.1806403112939164`},{2.915068815308841`,0.3698262976769481`},{3.6909519852730304`,0.2858824126117004`}},{1.1120681959609888`,{3.9069976799523545`,0.18083774811122677`},{2.915265276436185`,0.36958204426149355`},{3.6912009701111734`,0.282578416342112`}},{1.1023132117858923`,{3.9088084194346164`,0.18099042352312916`},{2.9154565611450103`,0.36931130908049636`},{3.6915281340517603`,0.2792785960233992`}},{1.0927278795094932`,{3.9106093877350823`,0.18109812239234135`},{2.9156427314619027`,0.3690145103407475`},{3.691802443984334`,0.2760007303106825`}},{1.0833078115826873`,{3.912414415565865`,0.18116032350364028`},{2.915823879232695`,0.3686902426715204`},{3.69206139219626`,0.27272693893957567`}},{1.074048770458049`,{3.9142155694827667`,0.18118384874255355`},{2.916000330657937`,0.368346795023914`},{3.6923095998036795`,0.26948064493851326`}},{1.0649466622338282`,{3.9160113379654935`,0.1811673147030031`},{2.916171595698593`,0.36798368176430507`},{3.692560002328802`,0.26625166019413166`}},{1.055997530618418`,{3.917816368789897`,0.18111274364994684`},{2.916339251940673`,0.3675956398618591`},{3.692744776504681`,0.26305556524407125`}},{1.0471975511965979`,{3.919638264212951`,0.18102344825503278`},{2.916501981035748`,0.3671911053682715`},{3.8311162434738057`,0.2515837059534055`}}}},{0.3`,{{125.66370614359172`,{2.0281433162712874`,0.00019858298744395347`},{9.045382958533851`,0.006218247777194583`},{2.426830382915018`,3.6226440674268927`}},{62.83185307179586`,{2.4512376287365494`,0.0010383192341036846`},{2.4238171756727995`,0.04971879500977271`},{2.4417177617282597`,4.537747207448248`}},{41.88790204786391`,{2.4727482423301312`,0.0021516836107055817`},{2.5119452446842936`,0.055783705085687224`},{2.0341612611285305`,3.256109542950826`}},{31.41592653589793`,{2.492850794219879`,0.003491411063838159`},{4.66233318395105`,0.07898747733533433`},{2.4744416706797483`,3.992576404719679`}},{25.132741228718345`,{2.2436972320378032`,0.005642205831274079`},{4.671055097292043`,0.09013313988830998`},{2.222614872119789`,3.900231644825837`}},{20.943951023931955`,{2.2598568048324075`,0.00846512231676253`},{2.469876945179482`,0.1613359836761077`},{2.2341155933151873`,4.170591961449201`}},{17.951958020513104`,{2.276578134556575`,0.011509282791671314`},{2.380551033928572`,0.20220989790789748`},{2.246379515957097`,4.260566368604509`}},{15.707963267948966`,{2.294139873495608`,0.014608203329129413`},{2.3863420578773304`,0.2449574763763925`},{2.2596263331169535`,4.234451944200505`}},{13.962634015954636`,{2.0976133112715667`,0.018567965834440956`},{2.3928806118583976`,0.2560393341787094`},{2.274321550018969`,4.068945422883639`}},{12.566370614359172`,{2.1133498573690517`,0.022987362953589673`},{2.2265433849030782`,0.3128841331128795`},{2.0726983499780545`,4.200184887515538`}},{11.423973285781067`,{2.1303608513178647`,0.026675051105313426`},{2.2392523345578774`,0.3316596226487174`},{2.0854635939402817`,4.120540788926652`}},{10.471975511965978`,{2.1470263369510727`,0.029201473340392706`},{2.2521700849659876`,0.32921582287072537`},{2.0981928362885767`,3.8819399011796722`}},{9.666438934122441`,{2.162307912398723`,0.03049246996366183`},{2.041766118848106`,0.34409642281771435`},{2.110031860608942`,3.5447363036316353`}},{8.975979010256552`,{2.175719217528256`,0.030699753126595578`},{2.050311576312103`,0.359369580191632`},{2.1201970919910305`,3.167841858445862`}},{8.377580409572783`,{1.9079831208929983`,0.0318181226947726`},{2.058189469930426`,0.36623153403816083`},{1.8503772933698615`,2.6539200570392314`}},{7.853981633974483`,{1.9187711872972202`,0.03347891910323547`},{2.0652807209702315`,0.3675244368723337`},{1.8580134767230128`,2.4894053114433743`}},{7.391982714328925`,{1.9279423234067186`,0.03502433093687121`},{2.0715893544345345`,0.36525481603299537`},{1.864375126642539`,2.3391798746601196`}},{6.981317007977318`,{1.9362270666254981`,0.03650512177141218`},{2.077193980616736`,0.3606429654445223`},{1.869866457432467`,2.204901670484414`}},{6.613879270715354`,{1.9437723834027045`,0.037937594368069184`},{2.0821945236537838`,0.354339656878941`},{1.874626780894409`,2.085220012077696`}},{6.283185307179586`,{1.9507625765477017`,0.03930996917923139`},{2.086685013095531`,0.34663657192202646`},{1.8789506662153912`,1.9777318557643564`}},{5.983986006837702`,{1.9573670397815717`,0.04059363823627036`},{2.090721706685679`,0.33766165436486256`},{1.8828924755547127`,1.8798280146556428`}},{5.711986642890533`,{1.9636604355337763`,0.04175035148425391`},{2.0943467618312543`,0.32748902917603256`},{1.8865630554082784`,1.7890702931663247`}},{5.463639397547467`,{1.9696993083337653`,0.04274140665175189`},{2.0975853747042237`,0.3162058072150184`},{1.8900032284245811`,1.7033492272471404`}},{5.235987755982989`,{1.975491590934642`,0.04353190994579118`},{2.1004566245553966`,0.30393875495382294`},{1.8933251795516437`,1.6212788974033772`}},{5.026548245743669`,{1.9810466708588672`,0.044093980971889574`},{4.604079571511858`,0.28798148637509197`},{1.896400562569603`,1.5420469369940375`}},{4.8332194670612205`,{1.9863516036811644`,0.044407937520011834`},{1.8251285539431865`,0.313484605811992`},{1.8993579962807274`,1.4649897698989194`}},{4.654211338651545`,{1.9913886000308985`,0.044462345697480025`},{1.827843847391686`,0.32012715884063053`},{1.9020554551289044`,1.3898449097088035`}},{4.487989505128276`,{5.467829654823902`,0.047734261558491926`},{1.8304859038621886`,0.3260908813686244`},{1.9045825593389039`,1.3167298270126504`}},{4.333231246330749`,{5.471730169566723`,0.05079659219746782`},{1.8330572451508635`,0.33137570586834775`},{1.906970904210011`,1.2456440831981868`}},{4.188790204786391`,{5.47603412138761`,0.05384466046368699`},{1.8355629409990644`,0.33591502919915917`},{1.9090305173613356`,1.1765647638578414`}},{4.053667940115862`,{5.4807235933852825`,0.056877321324506326`},{1.8379727840246705`,0.33972933781312686`},{5.41667199668548`,1.1115583966454925`}},{3.9269908169872414`,{5.485826099291182`,0.059898767418225266`},{1.84029772598553`,0.34282339808519974`},{5.41766729978058`,1.1077670055521573`}},{3.8079910952603555`,{5.491288520436775`,0.0629193166239698`},{1.8425329234340229`,0.345231235178926`},{5.418636668431213`,1.1030596288189352`}},{3.6959913571644627`,{5.497167332235587`,0.0659572796016679`},{1.8446724908446486`,0.3469916838081402`},{5.419587243157769`,1.0977770861840883`}},{3.5903916041026207`,{5.503570044089472`,0.06903537351219295`},{1.8467074818656408`,0.3481415631150025`},{5.420449421787954`,1.092299171679806`}},{3.490658503988659`,{5.510643330548049`,0.07217808006731977`},{1.8486550556693158`,0.3487311938212541`},{5.421341019704611`,1.08700696829293`}},{3.396316382259236`,{5.518617680399334`,0.07540432599073008`},{1.8504942536151003`,0.3488024709184754`},{5.422246292814957`,1.0821331069637503`}},{3.306939635357677`,{5.527946221367385`,0.07872753913834707`},{1.8522442927721494`,0.34840549640309615`},{5.4230965768991375`,1.0777946252949844`}},{3.222146311374147`,{5.539598758547776`,0.08215514167518866`},{1.8538981280047202`,0.3475849346291777`},{5.423997252253462`,1.0739477923089513`}},{3.141592653589793`,{5.5517798466623836`,0.08568544142578524`},{1.8554586094172547`,0.34638506940100927`},{5.424943411034915`,1.070375599384845`}},{3.0649684425266277`,{5.562231090904286`,0.08927470061439324`},{1.8569311106215851`,0.34484886884627247`},{5.425906308911611`,1.0667656711822966`}},{2.991993003418851`,{5.5717434785519915`,0.09286652248298988`},{1.8583087219345695`,0.3430146864460391`},{5.426956574291556`,1.062703865507628`}},{2.922411770781203`,{5.580711762231065`,0.09639994272580753`},{1.85961476329877`,0.3409204238893457`},{5.428062248904606`,1.0577656556933916`}},{2.8559933214452666`,{5.589334420540359`,0.09981163024984749`},{1.8608365681002832`,0.3385995380514313`},{5.429260070512452`,1.0515127109297624`}},{2.792526803190927`,{5.597662575229989`,0.10303661490309747`},{1.8619772158456813`,0.3360840010324019`},{5.430511279064261`,1.043573415665237`}},{2.7318196987737333`,{5.6057778910124165`,0.10601268626897611`},{1.863059480821109`,0.33340127915518125`},{5.431830743860661`,1.0336360911463214`}},{2.673695875395569`,{5.61365870264344`,0.10868183404502495`},{1.8640610125021237`,0.33058090866007633`},{5.433186801727999`,1.0214753033564805`}},{2.6179938779914944`,{5.621360780550091`,0.11099065924879876`},{1.8650008289855364`,0.3276382144495313`},{5.4345923146788255`,1.006952164016543`}},{2.564565431501872`,{5.628808413885485`,0.11289636662349722`},{1.8658807716619425`,0.32459682782377364`},{5.435960485340698`,0.9900119849709725`}},{2.5132741228718345`,{5.636025057916824`,0.11436218826935757`},{1.866708009327083`,0.3214898777939184`},{5.437413161249384`,0.9707071057944586`}},{2.463994238109642`,{5.642991146307027`,0.11536157222017028`},{5.262684543703326`,0.34253068323221053`},{5.438797223657593`,0.9491175650765021`}},{2.4166097335306103`,{5.649680972351399`,0.115877798285215`},{5.264439495123027`,0.3509361170507345`},{5.4402161535864035`,0.9254122252297202`}},{2.3710133234639947`,{5.656081359711454`,0.11590251371929125`},{5.266256606265403`,0.3584354097248353`},{5.441573508590451`,0.8998061221933367`}},{2.3271056693257726`,{3.10340428682843`,0.11544036643436961`},{5.405509755287673`,0.3571829837636017`},{4.344963326621436`,0.8549281685713921`}},{2.284794657156213`,{3.108082671459214`,0.11793852049421592`},{5.406363207524343`,0.3670021417768237`},{4.3462064921110235`,0.8461717686685208`}},{2.243994752564138`,{3.1125748757469536`,0.12027997655414731`},{5.407241488719601`,0.3758452125681346`},{4.347427807452973`,0.8358994568180725`}},{2.2046264235717845`,{3.1168796994503087`,0.12246431950496597`},{5.408148321355542`,0.3836724164103315`},{4.34872169338112`,0.824212784414907`}},{2.1666156231653746`,{3.1210176061288504`,0.12449148285001724`},{5.4090526682071385`,0.39046258586100757`},{4.3499222803441135`,0.811257300689696`}},{2.1298933244676563`,{3.1252252594035235`,0.12636250923345407`},{5.409968914442094`,0.39620301205395175`},{4.3511532312412236`,0.7971534267655962`}},{2.0943951023931957`,{3.1295991419528626`,0.12808302156240525`},{5.410883775858799`,0.4009088049949272`},{4.352339929258917`,0.7820456647371079`}},{2.0600607564523234`,{3.134154847180108`,0.12966012058057907`},{5.411792449292002`,0.40460155029232603`},{4.353476541047364`,0.7660658570416812`}},{2.026833970057931`,{3.138894194563603`,0.13109731549501707`},{5.412686631173441`,0.40731313399378605`},{4.354509219702199`,0.74933158331052`}},{1.9946620022792338`,{3.143884455350972`,0.13240195813796324`},{5.413562946251113`,0.40908465120625404`},{4.355614946261588`,0.7320071059193489`}},{1.9634954084936207`,{3.149156614257551`,0.13358140518118378`},{5.41441459191961`,0.4099641398880096`},{4.356646139243387`,0.7141734939779918`}},{1.9332877868244882`,{3.154779071621797`,0.13463862682794123`},{5.415245560886511`,0.4100041845402589`},{4.357589154570378`,0.6959580379841114`}},{1.9039955476301778`,{3.1608335905223646`,0.13558603082380422`},{5.416045731803601`,0.4092640830855162`},{4.358418239912298`,0.677455903154857`}},{1.8755777036356975`,{3.167494406499421`,0.13643033033454918`},{5.416813593595895`,0.40780470212600345`},{4.359298053471809`,0.658775950213954`}},{1.8479956785822313`,{3.175030089525579`,0.13718058114047663`},{5.417550538264044`,0.4056837377466581`},{4.360256705279658`,0.640004167774867`}},{1.821213132515822`,{3.184020644906047`,0.1378515447070961`},{5.418253048627233`,0.4029658254294346`},{4.360988480326364`,0.6212218886795133`}},{1.7951958020513104`,{3.196167339908516`,0.13845853038285236`},{5.418920847262241`,0.3997103798717154`},{2.9349118600496085`,0.6169464238636678`}},{1.7699113541350948`,{3.2097813306398257`,0.13903191533589634`},{5.419554168895396`,0.3959772471267612`},{2.935433888712831`,0.6055794420922421`}},{1.7453292519943295`,{3.217787698565141`,0.13954785969981812`},{4.31414294687519`,0.42309536334881315`},{2.9359355190765166`,0.5943033530592303`}},{1.7214206321039962`,{3.223891129320209`,0.1399869711808028`},{4.314898168318115`,0.42603512104232805`},{2.936497006045073`,0.5831402777773668`}},{1.698158191129618`,{3.2289754259451837`,0.1403438102786461`},{4.3156404082602124`,0.4285530604846128`},{2.9369249701698683`,0.5720952969007244`}},{1.6755160819145565`,{3.2333874185126183`,0.14061776010258628`},{4.316368437543998`,0.4306686975230353`},{3.047530609629823`,0.5625533436984593`}},{1.6534698176788385`,{3.237312846807328`,0.14080952958829132`},{4.3170808321903955`,0.4324014171812914`},{3.0482530919992277`,0.5531704883084626`}},{1.6319961836830095`,{3.2408479960546894`,0.1409205071713387`},{4.317776369860328`,0.4337705723141183`},{3.0488961055156443`,0.5438386763513776`}},{1.6110731556870734`,{3.244072100736087`,0.14095388281426774`},{4.3184548034311`,0.43479691158327893`},{3.0494780489558933`,0.5345883205663927`}},{1.590679824602427`,{3.2470427656039065`,0.1409109533117841`},{4.319115465699439`,0.4354987717901303`},{3.050109309689786`,0.5254146413149681`}},{1.5707963267948966`,{3.2497956192392237`,0.14079631246120702`},{4.319757586823749`,0.43589808038618144`},{3.050557756443244`,0.516324340705013`}},{1.5514037795505151`,{3.2523507311414344`,0.14060900503121812`},{4.320380919668926`,0.436006663286889`},{3.0511064691993486`,0.5073476304711417`}},{1.5324842212633139`,{3.2547377955574825`,0.14035639013157933`},{4.320985548993091`,0.43585110196918536`},{3.0516532191590184`,0.4984739082005581`}},{1.5140205559468882`,{3.256976861172076`,0.14003931766682454`},{4.32157124879861`,0.4354439068136469`},{3.0520863045622866`,0.48972460333664763`}},{1.4959965017094254`,{3.259082042670808`,0.1396621797333926`},{4.322137740542444`,0.43480442907206346`},{3.052607559525131`,0.4810963923667336`}},{1.478396542865785`,{3.2610835606174384`,0.13922586273466442`},{4.322685694897522`,0.43395046665505815`},{3.052963642849658`,0.47260218973344426`}},{1.4612058853906016`,{3.731035305978167`,0.13884496114014588`},{4.323214889372886`,0.4328971194744781`},{3.053427733282646`,0.4642384859875939`}},{1.444410415443583`,{3.7373255937823138`,0.14055225941481908`},{4.323725426689917`,0.43165682425048674`},{3.0537868207251946`,0.45602556183861254`}},{1.4279966607226333`,{3.7444572674185492`,0.14218229051264697`},{4.324210269904132`,0.43024774480457606`},{3.054106032051514`,0.44793388918575616`}},{1.411951754422379`,{3.7529513128625984`,0.14374270710823156`},{4.324682013089699`,0.42868246103726115`},{3.054454619326192`,0.4399942182440577`}},{1.3962634015954636`,{3.764113547123978`,0.1452452908614301`},{4.325149143020545`,0.4269742977420342`},{3.0547760478170893`,0.4321998148002076`}},{1.3809198477317772`,{3.7790401712168746`,0.14670540862742823`},{4.325586780387036`,0.42513502935152486`},{3.0550516516970125`,0.4245437501318941`}},{1.3659098493868667`,{3.8098180210887977`,0.148158413402059`},{4.326010120264793`,0.4231788816640932`},{3.055363357296334`,0.41704240399059817`}},{1.3512226467052875`,{3.839537745293776`,0.14970423686194026`},{4.326416321179212`,0.4211135638354688`},{3.055623659188257`,0.40968134848747456`}},{1.3368479376977844`,{3.8471353393374277`,0.15120164062618488`},{4.326806462333538`,0.41895290906733806`},{3.0558649257553734`,0.4024692202489182`}},{1.3227758541430708`,{3.8529058196659944`,0.15263302322952316`},{4.327175548684608`,0.4167054959331952`},{3.056106753657093`,0.39540696708698947`}},{1.3089969389957472`,{3.857725684430316`,0.1539963786423079`},{4.327540225391023`,0.41438232994495633`},{3.0563062955313005`,0.38847548146768085`}},{1.2955021251916674`,{3.8619357032780526`,0.15529034098272823`},{4.327885833754273`,0.41198685888574976`},{3.056511852020407`,0.3816899922599613`}},{1.282282715750936`,{3.8656837600871574`,0.1565140947464782`},{4.328215615222891`,0.40953548512790283`},{3.0567460625146072`,0.3750589229942281`}},{1.269330365086785`,{3.869103492295396`,0.1576691681603639`},{4.3285263046202695`,0.4070291739546847`},{3.056906133046328`,0.3685589732093165`}},{1.2566370614359172`,{3.8722558315249653`,0.15875746438273958`},{4.328830043675457`,0.4044792302666999`},{3.05711436646614`,0.3621981568852726`}},{1.2441951103325914`,{3.875171541879825`,0.1597798419264042`},{4.32912612608936`,0.4018904554376578`},{3.0572256006090166`,0.3559824112498099`}},{1.231997119054821`,{3.877905182580179`,0.16073667332147287`},{4.329400755843703`,0.3992704810193693`},{3.057415683946782`,0.3498915895101314`}},{1.2200359819766187`,{3.8804606055056388`,0.16163213115766226`},{4.329670405608965`,0.3966233220826758`},{3.0574843658988473`,0.3439365401094971`}},{1.2083048667653051`,{3.8828784174838384`,0.16246296953934675`},{4.329929159963037`,0.3939559409108937`},{3.0576064228985445`,0.3381125143149285`}},{1.1967972013675403`,{3.8851735386089423`,0.16323591843160176`},{4.330173985058339`,0.3912722903222251`},{3.057717349201818`,0.33240838605897033`}},{1.1855066617319974`,{3.8873406075893397`,0.16395193022240576`},{4.3304082251992115`,0.3885773139971252`},{1.5784837654218746`,0.3203337108099874`}},{1.1744271602204834`,{3.889405270492799`,0.1646109499913796`},{4.330631814329042`,0.38587719931735914`},{1.5785234318668873`,0.3169735750811326`}},{1.1635528346628863`,{3.8913747292053653`,0.16521401408199143`},{4.330845254998208`,0.38317417899204204`},{1.578518059316214`,0.3136813784193885`}},{1.152878038014603`,{3.893255939519161`,0.16576671929548584`},{4.331050247123278`,0.38047130779700666`},{1.57846836016172`,0.31044639445160077`}},{1.1423973285781066`,{3.89505631253741`,0.16626650041911725`},{4.331245661890079`,0.3777743824976744`},{1.5784936868733994`,0.30727484284412365`}},{1.1321054607530787`,{3.8967797889312856`,0.1667180115836088`},{4.331432070160375`,0.37508373995805466`},{1.5784859122016197`,0.3041580068200137`}},{1.121997376282069`,{3.8984339079004635`,0.16712212358497117`},{4.331610765154584`,0.37240585487486483`},{1.578464958118987`,0.30110590400270126`}},{1.1120681959609888`,{3.900022575719285`,0.16747971229612077`},{4.331781756896881`,0.3697402625533206`},{1.5784688260017457`,0.29810469268574413`}},{1.1023132117858923`,{3.90157990445198`,0.16779256819692115`},{2.913851820370324`,0.35588464207153825`},{1.5784350524233568`,0.2951537013082782`}},{1.0927278795094932`,{3.903132151849852`,0.1680625793541141`},{2.9140426851445587`,0.35584009741456213`},{1.5784244443812554`,0.29226973665874434`}},{1.0833078115826873`,{3.904677770627701`,0.16829251336251516`},{2.914229283301413`,0.3557667695876749`},{1.5784053603116528`,0.28942920375440373`}},{1.074048770458049`,{3.906218366297908`,0.16848165121056813`},{2.914405347311478`,0.3556663686987023`},{1.5784041368100037`,0.2866372694449274`}},{1.0649466622338282`,{3.907762194362336`,0.16863102390762474`},{2.914581676441084`,0.35554434203226276`},{1.5783651727485872`,0.28390162054676704`}},{1.055997530618418`,{3.909292979620584`,0.16874884406837104`},{2.9147533706808164`,0.3553985989017468`},{1.5783458104443573`,0.2812102159440256`}},{1.0471975511965979`,{3.9108160864406707`,0.16882961852654124`},{2.9149211427661106`,0.3552289020788418`},{1.5783038596907504`,0.27855953314423443`}}}},{0.35`,{{125.66370614359172`,{2.432385563340808`,0.00021103055559406735`},{9.045988801626027`,0.005916419964724311`},{2.0240222529905014`,3.17219193462604`}},{62.83185307179586`,{2.3906037785417444`,0.0007123556764944382`},{2.4237702355655086`,0.04665204440560139`},{2.4408613271668687`,4.306574857814631`}},{41.88790204786391`,{2.473249328670506`,0.001962299145186394`},{2.5128288414227247`,0.04810199902340141`},{2.456803575528057`,4.0510403323999995`}},{31.41592653589793`,{2.051416273729743`,0.0031561968023309907`},{4.662339619853601`,0.0714230019005958`},{2.4721648159344403`,3.7279354294694205`}},{25.132741228718345`,{2.2463042754771485`,0.005284604410152048`},{2.4531710332637595`,0.13147294228192652`},{2.2222367400712377`,3.762092643815662`}},{20.943951023931955`,{2.261749423779796`,0.007779487641230908`},{2.1788070647737263`,0.11687325675930589`},{2.2323319241806705`,3.977422361046518`}},{17.951958020513104`,{2.278120150613423`,0.0103939186722804`},{2.3810292557738992`,0.1811290383018545`},{2.243653634416769`,4.024934202393863`}},{15.707963267948966`,{2.087770899001938`,0.013288449955267902`},{2.386064670054626`,0.21597970319949175`},{2.2561528634058807`,3.9498878413286254`}},{13.962634015954636`,{2.100375027064735`,0.017012200019059728`},{2.391660471243312`,0.22393264178188466`},{2.059587094908623`,3.9104455175566795`}},{12.566370614359172`,{2.115129476390038`,0.020626037183608358`},{2.2257187859159533`,0.278457203470715`},{2.0692540116217013`,3.94873110878122`}},{11.423973285781067`,{2.130489439286372`,0.023638545305369102`},{2.236933357882586`,0.29339573894636917`},{2.080094717122206`,3.85039907710435`}},{10.471975511965978`,{2.1455845004829235`,0.025758170675539874`},{2.2482469059586974`,0.29231631541515857`},{2.0908568670769587`,3.6350335649979604`}},{9.666438934122441`,{2.159510012751779`,0.02692318953587944`},{2.040416069062694`,0.31150803065457233`},{2.101173801233573`,3.3464118575528614`}},{8.975979010256552`,{1.8933921239550868`,0.02750100673515022`},{2.0479709861186928`,0.3272472634060108`},{2.110004308676392`,3.0256863041146227`}},{8.377580409572783`,{1.9051611890273625`,0.029351785910663626`},{2.0550931046500938`,0.3358885689072159`},{2.1176257546218955`,2.703555521070879`}},{7.853981633974483`,{1.9155387437239093`,0.031012931770725394`},{2.061621784825259`,0.3394514450214859`},{1.8481887979622738`,2.425810172757122`}},{7.391982714328925`,{1.9246893644633647`,0.03254012556779398`},{2.0675477236769075`,0.33946551038144246`},{1.8541728981298222`,2.2949446261579305`}},{6.981317007977318`,{1.9328774680094287`,0.03396695635450925`},{2.0728869186120567`,0.3369487874089361`},{1.8593721256665487`,2.174703206062546`}},{6.613879270715354`,{1.9404104696721398`,0.03530472810143886`},{2.0777055504529085`,0.33252878423470505`},{1.8639376144620694`,2.0648779844695104`}},{6.283185307179586`,{1.9474007596510625`,0.03654712085904515`},{2.0820458515869356`,0.3265722838375411`},{1.868101865813597`,1.9642475826544656`}},{5.983986006837702`,{1.9539663455944905`,0.037675890375278166`},{2.085973939377286`,0.31930329181544825`},{1.8718647535375532`,1.8712894137554976`}},{5.711986642890533`,{1.9601753195871559`,0.03866732805740462`},{2.089501544749845`,0.31087838322103023`},{1.8753795077284616`,1.784144286340784`}},{5.463639397547467`,{1.9660781522579032`,0.0394949327691554`},{2.0926688271256615`,0.301439857532831`},{1.8786737993340574`,1.7017963395442428`}},{5.235987755982989`,{1.971705367826015`,0.04014158389514636`},{2.0954975288940467`,0.29115413003246576`},{1.8816832765743838`,1.6231322478850618`}},{5.026548245743669`,{1.9770598007067173`,0.0405844083117499`},{2.0979934557051787`,0.28016863649615575`},{1.8845922206469092`,1.5474794944004349`}},{4.8332194670612205`,{1.9821436325156576`,0.04081295343004064`},{1.8223752946309155`,0.29763672415070846`},{1.8872740920150723`,1.4743478999695538`}},{4.654211338651545`,{5.464689180360306`,0.042877427278434785`},{1.824997153349449`,0.30382662536649413`},{1.8897417363372198`,1.4034866115516513`}},{4.487989505128276`,{5.4680679913354355`,0.04564206952431471`},{1.8275436673837844`,0.30942952979000143`},{1.8920864673706967`,1.334788564264071`}},{4.333231246330749`,{5.471842835739075`,0.048416647026683315`},{1.8300125918319252`,0.3144175943926156`},{1.8941777964679807`,1.2682177927849811`}},{4.188790204786391`,{5.475957934568697`,0.05119045989735219`},{1.832404658608618`,0.3187796080680311`},{1.8961104248720841`,1.2039025216598849`}},{4.053667940115862`,{5.480464679447598`,0.05395961068556393`},{1.8347147675015667`,0.3225185576891042`},{1.8979010963068594`,1.1418841826422295`}},{3.9269908169872414`,{5.485388134966087`,0.05672423535723709`},{1.8369341278563744`,0.3256463135091257`},{5.414977467028493`,1.0944546839195066`}},{3.8079910952603555`,{5.490699283847245`,0.05948677241711467`},{1.8390709338513223`,0.3281866402749943`},{5.415791811622144`,1.0901788005465791`}},{3.6959913571644627`,{5.496483673381833`,0.06225525811108193`},{1.841120455587867`,0.3301670874113691`},{5.416599258832029`,1.08548060261446`}},{3.5903916041026207`,{5.50287724468829`,0.06503691815308772`},{1.8430802988257482`,0.3316215768185976`},{5.417396708748654`,1.0805124667274266`}},{3.490658503988659`,{5.510042644749985`,0.06783875958500064`},{1.844952798287938`,0.3325845667069103`},{5.418196465651618`,1.0754131734682812`}},{3.396316382259236`,{5.518235000847019`,0.07066528857641612`},{1.8467372724810098`,0.333094393710189`},{5.418996393435047`,1.0702635278262784`}},{3.306939635357677`,{5.527950096802951`,0.07352059730189531`},{1.8484341694757365`,0.33318744057175925`},{5.419798396143801`,1.0650862712316007`}},{3.222146311374147`,{5.540310636660145`,0.07640914122557405`},{1.8500399178956575`,0.3329029583881128`},{5.420563105808495`,1.0598192261804544`}},{3.141592653589793`,{5.552788277021452`,0.0793309601460857`},{1.8515699353105468`,0.33227176402380837`},{5.421390833549526`,1.0543129365964576`}},{3.0649684425266277`,{5.563187523842911`,0.08224710200288558`},{1.853020330172493`,0.331332102233433`},{5.422255081182712`,1.0484054735996184`}},{2.991993003418851`,{5.572481789745103`,0.08511272179898817`},{1.8543918375075779`,0.3301152784850124`},{5.423157226252308`,1.0418553655813085`}},{2.922411770781203`,{5.581068139790837`,0.08788472620082764`},{1.855688101016109`,0.3286552969449008`},{5.424104985584636`,1.0344352346848702`}},{2.8559933214452666`,{5.589184967107629`,0.09052104139890794`},{1.8569143253426978`,0.32697653484286676`},{5.425050597591423`,1.0259286730483348`}},{2.792526803190927`,{5.596905238997384`,0.09297713012629982`},{1.858063523797657`,0.32510715800455553`},{5.426050240979862`,1.0161020736879607`}},{2.7318196987737333`,{5.6043413087639005`,0.09522077177210124`},{1.859159177005037`,0.3230708287837798`},{5.427093786091475`,1.0048697683862367`}},{2.673695875395569`,{5.611479177794664`,0.09720990197434315`},{1.8601872188436768`,0.3208901908764856`},{5.428150154363954`,0.9920596599087039`}},{2.6179938779914944`,{5.618379793211668`,0.09891329074874959`},{1.8611559011401682`,0.31858705000792736`},{5.429204777482711`,0.977612695751971`}},{2.564565431501872`,{5.625024830366325`,0.10030517781791114`},{1.8620634033473427`,0.316179990954522`},{5.430274481761309`,0.9615196892103692`}},{2.5132741228718345`,{5.631430571801298`,0.1013639498925065`},{1.8629318212965058`,0.3136809145871192`},{5.431341599838027`,0.9438215286785723`}},{2.463994238109642`,{5.637580826265384`,0.10207499773183919`},{1.86373749829284`,0.3111117755807335`},{5.432410939190715`,0.9245849146705003`}},{2.4166097335306103`,{5.6434811029673915`,0.10242846512718891`},{5.263615813211731`,0.32239167097795607`},{5.433441922416631`,0.9039111743823617`}},{2.3710133234639947`,{3.0967039052089986`,0.10433003731437651`},{5.265174837731255`,0.32845261381165836`},{5.434432267993906`,0.881949222528698`}},{2.3271056693257726`,{3.1011696660206622`,0.10670315538838696`},{5.405615918780815`,0.3251885137726688`},{4.338444679003126`,0.8428975230396503`}},{2.284794657156213`,{3.1054702042313496`,0.1089506078140154`},{5.4063289713137905`,0.33339635419492253`},{4.339344754627873`,0.8342947928535043`}},{2.243994752564138`,{3.109600199403306`,0.11107006624144333`},{5.407058897026883`,0.3408810115875691`},{4.3402002557844215`,0.8246261767532164`}},{2.2046264235717845`,{3.1135689085329217`,0.11306143244436663`},{5.407809164052321`,0.3476167844841026`},{4.341085059558574`,0.8139665835025749`}},{2.1666156231653746`,{3.117390597029068`,0.11492352438960969`},{5.408560516560014`,0.35358247162540984`},{4.342043187088752`,0.8023811624614579`}},{2.1298933244676563`,{3.1210739079807532`,0.11665757334624187`},{5.409320683559378`,0.3587721603458926`},{4.342956102905663`,0.789965174890256`}},{2.0943951023931957`,{3.124825036052673`,0.11826333444242379`},{5.410080421060531`,0.36318952502124624`},{4.343866867443655`,0.7768004779521593`}},{2.0600607564523234`,{3.1287060986120885`,0.11974835456317952`},{5.410836605815692`,0.3668478484628799`},{4.344731753404921`,0.7629858957490159`}},{2.026833970057931`,{3.1327331197024155`,0.12111257366680699`},{5.411586253727022`,0.3697651239187962`},{4.345584638122068`,0.7486122423144805`}},{1.9946620022792338`,{3.1368973442574175`,0.1223630464071983`},{5.412323000313586`,0.37196723136899945`},{4.346464735847401`,0.7337433925281074`}},{1.9634954084936207`,{3.141256223942867`,0.12350238589249506`},{5.413045210074537`,0.3734867613274331`},{4.347220186450343`,0.7184841083023377`}},{1.9332877868244882`,{3.1458195105617954`,0.12453669589558668`},{5.413749976983228`,0.37435504758486665`},{4.348029367606059`,0.7029063155781794`}},{1.9039955476301778`,{3.1506319341528597`,0.12547065677889713`},{5.414435109116582`,0.37461629740715074`},{4.348716739777697`,0.6870940939651249`}},{1.8755777036356975`,{3.155758590766475`,0.126310320957161`},{5.4150991374648605`,0.37430204086118146`},{4.349399825119283`,0.6711033970816661`}},{1.8479956785822313`,{3.161256107714744`,0.12706095309359786`},{5.415739939721277`,0.37346112637500223`},{4.350067000331369`,0.655014883529937`}},{1.821213132515822`,{3.167276840630225`,0.1277288618092176`},{5.416356491885796`,0.37213253269910235`},{4.35065893088128`,0.6388887561338011`}},{1.7951958020513104`,{3.1740540812961133`,0.12832235745860854`},{5.416946933459607`,0.37036210057675567`},{2.927706164391248`,0.6245330910646563`}},{1.7699113541350948`,{3.1819863908725576`,0.12884939055401845`},{5.417513136836089`,0.368185766708303`},{2.928174944416788`,0.6144878621882026`}},{1.7453292519943295`,{3.19230714711969`,0.12932348748616448`},{5.418053643462949`,0.3656509997056092`},{2.928653638928783`,0.6045020014955944`}},{1.7214206321039962`,{3.206567420058417`,0.12976835343981957`},{4.3133696846220415`,0.3969838794709337`},{2.9290814283441393`,0.5945892764788264`}},{1.698158191129618`,{3.2149787509122802`,0.1301793294694764`},{4.314022373290421`,0.3996447224540029`},{2.929513104176462`,0.5847560587141643`}},{1.6755160819145565`,{3.2210591106294366`,0.13053174274637716`},{4.314665703545498`,0.4019760046366152`},{2.929914411992156`,0.5750153586310317`}},{1.6534698176788385`,{3.2260204660001106`,0.1308201741268069`},{4.315297951633997`,0.4039910925497001`},{2.9303208655138295`,0.565378369350314`}},{1.6319961836830095`,{3.230275889821304`,0.13104655007402619`},{4.315918570709678`,0.40570748555744196`},{2.930663041098968`,0.5558739329955841`}},{1.6110731556870734`,{3.234040056018359`,0.1311999438559718`},{4.31652688188126`,0.4071284905736253`},{2.9310082421646846`,0.5464655060782755`}},{1.590679824602427`,{3.2374305828358336`,0.13129319935331632`},{4.317121860989289`,0.40828063159156885`},{2.9313615113188596`,0.5372016798288458`}},{1.5707963267948966`,{3.2405057986578862`,0.13132394167399092`},{4.317703354034831`,0.4091728792276801`},{2.931648512026304`,0.5280781242919305`}},{1.5514037795505151`,{3.2433480633086567`,0.1312925202799259`},{4.318270690269552`,0.40981798093678806`},{2.93193046124257`,0.5190912745402378`}},{1.5324842212633139`,{3.245968189761284`,0.1312026241202606`},{4.318823582490091`,0.41023204571721256`},{2.932176408640796`,0.5102517462578632`}},{1.5140205559468882`,{3.2484096284998207`,0.13105476838203517`},{4.319362227177011`,0.41042588245274836`},{2.932484679128407`,0.5015591960464669`}},{1.4959965017094254`,{3.2506935439990805`,0.13085234677128937`},{4.319886196937128`,0.41041391129421073`},{2.932733992809976`,0.49301701232090994`}},{1.478396542865785`,{3.252825601373171`,0.13059743474911453`},{4.320395346196104`,0.410208740140065`},{2.9329704705033306`,0.4846274658930085`}},{1.4612058853906016`,{3.2548246879876666`,0.13029252572501304`},{4.320889776622926`,0.409823071319157`},{2.9332269876940478`,0.47639420204267885`}},{1.444410415443583`,{3.2567196874395927`,0.12994055550740496`},{4.3213695440496`,0.40926969741722463`},{2.9333622085615825`,0.4683124646344694`}},{1.4279966607226333`,{3.7392753248090593`,0.12916917689773477`},{4.32183464142328`,0.4085571321830315`},{2.933606763122895`,0.46038536904713356`}},{1.411951754422379`,{3.7458396139432177`,0.13069519910359562`},{4.322285532304189`,0.4076899127993683`},{2.9337946407342184`,0.4525883045520165`}},{1.3962634015954636`,{3.7536703290791973`,0.13218305528255744`},{4.322722164483262`,0.40670476148295326`},{2.933951187368531`,0.4449994215612117`}},{1.3809198477317772`,{3.763945046418597`,0.13360711103178566`},{4.323144447674803`,0.40558610056131217`},{2.9341319664023384`,0.4375357354280024`}},{1.3659098493868667`,{3.7776662236149203`,0.13499601027755165`},{4.323553663449963`,0.40435298766738037`},{2.9343167632567164`,0.4302271418122303`}},{1.3512226467052875`,{3.8256074242452547`,0.1363708850243116`},{4.323947543999727`,0.4030108663405576`},{2.9344022210674896`,0.42306903705102844`}},{1.3368479376977844`,{3.8395422202755953`,0.1378425336994007`},{4.324319907977155`,0.4015715719122166`},{3.049082642562792`,0.4164362090813989`}},{1.3227758541430708`,{3.84645004901655`,0.13926492159092213`},{4.324695288045213`,0.40004235545745137`},{3.049300696493166`,0.41001614468718794`}},{1.3089969389957472`,{3.8517385420683463`,0.14063322440841053`},{4.325055047542593`,0.3984327129158978`},{3.0495416475317714`,0.4037041532695522`}},{1.2955021251916674`,{3.856166422210036`,0.14194250742215214`},{4.325398779868484`,0.3967472552936246`},{3.0498223367658426`,0.3975070528620376`}},{1.282282715750936`,{3.860051255508399`,0.14319261348122148`},{4.325731042010812`,0.3949963933044397`},{3.0500153623025112`,0.39140900118940325`}},{1.269330365086785`,{3.8635384473796908`,0.14438347614700753`},{4.326050796664414`,0.3931852449970255`},{3.050207280043061`,0.3854361484386237`}},{1.2566370614359172`,{3.866704023245319`,0.14551471806191538`},{4.326356841248209`,0.39131837079618614`},{3.0504104326854278`,0.37957478080920803`}},{1.2441951103325914`,{3.869633285261962`,0.14658884966215993`},{4.3266570879723645`,0.38940460834658974`},{3.050557280275856`,0.3738190051493204`}},{1.231997119054821`,{3.872364776257535`,0.14760593261228688`},{4.326942800504863`,0.38744772844249936`},{3.050750241587389`,0.368179337783875`}},{1.2200359819766187`,{3.8749176203769373`,0.14856649989806767`},{4.327219762195585`,0.3854529890471765`},{3.0509200517391197`,0.3626365877891089`}},{1.2083048667653051`,{3.8773194267527575`,0.14947370565707072`},{4.327487003604612`,0.38342740471276265`},{2.9354079422876302`,0.35374025215459015`}},{1.1967972013675403`,{3.879577640098103`,0.15032517332678097`},{4.327742983744879`,0.38137300699131305`},{1.5740581143564671`,0.34828694154203393`}},{1.1855066617319974`,{3.8817403795086225`,0.1511279015340738`},{4.327989972718219`,0.3792951487412205`},{1.574055040763248`,0.34483267077857815`}},{1.1744271602204834`,{3.883779256831982`,0.1518797090778104`},{4.3282260710544485`,0.3771971717204333`},{1.574078727127414`,0.34143268474363775`}},{1.1635528346628863`,{3.8857291689652147`,0.15258088038890277`},{4.32845243923841`,0.37508532337793127`},{1.5741362312576601`,0.33808284119341847`}},{1.152878038014603`,{3.887594767640692`,0.1532358427356331`},{4.328680555537315`,0.372959788794371`},{1.5741540998135968`,0.3348167484237265`}},{1.1423973285781066`,{3.8893870001776905`,0.15384427815229312`},{4.328887830682836`,0.37082534682973045`},{1.5741230790716028`,0.3315983928461674`}},{1.1321054607530787`,{3.8910895633713873`,0.15440694876848654`},{4.329099128736428`,0.3686851216446427`},{1.5741582674255106`,0.3284336035075025`}},{1.121997376282069`,{3.8927348433175855`,0.15492715736343904`},{4.329289841195684`,0.36654233828725874`},{1.5741540261973062`,0.3253237451353089`}},{1.1120681959609888`,{3.8943119743051873`,0.15540451443697423`},{4.329482120715432`,0.36439866658897807`},{1.5741618236124002`,0.3222705129102662`}},{1.1023132117858923`,{3.895830918941378`,0.1558411331895819`},{4.329664827842538`,0.36225783854561233`},{1.5741723792259572`,0.3192717391570478`}},{1.0927278795094932`,{3.897295164128865`,0.1562394111870912`},{4.329840177628119`,0.36012038091103077`},{1.5741943907899827`,0.31631007615208945`}},{1.0833078115826873`,{3.898703510369525`,0.15659695156693265`},{4.330009011392913`,0.3579879082999757`},{1.574195410945302`,0.31341854935854696`}},{1.074048770458049`,{3.900064455620086`,0.15691967119683936`},{2.912954217460577`,0.3433259530559632`},{1.5741813632374921`,0.31055280730429513`}},{1.0649466622338282`,{3.9014024716252034`,0.1572043419634615`},{2.9131323947258263`,0.3434151577548042`},{1.5742260053299242`,0.30776713515503296`}},{1.055997530618418`,{3.902734477157965`,0.15745581915789664`},{2.913306583716714`,0.3434770621801803`},{1.574161108363449`,0.3049993270360797`}},{1.0471975511965979`,{3.904061485186383`,0.15767328273894818`},{2.9134771204630896`,0.34351436536093954`},{1.5741938397399298`,0.302299717826248`}}}}};


(* ::Subsubsection::Closed:: *)
(*El-Centro response spectra functions*)


Clear[ responseSpectrumAccelerationElCentro1940, responseSpectrumVelocityElCentro1940, responseSpectrumDisplacementElCentro1940 ];


SaElCentro1940 = Interpolation[ 
Flatten[ Map[ Prepend[ #, {0, #[[1, 2 ]], 0} ]&,Table[  {2\[Pi]/whatData[[1]], elCentroResponseSpectraRawData[[ whatDampingRatio, 1 ]], whatData[[4, 2]]},
{whatDampingRatio, 1, Length[ elCentroResponseSpectraRawData ]},
{whatData, elCentroResponseSpectraRawData[[ whatDampingRatio, 2 ]]} ] ], 1 ],
InterpolationOrder -> 1 ];


SvElCentro1940 = Interpolation[ 
Flatten[ Map[ Prepend[ #, {0, #[[1, 2 ]], 0} ]&,Table[  {2\[Pi]/whatData[[1]], elCentroResponseSpectraRawData[[ whatDampingRatio, 1 ]], whatData[[3, 2]]},
{whatDampingRatio, 1, Length[ elCentroResponseSpectraRawData ]},
{whatData, elCentroResponseSpectraRawData[[ whatDampingRatio, 2 ]]} ] ], 1 ],
InterpolationOrder -> 1 ];


SdElCentro1940 = 
Interpolation[ 
Flatten[ Map[ Prepend[ #, {0, #[[1, 2 ]], 0} ]&,Table[  {2\[Pi]/whatData[[1]], elCentroResponseSpectraRawData[[ whatDampingRatio, 1 ]], whatData[[2, 2]]},
{whatDampingRatio, 1, Length[ elCentroResponseSpectraRawData ]},
{whatData, elCentroResponseSpectraRawData[[ whatDampingRatio, 2 ]]} ] ], 1 ],
InterpolationOrder -> 1 ];


responseSpectrumAccelerationElCentro1940[ T_?NumericQ, \[Xi]_?NumericQ ] := SaElCentro1940[ T, \[Xi] ];


responseSpectrumVelocityElCentro1940[ T_?NumericQ, \[Xi]_?NumericQ ] := SvElCentro1940[ T, \[Xi] ];


responseSpectrumDisplacementElCentro1940[ T_?NumericQ, \[Xi]_?NumericQ ] := SdElCentro1940[ T, \[Xi] ];


(* ::Subsection::Closed:: *)
(*ASCE code 7-05*)


(* ::Text:: *)
(*"ASCE code 7-05";*)


(* ::Section::Closed:: *)
(*Exported functions - initializations and utilities*)


(* ::Subsection:: *)
(*    ----------------------     Initializations   -------------------------------*)


(* ::Subsection::Closed:: *)
(*Initializations:  global variables related to storage but internal to the package*)


wallDataMaster::usage = "wallDataMaster is used to control all shearWall object data.";
floorDataMaster::usage = "floorDataMaster is used to control all shearWall object data.";
buildingDataMaster::usage = "buildingDataMaster is used to control all shearBuilding object data.";
slabDataMaster::usage = "slabDataMaster is used to control all shearSlab object data.";


shearWallCount = 0;
shearFloorCount = 0;
shearBuildingCount = 0;
shearSlabCount = 0;


(* ::Subsection::Closed:: *)
(*Initializations:  Local globals (not exported)*)


$defaultYoungsModulusOfConcrete = 26. ; (** in Giga Pascal **)
$defaultShearModulusOfConcrete = (26. / (2 (1 + 0.2)));  (*  10.83 GPa  *)
$defaultSpecificGravityOfConcrete = 2.37;


$densityOfWater=10^3;  (*** Kg / m^3   ***)


$defaultResponseSpectrumDisplacementFunction = ((((# / (2\[Pi]))^2) * responseSpectrumAccelerationEurocodeElastic2004[ #,  "designGroundAccelerationOnTypeAGround$ag"->3.432275,"eurocodeTypeOfElasticResponseSpectra"->1,"eurocodeGroundType"->"A","dampingRatio$\[Xi]"->0.05,"lowerLimitPeiodOfConstantAcceleration$TB"->Automatic,"upperLimitPeiodOfConstantAcceleration$TC"->Automatic,"valueDefiningBeginningConstantDisplacement$TD"->Automatic,"soilFactor$S"->Automatic,"dampingCorrectionFactor$\[Eta]"->Automatic ] )&);


$shearBuildingMultipleOfLastEQTime = 1.2;


$epsForXYspan = 10^-3;  (*** This is the minimum \[CapitalDelta]x or \[CapitalDelta]y span in meters before a span of 1 is chosen ***)


$defaultDOFOrderingForAllMethods = "building";


$centerOfMassMainKeyword = "centerOfMass";


$centerOfMassLowercaseKeywordsList = {"centerofmass", "center of mass", "centerof mass", "centre of mass", "centreofmass", "center ofmass", "centreof mass", "center ofmass"};


$defaultWallSpecificGravity = 2.5;
$defaultWallThickness = 0.3;


$defaultSlabSpecificGravity = 2.5;
$defaultSlabThickness = 0.2;


(* ::Subsection:: *)
(*    ----------------------     Common utilities   -------------------------------*)


(* ::Subsection::Closed:: *)
(*Miscellaneous common local procedures*)


calcDisplacement::usage = "calcDisplacement[ {x, y, z}, {ux, uy, \[Theta]}, {xc, yc} ] for 3-D or calcDisplacement[ {x, y}, {ux, uy, \[Theta]}, {xc, yc} ] for 2D...";


calcDisplacement[ {x_, y_, z_}, {ux_, uy_, \[Theta]_}, {xc_, yc_} ] := TranslationTransform[ {ux, uy, 0} ][ RotationTransform[ \[Theta], {0, 0, 1}, {xc, yc, 0} ][ {x, y, z} ] ] - {x, y, z};


calcDisplacement[ {x_, y_}, {ux_, uy_, \[Theta]_}, {xc_, yc_} ] := TranslationTransform[ {ux, uy} ][ RotationTransform[ \[Theta], {xc, yc} ][ {x, y} ] ] - {x, y}


changeToMeter[ a_?( Head[ # ] =!= List &) ] := Convert[ a, Meter ]
changeToMeter[ a_List ] := Convert[ #, Meter ]& /@ a


getMeterValue[ a_ ] := changeToMeter[ a ] / Meter // Cancel


changeToKilogram[ a_?( Head[ # ] =!= List &) ] := Convert[ a, Kilogram ]
changeToKilogram[ a_List ] := Convert[ #, Kilogram ]& /@ a


getKilogramValue[ a_ ] := changeToKilogram[ a ] / Kilogram // Cancel


convertAlsoLists[ a_?( Head[ # ] =!= List &), whatUnits_ ] := Convert[ a, whatUnits ]
convertAlsoLists[ a_List, whatUnits_ ] := Convert[ #, whatUnits ]& /@ a
getUnitlessValue[ a_, whatUnits_ ] := convertAlsoLists[ a, whatUnits ] / whatUnits // Cancel


(* ::Subsection::Closed:: *)
(*Procedures for area, cg, moments of inertia*)


signedAreaOfPolygon[ listOfPoints:{ {_, _} ... } ] := 
Module[ {theSegments},
theSegments =  Partition[ Append[ listOfPoints, listOfPoints[[1]] ], 2, 1 ];

1/2 Sum[ With[ {xs = seg[[1, 1]], xe = seg[[2, 1]], ys = seg[[1, 2]], ye = seg[[2, 2]]},(ye - ys)(xs + xe) ], {seg, theSegments} ] 
]


cgOfPolygon[ listOfPoints:{ {_, _} ... } ] := 
Module[ {theSegments},
theSegments =  Partition[ Append[ listOfPoints, listOfPoints[[1]] ], 2, 1 ];

{
1/6 Sum[ With[ {xs = seg[[1, 1]], xe = seg[[2, 1]], ys = seg[[1, 2]], ye = seg[[2, 2]]},(ye-ys) (xe^2+xe xs+xs^2) ], {seg, theSegments} ],
1/6 Sum[ With[ {xs = seg[[1, 1]], xe = seg[[2, 1]], ys = seg[[1, 2]], ye = seg[[2, 2]]},(ye-ys) (2 xe ye+xs ye+xe ys+2 xs ys) ], {seg, theSegments} ]
} / signedAreaOfPolygon[listOfPoints ]
]


signedMomentOfInertiaRelativeToOriginOfPolygon[ listOfPoints:{ {_, _} ... } ] := 
Module[ {theSegments, Ixx, Iyy, xCG, yCG},
theSegments =  Partition[ Append[ listOfPoints, listOfPoints[[1]] ], 2, 1 ];

{
1/12 Sum[ With[ {xs = seg[[1, 1]], xe = seg[[2, 1]], ys = seg[[1, 2]], ye = seg[[2, 2]]},(ye-ys)(3 xe ye^2+xs ye^2+2 xe ye ys+2 xs ye ys+xe ys^2+3 xs ys^2) ], {seg, theSegments} ],
1/12 Sum[ With[ {xs = seg[[1, 1]], xe = seg[[2, 1]], ys = seg[[1, 2]], ye = seg[[2, 2]]},(ye-ys)(xe+xs) (xe^2+xs^2) ], {seg, theSegments} ],
1/24 Sum[ With[ {xs = seg[[1, 1]], xe = seg[[2, 1]], ys = seg[[1, 2]], ye = seg[[2, 2]]},(ye-ys)(3 xe^2 ye+2 xe xs ye+xs^2 ye+xe^2 ys+2 xe xs ys+3 xs^2 ys) ], {seg, theSegments} ] 
} 
]


signedMomentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints:{ {_, _} ... } ] := 
Module[ {theSegments, Ixx, Iyy,Ixy, xCG, yCG, theArea},
theSegments =  Partition[ Append[ listOfPoints, listOfPoints[[1]] ], 2, 1 ];

{xCG, yCG} = cgOfPolygon[listOfPoints ];
theArea = signedAreaOfPolygon[ listOfPoints ];
{Ixx, Iyy, Ixy} =  signedMomentOfInertiaRelativeToOriginOfPolygon[ listOfPoints ];

{Ixx - theArea * yCG^2, Iyy - theArea * xCG^2, Ixy - theArea * xCG * yCG}
]


signedPolarMomentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints:{ {_, _} ... } ] := 
With[ {  Iall = signedMomentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints ]},
Iall[[1]] + Iall[[2]]
]


areaOfPolygon[ listOfPoints:{ {_, _} ... } ] := Abs[ signedAreaOfPolygon[ listOfPoints ] ]


momentOfInertiaRelativeToOriginOfPolygon[ listOfPoints:{ {_, _} ... } ] := Sign[ signedAreaOfPolygon[ listOfPoints ] ] * signedMomentOfInertiaRelativeToOriginOfPolygon[ listOfPoints ]


momentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints:{ {_, _} ... } ] := Sign[ signedAreaOfPolygon[ listOfPoints ] ] * signedMomentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints ]


polarMomentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints:{ {_, _} ... } ] := Sign[ signedAreaOfPolygon[ listOfPoints ] ] * signedPolarMomentOfInertiaRelativeToCentroidOfPolygon[ listOfPoints ]


polarMomentOfInertiaRelativeToOriginOfPolygon[ listOfPoints:{ {_, _} ... } ] := With[ {Iall = signedMomentOfInertiaRelativeToOriginOfPolygon[ listOfPoints ]},
Abs[ Iall[[1]] ] + Abs[ Iall[[2]] ] ]


polarMomentOfInertiaRelativeToSpecifiedCenter[ listOfPoints:{ {_, _} ... }, {xc_, yc_} ] := With[ {Iall = signedMomentOfInertiaRelativeToOriginOfPolygon[ (## - {xc, yc})& /@ listOfPoints ]},
Abs[ Iall[[1]] ] + Abs[ Iall[[2]] ] ]


(* ::Subsection::Closed:: *)
(*internalShowStickBuilding*)


(* ::Text:: *)
(*\[Bullet]  Allow movement about different center of rotation and specified location of center of mass*)
(*\[Bullet]  Allow dofs to be entered in "floor" as well as "building" ordering*)


showStickBuilding = internalShowStickBuilding;


privateContext`oldDofs = {};
Clear[ internalShowStickBuilding ];
internalShowStickBuilding[ indofs:{_ ... }, heightsList:{ _ ...}, {scaleDisplacement_, scaleRotation_}, rotationLineLengthFraction_,
directivesForMainLine_, directivesForTransverseLines_,
directivesForMainPoints_, directivesForTransversePoints_,
initailDirectionOfTransverseLines_,
dofOrdering_
 ] := 
Module[ {dofs, nDofs, zValues, rotLineList, floorCenterDisplacement, rotationLineLength, initialDirection, perpDirection, dofOrderToUse},

nDofs = (Length[ indofs ] /3);
initialDirection = Normalize[ initailDirectionOfTransverseLines ];
perpDirection = {- initialDirection[[2]], initialDirection[[1]]};
zValues = Accumulate[Prepend[ heightsList, 0 ] ];
dofOrderToUse = Which[ 
dofOrdering === "Building" || dofOrdering === "building", Thread[ Partition[ Range[ 3 nDofs ], nDofs ] ] // Flatten,
dofOrdering === "Floor" || dofOrdering === "floor", Range[ 3 nDofs ],
True, Return[ $Failed ]
];
dofs = Partition[ Join[ {0, 0, 0}, indofs[[ dofOrderToUse ]] ], 3 ];
nDofs += 1;

rotationLineLength = rotationLineLengthFraction * zValues[[-1]] / nDofs;
floorCenterDisplacement = Table[  {scaleDisplacement * dofs[[iDof, 1]], scaleDisplacement * dofs[[iDof, 2]], zValues[[iDof]]}, {iDof, 1, nDofs} ];
rotLineList = Table[
With[ {c = Cos[ scaleRotation * dofs[[iDof, 3]] ],s =  Sin[ scaleRotation * dofs[[iDof, 3]] ]}, 
With[ {xy1 = floorCenterDisplacement[[iDof, {1, 2} ] ] + {{c, -s}, {s, c}}. ( rotationLineLength * initialDirection ),
xy2 = floorCenterDisplacement[[iDof, {1, 2} ] ] - {{c, -s}, {s, c}}. ( rotationLineLength * initialDirection ),
xy3 = floorCenterDisplacement[[iDof, {1, 2} ] ] + {{c, -s}, {s, c}}. ( rotationLineLength * perpDirection ),
xy4 = floorCenterDisplacement[[iDof, {1, 2} ] ] - {{c, -s}, {s, c}}. ( rotationLineLength * perpDirection )},
{ { {xy1[[1]], xy1[[2]], zValues[[iDof]]}, {xy2[[1]], xy2[[2]], zValues[[iDof]]} }, {{xy3[[1]], xy3[[2]], zValues[[iDof]]}, {xy4[[1]], xy4[[2]], zValues[[iDof]]}}}  ]
],
{iDof, 1, nDofs} ] ;


{
directivesForMainLine,
Line[ floorCenterDisplacement ],
directivesForMainPoints,
Point /@ floorCenterDisplacement,
directivesForTransverseLines,
Arrow[ 1.75 rotLineList[[1, 1]] ], Line[ rotLineList[[ 1, 2]]],
Map[ Line, rotLineList // Rest, {2} ],
directivesForTransversePoints,
Map[ Point, rotLineList, {2} ]
}
] /;  Length[ indofs ] === (3 Length[ heightsList ])


internalShowStickBuilding[ dofs:{_ ... }, heightsList:{ _ ...}, {scaleDisplacement_, scaleRotation_}, rotationLineLengthFraction_,
directivesForMainLine_, directivesForTransverseLines_,
directivesForMainPoints_, directivesForTransversePoints_,
initailDirectionOfTransverseLines_,
dofOrdering_,
"track", nTrack_, trackOpacity_Opacity
 ] := 
Module[ {res},
Block[ {privateContext},
res = {
internalShowStickBuilding[ dofs, heightsList, {scaleDisplacement, scaleRotation}, rotationLineLengthFraction,
directivesForMainLine, directivesForTransverseLines,
directivesForMainPoints, directivesForTransversePoints,
initailDirectionOfTransverseLines,
dofOrdering
 ],
Table[
If[ Length[ anOldDof  ] === Length[ dofs ] && ((And @@ (NumericQ /@ Flatten[ anOldDof ])) === True),
internalShowStickBuilding[ anOldDof, heightsList, {scaleDisplacement, scaleRotation}, rotationLineLengthFraction,
Append[ directivesForMainLine, trackOpacity ], 
Append[ directivesForTransverseLines, trackOpacity ],
Append[ directivesForMainPoints, trackOpacity ], 
Append[ directivesForTransversePoints, trackOpacity ],
initailDirectionOfTransverseLines,
dofOrdering
 ],
{}
],
{anOldDof, Take[privateContext`oldDofs,- Min[ Length[privateContext`oldDofs ], nTrack ]]}
]
};
If[ AtomQ[ privateContext`oldDofs ], privateContext`oldDofs = {} ];
If[ ((And @@ (NumericQ /@ Flatten[ dofs ])) === True), privateContext`oldDofs =  Append[ privateContext`oldDofs, dofs ] ];
];
res
]


internalShowStickBuilding[ dofs:{_ ... }, heightsList:{ _ ...}, {scaleDisplacement_, scaleRotation_}, rotationLineLengthFraction_,
directivesForMainLine_, directivesForTransverseLines_,
directivesForMainPoints_, directivesForTransversePoints_,
initailDirectionOfTransverseLines_,
dofOrdering_,
"track", nTrack_
 ] := 
internalShowStickBuilding[ dofs, heightsList, {scaleDisplacement, scaleRotation}, rotationLineLengthFraction,
directivesForMainLine, directivesForTransverseLines,
directivesForMainPoints, directivesForTransversePoints,
initailDirectionOfTransverseLines,
dofOrdering,
"track", nTrack, Opacity[0.2]
 ]


internalShowStickBuilding[ dofs:{_ ... }, heightsList:{ _ ...}, {scaleDisplacement_, scaleRotation_}, rotationLineLengthFraction_,
directivesForMainLine_, directivesForTransverseLines_,
directivesForMainPoints_, directivesForTransversePoints_,
initailDirectionOfTransverseLines_,
dofOrdering_,
"track"
 ] := 
internalShowStickBuilding[ dofs, heightsList, {scaleDisplacement, scaleRotation}, rotationLineLengthFraction,
directivesForMainLine, directivesForTransverseLines,
directivesForMainPoints, directivesForTransversePoints,
initailDirectionOfTransverseLines,
dofOrdering,
"track", 1
 ]


internalShowStickBuilding[ "initial" ] := 
Block[ {privateContext},privateContext`oldDofs =  {}; ]


(* ::Subsection::Closed:: *)
(*Transforming from floor to building degrees-of-freedom ordering*)


internalBuildingToFloor[ indofs_ ] := With[ {nDofs = Length[ indofs ] / 3},
indofs[[ Transpose[ Partition[ Range[ 3 nDofs ], nDofs ] ] // Flatten ]] ]


internalFloorToBuilding[ indofs_ ] := With[ {nDofs = Length[ indofs ] / 3},
indofs[[ Transpose[ Partition[ Range[ 3 nDofs ], 3 ] ] // Flatten ]] ]


(* ::Subsection::Closed:: *)
(*Editor support*)


internalFormatNum[ x_ ] := Which[
Not[ FreeQ[ x, Missing, Infinity ] ], Missing,
Not[ FreeQ[ x, Indeterminate, Infinity ] ], Indeterminate,
NumericQ[ x ] && (Head[ x ] =!= Real && Head[ x ] =!= Integer ), Row[ {x," = ",  N[ x ]}],
Head[ x  ] === List,  If[ Count[x,b_ /; NumericQ[ b ] && (Head[ b ] =!= Real && Head[ b ] =!= Integer ) ] =!= 0,  Row[ {x," = ",  N[ x ]}], x ],
True, x ];


internalSingleInputFieldEditor[ doThisOnEditFunction_, whatToShowFunction_ ] := 
InputField[Dynamic[ whatToShowFunction[] // Which[ NumericQ[ # ] && Not[ IntegerQ[ # ] ], N[#], True, # ]&, (doThisOnEditFunction[ #1 ])& ] ]


internalSinglePopupEditor[ doThisOnEditFunction_, whatToShowFunction_, popupList_ ] := 
PopupMenu[Dynamic[ whatToShowFunction[], (doThisOnEditFunction[#1])& ], popupList ]


internalSingleCheckboxEditor[ doThisOnEditFunction_, whatToShowFunction_ ] := 
Checkbox[Dynamic[ whatToShowFunction[], (doThisOnEditFunction[#1])& ] ]


internalCoordinateEditor[ doThisOnEditFunction_, whatToShowFunction_ ] := 
Row[ {"{ ", InputField[Dynamic[ whatToShowFunction[][[1]] // N, (doThisOnEditFunction[{N[#1] , whatToShowFunction[][[2]]}])& ],
FieldSize -> {{8., 8.},{1.,Infinity}} ], ", ",
InputField[Dynamic[ whatToShowFunction[][[2]] // N, (doThisOnEditFunction[{whatToShowFunction[][[1]], N[#1]}])& ],
FieldSize -> {{8., 8.},{1.,Infinity}} ], " }"} ]


internalSingleValueRuleListEditor[ doThisOnEditFunction_, whatToShowFunction_, howToFormat_ ] := 
Module[ {ruleList, numberOfTerms},
Table[  
With[ {i=i}, Row[ {whatToShowFunction[][[i, 1]] // Quiet, " \[RuleDelayed] ", InputField[ Dynamic[ whatToShowFunction[][[i, 2]] // howToFormat // Quiet, 
doThisOnEditFunction[ 
ruleList = Quiet[ Flatten[ whatToShowFunction[] ] ];numberOfTerms =Quiet[ Length[ ruleList ] ];
Table[ With[ {RHS = Quiet[ If[ i === j, #1, ruleList[[ j, 2 ]] ] ]}, ruleList[[j, 1]] :> RHS ], {j, 1, numberOfTerms} ] ]& ], FieldSize -> {{5., 5.},{1.,Infinity}} ]} ] ],
{i, 1, Length[whatToShowFunction[] //Quiet]} ] 
]


internalCoordinateRuleListEditor[ doThisOnEditFunction_, whatToShowFunction_, howToFormat_ ] := 
Module[ {ruleList, numberOfTerms},
Table[  
With[ {i=i}, Row[ {whatToShowFunction[][[i, 1]], " \[RuleDelayed] ", 
Row[ {"{ ", InputField[ Dynamic[ whatToShowFunction[][[i, 2, 1]] // howToFormat, 
doThisOnEditFunction[ 
ruleList = Flatten[ whatToShowFunction[] ];numberOfTerms = Length[ ruleList ];
Table[ ruleList[[j, 1]] -> If[ i === j, {#1, ruleList[[ j, 2, 2 ]]}, ruleList[[ j, 2 ]] ], {j, 1, numberOfTerms} ] ]& ], FieldSize -> {{5., 5.},{1.,Infinity}} ],
", ",
InputField[ Dynamic[ whatToShowFunction[][[i, 2, 2]] // howToFormat, 
doThisOnEditFunction[ 
ruleList = Flatten[ whatToShowFunction[] ];numberOfTerms = Length[ ruleList ];
Table[ ruleList[[j, 1]] -> If[ i === j, {ruleList[[ j, 2, 1 ]], #1}, ruleList[[ j, 2 ]] ], {j, 1, numberOfTerms} ] ]& ], FieldSize -> {{5., 5.},{1.,Infinity}} ],
" }" }]} ] ],
{i, 1, Length[whatToShowFunction[]]} ] 
]


internalCoordinateListEditor[ doThisOnEditFunction_, whatToShowFunction_, howToFormat_ ] := 
Module[ {coordinateList, numberOfTerms},
Table[  
With[ {i=i}, Row[ {"{ ", InputField[ Dynamic[ whatToShowFunction[][[i, 1]] // howToFormat, 
doThisOnEditFunction[ 
coordinateList = whatToShowFunction[];numberOfTerms = Length[ coordinateList ];
Table[ If[ i === j, {#1, coordinateList[[ j, 2 ]]}, coordinateList[[ j ]] ], {j, 1, numberOfTerms} ] ]& ], FieldSize -> {{5., 5.},{1.,Infinity}} ],
", ",
InputField[ Dynamic[ whatToShowFunction[][[i, 2]] // howToFormat, 
doThisOnEditFunction[ 
coordinateList = whatToShowFunction[];numberOfTerms = Length[ coordinateList ];
Table[ If[ i === j, {coordinateList[[ j, 1 ]], #1 }, coordinateList[[ j ]] ], {j, 1, numberOfTerms} ] ]& ], FieldSize -> {{5., 5.},{1.,Infinity}} ],
" }" }] ],
{i, 1, Length[whatToShowFunction[]]} ] 
]


(* ::Section::Closed:: *)
(*Exported functions - shearSlab*)


(* ::Subsection:: *)
(*    ----------------------     shearSlab:  OBJECT SUPPORT     -------------------------------*)


(* ::Subsection::Closed:: *)
(*shearSlab: Options*)


$defaultSlabOptions = {
shearSlabThickness -> $defaultSlabThickness,
shearSlabSpecificGravity -> $defaultSlabSpecificGravity,
shearSlabAdditionalDeadMassAtCentroid -> 0,
shearSlabDrawType -> Polygon
};
Options[ shearSlabNew ] = $defaultSlabOptions;


Options[ shearSlabDraw ] = {
shearSlabDOF -> {0, 0, 0},
shearSlabCenterOfRotation -> {0, 0},
shearSlabZCoordinate -> 0,
shearSlabDisplacementScaleFactor ->  1,
shearSlabRotationScaleFactor ->  1,
shearSlabDrawType -> Automatic,
shearSlabDirectives -> Directive[ Opacity[ 0.4 ] ]
};


Options[ shearSlabDraw2D ] = {
shearSlabDOF -> {0, 0, 0},
shearSlabCenterOfRotation -> {0, 0},
shearSlabDisplacementScaleFactor ->  1,
shearSlabRotationScaleFactor ->  1,
shearSlabDrawType -> Automatic,
shearSlabDirectives -> Directive[Opacity[1],PointSize[0.03]],
shearSlabShowDeformedQ -> False
};


Options[ shearSlabSpecs ] = {
shearSlabView -> Grid,
shearSlabEdit -> False
};


(* ::Subsection::Closed:: *)
(*shearSlab: Global symbols*)


shearSlabKeysGetList = {shearSlabThickness,shearSlabOuterBorder,shearSlabSpecificGravity, shearSlabAdditionalDeadMassAtCentroid, shearSlabDrawType, shearSlabExistsQ };


shearSlabKeysPutList = {shearSlabThickness,shearSlabOuterBorder,shearSlabSpecificGravity, shearSlabAdditionalDeadMassAtCentroid, shearSlabDrawType };


(* ::Subsection::Closed:: *)
(*shearSlab: Local symbols (slab specific)*)


$defaultSlabThickness = 0.2;


(* ::Subsection::Closed:: *)
(*shearSlab: Clear all created objects*)


shearSlabClearAll[] := (
Do[
slabDataMaster[ i ][ shearSlabExistsQ ] = False,
{i, 1, shearSlabCount, 1}
];
shearSlabCount = 0;
Options[ shearSlabNew ] = $defaultSlabOptions;
True
)


(* ::Subsection::Closed:: *)
(*shearSlab: Creation*)


shearSlabNew[    outerBorderSpec:( (someList:{ {_, _} ... }/; Length[someList ] > 1) | (aBuilding_ /; Head[ aBuilding ] === shearBuilding && shearBuildingExistsQ[ aBuilding ] === True) ), OptionsPattern[  shearSlabNew ] ] := 
Module[ {shearSlabData, checkResult, setOuterBorderData, someBuilding, xMin, xMax, yMin, yMax, zMin, zMax },
shearSlabCount += 1;
shearSlabData = slabDataMaster[  shearSlabCount ];
shearSlabData[  shearSlabThickness ] = OptionValue[ shearSlabThickness];
shearSlabData[  shearSlabSpecificGravity ] = OptionValue[ shearSlabSpecificGravity];
shearSlabData[  shearSlabAdditionalDeadMassAtCentroid ] = OptionValue[ shearSlabAdditionalDeadMassAtCentroid];
shearSlabData[  shearSlabDrawType ] = OptionValue[ shearSlabDrawType];

If[ shearSlabData[  shearSlabThickness ] === Automatic, shearSlabData[  shearSlabThickness ] = $defaultSlabThickness ];
If[ shearSlabData[  shearSlabSpecificGravity ] === Automatic, shearSlabData[  shearSlabSpecificGravity ] = $defaultSpecificGravityOfConcrete ];
If[ shearSlabData[  shearSlabAdditionalDeadMassAtCentroid ] === Automatic, shearSlabData[  shearSlabAdditionalDeadMassAtCentroid ] = 0 ];
If[ Not[ MatchQ[ shearSlabData[  shearSlabDrawType ], Polygon | Line | Arrow ] ], shearSlabData[  shearSlabDrawType ] = Polygon ];

shearSlabData[  shearSlabExistsQ ] = True;

If[ Head[ outerBorderSpec ] === shearBuilding,
(
someBuilding = outerBorderSpec;
{{xMin, xMax}, {yMin, yMax}, {zMin, zMax} } = shearBuildingXYZminmaxPairsList[ someBuilding ];
setOuterBorderData = {{xMin,yMin}, {xMax, yMin}, {xMax, yMax}, {xMin, yMax}};
),
(
setOuterBorderData = outerBorderSpec;
) ];
shearSlabData[  shearSlabOuterBorder ] = setOuterBorderData;

checkResult = And @@ {
shearSlabCheck[ shearSlabThickness, shearSlabData[  shearSlabThickness ] ],
shearSlabCheck[ shearSlabSpecificGravity, shearSlabData[  shearSlabSpecificGravity ]  ],
shearSlabCheck[ shearSlabAdditionalDeadMassAtCentroid, shearSlabData[  shearSlabAdditionalDeadMassAtCentroid ] ], 
shearSlabCheck[ shearSlabOuterBorder, shearSlabData[  shearSlabOuterBorder ] ],
shearSlabCheck[ shearSlabDrawType, shearSlabData[  shearSlabDrawType ] ]
};


If[ checkResult === True, shearSlab[ shearSlabCount ], 
(shearSlabData[  shearSlabExistsQ ] = False; shearSlabCount -= 1; $Failed ) 
]
]


(* ::Subsection::Closed:: *)
(*shearSlab: Deep cloning*)


shearSlabDeepClone[ a_shearSlab  ] := 
shearSlabNew[ shearSlabGet[ a, shearSlabOuterBorder ],
shearSlabThickness->shearSlabGet[ a, shearSlabThickness ],
shearSlabSpecificGravity->shearSlabGet[ a, shearSlabSpecificGravity ],
shearSlabAdditionalDeadMassAtCentroid->shearSlabGet[ a, shearSlabAdditionalDeadMassAtCentroid ],
shearSlabDrawType->shearSlabGet[ a, shearSlabDrawType ]
]


(* ::Subsection::Closed:: *)
(*shearSlab: Setting options with checking*)


shearSlabNew /: SetOptions[ shearSlabNew, OptionsPattern[ shearSlabNew ] ] := 
Module[ {checkResult},

checkResult = 
And @@ Table[  shearSlabCheck[ whatToCheck, OptionValue[  whatToCheck ] ],
{whatToCheck, {shearSlabThickness,shearSlabSpecificGravity,shearSlabAdditionalDeadMassAtCentroid, shearSlabDrawType }} ];

If[ checkResult,
Options[ shearSlabNew ] = Table[ whatOption -> OptionValue[ whatOption ], {whatOption, {shearSlabThickness,shearSlabSpecificGravity,shearSlabAdditionalDeadMassAtCentroid, shearSlabDrawType}} ],

$Failed
]
]


(* ::Subsection::Closed:: *)
(*shearSlab: Checking*)


shearSlabCheck[ shearSlabThickness, someValue_ ] := 
(
If[  ( With[ {v = someValue}, NumericQ[ v ] && v <= 0 ] ),
Message[ shearWalls::incom, {shearSlabThickness -> someValue} ]; False, 
True ]
)


shearSlabCheck[ shearSlabSpecificGravity, someValue_ ] := 
(
If[  (With[ {v = someValue}, NumericQ[ v ] && v <= 0 ] ),
Message[ shearWalls::incom, {shearSlabSpecificGravity -> someValue} ]; False, 
True ]
)


shearSlabCheck[ shearSlabAdditionalDeadMassAtCentroid, someValue_ ] := 
(
If[  (With[ {v = someValue}, NumericQ[ v ] && v < 0 ] ),
Message[ shearWalls::incom, {shearSlabAdditionalDeadMassAtCentroid -> someValue} ]; False, 
True ]
)


shearSlabCheck[ shearSlabDrawType, someValue_ ] := 
(
If[  Not[ MatchQ[someValue,Line | Polygon | Arrow ] ] ,
Message[ shearWalls::incom, {shearSlabDrawType -> someValue} ]; False, 
True ]
)


shearSlabCheck[ shearSlabOuterBorder, someValue_ ] := 
(
If[  
(***  check that the pattern is correct ***)
Not[ MatchQ[someValue, { {_?NumericQ, _?NumericQ} ... } ] ]  ||  Not[ Length[ someValue ] > 2 ],
Message[ shearWalls::incom, {shearSlabOuterBorder -> someValue} ]; False, 
True ]
)


shearSlabCheck[ a_ /; Not[ MemberQ[shearSlabKeysList,a ] ], someValue_ ] := 
(
Message[ shearWalls::noMem, shearSlab, a ];
False
)


(* ::Subsection::Closed:: *)
(*shearSlab: Getting*)


shearSlabGet[ a_shearSlab, shearSlabDrawType ] := With[ {whatToGet = shearSlabDrawType},
slabDataMaster[ a[[ 1  ]] ][  whatToGet ] ] /; shearSlabGet[ a, shearSlabExistsQ ]


shearSlabGet[ a_shearSlab, shearSlabExistsQ ] := (slabDataMaster[ a[[ 1  ]] ][ shearSlabExistsQ ] === True)


shearSlabGet[ a_shearSlab, shearSlabThickness ] := With[ {whatToGet = shearSlabThickness},
slabDataMaster[ a[[ 1  ]] ][  whatToGet ] ] /; shearSlabGet[ a, shearSlabExistsQ ]


shearSlabGet[ a_shearSlab, shearSlabSpecificGravity ] := With[ {whatToGet = shearSlabSpecificGravity},
slabDataMaster[ a[[ 1  ]] ][  whatToGet ] ] /; shearSlabGet[ a, shearSlabExistsQ ]


shearSlabGet[ a_shearSlab, shearSlabAdditionalDeadMassAtCentroid ] := With[ {whatToGet = shearSlabAdditionalDeadMassAtCentroid},
slabDataMaster[ a[[ 1  ]] ][  whatToGet ] ] /; shearSlabGet[ a, shearSlabExistsQ ]


shearSlabGet[ a_shearSlab, shearSlabOuterBorder ] := With[ {whatToGet = shearSlabOuterBorder},
slabDataMaster[ a[[ 1  ]] ][  whatToGet ] ] /; shearSlabGet[ a, shearSlabExistsQ ]


shearSlabGet[ a_shearSlab, whatToGet_ /;  Not[ MemberQ[ shearSlabKeysGetList,whatToGet ] ] ] := 
(Message[ shearWalls::noMem, a, whatToGet ]; $Failed)


(* ::Text:: *)
(*Alternative calling methods:*)


shearSlabExistsQ[ a_shearSlab ] := shearSlabGet[ a, shearSlabExistsQ ]
shearSlabThickness[ a_shearSlab ] := shearSlabGet[ a, shearSlabThickness ]
shearSlabSpecificGravity[ a_shearSlab ] := shearSlabGet[ a, shearSlabSpecificGravity ]
shearSlabAdditionalDeadMassAtCentroid[ a_shearSlab ] := shearSlabGet[ a, shearSlabAdditionalDeadMassAtCentroid ]
shearSlabOuterBorder[ a_shearSlab ] := shearSlabGet[ a, shearSlabOuterBorder ]
shearSlabDrawType[ a_shearSlab ] := shearSlabGet[ a, shearSlabDrawType ]


(* ::Subsection::Closed:: *)
(*shearSlab: Putting*)


shearSlabPut[ a_shearSlab, whatToPut_ /;  MemberQ[shearSlabKeysPutList ,whatToPut ], value_ ] := 
If[ shearSlabCheck[ whatToPut, value ] === True,
(slabDataMaster[ a[[1]] ][ whatToPut ] = value),
$Failed
] /; shearSlabGet[ a, shearSlabExistsQ ]


shearSlabPut[ a_shearSlab, whatToPut_ /;  Not[ MemberQ[shearSlabKeysPutList ,whatToPut ] ], value_ ] := (Message[ shearSlabs::noMem, shearSlab, whatToPut ]; $Failed);


(* ::Subsection:: *)
(*---------------------     shearSlab:  CALCULATIONS   ------------------------------*)


(* ::Subsection::Closed:: *)
(*shearSlab: Getting the centroid, area and the polar moment of inertia*)


shearSlabXYminmaxPairsList[ a_shearSlab ] := 
Module[ {allXYCoordinates, xMin, xMax, yMin, yMax},

allXYCoordinates = shearSlabGet[ a, shearSlabOuterBorder ];
{xMin, xMax, yMin, yMax} = {Min[  allXYCoordinates[[ All, 1 ]] ], Max[  allXYCoordinates[[ All, 1 ]] ], Min[  allXYCoordinates[[ All, 2 ]] ], Max[  allXYCoordinates[[ All, 2 ]] ]};

{{xMin, xMax}, {yMin, yMax}}
]


shearSlabCentroid[ a_shearSlab ] := 
Module[ {allXYCoordinates },

allXYCoordinates = shearSlabGet[ a, shearSlabOuterBorder ];

If[ And @@ (NumericQ /@ Flatten[ allXYCoordinates ]), cgOfPolygon[ N[ allXYCoordinates ] ], cgOfPolygon[ allXYCoordinates ] ]
]


shearSlabArea[ a_shearSlab ] := 
Module[ {allXYCoordinates },

allXYCoordinates = shearSlabGet[ a, shearSlabOuterBorder ];

If[ And @@ (NumericQ /@ Flatten[ allXYCoordinates ]), areaOfPolygon[ N[ allXYCoordinates ] ], areaOfPolygon[ allXYCoordinates ] ]
]


shearSlabPolarMomentOfInertiaRelativeToCentroid[ a_shearSlab ] := 
Module[ {allXYCoordinates },

allXYCoordinates = shearSlabGet[ a, shearSlabOuterBorder ];

If[ And @@ (NumericQ /@ Flatten[ allXYCoordinates ]), polarMomentOfInertiaRelativeToCentroidOfPolygon[ N[ allXYCoordinates ] ], polarMomentOfInertiaRelativeToCentroidOfPolygon[ allXYCoordinates ] ]
]


shearSlabMassSlabOnly[ a_shearSlab ] := shearSlabArea[ a ] * shearSlabGet[ a, shearSlabThickness ] * shearSlabGet[ a, shearSlabSpecificGravity ] * $densityOfWater


shearSlabMassSlabAndDeadMass[a_shearSlab ] := shearSlabMassSlabOnly[ a ] + shearSlabGet[ a, shearSlabAdditionalDeadMassAtCentroid ]


shearSlabMassPolarMomentOfInertiaRelativeToCentroid[ a_shearSlab ] := shearSlabPolarMomentOfInertiaRelativeToCentroid[ a ] * shearSlabGet[ a, shearSlabThickness ] * shearSlabGet[ a, shearSlabSpecificGravity ] * $densityOfWater


shearSlabPolarMomentOfInertiaRelativeToSpecifiedCenter[ a_shearSlab, {xc_, yc_} ] := 
Module[ {allXYCoordinates, xcNoUnits, ycNoUnits},

allXYCoordinates = shearSlabGet[ a, shearSlabOuterBorder ];
{xcNoUnits, ycNoUnits} = {xc, yc};

If[ (And @@ (NumericQ /@ Flatten[ allXYCoordinates ])) &&  NumericQ[ xcNoUnits ] && NumericQ[ ycNoUnits ], 
polarMomentOfInertiaRelativeToSpecifiedCenter[ N[ allXYCoordinates ], N[{xcNoUnits, ycNoUnits}] ], 
polarMomentOfInertiaRelativeToSpecifiedCenter[ allXYCoordinates, {xcNoUnits, ycNoUnits} ] ]
]


shearSlabMassPolarMomentOfInertiaRelativeToSpecifiedCenter[ a_shearSlab, {xc_, yc_} ] := shearSlabPolarMomentOfInertiaRelativeToSpecifiedCenter[ a , {xc, yc} ] * shearSlabGet[ a, shearSlabThickness ] * shearSlabGet[ a, shearSlabSpecificGravity ] * $densityOfWater


(* ::Subsection:: *)
(*---------------------     shearSlab:  VIEWERS   ------------------------------*)


(* ::Subsection::Closed:: *)
(*shearSlab: Drawing 2D*)


shearSlabDraw2D[ a_shearSlab, OptionsPattern[ shearSlabDraw2D ] ] := 
Module[ {
theShearSlabDOF,theShearSlabCenterOfRotation,theShearSlabDisplacementScaleFactor,
theShearSlabDrawType, theShearSlabDirectives,
theShearSlabRotationScaleFactor, theSlabCoordinates,
ux, uy, \[Theta], xyCentroid
},

(**** Get options *****)
{theShearSlabDOF,theShearSlabCenterOfRotation,theShearSlabDisplacementScaleFactor,theShearSlabDrawType, theShearSlabDirectives, theShearSlabRotationScaleFactor} = 
{OptionValue[shearSlabDOF],OptionValue[shearSlabCenterOfRotation],OptionValue[shearSlabDisplacementScaleFactor],OptionValue[shearSlabDrawType], OptionValue[shearSlabDirectives], OptionValue[ shearSlabRotationScaleFactor ]};

(**** Handle defaults ******)
If[ theShearSlabDOF === Automatic  ||  theShearSlabDOF == 0, theShearSlabDOF = {0, 0, 0} ];
If[ theShearSlabCenterOfRotation === Automatic, theShearSlabCenterOfRotation = shearSlabCentroid[ a ] ];
If[ theShearSlabDisplacementScaleFactor === Automatic, theShearSlabDisplacementScaleFactor = 1 ];
If[ theShearSlabRotationScaleFactor === Automatic, theShearSlabRotationScaleFactor = 1 ];
If[ theShearSlabDrawType === Automatic, theShearSlabDrawType = Line ];
If[ theShearSlabDirectives === Automatic, theShearSlabDirectives = Directive[{}] ];
If[ Not[ OptionValue[ shearSlabShowDeformedQ ] === True ],
theShearSlabDOF = {0, 0, 0};
];

(**** Get slab border coordinates ****)
theSlabCoordinates = shearSlabGet[ a, shearSlabOuterBorder];
xyCentroid = shearSlabCentroid[ a ];

(**** Remove dimensions ****)
{ux, uy, \[Theta]} = theShearSlabDOF;
theSlabCoordinates = Append[ theSlabCoordinates, theSlabCoordinates[[1]] ];

theShearSlabCenterOfRotation = theShearSlabCenterOfRotation;
xyCentroid =xyCentroid;

{theShearSlabDirectives, theShearSlabDrawType[ Table[ iPt + calcDisplacement[ iPt, {theShearSlabDisplacementScaleFactor * ux, theShearSlabDisplacementScaleFactor * uy, theShearSlabRotationScaleFactor * \[Theta]}, theShearSlabCenterOfRotation ] , {iPt, theSlabCoordinates}] ], Point[ xyCentroid  + calcDisplacement[ xyCentroid, {theShearSlabDisplacementScaleFactor * ux, theShearSlabDisplacementScaleFactor * uy, theShearSlabRotationScaleFactor * \[Theta]}, theShearSlabCenterOfRotation ]]}

] /; shearSlabGet[ a, shearSlabExistsQ ]


(* ::Subsection::Closed:: *)
(*shearSlab: Drawing 3D*)


shearSlabDraw[ a_shearSlab, OptionsPattern[ shearSlabDraw ] ] := graphics3DPrimitives[ a, Table[  First[ anOption ] -> OptionValue[ First[ anOption ] ], {anOption, Options[ shearSlabDraw ]}]] /; shearSlabGet[ a, shearSlabExistsQ ]


graphics3DPrimitives[ a_shearSlab, OptionsPattern[ shearSlabDraw ] ] := 
Module[ {
theShearSlabDOF,theShearSlabCenterOfRotation,theShearSlabZCoordinate,theShearSlabDisplacementScaleFactor,theShearSlabDrawType, theShearSlabDirectives,
theShearSlabRotationScaleFactor,
polygonBottom, polygonTop, polygonSides,dsFactor, theSlabThickness, theSlabCoordinates,
ux, uy, \[Theta]
 },

(**** Get options *****)
{theShearSlabDOF,theShearSlabCenterOfRotation,theShearSlabZCoordinate,theShearSlabDisplacementScaleFactor,theShearSlabDrawType, theShearSlabDirectives, theShearSlabRotationScaleFactor} = 
{OptionValue[shearSlabDOF],OptionValue[shearSlabCenterOfRotation],OptionValue[shearSlabZCoordinate],OptionValue[shearSlabDisplacementScaleFactor],OptionValue[shearSlabDrawType], OptionValue[shearSlabDirectives], OptionValue[ shearSlabRotationScaleFactor ]};
theSlabThickness = shearSlabGet[ a, shearSlabThickness ];
theSlabCoordinates = shearSlabGet[ a, shearSlabOuterBorder ];

(**** Handle defaults ******)
If[ theShearSlabDOF === Automatic  ||  theShearSlabDOF == 0, theShearSlabDOF = {0, 0, 0} ];
If[ theShearSlabCenterOfRotation === Automatic, theShearSlabCenterOfRotation = shearSlabCentroid[ a ] ];
If[ theShearSlabZCoordinate === Automatic, theShearSlabZCoordinate = 0 ];
If[ theShearSlabDisplacementScaleFactor === Automatic, theShearSlabDisplacementScaleFactor = 1 ];
If[ theShearSlabRotationScaleFactor === Automatic, theShearSlabRotationScaleFactor = 1 ];
If[ theShearSlabDrawType === Automatic, theShearSlabDrawType = shearSlabGet[ a, shearSlabDrawType ] ];
If[ theShearSlabDirectives === Automatic, theShearSlabDirectives = Directive[{}] ];

(**** Remove dimensions ****)
{ux, uy, \[Theta]} = theShearSlabDOF;

polygonBottom = Flatten[ {theShearSlabDirectives, EdgeForm[ theShearSlabDirectives ], theShearSlabDrawType[ Table[ With[ {v = {iPt[[1]], iPt[[2]], theShearSlabZCoordinate - 0.5 * theSlabThickness}}, v + calcDisplacement[ v, {theShearSlabDisplacementScaleFactor * ux, theShearSlabDisplacementScaleFactor * uy, theShearSlabRotationScaleFactor * \[Theta]}, theShearSlabCenterOfRotation ] ] , {iPt, theSlabCoordinates}] ] } ];
polygonTop = Flatten[ {theShearSlabDirectives, EdgeForm[ theShearSlabDirectives ], theShearSlabDrawType[ Table[ With[ {v = {iPt[[1]], iPt[[2]], theShearSlabZCoordinate + 0.5 * theSlabThickness}}, v + calcDisplacement[ v, {theShearSlabDisplacementScaleFactor * ux, theShearSlabDisplacementScaleFactor * uy, theShearSlabRotationScaleFactor * \[Theta]}, theShearSlabCenterOfRotation ] ], {iPt, theSlabCoordinates}] ] } ];
polygonSides  = Flatten[ {theShearSlabDirectives, 
EdgeForm[ theShearSlabDirectives ],
Table[ theShearSlabDrawType[  With[ {v = #}, v + calcDisplacement[ v, {theShearSlabDisplacementScaleFactor * ux, theShearSlabDisplacementScaleFactor * uy, theShearSlabRotationScaleFactor * \[Theta]}, theShearSlabCenterOfRotation ] ]& /@ {
{iPts[[1, 1]], iPts[[1, 2]], theShearSlabZCoordinate - 0.5 * theSlabThickness}, 
{iPts[[2, 1]], iPts[[2, 2]], theShearSlabZCoordinate - 0.5 * theSlabThickness},
{iPts[[2, 1]], iPts[[2, 2]], theShearSlabZCoordinate + 0.5 * theSlabThickness},
{iPts[[1, 1]], iPts[[1, 2]], theShearSlabZCoordinate + 0.5 * theSlabThickness},
{iPts[[1, 1]], iPts[[1, 2]], theShearSlabZCoordinate - 0.5 * theSlabThickness} 
} ], 
{iPts, Partition[ Append[theSlabCoordinates,theSlabCoordinates[[1]]], 2, 1 ]}] } ];


{
polygonBottom, 
polygonTop, 
polygonSides
}
] /; shearSlabGet[ a, shearSlabExistsQ ]


(* ::Subsection::Closed:: *)
(*shearSlab: Showing and editing specs*)


shearSlabSpecs[ a_shearSlab, OptionsPattern[ shearSlabSpecs ] ] := 
Module[ {howToPresent, isEditQ, theData, theHeader, theAll,

thicknessEditor, specificGravityEditor, deadMassEditor, drawTypeEditor, outerBorderEditor
},

howToPresent = OptionValue[ shearSlabView ];
If[ Not[ MatchQ[ howToPresent, List | Table | Grid ] ], 
(
Message[ shearWalls::incon, howToPresent, shearSlabView ];
Return[ $Failed ]
)
];

theHeader = {{Row[ {"Slab: ", a } ], SpanFromLeft, SpanFromLeft},{"Parameter", "Value", "Units"}};

isEditQ = OptionValue[ shearSlabEdit ] /. Automatic -> False;
If[isEditQ =!= True, isEditQ = False ];

thicknessEditor = internalSingleInputFieldEditor[ (shearSlabPut[ a, shearSlabThickness, # ] === $Failed)&, shearSlabThickness[ a ]& ];
specificGravityEditor = internalSingleInputFieldEditor[ (shearSlabPut[ a, shearSlabSpecificGravity, # ] === $Failed)&, shearSlabSpecificGravity[ a ]& ];
deadMassEditor = internalSingleInputFieldEditor[ (shearSlabPut[ a, shearSlabAdditionalDeadMassAtCentroid, # ] === $Failed)&, shearSlabAdditionalDeadMassAtCentroid[ a ]& ];
drawTypeEditor = internalSinglePopupEditor[ (shearSlabPut[ a, shearSlabDrawType, # ] === $Failed)&, shearSlabDrawType[ a ]&, {Line, Polygon, Arrow} ];
outerBorderEditor = internalCoordinateListEditor[ shearSlabPut[ a, shearSlabOuterBorder, # ]&, shearSlabOuterBorder[ a ]&, N ];

theData := {
{"Thickness: ", If[ isEditQ,
thicknessEditor,
shearSlabThickness[ a ]// internalFormatNum ], "m"},

{"Specific gravity: ", If[ isEditQ,
specificGravityEditor,
shearSlabSpecificGravity[ a ]// internalFormatNum ], ""},

{"Dead mass at centroid: ", If[ isEditQ,
deadMassEditor,
shearSlabAdditionalDeadMassAtCentroid[ a ]// internalFormatNum ], "Kg"},

{"Outer border coordinates: ", If[ isEditQ,
outerBorderEditor,
shearSlabOuterBorder[ a ]// internalFormatNum ], "m"},

{"slab outer border shape", With[ {pts =shearSlabOuterBorder[ a ]},
Graphics[ {Thick, Line[ Append[ pts, pts[[1]] ]  ], PointSize[ 0.1], Point[ shearSlabCentroid[ a ] ]}, ImageSize -> {100, 100}, AspectRatio -> Automatic, Frame -> True, GridLines -> Automatic, FrameTicks -> Automatic  ] ], ""},

{"Default draw type: ", If[ isEditQ,
drawTypeEditor,
shearSlabDrawType[ a ]// internalFormatNum ], ""},

{"centroid", shearSlabCentroid[ a ], "m"},

{"area", shearSlabArea[ a ], "\!\(\*SuperscriptBox[\(m\), \(2\)]\)"},

{"\!\(\*SubscriptBox[\(I\), \(p\)]\) (centroidal)", shearSlabPolarMomentOfInertiaRelativeToCentroid[ a ], "\!\(\*SuperscriptBox[\(m\), \(4\)]\)"},

{"mass (no dead load)", shearSlabMassSlabOnly[ a ], "Kg"},

{"mass (total)", shearSlabMassSlabAndDeadMass[ a ], "Kg"},

{"\[Integral] \!\(\*SuperscriptBox[\(r\), \(2\)]\) dm", shearSlabMassPolarMomentOfInertiaRelativeToCentroid[ a ], "Kg \!\(\*SuperscriptBox[\(m\), \(2\)]\)"}
};

theAll := Join[theHeader, theData];

If[ isEditQ,
Switch[ 
howToPresent,
List, theAll,
Table, MatrixForm[ theAll ],
_, Grid[ theAll, Spacings -> {{{2}}, Automatic}, Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, {True}, Thick}} ]
] // Dynamic,
Switch[ 
howToPresent,
List, theAll,
Table, MatrixForm[ theAll ],
_, Grid[ theAll, Spacings -> {{{2}}, Automatic}, Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, {True}, Thick}} ]
]
]

] /; shearSlabGet[ a, shearSlabExistsQ ]


(* ::Section::Closed:: *)
(*Exported functions - shearWall*)


(* ::Subsubsection::Closed:: *)
(*Stuff to export*)


{shearWallHeightList, shearWallNumberOfFloors, shearWallCenterOfRotationRules, shearWallDisplacementScaleFactor, shearWallRotationScaleFactor, shearWallDOFList, shearWallView, shearWallDrawType, shearWallDirectives, shearWallAnnotateStyleFunction, shearWallAnnotateTextList, shearWallAnnotateAlongPositiveNormalQ, shearWallAnnotateDistanceFromWall, shearWallAnnotateOrientation, shearWallShowDeformedQ, shearWallEdit};


{shearWallBaseStartCoordinates, shearWallBaseEndCoordinates, shearWallIncludeWhatStiffness, shearWallBaseLength, shearWallLengthAtFloor, shearWallThicknessRules, shearWallThicknessAtFloor, shearWallStartEndLengthFractionsRules, shearWallShearModulus, shearWallUnitVectorAlongWall, shearWallYoungsModulus, shearWallExistsQ, shearWallStartEndLengthFractionsAtFloor, shearWallStartCoordinatesAtFloor, shearWallEndCoordinatesAtFloor};


{shearWallIncludeBendingTypeOnly, shearWallIncludeShearTypeOnly, shearWallIncludeShearAndBendingTypes};


{shearWallClearAll, shearWallCheck, shearWallGet, shearWallPut, shearWallUnitVectorAlongWall, shearWallDisplacementMagnitudesAlongWall, shearWallShearForcesAlongWall, shearWallStiffnessMatrix, shearWallSpecs, shearWallDraw, shearWallDraw2D, shearWallNew, shearWallDeepClone};


(* ::Subsection:: *)
(*    ----------------------     shearWall:  OBJECT SUPPORT   -------------------------------*)


(* ::Subsection::Closed:: *)
(*shearWall: Global symbols*)


shearWallKeysGetList = {shearWallBaseStartCoordinates, shearWallBaseEndCoordinates, shearWallIncludeWhatStiffness, shearWallBaseLength, shearWallThicknessRules, shearWallThicknessAtFloor, shearWallStartEndLengthFractionsRules, shearWallUnitVectorAlongWall, shearWallShearModulus, shearWallYoungsModulus, shearWallStartEndLengthFractionsAtFloor, shearWallStartCoordinatesAtFloor, shearWallEndCoordinatesAtFloor, shearWallExistsQ, shearWallSpecificGravity, shearWallIncludeMassQ };


shearWallKeysPutList = {shearWallBaseStartCoordinates, shearWallBaseEndCoordinates, shearWallIncludeWhatStiffness, shearWallBaseLength, shearWallThicknessRules, shearWallStartEndLengthFractionsRules, shearWallUnitVectorAlongWall, shearWallShearModulus, shearWallYoungsModulus,
shearWallSpecificGravity, shearWallIncludeMassQ };


(* ::Subsection::Closed:: *)
(*shearWall: Options*)


(* ::Subsubsection::Closed:: *)
(*part 1:  shearWallNew*)


$defaultWallOptions = {
shearWallThicknessRules ->{ _ ->  $defaultWallThickness  },
shearWallStartEndLengthFractionsRules -> { _ -> {0, 1} },
shearWallShearModulus -> $defaultShearModulusOfConcrete,
shearWallYoungsModulus -> $defaultYoungsModulusOfConcrete,

shearWallIncludeWhatStiffness -> shearWallIncludeShearAndBendingTypes,

shearWallSpecificGravity -> $defaultWallSpecificGravity, 
shearWallIncludeMassQ -> True
};
Options[ shearWallNew ] = $defaultWallOptions;


(* ::Subsubsection::Closed:: *)
(*part 2: shearWallDraw2D, shearWallDraw, shearWallSpecs*)


$defaultAnnotationDistanceFromWallFraction = 0.2;


Options[ shearWallDraw2D ] = {
shearWallNumberOfFloors -> 1,
shearWallDOFList -> None,
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} },
shearWallDisplacementScaleFactor ->  1,
shearWallRotationScaleFactor -> 1,
shearWallDrawType -> Line,
shearWallDirectives -> Directive[ Opacity[ 1 ] ],
shearWallAnnotateStyleFunction -> Identity,
shearWallAnnotateTextList -> None,
shearWallAnnotateAlongPositiveNormalQ -> False,
shearWallAnnotateDistanceFromWall -> Automatic,
shearWallAnnotateOrientation -> {1, 0},
shearWallShowDeformedQ -> False
};


Options[ shearWallDraw ] = {
shearWallDOFList -> None,
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} },
shearWallDisplacementScaleFactor ->  1,
shearWallRotationScaleFactor -> 1,
shearWallDrawType -> Polygon,
shearWallDirectives -> Directive[ Opacity[ 0.4 ] ],
shearWallHeightList -> {3},
shearWallShowDeformedQ -> False
};


Options[ shearWallSpecs ] = {
shearWallView -> Grid,
shearWallEdit -> False
};


(* ::Subsubsection::Closed:: *)
(*part 3: shearWallDisplacementMagnitudesAlongWall, ...*)


Options[ shearWallDisplacementMagnitudesAlongWall ] = {
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


Options[ shearWallShearForcesAlongWall ] = {
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


Options[ shearWallBendingMomentPairs ] = {
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


(* ::Subsubsection::Closed:: *)
(*part 4: shearWallMassList, shearWallMassPolarMomentOfInertiaList, shearWallMassTotal, shearWallMassPolarMomentOfInertiaTotal, shearWallMassMatrix*)


Options[ shearWallMassList ] = {};


Options[ shearWallMassLumpedList ] = {};


Options[ shearWallMassTotal ] = {};


Options[ shearWallMassPolarMomentOfInertiaList ] = {
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


Options[ shearWallMassLumpedPolarMomentOfInertiaList ] = {
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


Options[ shearWallMassPolarMomentOfInertiaTotal ] = {
shearWallCenterOfRotationRules -> Automatic
};


Options[ shearWallMassMatrix ] = {
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


(* ::Subsubsection::Closed:: *)
(*part 5: shearWallStiffnessMatrix*)


Options[ shearWallStiffnessMatrix ] = {
shearWallDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearWallCenterOfRotationRules -> { _ -> {0, 0} }
};


(* ::Subsection::Closed:: *)
(*shearWall: Clear all created objects*)


shearWallClearAll[] := (
Do[
wallDataMaster[ i ][ shearWallExistsQ ] = False,
{i, 1, shearWallCount, 1}
];
shearWallCount = 0;
Options[ shearWallNew ] = $defaultWallOptions;
True
)


(* ::Subsection::Closed:: *)
(*shearWall: Creation*)


shearWallNew[  startCoordinates:{ _, _}, endCoordinates:{_, _}, OptionsPattern[  shearWallNew ] ] := 
Module[ {shearWallData, checkResult},
shearWallCount += 1;
shearWallData = wallDataMaster[  shearWallCount ];
shearWallData[  shearWallThicknessRules ] = OptionValue[ shearWallThicknessRules];
shearWallData[  shearWallShearModulus ] = OptionValue[ shearWallShearModulus];
shearWallData[  shearWallYoungsModulus ] = OptionValue[ shearWallYoungsModulus];
shearWallData[  shearWallIncludeWhatStiffness ] = OptionValue[ shearWallIncludeWhatStiffness];
shearWallData[  shearWallStartEndLengthFractionsRules ] = OptionValue[ shearWallStartEndLengthFractionsRules ];

shearWallData[  shearWallSpecificGravity ] = OptionValue[ shearWallSpecificGravity ];
shearWallData[  shearWallIncludeMassQ ] = OptionValue[ shearWallIncludeMassQ ];

shearWallData[  shearWallBaseStartCoordinates ] = startCoordinates;
shearWallData[  shearWallBaseEndCoordinates ] = endCoordinates;

shearWallData[  shearWallExistsQ ] = True;

checkResult = And @@ Table[  shearWallCheck[ whatToCheck, shearWallData[  whatToCheck ] ],
{whatToCheck, {shearWallThicknessRules, shearWallShearModulus, shearWallYoungsModulus, shearWallIncludeWhatStiffness, shearWallBaseStartCoordinates,shearWallBaseEndCoordinates, shearWallSpecificGravity, shearWallIncludeMassQ }} ];

If[ checkResult === True, shearWall[ shearWallCount ], 
(shearWallData[  shearWallExistsQ ] = False; shearWallCount -= 1; $Failed ) 
]
]


shearWallNew[ {startCoordinates:{ _, _}, endCoordinates:{_, _}}, someOptions:OptionsPattern[  shearWallNew ] ] := 
shearWallNew[startCoordinates, endCoordinates, someOptions ]


shearWallNew[ Missing ] := 
shearWallNew[{Missing, Missing} , {Missing, Missing} , 
{shearWallThicknessRules ->{Global`i_ -> Missing},
shearWallStartEndLengthFractionsRules -> {Global`i_ -> {0, 1}},
shearWallShearModulus -> Missing,
shearWallYoungsModulus -> Missing,

shearWallIncludeWhatStiffness -> shearWallIncludeShearAndBendingTypes,

shearWallSpecificGravity -> Missing, 
shearWallIncludeMassQ -> True}
]


shearWallNew[] := shearWallNew[ Missing ]


shearWallNew[ someOptions:OptionsPattern[  shearWallNew ] ] := 
shearWallNew[ {Missing, Missing} , {Missing, Missing} , 
Flatten[ Join[{ FilterRules[{someOptions},Options[  shearWallNew ]],
{shearWallThicknessRules ->{Global`i_ -> Missing},
shearWallStartEndLengthFractionsRules -> {Global`i_ -> {0, 1}},
shearWallShearModulus -> Missing,
shearWallYoungsModulus -> Missing,

shearWallIncludeWhatStiffness -> shearWallIncludeShearAndBendingTypes,

shearWallSpecificGravity -> Missing, 
shearWallIncludeMassQ -> True} } ] ] ]


(* ::Subsection::Closed:: *)
(*shearWall: Deep cloning*)


shearWallDeepClone[ a_shearWall  ] := 
shearWallNew[ shearWallGet[ a, shearWallBaseStartCoordinates ], shearWallGet[ a, shearWallBaseEndCoordinates ],

shearWallThicknessRules ->shearWallGet[ a, shearWallThicknessRules ],
shearWallStartEndLengthFractionsRules -> shearWallGet[ a, shearWallStartEndLengthFractionsRules ],
shearWallShearModulus -> shearWallGet[ a, shearWallShearModulus ],
shearWallYoungsModulus -> shearWallGet[ a, shearWallYoungsModulus ],

shearWallIncludeWhatStiffness -> shearWallGet[ a, shearWallIncludeWhatStiffness ],

shearWallSpecificGravity -> shearWallGet[ a, shearWallSpecificGravity ], 
shearWallIncludeMassQ -> shearWallGet[ a, shearWallIncludeMassQ ]
]


(* ::Subsection::Closed:: *)
(*shearWall: Setting options with checking*)


shearWallNew /: SetOptions[ shearWallNew, OptionsPattern[ shearWallNew ] ] := 
Module[ {checkResult},

checkResult = 
And @@ Table[  shearWallCheck[ whatToCheck, OptionValue[  whatToCheck ] ],
{whatToCheck, {shearWallThicknessRules,shearWallStartEndLengthFractionsRules,shearWallShearModulus,shearWallYoungsModulus,shearWallIncludeWhatStiffness, shearWallSpecificGravity, shearWallIncludeMassQ }} ];

If[ checkResult,
Options[ shearWallNew ] = Table[ whatOption -> OptionValue[ whatOption ], {whatOption, {shearWallThicknessRules,shearWallStartEndLengthFractionsRules,shearWallShearModulus,shearWallYoungsModulus,shearWallIncludeWhatStiffness, shearWallSpecificGravity, shearWallIncludeMassQ}} ],

$Failed
]
]


(* ::Subsection::Closed:: *)
(*shearWall: Checking*)


shearWallCheck[ shearWallSpecificGravity, someValue_ ] := 
If[  If[ NumericQ[ someValue ] &&  someValue <= 0 === True, True, False ],
Message[ shearWalls::incom, {shearWallSpecificGravity -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallIncludeMassQ, someValue_ ] := 
If[  MatchQ[ someValue, True | False] =!= True,
Message[ shearWalls::incom, {shearWallIncludeMassQ -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallThicknessRules, someValue_ ] := 
If[  someValue =!= Missing  &&  (Not[ MatchQ[ someValue, { ((Verbatim[ Rule ] | Verbatim[ RuleDelayed ])[ _,(_?( (NumericQ[#] && # > 0)& )) ] | ((Verbatim[ Rule ] | Verbatim[ RuleDelayed ])[ _, ((_?( (Not[ NumericQ[#] ])& ))) ] ))... } ] ] =!= False),
Message[ shearWalls::incom, {shearWallThicknessRules -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallStartEndLengthFractionsRules, someValue_ ] := 
If[  someValue =!= Missing  &&  (Not[ MatchQ[ someValue, { ((Verbatim[ Rule ] | Verbatim[ RuleDelayed ])[ _,{(_?( ((NumericQ[#] && 0 <= # <= 1) || Not[ NumericQ[#] ])& )), (_?( ((NumericQ[#] && 0 <= # <= 1) || Not[ NumericQ[#] ])& ))} ] )... } ] ] =!= False),
Message[ shearWalls::incom, {shearWallStartEndLengthFractionsRules -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallBaseLength, someValue_ ] := 
If[  If[ NumericQ[ someValue ] &&  someValue <= 0 === True, True, False ],
Message[ shearWalls::incom, {shearWallBaseLength -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallShearModulus, someValue_ ] := 
If[  If[ NumericQ[ someValue ] &&  someValue <= 0 === True, True, False ],
Message[ shearWalls::incom, {shearWallShearModulus -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallYoungsModulus, someValue_ ] := 
If[  If[ NumericQ[ someValue ] &&  someValue <= 0 === True, True, False ],
Message[ shearWalls::incom, {shearWallYoungsModulus -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallIncludeWhatStiffness, someValue_ ] := 
If[  MatchQ[ someValue, shearWallIncludeShearTypeOnly | shearWallIncludeBendingTypeOnly | shearWallIncludeShearAndBendingTypes] =!= True,
Message[ shearWalls::incom, {shearWallIncludeWhatStiffness -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallBaseStartCoordinates, someValue_ ] := 
If[  someValue =!= Missing  && Not[ MatchQ[ someValue, {_, _} ] ],
Message[ shearWalls::incom, {shearWallBaseStartCoordinates -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallBaseEndCoordinates, someValue_ ] := 
If[  someValue =!= Missing  && Not[ MatchQ[ someValue, {_, _} ] ],
Message[ shearWalls::incom, {shearWallBaseEndCoordinates -> someValue} ]; False, 
True ]


shearWallCheck[ shearWallUnitVectorAlongWall, someValue_ ] := 
If[  someValue =!= Missing  && Not[ MatchQ[ someValue, {_, _} ] ],
Message[ shearWalls::incom, {shearWallUnitVectorAlongWall -> someValue} ]; False, 
True ]


shearWallCheck[ a_ /; Not[ MemberQ[shearWallKeysList,a ] ], someValue_ ] := 
(
Message[ shearWalls::noMem, shearWall, a ];
False
)


(* ::Subsection::Closed:: *)
(*shearWall: Getting*)


shearWallGet[ a_shearWall, whatToGet_ /;  MemberQ[DeleteCases[shearWallKeysGetList,shearWallBaseLength | shearWallUnitVectorAlongWall | shearWallStartEndLengthFractionsAtFloor | shearWallStartCoordinatesAtFloor | shearWallEndCoordinatesAtFloor | shearWallExistsQ  ] ,whatToGet ] ] := wallDataMaster[ a[[ 1  ]] ][  whatToGet ] /; shearWallGet[ a, shearWallExistsQ ]


shearWallGet[ a_shearWall, shearWallExistsQ ] := (wallDataMaster[ a[[ 1  ]] ][ shearWallExistsQ ] === True)



shearWallGet[ a_shearWall, shearWallBaseLength ] := Module[ {xs, ys, xe, ye},
{xs, ys} = shearWallGet[ a, shearWallBaseStartCoordinates ];
{xe, ye } = shearWallGet[ a, shearWallBaseEndCoordinates ];

Sqrt[(xe - xs)^2 + (ye-ys)^2] 
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallGet[ a_shearWall, shearWallLengthAtFloor, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := 
Module[ {sS, sE},
{sS, sE} = floorNumber /. Flatten[ Join[ shearWallGet[ a,  shearWallStartEndLengthFractionsRules ], {_Integer-> {0, 1} } ] ];

Abs[ (sE - sS)  ] * shearWallGet[ a, shearWallBaseLength ]
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallGet[ a_shearWall, shearWallThicknessAtFloor, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := 
Module[ {th},
th = floorNumber /. Flatten[ Join[ shearWallGet[ a,  shearWallThicknessRules ], {_Integer-> Missing } ] ];

th
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallGet[ a_shearWall, shearWallUnitVectorAlongWall ] := ((shearWallGet[ a, shearWallBaseEndCoordinates ] - shearWallGet[ a, shearWallBaseStartCoordinates ]) /  shearWallGet[ a, shearWallBaseLength ])/; shearWallGet[ a, shearWallExistsQ ]


shearWallGet[ a_shearWall, shearWallStartEndLengthFractionsAtFloor, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := 
floorNumber /. Flatten[ Join[ {wallDataMaster[ a[[ 1  ]] ][  shearWallStartEndLengthFractionsRules ]}, { _Integer -> {0, 1} } ] ]


shearWallGet[ a_shearWall, shearWallStartCoordinatesAtFloor, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] :=
shearWallBaseStartCoordinates[ a ] +  shearWallStartEndLengthFractionsAtFloor[ a, floorNumber ][[1]] * shearWallUnitVectorAlongWall[ a ] * shearWallBaseLength[ a ]


shearWallGet[ a_shearWall, shearWallEndCoordinatesAtFloor, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] :=
shearWallBaseStartCoordinates[ a ] +  shearWallStartEndLengthFractionsAtFloor[ a, floorNumber ][[2]] * shearWallUnitVectorAlongWall[ a ] * shearWallBaseLength[ a ]


shearWallBaseStartCoordinates[ a_shearWall ] := shearWallGet[ a, shearWallBaseStartCoordinates ]
shearWallBaseEndCoordinates[ a_shearWall ] := shearWallGet[ a, shearWallBaseEndCoordinates ]
shearWallIncludeWhatStiffness[ a_shearWall ] := shearWallGet[ a, shearWallIncludeWhatStiffness ]
shearWallBaseLength[ a_shearWall ] := shearWallGet[ a, shearWallBaseLength ]
shearWallUnitVectorAlongWall[ a_shearWall ] := shearWallGet[ a, shearWallUnitVectorAlongWall ]
shearWallThicknessRules[ a_shearWall ] := shearWallGet[ a, shearWallThicknessRules ]
shearWallStartEndLengthFractionsRules[ a_shearWall ] := shearWallGet[ a, shearWallStartEndLengthFractionsRules ]
shearWallShearModulus[ a_shearWall ] := shearWallGet[ a, shearWallShearModulus ]
shearWallYoungsModulus[ a_shearWall ] := shearWallGet[ a, shearWallYoungsModulus ]
shearWallExistsQ[ a_shearWall ] := shearWallGet[ a, shearWallExistsQ ]


shearWallSpecificGravity[ a_shearWall ] := shearWallGet[ a, shearWallSpecificGravity ]
shearWallIncludeMassQ[ a_shearWall ] := shearWallGet[ a, shearWallIncludeMassQ ]


shearWallLengthAtFloor[ a_shearWall, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := shearWallGet[ a, shearWallLengthAtFloor, floorNumber ]
shearWallThicknessAtFloor[ a_shearWall, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := shearWallGet[ a, shearWallThicknessAtFloor, floorNumber ]


shearWallStartEndLengthFractionsAtFloor[ a_shearWall, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := shearWallGet[ a, shearWallStartEndLengthFractionsAtFloor, floorNumber ]
shearWallStartCoordinatesAtFloor[ a_shearWall, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := shearWallGet[ a, shearWallStartCoordinatesAtFloor, floorNumber ]
shearWallEndCoordinatesAtFloor[ a_shearWall, floorNumber_?( (IntegerQ[#] && # >= 1)& ) ] := shearWallGet[ a, shearWallEndCoordinatesAtFloor, floorNumber ]


shearWallGet[ a_shearWall, whatToGet_ /;  Not[ MemberQ[ shearWallKeysGetList,whatToGet ] ] ] := 
(Message[ shearWalls::noMem, a, whatToGet ]; $Failed)


(* ::Subsection::Closed:: *)
(*shearWall: Putting*)


shearWallPut[ a_shearWall, whatToPut_ /;  MemberQ[DeleteCases[shearWallKeysPutList,shearWallBaseLength | shearWallUnitVectorAlongWall  ] ,whatToPut ], value_ ] := 
If[ shearWallCheck[ whatToPut, value ] === True,
(wallDataMaster[ a[[1]] ][ whatToPut ] = value),
$Failed
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallPut[ a_shearWall, shearWallBaseLength, value_ ] := 
If[ shearWallCheck[ shearWallBaseLength, value ] === True,
With[ {s = shearWallGet[ a, shearWallBaseStartCoordinates ], t = Simplify[ Normalize[ (shearWallGet[ a, shearWallBaseEndCoordinates ] // Chop) - (shearWallGet[ a, shearWallBaseStartCoordinates ] // Chop) ] ]},
shearWallPut[ a, shearWallBaseEndCoordinates, Chop[ s ] +Chop[ t ] *Chop[ value ] ];
value
],
$Failed
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallPut[ a_shearWall, shearWallUnitVectorAlongWall, value_ ] := 
If[ shearWallCheck[ shearWallUnitVectorAlongWall, value ] === True,
With[ {s = shearWallGet[ a, shearWallBaseStartCoordinates ], L = shearWallGet[ a, shearWallBaseLength ]},
shearWallPut[ a, shearWallBaseEndCoordinates, s +  Normalize[ value ] * L];
value
],
$Failed
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallPut[ a_shearWall, whatToPut_ /;  Not[ MemberQ[shearWallKeysPutList ,whatToPut ] ], value___ ] := (Message[ shearWalls::noMem, shearWall, whatToPut ]; $Failed);


(* ::Subsection:: *)
(*---------------------     shearWall:  CALCULATIONS   ------------------------------*)


(* ::Subsection::Closed:: *)
(*shearWall:  length, thickness and centroid lists*)


shearWallLengthList[ a_shearWall, numberOfFloors_?(( IntegerQ[ # ] && # >= 1 )&) ] := Table[ shearWallLengthAtFloor[ a, floorNumber ], {floorNumber, 1, numberOfFloors} ]


shearWallThicknessList[ a_shearWall, numberOfFloors_?(( IntegerQ[ # ] && # >= 1 )&) ] := Table[ shearWallThicknessAtFloor[ a, floorNumber ], {floorNumber, 1, numberOfFloors} ]


shearWallCentroidList[ a_shearWall, numberOfFloors_?(( IntegerQ[ # ] && # >= 1 )&) ] := 
Table[ (1/2) (shearWallStartCoordinatesAtFloor[ a, floorNumber ] + shearWallEndCoordinatesAtFloor[ a, floorNumber ]), {floorNumber, 1, numberOfFloors} ]


shearWallCenterOfMassLumpedList[ a_shearWall, heightList_ ] := 
Module[ { numberOfFloors, massList, centroidList, centerOfMassList },

numberOfFloors = Length[ heightList ];
If[ Not[ IntegerQ[numberOfFloors ] ] || numberOfFloors < 1,
Message[shearWalls::numberOfFloorsInvalid, numberOfFloors];
Return[ $Failed ];
];
massList = shearWallMassList[ a, heightList ] // N;
centroidList = shearWallCentroidList[ a, numberOfFloors ] // N;
centerOfMassList = ConstantArray[ 0, {numberOfFloors} ] // N;

(*** Case of 1 floor only is special ***)
If[ numberOfFloors === 1,
centerOfMassList[[1]] = centroidList[[1]];
Return[  centerOfMassList ];
];

(*** First floor is special ***)
centerOfMassList[[1]] = (massList[[1]] * centroidList[[1]] + (1/2) * massList[[2]] * centroidList[[2]]) / (massList[[1]] + (1/2) * massList[[2]]);

(*** Last floor is special ***)
centerOfMassList[[-1]] = centroidList[[-1]];

Do[
centerOfMassList[[floorNumber]] = (massList[[floorNumber]] * centroidList[[floorNumber]] +  massList[[floorNumber + 1]] * centroidList[[floorNumber + 1]]) / (massList[[floorNumber]] +  massList[[floorNumber + 1]]),  (*** There's a 1/2 factor that cancels top and bottom ***)
{floorNumber, 2, numberOfFloors - 1}
];

centerOfMassList // N
]


(* ::Subsection::Closed:: *)
(*shearWall: getting mass, moment of inertia, ...*)


shearWallMassList[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassList ] ] := 
Module[ {numberOfFloors, sg, thicknessList, lengthList},
numberOfFloors = Length[ heightList ];

If[ Not[ IntegerQ[numberOfFloors ] ] || numberOfFloors < 1,
Message[shearWalls::numberOfFloorsInvalid, numberOfFloors];
Return[ $Failed ];
];
lengthList = shearWallLengthList[ a, numberOfFloors ];
thicknessList = shearWallThicknessList[ a, numberOfFloors ];
sg = shearWallSpecificGravity[ a ];

Table[ sg *  $densityOfWater * lengthList[[ floorNumber ]] * thicknessList[[ floorNumber ]] * heightList[[ floorNumber ]],
{floorNumber, 1, numberOfFloors} ]
]


shearWallMassLumpedList[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassLumpedList ] ] := 
Module[ {numberOfFloors, wallMassList, extendedOptions, lumpedMassList},

numberOfFloors = Length[ heightList ];
extendedOptions = Flatten[ Join[ {someOptions}, Options[ shearWallMassLumpedList ] ] ];
wallMassList = shearWallMassList[ a, heightList,  FilterRules[extendedOptions, Options[ shearWallMassLumpedList ] ] ];
lumpedMassList = ConstantArray[ 0, {numberOfFloors} ];

Do[
(
lumpedMassList[[ floorNumber ]] +=  (1/2) ( wallMassList[[ floorNumber ]] + wallMassList[[ floorNumber+1 ]]);
),
{floorNumber, 1, numberOfFloors - 1}
];

(*** first floor special ***)
lumpedMassList[[ 1 ]] +=  (1/2) ( wallMassList[[ 1 ]]);

(*** last floor special ***)
lumpedMassList[[ numberOfFloors ]] +=  (1/2) ( wallMassList[[ numberOfFloors ]]);

lumpedMassList
]


shearWallMassTotal[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassTotal ] ] := 
Total[ shearWallMassList[ a, heightList,someOptions   ] ]


shearWallMassPolarMomentOfInertiaList[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassPolarMomentOfInertiaList ] ] := 
Module[ {numberOfFloors, sg, thicknessList, coorStartList, coorEndList, wallCentersList, rotationCenterRules, rotationCentersList,
explicitCenterOfRotationRules },


numberOfFloors = Length[ heightList ];

If[ Not[ IntegerQ[numberOfFloors ] ] || numberOfFloors < 1,
Message[shearWalls::numberOfFloorsInvalid, numberOfFloors];
Return[ $Failed ];
];
thicknessList = shearWallThicknessList[ a, numberOfFloors ];
sg = shearWallSpecificGravity[ a ];
coorStartList = Table[ shearWallStartCoordinatesAtFloor[ a, floorNumber ],{floorNumber, 1, numberOfFloors} ];
coorEndList = Table[ shearWallEndCoordinatesAtFloor[ a, floorNumber ],{floorNumber, 1, numberOfFloors} ];
rotationCenterRules = OptionValue[ shearWallCenterOfRotationRules ];
rotationCentersList = internalWallGetExplicitCenterOfRotationList[ a, numberOfFloors, rotationCenterRules ];

sg *  $densityOfWater * Table[ internalWallMOI[ coorStartList[[ floorNumber ]], coorEndList[[ floorNumber ]], thicknessList[[ floorNumber ]], rotationCentersList[[ floorNumber ]]  ], {floorNumber, 1, numberOfFloors} ]
]


shearWallMassLumpedPolarMomentOfInertiaList[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassPolarMomentOfInertiaList ] ] := 
Module[ {numberOfFloors, wallMassMOIList, extendedOptions, lumpedMassMOIList},

numberOfFloors = Length[ heightList ];
extendedOptions = Flatten[ Join[ {someOptions}, Options[ shearWallMassLumpedList ] ] ];
wallMassMOIList = shearWallMassPolarMomentOfInertiaList[ a, heightList,  FilterRules[extendedOptions, Options[ shearWallMassPolarMomentOfInertiaList ] ] ];
lumpedMassMOIList = ConstantArray[ 0, {numberOfFloors} ];

Do[
(
lumpedMassMOIList[[ floorNumber ]] +=  (1/2) ( wallMassMOIList[[ floorNumber ]] + wallMassMOIList[[ floorNumber+1 ]]);
),
{floorNumber, 1, numberOfFloors - 1}
];

(*** first floor special ***)
lumpedMassMOIList[[ 1 ]] +=  (1/2) ( wallMassMOIList[[ 1 ]]);

(*** last floor special ***)
lumpedMassMOIList[[ numberOfFloors ]] +=  (1/2) ( wallMassMOIList[[ numberOfFloors ]]);

lumpedMassMOIList
]


shearWallMassPolarMomentOfInertiaTotal[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassPolarMomentOfInertiaTotal ] ] := 
Total[ shearWallMassPolarMomentOfInertiaList[ a, heightList,someOptions   ] ]


internalWallMOI[ {xs_, ys_}, {xe_, ye_}, th_, {xc_, yc_} ] := 1/12 (Abs[1/Sqrt[(xe-xs)^2+(ye-ys)^2] th (4 xe^4-4 xe^3 xs+4 xs^4+th^2 ye^2+4 xs^2 ye^2-4 xe xs (xs^2-(ye-ys)^2)+12 xc^2 (xe^2-2 xe xs+xs^2+(ye-ys)^2)-12 xc (xe+xs) (xe^2-2 xe xs+xs^2+(ye-ys)^2)+4 xe^2 (ye-ys)^2-2 th^2 ye ys-8 xs^2 ye ys+th^2 ys^2+4 xs^2 ys^2)]+Abs[(th (th^2 (xe-xs)^2+4 (xe^2-2 xe xs+xs^2+(ye-ys)^2) (3 yc^2+ye^2+ye ys+ys^2-3 yc (ye+ys))))/Sqrt[(xe-xs)^2+(ye-ys)^2]])


internalWallGetExplicitCenterOfRotationList[ a_shearWall, numberOfFloors_, rotationCenterRules_ ] := 
Module[ {coorStartList, coorEndList, wallCentersList, rotationCentersList},

coorStartList = Table[ shearWallStartCoordinatesAtFloor[ a, floorNumber ],{floorNumber, 1, numberOfFloors} ];
coorEndList = Table[ shearWallEndCoordinatesAtFloor[ a, floorNumber ],{floorNumber, 1, numberOfFloors} ];

wallCentersList = Table[ (1/2) * (coorStartList[[floorNumber]] + coorEndList[[floorNumber]]), {floorNumber, 1, numberOfFloors} ];

Which[ 
rotationCenterRules === Automatic || Not[ MatchQ[ rotationCenterRules, { (Verbatim[ Rule ] | Verbatim[ RuleDelayed ])[ _, _ ] ... } ] ],
		rotationCentersList = Table[ wallCentersList[[1]], {numberOfFloors}],
True,
		rotationCentersList = Table[ floorNumber /. Join[ Flatten[ {rotationCenterRules} ], {_Integer -> wallCentersList[[ floorNumber ]] } ], {floorNumber, 1, numberOfFloors} ]
 ];
Do[ rotationCentersList[[ floorNumber ]] = If[ rotationCentersList[[ floorNumber ]] === Automatic, wallCentersList[[ floorNumber ]], 
rotationCentersList[[ floorNumber ]] ], {floorNumber, 1, numberOfFloors} ];

rotationCentersList
]


(* ::Subsection::Closed:: *)
(*shearWall: wall mass matrix*)


shearWallMassMatrix[ a_shearWall, heightList_,someOptions:OptionsPattern[ shearWallMassMatrix ] ] := 
Module[ {numberOfFloors, extendedOptions, massLumpedList, massLumpedMOIList, rotationCenterRules, rotationCentersList,
useConsistentMatrixQ,wallMassMatrix, dofOrdering ,
massList, massMOIList },

numberOfFloors = Length[ heightList ];
If[ Not[ IntegerQ[numberOfFloors ] ] || numberOfFloors < 1,
Message[shearWalls::numberOfFloorsInvalid, numberOfFloors];
Return[ $Failed ];
];

extendedOptions = Flatten[ Join[ {someOptions}, Options[ shearWallMassMatrix ] ] ];
massLumpedList = shearWallMassLumpedList[ a, heightList,FilterRules[ extendedOptions, Options[  shearWallMassLumpedList ] ] ];
massList = shearWallMassList[ a, heightList,FilterRules[ extendedOptions, Options[  shearWallMassList ] ] ];

rotationCenterRules = OptionValue[ shearWallCenterOfRotationRules ];
rotationCentersList = internalWallGetExplicitCenterOfRotationList[ a, numberOfFloors, rotationCenterRules ];

(*** Appropriate center of rotation rules should be assigned at building level ****)
massLumpedMOIList = shearWallMassLumpedPolarMomentOfInertiaList[ a, heightList,FilterRules[ extendedOptions, Options[  shearWallMassLumpedPolarMomentOfInertiaList ] ] ];
massMOIList = shearWallMassPolarMomentOfInertiaList[ a, heightList,FilterRules[ extendedOptions, Options[  shearWallMassPolarMomentOfInertiaList ] ] ];

dofOrdering = OptionValue[ shearWallDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods};

(**** Do floor ordering then switch depending on desired ordering ****)
wallMassMatrix = SparseArray[ {}, {3 * numberOfFloors, 3 * numberOfFloors}, 0 ];
(*** lumped mass matrix ***)
Do[
(
wallMassMatrix[[ 3 * (floorNumber - 1) + 1, 3 * (floorNumber - 1) + 1 ]] +=  massLumpedList[[ floorNumber ]];
wallMassMatrix[[ 3 * (floorNumber - 1) + 2, 3 * (floorNumber - 1) + 2 ]] +=  massLumpedList[[ floorNumber ]];
wallMassMatrix[[ 3 * (floorNumber - 1) + 3, 3 * (floorNumber - 1) + 3 ]] +=  massLumpedMOIList[[ floorNumber ]];
),
{floorNumber, 1, numberOfFloors}
];

Switch[ dofOrdering,
"floor" | "Floor", wallMassMatrix,
"building" | "Building", With[ {ord =  Join[ Range[ 1,3 * numberOfFloors, 3 ], Range[ 2,3 * numberOfFloors, 3 ], Range[ 3,3 * numberOfFloors, 3 ] ]}, wallMassMatrix[[ ord, ord ]] ],
_, Message[ shearWalls::unknwnord, OptionValue[ shearWallDOFOrdering ] ]; $Failed
]

]


(* ::Subsection::Closed:: *)
(*shearWall: (Internal methods):  section stiffness, dof to tangential displacement, reduced stiffness in local, etc*)


(* ::Subsubsection:: *)
(*----- stiffness calculations -------*)


(* ::Subsubsection::Closed:: *)
(*stiffness relating tangent-wall displacements only to tangent-wall slab-forces only -  reduced stiffness*)


(* ::Text:: *)
(*This gives the stiffness relating tangential-displacements  at each node-floor to the tangential-force  at the node-floor.*)
(*The ordering of the displacements-rotations are {ux1, ux2, ...} where 1, 2, ... are the floor numbers and 1 denotes the first floor (0 is the ground).*)


internalShearWallFreeFreeAllWallLocalReducedStiffness::usage = "internalShearWallFreeFreeAllWallLocalReducedStiffness[ a_shearWall, heightList, wallWhatTypeStiffness ] This gives the stiffness relating tangential-displacements  at each node-floor to the tangential-force  at the node-floor.  The ordering of the displacements-rotations are {ux1, ux2, ...} where 1, 2, ... are the floor numbers and 1 denotes the first floor (0 is the ground).";


internalShearWallFreeFreeAllWallLocalReducedStiffness[ a_shearWall, heightList_ ] := 
Module[ {wallWhatTypeStiffness, Kb, Ks, Kres},
wallWhatTypeStiffness = shearWallIncludeWhatStiffness[ a ];

internalShearWallFreeFreeAllWallLocalReducedStiffness[ a, heightList, wallWhatTypeStiffness  ]
]


internalShearWallFreeFreeAllWallLocalReducedStiffness[ a_shearWall, heightList_, shearWallIncludeShearAndBendingTypes ] := 
Module[ {Kb, Ks, Kres},

Kb = internalShearWallFreeFreeAllWallLocalReducedStiffness[ a, heightList, shearWallIncludeBendingTypeOnly  ];
Ks = internalShearWallFreeFreeAllWallLocalReducedStiffness[ a, heightList, shearWallIncludeShearTypeOnly  ];
Kres = Ks . Inverse[ ( IdentityMatrix[ Length[ Ks ] ] + Inverse[ Kb ] . Ks ) ];

Kres
]


internalShearWallFreeFreeAllWallLocalReducedStiffness[ a_shearWall, heightList_, wallWhatTypeStiffness:( shearWallIncludeBendingTypeOnly | shearWallIncludeShearTypeOnly ) ] := 
Module[ {numberOfFloors, arraySize, fullStiffnessMatrix, reducedStiffnessMatrix, Kuu, Ku\[Theta], K\[Theta]u, K\[Theta]\[Theta]},
numberOfFloors = Length[ heightList ];
arraySize = 2 * numberOfFloors;
(** remove the ground dof contributions **)
fullStiffnessMatrix = internalShearWallFreeFreeAllWallLocalFullStiffness[ a, heightList, wallWhatTypeStiffness  ][[ 3;;-1, 3;;-1]];
fullStiffnessMatrix = fullStiffnessMatrix[[ Join[ 2 Range[ numberOfFloors ] - 1, 2 Range[ numberOfFloors ] ], Join[ 2 Range[ numberOfFloors ] - 1, 2 Range[ numberOfFloors ] ] ]];
Kuu =  fullStiffnessMatrix[[ 1;;numberOfFloors, 1;;numberOfFloors ]];
Ku\[Theta] =  fullStiffnessMatrix[[ 1;;numberOfFloors, (numberOfFloors+1);;2numberOfFloors]];
K\[Theta]u =  fullStiffnessMatrix[[ (numberOfFloors+1);;2numberOfFloors,  1;;numberOfFloors ]];
K\[Theta]\[Theta] =  fullStiffnessMatrix[[ (numberOfFloors+1);;2numberOfFloors, (numberOfFloors+1);;2numberOfFloors ]];

reducedStiffnessMatrix = Kuu - Ku\[Theta].Inverse[ K\[Theta]\[Theta] ].K\[Theta]u;

reducedStiffnessMatrix
]


Global`$outReducedStiffness = internalShearWallFreeFreeAllWallLocalReducedStiffness;


(* ::Subsubsection::Closed:: *)
(*stiffness relating tangent-wall displacements and rotations to tangent-wall slab-forces and slab-moments (should be zero if pinned)*)


(* ::Text:: *)
(*This gives the stiffness relating tangential-displacements and rotations at each node-floor to the tangential-force and moment at the node-floor.*)
(*The ordering of the displacements-rotations are {ux0, \[Theta]0, ux1, \[Theta]1, ux2, \[Theta]2, ...} where 0, 1, 2, ... are the floor numbers and 0 denotes the ground.*)


internalShearWallFreeFreeAllWallLocalFullStiffness::usage = "internalShearWallFreeFreeAllWallLocalFullStiffness[ a_shearWall, heightList, wallWhatTypeStiffness ] This gives the stiffness relating tangential-displacements and rotations at each node-floor to the tangential-force and moment at the node-floor.  The ordering of the displacements-rotations are {ux0, \[Theta]0, ux1, \[Theta]1, ux2, \[Theta]2, ...} where 0, 1, 2, ... are the floor numbers and 0 denotes the ground.";


internalShearWallFreeFreeAllWallLocalFullStiffness[ a_shearWall, heightList_, wallWhatTypeStiffness_ ] := 
Module[ {numberOfFloors, arraySize, stiffnessMatrix},
numberOfFloors = Length[ heightList ];
arraySize = 2 * (numberOfFloors + 1);
stiffnessMatrix = SparseArray[{}, {arraySize, arraySize}, 0 ];
Do[
stiffnessMatrix[[ (2 * (floorLevel -1) + 1) ;; (2 * (floorLevel - 1) + 4), (2 * (floorLevel -1) + 1) ;; (2 * (floorLevel - 1) + 4) ]]+= internalShearWallFloorStiffness[ a, heightList, floorLevel, wallWhatTypeStiffness ],
{floorLevel, 1, numberOfFloors}
];
stiffnessMatrix
]


Global`$outFreeFreeFullStiffness = internalShearWallFreeFreeAllWallLocalFullStiffness;


(* ::Subsubsection::Closed:: *)
(*stiffness:  single floors shear wall stiffness*)


$shearCorrectionFactor = 1.2;


internalShearWallFloorStiffness::usage = "internalShearWallFloorStiffness[ a_shearWall, heightList, floorLevel, wallWhatTypeStiffness ] ...";


internalShearWallFloorStiffness[ a_shearWall, heightList_, floorLevel_, wallWhatTypeStiffness_ ] := 
Module[  { youngsModulus, shearModulus, L, h, t, Iinertia, AatFloor, EI, GAs,
KBending, KShear, KCombo, Kresult },

youngsModulus = shearWallGet[ a, shearWallYoungsModulus ] * 10^9;
shearModulus = shearWallGet[ a, shearWallShearModulus ] * 10^9;
L = shearWallLengthAtFloor[ a, floorLevel ];
t = shearWallThicknessAtFloor[ a, floorLevel ];
h = heightList[[ floorLevel ]];
Iinertia = t L^3 / 12;
AatFloor = t L;
EI = youngsModulus * Iinertia;
GAs = shearModulus * AatFloor / $shearCorrectionFactor;
KBending = { {12 EI / h^3, - 6 EI / h^2, -12 EI / h^3, - 6 EI / h^2},
{- 6 EI / h^2, 4 EI / h, 6 EI / h^2, 2 EI / h},
{-12 EI / h^3, 6 EI / h^2, 12 EI / h^3, 6 EI / h^2},
{-6 EI / h^2, 2 EI / h, 6 EI / h^2, 4 EI / h}  };
KShear = {
{GAs / h, - GAs / 2, - GAs/h, - GAs / 2},
{- GAs / 2, GAs h / 3, GAs / 2, GAs h / 6},
{- GAs/h, GAs / 2, GAs/h, GAs/2},
{- GAs/2, GAs h / 6, GAs / 2, GAs h / 3}
}; (*** NOT USED - ALTERNATIVE SHEAR STIFFNESS ****)
KShear = {
{GAs / h, 0, - GAs/h, 0},
{0, GAs h / 4, 0, GAs h / 4},
{- GAs/h, 0, GAs/h, 0},
{0, GAs h / 4, 0, GAs h / 4}
};

Kresult =  Which[
wallWhatTypeStiffness === shearWallIncludeBendingTypeOnly,KBending,
wallWhatTypeStiffness === shearWallIncludeShearTypeOnly, KShear,
True, Return[ $Failed ]
];

Kresult
]


Global`$outShearWallFloorStiffness = internalShearWallFloorStiffness;


(* ::Subsubsection:: *)
(*-----  slab to wall dof and force transformation -------*)


(* ::Subsubsection::Closed:: *)
(*matrix relating slab motion to slab static equivalent force transformation except for stiffness factor*)


internalShearWallMatrixFactorsForSlabMotionToSlabForce[ a_shearWall, centerOfRotationOfForce_, centerOfRotationOfMotion_ ] := 
Outer[ Times, internalShearWallVectorSlabToWall[ a, centerOfRotationOfForce ], internalShearWallVectorSlabToWall[ a, centerOfRotationOfMotion ] ]


(* ::Subsubsection::Closed:: *)
(*vector relating slab motion to wall tangential displacement (by dot product) or wall force to slab static equivalent (by multiplying)*)


internalShearWallVectorSlabToWall::usage = "internalShearWallVectorSlabToWall[ a_shearWall, centerOfRotation ] ...";


internalShearWallVectorSlabToWall[ a_shearWall, centerOfRotation_ ] := 
Module[ {tx, ty, \[CapitalDelta]rx, \[CapitalDelta]ry},
{\[CapitalDelta]rx, \[CapitalDelta]ry} = shearWallBaseStartCoordinates[ a ] - centerOfRotation;
{tx, ty} = shearWallUnitVectorAlongWall[ a ];
{tx, ty, - \[CapitalDelta]ry * tx + \[CapitalDelta]rx ty}
]


Global`$outShearWallVectorSlabToWall = internalShearWallVectorSlabToWall;


(* ::Subsubsection::Closed:: *)
(*slab dof to wall tangential displacement*)


internalShearWallSlabToTangentialDisplacement::usage = "internalShearWallSlabToTangentialDisplacement[ a_shearWall, {usx, usy, \[Theta]s}, centerOfRotation ] ...";


internalShearWallSlabToTangentialDisplacement[ a_shearWall, {usx_, usy_, \[Theta]s_}, centerOfRotation_ ] := 
internalShearWallVectorSlabToWall[ a, centerOfRotation ].{usx, usy, \[Theta]s}


(* ::Subsubsection::Closed:: *)
(*wall force to slab static equivalent - returns a vector { fx, fy, Torque }*)


internalShearWallWallTangentialForceToSlabStaticEquivalent::usage = "internalShearWallWallTangentialForceToSlabStaticEquivalent[ a_shearWall, fw, centerOfRotation ] ...";


internalShearWallWallTangentialForceToSlabStaticEquivalent[ a_shearWall, fw_, centerOfRotation_ ] := 
internalShearWallVectorSlabToWall[ a, centerOfRotation ] * fw


(* ::Subsection::Closed:: *)
(*shearWall: Getting displacement magnitudes along the wall*)


shearWallDisplacementMagnitudesAlongWall[ a_shearWall, dofListIn_, OptionsPattern[ shearWallDisplacementMagnitudesAlongWall ] ] := 
Module[ {numberOfFloors, dofOrdering, centerOfRotations, dofList, dofArray},

dofList= dofListIn /. {Automatic -> {}, None -> {} };
If[ Head[ dofList ] =!= List, dofList = {} ];
If[ Mod[Length[ dofList  ],3] =!= 0,
(
Message[ shearWalls::dofMustMult3, dofList ];
Return[ $Failed ]
)
];
numberOfFloors = Length[ dofList ] /3;
dofOrdering = OptionValue[ shearWallDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods};
If[ Not[ MatchQ[ dofOrdering, "building" | "Building" | "floor" | "Floor" ] ], dofOrdering = $defaultDOFOrderingForAllMethods ];

centerOfRotations = With[ {theCenterRules = Join[ (OptionValue[ shearWallCenterOfRotationRules ] /. (Automatic | None  ) -> ({_Integer -> {0, 0}}) ), {_Integer -> {0, 0}} ]}, 
Table[ floorNumber /. theCenterRules, {floorNumber, 1, numberOfFloors} ]
];

(*** make sure that the dofs are floor ordered ***)
Switch[ dofOrdering,
"floor" | "Floor", True,
"building" | "Building", dofList =  internalBuildingToFloor[ dofList ],
_, Return[ $Failed ]
];
dofArray = Partition[dofList, 3, 3 ];

Table[
internalShearWallSlabToTangentialDisplacement[ a, dofArray[[ floorNumber ]], centerOfRotations[[ floorNumber ]] ],
{floorNumber, 1, numberOfFloors}
]
] /; shearWallGet[ a, shearWallExistsQ ]


shearWallDisplacementMagnitudesAlongWall[ a_shearWall, dofListIn_, heightList_, someOptions:OptionsPattern[ shearWallDisplacementMagnitudesAlongWall ] ] := 
shearWallDisplacementMagnitudesAlongWall[ a, dofListIn, someOptions ]


(* ::Subsection::Closed:: *)
(*shearWall: Getting shear force magnitudes along the wall*)


shearWallShearForcesAlongWall[ a_shearWall, dofListIn_, heightList_,someOptions:OptionsPattern[ shearWallShearForcesAlongWall ] ] := 
Module[ { tangentialWallDisplacements, kReduced, nodalForces, dofList, dofOrdering, numberOfFloors },

dofList= dofListIn /. {Automatic -> {}, None -> {} };
If[ Head[ dofList ] =!= List, dofList = {} ];
If[ Mod[Length[ dofList  ],3] =!= 0,
(
Message[ shearWalls::dofMustMult3, dofList ];
Return[ $Failed ]
)
];

numberOfFloors = Length[ dofList ] /3;
If[ numberOfFloors =!= Length[ heightList ],
(
Message[ shearWalls::hMustSameDof, heightList, dofListIn ];
Return[ $Failed ]
)
];

(*** make sure that the dofs are floor ordered ***)
dofOrdering = OptionValue[ shearWallDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods};
If[ Not[ MatchQ[ dofOrdering, "building" | "Building" | "floor" | "Floor" ] ], dofOrdering = $defaultDOFOrderingForAllMethods ];
Switch[ dofOrdering,
"floor" | "Floor", True,
"building" | "Building", dofList =  internalBuildingToFloor[ dofList ],
_, Return[ $Failed ]
];

tangentialWallDisplacements = shearWallDisplacementMagnitudesAlongWall[ a, dofList, 
shearWallDOFOrdering -> "floor",
FilterRules[Flatten[ Join[ {someOptions}, Options[shearWallShearForcesAlongWall] ] ],Options[ shearWallDisplacementMagnitudesAlongWall]] ];
If[  tangentialWallDisplacements === $Failed,
Return[ $Failed ]
];

kReduced = internalShearWallFreeFreeAllWallLocalReducedStiffness[ a, heightList  ];

nodalForces = kReduced . tangentialWallDisplacements;

Reverse[ Accumulate[ Reverse[ nodalForces ] ] ]
] /; shearWallGet[ a, shearWallExistsQ ]


(* ::Subsection::Closed:: *)
(*shearWall: Getting bending moment magnitudes along the wall*)


shearWallBendingMomentPairs[ a_shearWall, dofListIn_, heightList_,someOptions:OptionsPattern[ shearWallBendingMomentPairs ] ] := 
Module[ {shearForces, deltaMoments},

shearForces = shearWallShearForcesAlongWall[ a, dofListIn, heightList,
FilterRules[Flatten[ Join[ {someOptions}, Options[ shearWallBendingMomentPairs ] ] ],Options[ shearWallShearForcesAlongWall ]]];

deltaMoments = shearForces * heightList;

Reverse[ Map[ Reverse, Partition[ Accumulate[ Prepend[ Reverse[ deltaMoments ], 0 ] ], 2, 1 ] ] ]
]


(* ::Subsection::Closed:: *)
(*shearWall: Getting shear wall stiffness*)


shearWallStiffnessMatrix[ a_shearWall, heightList_, someOptions:OptionsPattern[ shearWallStiffnessMatrix ] ] := 
Module[ { numberOfFloors, dofOrdering, centerOfRotations, wallToSlabVector, KwwReducedStiffnessMatrix, KfloorOrdering, dorOrder },

numberOfFloors = Length[ heightList ];
dofOrdering = OptionValue[ shearWallDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods};
If[ Not[ MatchQ[ dofOrdering, "building" | "Building" | "floor" | "Floor" ] ], dofOrdering = $defaultDOFOrderingForAllMethods ];

centerOfRotations = With[ {theCenterRules = Join[ (OptionValue[ shearWallCenterOfRotationRules ] /. (Automatic | None  ) -> ({_Integer -> {0, 0}}) ), {_Integer -> {0, 0}} ]}, 
Table[ floorNumber /. theCenterRules, {floorNumber, 1, numberOfFloors} ]
];

wallToSlabVector = Table[ internalShearWallVectorSlabToWall[ a, centerOfRotations[[ floorNumber ]]  ], {floorNumber, 1, numberOfFloors} ];
KwwReducedStiffnessMatrix = internalShearWallFreeFreeAllWallLocalReducedStiffness[ a, heightList ];

KfloorOrdering = ArrayFlatten[ KwwReducedStiffnessMatrix * Outer[Outer[Times,#1,#2]&,wallToSlabVector,wallToSlabVector,1]];

Switch[ dofOrdering,
"floor" | "Floor", KfloorOrdering,
"building" | "Building", With[ {ord =  Join[ Range[ 1,3 * numberOfFloors, 3 ], Range[ 2,3 * numberOfFloors, 3 ], Range[ 3,3 * numberOfFloors, 3 ] ]}, KfloorOrdering[[ ord, ord ]] ],
_, Message[ shearWalls::unknwnord, OptionValue[ shearWallDOFOrdering ] ]; $Failed
]
] /; shearWallGet[ a, shearWallExistsQ ]


(* ::Text:: *)
(*In order to relate slab motion to static equivalent of the wall on the slab then we simply substitute the relations obtained in the previous section.   This implies that every element of KRw is replaced by that element multiplied by the outer product of (  {*)
(* {Subscript[tw, x],              Subscript[tw, y],         (- Subscript[\[CapitalDelta]rw, y] Subscript[tw, x] + Subscript[\[CapitalDelta]rw, x] Subscript[tw, y]}*)
(*})   ) by itself.   If we call the global stiffness matrix of the wall to be KGw then:*)


(* ::Text:: *)
(*	KGw[[ i, j ]]  =   ({*)
(* {Subscript[tw, x]^2,             Subscript[tw, x] Subscript[tw, y],          Subscript[tw, x] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y])},*)
(* {Subscript[tw, x] Subscript[tw, y],           (Subscript[tw, y]^2),          Subscript[tw, y] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y])},*)
(* {Subscript[tw, x] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y]),         Subscript[tw, y] (Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y]),          ((Subscript[tw, y] Subscript[\[CapitalDelta]rw, x] - Subscript[tw, x] Subscript[\[CapitalDelta]rw, y])^2)}*)
(*}) KRw[[i, j ]]*)


(* ::Text:: *)
(*An example of how the matrix is setup:*)
(*someList = {{a, b, c}, {d, e, f}, {g, h, i}};*)
(*someMatrix = {{"11", "12", "13"}, {"21", "22", "23"}, {"31", "32", "33"}};*)
(*ArrayFlatten[someMatrix *  Outer[ Outer[ Times, #1, #2]&, someList, someList, 1 ] ] // MatrixForm*)


(* ::Subsection:: *)
(*---------------------     shearWall:  VIEWERS   ------------------------------*)


(* ::Subsection::Closed:: *)
(*shearWall: Drawing 2-D*)


shearWallDraw2D[ a_shearWall, OptionsPattern[ shearWallDraw2D ] ] := 
Module[ {
numberOfFloors, wallThicknessList, wallLengthList, startBaseCoordinates, endBaseCoordinates,
wallBaseLength,
theAnnotationStyleFunction, theAnnotationTextList, theAnnotationAlongNormalQ, theAnnotationDistanceFromWall, 
theAnnotationTextOrientation,theAnnotationTextOrientationList,
dsFactor, rtFactor,dofOrdering,

centerOfRotations,
dofList,dofArray,
drawType, drawDirectives, normalToWall,
xyCentroidAtFloor, xyTextAtFloor, polygonAtFloor, polygonAtFloorDisplacements, dofAtFloor, centerOfRotationAtFloor, allPolygons, xyTextList
},

numberOfFloors = OptionValue[ shearWallNumberOfFloors ] /. {Automatic -> 1, _?( (Not[ NumericQ[ # ] ] || Not[ IntegerQ[ # ] ])& ) -> 1 };
startBaseCoordinates = shearWallBaseStartCoordinates[ a ];
endBaseCoordinates = shearWallBaseEndCoordinates[ a ];
wallBaseLength = shearWallBaseLength[ a ];
wallLengthList = Table[ shearWallLengthAtFloor[ a, floorNumber ], {floorNumber, 1, numberOfFloors} ];
wallThicknessList = Table[ shearWallThicknessAtFloor[ a, floorNumber ], {floorNumber, 1, numberOfFloors} ];


theAnnotationStyleFunction = OptionValue[ shearWallAnnotateStyleFunction ] /. Automatic -> Identity;
theAnnotationTextList = OptionValue[ shearWallAnnotateTextList ] /. Automatic -> None;
If[ Head[theAnnotationTextList ] =!= List, theAnnotationTextList = None,
If[ Length[  theAnnotationTextList ] < numberOfFloors, Join[ theAnnotationTextList, Table[ "", {numberOfFloors} ] ] ] ];

theAnnotationAlongNormalQ = OptionValue[ shearWallAnnotateAlongPositiveNormalQ ] /. Automatic -> False;
theAnnotationDistanceFromWall = OptionValue[ shearWallAnnotateDistanceFromWall ] /. Automatic -> ($defaultAnnotationDistanceFromWallFraction * wallBaseLength);
theAnnotationTextOrientation = OptionValue[ shearWallAnnotateOrientation ];

dsFactor = OptionValue[ shearWallDisplacementScaleFactor ] /. Automatic -> 1;
rtFactor = OptionValue[ shearWallRotationScaleFactor ] /. Automatic -> 1;

If[ OptionValue[ shearWallShowDeformedQ ] === True,
dofList = OptionValue[ shearWallDOFList ],
dofList = ConstantArray[ 0, {3 * numberOfFloors} ]
];
If[ Head[ dofList ] =!= List || Length[ dofList ] < 3 * numberOfFloors, dofList = Join[ dofList, ConstantArray[ 0, {3 * numberOfFloors} ] ] ];

dofOrdering = OptionValue[ shearWallDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods};
If[ Not[ MatchQ[ dofOrdering, "building" | "Building" | "floor" | "Floor" ] ], dofOrdering = $defaultDOFOrderingForAllMethods ];

(*** make sure that the dofs are floor ordered ***)
Switch[ dofOrdering,
"floor" | "Floor", True,
"building" | "Building", dofList =  internalBuildingToFloor[ dofList ],
_, If[ OptionValue[ shearWallShowDeformedQ ] === True,
Message[ shearWalls::unknwnord, OptionValue[ shearWallDOFOrdering ] ]; Return[ $Failed ]
]
];
dofArray = Partition[dofList, 3, 3 ];

If[  theAnnotationTextOrientation === Automatic || Not[ MatchQ[ theAnnotationTextOrientation, {_?NumericQ, _?NumericQ} ] ],
(
theAnnotationTextOrientation = Normalize[ endBaseCoordinates - startBaseCoordinates ];
)
];
theAnnotationTextOrientationList = Table[
Module[ {\[Theta]t},
\[Theta]t = Mod[ (ArcTan @@ theAnnotationTextOrientation) + If[ OptionValue[ shearWallAnnotateOrientation ] === Automatic, (rtFactor * dofArray[[floorNumber, 3 ]]), 0 ], 2\[Pi] ];
If[(Not[ (0 <= \[Theta]t <= \[Pi]/2) ] && Not[ (3 \[Pi] / 2 <= \[Theta]t <= 2 \[Pi]) ]),
(
{Cos[\[Theta]t + \[Pi]], Sin[\[Theta]t + \[Pi]]}
),
(
{Cos[\[Theta]t ], Sin[\[Theta]t ]}
)
]], {floorNumber, 1, numberOfFloors} ];

centerOfRotations = With[ {theCenterRules = Join[ (OptionValue[ shearWallCenterOfRotationRules ] /. (Automatic | None  ) -> (_Integer -> {0, 0}) ), {_Integer -> {0, 0}} ]}, 
Table[ floorNumber /. theCenterRules, {floorNumber, 1, numberOfFloors} ]
];

drawType = OptionValue[ shearWallDrawType ] /. Automatic -> Line;
If[ Not[ MatchQ[ drawType, Line | Polygon ] ], drawType = Line ];
drawDirectives = OptionValue[ shearWallDirectives ] /. Automatic -> Directive[ Opacity[1]];

normalToWall = With[ {t = Normalize[ endBaseCoordinates - startBaseCoordinates]}, {-t[[2]], t[[1]]} ];

xyTextList = {};
allPolygons = Table[
(
With[ {s = startBaseCoordinates, e = endBaseCoordinates},
xyCentroidAtFloor = (1/2) ( s + e );
dofAtFloor = dofArray[[ floorNumber ]];
centerOfRotationAtFloor = centerOfRotations[[ floorNumber]];
xyTextAtFloor = xyCentroidAtFloor +  theAnnotationDistanceFromWall * normalToWall * If[ theAnnotationAlongNormalQ === True, 1, -1 ];
xyTextAtFloor = xyTextAtFloor + calcDisplacement[ xyTextAtFloor, {dsFactor, dsFactor, rtFactor} *dofAtFloor, centerOfRotationAtFloor ];
polygonAtFloor  = With[ {wallThickness = wallThicknessList[[floorNumber]]},
{s - normalToWall *  (wallThickness/2), s + normalToWall *  (wallThickness/2), e + normalToWall *  (wallThickness/2), e - normalToWall *  (wallThickness/2),s - normalToWall *  (wallThickness/2)} ];
];
AppendTo[xyTextList,xyTextAtFloor];
polygonAtFloorDisplacements = Table[ calcDisplacement[ coor, {dsFactor, dsFactor, rtFactor} *dofAtFloor, centerOfRotationAtFloor ], {coor, polygonAtFloor} ] ;
polygonAtFloor = polygonAtFloor + polygonAtFloorDisplacements;
polygonAtFloor
),
{floorNumber, 1, numberOfFloors}
];

Table[
{
drawDirectives,
drawType[ allPolygons[[ floorNumber ]] ],
If[ theAnnotationTextList === None,
{},
Text[ theAnnotationStyleFunction[ theAnnotationTextList[[ floorNumber ]] ], xyTextList[[ floorNumber ]],{0, 0}, theAnnotationTextOrientationList[[ floorNumber ]]  ]
]
},
{floorNumber, 1, numberOfFloors}
]
]


(* ::Subsection::Closed:: *)
(*shearWall: Drawing 3-D*)


shearWallDraw[ a_shearWall, someOptions:OptionsPattern[ shearWallDraw ] ] := graphics3DPrimitives[ a, {someOptions}] /; shearWallGet[ a, shearWallExistsQ ]


graphics3DPrimitives[ a_shearWall, OptionsPattern[ shearWallDraw ] ] := 
Module[ { heightList, numberOfFloors, wallThicknessList, wallLengthList, startBaseCoordinates, endBaseCoordinates,
wallBaseLength,

dofList,dofArray,
dsFactor, rtFactor,dofOrdering,
centerOfRotations,

zCoorList, normalToWall,
dofAtFloor, centerOfRotationAtFloor,

drawType, drawDirectives,

lowerBasePoints, upperBasePoints, cubePoints,

startCoordinates, endCoordinates, ZCoor, wallThickness, dofTriple, centerRotation, whatToDrawAtFloor
},

heightList = OptionValue[ shearWallHeightList ] /. {Automatic -> {1}};
numberOfFloors = Length[heightList ];
startBaseCoordinates = shearWallBaseStartCoordinates[ a ];
endBaseCoordinates = shearWallBaseEndCoordinates[ a ];
wallBaseLength = shearWallBaseLength[ a ];
wallLengthList = Table[ shearWallLengthAtFloor[ a, floorNumber ], {floorNumber, 1, numberOfFloors} ];
wallThicknessList = Table[ shearWallThicknessAtFloor[ a, floorNumber ], {floorNumber, 1, numberOfFloors} ];


dsFactor = OptionValue[ shearWallDisplacementScaleFactor ] /. Automatic -> 1;
rtFactor = OptionValue[ shearWallRotationScaleFactor ] /. Automatic -> 1;

If[ OptionValue[ shearWallShowDeformedQ ] === True,
dofList = OptionValue[ shearWallDOFList ],
dofList = ConstantArray[ 0, {3 * numberOfFloors} ]
];
dofOrdering = OptionValue[ shearWallDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods};
(*** make sure that the dofs are floor ordered ***)
Switch[ dofOrdering,
"floor" | "Floor", True,
"building" | "Building", dofList =  internalBuildingToFloor[ dofList ],
_, If[ OptionValue[ shearWallShowDeformedQ ] === True,
Message[ shearWalls::unknwnord, OptionValue[ shearWallDOFOrdering ] ]; Return[ $Failed ]
]
];
dofArray = Partition[dofList, 3, 3 ];


centerOfRotations = With[ {theCenterRules = OptionValue[ shearWallCenterOfRotationRules ]}, 
Table[ floorNumber /. theCenterRules, {floorNumber, 1, numberOfFloors} ]
];


drawType = OptionValue[ shearWallDrawType ] /. Automatic -> Line;
drawDirectives = OptionValue[ shearWallDirectives ] /. Automatic -> Directive[ Opacity[0.5]];

zCoorList = Accumulate[heightList];
normalToWall = With[ {t = Normalize[ endBaseCoordinates - startBaseCoordinates]}, {-t[[2]], t[[1]]} ];

(*** Calculate and draw faces ****)
Table[
(
startCoordinates = shearWallStartCoordinatesAtFloor[ a, floorNumber ];
endCoordinates = shearWallEndCoordinatesAtFloor[ a, floorNumber ];
ZCoor = zCoorList[[floorNumber ]] - heightList[[ floorNumber ]];
wallThickness = shearWallThicknessAtFloor[ a, floorNumber ];
dofTriple = If[ floorNumber === 1, {0, 0, 0}, dofArray[[floorNumber - 1 ]] ];
centerRotation = If[ floorNumber === 1, {0, 0}, centerOfRotations[[ floorNumber - 1 ]] ];
lowerBasePoints = With[ {s = startCoordinates, e = endCoordinates},
{s - normalToWall *  (wallThickness/2), s + normalToWall *  (wallThickness/2), e + normalToWall *  (wallThickness/2), e - normalToWall *  (wallThickness/2)}
];
lowerBasePoints = Table[ Append[ coor + calcDisplacement[ coor,{dsFactor, dsFactor, rtFactor} * dofTriple, centerRotation ], ZCoor ], {coor, lowerBasePoints} ];

startCoordinates = shearWallStartCoordinatesAtFloor[ a, floorNumber ];
endCoordinates = shearWallEndCoordinatesAtFloor[ a, floorNumber ];
ZCoor = zCoorList[[floorNumber ]];
wallThickness = shearWallThicknessAtFloor[ a, floorNumber ];
dofTriple = dofArray[[floorNumber ]];
centerRotation = centerOfRotations[[ floorNumber ]];
upperBasePoints = With[ {s = startCoordinates, e = endCoordinates},
{s - normalToWall *  (wallThickness/2), s + normalToWall *  (wallThickness/2), e + normalToWall *  (wallThickness/2), e - normalToWall *  (wallThickness/2)}
];
upperBasePoints = Table[ Append[ coor + calcDisplacement[ coor,{dsFactor, dsFactor, rtFactor} * dofArray[[floorNumber ]], centerRotation ], ZCoor ], {coor, upperBasePoints} ];

cubePoints = {upperBasePoints, lowerBasePoints};
whatToDrawAtFloor = Flatten[ {drawDirectives,
drawType[ Append[ lowerBasePoints,  lowerBasePoints[[1]] ]],
drawType[ Append[ upperBasePoints,  upperBasePoints[[1]] ] ],
Table[ drawType[With[ {v =  Flatten[ cubePoints[[ {1, 2}, {i, Mod[ i+1, 4, 1 ]} ]], 1 ][[ {1, 2, 4, 3} ]]}, Append[ v, v[[1]] ] ] ], {i, 1, 4} ]
} ];

whatToDrawAtFloor
),
{floorNumber, 1, numberOfFloors}
]

] /; shearWallGet[ a, shearWallExistsQ ]


(* ::Subsection::Closed:: *)
(*shearWall: Showing and editing specs*)


shearWallSpecs[ a_shearWall, OptionsPattern[ shearWallSpecs ] ] := 
Module[ {howToPresent, theData, theHeader, theAll,
isEditQ,
lengthEditor,shearModulusEditor, youngsModulusEditor, whatStiffnessEditor, startCoorEditor, endCoorEditor,
angleUnitVectorEditor,thicknessRulesEditor, startEndFractionsRuleEditor,
specificGravityEditor, includeMassEditor
},

howToPresent = OptionValue[ shearWallView ];
If[ Not[ MatchQ[ howToPresent, List | Table | Grid ] ], 
(
Message[ shearWalls::incon, howToPresent, shearWallView ];
Return[ $Failed ]
)
];
isEditQ = OptionValue[ shearWallEdit ] /. Automatic -> False;
If[isEditQ =!= True, isEditQ = False ];

theHeader = {{Row[ {"Wall: ", a } ], SpanFromLeft, SpanFromLeft},{"Parameter", "Value", "Units"}};

lengthEditor = internalSingleInputFieldEditor[ (shearWallPut[ a, shearWallBaseLength, # ] === $Failed)&, shearWallGet[ a, shearWallBaseLength]& ];
shearModulusEditor = internalSingleInputFieldEditor[ (shearWallPut[ a, shearWallShearModulus, # ] === $Failed)&, shearWallGet[ a, shearWallShearModulus]& ];
youngsModulusEditor = internalSingleInputFieldEditor[ (shearWallPut[ a, shearWallYoungsModulus, # ] === $Failed)&, shearWallGet[ a, shearWallYoungsModulus]& ];
whatStiffnessEditor = internalSinglePopupEditor[ (shearWallPut[ a, shearWallIncludeWhatStiffness, # ] === $Failed)&, shearWallGet[ a, shearWallIncludeWhatStiffness]&, {shearWallIncludeShearAndBendingTypes,shearWallIncludeShearTypeOnly, shearWallIncludeBendingTypeOnly} ];
startCoorEditor = internalCoordinateEditor[ (shearWallPut[ a, shearWallBaseStartCoordinates, # ] === $Failed)&, shearWallGet[ a, shearWallBaseStartCoordinates]& ];
endCoorEditor = internalCoordinateEditor[ (shearWallPut[ a, shearWallBaseEndCoordinates, # ] === $Failed)&, (shearWallGet[ a, shearWallBaseEndCoordinates])& ];

angleUnitVectorEditor = internalSingleInputFieldEditor[ (shearWallPut[ a, shearWallUnitVectorAlongWall, {Cos[# Degree],  Sin[ # Degree ]}] === $Failed)&, (N[( ArcTan @@ shearWallGet[ a, shearWallUnitVectorAlongWall]) / Degree ])& ];

thicknessRulesEditor = internalSingleValueRuleListEditor[ shearWallPut[ a, shearWallThicknessRules, # ]&, shearWallGet[ a, shearWallThicknessRules]&, N ];

startEndFractionsRuleEditor = internalCoordinateRuleListEditor[ shearWallPut[ a, shearWallStartEndLengthFractionsRules, # ]&, shearWallGet[ a, shearWallStartEndLengthFractionsRules]&, N ];

specificGravityEditor = internalSingleInputFieldEditor[ (shearWallPut[ a, shearWallSpecificGravity, # ] === $Failed)&, shearWallGet[ a, shearWallSpecificGravity]& ];
includeMassEditor = internalSingleCheckboxEditor[ shearWallPut[ a, shearWallIncludeMassQ, # ]&, shearWallGet[ a, shearWallIncludeMassQ]& ];

theData := {

{"Thickness rules: ", If[ isEditQ,
thicknessRulesEditor,
Table[ With[ { rL = oneRule[[1]], rR = (oneRule[[2]]// internalFormatNum)}, rL :> rR ], {oneRule, shearWallGet[ a, shearWallThicknessRules]} ] ], Meter},

{"Start end fraction rules: ", If[ isEditQ,
startEndFractionsRuleEditor,
Table[ With[ { rL = oneRule[[1]], rR = (oneRule[[2]]// internalFormatNum)}, rL :> rR ], {oneRule, shearWallGet[ a, shearWallStartEndLengthFractionsRules]} ] ], ""},

{"Length: ", If[ isEditQ,
lengthEditor,
shearWallGet[ a, shearWallBaseLength]// internalFormatNum ], Meter},

{"Shear modulus: ", If[ isEditQ,
shearModulusEditor,
shearWallGet[ a, shearWallShearModulus] // internalFormatNum ], Giga Pascal},

{"Young's modulus: ", If[ isEditQ,
youngsModulusEditor,
shearWallGet[ a, shearWallYoungsModulus] // internalFormatNum ], Giga Pascal},

{"Stiffness type: ", If[ isEditQ,
whatStiffnessEditor,
shearWallGet[ a, shearWallIncludeWhatStiffness] ], ""},

{"Specific gravity: ", If[ isEditQ,
specificGravityEditor,
shearWallGet[ a, shearWallSpecificGravity] ], ""},

{"Include wall masss? ", If[ isEditQ,
includeMassEditor,
shearWallGet[ a, shearWallIncludeMassQ] ], ""},

{"Start coordinates: ", If[ isEditQ,
startCoorEditor,
internalFormatNum /@ shearWallGet[ a, shearWallBaseStartCoordinates]  ], Meter},

{"End coordinates: ", If[ isEditQ,
endCoorEditor,
internalFormatNum /@ shearWallGet[ a, shearWallBaseEndCoordinates] ], Meter},

{"Unit vector along wall: ", If[ isEditQ,
Column[ {angleUnitVectorEditor,
(internalFormatNum /@ shearWallGet[ a, shearWallUnitVectorAlongWall])
}],
Column[ {With[ {v =(N[( ArcTan @@ shearWallGet[ a, shearWallUnitVectorAlongWall]) / Degree ])}, If[ internalFormatNum[ v ] === Missing, Missing, Row[ {"angle: ", v}] ] ],
internalFormatNum /@ shearWallGet[ a, shearWallUnitVectorAlongWall]
}]
 ]
}
} // Quiet;

theAll := Join[theHeader, theData];

If[ isEditQ,
Switch[ 
howToPresent,
List, theAll,
Table, MatrixForm[ theAll ],
_, Grid[ theAll, Spacings -> {{{2}}, Automatic}, Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, Thick, {True}, Thick}} ]
] // Dynamic,
Switch[ 
howToPresent,
List, theAll,
Table, MatrixForm[ theAll ],
_, Grid[ theAll, Spacings -> {{{2}}, Automatic}, Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, Thick, {True}, Thick}} ]
]
]

] /; shearWallGet[ a, shearWallExistsQ ]


(* ::Section:: *)
(*Exported functions - shearBuilding*)


(* ::Subsection:: *)
(*    ----------------------     shearBuilding:  OBJECT SUPPORT   -------------------------------*)


(* ::Subsection::Closed:: *)
(*shearBuilding: Options*)


(* ::Subsubsection::Closed:: *)
(*p1:  shearBuildingNew, shearBuildingDraw, shearBuildingDraw2D, shearBuildingSpecs*)


$defaultDampingRatio = 0.05;
$defaultBuildingOptions = {
shearBuildingSlabRules -> { _ -> Automatic },
shearBuildingHeightRules -> { Global`i_ :> 3 },
shearBuildingDampingRatio -> $defaultDampingRatio
};
Options[ shearBuildingNew ] = $defaultBuildingOptions;


Options[ shearBuildingDraw2D ] = {
shearBuildingDOFList-> Automatic,
shearBuildingCenterOfRotation->$centerOfMassMainKeyword,
shearBuildingDisplacementScaleFactor ->  1,
shearBuildingRotationScaleFactor ->  1,
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearBuildingShowDeformedQ->False,

shearWallDrawType->Line,
shearWallDirectives->Directive[Opacity[0.5`]],

shearBuildingAnnotateTextListsOnePerWall->None,
shearBuildingAnnotateUnits->None,
shearWallAnnotateStyleFunction->Identity,
shearWallAnnotateAlongPositiveNormalQ->False,
shearWallAnnotateDistanceFromWall->Automatic,
shearWallAnnotateOrientation->Automatic
};


Options[ shearBuildingDraw ] = {
shearBuildingDOFList -> None,
shearBuildingCenterOfRotation->$centerOfMassMainKeyword,
shearBuildingDisplacementScaleFactor ->  1,
shearBuildingRotationScaleFactor ->  1,
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearBuildingShowDeformedQ->False,

shearSlabDirectives -> Directive[ Opacity[0.5 ] ],
shearSlabDrawType -> Polygon,
shearWallDirectives -> Directive[ Opacity[ 0.5 ] ],
shearWallDrawType -> Polygon
};


Options[ shearBuildingSpecs ] = {
shearBuildingView -> Grid,
shearBuildingEdit -> False
};


(* ::Subsubsection::Closed:: *)
(*p2: shearBuildingRigidityCenters,  shearBuildingStiffnessMatrix, shearBuildingMassMatrix, *)
(*	shearBuildingDampingMatrix, shearBuildingEigensystem*)
(*	shearBuildingFromDOForLoadSpecToVector, shearBuildingCalculateDOFFromForces*)


Options[ shearBuildingRigidityCenters ] = { };


Options[ shearBuildingStiffnessMatrix ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingMassMatrix ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingEigensystem ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingDampingMatrix ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingFromDOForLoadSpecToVector ] = 
{
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


(* ::Subsubsection::Closed:: *)
(*p3: shearBuildingGetWallDeltaDisplacementsFromDOF, shearBuildingGetWallShearForcesFromDOF, shearBuildingGetWallBendingMomentsFromDOF, internalShearBuildingWallCalculate*)


Options[ shearBuildingGetWallDeltaDisplacementsFromDOF ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingGetWallShearForcesFromDOF ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingGetWallBendingMomentsFromDOF ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ internalShearBuildingWallCalculate ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


Options[ shearBuildingCalculateDOFFromForces ] = 
{
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods
};


(* ::Subsubsection::Closed:: *)
(*p4: shearBuildingEarthquakeLoadMassVector, shearBuildingEarthquakeAnalyzeResponseSpectrum, shearBuildingEarthquakeAnalyzeDirectIntegration*)


Options[ shearBuildingEarthquakeLoadMassVector  ] = { 
shearBuildingEarthquakeMotionDirection -> {1, 0},
shearBuildingDOFOrdering->$defaultDOFOrderingForAllMethods 
};


Options[ shearBuildingEarthquakeAnalyzeResponseSpectrum ] = {
shearBuildingCentersOfRotationRules -> { _ -> $centerOfMassMainKeyword },
shearBuildingDOFOrdering -> $defaultDOFOrderingForAllMethods,
shearBuildingEarthquakeMotionDirection -> {1, 0},
shearBuildingResponseSpectrumForDisplacementFunction -> $defaultResponseSpectrumDisplacementFunction
};


Options[ shearBuildingEarthquakeAnalyzeDirectIntegration ] = { shearBuildingCentersOfRotationRules->{_->$centerOfMassMainKeyword},
shearBuildingDOFOrdering->$defaultDOFOrderingForAllMethods,
shearBuildingEarthquakeMotionDirection->{1,0},
shearBuildingEarthquakeAccelerationData -> shearWallsEarthquakeRecords[ "El Centro 1940" ],
shearBuildingEarthquakeMaxTime -> Automatic
};


(* ::Subsection::Closed:: *)
(*shearBuilding: Exported globals*)


shearBuildingKeysGetList = {shearBuildingDampingRatio,shearBuildingExistsQ,shearBuildingHeight,shearBuildingHeightAtFloor,shearBuildingHeightList,shearBuildingHeightRules,shearBuildingNumberOfFloors,shearBuildingSlabList,shearBuildingSlabDrawPrimitives,shearBuildingSlabRules,shearBuildingWallList};


shearBuildingKeysPutList = {shearBuildingDampingRatio,  shearBuildingHeightAtFloor,shearBuildingHeightRules,shearBuildingIncludeWhatStiffness,shearBuildingNumberOfFloors,shearBuildingShearModulus,shearBuildingSlabRules,shearBuildingWallList,shearBuildingWallThicknessRules,shearBuildingYoungsModulus,
shearBuildingWallSpecificGravity,shearBuildingWallIncludeMassQ,
shearBuildingSlabSpecificGravity, shearBuildingSlabThickness };


$shearBuildingComboCQC = "CQC";
$shearBuildingComboSRSS = "SRSS";
$shearBuildingComboSumAbsoluteValues = "SumAbsoluteValues";
$shearBuildingComboHighestMode = "highestMode";


(* ::Subsection::Closed:: *)
(*shearBuilding: Clear all created objects*)


shearBuildingClearAll[] := (
Do[
buildingDataMaster[ i ][ shearBuildingExistsQ ] = False,
{i, 1, shearBuildingCount, 1}
];
shearBuildingCount = 0;
Options[ shearBuildingNew ] = $defaultBuildingOptions;
True
)


(* ::Subsection::Closed:: *)
(*shearBuilding: Creation*)


shearBuildingNew[  numberOfFloors_ , listOfWalls:{ (_shearWall) ... },  OptionsPattern[  shearBuildingNew  ] ] := 
Module[ {shearBuildingData, checkResult, xMin, yMin, xMax, yMax,zMin, zMax},
shearBuildingCount += 1;
shearBuildingData = buildingDataMaster[  shearBuildingCount ];

shearBuildingData[  shearBuildingNumberOfFloors ] = numberOfFloors;
shearBuildingData[  shearBuildingWallList ] = listOfWalls;
shearBuildingData[  shearBuildingSlabRules ] = OptionValue[ shearBuildingSlabRules ];
shearBuildingData[  shearBuildingDampingRatio ] = OptionValue[shearBuildingDampingRatio ];
If[ shearBuildingData[  shearBuildingDampingRatio ] === Automatic, shearBuildingData[  shearBuildingDampingRatio ] = $defaultDampingRatio ];
If[ shearBuildingData[  shearBuildingDampingRatio ] === None, shearBuildingData[  shearBuildingDampingRatio ] = 0 ];
shearBuildingData[  shearBuildingHeightRules ] = OptionValue[shearBuildingHeightRules ];
If[ shearBuildingData[  shearBuildingHeightRules ] === Automatic, shearBuildingData[  shearBuildingHeightRules ] = {i_ :> 3} ];

shearBuildingData[  shearBuildingExistsQ ] = True;

checkResult = And @@ {
shearBuildingCheck[ shearBuildingNumberOfFloors, shearBuildingData[  shearBuildingNumberOfFloors ] ],
shearBuildingCheck[ shearBuildingWallList, shearBuildingData[  shearBuildingWallList ]  ],
shearBuildingCheck[ shearBuildingSlabRules, shearBuildingData[  shearBuildingSlabRules ] ],
shearBuildingCheck[ shearBuildingDampingRatio, shearBuildingData[  shearBuildingDampingRatio ] ], 
shearBuildingCheck[ shearBuildingHeightRules, shearBuildingData[  shearBuildingHeightRules ] ]
};

(*** If input OK, reassign defaults ****)
If[checkResult === True,
(
{{xMin, xMax}, {yMin, yMax}, {zMin, zMax}} = shearBuildingXYZminmaxPairsList[ shearBuilding[ shearBuildingCount ] ];
shearBuildingData[  shearBuildingSlabRules ] = internalShearBuildingDefault[ shearBuildingSlabRules, shearBuildingData[  shearBuildingSlabRules ],
{{xMin, If[Abs[ (xMax - xMin)   ] < 10^-9, xMax + (yMax - yMin), xMax ]}, {yMin,If[Abs[ (yMax - yMin) ] < 10^-9, yMax + (xMax - xMin), yMax ]} }  ];
)
];

If[ checkResult === True, shearBuilding[ shearBuildingCount ], 
(shearBuildingData[  shearBuildingExistsQ ] = False; shearBuildingCount -= 1; $Failed ) 
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Deep cloning*)


shearBuildingDeepClone[ a_shearBuilding ] := 
With[ {numberOfFloors = shearBuildingGet[ a, shearBuildingNumberOfFloors ]},
shearBuildingNew[  numberOfFloors , 
shearWallDeepClone /@ shearBuildingGet[ a, shearBuildingWallList ],
shearBuildingSlabRules -> Thread[ Range[ numberOfFloors ] -> Table[ shearSlabDeepClone[ aSlab ], {aSlab, shearBuildingGet[ a, shearBuildingSlabList ]}] ],
shearBuildingHeightRules -> shearBuildingGet[ a, shearBuildingHeightRules ],
shearBuildingDampingRatio -> shearBuildingGet[ a, shearBuildingDampingRatio ]
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Setting options with checking*)


shearBuildingNew /: SetOptions[ shearBuildingNew, allOptions:OptionsPattern[ shearBuildingNew ] ] := 
Module[ {checkResult, effectiveDampingRatio},

effectiveDampingRatio = With[ {v = OptionValue[  shearBuildingDampingRatio ]},
Which[ v === Automatic, $defaultDampingRatio, v=== None, 0, True, v ] ];

checkResult = And[  shearBuildingCheck[ shearBuildingSlabRules, OptionValue[  shearBuildingSlabRules ] ],
			shearBuildingCheck[ shearBuildingDampingRatio, effectiveDampingRatio ],
shearBuildingCheck[ shearBuildingHeightRules, OptionValue[  shearBuildingHeightRules ] ] ];

If[ checkResult,
Options[ shearBuildingNew ] = {shearBuildingSlabRules -> OptionValue[  shearBuildingSlabRules ], shearBuildingHeightRules -> OptionValue[  shearBuildingHeightRules ], shearBuildingDampingRatio -> effectiveDampingRatio},
$Failed
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Checking*)


shearBuildingCheck[ shearBuildingDampingRatio, someValue_ ] := 
(
If[  Not[ NumericQ[ someValue ] ] || (someValue < 0 === True),
Message[ shearWalls::incom, {shearBuildingDampingRatio -> someValue} ]; False, 
True ]
)


shearBuildingCheck[ shearBuildingHeightAtFloor, someValue_ ] := 
(
If[  Not[ NumericQ[ someValue ] ] || (someValue < 0 === True),
Message[ shearWalls::incom, {shearBuildingHeightAtFloor -> someValue} ]; False, 
True ]
)


shearBuildingCheck[ shearBuildingHeightRules, someValue_ ] := 
(
If[   Not[ MatchQ[ someValue,{ ((Verbatim[ Rule ] | Verbatim[ RuleDelayed ])[ _ , _ ])... } ] ] ||
(Or @@( If[ NumericQ[ # ] &&  # <= 0 === True, True, False ]& /@ (Last /@ someValue) )),
Message[ shearWalls::incom, {shearBuildingHeightRules -> someValue} ]; False, 
True ]
)


shearBuildingCheck[ shearBuildingNumberOfFloors, someValue_ ] := 
(
If[  Not[ IntegerQ[ someValue ] && someValue > 0 ],
Message[ shearWalls::incom, {shearBuildingNumberOfFloors -> someValue} ]; False, 
True 
]
)


shearBuildingCheck[ shearBuildingSlabRules, someValue_ ] := 
(
If[  Not[ someValue === Automatic ||  ( MatchQ[ someValue,{( ( _ ->  _) | ( _ :>  _) ) ... }  ]  && ( And @@ (( Last[ # ] === Automatic || MatchQ[ Last[ # ] , Polygon[ { {_, _} ... } ]] || MatchQ[ Last[ # ] ,  { {_, _} ... }] || MatchQ[ Last[ # ] , Line[ { {_, _} ... } ]]  || Head[ Last[ # ] ] === shearSlab )& /@ someValue ))) ],
Message[ shearWalls::incom, {shearBuildingSlabRules -> someValue} ]; False, 
True 
]
)


shearBuildingCheck[ shearBuildingWallList, someValue_ ] := 
(
If[   Not[ MatchQ[ someValue,{ _shearWall... } ] ],
Message[ shearWalls::incom, {shearBuildingWallList -> someValue} ]; False, 
True ]
)


shearBuildingCheck[ shearBuildingIncludeWhatStiffness, someValue_ ] := shearWallCheck[ shearWallIncludeWhatStiffness, someValue ]


shearBuildingCheck[ shearBuildingShearModulus, someValue_ ] := shearWallCheck[ shearWallShearModulus, someValue ]


shearBuildingCheck[ shearBuildingYoungsModulus, someValue_ ] := shearWallCheck[ shearWallYoungsModulus, someValue ]


shearBuildingCheck[ shearBuildingWallThicknessRules, someValue_ ] := shearWallCheck[ shearWallThicknessRules, someValue ]


shearBuildingCheck[ shearBuildingWallSpecificGravity, someValue_ ] := shearWallCheck[ shearWallSpecificGravity, someValue ]


shearBuildingCheck[ shearBuildingWallIncludeMassQ, someValue_ ] := shearWallCheck[ shearWallIncludeMassQ, someValue ]


shearBuildingCheck[ shearBuildingSlabSpecificGravity, someValue_ ] := shearSlabCheck[ shearSlabSpecificGravity, someValue ]


shearBuildingCheck[ shearBuildingSlabThickness, someValue_ ] := shearSlabCheck[ shearSlabThickness, someValue ]


(* ::Subsection::Closed:: *)
(*shearBuilding: Standardizing 'shearBuildingSlabRules' input and handling defaults*)


internalShearBuildingDefault[ shearBuildingSlabRules, someValue_, {{xMin_, xMax_}, {yMin_, yMax_} } ] := 
Module[ {zMin, zMax},
If[ someValue === Automatic, 
Return[ { _ -> shearSlabNew[{{xMin, yMin}, {xMax, yMin}, {xMax, yMax}, {xMin, yMax} } ] } ]
];
Append[ Table[
Which[ 
Head[ Last[ iSpec ] ] === shearSlab, iSpec,
Head[ Last[ iSpec ] ] === Line || Head[ Last[ iSpec ] ] === Polygon,  iSpec[[1]] -> shearSlabNew[ Identity @@ Last[ iSpec ], shearSlabDrawType ->  Head[ Last[ iSpec ] ] ],
Head[ Last[ iSpec ] ] === List,  iSpec[[1]] -> shearSlabNew[ Last[ iSpec ] ],
Last[ iSpec ] === Automatic, iSpec[[1]] -> shearSlabNew[{{xMin, yMin}, {xMax, yMin}, {xMax, yMax}, {xMin, yMax} } ],
True, iSpec[[1]] -> shearSlabNew[{{xMin, yMin}, {xMax, yMin}, {xMax, yMax}, {xMin, yMax} } ]
],
{iSpec, someValue}
], _ -> shearSlabNew[{{xMin, yMin}, {xMax, yMin}, {xMax, yMax}, {xMin, yMax} } ]]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Getting - default*)


shearBuildingGet[ a_shearBuilding, whatToGet_  ] := 
(Message[ shearWalls::noMem, a, whatToGet ]; $Failed)/;  ( Not[ MemberQ[ shearBuildingKeysGetList,whatToGet ] ] || Not[ buildingDataMaster[ a[[ 1  ]] ][ shearBuildingExistsQ ] === True ])


(* ::Subsection::Closed:: *)
(*shearBuilding: Getting*)


shearBuildingGet[ a_shearBuilding, shearBuildingDampingRatio ] := buildingDataMaster[ a[[ 1  ]] ][ shearBuildingDampingRatio ]


shearBuildingGet[ a_shearBuilding, shearBuildingExistsQ ] := (buildingDataMaster[ a[[ 1  ]] ][ shearBuildingExistsQ ] === True)


shearBuildingGet[ a_shearBuilding, shearBuildingHeight ] := 
Total[ shearBuildingGet[ a, shearBuildingHeightList ] ] /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingGet[ a_shearBuilding, shearBuildingHeightAtFloor, floorNumber_ ] := 
floorNumber /.  Append[ shearBuildingGet[ a, shearBuildingHeightRules ], i_ -> 3 ]


shearBuildingGet[ a_shearBuilding, shearBuildingHeightList ] := 
Table[ shearBuildingGet[ a, shearBuildingHeightAtFloor, floorNumber ], {floorNumber, 1, shearBuildingGet[ a, shearBuildingNumberOfFloors ]} ]


shearBuildingGet[ a_shearBuilding, shearBuildingHeightRules ] := buildingDataMaster[ a[[ 1  ]] ][ shearBuildingHeightRules ]


shearBuildingGet[ a_shearBuilding, shearBuildingNumberOfFloors ] := buildingDataMaster[ a[[ 1  ]] ][ shearBuildingNumberOfFloors ]


shearBuildingGet[ a_shearBuilding, shearBuildingSlabList ] := 
With[ {nFloors = shearBuildingGet[ a, shearBuildingNumberOfFloors ], slabSpecs = shearBuildingGet[ a, shearBuildingSlabRules ]},
Table[  i /. slabSpecs,{i, 1, nFloors}] ]


shearBuildingGet[ a_shearBuilding, shearBuildingSlabDrawPrimitives, floorNumber_ ] := 
If[ 1 <= floorNumber <= shearBuildingGet[ a, shearBuildingNumberOfFloors ],
shearSlabDraw[ (floorNumber /.  shearBuildingGet[ a, shearBuildingSlabRules ]) ] ,
Message[ shearWalls::nofloor, floorNumber, a  ]; $Failed
]


shearBuildingGet[ a_shearBuilding, shearBuildingSlabRules ] := buildingDataMaster[ a[[ 1  ]] ][ shearBuildingSlabRules ]


shearBuildingGet[ a_shearBuilding, shearBuildingWallList ] := buildingDataMaster[ a[[ 1  ]] ][ shearBuildingWallList ]


(* ::Subsection::Closed:: *)
(*shearBuilding: Getting - equivalent form*)


shearBuildingDampingRatio[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingDampingRatio ]
shearBuildingExistsQ[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingExistsQ ]
shearBuildingHeight[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingHeight ]
shearBuildingHeightAtFloor[ a_shearBuilding, floorNumber_ ] := shearBuildingGet[ a, shearBuildingHeightAtFloor, floorNumber ]
shearBuildingHeightList[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingHeightList ]
shearBuildingHeightRules[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingHeightRules ]
shearBuildingNumberOfFloors[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingNumberOfFloors ]
shearBuildingSlabList[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingSlabList ]
shearBuildingSlabDrawPrimitives[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingSlabDrawPrimitives ]
shearBuildingSlabRules[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingSlabRules ]
shearBuildingWallList[ a_shearBuilding ] := shearBuildingGet[ a, shearBuildingWallList ]


(* ::Subsection::Closed:: *)
(*shearBuilding: Putting - default*)


shearBuildingPut[ a_shearBuilding, whatToPut_, value_ ] := (Message[ shearWalls::noMem, a, whatToPut ]; $Failed) /;  (Not[ MemberQ[shearBuildingKeysPutList ,whatToPut ] ] || Not[ shearBuildingGet[ a, shearBuildingExistsQ ] ]);


(* ::Subsection::Closed:: *)
(*shearBuilding: Putting - part 1*)


shearBuildingPut[ a_shearBuilding, shearBuildingDampingRatio, value_ ] := 
Module[ {effectiveDampingRatio},
effectiveDampingRatio = With[ {v = value},
Which[ v === Automatic, $defaultDampingRatio, v=== None, 0, True, v ] ];
If[ shearBuildingCheck[ shearBuildingDampingRatio, effectiveDampingRatio ] === True,
(
buildingDataMaster[ a[[ 1  ]] ][ shearBuildingDampingRatio ] = effectiveDampingRatio;
effectiveDampingRatio
),
$Failed
]
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingHeightAtFloor, floorNumber_, value_ ] := 
If[  (1 <= floorNumber <= shearBuildingGet[ a, shearBuildingNumberOfFloors ])  &&
(shearBuildingCheck[ shearBuildingHeightRules, Prepend[ shearBuildingGet[ a, shearBuildingHeightRules ],floorNumber -> value ] ] === True),
(
buildingDataMaster[ a[[ 1  ]] ][ shearBuildingHeightRules ] = Prepend[ shearBuildingGet[ a, shearBuildingHeightRules ],floorNumber -> value ];
Prepend[ shearBuildingGet[ a, shearBuildingHeightRules ],floorNumber -> value ]
),
$Failed
]


shearBuildingPut[ a_shearBuilding, shearBuildingHeightRules, value_ ] := 
If[ shearBuildingCheck[ shearBuildingHeightRules, value ] === True,
(
buildingDataMaster[ a[[ 1  ]] ][ shearBuildingHeightRules ] = value;
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingIncludeWhatStiffness, value_ ] := 
If[ shearBuildingCheck[ shearBuildingIncludeWhatStiffness, value ] === True,
(
Do[
shearWallPut[ oneWall, shearWallIncludeWhatStiffness, value ],
{oneWall, shearBuildingGet[ a, shearBuildingWallList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingNumberOfFloors, value_ ] := 
If[ shearBuildingCheck[ shearBuildingNumberOfFloors, value ] === True,
(
buildingDataMaster[ a[[ 1  ]] ][ shearBuildingNumberOfFloors ] = value;
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingShearModulus, value_ ] := 
If[ shearBuildingCheck[ shearBuildingShearModulus, value ] === True,
(
Do[
shearWallPut[ oneWall, shearWallShearModulus, value ],
{oneWall, shearBuildingGet[ a, shearBuildingWallList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingSlabRules, value_ ] := 
Module[ {xMin, yMin, xMax, yMax,zMin, zMax},
If[ shearBuildingCheck[ shearBuildingSlabRules, value ] === True,
(
{{xMin, xMax}, {yMin, yMax}, {zMin, zMax}} = shearBuildingXYZminmaxPairsList[ a ];
buildingDataMaster[ a[[ 1  ]] ][ shearBuildingSlabRules ] = internalShearBuildingDefault[ shearBuildingSlabRules, value, {{xMin, xMax}, {yMin, yMax} } ];
value
),
$Failed
]
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingWallList, value_ ] := 
If[ shearBuildingCheck[ shearBuildingWallList, value ] === True,
(
buildingDataMaster[ a[[ 1  ]] ][ shearBuildingWallList ] = value;
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingWallThicknessRules, value_ ] := 
If[ shearBuildingCheck[ shearBuildingWallThicknessRules, value ] === True,
(
Do[
shearWallPut[ oneWall, shearWallThicknessRules, value ],
{oneWall, shearBuildingGet[ a, shearBuildingWallList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingYoungsModulus, value_ ] := 
If[ shearBuildingCheck[ shearBuildingYoungsModulus, value ] === True,
(
Do[
shearWallPut[ oneWall, shearWallYoungsModulus, value ],
{oneWall, shearBuildingGet[ a, shearBuildingWallList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingWallSpecificGravity, value_ ] := 
If[ shearBuildingCheck[ shearBuildingWallSpecificGravity, value ] === True,
(
Do[
shearWallPut[ oneWall, shearWallSpecificGravity, value ],
{oneWall, shearBuildingGet[ a, shearBuildingWallList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingWallIncludeMassQ, value_ ] := 
If[ shearBuildingCheck[ shearBuildingWallIncludeMassQ, value ] === True,
(
Do[
shearWallPut[ oneWall, shearWallIncludeMassQ, value ],
{oneWall, shearBuildingGet[ a, shearBuildingWallList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingSlabSpecificGravity, value_ ] := 
If[ shearBuildingCheck[ shearBuildingSlabSpecificGravity, value ] === True,
(
Do[
shearSlabPut[ oneSlab, shearSlabSpecificGravity, value ],
{oneSlab, shearBuildingGet[ a, shearBuildingSlabList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


shearBuildingPut[ a_shearBuilding, shearBuildingSlabThickness, value_ ] := 
If[ shearBuildingCheck[ shearBuildingSlabThickness, value ] === True,
(
Do[
shearSlabPut[ oneSlab, shearSlabThickness, value ],
{oneSlab, shearBuildingGet[ a, shearBuildingSlabList ]}
];
value
),
$Failed
]  /; shearBuildingGet[ a, shearBuildingExistsQ ]


(* ::Subsection::Closed:: *)
(*shearBuilding: Putting - equivalent form*)


shearBuildingDampingRatio[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingDampingRatio, value ]
shearBuildingHeightAtFloor[  a_shearBuilding, floorNumber_, value_ ] := shearBuildingPut[ a, shearBuildingHeightAtFloor, floorNumber, value ]
shearBuildingHeightRules[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingHeightRules, value ]
shearBuildingIncludeWhatStiffness[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingIncludeWhatStiffness, value ]
shearBuildingNumberOfFloors[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingNumberOfFloors, value ]
shearBuildingShearModulus[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingShearModulus, value ]
shearBuildingSlabRules[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingSlabRules, value ]
shearBuildingWallList[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingWallList, value ]
shearBuildingWallThicknessRules[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingWallThicknessRules, value ]
shearBuildingYoungsModulus[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingYoungsModulus, value ]
shearBuildingWallSpecificGravity[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingWallSpecificGravity, value ]
shearBuildingWallIncludeMassQ[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingWallIncludeMassQ, value ]
shearBuildingSlabSpecificGravity[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingSlabSpecificGravity, value ]
shearBuildingSlabThickness[  a_shearBuilding, value_ ] := shearBuildingPut[ a, shearBuildingSlabThickness, value ]


(* ::Subsection::Closed:: *)
(*shearBuilding: Adding and removing walls*)


{shearBuildingAddShearWall, shearBuildingRemoveShearWall};


shearBuildingAddShearWall[ a_shearBuilding, someShearWall_shearWall ] := 
If[ shearWallExistsQ[ someShearWall  ] && Not[ MemberQ[ shearBuildingGet[  a, shearBuildingWallList ], someShearWall ] ],
shearBuildingPut[ a, shearBuildingWallList, Append[ shearBuildingGet[  a, shearBuildingWallList ],someShearWall ] ]
] /; shearBuildingExistsQ[ a ]


shearBuildingRemoveShearWall[ a_shearBuilding, someShearWall_shearWall ] := If[ shearWallExistsQ[ someShearWall  ] && MemberQ[ shearBuildingGet[  a, shearBuildingWallList ], someShearWall ],
shearBuildingPut[ a, shearBuildingWallList, DeleteCases[ shearBuildingGet[  a, shearBuildingWallList ],someShearWall ] ]
] /; shearBuildingExistsQ[ a ]


(* ::Subsection:: *)
(*---------------------     shearBuilding:  CALCULATIONS   ------------------------------*)


(* ::Subsection::Closed:: *)
(*shearBuilding: Getting the slab centroids, slab areas and slab polar moments of inertia*)


shearBuildingSlabCentroids[ a_shearBuilding ] := 
With[ {shearSlabRules = shearBuildingGet[ a, shearBuildingSlabRules ]},

Table[  shearSlabCentroid[ floorNumber /.  shearSlabRules ], {floorNumber, 1, shearBuildingGet[ a, shearBuildingNumberOfFloors ], 1}]
]


shearBuildingSlabAreas[ a_shearBuilding ] := 
With[ {shearSlabRules = shearBuildingGet[ a, shearBuildingSlabRules ]},

Table[  shearSlabArea[ floorNumber /.  shearSlabRules ], {floorNumber, 1, shearBuildingGet[ a, shearBuildingNumberOfFloors ], 1}]
]


shearBuildingSlabPolarMomentOfInertiaRelativeToCentroids[ a_shearBuilding ] := 
With[ {shearSlabRules = shearBuildingGet[ a, shearBuildingSlabRules ]},

Table[  shearSlabPolarMomentOfInertiaRelativeToCentroid[ floorNumber /.  shearSlabRules ], {floorNumber, 1, shearBuildingGet[ a, shearBuildingNumberOfFloors ], 1}]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Getting center of mass list (includes role of walls)*)


shearBuildingCenterOfMassList[ a_shearBuilding ] := 
Module[ {
numberOfFloors,
slabList, slabCentroidsList, slabMassesList, 
wallMassesLumpedList, wallCentersOfLumpedMassList, wallWithMassList, numberOfEffectiveWalls, 
heightList,
totalEffectiveMass, totalEffectiveMoment
},

numberOfFloors = shearBuildingNumberOfFloors[ a ];
slabList = shearBuildingSlabList[ a ];
wallWithMassList = Select[ shearBuildingWallList[ a ], shearWallIncludeMassQ[ # ]& ];
numberOfEffectiveWalls = Length[ wallWithMassList ];
heightList = shearBuildingHeightList[ a ];

slabMassesList = Table[ shearSlabMassSlabAndDeadMass[ oneSlab ], {oneSlab, slabList} ];
slabCentroidsList = shearBuildingSlabCentroids[ a ];

If[  numberOfEffectiveWalls == 0, 
Return[ slabCentroidsList ];
];

wallMassesLumpedList = Table[ shearWallMassLumpedList[ oneWall, heightList ], {oneWall, wallWithMassList} ];
wallCentersOfLumpedMassList = Table[ shearWallCenterOfMassLumpedList[oneWall, heightList ],{oneWall, wallWithMassList} ];

Table[
(
(slabMassesList[[floorNumber]] *   slabCentroidsList[[floorNumber]] + 
Sum[wallMassesLumpedList[[ wallNumber,floorNumber ]] * wallCentersOfLumpedMassList[[ wallNumber,floorNumber ]],{wallNumber, 1, numberOfEffectiveWalls}]  ) / (slabMassesList[[floorNumber]] + 
Sum[wallMassesLumpedList[[ wallNumber,floorNumber ]],{wallNumber, 1, numberOfEffectiveWalls}]  )
),
{floorNumber, 1, numberOfFloors}
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Getting the min x, max x, min y, max y, min z, max z*)


shearBuildingXYZminmaxPairsList[ a_shearBuilding ] := 
Module[ {wallsList, heightsList, allXYCoordinates, 
xMin, xMax, yMin, yMax, zMin, zMax,
zCoordinateList,  \[CapitalDelta]x, \[CapitalDelta]y, \[CapitalDelta]z },

wallsList = shearBuildingWallList[ a ];
heightsList = shearBuildingHeightList[ a ];
zCoordinateList = Accumulate[ Prepend[ heightsList, 0 ] ];
{zMin, zMax} = {Min[zCoordinateList ], Max[zCoordinateList ]};
\[CapitalDelta]z = Abs[ zMax - zMin ];
Which[ 
Not[And @@ (NumericQ /@ {zMin, zMax}) ], ({zMin, zMax} = {0, 1}),
\[CapitalDelta]z < $epsForXYspan, zMax = zMin + 1,
True, Null
 ];

If[ Length[ wallsList ] === 0,
Return[ {{0, 1}, {0, 1}, {zMin, zMax}} ]
];

allXYCoordinates = Flatten[ Table[ {shearWallGet[ aWall, shearWallBaseStartCoordinates ], shearWallGet[ aWall, shearWallBaseEndCoordinates ]},
{aWall, wallsList} ], 1 ];
{xMin, xMax, yMin, yMax} = {Min[  allXYCoordinates[[ All, 1 ]] ], Max[  allXYCoordinates[[ All, 1 ]] ], Min[  allXYCoordinates[[ All, 2 ]] ], Max[  allXYCoordinates[[ All, 2 ]] ]};
\[CapitalDelta]x = Abs[ xMax - xMin ];
\[CapitalDelta]y = Abs[ yMax - yMin ];
Which[
Not[ And @@ (NumericQ /@ {xMin, xMax, yMin, yMax}) ], {xMin, xMax, yMin, yMax} = {0, 1, 0, 1},
(\[CapitalDelta]x < $epsForXYspan)  && (\[CapitalDelta]y < $epsForXYspan),  (xMax = xMin + 1;  yMax = yMin + 1;),
(\[CapitalDelta]x < $epsForXYspan)  && (\[CapitalDelta]y > $epsForXYspan),  (xMax = xMin + \[CapitalDelta]y;),
(\[CapitalDelta]x > $epsForXYspan)  && (\[CapitalDelta]y < $epsForXYspan),  ( yMax = yMin + \[CapitalDelta]x;),
True, Null
];

{{xMin, xMax}, {yMin, yMax}, {zMin, zMax}} 
]


(* ::Subsection::Closed:: *)
(*shearBuilding:  Rigidity centers*)


shearBuildingRigidityCenters[ a_shearBuilding, someOptions:OptionsPattern[ shearBuildingRigidityCenters ] ] := 
Module[ {stiffMat, xc, yc, nFloors},
nFloors = shearBuildingNumberOfFloors[ a ];
stiffMat = shearBuildingStiffnessMatrix[ a, 
shearBuildingCentersOfRotationRules->Table[ i -> {xc[i], yc[i]}, {i, 1, nFloors }],
shearBuildingDOFOrdering->"building" ];
Table[ {xc[i], yc[i]}, {i, 1, nFloors}] /.Solve[ Join[ Thread[ (stiffMat[[4;;-1]] . Join[ ConstantArray[ 0, {nFloors} ], ConstantArray[ 1, {nFloors} ], ConstantArray[ 0, {nFloors} ]])[[ Reverse[ - Range[ nFloors ] ] ]] == 0 ],
Thread[ (stiffMat[[4;;-1]] . Join[ ConstantArray[ 1, {nFloors} ], ConstantArray[ 0, {nFloors} ], ConstantArray[ 0, {nFloors} ]])[[ Reverse[ - Range[ nFloors ] ] ]] == 0 ] ],
Join[ Table[ xc[i], {i, 1, nFloors}], Table[ yc[i], {i, 1, nFloors}] ] ][[1]]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Stiffness matrix (whole building due to shear walls)*)


shearBuildingStiffnessMatrix[ a_shearBuilding, OptionsPattern[ shearBuildingStiffnessMatrix ] ] := 
Module[ { numberOfFloors, wallList, numberOfWalls, heightList, centerOfRotationRules, 
explicitCenterOfRotationRules, theFloorCentersOfMass, dofOrdering},

numberOfFloors = shearBuildingNumberOfFloors[ a ];
wallList = shearBuildingWallList[ a ];
numberOfWalls = Length[ wallList ];
heightList = shearBuildingHeightList[ a ];

centerOfRotationRules = OptionValue[ shearBuildingCentersOfRotationRules ];
If[ centerOfRotationRules === Automatic || Head[centerOfRotationRules ] =!= List || Length[centerOfRotationRules ] === 0,
centerOfRotationRules = { _ -> $centerOfMassMainKeyword } ];
theFloorCentersOfMass = shearBuildingCenterOfMassList[ a ];

explicitCenterOfRotationRules = Table[
floorNumber -> ( (floorNumber /. centerOfRotationRules) /. { (kw_ /; MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ kw ] ]) -> theFloorCentersOfMass[[ floorNumber ]]} ),
{floorNumber, 1, numberOfFloors}
];
dofOrdering = OptionValue[ shearBuildingDOFOrdering ] /. Automatic -> $defaultDOFOrderingForAllMethods;

Sum[
shearWallStiffnessMatrix[ oneWall, heightList,
shearWallDOFOrdering->dofOrdering,
shearWallCenterOfRotationRules-> explicitCenterOfRotationRules
 ],
{oneWall, wallList}
]
] /; shearBuildingGet[ a, shearBuildingExistsQ ]


(* ::Subsection::Closed:: *)
(*shearBuilding: Mass matrix*)


shearBuildingMassMatrix[ a_shearBuilding,someOptions:OptionsPattern[ shearBuildingMassMatrix ] ] := Module[ { centersOfRotationRules, numberOfFloors, listOfShearSlabs, massSlabDiagonal, massSlabMatrix, theFloorCentersOfMass,
centerOfRotationForFloor, explicitCenterOfRotationRules,
wallWithMassList, numberOfEffectiveWalls,  heightList, massWallsMatrix, massMatrix },

numberOfFloors = shearBuildingGet[ a, shearBuildingNumberOfFloors ];

centersOfRotationRules = OptionValue[  shearBuildingCentersOfRotationRules ];
theFloorCentersOfMass = shearBuildingCenterOfMassList[ a ];
If[  centersOfRotationRules === Automatic ||  MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ centersOfRotationRules ] ], centersOfRotationRules = { _ -> $centerOfMassMainKeyword } ];
centerOfRotationForFloor[ floorNumber_ ] :=   (floorNumber /. Join[centersOfRotationRules, {_ -> $Failed } ]) /.  {(kw_ /; MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ kw ] ]) ->  theFloorCentersOfMass[[floorNumber ]]};
explicitCenterOfRotationRules = Table[ floorNumber -> centerOfRotationForFloor[ floorNumber ], {floorNumber, 1, numberOfFloors} ];

listOfShearSlabs = shearBuildingGet[ a, shearBuildingSlabList ];

If[ MemberQ[ Table[ If[ Not[(Head[ aSlab ] === shearSlab && shearSlabGet[ aSlab, shearSlabExistsQ ] )], $Failed, aSlab ] , {aSlab, listOfShearSlabs} ], $Failed ], 
Message[shearWalls::floorNoExist,  " <some floor> "];
Return[ $Failed ] ];
If[ Not[ And @@ Table[ MatchQ[ centerOfRotationForFloor[ i ], {_?NumericQ, _?NumericQ} ], {i, 1, numberOfFloors} ] ],
Message[ shearWalls::centWrng ];
Return[ $Failed ] ];

massSlabDiagonal = Flatten[ Table[ With[ {m = shearSlabMassSlabAndDeadMass[ listOfShearSlabs[[ floorNumber ]] ], Ip = shearSlabMassPolarMomentOfInertiaRelativeToSpecifiedCenter[ listOfShearSlabs[[ floorNumber ]], centerOfRotationForFloor[ floorNumber ] ]},
{m, m, Ip} ], {floorNumber, 1, numberOfFloors} ] ];
massSlabMatrix = DiagonalMatrix[ massSlabDiagonal ];

wallWithMassList = Select[ shearBuildingWallList[ a ], shearWallIncludeMassQ[ # ]& ];
numberOfEffectiveWalls = Length[ wallWithMassList ];
heightList = shearBuildingHeightList[ a ];
massWallsMatrix = Sum[ shearWallMassMatrix[ oneWall, heightList,
shearWallDOFOrdering -> "floor",  (*** to be consistent with slab;  later reorder if needed ***)
shearWallCenterOfRotationRules -> explicitCenterOfRotationRules
 ], {oneWall, wallWithMassList} ];

If[  numberOfEffectiveWalls == 0,
(
massMatrix = massSlabMatrix;
),
(
massMatrix = massSlabMatrix + massWallsMatrix;
)
];

Switch[ OptionValue[ shearBuildingDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods},
"floor" | "Floor", massMatrix,
"building" | "Building", With[ {ord =  Join[ Range[ 1,3 * numberOfFloors, 3 ], Range[ 2,3 * numberOfFloors, 3 ], Range[ 3,3 * numberOfFloors, 3 ] ]}, massMatrix[[ ord, ord ]] ],
_, Message[ shearWalls::unknwnord, OptionValue[ shearBuildingDOFOrdering ] ]; $Failed
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Damping matrix*)


shearBuildingDampingMatrix[ a_shearBuilding, dampingMatrixOptions:OptionsPattern[ shearBuildingDampingMatrix ] ] := 
Module[ { eigenVectors, eigenValues, massMatrix, dampingRatio, capMlist, capCmatrix },

massMatrix = shearBuildingMassMatrix[ a,FilterRules[ {dampingMatrixOptions} // Flatten,Options[shearBuildingMassMatrix ]] ];

{eigenValues, eigenVectors} = {shearBuildingEigenvalues, shearBuildingModeShapes} /. shearBuildingEigensystem[ a, FilterRules[ {dampingMatrixOptions} // Flatten,Options[shearBuildingEigensystem ]] ];

dampingRatio = shearBuildingGet[ a, shearBuildingDampingRatio ];
capMlist = Tr[  eigenVectors . massMatrix . Transpose[ eigenVectors ], List ];
capCmatrix = DiagonalMatrix[ 2 * dampingRatio * (Sqrt /@ eigenValues) * capMlist   ];

Inverse[ eigenVectors ] . capCmatrix . Inverse[ Transpose[ eigenVectors ] ]
]


(* ::Text:: *)
(*Let:*)
(*\[CapitalPhi] be a matrix whose columns are the eigenvectors of the system above  (in Mathematica, this is obtained as *)
(*\[CapitalLambda] be a diagonal matrix of the corresponding eigenvalues*)


(* ::Text:: *)
(*Let:*)
(*M = \[CapitalPhi]^T m  \[CapitalPhi]*)
(*K = \[CapitalPhi]^T k  \[CapitalPhi]*)


(* ::Text:: *)
(*The most general way to specify 'c' to be orthogonal is to choose it as follows:*)
(*        c = (\[CapitalPhi]^-T) C (\[CapitalPhi]^-1)     where:   'C' is a diagonal matrix*)
(*        Usually, the diagonal elements of 'C' are written as:  Subscript[C, n] = 2 Subscript[\[Xi], n] Subscript[\[Omega], n] Subscript[M, n]  where Subscript[\[Xi], n] is the damping ratio*)


(* ::Text:: *)
(*Computationally, if we write: Subscript[C, n] = 2 Subscript[\[Xi], n] Subscript[\[Omega], n] Subscript[M, n]  where Subscript[\[Omega], n] = Sqrt[Subscript[\[Lambda], n]] (assuming all Subscript[\[Lambda], n]'s are positive) *)
(*Then we can show that   c = m \[CapitalPhi] \[Zeta] \[CapitalPhi]^T m*)
(*Note:  *)
(*\[Bullet]  It takes less than a second to invert a 1000*1000 system of (fully populated) equations in Mathematica on my MacBook circa 2011 so that the above computational shortcut is not really needed.*)
(*\[Bullet]  For buildings less than 50 floors the system is less than 150*150 and this would take less than 5/1000^th of a second (see below)*)


(* ::Subsection::Closed:: *)
(*shearBuilding: Eigensystem*)


shearBuildingEigensystem[ a_shearBuilding, eigensystemOptions:OptionsPattern[ shearBuildingEigensystem ] ] := 
Module[ { centersOfRotationRules, numberOfFloors,  massMatrix, stiffnessMatrix, eigenVectors, eigenValues, ascendingOrder, dofOrdering, capCmatrix, capMlist,
dampingRatio },

massMatrix = shearBuildingMassMatrix[ a,FilterRules[ {eigensystemOptions} // Flatten,Options[shearBuildingMassMatrix ]] ];
stiffnessMatrix = shearBuildingStiffnessMatrix[ a, FilterRules[{eigensystemOptions} // Flatten,Options[shearBuildingStiffnessMatrix ]] ];
dofOrdering = OptionValue[ shearBuildingDOFOrdering ] /. Automatic -> $defaultDOFOrderingForAllMethods;

numberOfFloors = shearBuildingNumberOfFloors[ a ];
{eigenValues, eigenVectors} =  Eigensystem[ {stiffnessMatrix, massMatrix}];

ascendingOrder = Ordering[ eigenValues, All, Less ];

eigenValues = eigenValues[[ ascendingOrder ]];
eigenVectors = eigenVectors[[ ascendingOrder  ]];

With[ {maxEigenvalue = Max[ Abs /@ eigenValues ], maxEigcomponent = Max[ Abs /@ Flatten[ eigenVectors ] ] },
eigenValues = (If[ Abs[ Im[ # ] ] < 10^-7 maxEigenvalue, Chop[ Re[ # ], 10^-12  * maxEigenvalue ], Chop[ #, 10^-12  * maxEigenvalue ] ]& /@ eigenValues);
eigenVectors = Map[ If[ Abs[ Im[ # ] ] < 10^-7  * maxEigcomponent, Chop[ Re[ # ], 10^-12  * maxEigcomponent ],Chop[ #, 10^-12  * maxEigcomponent ] ]&, eigenVectors, {2} ];
];

{shearBuildingModePeriods ->  ( If[ # == 0, \[Infinity], (2\[Pi]/Sqrt[#])]& /@  eigenValues),shearBuildingEigenvalues -> eigenValues, shearBuildingModeShapes -> eigenVectors}
]


(* ::Text:: *)
(*Let:*)
(*\[CapitalPhi] be a matrix whose columns are the eigenvectors of the system above  (in Mathematica, this is obtained as *)
(*\[CapitalLambda] be a diagonal matrix of the corresponding eigenvalues*)


(* ::Text:: *)
(*Let:*)
(*M = \[CapitalPhi]^T m  \[CapitalPhi]*)
(*K = \[CapitalPhi]^T k  \[CapitalPhi]*)


(* ::Text:: *)
(*The most general way to specify 'c' to be orthogonal is to choose it as follows:*)
(*        c = (\[CapitalPhi]^-T) C (\[CapitalPhi]^-1)     where:   'C' is a diagonal matrix*)
(*        Usually, the diagonal elements of 'C' are written as:  Subscript[C, n] = 2 Subscript[\[Xi], n] Subscript[\[Omega], n] Subscript[M, n]  where Subscript[\[Xi], n] is the damping ratio*)


(* ::Text:: *)
(*Computationally, if we write: Subscript[C, n] = 2 Subscript[\[Xi], n] Subscript[\[Omega], n] Subscript[M, n]  where Subscript[\[Omega], n] = Sqrt[Subscript[\[Lambda], n]] (assuming all Subscript[\[Lambda], n]'s are positive) *)
(*Then we can show that   c = m \[CapitalPhi] \[Zeta] \[CapitalPhi]^T m*)
(*Note:  *)
(*\[Bullet]  It takes less than a second to invert a 1000*1000 system of (fully populated) equations in Mathematica on my MacBook circa 2011 so that the above computational shortcut is not really needed.*)
(*\[Bullet]  For buildings less than 50 floors the system is less than 150*150 and this would take less than 5/1000^th of a second (see below)*)


(* ::Subsection::Closed:: *)
(*shearBuilding: Mass Earthquake load vector*)


shearBuildingEarthquakeLoadMassVector[ a_shearBuilding,someOptions:OptionsPattern[ shearBuildingEarthquakeLoadMassVector ] ] := 
Module[ {whatDirectionOrAngle, unitDirection, numberOfFloors, slabList, massMatrix, extendedUnitVector, extendedUnitVectorList, massVector},

whatDirectionOrAngle = OptionValue[ shearBuildingEarthquakeMotionDirection ];
Which[ 
Head[ whatDirectionOrAngle ] === List && MatchQ[ whatDirectionOrAngle, {_, _} ], unitDirection = Normalize[ whatDirectionOrAngle ],
	  MatchQ[ whatDirectionOrAngle, _?NumericQ | _Symbol | ( _Symbol * Degree ) ], unitDirection = {Cos[ whatDirectionOrAngle ], Sin[ whatDirectionOrAngle ]},
	whatDirectionOrAngle === Automatic, unitDirection = {1, 0},
          True,  Message[ shearWalls::unknwnDirFormat, shearBuildingEarthquakeMotionDirection ->  whatDirectionOrAngle ]; Return[ $Failed ]
];
extendedUnitVector = {unitDirection[[1]], unitDirection[[2]], 0};
numberOfFloors = shearBuildingGet[ a, shearBuildingNumberOfFloors ];
extendedUnitVectorList = Flatten[ Table[ extendedUnitVector, {numberOfFloors} ] ];

massMatrix = shearBuildingMassMatrix[ a,
shearBuildingDOFOrdering->"floor"
 ];

massVector =  -  massMatrix . extendedUnitVectorList;

Switch[ OptionValue[ shearBuildingDOFOrdering ] /. Automatic -> $defaultDOFOrderingForAllMethods,
"floor" | "Floor", massVector,
"building" | "Building", With[ {ord =  Join[ Range[ 1,3 * numberOfFloors, 3 ], Range[ 2,3 * numberOfFloors, 3 ], Range[ 3,3 * numberOfFloors, 3 ] ]}, massVector[[ ord ]] ],
_, Message[ shearWalls::unknwnord, OptionValue[ shearBuildingDOFOrdering ] ]; $Failed
]

]


(* ::Subsection::Closed:: *)
(*shearBuilding: Analysis using response spectra*)


$shearBuildingCQC= "CQC";
$shearBuildingSRSS = "SRSS";
$shearBuildingSumAbsoluteValues = "Sum Absolute Values";
$shearBuildingHighestMode = "Highest Mode"; 


shearBuildingEarthquakeAnalyzeResponseSpectrum[ a_shearBuilding,someOptions:OptionsPattern[ shearBuildingEarthquakeAnalyzeResponseSpectrum ] ] := 
Module[ { sdFct, bldEigenvalues, bldEigenmodes, extendedOptions,
\[Omega]List, TList,eqLoadVector, \[Xi], numberOfFloors, \[Phi]Matrix, massLoadVector,massMatrix, 
contributionFactors, percentContributionFactors, modeWithHighestContributionFactor,
modeAmplitudeFromRS,
dofModeResponses, wallForcesModeResponses, wallMomentsModeResponses, wallDriftsModeResponses,
wallForceExp, wallMomentExp, wallDriftExp,
dofVec, dof, numberOfModes, epsToChop,
comboDofModeResponses, comboWallForcesModeResponses,comboWallMomentsModeResponses, comboWallDriftsModeResponses },


(*****************************************************************************************************)
(***         Get the options and handle defaults;  Also do some initializations                    ***)
(*****************************************************************************************************)
sdFct = OptionValue[ shearBuildingResponseSpectrumForDisplacementFunction ];
If[ sdFct === Automatic, sdFct = $defaultResponseSpectrumDisplacementFunction ];
If[ Or @@ ( Not[ NumericQ[ sdFct[ #  ] ] ]& /@ {0, 0.1, 0.3, 0.5, 1} ),
Message[shearWalls::rsNonNumeric]; Return[ $Failed ];
];

\[Xi] = shearBuildingGet[ a, shearBuildingDampingRatio ];
numberOfFloors = shearBuildingGet[ a, shearBuildingNumberOfFloors ];
extendedOptions = Flatten[ Join[{someOptions}, Options[ shearBuildingEarthquakeAnalyzeResponseSpectrum ]] ];
epsToChop = 10^-12;


(*****************************************************************************************************)
(***  Get the eigenvalues, eigenvectors, earthquake mass load vector and contribution factors      ***)
(*****************************************************************************************************)
{bldEigenvalues, bldEigenmodes} = {shearBuildingEigenvalues, shearBuildingModeShapes} /. shearBuildingEigensystem[ a, FilterRules[ extendedOptions,Options[ shearBuildingEigensystem]] ];
\[Omega]List = Table[ Sqrt[\[Omega]2], {\[Omega]2, bldEigenvalues} ];
TList = Table[  2\[Pi] / \[Omega], {\[Omega], \[Omega]List} ];
\[Phi]Matrix = Transpose[bldEigenmodes ];
massLoadVector = shearBuildingEarthquakeLoadMassVector[ a,  FilterRules[extendedOptions,Options[ shearBuildingEarthquakeLoadMassVector]] ];
massMatrix = shearBuildingMassMatrix[ a,  FilterRules[extendedOptions,Options[ shearBuildingMassMatrix]] ];
contributionFactors = Transpose[\[Phi]Matrix ]. massLoadVector / Table[  \[Phi].massMatrix.\[Phi], {\[Phi], Transpose[\[Phi]Matrix ]} ];
percentContributionFactors = 100 (Abs /@ contributionFactors) / Total[ Abs /@ contributionFactors ];
modeWithHighestContributionFactor = SortBy[ Transpose[ {Range[Length[ percentContributionFactors ] ], percentContributionFactors} ], (-#[[2]]&) ][[1, 1]];

(*****************************************************************************************************)
(***  Get the response spectrum displacement for each mode and dof response for each mode          ***)
(*****************************************************************************************************)
modeAmplitudeFromRS = Table[  sdFct[ T ], {T, TList} ];
dofModeResponses = Table[  modeAmplitudeFromRS[[i]] * contributionFactors[[i]] * \[Phi]Matrix[[ All, i ]], {i, 1, Length[ modeAmplitudeFromRS]} ];

(*****************************************************************************************************)
(***  Get wall shears, moments and drifts for each mode                                            ***)
(*****************************************************************************************************)
numberOfModes = Length[\[Phi]Matrix ];
dofVec = Array[ dof, {numberOfModes}];
wallForceExp = shearBuildingGetWallShearForcesFromDOF[ a, dofVec, FilterRules[extendedOptions,Options[ shearBuildingGetWallShearForcesFromDOF]] ];
wallMomentExp = shearBuildingGetWallBendingMomentsFromDOF[ a, dofVec, FilterRules[extendedOptions,Options[ shearBuildingGetWallBendingMomentsFromDOF]] ];
wallDriftExp = shearBuildingGetWallDeltaDisplacementsFromDOF[ a, dofVec, FilterRules[extendedOptions,Options[ shearBuildingGetWallDeltaDisplacementsFromDOF]] ];

wallForcesModeResponses = Table[  wallForceExp /. Thread[ dofVec -> inDof ], {inDof, dofModeResponses} ];
wallMomentsModeResponses = Table[  wallMomentExp /. Thread[ dofVec -> inDof ], {inDof, dofModeResponses} ];
wallDriftsModeResponses = Table[  wallDriftExp /. Thread[ dofVec -> inDof ], {inDof, dofModeResponses} ];

(*****************************************************************************************************)
(***  Get mode combinations for each type of response                                              ***)
(*****************************************************************************************************)
comboDofModeResponses = Append[ Table[ whatMethod -> combineModes[ whatMethod, dofModeResponses, \[Omega]List, \[Xi] ], {whatMethod, {$shearBuildingCQC, $shearBuildingSRSS, $shearBuildingSumAbsoluteValues }}],
$shearBuildingHighestMode ->  dofModeResponses[[ modeWithHighestContributionFactor ]] ];
comboWallForcesModeResponses = Append[ Table[ whatMethod -> (combineModes[ whatMethod, wallForcesModeResponses, \[Omega]List, \[Xi] ]), {whatMethod, {$shearBuildingCQC, $shearBuildingSRSS, $shearBuildingSumAbsoluteValues }}],
$shearBuildingHighestMode ->  wallForcesModeResponses[[ modeWithHighestContributionFactor ]] ];
comboWallMomentsModeResponses = Append[ Table[ whatMethod -> (combineModes[ whatMethod, wallMomentsModeResponses, \[Omega]List, \[Xi] ]), {whatMethod, {$shearBuildingCQC, $shearBuildingSRSS, $shearBuildingSumAbsoluteValues }}],
$shearBuildingHighestMode ->  wallMomentsModeResponses[[ modeWithHighestContributionFactor ]] ];
comboWallDriftsModeResponses = Append[Table[ whatMethod -> (combineModes[ whatMethod, wallDriftsModeResponses, \[Omega]List, \[Xi] ] ), {whatMethod, {$shearBuildingCQC, $shearBuildingSRSS, $shearBuildingSumAbsoluteValues }}],
$shearBuildingHighestMode ->  wallDriftsModeResponses[[ modeWithHighestContributionFactor ]] ];

(*****************************************************************************************************)
(***  Package the data and return results                                                          ***)
(*****************************************************************************************************)

{
shearBuilding -> a,
shearBuildingDOFOrdering -> OptionValue[shearBuildingDOFOrdering ],
shearBuildingCentersOfRotationRules -> OptionValue[shearBuildingCentersOfRotationRules ],
shearBuildingEarthquakeMotionDirection ->  OptionValue[shearBuildingEarthquakeMotionDirection ],
shearBuildingResponseSpectrumForDisplacementFunction -> OptionValue[shearBuildingResponseSpectrumForDisplacementFunction ],
shearBuildingModePeriods -> TList,
shearBuildingModeVsMassContributionsPercent -> SortBy[ Transpose[ {Range[Length[ percentContributionFactors ] ], percentContributionFactors} ], (-#[[2]]&) ],
shearBuildingModeShapes -> bldEigenmodes,
shearBuildingDOFList -> Join[  Thread[ Range[ numberOfModes ] ->  dofModeResponses ], comboDofModeResponses ],
shearBuildingGetWallShearForcesFromDOF ->    Join[ Thread[ Range[ numberOfModes ] ->  wallForcesModeResponses ], comboWallForcesModeResponses ],
shearBuildingGetWallBendingMomentsFromDOF -> Join[ Thread[ Range[ numberOfModes ] ->  wallMomentsModeResponses ],comboWallMomentsModeResponses ],
shearBuildingGetWallDeltaDisplacementsFromDOF -> Join[ Thread[ Range[ numberOfModes ] ->  wallDriftsModeResponses ], comboWallDriftsModeResponses ]
}
]


(* ::Text:: *)
(*Output should follow the pattern below:*)


(* ::Text:: *)
(*{ *)
(*  shearBuildingDOFOrdering -> "building",*)
(*  shearBuildingEarthquakeMotionDirection -> {1, 0},*)
(*  shearBuildingResponseSpectrumForDisplacementFunction -> someFunction,*)
(*  shearBuilding -> shearBuilding[ indexNumber ],*)
(* " shearBuildingModePeriods"  ->  { 1 ->..., 2 -> ---,  ... },*)
(* "shearBuidlingModeShapes" -> { 1 -> { ... }, 2 -> {...}, ...},*)
(*  "massContributionPercent" -> { 1 -> ..., 2 -> ..., ... },*)
(*  "degreesOfFreedom" -> { 1 -> { ...}, 2 -> { ... }, ...,  "highestMode" -> { ...}, "SRSS" -> { ... }, "SumOfAbsolutes" -> { ...}, "CQC" -> { ...} },*)
(*  "wallShearForces" -> { 1 -> { ...}, 2 -> { ... }, ...,  "highestMode" -> { ...}, "SRSS" -> { ... }, "SumOfAbsolutes" -> { ...}, "CQC" -> { ...} },*)
(*  "wallBendingMoments" -> { 1 -> { ...}, 2 -> { ... }, ...,  "highestMode" -> { ...}, "SRSS" -> { ... }, "SumOfAbsolutes" -> { ...}, "CQC" -> { ...} },*)
(*  "wallDrifts" -> { 1 -> { ...}, 2 -> { ... }, ...,  "highestMode" -> { ...}, "SRSS" -> { ... }, "SumOfAbsolutes" -> { ...}, "CQC" -> { ...} }*)
(*  };*)


(* ::Subsection::Closed:: *)
(*shearBuilding: Analysis using direct time integration*)


shearBuildingEarthquakeAnalyzeDirectIntegration[ a_shearBuilding,someOptions:(OptionsPattern[ shearBuildingEarthquakeAnalyzeDirectIntegration ] | OptionsPattern[ NDSolve ])  ] := 
Module[ {numberOfFloors, extendedOptions,massLoadVector,
m, c, k, u, uV, p, zeroVec, eqData, extendedEQData, eqAccFct, tmax, tLastData, fuV, t, dofOrdering, lengthOfAccelerationData},

numberOfFloors = shearBuildingGet[ a, shearBuildingNumberOfFloors ];
extendedOptions = Flatten[ Join[{someOptions}, Options[ shearBuildingEarthquakeAnalyzeDirectIntegration ]] ];
eqData = shearBuildingEarthquakeAccelerationData /. Flatten[ Join[ {someOptions}, Options[ shearBuildingEarthquakeAnalyzeDirectIntegration ] ] ];
tmax = shearBuildingEarthquakeMaxTime /. Flatten[ Join[ {someOptions}, Options[ shearBuildingEarthquakeAnalyzeDirectIntegration ] ] ];
dofOrdering = (shearBuildingDOFOrdering /. Flatten[ Join[ {someOptions}, Options[ shearBuildingEarthquakeAnalyzeDirectIntegration ] ] ]) /. Automatic -> $defaultDOFOrderingForAllMethods;

(** Check that eqData is in right form **)
If[ Not[ MatchQ[eqData,b:{ {_?NumericQ, _?NumericQ} ... } /;  Length[ b ] > 1 ] ],
(
Message[ shearWalls::eqNoGood, eqData ]; Return[ $Failed ]
)
];

(** Identify tmax if Automatic is included in spec **)
If[ Not[ FreeQ[ tmax, Automatic ] ], tmax = (tmax /. {Automatic -> ($shearBuildingMultipleOfLastEQTime * eqData[[-1]][[1]]) } ) ];
If[ Not[ NumericQ[ tmax ] ],
(
Message[ shearWalls::tmaxNotNumeric, tmax ]; Return[ $Failed ]
)
];
tLastData = eqData[[-1, 1 ]];
If[ tmax > tLastData,
extendedEQData = Join[ eqData, { {tLastData + 0.01 (tmax - tLastData), 0}, {tmax, 0} } ];,
extendedEQData = eqData
];
eqAccFct = Interpolation[ extendedEQData, InterpolationOrder -> 1 ];
lengthOfAccelerationData = Length[ extendedEQData ];

m = shearBuildingMassMatrix[ a, FilterRules[extendedOptions,Options[ shearBuildingMassMatrix]]  ];
c = shearBuildingDampingMatrix[ a, FilterRules[extendedOptions,Options[ shearBuildingDampingMatrix]]  ];
k = shearBuildingStiffnessMatrix[ a, FilterRules[extendedOptions,Options[ shearBuildingStiffnessMatrix]]  ];
massLoadVector = shearBuildingEarthquakeLoadMassVector[ a,FilterRules[extendedOptions,Options[ shearBuildingEarthquakeLoadMassVector]] ];

uV[t_] = Table[ u[i][t], {i, 1, Length[ k ]} ];
zeroVec = Table[ 0, {i, 1, Length[ k ]} ];

(** Identify the earthquake load vector **)
p[t_] := massLoadVector * eqAccFct[t];

fuV[t_] = uV[t] /. NDSolve[  { Thread[ m.uV''[t] + c.uV'[t] + k.uV[t] == p[t] ], Thread[ uV[0] == zeroVec], Thread[ uV'[0] == zeroVec] } //Flatten , uV[t], {t, 0, tmax},
FilterRules[extendedOptions,Options[ NDSolve]], Method -> "StiffnessSwitching", Compiled -> True ,
MaxStepSize -> If[ lengthOfAccelerationData > 100,  tmax / (4 * lengthOfAccelerationData), Automatic ], MaxSteps -> 100000  ][[1]];

{shearBuildingEarthquakeMaxTime -> tmax, shearBuildingDOFFunction -> fuV}
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Combination methods - utility for spectral analyzer*)


(* ::Subsubsection::Closed:: *)
(*All cases for uniform damping ratio*)


combineModes[ whatMethod_, modeResultsList_List, modeRadialFrequenciesList_List, modeDampingRatioValue:( a_ /; NumericQ[ a ] || Head[ a ] =!= List ) ] := 
combineModes[ whatMethod , modeResultsList, modeRadialFrequenciesList, Table[ modeDampingRatioValue, {Length[ modeResultsList]} ] ]


(* ::Subsubsection::Closed:: *)
(*CQC method (Complete Quadratic Combination method)*)


(* ::Text:: *)
(*Ref:  EP 1110-2-12 30 Sep 95*)


(* ::Text:: *)
(*Image[CompressedData["*)
(*1:eJzs3X3M9VhdN/qeGOMfDycx0T/M+UPlxMRHj/Ykj8dEUdTGGAjR2T4DvoSn*)
(*8eURC5GXpwhRihClikkNf9gEzhQCFtSGSGGYBqG8NUIHmQYoMzTBQuhJCqQj*)
(*dpze0AEKdGb26Vp972737t7Xvu7rvu77+wkv131dfVldXV39dXV1raf+z/91*)
(*9//8LoZhwv+NYf6h+oH8vAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAC4/n7yJ3/yfwcAAACAO88999xz1aHo5XrqU5/KAAAA*)
(*AMCdR1XVqw5FLxcCXQAAAIA7020f6Mqy/L8AAAAA4M7z0Y9+9KpDUQAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACANQpblURpkShqUbF/*)
(*A5FGNiCqVri0SJl6sihW21Kt6IQk5kkUBOGcIEqyxdXKLHBtwzB03bDcICtP*)
(*2DMAAAAAXF+5xu2fMWPj5fs34G/qBVl1KejMfbVehFP9E5IYqMtJXNhpGds7*)
(*63BmsBwVAwAAAMDt5mCgyx0IdAufbxbUlhbMA60Jmk8KdG1xT+pmA91YOi1o*)
(*BwAAAIDbSJFnVF7ksdo0znJ2nHW/b975l5nvWIZhWpbleEHS/roPdDdGXoW0*)
(*rm3RJZJBh4fZQLdIQ8cyDbJFJ4j3tbXmkWeR3dZsx9G7yJXXZiLnIuwW4J04*)
(*yxNfaoN5Xl/sXwEAAAAAt69cbwLdjT9u+Ux9Y7fdVzRokNkFujuNrWbYbGUn*)
(*0C09fdpKy4rmyo4FiS036wjGbPfhrqdEF9amTrPKZi4wBgAAAIDb3UKgW4ZL*)
(*oayb7Ql0SaQZ0Eh0EujG1nxfBE71DqcxddqQWwgWvpJLPFPVNE3VumZlv22q*)
(*5rXgYlkEAAAAANfRfKBbhFoXicYkcky0ZjFG9bNRoLtRwzQNLLn7hWiSYRZG*)
(*gW4ZdWGuZFaxahk5GjsOjJcVptAsKjvJyqPKBs3R69cCAAAAgNvIUotuHga+*)
(*55hklC7fNXWljXMnga4Ytv12vbYFtW7CHQW6udeuLth+4Pt+GPQjJGjBvq/F*)
(*+s63nJq2v3MUgdt0uI1oDDcRmH3UPVgLAAAAAO4oi310fUNmmRmjQHejdyv1*)
(*ESn95TDQ7X6eRTa4qLREtm2Y7SLWnVEjOK3ZRB6p/CDVnHxgQGAAAAAAuG3N*)
(*B7rdl1wEu5EUVWxjy3Gg2w8vlnUD58rudhro9mMmcHxDoPiN0H2/Npe6vil4*)
(*0MOhS3OXQjrgWBkNRxjjFRtD6AIAAADcweYD3e5LLtFsBjFwZG4m0B2MUusp*)
(*XBfZbiddF4puggm5a5ZNSBcGIl6ewCwy2769gjVeqMzzvGhUP1V/LLq23yrI*)
(*tfYEzwAAAABwR5gPdIP22zPR8Isy9y2laylVq+WGH6OxguX5tiZ0v6j73E4+*)
(*RuvaWjlRC6LI6YcaY53lhteu3+/BD8oG4+iSnciSKDRNxrxsYhxdAAAAgDvQ*)
(*fKAbmQKzQHHTfgrgXZumu+xkeLHUVWYX52RnT9q6oR40/0ALbd/2u7uLk6Zm*)
(*AwAAAIBrrgt0+XEsmRri4IuvjaQpbejLaXkRdv8Q+H4xllfjtodBF+gKRtOg*)
(*mvgGP/68TTK8xV4Lddr42bTNCPXFyBzj6AIAAADARJ7EYRjFSbo3HN3maRJX*)
(*kjXffpVpHIVBEIRRivEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAblUlmZM7r6flBoCbD9fg9VOSU1YUOGWXI49NVeJYMpEDy7Lc*)
(*RlANJ7nMEW4jWxOlihosDLtbhCa/4Xl+I62duje3JJ6swMvB5aU8C1SRJlyS*)
(*RFENBzuKrMFfFPvQ1BaLmpyR9WjFUZSpJ1d7rZJiRbMLFJEtCU2yhmRZNZ2D*)
(*82/AKrFnSvyGzoJCrh5BUu3gwFzVl+1gwbg8VW6Im+GUMJykWpdamWyPvGpW*)
(*Or4KWnDr1a43obY8W+7tFXS17qSoF2FfHQuSFZ1S1cWOXlWUsiTbZyxVq8tq*)
(*bMnTeY5WF6T11+Deuqsw6XRRvOKeeqynKiKNnjvNiZcWIdm4c2dTVN3x4/NG*)
(*iQevprNUtkXiqyI/OGWsIOnBgbkL4AiZb4xnKusnQrPPXGR6fjutr+LNl55u*)
(*SrXVU/d2MwVvvEsL4HJfHWaQFnR76ucpponW1kybMetgzsymZymXcl9bmiqO*)
(*rqYs1iOwSmqI81fPRnGusJI6WDAmYlsmdzqG1YOLXDzZaCLFcX5Y4SU+Vx11*)
(*1cwrI7mKISq8Xif0+Cpoxq1Zu569ttwtP2fJvUMybVjcOK2vjoNRvaf6K0rF*)
(*TgHw1c0Rq6+2qqymDj0y1kqaQrK6IK2/Bg/XXbEl1b+5WLVwvNxv8ohVF/Jo*)
(*fOoneC09X1oOxypHVrYzWwj0pUPRlx9W4QiJPSrrLDcu+sIlFfBAax5eluqQ*)
(*rqbi9ZVT93ZVN395LbqT+rNPWxEMH8aGVe6xDubMbHo2S4FusDfQJSt6p6YU*)
(*SkcaXS7c+OpZXXTP72DBmAi07p5++gXvKcN7DyuIkjBqVtpc3iuEo66aeUV7*)
(*b20v3uOroB23au169tpyt/ycIfcO62aunx5LoI/q41WlYqcAnKFQzVmx2dKi*)
(*ISgr2s0vVhek1dfgyrorketfc0sB5+XozsVm6U46OfU7ROtcj5HrY5WVle1U*)
(*GUuDU8aLksgPT6IYoVn3ogpr8EynunXzXhlayqC89G1+SeDqGqGquu2Nsr/I*)
(*6Py/UZyX2yzybaviBAktpGUWeg75txtk7Tpd4dHDvEgCurzlhf1zWJkngR9U*)
(*2kmCC7qDOCWbzAPXNk3Tst0o66rpMgmrNfwwztct38jjwDLJH13yyqNMIiJe*)
(*mJm4LtJ9lvFGk7iwfyIjfx0HunvyrVm7TV5cbEN957IqM9+xDMMkeehVmdpv*)
(*4IhAl1OToiyoPIsNiet+P7h6i+pMGYRZ7SibJLRIq2Toul792XL8QTKKuM60*)
(*6nSXWZXVVTpt15+uThZMXMtQVZITmmFHgyWG5Scn5aE+Izsv9xbTcJH0n6iM*)
(*rcGNQYubwh4ofQ0sDdtalotBW1aL+lzb9cVSF6EsDutfBHF/ooq0yXKSXXF9*)
(*+dh+1C8wWzCKNHQsk+TOaGtlnmd2e9dTnCjPu1zfm58TqdNdF5xodO/cEk/v*)
(*f694dTrqxPfXYvOb0XVXVSNVYul14VS1wDFXTVMgm2vfsavkNw1jey6lyGLb*)
(*VEZZXv1lpwpqzpVXl07L9oJ4b5B469auJ9aW87k3X36Wcu+iNcBIHe30maw3*)
(*nckKYxTnDkOUxSK9WwB2srG7TUzO8+JB9TvdX8OPlUmTEqM9nLUFafU1uL7u*)
(*Cg2h2e/+dyXLV9bKM1skYfunpG84Wmwy6gNd2YlLcmcr8zTUhO5A+8bw7f5b*)
(*8KHq6ODVdExlO3sobVRfPbC0aShiuwt2m1J9KJ3H1hJ3kO65aVzlVtzmQY5h*)
(*63vTNtF3X3NwcvcmxFfnXyTIxuT1iFjfv7vCM92kZDXNKe3rgCYBudfugN2M*)
(*dyXbdcpztdkRfa4/vDxNhiEN/9Qt2h711E4DqRDSYhO1tUF7GN3leSDfqi2O*)
(*H6zZ7l91NZj6xm7OioY/Sc/hQHf8aFz4bSXZ9rIoU28npZzRvjfJgplkyHWX*)
(*pD6rh/ccZvKmLB1UtoMthNPyw473U9102gtzXxoukn4qNETSTsJyur/2rVfQ*)
(*91aRRn2zsu52w7rN/vcWg0EGssOlNrKhicM1BCOYZtfYRm4vn2nBKD1dnCzM*)
(*imY2OX3NH8izz/783JcbrDzpoBxb3a5JTR60Lx27V4HTi32b9g9ig+T2ccH+*)
(*q6Y7IpYX2kY6L993KUWmMPl9lbadVG0TV9s5i4KTLNw5buHa9YTacjH3FsrP*)
(*bu5dvAbYMW3WEwy6tTKcnM66Lt1TpGcLQJ+N3DhJG7Ur4fsP6nBZndN0meDU*)
(*9MiCdMw1uLbu6qJuRjCXHjr236TWnNnAHN+Iu+blFYHu+CVU2wRNWqHqs3Dg*)
(*4jpYHR2OVdZXtrMKv92BMPzqx1VFQRQFQa7bjA6m89ha4s5RhEZ77DsvsKoH*)
(*coo+PhTW9Lx150+pL8alwjBTPPYWHqZ9aTItPH1h2FUXj67k015nh5efdrgd*)
(*Ohg3cnzzdsEgD6alRR8kOUFqXhM1l+fBfMsWyiZBqsEyXDgKrq6FjmnRHdYY*)
(*pa8Lo9+X0UJKN2RHoxvHMBbjnHR/VjflqozNpSUUNz1UHnZvXjtpuEj6xwWY*)
(*W3jG2b16uoeb3ZezeUovnrRpLjtQDOoMXOiBN8bVldye7NrMXT7xQgo41duN*)
(*Ckigsj8/53RJEoydLzL6WIi8Od19FThJbWjMHx0r1x/FHLpqZvKzyrd9l9Lu*)
(*PYIEuuNUFdFCGW7rwGn5uIVr16Nryz0VUTpXfnbO6RlqgBndUXB8HaALZkkq*)
(*g3pfG0kcdLLdW6RnC8CeJAlmtOagDpfVGWnd+6CriFYXpPXX4Pq6azsIHRd6*)
(*uRy6SR08s9nyjXhdoDvKxq5L7Ubzj7q4lqqjY2OVfZXt/KF4w8c1XlJM242S*)
(*adm4SDqnKVl7j7tNLDX3TVTPdF0WyaafFXk0aNmQHfLs2GcyK7pxGtr9WxVW*)
(*0OM8sfp35aQJcXhSFDtMk0DuTzbplLIn0K02mBRl3Keh/p6ir7r9fM3yRf8Q*)
(*z0pelWanP6iDcSOv6PUB0UfsWGwyp90kvTwP5tuww4NouEkSaEJfLVbluQj7*)
(*jgf0LWmija/u4/rochuOGoYAiktOX39tcpKfFmUedSmp6qJBOakbGQqzfUSU*)
(*vWx0l9yoYZL69HvhZnXyWF3a3SMlJ/tJlmeR3r1jYpVkVB5YzUvKIu5eQtWH*)
(*tj8NF0o/1d3plhrzd7O2Oxfa3ifkw5fPIANFzU3TcPACkdWrohmYXbGoz/v0*)
(*8on9wSokMhkVjMEtXjKrm1UZ9UWd3LzKMnfb9RUnLopif37O5oa+LzfiruXJ*)
(*istDNXa/KYV+c5167X2QdrM5eNVMwjZRIe8rP/vQvkuJDMSUOJtugZyM7zNO*)
(*1agMB1k+qE9GL0n7HLmFa9dja8v9FdFu+dk5p2eoAfaWOkFv3n2IVYlJ6tK7*)
(*UUytfe3uH6giZgvAIElcdRkW0yQdPqjDZXVX5tZLyE2ovLYgHXMN3lhZd9Ul*)
(*tOuXos11sj94kzp0Zgf9TFipivCGN+ITAt2wa8PhjceOubjWBJCHY5VDle2c*)
(*UdeUAVaQ9bDtanBEOtfVEneOlVdQ10un7xs/yNVJJrfvVrI21mm/6u2609N9*)
(*DZ492/tm1j3XkLp3OdDl3CatxaiuXqy6F5bvPx8jN996iaT9yPRwoKu7Fr38*)
(*Wckpmtc9nB16w0D3YL51P7dNVdsuZm7Kc5mHge85pmG5ge+aeh/OnBLoztDr*)
(*xbrviwXNrvboB6GjdDc6/eHh0A0sJ6k66UkVRFmWke54gzcv3YU8eqwugrbq*)
(*qUKCNmX9WqNWvkE7hj48tHxvGi6UfqrMk5CKkpXvdZbenU0dvnz6rJDqi6fo*)
(*Xhy0udHdayb3jq4zw+D95s7l07cYCLZf5Y4fBn0HsPpON6hF84PlYe5o+4+g*)
(*526dXbsW56QHA91tdSp837UMw63+zzYVsTuyUdWxeNUMwjbNa1tbD11K/Vqb*)
(*6cdoNFVJHye0Ya2rSvTdouReINC9ktr16NryUO5Nys80985RA8zpA13XN+sx*)
(*spy0cOnFwimOb/SB7uEivVMA+iS1CRgl6ZiDWiyru4fUVla7OXko0F1/Dd5Y*)
(*WXdtx/kwH5mvLhvzZ7avuPr3a4OnkqMD3e47RE52jrq4DgaQq2KVFZXtnMzR*)
(*pNlgl7xxSOfPwlI6V9YSd47+3T038/atpLaDDJTsvuNPdy+uTn8xWKY9ld1F*)
(*137mOe5evrP8dlC1kl8uBrr0SblO/qpAd2n5/vqSum5P3auoFYFuENUXI6e4*)
(*zaOTHGfzx7iUb5/sF+h7XrntZ7N1efYNebb8Hx/osmRUSzp25nCDNP/HY6NN*)
(*VE9/C2/9BNUthqdmEAL1+xWtoh8rZthzrK+pjLDo8qp+yp45tH1puFj6T9Tf*)
(*VtrXlEPtxbPm8jkQYo02Mrl3DAe4a/OTNaNiuIX9Dzs7gUp2uDzMZYfX3t9G*)
(*3QiLyLSCchyEH6yxt5kv83NvfKeX1cJV0wcbYjiIQPdfSv1aO6Mu0PtXdwj8*)
(*yrEjbuXa9eja8lDuHTinZ6kB5vK43QIfpGF9jSu2W0d0khN3fWBU/0uHi/RO*)
(*AdgtaScf1J4afnpIgTb568qCtD3iGlxbd23H+bDYqXhd2Zg/s33Zk/tEt83a*)
(*pwS6c01Jay6ugwHkmlhlTWW7rIhD3zZ1eTSgbvOcdXw6D9QSd5BmsD7CGPf4*)
(*774MrSK6rnWu7phU6x48WckuZ87CtJ6cVCNzhac7L+TJbjHQ7R9G1gW6S8sP*)
(*PnXs7oYH2xD6VGlhEdVdp9imL4BglV1vJXqMB/Ptwe4RrF+g7N5iVDmZOn0f*)
(*gCpQlRS1GyLx6EB3ow+CuqTrOUZ7GeWDwXi4JhzmBYrn6y73ZWJpux8I0Rp1*)
(*NtBtK2cyfFmf1cPAo4umODvpW/m02RahJm+W0vDZC6X/VK7cbo/2DOz1LwvI*)
(*u6rDl8/+EItaEehm/cio2XZc9/bvT6e5sxHMMN/Z/orysKNrMeuLQREp0xzn*)
(*/WIm8cXoeBNlcNfcCJKqjpp3gkNXzdy1vz14KR0R6PYDvZRFQf87Wz5u4dr1*)
(*2NryYO6tDXQvWANMDQLdIq+j2rY6ZqykjPrxDb50uEgvB7rzSTrmoBbL6u4h*)
(*7QS6KwvS9phrcGXdtR3nw2yC15eN+WwcvM/qDq7v/Hx0oBt3DaNVnh91cS1U*)
(*R8fFKmsq24ki8TRVrf5juIMHpjJz1L5pejYZS+lcWUvcSQb3FE7ph01J3a5W*)
(*EK2of4/A95GM3UYNC48ba6vifhzX7iFuf9cF7shAd2n5wTc4UvP1fem0nW9W*)
(*BLrBtgyGjQS0/3/7G7rTg/nWffpaXXHt36PuOh2+bhPb2YUcedQacNTHaMPq*)
(*YOf1TbMjuXt7VCR+LYgf9k1ZUSt2mBVZ7Fp6N+0ON6qp+saurtWCo92Wuk9q*)
(*+7qiHxmSvFg5+Lia7k3DhdJfn/s8S4kjBl9J3b6GV/oWm9JV+6unqroPXz4X*)
(*CHR5rT3vg8vHy6e3kq7pqWu+SYIme+Js1K6oBcXB8jCbRcMavpkMK+urkXb/*)
(*pMbuSnXX3ddTB9ddHz9IzTfI3ZfgTdVx4KqZrc8PXkrD57Vi5iz0XRyNZmCk*)
(*4lBHx1u3dj22tjyYe5PyM829c9QAs4WuS2RQbsNRo61QVcfhYJuHi/ROATiQ*)
(*pFUHdais7h7STteFlQVpe8w1uLLu2i7kw9D6sjGfjX1Tc98pqJuoYk2gq/U9*)
(*XzO77z7LVud5zcV1oDo6NlZZUdnunPHuWzx52OySuU0nW1ZaUW0i0N0rsYfD*)
(*emwU3TBGfUVor8v+tDKcpPthYCn91aNP+/gdVxWTfahW4Nv9AHj0afTSA93q*)
(*ehwcqKioMt//83CgS7+aGX5Rq1dP9eV4yPFD+da2CdMNymYQOINe7qPKWTT8*)
(*osz9wcCJdTV46qgLg4tXqz8U7YoBpzlBFDp973jZ7T9J5iQvzooi99oO/6Tb*)
(*1fDbH060XM8cHGb9amwwjDmnO37oWf2X2ryRH6wMh2OnzKXhQumnumX6jliH*)
(*xaOLR1RM0xiWouaL5oOXzwUC3YqoWp5rDk4B+eBu6Y7MiVoQRU4/+g3rjL+M*)
(*FnUnjJL/b29+LuTGaPBSlpcNy5q80TRpi0XSNwGRwjBIzOSNsOinRZ4MvrOj*)
(*7Y0Hr5rZ+vzgpTR4hSpWJTTJy8XPqRjBCcNBsoVw4enolq1dj60tD+bepPyU*)
(*O2X44jXAnEEii+ogBh/v8/qkJXx/FTFbAA4m6eBBHS6ru9ryMOxUsKogHXMN*)
(*rq27xts050Y1Xl82FrJx8FU4w5ue7xqDJuIVgS7LbXa75NWttWsurgPV0bGx*)
(*yorKdqIczgbCCrrtuK6tK4Nk0HOxPp0IdOfk1lInaDJGdHOt+UsjV4hW+/C7*)
(*mWSydqAqXuwypY3bKrnlQFc7MtCdJil1lxKxLtAdVnT0hebOTg/lW7EzfGOv*)
(*ysnd0R07dTV4OND1lwLdvqmB3qXThWFwyNdDw3HIp4n0ph+5j9duh4LMl5Zh*)
(*68pzpjL0x4e2Pw0XSX+TIaMm7pWK0Fy8eDb9NJQHikG+OCfXmkB354hmCkbq*)
(*KrML1y/FtsOXnkw9PNTe/FyS+cvFmW5Y0KsYqFwap6u5U+wMV9XvvB00Y+9V*)
(*M1ufH7yUJuPBDocX4/YOkNU3qs+4RWvXY2vLg7m3U352KvCL1wBz2Ts6ikFU*)
(*Q964Tbd5qEjvFIDDSTp0UIfL6oxmeLFBI/DagkSsuwa3q+uu/uOInbF5awfL*)
(*xsFsXBy4j1kV6M4dpNw1Rx+8uA5UR8fEKisr212LiSSaHh3r07mylrjzlIGp*)
(*TMs8J9hhNl5GniwiqM7gPiIOT/1glFF+msmb8YgE/GC8laqKdKbd/qW6F+VM*)
(*L7JuUA5+HOjyC73OJsvXuwm1ruM3J6qKMCw5uwZdF8ZFut7LzE4P5BudcHyQ*)
(*ARtJlboeTdnuX7U2hXVZ7dKz1A5ZPS22HdJHZXswiEF7FZRJ9Ug/Signee27*)
(*pDQw+Z0iotrR6NRUOTg4maygjSaOynx5UmGwgh01idrtx1XGzUDlmzaQ2JeG*)
(*i6S/ToDenbrjpnEsU1/Z2bSg2uN72N5i0N1K2p513ciZXWIG+TP+kFkQ918+*)
(*XcFIfGOSTMnwBpPbOX0zRT1Z3t78XM6OxFSmNz52039aZtUjELnDTzZ4TW+e*)
(*GOt2pGw8/ryk9fMdtXX43qtmrtP4wUupygNX7VNe7WhaBZFpR8xJEZaMg6Xl*)
(*Vqxdj68tD+TebvnZzb2L1wA7xkfRhojMTO/QZvKDvUV6WgB2k1SFZNMk7T0o*)
(*an8NP6Oti8ZTOawqSPWCq67B7bq6q6uLlgdfPVA2VtXtk0teVXcK5MR8oMty*)
(*vGJMnsUP3oIPVEfrY5WVle2syNF3TgXDy8bwHro/ncfWEneoMo9D36M9ScJ4*)
(*odWmyOjALIEfhMkZZ5Jr5q6Ld6bnvVxp4JK3BI4TJM2Ou14x3DHNeocdyrc8*)
(*icnAVgvZTv8axcmeprSzKfM0CkMycefMrIVlGkcBFUZJf67Gfduq1NJJCeev*)
(*pKwqZGRiUD+IDsZM8wmcT8NF0n8OeRq3/f3CdGly4fNdPv29IyzIlVtPDXl4*)
(*kyQHQnr8s3Nc51mWVwYfV+3Nz+XdFFlEu6VVe4pTuiKZH4rThxOrVVlWlel0*)
(*4aInBxXScrQ8Ldbeq2Z5lb2XUtHkwfI2i5jkBzmRR8wifVvUrgdzb7f87Lpw*)
(*DXBRB4r04QIw4+BBHVdW26Zpfbfv95qCVC+45hqs07a37nKaHq3zg0WPD/Bi*)
(*Nyl6yYdk5u5LKBcHL6791dFgO6uvpgOV7ewqWdLcochas/mwMp0AjbwbYqV6*)
(*Bjdsx9L7XkvD0UjggMELkTtqGOordHDAHwC4vppOcaJ1Jc8Cva43yJWnBABO*)
(*kg3nERjiFIS5Ryj6LqaIum6One5YAHAbaVsPtJ0G2JupHTxnceJvALj15ZGn*)
(*SkI7Jy7LbQRF3/e1DcwoQmnDbfjNRjTv3J4/N1doStxmU+W6MTcwIwBcd6ln*)
(*SKJkeLsTOtwsZaRJxFWmAQAAAAAAAAAAAAAAAAAAAAAAblNFkedFsTSPPQAA*)
(*AADc4gJLFUXa41wUVWswQHURtn+QREGyolO+eYkdXZJlWZLtuakDTxbZGkmZ*)
(*rO/famzJdFTloFmlOZqeouqOH+8EsoVvqcPZBFlO0OygXywL+pwR1XCQhsga*)
(*/EWx821h0pG0eWVp1lQAAAAAuCSZNpyPZDAxXDfZxxGjGJWRzLEE30xI1M0L*)
(*ed5BkPx2bCXFW95s6nD9MNfjw5zgB9MdbnODX1hMMJp59YYzqpPhX/o8G00V*)
(*SMfa6iZYnxn6GwAAAAAu0WQePT5o2ye7GVGPiFQH46nWUd0lDWu/YrNlPX8l*)
(*K9bThe+dF5vpR8Pu4lJ6FLwkidygaVcwSYv35BGgnn2PHn4wyrImExK53kI9*)
(*rSoAAAAA3CR1BNgHc3rzJr6YNGwOQsoi9ByDMB0vGE6ml0fNBNYMp0QZmUOx*)
(*i0j1MC+SwLZM07Tc3d4CReJahqpqmqZqhh3NzNBXhK5NVrbduNiG+oFAt0ya*)
(*lBjN4fSBruzEZUl63uZpqPWzszfzG3ZtxbwRdLu25bY5mDeKNtDts4z+kiZR*)
(*737H9oFuP1O2uqf9GQAAAADObNrUKRgh+XUZCqNfNyFlmXoiO/4Dwxl06pbI*)
(*nKxB+hV0gS7DjbsObNRu6rHU06ebrMJRKxykMZBGS7Ddv5YC3abLBKe2fRL6*)
(*w1T9YReCtrmVhKtkj12C63+2SzkiL4iCIBv+dqdFt8qzkAbmkTHOgTbQ7aJu*)
(*RjAxPzUAAADAzdJFgBy/4epgrCSdbc06HpXEQSfbMhJ3ItJ6MTerYstpL9hR*)
(*oLuj7gZQxubSAopbR6nZzoZ7C4FuWs9byCnezmFOV+macDcaCWK7TsV1liia*)
(*6fpRNg5Pu0CX4/k6aQb5KK60aPswJ0jNh2x9h+cunO57hgAAAADAJesiQEHX*)
(*6jBWjKvIzKI/bxRTa1+7+1lstXEuJ/lpUeaRJjQxKK+HZVHkidNGzWqck3G5*)
(*BoEup3txUcRdb4GNWgWWpd01EHOyn2R5FulddwJWScb9AUTDTZKg2+lioJu5*)
(*9RKym+4c5nSVUG+bYWkPhCKyZiNqlhN0p2647QNdXtEluifRqvIsrnNHNtum*)
(*7T7QLe22SVrz8UkaAAAAwM3RB7qub9JojHXSwqWBGac4vtEHul1rp6DZYeD7*)
(*QegobVC6ocMsFH4T126mH6NxJKwlusCVBLpF0EaZrNV1Zeg2wmyqqLDbAit3*)
(*I3TFXcPybKCb+1r71348hKVAt/vmjpOd+jdZaEub3c4UdZpJE3Ef6OquRTOK*)
(*lZwic+g6nB16O4HuZX2UBwAAAADLugiQD9KwDiAV2617C0hOHBpdhPYlbc/A*)
(*BXQorT5G3Rl1QbLjZn9tlEgC3bwdpYGVk5kkkU/JdrdQcRVuX6AbaDt/XQ50*)
(*2+1v2lC8VqSx79q6IvOjjhMbvxgGukFUt3Jzimsr9HdynAWTTNgi0AUAAAC4*)
(*AoNAt2iGkGW5ZkgtKymjfnyDLw3GG+P4hkDxvGSNWnR3At3ulf18oMuIYT/Q*)
(*QjcaLWcnZbcF0ewms2iGDjtHoBt3n7nR7ReeoamapqrGcGCILHK6Q9eCvD8E*)
(*LSwigxnmmWCVZYhAFwAAAOAW0EWAm6DchqNGW6GK/MJBhBa0f5Wdtu9rkfi1*)
(*gAaGfdcFvf7oajfAGwW6ZdSNWttPu5DYXX8Ij3RdaBt9JbtNc9RFpyd0XdD6*)
(*78EyW+6Ol6XHlKntlocNyN3XbaSLRVwMAt1gWwajLDOqPGt/g0AXAAAA4Cr1*)
(*ga5fVIHqYM4vXi/HEdpgMgVOc4IodPqhxuoOtF2gy4qOHyZ5eSDQ3W49pesZ*)
(*wOnVOp7VD9HFGzn5OszofrGRzSBw5EFkuf9jNGXuYzSW29C26FE33CqKpi24*)
(*/VdjDP3WzPVc29TFfo9k2ITxIeTDQSH0sNyW01kzhoMSm2edChkAAAAAlg0C*)
(*3bwPEZm6uXLaFJkujPTFOSmNE3Nv+Pfh8GJ9oOuPAt3q3wsDkLFtTFjsDNDb*)
(*2z+82KAReO/MaKwcdR0VFtNDSGR0hT2xOu8XM/03+mHZRl2RAQAAAOBS9X10*)
(*6Xv+7h19E0MOOtnSkLJMDHkcCXKSl3RhYuGqfVRKeztM++gWUT22QzNuLZH5*)
(*8iQKZQU7Gg7DlRriIILeSKo0TtWOdiwFqe3XOx/oshyvGE2QPsiSSJd2ol2W*)
(*N7yd7+noIaSu0iZMmx16ogibRunBuL4AAAAAcCsq8zQKwyAIonguzizyLMtz*)
(*MgPwEbI49P1qk34QJbMr5kkchmEUT8PShc01TdN6cOK4tWWRReQQiShZt9MF*)
(*Tj3YbjvLMAAAAADARTQ9CkTrioPLrjfIlacEAAAAAG4PbRcCLbjKgQ7aIX/J*)
(*LMkAAAAAAGeReoYkSoaXHl70kpSRJhFXmQYAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAgAv7kz/5k98HAAAAgDvPhz70oasORS/XH/7hH94FAAAAAHee97zn*)
(*PVcdigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAABcW2WeJkSaFVedlIvK6iNJkvzaH8q2aE/LbXAspyqLohz++0Ce*)
(*lHlz+pO0nPv7whbK/A7OYgAAuBMVgcAQipuOfp+5PP29FuT71iY305TeO3Nj*)
(*w3Caf3JCYktimI0/t7cyDTRZkiRZUXU3TGeWOKwMTIVlepygBosxwhkEepWv*)
(*vP/YvmWqzDsh5C5iR+SYIVFz9p2kY+w5C0v6oyiCqswY4d5jnihiXdqc/1iK*)
(*UKwOY6Y05nqVRF4/bRcXOtJ9CrMqLILV/utAnoTWqCQzLG94yXh7S1tI5Cpb*)
(*9OBMyQYAALjlFX4d0DKCOQz7Ykusf6362Z61fbUKuViP3ERzjWM49fRA19c2*)
(*syFWEdtNWNfe3UUzOnLbpaPU9/2Natqua6tNGMAHl9a+FdxzF8PctTfQzVXy*)
(*gOEdtdk8MOpM4CXNdhzLUJuAhtf3nafVls7CnhT1R0HDv7/dW2BGilBqIjXZ*)
(*clzHNoT6TIvWRZ9Acr86jLnSmBsCCfVOCnQvcKT7t+tr1YatmB70oTzx1Pp6*)
(*5WTddBxbV+rnVEbqLoq9W8g8pfqLc9rDIgAAwLXTBboMPwhvaMMXpfV38yKJ*)
(*4zhJ8j4KKT0SZ21c0qZLA10tqH5ZLRZF8SSWKNI4DMMoTiYxTJ41bcKhwc+F*)
(*WKVNIm7OCEgyytSj/1KPijCKiAaHnBIN9h0aIo3uu/Agi0KSwGELa/s6uT7w*)
(*Zp9VeuMo7hYrS7pImVcH3S2z3Q10i4xsIx0kvEyqpwRWcQeJ2s3hiZjGMGyd*)
(*G/12aLAr2Umd5uE78PG/qlSQPcRNI3xv7iyQLdEjS7vjmll9fBRNbnR/i6pM*)
(*jZKFVmufppvXhqF+RgLtYSQ2d176hMVx2mRWQU9LW7oKEujSpsu8KotRPGy7*)
(*b9PY5lReHVRUJXLcc+DII01jkswqNf2v2sJDErZzOQyk5GGRN4oVeVKEbUke*)
(*5EYeWTSS5bxsTa6SRl1GtC/xZQYAAMCtg4YEDEdulZLTvgBNHba6L264rkW3*)
(*iB2hf13KqjaJD/3+DSrr5jm5mfIi3/9ODpu7e+GoPNOvLbpNPFLYyugF6zjY*)
(*rmVqtUFOb2/sBf2nRm/pub5Z9RqaRuOMHo7DrTLWZUmjB5J6+vBdsGLX0S8J*)
(*3Rle6voJbCRVEbsFeTcp2tzb9F0JeLVumRsGuqEl91vnRK8Kuwp/mJ35Qg5P*)
(*z1Wok2TsNlSmNlmVNFTmGlsFY+0Cuc/1r6pTY9TjYWNF+b6zQNflJYkmSslm*)
(*V58cReH/EsPcE9BjznxpsDiv2NNgtwxpW6QUj3+dh7YsyjZN2/x5oQljhS63*)
(*WFnTuuLFiiYtr/6gwNXpVWlwSM8pLT9+HfwNTp3WdAA48kjzQB4svpHMrCs8*)
(*G1Ho/sRKs52Acp+0EzcdhA7kSWbTs2FE07yMSDs1fWpbkauJfXTvFAAAgOuK*)
(*hmq8apJgp21WikzSw9GwyC2YBLpFfffc6G4Yh04d65lxmSehLtK4wQnykoad*)
(*JAJR/ShyNLJG/e44MunPkhFnWeio9K4vJ81equU1PwzMJtbaDXS3RV5/QFMk*)
(*ceTSfrZs8xo3J62PnHbojk0j8GrLS70UaFRfhQlOmKSxWx+dQWL09ohE3Q+9*)
(*NhjcGK7vmUpzdG1AxclWnCa2wtPAy90OAt3MI4fM8ooXxYFND59V0mq3oSM0*)
(*G4/LhRyepDSg7ezqTIxCk0rit3EHkqJ/g0/fWVcBJ0ln6BobpnmDv3gWukMT*)
(*FcuNllYfH4V/V/NCP9NogCdbQRL7NFd2DqfpXbDcc2PpvLQJkww3qFNCUqZ6*)
(*gW/Im7bEdufFCOPIqs+L5HQZVaU8aKLj6oQGgaNzTPPEcfSR0hQoVpBlsUUT*)
(*QDO8KTwkYWFoq/3lMD2ndV+RYk2e0OCZkePdvyTkSYds/2CubptmYdU7T78L*)
(*AACAW1od6OpBQKPGprctufcacX1D9LM6FtK6/qwZiUA2pJfCNtS723R9Z5eb*)
(*RuEy5Js7e0a78SrdbZV+7sRo/udpzNouX3+Ps9zQlPtK12gm2DO3+mV9bDOL*)
(*Ro+s3X3NkzncKFZpUlgEpCOl4tbHQduZBbNoWnSV9k173eVDDMsu0KXROCN2*)
(*KY5pZtJGuUInQSnJxj05PEoqDarMnQa9wTEuB7qBJctGm076upwExsniWaDr*)
(*spLdpGh+9e3wKLa0nbMK/9qW5zbcSkmW6pMGzbp3wXKn7sXzMlqxpNkrhHX/*)
(*EbrfOtClDzdG9yKAnspqsWmga7Tt/LS3uVCdgSOPlFwjvB52qaxLe9IUnrZl*)
(*lTa0zga6tKeB2HSqOZAnyyWZ9hneyZwF3cIAAAC3vfrOqIXb1CI3Zjvd5i4J*)
(*4qykjJqwoX7Jy7A1rn6Hy9GvcoL+26W660IXWrQR104TUxHQzd7/L5M7Mg1s*)
(*lt+okj6ukW/X7WSce0RzVN4GOZPfk36VcVp4CtdHGtthTDI6opwGum1ratuC*)
(*2uReH5GG9Ciq54Uu0K0zr8u9OlZXSHtaH5TuyeGhOjabGweDtqCSrsuLgS4Z*)
(*d8LWRZ7rX8FvtDyfxkX9WaDryv1YHHOr06zo99iGf3Ve7R+vY/F7sSIjPVrL*)
(*7eJ5KUjXBbXdeEC7huejc5Rtd84LzbrqvAwD3UFTavtP+qB3oSOlGVg9ME4v*)
(*B33+U026WBe7HsgTujCr7H5JVkYmM2rRXczVOvGHg2EAAIDbQxMLVSFBRhr3*)
(*RNMnLa6sk1X3+yZsqOMrQdENnTIM0zCckMSao0B3dCsfBbrDu2rdNFoHusMA*)
(*eD7QLRNTU83B6En1m+X9Y0FM1J/nGNHk1blHIhnRpv0eB30a+/au0RH1QRT9*)
(*VxMvzQRUm0mgW4fm48wzvKQYbn9PDo+STPtz8oPhofI4IEsl5CGFflY/CXT7*)
(*tjsaNzLsRlR10/XoF35toDt/Fup4sj0f86vTJKwJ//IsKyYPGnVv0r4xuUF7*)
(*kDKKny2elyZhWZvhHMOuCXQ3dfw5DXTz4QLknxc8Upd02K22s3A5TDV9hvNV*)
(*efKwMe0EUkY+eQ1AH6/oCIGHcrVO/MKQFAAAALedwV0v6IZaoJ0Siy7Qpb83*)
(*upijCKTNRnPJvbQODwL68frCnT2RaffBLhSoWy/Nz312PH5CYcx2Xcg9joaj*)
(*3S/q7260Y76lqXvJMrw2aAorHdqdUnZTegj9Z/5lbLXB5NpAd/BBXPPmOt0O*)
(*WnTHPTcyT9vw9fgP3TgV2z05PNIMesxZTe8F+gU9+RaObfOk7nbSfLtXv1in*)
(*Txl1p1mxTQZ9qKnSX0aLZ2EUTy6svh0dRf9Cnzbady/06x4Fyk6nUBoTMqIx*)
(*6KFRhLQvLulQvXheVge6jGC056U5C+n2YKB73JHWexyMd5e2y68MdEuHxPP9*)
(*MHf786QpyRutKRmxSWNynr4naFq/92+B/jNoh6QAAAC43Q0C3TqW6G7cfdiQ*)
(*ubSRS7D8KA6d+mt6MyZ3TdpYyqqWl5WLd/a6Z+lGNqM0DSylC6TriJeTjCiJ*)
(*7WZYhvrd8VDdx5URVJvs25DpC2WRtmmtHXWh7XpKDsFwPN931fpjeFautlO/*)
(*9mVY0QmTJHLqSJLGV4cD3az96GmjWHESGnR43nqegjrQfeCxpk8yJ+pBnAQ2*)
(*6dtL+3Bu29Y8yQnTPTk8UW+NZIFmeoFvSt0LdjHttlkF8KYX+WbdaYKmp85G*)
(*zvDCOHTrr8MYVvLTYvEsjOLJxdVHR9GGf028R8aO8KPApuMjcDtnlgT9TQol*)
(*zfV9zzGa3dMW5sXzsibQzfuPBKMkMuU67A0HX+3NB7pefuyRJnWJVCw/TSOD*)
(*njl6+awMdOsHt74Hxf48qf7cPozyukU+ohPa0990Hj68hSZj5z5pBAAAuO3Q*)
(*N8LtHFL00xtmU/eAzWm7nE7HCEt9Yzjikuo0jY8ZHeuezhkx6YU4vLNn5nCe*)
(*pk037Fg2GMeJk2SefMY186HVaPgmEvk0EeCBr8zGMlsRBlupwgCjG9I3qgdD*)
(*aFOi+2mz/VGgS3JDGwa6glU0gS7bhZtVQFuvTAekrVvqClcb7JoV26bN0m4O*)
(*jLT3LuXwrtjVB7lJ9rnZ0LBStAo6v0b3141EhkNrPkbzjb7TKa/odQwne4tn*)
(*gT4BdfHk8uqDo+jHIiDHMxiji9Oc+Tk+ytSX+wHpyEEoVvdh18J5aRLW9dHd*)
(*TProknPUNn13m97IVt6fOLN93T8IdPXmwI890jJxxcERCKpT7BSePYFu/XQ5*)
(*nJdwf55Um6rHcOj/vGmGSJPbjzT3byEkoTVrTwe0BgAAuLOVOZ3OIJ1MZ1C2*)
(*43/tl6dJTIb0n067S0brj+NDE+GSD8fIwP/JhWbtLekXbZWZiXeLtNp4dYDZ*)
(*UTsYTEyQ0LxZXDCrM2+6+Srz+ikdFnJ4dntJPY9CXM8uUXq6pFhtMFltJ5mb*)
(*XLiZtKL98inL8nbXq87C8uqjo+iVaUISMvOXMVI2yKQKczNlnHZeBmnef16W*)
(*1jrySMnYd1G0ODXGXvPPa/vyhE6W0Z7/utttpAqikxQrthCL7Qh4AAAAAPvg*)
(*A3a4sLovgR7ejL4EiSMfOWgJAAAA3KkwJCmcg6dywy8uLw3pUDEY9RcAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAADgCM997nM5AAAAALjz3HvvvVcdil6uv/iL*)
(*v3gxAAAAANx5PvrRj151KAoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*ALeVIks7WV5cdXIA4JZT5hlqCQAAuH7KkGcGZO+qEwQAt5gi2AwqCVZBLQEA*)
(*ANdE7tNAVzRtyzStIEVbDQCMlYljVtWDZRkKyzAb1b/qBAEAAKxT+JvqzqWH*)
(*V50OALjllaRpl0OgCwAA1wUNdHHnAoDDUF0AAMD1gjsXAKyE6gIAAK4X3Llu*)
(*rt///d9/6gq//uu/vmaxpz3taQeX+dmf/dmrPmi4XaC6AACA6wV3rpvo0Ucf*)
(*/eM//uMnV6gWPtdiV33QcBtBdQEAANcL7lw30fve975/+qd/uupUAJwK1QUA*)
(*AFwvuHPdRH/+53/+xS9+8apTAXAqVBcAAHC94M51E/3e7/3eVScB4AJQXQAA*)
(*wPWCO9fN8uSTT/7BH/zBVacC4AJQXQAAwPWCO9fN8rnPfU5RlKtOBcAFoLoA*)
(*AIDrBXeum+Vtb3vbRz/60atOxR0sC1SR3/CSHWbtr0pX08OiDG1N4AVZs7Py*)
(*KhN4DaC6AACA6+XGff83w/zYS95/1em4nrLIkAWWZRmG5SUt3BsnvfjFL/76*)
(*179+05J2rNCSWcEorjoZqxQ+zwpeelRUmsgbwYliV+cZRsm67XDqv9kSK+iu*)
(*YyCEO+zGfT9RlfVX33/V6QAAAFjnEeP7GOa/3PXWq07HNZS5VWjEbJQgyZLQ*)
(*EaqfGd7PFxd/3vOedxMTd5TSVbkq8UeGjlcpduQq4LLj1YF5kcb10eUOx6n1*)
(*WcpcRdAfsjWzjntjU2A21yTUvyqPGD+A6gIAAK6RG+TO9b13G1edjusn0Eic*)
(*ayXNP3Nfrf6peNnswt/85jdf8pKX3LzEHSMgjZysnVybKLfm0eA8WH6y2JUG*)
(*dvU8wrbNtrbId6evEqgcqwZnTeNth1YX34fqAgAArgsEuqfyVRLoyk5a/3N/*)
(*oHv//fe/7W1vu4mpW6uMrSrZghGdfcuXPilbEVQBOiNaqwP0Mgl9UyVN71Zc*)
(*bstQ2Cj92Sp8gZNCtOfuh+oCAACul5R2Xfg13LmOlroy6a3AsLqfVfGiwu3r*)
(*uvC6173u85//fPuv3NUllqmxgmKu7zJQxK7EN6uyG8H004sdRGmThHDuIDw/*)
(*yy6qKPeHf/iH1yxZZEngu6amaE68zUNdUXQ7XJlFoSE2USvdUhIFrm0qsh6X*)
(*ZWiTLYUzp6M0NozsZdWDCa917beJwvHu/DMKDKRvQ3UBAADXyWPv/38Y5v96*)
(*KT5GO0Gi8cyA5C8HrIIgdC2ckUkaFVnRzMpUp1tYageeKkPaE5g1wyz1NbpT*)
(*5ULRWRGQVmlO7Tdypl2sD3RTT6+zT9S67FT8dVlUBCSFG412RSgiZVPHxaKu*)
(*NFuS+7WKNKl/zmSWBPaOxBtNhJzrG1b1krIoItewjuoMcacp/uVpVXXxkn++*)
(*6nQAAACsU/h3Mcwv/S0+Nj9NtOniXE6JB3HuN77xjeFyVaDb/Vz3eWgitzI2*)
(*dSNYOaxV7pE12SYujV3TsMOL9Kytdk62J9n9Rs60i/WB7rbNEBKXmo6piLLh*)
(*f2JdFpWJTVp9N3oTm5Y+17QBy45jiILcf15Xh/QbUZYkw0tIPM/Kdf9cV+3P*)
(*YZWEZHc30EF1AQAA1wvuXKfLTIkjwy6oUvuOXarfladp+rrXva5b7uGHH37N*)
(*a17Tr+bRltKN4oe+bTnJEf1CU/oBHCNbXuDajn/RoCz3By2i59jFo48++kPU*)
(*D/7gD37Xd31X/fOP//iP710pq9tsmY3ZxbJrs6jupstp+eBwKmY8G5uXRZ53*)
(*gW+Woz/u8VBdAADA9YI716lim3QQlWwSCuahWbclbmi3z3e9613Pec5zuiXv*)
(*vffeD3zgA4NVE3HYhriy30K9pi0MVr1Yv4Uq2c2r/9FQA2fZxREtuplXt6ia*)
(*o5h6XRYVPk8PoA50vbptdmOdlGRYAdUFAABcL7hznconTZ8bv20XLCODRFm8*)
(*UQVdX/3qV3/mZ36mW/IVr3jFjRs3un/W45IJOsnzPDtmMi46LxXDCuSTtzLP*)
(*8osOCFaENM2C2TdunmkXR/TRdZVp94n1WdS06NYdLVL6PSBrXbdx0q4TVBcA*)
(*AHC94M51KtqzlLW7dsgy5GmgWweNHMd186C94AUvGK4Y0I+u+q+rEkeSrVXv*)
(*0ctQHHSgrTiKZEUXeAVfh7Vti+gZd7E+0HVkEp6q4+EqVmZR00e3HmEsddjJ*)
(*scDZoboAAIDrBXeuUyUOHV5M0OvhtyKb/FNymsD3hS984cc//vHqh8cff/xF*)
(*L3rRcMVAr9+wK2FWFKkvDWaeLRJ/X7fY+osq0oE2LMoiMKuYlPPy9m+Oe3xb*)
(*ZkabTqWoW3HvLnzbWb+L73znOyuWimn/ZjEab3ZPFm3L1HWCOuhNbLK24pIz*)
(*ENOfBfP8AwJDD9UFAABcL7hzXUBoKfVYr/X/yqbfxWv3UNUPDz30kKZpo9XK*)
(*WBO4rgMqJ5ld82lsiYxo79lj4mr9mgxnBv2q0klv7esPuGS3Hyx3cRdlJDKc*)
(*c97BZukgD6zsTH+/nEXb3OUYgY4EURh0xoiY/po2sHPOBccVhv1QXQAAwPWC*)
(*O9dFFVmaJmk66c16//33P//5z69+eOMb31jFuvOrpem0E2xZFAdj1bJI6aqj*)
(*BcuyOHEYgYKMWcsqowhxdhfVojd3pILZLKIHSn5Th+iqh9D2JkJ1AQAA1wvu*)
(*XJfjxo0b9fdoL37xix9//PE1q6QumURYO2XCgswiPV1PHYShjCQ6fsTeEDuh*)
(*Lab61faALVOfHKjsVZlV/T+vo9zeXKguAADgSIlvG6ZlUxbluH6c3qymsxv3*)
(*sQzzX1+MmdHO70d/9EefeOKJF77whWtXyF2WEaKTxgyITYGtwr+TFZFclQPB*)
(*2rNzT2Z54+p7wFo8I3/4Y1XQLVnhVaflznPjvp9gGPZV9191OgAA4NrIY1+X*)
(*m7mZOEGSxeZnQfduxjBJjxh08vq33oRd3Wme8YxnfOITn3jlK1+5cvnEFhlh*)
(*XwfdZYWxOW483tmNJOme9loysK115d0EyNAWnJvmaYbpHq7CI8YPoLoAAIAj*)
(*Fc2MTlL9vX1ej25a3dDP++HPrBvkzvV9/924/D3dcV72spcJgnDfffetW7y0*)
(*BFbQ7eCYmdLaVSP+kksLnSxYtL3wirsukMGKLzpNBpwO1QUAABzPrUe6l9pv*)
(*z+th8Mngopd/S0eL7qV561vf+pSnPOUrX/nKusVznQ5AcMKwuGV86eFfEepk*)
(*cAb7irsuRAZ/oR4acEGPvBXVBQAAHCmR6ehUSjfEU+ZyJ7XoJknyW7/1W38w*)
(*9tu//dtZtryhxz78NIb5b6/6l5NTD0s+9alPrZ0G93RFQcO/fpjZS1MeHg/i*)
(*MhV5SXtoqKd8rAdnUtz/i9XT2J9++KrTAQAA10c9u1M7mWyZh0rdS3ejHdtG*)
(*9453vON7vud7/o+xaksf+chHFtfBZ9SX5pvf/OZzn/vcS91F7pP5czlO9G/3*)
(*6M8nIxaznHDFwz7c6VBdAADAkcgcAfWkAxzHsc0I+YJqn/Am+sknn/zCjija*)
(*+7oZd67L9NWvfvWS91CmcXTThui4SmUeR/GdcKC3NFQXAABwHDpcP5n7yfB9*)
(*z3Ucx/WT6Tj9a1WB7pd2fPnLX967f9y5AGAdVBcAAHCUMqRxLmOcNnzq2OOP*)
(*P/7OHffee+++dXDnAoCVUF0AAMAxikCnca54jjj3tBTgzgUA66C6AACAYwQa*)
(*TwcW2zP7auHbTkL/nAauf8Igq/utuHMFQfDXAHBH+trXvnZUdQEAANAoI4l+*)
(*fbZvbKgyEhnOIV+mlbbInH8O1hV3rne/+90/BgB3pIcffvio6gIAAIAoAoHp*)
(*CUa4uGBet+KWRZ6fv4MD7lwAsBKqCwAAOKdE3TAMp+fb0jdlhmHds48iijsX*)
(*wEkefPDBq07CYY8//vg5N4fqAgAAzsqT2aa7QmJeyjSvN+5jGea/vvj9Z98w*)
(*wG2sLMsXv/jFV52Kwz7/+c+fc3M37vuJ6nn7Vfefc5sAAHDnSkSGsejMwJHB*)
(*s7J3/j08YmDyeoBjvfOd73zb29521ak47CMf+ciTTz55ts09YvwAqgsAADiT*)
(*MjYZRrS9MN+W5oaRvfM36G5vkDvX9/5346iVnnjiiXPePc9t8rq2zAJNEgRR*)
(*tsNLyMDbwplfcJ/VrZm2l7/85WmaXnUqDvv617/+hS984Wybo9XF9x1ZXQAA*)
(*AMwqQjLKrmxH2zLiGc69jDDtpDvXAw88cAlJOZvPfvazgzGREpnlNNs1ZNLd*)
(*2T97J+fr76GHHvrmN7951alYdOPGjc997nNXnYqp3/zN37zqJKz1kY985Gzb*)
(*Oum5GAAAYElZkEEXythgWO1SYrTjuy488sgj73rXuy4jLefyxBNPvOlNb6p/*)
(*LiLLaFrCI4FhrOSqZua4RT355JNdXt2yNE276iSMfPvb337Ws561f5kstOlr*)
(*BD08dUbvk5ShrQm8IGt2t9tXvOIVZ3v/8shb0dMJAADOqQw2DMOynB5czmv3*)
(*xz78NIb5b6/6l/Vr/M3f/M2t3ABYe+lLX3rjxo3Rr0qfYzj/3BNuXHf33Xff*)
(*Qw89dNWpOKAKxT/+8Y9fdSp6H/jAB0RR3LdEanOsaLs2eY1wSY+ocxJbYgXd*)
(*dYzNYHTuV7/61R/+8IfPs4Pi/l+sDuhPz7Q1AACA7TZP4zi9tPjs+PGC3vCG*)
(*N1xWYk6123p2zz33mKY5XCbQBNE893Qb198teDZ3+1T7vv/yl7/8alM19Jzn*)
(*POcf//Ef9ywQWXrzGoF0s+eDm/R4Vdia2e5WYDZGvdvqWea1r33tui1ktiZX*)
(*Wa/Z4XwzNIYXAwCA6+XIO9d//Md/vP3tb7/UFB1trvXsE5/4xIte9KJ+EUfe*)
(*KJcwZsX1p6rqVSdhYqZP9Xe+852nP/3pV52wxje+8Y3v/u7vDsPFGV6GikCt*)
(*yuTNf40QqByrBvXPX/7yl+++++41azkSJ2i2Y8gMw6jBXDs0Al0AALhejrxz*)
(*/fM///NuoJvHniLIszfGm2C29exb3/pWFxrlgcZstLQoiiwyNOtSkxnbMicY*)
(*1+WLt0ceeeSlL33p5JdXezaX+lT/3M/9XBXuXvbe15y+Rx999ClPecoTTzyx*)
(*Ynu5zm/M6KbHuYUvcFI42O1P//RPr1gr1I2mHjB5ZqPPRfIIdAEA4Ho58s71*)
(*mte85gMf+EC/duIrPEsnMd54Vx3eTVrPqkC3LMtt6m4GUy1LTnKJKUhsrtoH*)
(*p12XUcze//73y7Lc/fOWOpuTPtV/9Ed/9OlPf/py97ju9FVPByublx2ZV9yb*)
(*PwRZonD8ZISWn//5n6+SvXoLhcaiRRcAAG4LR9657r777jzv74CRbVieK5P4*)
(*YHPVI3dNW89e9rKXfeYzn7mJCUiVJki8eR8fXdBrX/va4dhTt9LZnPapfsc7*)
(*3nHJo0OsPX0f+9jHDnyJRgUav1G9oiyyyNHMVf0cziHXN6zqJWVRRK5htcFq*)
(*FZlXDzVrNxFonGjON0Mj0AUAgOvlyDvXT/3UT+1uQt9cfWi023r2hje84e/+*)
(*7u9O3mAQBO95z3vWL+8pHMOJIkeaBK86SFyremz54he/OP7d6WfT8zzHcc6S*)
(*sN0+1Z/85Cef//znr9/CJz7xiaOGGlh/+lRVffOb37x/a6mrDl4jsPbqZt17*)
(*7rlnOlrIMVx1+PpC7t5ePOtZz1r7PVrqbDbqYnoR6AIAwPVy5J3rh37oh3Z+*)
(*l192oFtkSeC7pqZoTrzNQ11RdHvURDbbelYFuoqinLxT0zRf9rKXrVyYdANm*)
(*WC/LDH4SKeWuLrFtwCMoZrp2UNUTVzyYV0NPf/rTdwLd08/mm970pr/6q79a*)
(*k8YkClzbVGQ9LsvQJmkMh1k216e6CnSf/exnr09MFYsOe2Xst3z6Zrz61a8e*)
(*Tv5bxK7U9Pdg2I1g+hfqq/ALv/ALcRyvWfKo/b7+9a+nrdAHcr6qDXiG92jW*)
(*u7o+03kBgS4AAFwv1yHQTT29vqGLmsY3sZ/SdUJcaj27eYFuEfBkquaEdG7c*)
(*jCKlyBRImkQzK1OdJl1ZN4/zySvuz6uJqwl0i0ip2x1ZUVeaNPbTWy/0qb7E*)
(*QHf59M0aBbplKNAjMcMs9bX9ub3G2kD3yP3ee++9JNDdn/PbROVGWT+zIQS6*)
(*AABwvRT3/wzDPPV5a2c6O0ug++53v1vZsX+8Jr99JyubjqmIsuEfbOA8LdB9*)
(*8MEH6/T8j//xP6o4sP75ve997/IaBYlJBZOmJ68jpS50qJPdxKhlbOpGsG6e*)
(*rJNX3B6TV2cJdB944IE6l+6+++5nPOMZ9c8H+jCQD83qiEt2HEMUZO9Qg/XK*)
(*QNfzvDoB1cK/8iu/Uv+8tw/DvtM3axTo5h7JLVZthv1wTWNpBNq93vKWt9RJ*)
(*fepTn/qKV7yi/vkrX/nK4gpH7rcJdLen5PzIDevHGeb/XF1dAAAAXLFH3vr9*)
(*DPO9d6+dvP7HfuzHdn53dGhk2/b/uyOK9szmkNWtmszGXH9XrgLd17/+9asX*)
(*b3z2s599A/W85z3vl3/5l+uf94RtsSUyjNgmnXZw5fTuQ57Mo61tG8UPfdty*)
(*ktUDTZ284lF59cxnPnOn/fDos+n7fp1Lz33uc3/t136t/vlf//Vf96ySN42Q*)
(*jBmvPZ9VoPs7v/M7Bxf79Kc/XSegek751V/91frn+++/f2n5/adv1rjrQqrR*)
(*pwrZ8gLXdvwTx/R4+9vfXif1R37kR/7yL/+y/jlN9/RGOG6/XaB7Qs6PPGL8*)
(*wDHVBQAAwBW7cdyd66677nr00UfHv7v0rgtV2Fe3UZrHxBFVqPDggw+evM9V*)
(*XRfoW2/yJlgUBaJOJscLPC+ZND8ScfA2WF7X/WB7kRWPyasqptr5GP8m9NHd*)
(*enWb88Zav/Eq0NU0bf3yq7ouHD59MxRFGfbRTWxhcKIu1G9he0wf3aP2+853*)
(*vrOKz7cn5fzIkdUFAADAFaN3ru9ffed63etetzMWweX30XUVEo5I9lGNUH//*)
(*93+/blT/eesCXb+KlFiWZXbRUaoC2u4m6KRPY56t7nxwgRWPyqv777//Va96*)
(*1fh3NyHQTRXy+pztJoNY44EHHvjc5z63fvl1ge6B0zfrgx/8YB/oFj7tQiCQ*)
(*7CrzLB8eUeHbzjGHSKwNdPfuN3DcyX7/+q//+t577z0t50cQ6AIAwPXyiPH9*)
(*DPNf7nrrysU/9alP7cyMdumBrkOHdlWP3MH73ve+i+z03/7t3z70oQ8duRLN*)
(*isHXTAH9IKz/jixxJNla0w3h5BWPyqtvf/vbr3zlK2cO4aSz+elPf3pPJ4Fe*)
(*6rB7I8lZtm0flZgHH3zQdd2jVtk9fbP+/d//ffgxGml4b/vKVhxFsurBnMtI*)
(*ZDjnyBbeastf/epXDy+3Z7/bWNoJZZ/97GeTztgn5fwI7em0vroAAAC4Yo99*)
(*6OcY5qde9S8rFy/LkjYNDaVq3Ux0Wq+/w6obN0M6Uh65+ePD1IvbCXT1+k2x*)
(*EmZFkfrVgXBq88V64jv+ctfbPSuWabDcJ/PovHrHO94x/sVln81tbJM0Cuae*)
(*LtkzbsrZXBXoPvroo33DdRHU3R1kKyzKIjCr8JPrJpUr8kub/HfPfstyd7/1*)
(*FMCn5fx4v/f/UlU4/vTmX1kAAAAnoe9AuyBqjTe+8Y3dz4mrDt/7biTr/M26*)
(*9ANzVj5uJoIoio6aL+BMaKQ0bDErY03ox2ziJLNtgistgRGt5ZfUiytuE1tk*)
(*+IWJq47Pq5t9NptBITjnmOFmq8ert7zlLZeQlomd0zfna1/72t133939M3G1*)
(*waBcnBnUJyqhR6lfXr/1hf1mFmnSH3XZ/c///M9nPvOZ25Nyfur46gIAAOAq*)
(*HX/n+od/+IdVb1ev1Jvf/OaiuLT2tCMVWVoZd6TclkV+sM10acXifK2tn/zk*)
(*Jx944IGzbe5y2Lb9hS984apT0fvd3/3d0b/LIqUnanhaPJnljQu0na4xt9/Y*)
(*FFh5NKncBz/4wT/7sz87zx4R6AIAwPVy/J3rySef/MxnPnN5Kbq473znO5/9*)
(*7GevOhV7lHSq1k1wfCSe+iZ33OgNhz300ENn3NpluNVS+Pa3v33v2F/betAM*)
(*60KTpJ2mMDbT4tF+iXaWzSPQBQCAa+WkO1eWnTPQOrudAdBuOZknHzUm8EAs*)
(*MJx71ux/7LHHqkeDc27xrL75zW/eOo3ztaqA3XfffXsWKGOTTLbmhZfXdWFh*)
(*xxG/Uzx+4zd+Y2dakFMh0AUAgOsFd66rYAuMYJ0yuUAZGRcfrBUurh6WdkkR*)
(*komYZfuSuy7sKOOZ4vGLv/iLZ9sBqgsAALhecOe6ApHIsJrtHTPfWbumwU96*)
(*YMKVeMELXvCtb31rzwLlGTtSr0JavaviMbmWv/Od77zkJS85305QXQAAwLWC*)
(*O9fNR8eGYmX7+Di3NHd6YMKVeNOb3mRZp84vdglyn0wUwnHiZADkj33sY1/6*)
(*0pfOthtUFwAAcL3gznUVTmjuI4Ojkh6YG//W6q96h8rz/JwtpWdQpnGU7pSN*)
(*M383iuoCAACuF9y5rodcJdM4sIIeXHVKoPHe9773qpNw2P7+FUdDdQEAANcL*)
(*7lzXRJmnUXwF41UB9FBdAADA9ULvXBsN7YQAcEgZ8Ah0AQDgGqGBLrMRZEWW*)
(*JUm1bvaASABwy8sdTZHkqooQSG2BQBcAAK6LwueZnmgi0AWAsdzjBrUEAl0A*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAlUJDYBjez686*)
(*HQAAAAAAZxVoG4bZeAh0AQAAAOBaKYuiKIf/KLo/1T/TQJcPim2RxlEUJVk5*)
(*Wr/I4jhO0my0RbpIlsRJViwuBgAAAABwiRKZYRhOo+21hcFX/2DMmESnRWRU*)
(*P6t+Fmj0txzLtHQvrVcOLbn7JcOJXkoCXF+tAmNWEDbkl7K3tBgAAAAAwKVy*)
(*ZJZ0wa1i2zIUaCgqmtG26ZrLedm2CXSZjemFoatz1Y+sWgXGmaeSH3nFi+LA*)
(*Jj8zrJJuu+UZSTX8OF9aDAAAAADgUmWeUsWeWlhuY7NpdBWtKuolrbsbPW8D*)
(*VyNqOiHQBlshLHLa/CvG7XZiU6wXq5dXvbqXwuJiN/kwAQAAAOCOk/ukD64R*)
(*xpbAsJKhVoGpFOekdbf65bb9GM1vI9P227Rco30TGLbG1TGy4mXN8s3Ha4uL*)
(*XdXhAgAAAMAdI9dJG62qiVWE62akay6rGWrXWXccuHb/pGtVIatu6JRhmIZh*)
(*eEkxCXSXFruqowUAAACAO0dEuxOQXrV2st02PXUZVq77GywFuhpHett2LbOZ*)
(*p214JSq30xbdhcUAAAAAAC5bGVt1aGslZTf2Ais79V9nA10v38aWRAdR0IM4*)
(*CWyVpV+ZJTvj7i4tBgAAAABw+RKFJaFtHX/WDbzt12TbUOd3Al0xpCOQuZrQ*)
(*jxvGivUaIQmUybi7rfnFAAAAAABuZUWW1DNB7O+MsHIxAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALgVlUVRlFedCAAAAIA7VmHy*)
(*DKf6ywvkOs+wsn0wYostiWE2fn7OxE2SwfD6ZW1+V5EnSVrQHwOyb+kLxwSt*)
(*kaUwBOudluLB3rdFUO1ePTln6epG+BjdatpuNjc2DKftOe/nd8klBAAAAGAi*)
(*17gDga62YaolskMb8slylxjoGkK1+ZsX6Oa+WsWpakB2GJJ98/5jR6xd5WqV*)
(*XNWwk+Kie98WPkcC3YNnYAENdP+Wru6rXBt7Hzzv53fJJQQAAABuE0VB4qcy*)
(*T+M4TvO6qbFIkziKk1G7Y5FFYSXKpuFWmSZJklbBT2FsGLYPeMqs2ki1lbQL*)
(*R3KdBLraUniSZ00jYWjwwzCmqDZU6Zol1ya7LMt29ShKRulu/lQ2HQLoilE8*)
(*SVhB05PvaX1t16/20G5/96i3qUdCTdlJ2n2P9rGQq/3aJNDd6MW+Vco+N5Jp*)
(*EDvaOw10tbCoNlKlMoonCxcko5NkzyE3GbctPZWEmi45JzTQ1YLql9Xqu9k4*)
(*TGXZ76XZdUbP2fjwyzQmhxin0y0tlRByOKSAnBrAAwAAwC2jrEK3JMn2RWCr*)
(*5STyYQWBZWqsrGk80/5DNOvQIfX0dgFCsaNm9SyQuPa33Ia0PNJX2GXiCoMV*)
(*WF6NSWL3BLqFrWyYEZ6GMakhcoNfbqwoX5nsPNBoqvrVRaMOwmkbKadl9Q8b*)
(*UegWYaWgSVxuK/326J5nWoB9EuxVqaApl73Zo859pftNFQ0G99xVHVpQ7M3V*)
(*Xqb2SwhhubAKzQ1ekuiflGG0N9l7FeiSFPPdoTEbxWkeEmJnkHhWnUkMiZN/*)
(*iWHuCR7zlW5R1s1pQz0v8v3v5HDmHNPc5qXufG4kVRG7dXi3brDOA3lwwjeS*)
(*2R7OUgnZhpbc/44TvRSdmQEAAK6rwBBJAMDTqFJ1F5bK43BGvNtuWPh10CMZ*)
(*buAaTSTBq17gGzL5F3nNnTo0HBGcMEljt45NDBLKZBpdQdKdMHDqiHdDWnQL*)
(*0t7GsJoTpmnsaCTBipftCXQjkyzDCpofBmYTz5AwJvNInMYrVpwmYZ28OuBc*)
(*kewm0K1+rpKR+HXyNH+YDPpDvWIY2qpAAiXaIh2Z9GfRCKPQqAOvzUyygza4*)
(*llTDj9PZoy7zpI7QJN2uTgANdO964LHtcq4OlUlg8yR01z0/yB5eWKXNDU5U*)
(*LHcUoE723ueb7kSRp9DY1KzC8SIU6EHqbhiHTr1lM96JGAv/Ltp1IU9CXaRP*)
(*C06Ql002soLqR5Gj9dk4KZPNYqLuh14btG4M1/dMpV2lKVGKFWRZbNFT2Z6R*)
(*pRJC2qtZXvGiOLBVugMlXbgqAAAA4NZGm/hkEt9GlsSJ5vwb79xjZsnedEna*)
(*xLdpwpKShmqk5ZD8I9TriJF+P8XaSZcEh6PhRxEZTNuEW++03VTh6YpqhfWv*)
(*y8Rmm36hS4FuQhoIWbndQ0HDTPJiOgssWTbauCVVm5bYVcmuA11BD9qdkGTQ*)
(*qGkS6Epxk1AS7NXhFu1/qrTpycn25+LzOtBVvbrRcemomyRptBm3DnT9x7ZL*)
(*ubqzk0InPWDJUSyuUrfTSvbOun2G1Huvl+RUb/inKpF1GNksQ7fMkjMbTLdF*)
(*W3TrPrqhTnvJkjXqbGxPXxny+wLdZrGCnh3FrbOOlmrBvBGSEsXrYXeE7YlY*)
(*KiH01DBi3K4Q0wMxopN6MwMAAMAVq2/xkhdFQRgvLzbfohslO8Fa/XVS+8I+*)
(*oL0t63/UgWIVBXlKtYgYdc17bUBYL6AFgy643UdJRWKp0obr34XvC3TzYdRK*)
(*k6F3PTDLwNZFfrChumV1RbJ3kpfRV+dGMQh06Tt3o42K2vTX6RmEeUG1HDsb*)
(*6I4/iZo/6j5J20Ggu5Sru6ey+9RrcRUavsrufEPmcO+TfOv+5NcNqWytOQBO*)
(*mXks6gLdwbFPs3Hh27TRYu2um5NWn5EvTU9ZXRI47+GlEpLXCe9SXme74qGz*)
(*LgAAwLUUmaQNi9tU93QhWGy4KrN0RrY7Fuv4M3wSMbLTiNEmfT+lPqqmn96T*)
(*Fl3a/jYMdNsIJ6k7TfKSohu255ncikC3a2bcDgJdGtox7EZUddP1bHES6O5N*)
(*9m4cTpYijeGDQHcUkrX/3Am8w1WB7tJRzwe6S7m6s5M+kYurNLkx/xHYTKDb*)
(*5lv3p7ppWqgSrlOGYRqGE+6Ei0uB7mw2Lh/INFXtGXl4J9B1Sb+Rjf/wUglp*)
(*ukOME254p41PAQAAAFerbsTrmtqKvL6jZ4FlPpD0ix3TdeFgxEhDGtZp2wvL*)
(*2KLvl4Omb4DRvmjOmq4L9QIbrf19bLavxRcC3TIiEWw/7FhhNC+maRssI7a/*)
(*z8j7a+64QFe02sBwruvCQoSW9juiayrcUteFPtBdPuptG3KPuy4s5OrOTvpE*)
(*Lq6yd9Cw4d4XA10SNzJGF0MXgbTZaG4y3dZOoBuU27MHuqLZdTNuT8RiCaEf*)
(*uLH993eZp214JcLnaAAAANdRfcffaCTYIUEvV08ikLim84XB2Kxl5nuuN+X6*)
(*0Uwb3cGIsYxM+nZYdMIkiRz61RJHw61Err/zt/wk9tpvtvwqzCY/8oofxYHT*)
(*fu+lWGlRj6M7EzHWr845yYiS2Fbr76U2XtMDkzO8MA7dZhQEVvLTYn2gS2I8*)
(*p//AivbebMKqbDlCo8MpMBtJ90O/Tc5ioNvM47B41E2SeMWMsrILdJdzdeL/*)
(*b++OeVRHEjyAE25y902ObPPhCwxfgJiYlPDIiE5ES8YlJEuEtBIRCcmygTdA*)
(*WjlYAu9KTIBWPokJHDjoo2wMNOB+3T2v902/+f2ihme7ymU/9b/L5apLrWp3*)
(*eUXQLUuvC7pP6aroOu/Oj7WPT+8VzpIHry7+cJlHN6Tu0Ty8bve1gm56dUft*)
(*99tpUY8y99bcIeXKEY1Wb7JJdptFMUfFZXA1APDJxLPLZEqD0xxQP0/7/10/*)
(*jOFFxfDO81PvkNyeD3Ytpil42pbvs5+0JtEpkIUJtS5fd1qnd9Oy5egygVV3*)
(*OC5nlBqs/1k/vVh6NY1Yqz847t6Ls6c0ml4GvHaGkzLsDtavqfY56F6a6/Sm*)
(*WBGrurPselBx8f1VEstWxbQJRXW63Zoe3WI2107V8nVnnR4TajnzV3O4jkPf*)
(*6Y/lghF1rfrcs0o+3uXUGjUDU69Kv2m360u8j6bX87iNlo9GgFezLoQLFpXN*)
(*2zz+PVLfjLUncthMzkVXV2SeFXfUZcqx43ej5fkFuYd3SHGlLvfg8a8A43MB*)
(*4HPLDun+ahrdED/6H96Lle2T3X6XJOntc+Fy/v/b2UvDGgxJNdlvnqWvmPY3*)
(*LLWQ3E2BdloLoMpmxwPdjzR+pExxk/jwVCwqUb8iw71ss1osozC7Vl6UtRo2*)
(*G80vL+j29NJZ54fDoxaobdWXynjzLnWl321VXspXztCcZ8ejfsRo2CysuXG7*)
(*xkfw+A6plhTZ7d/SJADAZ5DFf/iv7tyv+BvPH46/zTI8Dy8eoKe7ssOwNayb*)
(*shgAgI/y92n3aupRTrLN5N1BN9+vrhdka13W5wIA4N9n2fvhD5ufv7wdb3TY*)
(*74on4kIuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAACfSp5lWf6tKwEA8JuVzTqN1iiq3+Aw6TSa*)
(*g8UXE1sy7zca7ejwNSt3U41GZ/JRh7+XHXa7fVb8uAll9//+ltC6nQ8bQXP9*)
(*vhpflf6UbY7Fj97dssXuk82hOOq+Ouxh2m60xi9c96/vg+8QAIAbh3HrC0F3*)
(*3G4ct0i/dKAobPeBQXfaPR7+3xd0D9HomFNHRT6MQ9md6Oc37H1s1WN1R9PF*)
(*LvulpT9lUSsE3S9egRpZdLww4+JQ0ahVZe8vXvev74PvEADgO5FlIT/lh32S*)
(*JPtD2dWY7XfJNtk963fM0m18tE1v41a+3+12+2N2yqbtRvMSePL0eJDjUfbn*)
(*OHKYhKA7rosnh/TUSRhPO9cxJjse6OjcLfnaaud5Xu2+3e6e1fv0T/lpQECx*)
(*4za5qVhW1OfwQu9rtf+xhOr492f9tF+HqDlY7qqyn5VR06qXvUPQbU+yl3bJ*)
(*L62xuw2xz0ovgu44zo4HOdZym9xsnIWG3u1eOOX8NIIiX49C1FyFa1IE3fHm*)
(*+OVx9/tmvK5lfinlVHRaXLPnp5/vk3CKyf72SHV3SDidcIO8N8ADAL8a+TG6*)
(*7XbpSwns1Q4h+TS73Waj1ByMx51G9aE3K6PDfj2pNgiGi+1p93TTb1Xfttqh*)
(*57F4hJ3vVt2rHZqdURIq+0LQzRbDduOZThFj9tNe6+rL9nx7eGW1D5txUavL*)
(*7r1pGcKLPtLWOC1/aPe6502a/c2pcofF8HK8ouQHPcBRCHvHWhQ1H6wfnvUh*)
(*Gp6/OabBzR9+PJ7aJnuxVS/S0WWLbpzX7FK0RqffL/5peJ32bkovu2SbnfOp*)
(*NdrD5emPhGR5Vfnm6EFlLh3C0fC8aXN1KDrqO73O5btB/OAaF63d6Z+vZ7s/*)
(*GvbO+3RWZYf1YTO4uuDt/qw6nbo75CmeDy7ftXrrvcHMAPBZbaa9EAA6Raoc*)
(*rWq2OiTxA8l9v2EWlaGnP11tVtNTkuiM1ptoOgifwmPu/bKII91lvNsnqzKb*)
(*TEOUScfFDv3JMt4sy8TbDj26WehvazTHy3i/T5bjUOHhOn0h6G5nYZtmdxzF*)
(*m9kpz4QYk65DTusM58l+F5fVKwPnK6p9CrrHn4/V2EVl9cbRdTWKH8od43gx*)
(*6oagVPRIb2fFz71pvI2nZfBqP6j2pgrX/dE0SvYPzzo/7MqE1p8sjhegCLo/*)
(*/vnnp/pWvZbvNotOiO6TdbRJf6rZpWqNVm84Xz0LqDelX9ptstxu18Mim86O*)
(*cTyLu8VJTlZxEi/LI8+Su8RY5OTQtrt40iv+WlhuDvmpGZvdUbTdLseXZry5*)
(*J0+b9SZRvK5Ca3u6itazYbXL6Y4azjdpmsyLS1ldkbo7JPRXNzvD9TbZLEZF*)
(*AcN9zf8KAODXrejiG4R8u533W73Z4yfeh3XjocH6dssiurRPsSQvolroOQwf*)
(*4kmZGIv3p5qL3bkKy1YRP7LttFF14ZaFVofK1pPhaB6XX+e7RfM0LrQu6O5C*)
(*B2FzUJWQFTEzPJhON/PBYFrllv3o1BP7qmqXQbc72VSFhGoUqekm6PaTU0VD*)
(*2CvjVjH+dFjV5xCO/yifl0F3tC47HevO+lSlcdGNWwbd6Oenula9KySbhBGw*)
(*4Sxqdyn7afuLu30vDVKWXm7ZGq2v/+lYyTJGnrYpjtwMV3Zze6yrIb7xpBgl*)
(*G/Yom7G6fHnceSnonjbLiqszXJVNV9zV3dn/xeGO6kzi8xlWF6LuDikuTaOX*)
(*VDskxYlMt+8azQwAfGPlr/j+ervdxEn9Zo97dLe7u7BWRpfqgf2mGG1ZfiiD*)
(*4jHVrIfHTXrbc/deFQjLDcabqyG455eSst181G+3Ls/CXwq6h+vUWlRjch6B*)
(*mW8Wk17n6kBlz+orqn1XvbR4dD7NroJu8cx9WqWiqv5lfa5i3ua4XfNh0H3+*)
(*StTjs75U6ekq6Na16v2lPL/qVbtLEV8Hq8cdmdel37Tb+Z+isiO1WTqdQGv4*)
(*4M+ic9C9OvfbZqx5N+3ZZlXRp4tWXpF/3l6y8k5orX+qu0MOZcXPNS+bfbg2*)
(*WBcAPqXtLPRhtdrH3+ndSw/cZj5b7662ytP9A+n9XKzPX8MPibF5mxgXYexn*)
(*/5KqizmmQo9u0f92HXSrhLMrB012+sPJdLFez1qvCLrnbsanq6BbRLtGs90b*)
(*TWar9aJ3E3RfrPZ9Dg9bhc7wq6D7LJJVH++Cd/yqoFt31o+Dbl2r3hVyqWTt*)
(*LqfWePwS2IOgW7Xb+Z/KrunuseKTwnQ6m06X8V1crAu6D5ux/kRua1VdkZ/u*)
(*gu4qjBtpRz/V3SGn4RDPKz5dv29+CgDg2yo78c5dbdmh/I2erGaL7VXOecvQ*)
(*hS8mxiLSNJdVf2GezIvny5vT2IBp9aA5PQ1dKDdoj6vvk1n1WLwm6ObbkGAv*)
(*045l09OD6aIPttGrvk/D8+vW24Jub14Fw0dDF2oS2v5SULHnsFU3dOESdOvP*)
(*+qmK3M+HLtS06l0hl0rW7vLipGHXpdcG3ZAbG9Nzhs42/XZ7vNrdHusu6G7y*)
(*p68edHuz8zDj6kLU3iHFC27Ny/t36Xrc7gy3XkcDgM+o/I3fHoewE0Jvq5zI*)
(*dNofbK47sfI0Wq/Wt1bR9qU+uqeaxJhvZ8XT4d4y3u22y+KtpVYRt3aD8j3/*)
(*ebRL1tU7W9ExZocfO8Nom2yW1ftew/k+K+fRfZAYy0fnrf50u0sWo/J9qfb6*)
(*NAKzNV3HSbw6zYLQ7Ef77PVBN2S85eUFq2L05ilWpfUJrZhOodHuT6I4qqpT*)
(*G3RP6zjUnvWpSp3hbJvm56Bb36o3LrWq3eUVQbcsvS7oPqWrouu8Oz/WPj69*)
(*VzhLHry6eN69nHFiNA+v232toJte3VH7/XZa1KPMvTV3SLlyRKPVm2yS3WZR*)
(*zFFxGVwNAHwy8ewymdKgnAMqDNHsv/OX++k9+vNg1/bNYNdimoKnbfk++0lr*)
(*Ep0CWZhQ6/J1p3V6Ny1bji4TWHWH43JGqcH6n/XTi6VX04i1+oPj7r04e0qj*)
(*6WXAa2c4KcPuYP2aap+D7qW5Tm+KFbGqO8uuBxUX318lsWxVTJtQVKfbrenR*)
(*LWZz7VR/YtSddXpMqOXMX83hOg59pz+WC0bUtepzzyr5eJdqMoTHl/iq9Jt2*)
(*u77E+2h6PY/baPloBPhVQWlUNm/z+PdIfTPWnshhMzkXXV2ReVbcUZcpx47f*)
(*jZbn4TkP75DiSl3uweNfAcbnAsDnlh3S/WUa3SweN7vzD39am+2T3X6XJOlt*)
(*SeX8/7ezl4Y1GJJqst88S18x7W9YaiG5mwLttBZAlc2OB7ofafxImeIm8eGp*)
(*WFSifkWGe9lmtVhGYXatcn2E1bDZaH55Qbenl846PxwetUBtq75Uxpt3qSv9*)
(*bqvyUtZuWvRanxN1nh2P+hGjYbOw5sbtGh/B4zukWlJkt39LkwAAn8F22u1M*)
(*H03v/9v2/OH42yzD8/DiAXq6KzsMW8O6KYt/K/I0nvTD+AFzGgAA/zaLbmsc*)
(*e838VraZvDvo5vvV9YJsrcv6XL9dp0XW2sNHq54BAHyAsKZVOW8/X9lhvyue*)
(*iAu5pTz7kIEKAAAPHaadZndy/+IPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAfArZejpoNBqtUVR9kwyax8+9RZx+y3oBAMD7ZbPeMeQ2Rsvt*)
(*8UMaLyfTxS47fr2bdsP340jWBQDg88m3sxBnu7M8fDqMW+HTcF2E2/2iWfTz*)
(*SroAAHw68ST027bHm+JTvuiHpDsqe3GzTSfE3vb68E2rCAAAb7cZhzDbrkbn*)
(*bsbtS7LNojLoRoIuAACfTZFszz26T2k0ajRa0fOgq0cXAIBP5xCS7XmM7lM8*)
(*aYegmxUfsiiE4EY/yb9lDQEA4F2Sfkizzfk2e8qTYfEyWncSRjKshiHndqfb*)
(*04b5frXcZN+yqgAA8Ab5ft0L0ysEreEqO5QjForEO1pdku1h1Wp0Y727AAB8*)
(*Jnma7tP0nGqzdL9PD89CbZ5nh0zMBQDgu5Lvo0Gr0Risv3VFAADgK5t3GoOV*)
(*tSMAAPi+5HGn0ZJzAQD4zuTbaaMxlHMBAHi3LN1totVsPBwvk6dDPBkOJ4v4*)
(*5V3+9a9/Le785S9/+Yq12k47TQN0AQD4BfbrSTm1V288rqb5+kJX6u9///vf*)
(*/e53//Hccbe//e1vX6FC2SF/yqbtxmhjgTQAAH6RaNQuA+5gtpwNe4Np9PKs*)
(*Xj/99NPkzmKx+DqVGTYbjWarOxFzAQD4ZdJJ2ZPbnv0qZq3ND8k2sSAaAAC/*)
(*VLou+3Nnu9fu8Y9//ON/7vzxj3/8yFoCAMDb7FfDY8pt9he/iu5cAAD4SpZh*)
(*BbLGKDIkFgCA70nSL2Zc2H5wf+4PP/zwn+81GAw+tnIAAHx/DmGAbnOw/Ohy*)
(*/vSnP/3ve/31r3/96OoBAAAAAAAAAAAAAAAAAAAAAAAA75Wtp4NGo9EaRdU3*)
(*yaB5/NxbxOm3rBcAALxfNuuFNSpGy+3xQxovJ9PFLjt+vZt2w/fjSNYFAODz*)
(*ybezEGe7s2IptsM4rD/cGK6LcLtfNIt+XkkXAIBPJ56Eftv2eFN8yhf9kHRH*)
(*ZS9utumE2NteH75pFQEA4O024xBm29Xo3M24fUm2WVQG3UjQBQDgsymS7blH*)
(*9ymNRo1GK3oedPXoAgDw6RxCsj2P0X2KJ+0QdLPiQxaFENzoJ/m3rCEAALxL*)
(*0g9ptjnfZk95MixeRutOwkiG1TDk3O50W26X7aJltPumVQUAgDfI9+temF4h*)
(*aA1X2aEcsVAk3tEqqzZL5r1Gb/EtKwoAAG+Wp+k+Tc+pNkv3+/TwfMhCnmXG*)
(*MAAA8H3Zr8JQ3vHGa2kAAHxfDqtmo7vVowsAwPdlt+g1ugboAgDwncnn3WZ3*)
(*stjssi9vCwAAn8YhTK/bHGzlXAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*)
(*AAAAAAAAAAAAAAAAAF70/70UW0M=*)
(*"], "Byte", ImageSize -> {538.1999999999998, Automatic}, ColorSpace -> "RGB", Interleaving -> True]*)


combineModes[ $shearBuildingCQC , modeResultsList_List, modeRadialFrequenciesList_List, modeDampingRatioList_List ] := 
Module[ {\[Omega]List, \[Xi]List, sumSquare},
\[Omega]List = modeRadialFrequenciesList;
\[Xi]List = modeDampingRatioList;
sumSquare = Sum[ CQCCombinationCoefficient[ \[Omega]List[[i]], \[Omega]List[[j]], \[Xi]List[[i]], \[Xi]List[[j]] ] * modeResultsList[[i]] * modeResultsList[[j]], {i, 1, Length[modeResultsList]}, {j, 1, Length[modeResultsList]} ];

Re[ Sqrt[sumSquare] ]
] /; ( Length[ modeResultsList ] === Length[ modeRadialFrequenciesList ] && Length[ modeResultsList ] === Length[ modeDampingRatioList ])


CQCCombinationCoefficient[ \[Omega]1_, \[Omega]2_, \[Xi]1_, \[Xi]2_] := With[ {r = \[Omega]2/\[Omega]1}, If[ Abs[ 1 - r ] < 10^-9, 1,  (8 Sqrt[\[Xi]1 \[Xi]2] (\[Xi]1 + r \[Xi]2) r^(3/2))/((1 - r^2)^2 + 4 \[Xi]1 \[Xi]2 r (1 + r^2) + 4 (\[Xi]1^2 + \[Xi]2^2) r^2) ] ]
CQCCombinationCoefficient[ \[Omega]1_, \[Omega]2_, \[Xi]_] := CQCCombinationCoefficient[ \[Omega]1, \[Omega]2, \[Xi], \[Xi] ]


(* ::Subsubsection::Closed:: *)
(*SRSS (Square Root of Sum Square combination method)*)


combineModes[ $shearBuildingSRSS , modeResultsList_List, modeRadialFrequenciesList_List, modeDampingRatioList_List ] := 
Module[ {\[Omega]List, \[Xi]List, sumSquare},
\[Omega]List = modeRadialFrequenciesList;
\[Xi]List = modeDampingRatioList;
sumSquare = Sum[  modeResultsList[[i]]^2, {i, 1, Length[modeResultsList]} ];

Sqrt[sumSquare]
] /; ( Length[ modeResultsList ] === Length[ modeRadialFrequenciesList ] && Length[ modeResultsList ] === Length[ modeDampingRatioList ])


(* ::Subsubsection::Closed:: *)
(*SumAbsoluteValues (Sum of absolute values)*)


combineModes[ $shearBuildingSumAbsoluteValues , modeResultsList_List, modeRadialFrequenciesList_List, modeDampingRatioList_List ] := 
Module[ {\[Omega]List, \[Xi]List, sumResult},
\[Omega]List = modeRadialFrequenciesList;
\[Xi]List = modeDampingRatioList;
sumResult = Sum[ Abs[ modeResultsList[[i]] ], {i, 1, Length[modeResultsList]} ];

sumResult
] /; ( Length[ modeResultsList ] === Length[ modeRadialFrequenciesList ] && Length[ modeResultsList ] === Length[ modeDampingRatioList ])


(* ::Subsubsection::Closed:: *)
(*Highest mode anywhere*)


combineModes[ "HighestValueAnywhereMode" , modeResultsList_List, modeRadialFrequenciesList_List, modeDampingRatioList_List ] := 
Module[ {\[Omega]List, \[Xi]List, sumResult, modeMaxElement},
\[Omega]List = modeRadialFrequenciesList;
\[Xi]List = modeDampingRatioList;

modeMaxElement =  SortBy[
Table[ {i, Max @@ (Abs /@ Flatten[ {modeResultsList[[i]]} ])}, {i, 1, Length[ modeResultsList ]}], (-#[[2]])& ];

modeResultsList[[  modeMaxElement[[1]] ]]
] /; ( Length[ modeResultsList ] === Length[ modeRadialFrequenciesList ] && Length[ modeResultsList ] === Length[ modeDampingRatioList ])


(* ::Subsection::Closed:: *)
(*shearBuilding: Floor dof or load spec to vector form*)


shearBuildingBuildingToFloorVectorTransform[ dofOrLoad_ ] := With[ {nDofs = Length[ dofOrLoad ] / 3},
dofOrLoad[[ Transpose[ Partition[ Range[ 3 nDofs ], nDofs ] ] // Flatten ]] ]


shearBuildingFloorToBuildingVectorTransform[ dofOrLoad_ ] := With[ {nDofs = Length[ dofOrLoad ] / 3},
dofOrLoad[[ Transpose[ Partition[ Range[ 3 nDofs ], 3 ] ] // Flatten ]] ]


$dofSpecStrings = {"ux", "uy", "\[Theta]" };
$loadSpecStrings = {"fx", "fy", "t" };


shearBuildingFromDOForLoadSpecToVector[ dofOrLoadSpec:{ (_ -> _) ... }, numberOfFloorsSpec_?(  ((# === Automatic) || (IntegerQ[#] && # >= 1))&   ), someOptions:OptionsPattern[shearBuildingFromDOForLoadSpecToVector]] := 
Module[ {varUsed, floorNumbersUsed, locateIt, numberOfFloors, resultVector, minFloorsInferred},
varUsed = Union[ ToLowerCase /@ (Head /@ (First /@ dofOrLoadSpec)) ];
If[ Length[ Complement[ varUsed, $loadSpecStrings ] ] =!= 0  &&
Length[ Complement[ varUsed, $dofSpecStrings ] ] =!= 0,
(
Message[  shearWalls::dofOrLoadSpecNotValidString, $loadSpecStrings, $dofSpecStrings, dofOrLoadSpec ];
Return[ $Failed ]
)
];
floorNumbersUsed = (Abs /@ (#[[1]]&) /@ (First /@ dofOrLoadSpec));
minFloorsInferred = If[ Length[ floorNumbersUsed ] == 0, 1, Max[ floorNumbersUsed ] ];

If[  numberOfFloorsSpec === Automatic,
numberOfFloors = minFloorsInferred,
If[ minFloorsInferred > numberOfFloorsSpec,
Message[shearWalls::floorsInferredMoreThanSpecified, minFloorsInferred, numberOfFloorsSpec ];
numberOfFloors = minFloorsInferred,
numberOfFloors = numberOfFloorsSpec
]
];

locateIt[ whatVar_[ whatIndex_ ] ] := 
With[ {pIndex = If[ whatIndex > 0, whatIndex, numberOfFloors + whatIndex + 1 ]},
Which[
MatchQ[ToLowerCase[ whatVar ],"ux"| "fx" ], 3 * (pIndex - 1) + 1,
MatchQ[ToLowerCase[ whatVar ], "uy"  | "fy" ], 3 * (pIndex - 1) + 2,
MatchQ[ToLowerCase[ whatVar ],"\[Theta]" | "t" ], 3 * (pIndex - 1) + 3,
True, $Failed
]
];

resultVector = ConstantArray[ 0, {3 * numberOfFloors} ];

(*** Reverse the specs so that the final answer is governed by the first duplicate spec ***)
Do[
resultVector[[ locateIt[ oneSpec[[1]] ] ]] = oneSpec[[2]],
{oneSpec, Reverse[ dofOrLoadSpec ]}
];

Switch[ OptionValue[ shearBuildingDOFOrdering ],
"floor" | "Floor", resultVector,
"building" | "Building" | Automatic, With[ {ord =  Join[ Range[ 1,3 * numberOfFloors, 3 ], Range[ 2,3 * numberOfFloors, 3 ], Range[ 3,3 * numberOfFloors, 3 ] ]}, resultVector[[ ord ]] ],
_, Message[ shearWalls::unknwnord, OptionValue[ shearBuildingDOFOrdering ] ]; $Failed
]

]


shearBuildingFromDOForLoadSpecToVector[ dofOrLoadSpec:{ (_ -> _) ... }, someBuilding_shearBuilding, someOptions:OptionsPattern[shearBuildingFromDOForLoadSpecToVector] ] := 
shearBuildingFromDOForLoadSpecToVector[ dofOrLoadSpec, shearBuildingNumberOfFloors[  someBuilding ], someOptions ]
shearBuildingFromDOForLoadSpecToVector[ dofOrLoadSpec:{ (_ -> _) ... }, someOptions:OptionsPattern[shearBuildingFromDOForLoadSpecToVector] ] := 
shearBuildingFromDOForLoadSpecToVector[ dofOrLoadSpec, Automatic, someOptions ]


(* ::Subsection::Closed:: *)
(*shearBuilding: shearBuildingGetWallShearForcesFromDOF, shearBuildingGetWallBendingMomentsFromDOF, shearBuildingGetWallDeltaDisplacementsFromDOF*)


shearBuildingGetWallShearForcesFromDOF[  a_shearBuilding, inDOF:{ _ ... }, someOptions:OptionsPattern[  shearBuildingGetWallShearForcesFromDOF ] ] := 
internalShearBuildingWallCalculate[  a, inDOF, shearWallShearForcesAlongWall, FilterRules[Flatten[ Join[ {someOptions}, Options[shearBuildingGetWallShearForcesFromDOF ] ] ],Options[internalShearBuildingWallCalculate ]] ]


shearBuildingGetWallBendingMomentsFromDOF[  a_shearBuilding, inDOF:{ _ ... }, someOptions:OptionsPattern[  shearBuildingGetWallBendingMomentsFromDOF ] ] := 
internalShearBuildingWallCalculate[  a, inDOF, shearWallBendingMomentPairs, FilterRules[Flatten[ Join[ {someOptions}, Options[shearBuildingGetWallBendingMomentsFromDOF ] ] ],Options[internalShearBuildingWallCalculate ]] ]


shearBuildingGetWallDeltaDisplacementsFromDOF[  a_shearBuilding, inDOF:{ _ ... }, someOptions:OptionsPattern[  shearBuildingGetWallDeltaDisplacementsFromDOF ] ] := 
Map[ Differences[ Prepend[ #, 0 ] ]&, internalShearBuildingWallCalculate[  a, inDOF, shearWallDisplacementMagnitudesAlongWall, FilterRules[Flatten[ Join[ {someOptions}, Options[shearBuildingGetWallDeltaDisplacementsFromDOF ] ] ],Options[internalShearBuildingWallCalculate ]] ] ]


internalShearBuildingWallCalculate[  a_shearBuilding, inDOF:{ _ ... }, whatMethod_, someOptions:OptionsPattern[  internalShearBuildingWallCalculate ] ] := 
Module[ { numberOfFloors, centersOfRotationRules,explicitCenterOfRotationRules, dofOrdering, heightList, wallList, theFloorCentersOfMass, dof, varUsed},

dofOrdering = OptionValue[  shearBuildingDOFOrdering ] /. Automatic -> $defaultDOFOrderingForAllMethods;
numberOfFloors = shearBuildingNumberOfFloors[ a ];
heightList = shearBuildingHeightList[ a ];
If[ MatchQ[inDOF,{ (Verbatim[ Rule ] | Verbatim[ RuleDelayed])[ _, _ ] ...} ],
varUsed = Union[ ToLowerCase /@ (Head /@ (First /@ inDOF)) ];
If[ Length[ Complement[ varUsed, $dofSpecStrings ] ] =!= 0,
(
Message[  shearWalls::dofSpecNotValidString, $dofSpecStrings, dofOrLoadSpec ];
Return[ $Failed ]
)
];
dof = shearBuildingFromDOForLoadSpecToVector[ inDOF, numberOfFloors, shearBuildingDOFOrdering->dofOrdering ],
dof = inDOF
];

centersOfRotationRules = OptionValue[ shearBuildingCentersOfRotationRules ];
If[ centersOfRotationRules === Automatic || Head[centersOfRotationRules ] =!= List || Length[centersOfRotationRules ] === 0,
centersOfRotationRules = { _ -> $centerOfMassMainKeyword } ];
theFloorCentersOfMass = shearBuildingCenterOfMassList[ a ];
explicitCenterOfRotationRules = Table[
floorNumber -> ( (floorNumber /. centersOfRotationRules) /. { (kw_ /; MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ kw ] ]) -> theFloorCentersOfMass[[ floorNumber ]]} ),
{floorNumber, 1, numberOfFloors}
];

wallList = shearBuildingWallList[ a ];

Table[
(
whatMethod[  whichWall, dof, heightList,
shearWallDOFOrdering -> dofOrdering,
shearWallCenterOfRotationRules -> explicitCenterOfRotationRules
]
),
{whichWall, wallList }
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: shearBuildingCalculateDOFFromForces*)


$gAccelerationDueToGravity = 9.81;


shearBuildingCalculateDOFFromForces[ a_shearBuilding, forceSpec:( { _ ... } | "gforce"[ gForceFraction_, gForceDirectionVector_, eccentricityDistance_ ] | "gforce"[ gForceFraction_, gForceDirectionVector_ ] | "gforce"[ gForceFraction_ ]), someOptions:OptionsPattern[  shearBuildingCalculateDOFFromForces ]  ] := 
Module[ { extendedOptions, stiffnessMatrix, caseCode, varUsed, fVector, numberOfFloors,
centersOfRotationRules, theFloorCentersOfMass, centersOfRotationList, listOfShearSlabs, massOfFloorsList, forceMagnitudesList,
unitDirectionOfLoad,dof, effEccentricity, effGForceDirection
 },

numberOfFloors = shearBuildingNumberOfFloors[ a ];
extendedOptions = Flatten[ Join[ {someOptions}, Options[ shearBuildingCalculateDOFFromForces ] ] ];
stiffnessMatrix = shearBuildingStiffnessMatrix[ a,  FilterRules[extendedOptions,Options[  shearBuildingStiffnessMatrix ]]  ];

caseCode = Which[
MatchQ[forceSpec,{ (Verbatim[ Rule ] | Verbatim[ RuleDelayed])[ _, _ ] ...}],  1,
MatchQ[forceSpec,"gforce"[ _, _, _ ] | "gforce"[ _, _ ] | "gforce"[ _ ]], 2,
True, 3
];

If[ caseCode == 1,
(
varUsed = Union[ ToLowerCase /@ (Head /@ (First /@ forceSpec)) ];
If[ Length[ Complement[ varUsed, $loadSpecStrings ] ] =!= 0,
(
Message[  shearWalls::loadSpecNotValidString, $loadSpecStrings, forceSpec ];
Return[ $Failed ]
)
];
fVector = shearBuildingFromDOForLoadSpecToVector[ forceSpec, shearBuildingNumberOfFloors[ a ], FilterRules[extendedOptions,Options[  shearBuildingFromDOForLoadSpecToVector ]] ];
)
];

If[ caseCode == 3,
fVector = Join[ Flatten[ forceSpec ], ConstantArray[ 0, {3 * numberOfFloors} ] ][[ 1;;3 * numberOfFloors ]];
];

If[ caseCode == 2,
(
theFloorCentersOfMass = shearBuildingCenterOfMassList[ a ];
listOfShearSlabs = shearBuildingSlabList[ a ];
massOfFloorsList = Table[ shearSlabMassSlabAndDeadMass[ listOfShearSlabs[[ floorNumber ]] ], {floorNumber, 1, numberOfFloors} ];
effEccentricity = If[ eccentricityDistance === Null, 0, eccentricityDistance ];
effGForceDirection = If[ gForceDirectionVector === Null, {1, 0}, gForceDirectionVector ];

centersOfRotationRules = OptionValue[  shearBuildingCentersOfRotationRules ];
If[  centersOfRotationRules === Automatic ||  MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ centersOfRotationRules ] ], centersOfRotationRules = { _ -> $centerOfMassMainKeyword } ];
centersOfRotationList =   Table[
(floorNumber /. Join[centersOfRotationRules, {_ -> $Failed } ]) /.  {(kw_ /; MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ kw ] ]) ->  theFloorCentersOfMass[[floorNumber ]]}, {floorNumber, 1, numberOfFloors} ];

forceMagnitudesList = gForceFraction *  $gAccelerationDueToGravity * massOfFloorsList;
unitDirectionOfLoad = Normalize[ effGForceDirection ];
fVector = Flatten[ Table[  forceMagnitudesList[[floorNumber]] * {  unitDirectionOfLoad, effEccentricity }, {floorNumber, 1, numberOfFloors} ] ];
Switch[ OptionValue[ shearBuildingDOFOrdering ] /. {Automatic -> $defaultDOFOrderingForAllMethods},
"floor" | "Floor", True,
"building" | "Building", With[ {ord =  Join[ Range[ 1,3 * numberOfFloors, 3 ], Range[ 2,3 * numberOfFloors, 3 ], Range[ 3,3 * numberOfFloors, 3 ] ]}, 
	fVector = fVector[[ ord ]] ],
_, Message[ shearWalls::unknwnord, OptionValue[ shearBuildingDOFOrdering ] ]; $Failed
];
)
];

dof = LinearSolve[stiffnessMatrix,fVector ];

dof
]


(* ::Subsection:: *)
(*---------------------     shearBuilding:  VIEWERS   ------------------------------*)


(* ::Subsection::Closed:: *)
(*shearBuilding: Viewer (opener) for results of response spectra analysis*)


shearBuildingEarthquakeResultsResponseSpectrumOpenerViewer[ res_ ] := 
Module[ {floorImageSize, doFloorGraphics, eigVec, theHeightList, periodsList, whatNowBldg, whatOrdering},
floorImageSize = 200;
whatNowBldg = (shearBuilding /. res);
eigVec= (shearBuildingModeShapes /. res);
periodsList = (shearBuildingModePeriods /. res);
whatOrdering = (shearBuildingDOFOrdering /. res);
showStickBuilding[ "initial" ];
theHeightList = shearBuildingGet[ whatNowBldg, shearBuildingHeightList ];

doFloorGraphics[ whatVar_, whatCombo_, whatUnits_ ] := Grid[ Module[ {whatBldg, whatToShow, numberOfFloors, whatGraphicList},
whatBldg = (shearBuilding /. res);
whatToShow = whatCombo /. (whatVar /. res);
numberOfFloors = shearBuildingGet[whatBldg, shearBuildingNumberOfFloors ];
whatGraphicList = shearBuildingDraw2D[ whatBldg,
shearBuildingDOFList->Automatic,
shearBuildingCenterOfRotation->$centerOfMassMainKeyword,
shearBuildingDisplacementScaleFactor->1,
shearBuildingRotationScaleFactor->1,
shearBuildingDOFOrdering->"building",
shearBuildingShowDeformedQ->False,
shearWallDrawType->Line,
shearWallDirectives->Directive[Opacity[1]],
shearBuildingAnnotateTextListsOnePerWall->whatToShow,
shearBuildingAnnotateUnits->whatUnits,
shearWallAnnotateStyleFunction->Identity,
shearWallAnnotateAlongPositiveNormalQ->True,
shearWallAnnotateDistanceFromWall->Automatic,
shearWallAnnotateOrientation->Automatic
 ];
Partition[ Table[ Graphics[ 
whatGraphicList[[ floorNumber ]],
PlotLabel -> Row[ {"floor: ", floorNumber}],
ImageSize -> floorImageSize, Frame -> True, FrameTicks -> None
] , {floorNumber, 1, numberOfFloors}], 4, 4, {1, 1}, {}  ] ],
Spacings -> { {{1}}, Automatic } ];

Column[
{
OpenerView[ {"Building specs:", shearBuildingSpecs[ (shearBuilding /. res), shearBuildingEdit->False ]} ],
OpenerView[ {"Analysis options:",
Column[ {
OpenerView[ {"Ordering of degrees of freedom (DOF):", (shearBuildingDOFOrdering /. res)} ],
OpenerView[ {"Earthquake motion direction:", (shearBuildingEarthquakeMotionDirection /. res)} ],
OpenerView[ {"Response spectrum displacements Sd(m):", With[ {v = (shearBuildingResponseSpectrumForDisplacementFunction /. res)}, 
Column[ {v, Manipulate[ Plot[ v[T], {T, 0, Tmax}, ImageSize -> 300, GridLines -> Automatic, Frame -> True, PlotRange -> All ], {{Tmax, 4, Dynamic[ Row[ {"Tmax = ", Tmax}]]}, 1, 8, 1}]}] ]} ]
}]
}],
OpenerView[ {"Mode periods:", (shearBuildingModePeriods /. res)} ],
OpenerView[ {"Mode mass contribution % ranking:", {#[[1]], Row[ {#[[2]], " %"}]}& /@ (shearBuildingModeVsMassContributionsPercent /. res)} ],
OpenerView[ {"Mode shapes",  
Column[ {
Manipulate[
whatNowBldg = (shearBuilding /. res);
eigVec= (shearBuildingModeShapes /. res);
periodsList = (shearBuildingModePeriods /. res);
whatOrdering = (shearBuildingDOFOrdering /. res);
theHeightList = shearBuildingGet[ whatNowBldg, shearBuildingHeightList ];
dofs = eigVec[[whichMode]];
showStickBuilding[ Sin[\[Alpha] // N]  If[ Head[ dofs ] === Rule, dofs // First, dofs ], theHeightList, amp {1, 1}, 0.5 ,
Directive[ Thickness[0.006] ],
Directive[ Thickness[0.004] ], 
Directive[ PointSize[0.04] ],
Directive[ PointSize[0.02], Blue ],
{1, 0}, whatOrdering,
"track", trackNum, Opacity[0.2]
 ]// Graphics3D[ #, Boxed -> False, ViewVertical -> {0, 0, 1},
PlotRange -> {{-4, 4}, {-4, 4}, {-0.1,Total[ theHeightList ] + 0.1}}, 
PlotLabel -> Grid[ {{Row[ {"Mode = ", whichMode}]}, {Row[ {"Period = ", NumberForm[periodsList[[ whichMode ]],3] , " seconds"}]}} ], ImageSize -> imSize ]&,
{dofs, ControlType -> None},
{{\[Alpha], \[Pi]/2., "\[Alpha]"}, 0, 2.\[Pi], 2.\[Pi] / 500., ControlType -> Manipulator, Appearance->"Open",AnimationRate-> 2.5 },
{{ whichMode, 1, "Mode"}, Table[ i, {i, 1, Length[ eigVec ]}],  Appearance -> If[ Length[ eigVec ] <= 3 * 15, "Vertical", Automatic ], ControlType -> If[ Length[ eigVec ] <= 3 * 15, SetterBar, PopupMenu ], ControlPlacement -> If[ Length[ eigVec ] <= 3 * 15, Right, Left ]},
Delimiter,
{{trackNum, 1, Dynamic[ Row[ {"track # = ", trackNum}]]}, {0, 1, 2, 3, 5, 10, 20}, ControlType -> SetterBar },
{{amp, 5, Dynamic[ Row[ {"amp = ", amp//N}]]}, 1, 10, 1/4},
Delimiter,
{{imSize, 150, "Image size:"}, {50, 100, 150, 200, 300, 400}, ControlType -> SetterBar},
ControlPlacement -> Left  ],
(shearBuildingModeShapes /. res)
 }]
 }],
OpenerView[{"DOF response:",Column[ {
OpenerView[ {"Modes",  Range[ Length[(shearBuildingModePeriods /. res) ] ] /. (shearBuildingDOFList /. res)} ], 
OpenerView[ {"CQC", $shearBuildingCQC /. (shearBuildingDOFList /. res)} ],
OpenerView[ {"SRSS", $shearBuildingSRSS /. (shearBuildingDOFList /. res)} ],
OpenerView[ {"Sum of absolute values", $shearBuildingSumAbsoluteValues /. (shearBuildingDOFList /. res)} ],
OpenerView[ {"Highest mode", $shearBuildingHighestMode /. (shearBuildingDOFList /. res)} ]
} ]} ], 
OpenerView[{"Wall shear forces response:",Column[ {
OpenerView[ {"Modes", Range[ Length[(shearBuildingModePeriods /. res) ] ] /. (shearBuildingDOFList /. res)} ], 
OpenerView[ {"CQC", $shearBuildingCQC /. (shearBuildingGetWallShearForcesFromDOF /. res)} ],
OpenerView[ {"SRSS", $shearBuildingSRSS /. (shearBuildingGetWallShearForcesFromDOF /. res)} ],
OpenerView[ {"Sum of absolute values", $shearBuildingSumAbsoluteValues /. (shearBuildingGetWallShearForcesFromDOF /. res)} ],
OpenerView[ {"Highest mode", $shearBuildingHighestMode /. (shearBuildingGetWallShearForcesFromDOF /. res)} ],
OpenerView[ {"CQC Figures", doFloorGraphics[ shearBuildingGetWallShearForcesFromDOF, $shearBuildingCQC, "N" ]} ]
} ]} ],
OpenerView[{"Wall bending moments response:",Column[ {
OpenerView[ {"Modes", Range[ Length[(shearBuildingModePeriods /. res) ] ] /. (shearBuildingDOFList /. res)} ], 
OpenerView[ {"CQC", $shearBuildingCQC /. (shearBuildingGetWallBendingMomentsFromDOF /. res)} ],
OpenerView[ {"SRSS", $shearBuildingSRSS /. (shearBuildingGetWallBendingMomentsFromDOF /. res)} ],
OpenerView[ {"Sum of absolute values", $shearBuildingSumAbsoluteValues /. (shearBuildingGetWallBendingMomentsFromDOF /. res)} ],
OpenerView[ {"Highest mode", $shearBuildingHighestMode /. (shearBuildingGetWallBendingMomentsFromDOF /. res)} ],
OpenerView[ {"CQC Figures", doFloorGraphics[ shearBuildingGetWallBendingMomentsFromDOF, $shearBuildingCQC, "Nm" ]} ]
} ]} ], 
OpenerView[{"Wall drifts response:",Column[ {
OpenerView[ {"Modes", Range[ Length[(shearBuildingModePeriods /. res) ] ] /. (shearBuildingDOFList /. res)} ], 
OpenerView[ {"CQC", $shearBuildingCQC /. (shearBuildingGetWallDeltaDisplacementsFromDOF /. res)} ],
OpenerView[ {"SRSS", $shearBuildingSRSS /. (shearBuildingGetWallDeltaDisplacementsFromDOF /. res)} ],
OpenerView[ {"Sum of absolute values", $shearBuildingSumAbsoluteValues /. (shearBuildingGetWallDeltaDisplacementsFromDOF /. res)} ],
OpenerView[ {"Highest mode", $shearBuildingHighestMode /. (shearBuildingGetWallDeltaDisplacementsFromDOF /. res)} ],
OpenerView[ {"CQC Figures", doFloorGraphics[ shearBuildingGetWallDeltaDisplacementsFromDOF, $shearBuildingCQC, "m" ]} ]
} ]} ]}
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Drawing 2D*)


shearBuildingDraw2D[ a_shearBuilding, OptionsPattern[ shearBuildingDraw2D ] ] := 
Module[ {wallList, numberOfWalls, numberOfFloors, theSlabCentroids,

textAnnotationListPerWall, textAnnotationUnits,

dsf, rsf, showDeformedQ,

inDof, centerOfRotation, dofOrdering, theFloorCentersOfMass, centersOfRotationRules
 },

wallList = shearBuildingWallList[ a ];
numberOfWalls = Length[ wallList ];
numberOfFloors = shearBuildingNumberOfFloors[ a ];
theSlabCentroids = shearBuildingSlabCentroids[ a ];

textAnnotationListPerWall = OptionValue[ shearBuildingAnnotateTextListsOnePerWall ];
If[ textAnnotationListPerWall === None || Head[textAnnotationListPerWall ] =!= List, textAnnotationListPerWall = {} ];
textAnnotationListPerWall = Join[ textAnnotationListPerWall, Table[ None, {numberOfWalls} ] ];
Do[  
Which[ 
textAnnotationListPerWall[[ wallNumber ]] === None,  textAnnotationListPerWall[[ wallNumber ]] = Table[ "", {numberOfFloors}],
Head[textAnnotationListPerWall[[ wallNumber ]] ] =!= List, textAnnotationListPerWall[[ wallNumber ]] = Table[ "", {numberOfFloors}],
Length[textAnnotationListPerWall[[ wallNumber ]] ] < numberOfFloors, textAnnotationListPerWall[[ wallNumber ]] = Join[ textAnnotationListPerWall[[ wallNumber ]], Table[ "", {numberOfFloors}] ]
],
{wallNumber, 1, numberOfWalls}
];
textAnnotationListPerWall = textAnnotationListPerWall /. None -> "";

textAnnotationUnits = OptionValue[ shearBuildingAnnotateUnits ];
If[  textAnnotationUnits =!= None,
textAnnotationListPerWall = Table[
If[ # =!= "", Row[ {#, " ",textAnnotationUnits} ], "" ]& /@ textAnnotationListPerWall[[ wallNumber ]],
{wallNumber, 1, numberOfWalls}
];
];

dsf = OptionValue[ shearBuildingDisplacementScaleFactor ] /. Automatic -> 1;
rsf = OptionValue[ shearBuildingRotationScaleFactor ] /. Automatic -> 1;
showDeformedQ = OptionValue[ shearBuildingShowDeformedQ ] /. Automatic -> False;

inDof = OptionValue[ shearBuildingDOFList ] /. Automatic -> Table[ 0, {3 numberOfFloors} ];
If[ Head[ inDof ] =!= List  || showDeformedQ === False, inDof = Table[ 0, {3 numberOfFloors} ] ];
If[ Length[ inDof ] < 3 numberOfFloors, inDof = Join[  inDof, Table[ 0, {3 numberOfFloors} ] ][[ 1;;3 numberOfFloors]]];

centerOfRotation = OptionValue[ shearBuildingCenterOfRotation ];
theFloorCentersOfMass = shearBuildingCenterOfMassList[ a ];
If[  centerOfRotation === Automatic ||  MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ centerOfRotation ] ],
centersOfRotationRules  = Table[ floorNumber -> theFloorCentersOfMass[[ floorNumber ]], {floorNumber, 1, numberOfFloors} ],
centersOfRotationRules = { _ -> centerOfRotation}
 ];

dofOrdering = OptionValue[ shearBuildingDOFOrdering ] /. Automatic -> $defaultDOFOrderingForAllMethods;

Transpose[ Table[
shearWallDraw2D[ wallList[[wallNumber ]],
shearWallNumberOfFloors->numberOfFloors,
shearWallDOFList->inDof,
shearWallDOFOrdering->dofOrdering,
shearWallCenterOfRotationRules-> centersOfRotationRules,
shearWallDisplacementScaleFactor->dsf,
shearWallRotationScaleFactor->rsf,
shearWallDrawType->OptionValue[ shearWallDrawType ],
shearWallDirectives->OptionValue[ shearWallDirectives ],
shearWallAnnotateStyleFunction->OptionValue[ shearWallAnnotateStyleFunction ],
shearWallAnnotateTextList->textAnnotationListPerWall[[ wallNumber ]],
shearWallAnnotateAlongPositiveNormalQ->OptionValue[ shearWallAnnotateAlongPositiveNormalQ ],
shearWallAnnotateDistanceFromWall->OptionValue[ shearWallAnnotateDistanceFromWall ],
shearWallAnnotateOrientation->OptionValue[ shearWallAnnotateOrientation ],
shearWallShowDeformedQ->showDeformedQ
 ],
{wallNumber, 1, numberOfWalls}
] ]
]


(* ::Subsection::Closed:: *)
(*shearBuilding: Drawing 3D*)


shearBuildingDraw[ a_shearBuilding, OptionsPattern[ shearBuildingDraw ] ] := 
Module[ {numberOfFloors, slabList,wallList, numberOfWalls, heightList, slabThicknessList,
zCoordinateList, xMin, xMax, yMin, yMax, zMin, zMax,

dsf, rsf, showDeformedQ, inDof, centerOfRotation, theFloorCentersOfMass, centersOfRotationRules, dofOrdering,
dofFloorOrderedArray,

wallsPrimitives, slabsPrimitives
},

numberOfFloors = shearBuildingNumberOfFloors[ a ];
slabList = shearBuildingSlabList[ a ];
wallList = shearBuildingWallList[ a ];
numberOfWalls = Length[ wallList ];
heightList = shearBuildingHeightList[ a ];
slabThicknessList = Table[  shearSlabThickness[  aSlab ], {aSlab, slabList}];
zCoordinateList = Accumulate[ heightList ];   (** z coordinate is at middle of slab **)
{ xMin, xMax, yMin, yMax, zMin, zMax } = Flatten[ shearBuildingXYZminmaxPairsList[ a ] ];


dsf = OptionValue[ shearBuildingDisplacementScaleFactor ] /. Automatic -> 1;
rsf = OptionValue[ shearBuildingRotationScaleFactor ] /. Automatic -> 1;
showDeformedQ = OptionValue[ shearBuildingShowDeformedQ ] /. Automatic -> False;

inDof = OptionValue[ shearBuildingDOFList ] /. Automatic -> Table[ 0, {3 numberOfFloors} ];
If[ Head[ inDof ] =!= List  || showDeformedQ === False, inDof = Table[ 0, {3 numberOfFloors} ] ];
If[ Length[ inDof ] < 3 numberOfFloors, inDof = Join[  inDof, Table[ 0, {3 numberOfFloors} ] ][[ 1;;3 numberOfFloors]]];

centerOfRotation = OptionValue[ shearBuildingCenterOfRotation ];
theFloorCentersOfMass = shearBuildingCenterOfMassList[ a ];
If[  centerOfRotation === Automatic ||  MemberQ[$centerOfMassLowercaseKeywordsList,ToLowerCase[ centerOfRotation ] ],
centersOfRotationRules  = Table[ floorNumber -> theFloorCentersOfMass[[ floorNumber ]], {floorNumber, 1, numberOfFloors} ],
centersOfRotationRules = { _ -> centerOfRotation}
 ];
dofOrdering = OptionValue[ shearBuildingDOFOrdering ] /. Automatic -> $defaultDOFOrderingForAllMethods;
dofFloorOrderedArray = Which[ 
dofOrdering === "Building" || dofOrdering === "building", Partition[ internalBuildingToFloor[ inDof ], 3, 3 ],
dofOrdering === "Floor" || dofOrdering === "floor", Partition[ inDof, 3, 3 ],
True, Return[ $Failed ]
];

wallsPrimitives = 
Table[ shearWallDraw[  wallList[[ wallNumber ]], 
shearWallDOFList->inDof,
shearWallDOFOrdering->dofOrdering,
shearWallCenterOfRotationRules-> centersOfRotationRules,
shearWallDisplacementScaleFactor->dsf,
shearWallRotationScaleFactor->rsf,
shearWallDrawType-> OptionValue[ shearWallDrawType ],
shearWallDirectives->OptionValue[ shearWallDirectives ],
shearWallHeightList-> heightList,
shearWallShowDeformedQ->showDeformedQ
 ], 
{wallNumber, 1, numberOfWalls, 1} ];


slabsPrimitives = Table[
shearSlabDraw[ slabList[[ floorNumber ]],
shearSlabDOF-> dofFloorOrderedArray[[ floorNumber ]],
shearSlabCenterOfRotation->(floorNumber /. centersOfRotationRules),
shearSlabZCoordinate->zCoordinateList[[ floorNumber ]],
shearSlabDisplacementScaleFactor->dsf,
shearSlabRotationScaleFactor->rsf,
shearSlabDrawType->OptionValue[ shearSlabDrawType ],
shearSlabDirectives->OptionValue[ shearSlabDirectives ]
 ],
{floorNumber, 1, numberOfFloors, 1} ];

{ 
wallsPrimitives, 
slabsPrimitives
}
] /; shearBuildingGet[ a, shearBuildingExistsQ ]


(* ::Subsection:: *)
(*shearBuilding: Showing and editing specs*)


(* ::Subsubsection::Closed:: *)
(*Main method*)


shearBuildingSpecs[ a_shearBuilding, OptionsPattern[ shearBuildingSpecs ] ] := 
Module[ {howToPresent, theData, theHeader, theAll,
numberOfFloors, wallList, wallWithMassList, numberOfWalls, slabList, isEditQ,

status3Dview, statusWalls, statusSlabs, statusWallWhat, statusSlabWhat,
statusAdvancedEditingWall, statusAdvancedEditingSlab, statusWallsMultiSetter, statusMassInfo,
statusMassSub1, statusMassSub2, statusMassSub3, statusMassSub4, statusMassSub5, statusMassSub6,
statusMassSub7,statusActionGroups, statusActionSubGroups, statusMassSub8, statusMassSub9,
statusAdvancedEditingHeight,

heightList, massMatrixLumped, massPerFloorList, mIpPerFloorList,

prepareData, prepareDataMethodID
},

(****************************************************************************************************************)
(******           Initializations and option values                                                    **********)
(****************************************************************************************************************)
howToPresent = OptionValue[ shearBuildingView ];
If[ Not[ MatchQ[ howToPresent, List | Table | Grid ] ], 
(
Message[ shearWalls::incon, howToPresent, shearBuildingView ];
Return[ $Failed ]
)
];
isEditQ = OptionValue[ shearBuildingEdit ] /. Automatic -> False;
If[isEditQ =!= True, isEditQ = False ];

theHeader = {{Row[ {"Building: ", a } ], SpanFromLeft},{"Parameter", "Value"}};


(****************************************************************************************************************)
(******           Opener status variables                                                              **********)
(****************************************************************************************************************)
{status3Dview, statusWalls, statusSlabs, statusAdvancedEditingWall, statusAdvancedEditingSlab, statusWallsMultiSetter, statusMassInfo, statusActionGroups,
statusAdvancedEditingHeight} = {False, False, False, False, False, False, False, False, False};
{statusMassSub1, statusMassSub2, statusMassSub3, statusMassSub4, statusMassSub5, statusMassSub6, statusMassSub7, statusMassSub8, statusMassSub9} = 
Table[ False, {9} ];

Do[  statusWallWhat[ i ] = False, {i, 1, 100}];
Do[  statusSlabWhat[ i ] = False, {i, 1, 100}];
statusWallWhat[ _ ] := False;
statusSlabWhat[ _ ] := False;
Do[ statusActionSubGroups[ i ] = False, {i, 1, 100}];
Do[ statusActionSubGroups[ 3, i ] = False, {i, 1, 100}];

(****************************************************************************************************************)
(******           Editors: Initializations                                                             **********)
(****************************************************************************************************************)
internalShearBuildingSpecsDataPrepare[ a, "group 1", isEditQ, prepareDataMethodID, "initial" ];
internalShearBuildingSpecsDataPrepare[ a, "group 2", isEditQ, prepareDataMethodID, "initial" ];
internalShearBuildingSpecsDataPrepare[ a, "mass info", isEditQ, prepareDataMethodID_, "initial" ];
internalShearBuildingSpecsDataPrepare[ a, "multi-editor", isEditQ, prepareDataMethodID, "initial" ];
internalShearBuildingSpecsDataPrepare[ a, "action", isEditQ, prepareDataMethodID, "initial" ];

(****************************************************************************************************************)
(******           Methods to prepare data for specs                                                    **********)
(****************************************************************************************************************)
prepareData[ "initial" ] := (
wallList = shearBuildingGet[ a, shearBuildingWallList];
wallWithMassList = Select[ wallList, shearWallIncludeMassQ[ # ]& ];
heightList = shearBuildingGet[ a, shearBuildingHeightList ];
numberOfWalls = Length[wallList ];
slabList = shearBuildingGet[ a, shearBuildingSlabList ];
numberOfFloors = shearBuildingNumberOfFloors[ a ];

massMatrixLumped = shearBuildingMassMatrix[ a, shearBuildingCentersOfRotationRules->{_->"centerOfMass"},shearBuildingDOFOrdering->"floor" ];
{massPerFloorList, mIpPerFloorList} = With[ {mv = Tr[ massMatrixLumped, List ]},
{ mv[[ 3 (Range[ numberOfFloors ]-1) + 1 ]], mv[[ 3 (Range[ numberOfFloors ]-1) + 3 ]]}
];
);

prepareData[ "group 1" ] := internalShearBuildingSpecsDataPrepare[ a, "group 1", isEditQ, prepareDataMethodID, heightList, 
Unevaluated[ statusAdvancedEditingHeight ], Unevaluated[ statusAdvancedEditingWall ],   Unevaluated[ statusAdvancedEditingSlab ] ];

prepareData[ "group 2" ] := internalShearBuildingSpecsDataPrepare[ a, "group 2", isEditQ, prepareDataMethodID, numberOfWalls, numberOfFloors, wallList, slabList,
Unevaluated[ status3Dview ], Unevaluated[ statusWalls ],  Unevaluated[ statusSlabs ], Unevaluated[ statusWallWhat ], Unevaluated[ statusSlabWhat ] ];

prepareData[ "mass info" ] := internalShearBuildingSpecsDataPrepare[ a, "mass info", isEditQ, prepareDataMethodID, slabList, heightList, wallWithMassList, numberOfFloors, massPerFloorList, mIpPerFloorList, 
Unevaluated[ statusMassSub1 ], Unevaluated[ statusMassSub2 ], Unevaluated[ statusMassSub3 ], Unevaluated[ statusMassSub4 ], Unevaluated[ statusMassSub5 ], 
Unevaluated[ statusMassSub6 ], Unevaluated[ statusMassSub7 ], Unevaluated[ statusMassSub8 ], Unevaluated[ statusMassSub9 ], Unevaluated[ statusMassInfo ] ];

prepareData[ "multi-editor" ] := internalShearBuildingSpecsDataPrepare[ a, "multi-editor", isEditQ, prepareDataMethodID, Unevaluated[ statusWallsMultiSetter ] ];

prepareData[ "action" ] := internalShearBuildingSpecsDataPrepare[ a, "action", isEditQ, prepareDataMethodID, heightList, numberOfFloors, wallList, wallWithMassList, numberOfWalls, slabList, massMatrixLumped, massPerFloorList, mIpPerFloorList, Unevaluated[ statusActionGroups ], Unevaluated[ statusActionSubGroups ] ];

(****************************************************************************************************************)
(******           Data for specs                                                                       **********)
(****************************************************************************************************************)
theData := (
prepareData[ "initial" ];
Join[ 
prepareData[ "group 1" ],
prepareData[ "group 2" ],
prepareData[ "mass info" ],
prepareData[ "multi-editor" ],
prepareData[ "action" ]
]
);

theAll := Join[ theHeader, If[ isEditQ,theData, Delete[ theData, -2 ]  ]];

(****************************************************************************************************************)
(******           Presenting the data                                                                  **********)
(****************************************************************************************************************)
If[ isEditQ,
Switch[ 
howToPresent,
List, theAll,
Table, MatrixForm[ theAll ],
_, Grid[ theAll, Spacings -> {{{2}}, Automatic}, Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, Thick, {True}, Thick}}, Alignment -> Left ]
] // Dynamic,
Switch[ 
howToPresent,
List, theAll,
Table, MatrixForm[ theAll ],
_, Grid[ theAll, Spacings -> {{{2}}, Automatic}, Dividers -> {{Thick, {True}, Thick}, {Thick, Thick, Thick, {True}, Thick}}, Alignment -> Left ]
] // Dynamic
]

] /; shearBuildingGet[ a, shearBuildingExistsQ ]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "group 1"*)


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "group 1", isEditQ_, prepareDataMethodID_, "initial" ] := 
Module[ {},

prepareDataMethodID[ "numberOfFloorsEditor" ] = internalSingleInputFieldEditor[ (shearBuildingPut[ a, shearBuildingNumberOfFloors, # ] === $Failed)&, shearBuildingNumberOfFloors[ a ]& ];
prepareDataMethodID[ "dampingRatioEditor" ] = internalSingleInputFieldEditor[ (shearBuildingPut[ a, shearBuildingDampingRatio, # ] === $Failed)&, shearBuildingDampingRatio[ a ]& ];
prepareDataMethodID[ "heightRulesEditor" ] = internalSingleValueRuleListEditor[ shearBuildingPut[ a, shearBuildingHeightRules, # ]&, shearBuildingHeightRules[ a ]&, N ];
prepareDataMethodID[ "advancedHeightEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingHeightRules, # ] === $Failed ],
prepareDataMethodID[ "heightRulesEditor" ] = internalSingleValueRuleListEditor[ shearBuildingPut[ a, shearBuildingHeightRules, # ]&, shearBuildingHeightRules[ a ]&, N ] ])&, shearBuildingHeightRules[ a ]& ];
prepareDataMethodID[ "advancedWallEditor" ] = internalSingleInputFieldEditor[ (shearBuildingPut[ a, shearBuildingWallList, # ] === $Failed)&, shearBuildingWallList[ a ]& ];
prepareDataMethodID[ "advancedSlabEditor" ] = internalSingleInputFieldEditor[ (shearBuildingPut[ a, shearBuildingSlabRules, # ] === $Failed)&, shearBuildingSlabRules[ a ]& ];
]


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "group 1", isEditQ_, prepareDataMethodID_, heightList_, 
statusAdvancedEditingHeight_, statusAdvancedEditingWall_,  statusAdvancedEditingSlab_ ] := 
Module[ {},
{
{"Number of floors: ", If[ isEditQ,
prepareDataMethodID[ "numberOfFloorsEditor" ],
shearBuildingNumberOfFloors[ a]  ]},

{"Damping ratio (uniform): ", If[ isEditQ,
prepareDataMethodID[ "dampingRatioEditor" ],
shearBuildingDampingRatio[ a]  ]},

{"Height rules: ", If[ isEditQ,
Column[ {
prepareDataMethodID[ "heightRulesEditor" ],
Row[{"Height list (implied from rules): ", heightList } ],
OpenerView[{"Advanced editing: ",prepareDataMethodID[ "advancedHeightEditor" ] },Dynamic[statusAdvancedEditingHeight ] ]
}],
Column[ {
shearBuildingHeightRules[ a],
Row[{"Height list (implied from rules): ", heightList } ]
}]  ]},

{"Wall rules: ", If[ isEditQ,
Column[ {
shearBuildingGet[ a, shearBuildingWallList],
OpenerView[{"Advanced editing: ",prepareDataMethodID[ "advancedWallEditor" ] }, Dynamic[statusAdvancedEditingWall ] ]
}],
shearBuildingGet[ a, shearBuildingWallList]  ]},

{"Slab rules: ", If[ isEditQ,
Column[ {
shearBuildingGet[ a, shearBuildingSlabRules],
OpenerView[{"Advanced editing: ",prepareDataMethodID[ "advancedSlabEditor" ] }, Dynamic[statusAdvancedEditingSlab ] ]
}],
shearBuildingGet[ a, shearBuildingSlabRules]  ]}
}
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "group 2"*)


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "group 2", isEditQ_, prepareDataMethodID_, "initial" ] := 
Module[ {},
Null
]


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "group 2", isEditQ_, prepareDataMethodID_, numberOfWalls_, numberOfFloors_, wallList_, slabList_,
status3Dview_, statusWalls_,  statusSlabs_, statusWallWhat_, statusSlabWhat_ ] := 
Module[ {},
{
{Item[ OpenerView[ {
"3-D view: ",
Graphics3D[ shearBuildingDraw[ a, shearWallDirectives->Directive[Opacity[0.3]], shearSlabDirectives->Directive[Opacity[0.3]]  ],
Boxed -> False ]}, Dynamic[status3Dview ]
], Alignment -> Left ], SpanFromLeft
},

{Item[ OpenerView[ {
"Walls in building: ",
Column[ 
Table[ OpenerView[{Row[ {"Wall (", wallList[[wallNumber]], ") : "}],shearWallSpecs[ wallList[[wallNumber]], shearWallEdit -> isEditQ ]},
With[ {wallNumber = wallNumber}, Dynamic[ statusWallWhat[ wallNumber ] ] ] ], {wallNumber, numberOfWalls}]
]}, Dynamic[statusWalls ]
], Alignment -> Left ], SpanFromLeft
},

{Item[ OpenerView[ {
"Slabs in building: ",
Column[ 
Table[ OpenerView[{Row[ {"Slab (", slabList[[floorNumber]], ") at floor: ", floorNumber}],shearSlabSpecs[ slabList[[floorNumber]], shearSlabEdit -> isEditQ ]},
With[ {floorNumber = floorNumber}, Dynamic[ statusSlabWhat[ floorNumber ] ]] ], {floorNumber, numberOfFloors}]
]}, Dynamic[statusSlabs ]
], Alignment -> Left ], SpanFromLeft
}
}
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "mass info"*)


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "mass info", isEditQ_, prepareDataMethodID_, "initial" ] := 
Module[ {},
Null
]


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "mass info", isEditQ_, prepareDataMethodID_, slabList_, heightList_, wallWithMassList_, numberOfFloors_, massPerFloorList_, mIpPerFloorList_, 
statusMassSub1_, statusMassSub2_, statusMassSub3_, statusMassSub4_, statusMassSub5_, statusMassSub6_, statusMassSub7_, statusMassSub8_, statusMassSub9_, statusMassInfo_ ] := 
Module[ {},
{
{Item[ OpenerView[ {
"Mass information:",
Grid[ {
{"Total building mass = ", Total[Flatten[  Join[ shearSlabMassSlabAndDeadMass /@ slabList, shearWallMassList[#, heightList ]& /@ wallWithMassList] ] ]},
{"Total wall mass = ", Total[Flatten[  Join[ shearWallMassList[#, heightList ]& /@ wallWithMassList] ] ]},
{"Total slab only mass = ", Total[Flatten[  Join[ shearSlabMassSlabOnly /@ slabList ] ] ]},
{"Total dead load only mass = ", Total[Flatten[  Join[ shearSlabAdditionalDeadMassAtCentroid /@ slabList ] ] ]},

{Item[ OpenerView[ {"Total lumped mass per floor: ", Thread[ Range[ numberOfFloors ] -> massPerFloorList ]}, Dynamic[statusMassSub8 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Total lumped mass MOI per floor (relative to center of mass of each floor): ", Thread[ Range[ numberOfFloors ] -> mIpPerFloorList ]}, Dynamic[statusMassSub9 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Centers of mass (floor \[Rule] center): ", Thread[ Range[ numberOfFloors ] -> (shearBuildingCenterOfMassList[a]) ]}, Dynamic[statusMassSub7 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Slabs - mass slab only list (floor \[Rule] mass): ", Thread[ Range[ numberOfFloors ] -> (shearSlabMassSlabOnly /@ slabList) ]}, Dynamic[statusMassSub1 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Slabs - mass slab and dead mass list (floor \[Rule] mass): ", Thread[ Range[ numberOfFloors ] -> (shearSlabMassSlabAndDeadMass /@ slabList) ]}, Dynamic[statusMassSub2 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Slabs - mass Polar MOI relative to centroid list (floor \[Rule] massPolarMOI): ", Thread[ Range[ numberOfFloors ] -> (shearSlabMassPolarMomentOfInertiaRelativeToCentroid /@ slabList) ]}, Dynamic[statusMassSub3 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Walls - mass per floor list (floor \[Rule] mass): ", If[ Length[ wallWithMassList ] > 0, Thread[ Range[ numberOfFloors ] -> (Plus @@ (shearWallMassList[#, heightList ]& /@ wallWithMassList)) ], 0 ]}, Dynamic[statusMassSub4 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Walls - mass Polar MOI relative to midpoints per floor list (floor \[Rule] massPolarMOI): ",If[ Length[ wallWithMassList ] > 0,  Thread[ Range[ numberOfFloors ] -> (Plus @@ (shearWallMassPolarMomentOfInertiaList[#, heightList, shearWallCenterOfRotationRules -> {_ -> Automatic} ]& /@ wallWithMassList)) ], 0 ]}, Dynamic[statusMassSub5 ] ], Alignment -> Left ], SpanFromLeft
},
{Item[ OpenerView[ {"Walls - mass lumped per floor list (floor \[Rule] mass): ", If[ Length[ wallWithMassList ] > 0,  Thread[ Range[ numberOfFloors ] -> (Plus @@ (shearWallMassLumpedList[#, heightList ]& /@ wallWithMassList)) ], 0 ]}, Dynamic[statusMassSub6 ] ], Alignment -> Left ], SpanFromLeft
}
},
Dividers -> {{{True}}, {{True}}}
]}, Dynamic[statusMassInfo ]
], Alignment -> Left ], SpanFromLeft
}
}
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:  "multi-editor"*)


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "multi-editor", isEditQ_, prepareDataMethodID_, "initial" ] := 
Module[ {shearMod, youngMod, stiffWhat, wallTh, wallSG, wallMassQ, slabSG, slabTh},

Do[ Evaluate[ whatVar ] = "", {whatVar, {shearMod, youngMod, stiffWhat, wallTh, wallSG, wallMassQ, slabSG, slabTh}} ];

prepareDataMethodID[ "shearModulusEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingShearModulus, # ] === $Failed ], shearMod = # ])&, shearMod& ];

prepareDataMethodID[ "youngsModulusEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingYoungsModulus, # ] === $Failed ], youngMod = # ])&, youngMod& ];

prepareDataMethodID[ "whatStiffnessEditor" ] = 
internalSinglePopupEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingIncludeWhatStiffness, # ] === $Failed ], stiffWhat = # ])&, stiffWhat&, {shearWallIncludeShearAndBendingTypes,shearWallIncludeShearTypeOnly, shearWallIncludeBendingTypeOnly} ];

prepareDataMethodID[ "whatThicknessMultiSetterEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingWallThicknessRules, {Global`i_ -> #} ] === $Failed ], wallTh = # ])&, wallTh& ];

prepareDataMethodID[ "wallSpecificGravityEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingWallSpecificGravity, # ] === $Failed ], wallSG = # ])&, wallSG& ];

prepareDataMethodID[ "wallIncludeMassEditor" ] = internalSingleCheckboxEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingWallIncludeMassQ, # ] === $Failed ], wallMassQ = # ])&, wallMassQ& ];

prepareDataMethodID[ "slabSpecificGravityEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingSlabSpecificGravity, # ] === $Failed ], slabSG = # ])&, slabSG& ];

prepareDataMethodID[ "slabThicknessEditor" ] = internalSingleInputFieldEditor[ (If[ Not[ shearBuildingPut[ a, shearBuildingSlabThickness, # ] === $Failed ], slabTh = # ])&, slabTh& ];

]


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "multi-editor", isEditQ_, prepareDataMethodID_, statusWallsMultiSetter_ ] := 
Module[ {},
{
If[ isEditQ,
{Item[ OpenerView[ {
"Walls/Slabs multi-setter: ",
Column[ 
{
Row[ {"Wall shear modulus: ", prepareDataMethodID[ "shearModulusEditor" ]}], 
Row[ {"Wall Young's modulus: ", prepareDataMethodID[ "youngsModulusEditor" ]}], 
Row[ {"Wall thickness (all; 'i' is floor number): i_ \[Rule] ", prepareDataMethodID[ "whatThicknessMultiSetterEditor" ]}], 
Row[ {"Wall stiffness type: ", prepareDataMethodID[ "whatStiffnessEditor" ]}],
Row[ {"Wall specific gravity: ", prepareDataMethodID[ "wallSpecificGravityEditor" ]}], 
Row[ {"Wall include mass? ", prepareDataMethodID[ "wallIncludeMassEditor" ]}],
"------------------------------------------------------------",
Row[ {"Slab specific gravity: ", prepareDataMethodID[ "slabSpecificGravityEditor" ]}], 
Row[ {"Slab thickness: ", prepareDataMethodID[ "slabThicknessEditor" ]}]
}
]}, Dynamic[statusWallsMultiSetter ]
], Alignment -> Left ], SpanFromLeft},
{}
]
}
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - main*)


$actionResponseSpectrumASCE7 = "ASCE-7 - acceleration";
$actionResponseSpectrumEurocode8Elastic = "Eurocode 8 elastic - acceleration";
$actionResponseSpectrumElCentro1940NF = "El-Centro 1940 - acceleration (NF)";


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "action", isEditQ_, prepareDataMethodID_, "initial" ] := 
Module[ {whatAllWallCalc, loadSpec, responseSpectrumGlobalClassSelection, responseSpectrumEarthquakeDirection },
(**** Eigensystem - No initializations needed *****)


(**** Static wall calculations *****)
whatAllWallCalc = shearBuildingGetWallShearForcesFromDOF;
loadSpec = {};
prepareDataMethodID[ "wall calculation static load function" ] = SetterBar[ Dynamic[whatAllWallCalc ],{ shearBuildingGetWallShearForcesFromDOF -> "shear", shearBuildingGetWallBendingMomentsFromDOF -> "moments", shearBuildingGetWallDeltaDisplacementsFromDOF -> "drift"}];
prepareDataMethodID[ "whatAllWallCalc" ] := whatAllWallCalc;

prepareDataMethodID[ "wall calculation static load spec" ] = InputField[Dynamic[ loadSpec ] ];
prepareDataMethodID[ "loadSpec" ] := loadSpec;

(**** Response spectra calculations *****)
responseSpectrumGlobalClassSelection = $actionResponseSpectrumASCE7;
prepareDataMethodID[ "response spectrum class selector" ] = 
PopupMenu[ Dynamic[ responseSpectrumGlobalClassSelection ], {$actionResponseSpectrumASCE7, $actionResponseSpectrumEurocode8Elastic, $actionResponseSpectrumElCentro1940NF}];
prepareDataMethodID[ "responseSpectrumGlobalClassSelection" ] := responseSpectrumGlobalClassSelection;

responseSpectrumEarthquakeDirection = 0;
prepareDataMethodID[ "response spectrum earthquake direction" ] = Row[ {InputField[Dynamic[ responseSpectrumEarthquakeDirection ] ], "\[Degree]  (input in degrees - 0 \[Implies] {1, 0})"} ];
prepareDataMethodID[ "responseSpectrumEarthquakeDirection" ] := responseSpectrumEarthquakeDirection;
]


internalShearBuildingSpecsDataPrepare[ a_shearBuilding, "action", isEditQ_, prepareDataMethodID_, heightList_, numberOfFloors_, wallList_, wallWithMassList_, numberOfWalls_, slabList_, massMatrixLumped_, massPerFloorList_, mIpPerFloorList_, statusActionGroups_, statusActionSubGroups_] := 
Module[ {},
{
{Item[ OpenerView[ {
"Action buttons: ",
Grid[ 
{
{OpenerView[ {"Eigenanalysis (periods and shapes):", internalActionGroupEigenanalysis[ a, heightList  ]}, Dynamic[ statusActionSubGroups[1] ] ]},

{OpenerView[ {"Static load application:", internalActionGroupStaticLoadApplication[ a, heightList,prepareDataMethodID  ]}, Dynamic[ statusActionSubGroups[2] ]]},

{OpenerView[ {"Response spectra application:", internalActionGroupResponseSpectrumAnalysis[ a, heightList,prepareDataMethodID, Unevaluated[statusActionSubGroups ]  ]}, Dynamic[ statusActionSubGroups[3] ]]}

},
Alignment -> Left,
Spacings -> {{{2}}, {{1}}}
]}, Dynamic[statusActionGroups ]
], Alignment -> Left ], SpanFromLeft}
}
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - eigenanalysis*)


internalActionGroupEigenanalysis[ a_shearBuilding, heightList_  ] := Grid[{ {Button[ " Do eigenanalysis: ",SelectionMove[ ButtonNotebook[], After, ButtonCell ];NotebookWrite[  ButtonNotebook[],  Cell[BoxData[ToBoxes[shearBuildingEigensystem[ a ]]],"Output"] ]  ],
Button[ " Make shapes viewer: ", Module[ {eigRes, eigVec, periodsList},
eigRes = shearBuildingEigensystem[ a, shearBuildingDOFOrdering->"floor" ];
eigVec = shearBuildingModeShapes /. eigRes;
periodsList = shearBuildingModePeriods /. eigRes;
SelectionMove[ ButtonNotebook[], After, ButtonCell ]; NotebookWrite[  ButtonNotebook[], Cell[BoxData[ToBoxes[makeStickViewApp[ eigVec, periodsList, heightList ]]],"Output"] ]] ]} }, 
Spacings -> {{{2}}, Automatic},
Dividers -> { {True, {False}, True}, {True, {False}, True}}]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - static load application*)


internalActionGroupStaticLoadApplication[ a_shearBuilding, heightList_,prepareDataMethodID_  ] := 
Module[ {whatAllWallCalc, whatLoadSpec, dof, wallCalcRes},
Grid[ {
{"What to calculate: ", prepareDataMethodID[ "wall calculation static load function" ]},
{Tooltip[ "Load specification: ", "{ (\"fx\" | \"fy\" | \"T\")[ index ] \[Rule] value ... } | \"gforce\"[ forceFraction, directionVector, eccentricityDistance ]"], prepareDataMethodID[ "wall calculation static load spec" ]},
{Button[ "Calculate", 
(
whatAllWallCalc = prepareDataMethodID[ "whatAllWallCalc" ];
whatLoadSpec = prepareDataMethodID[ "loadSpec" ];
dof = shearBuildingCalculateDOFFromForces[ a, whatLoadSpec,
shearBuildingCentersOfRotationRules->{_->"centerOfMass"},
shearBuildingDOFOrdering->"building"];
If[ dof =!= $Failed,
(
SelectionMove[ ButtonNotebook[], After, ButtonCell ];
NotebookWrite[  ButtonNotebook[],  
Cell[BoxData[ToBoxes[ whatAllWallCalc -> Chop[ whatAllWallCalc[ a, dof, 
shearBuildingCentersOfRotationRules->{_->"centerOfMass"},
shearBuildingDOFOrdering->"building"] ]]],"Output"] ]
),
Beep[]
]
)
], Button[ "Show on walls", (
whatAllWallCalc = prepareDataMethodID[ "whatAllWallCalc" ];
whatLoadSpec = prepareDataMethodID[ "loadSpec" ];
dof = shearBuildingCalculateDOFFromForces[ a, whatLoadSpec,
shearBuildingCentersOfRotationRules->{_->"centerOfMass"},
shearBuildingDOFOrdering->"building"];
wallCalcRes = Chop[ whatAllWallCalc[ a, dof, 
shearBuildingCentersOfRotationRules->{_->"centerOfMass"},
shearBuildingDOFOrdering->"building"] ];
If[ dof =!= $Failed,
(
SelectionMove[ ButtonNotebook[], After, ButtonCell ];
NotebookWrite[  ButtonNotebook[],  
Cell[BoxData[ToBoxes[ Graphics /@ shearBuildingDraw2D[ a,
shearBuildingDOFList->Automatic,shearBuildingCenterOfRotation->"centerOfMass",shearBuildingDisplacementScaleFactor->1,shearBuildingRotationScaleFactor->1,shearBuildingDOFOrdering->"building",shearBuildingShowDeformedQ->False,shearWallDrawType->Line,shearWallDirectives->Directive[Opacity[1]],shearBuildingAnnotateTextListsOnePerWall->wallCalcRes,
shearBuildingAnnotateUnits->(Which[ whatAllWallCalc === shearBuildingGetWallShearForcesFromDOF, "N",
whatAllWallCalc === shearBuildingGetWallBendingMomentsFromDOF,"Nm",
whatAllWallCalc === shearBuildingGetWallDeltaDisplacementsFromDOF, "m",
True, "Unknown" ]),
shearWallAnnotateStyleFunction->Identity,
shearWallAnnotateAlongPositiveNormalQ->False,
shearWallAnnotateDistanceFromWall->Automatic,shearWallAnnotateOrientation->Automatic
 ]]],"Output"] ]
),
Beep[]
]
) ]}
},
Spacings -> {{{2}}, Automatic},
Dividers -> { {True, {False}, True}, {True, {False}, True}} ]
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - response spectrum analysis - main*)


internalActionGroupResponseSpectrumAnalysis[ a_shearBuilding, heightList_,prepareDataMethodID_, statusActionSubGroups_ ] := 
Module[ {responseSpectrumGlobalClassSelection, eqDirection},
responseSpectrumGlobalClassSelection = $actionResponseSpectrumASCE7;
Grid[ {
{OpenerView[{Row[ {"Data for ", $actionResponseSpectrumASCE7}], 
internalActionGroupResponseSpectrumAnalysisDataInput[ $actionResponseSpectrumASCE7, a ]}, Dynamic[ statusActionSubGroups[ 3, 1 ] ]], SpanFromLeft},
{OpenerView[{Row[ {"Data for ", $actionResponseSpectrumEurocode8Elastic}], 
internalActionGroupResponseSpectrumAnalysisDataInput[ $actionResponseSpectrumEurocode8Elastic, a ]}, Dynamic[ statusActionSubGroups[ 3, 2 ] ]], SpanFromLeft},
{OpenerView[{Row[ {"Data for ", $actionResponseSpectrumElCentro1940NF}], 
internalActionGroupResponseSpectrumAnalysisDataInput[ $actionResponseSpectrumElCentro1940NF, a ]}, Dynamic[ statusActionSubGroups[ 3, 3 ] ]], SpanFromLeft},
{"Which response spectra family: ", prepareDataMethodID[ "response spectrum class selector" ]},
{"Earthquake direction: ", prepareDataMethodID[ "response spectrum earthquake direction" ]},
{Button[ "Calculate", 
(
responseSpectrumGlobalClassSelection = prepareDataMethodID[ "responseSpectrumGlobalClassSelection" ];
eqDirection = With[ {\[Theta] =prepareDataMethodID[ "responseSpectrumEarthquakeDirection" ]}, {Cos[\[Theta] Degree], Sin[\[Theta] Degree]} // N ];
(
SelectionMove[ ButtonNotebook[], After, ButtonCell ];
NotebookWrite[  ButtonNotebook[],  
Cell[BoxData[ToBoxes[ Which[
responseSpectrumGlobalClassSelection === $actionResponseSpectrumASCE7, 
	internalActionGroupResponseSpectrumAnalysisExecute[ $actionResponseSpectrumASCE7, a,  eqDirection],
responseSpectrumGlobalClassSelection === $actionResponseSpectrumEurocode8Elastic, 
	internalActionGroupResponseSpectrumAnalysisExecute[ $actionResponseSpectrumEurocode8Elastic, a, eqDirection ],
responseSpectrumGlobalClassSelection === $actionResponseSpectrumElCentro1940NF, 
	internalActionGroupResponseSpectrumAnalysisExecute[ $actionResponseSpectrumElCentro1940NF, a, eqDirection ]
]]],"Output"] ]
)
)
],  SpanFromLeft }
},
Spacings -> {{{2}}, {1, 2, 2, 2, 1, 1}},
Dividers -> { {True, {False}, True}, {True, {True}, True, False, False, True}},
Alignment -> Left ]
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - response spectrum analysis - Eurocode*)


localEurocode`spectrumEuroCodeHowToSpecify = "type";
localEurocode`spectraType = 1;
localEurocode`groundType = "A";
localEurocode`valS = responseSpectrumAccelerationEurocodeElastic2004["constants", localEurocode`spectraType, localEurocode`groundType ][[1]];
localEurocode`valTB = responseSpectrumAccelerationEurocodeElastic2004["constants", localEurocode`spectraType, localEurocode`groundType ][[2]];
localEurocode`valTC = responseSpectrumAccelerationEurocodeElastic2004["constants", localEurocode`spectraType, localEurocode`groundType ][[3]];
localEurocode`valTD = responseSpectrumAccelerationEurocodeElastic2004["constants", localEurocode`spectraType, localEurocode`groundType ][[4]];

localEurocode`valTypeAag = 3.432275;
localEurocode`valCorrectionFactor\[Eta] = Automatic;


internalActionGroupResponseSpectrumAnalysisDataInput[ $actionResponseSpectrumEurocode8Elastic, a_shearBuilding ] = 
Dynamic[ Grid[ {
{Style["   Alternative parameter specification: ", FontWeight -> Bold] , SpanFromLeft},
{SetterBar[Dynamic[localEurocode`spectrumEuroCodeHowToSpecify ], {"type" -> " Class and ground type ", "values"-> "  Explicit constants " }], SpanFromLeft},
If[ (localEurocode`spectrumEuroCodeHowToSpecify === "type"),
{localEurocode`valS, localEurocode`valTB, localEurocode`valTC, localEurocode`valTD} = responseSpectrumAccelerationEurocodeElastic2004["constants", localEurocode`spectraType, localEurocode`groundType ];
];
{ SetterBar[Dynamic[ localEurocode`spectraType ],{1, 2}, Enabled -> (localEurocode`spectrumEuroCodeHowToSpecify === "type")],
SetterBar[Dynamic[ localEurocode`groundType ],{"A", "B", "C", "D", "E"}, Enabled ->  (localEurocode`spectrumEuroCodeHowToSpecify === "type")] },
{Item[ "       or", Alignment -> Left ], SpanFromLeft},
{Grid[ {
{"S: ", InputField[ Dynamic[localEurocode`valS ], Number, Enabled ->  (localEurocode`spectrumEuroCodeHowToSpecify === "values")]},
{"TB: ", InputField[ Dynamic[localEurocode`valTB ],  Number, Enabled ->  (localEurocode`spectrumEuroCodeHowToSpecify === "values")]},
{"TC: ", InputField[ Dynamic[localEurocode`valTC ],  Number, Enabled ->  (localEurocode`spectrumEuroCodeHowToSpecify === "values")]},
{"TD: ", InputField[ Dynamic[localEurocode`valTD ],  Number, Enabled ->  (localEurocode`spectrumEuroCodeHowToSpecify === "values")]}
},
Alignment -> Left
], SpanFromLeft
},
{ Style["   Common parameter specification: ", FontWeight -> Bold], SpanFromLeft},
{Grid[ {
{"Type A ground acceleration: ", InputField[ Dynamic[localEurocode`valTypeAag ], Number]}},
Alignment -> Left
], SpanFromLeft
},
{
Plot[ responseSpectrumAccelerationEurocodeElastic2004[ Tv, 
"designGroundAccelerationOnTypeAGround$ag"->localEurocode`valTypeAag,
"dampingRatio$\[Xi]"->shearBuildingGet[ a, shearBuildingDampingRatio ],
"dampingCorrectionFactor$\[Eta]"->localEurocode`valCorrectionFactor\[Eta],

"eurocodeTypeOfElasticResponseSpectra"->localEurocode`spectraType,
"eurocodeGroundType"->localEurocode`groundType,

"lowerLimitPeiodOfConstantAcceleration$TB"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valTB ],
"upperLimitPeiodOfConstantAcceleration$TC"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valTC ],
"valueDefiningBeginningConstantDisplacement$TD"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valTD ],
"soilFactor$S"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valS ]
 ],
{Tv, 0,1.5 localEurocode`valTD}, 
ImageSize -> 300,
PlotRange -> {0, All}
], SpanFromLeft
}
},
Alignment -> Left,
Spacings -> { Automatic, { 0,1, 1, 1,1,  3,1, 3, {0}}},
Dividers -> { {{False}},  { False, False, False, False,False,  True,False, True,{False}}}
] ];


internalActionGroupResponseSpectrumAnalysisExecute[ $actionResponseSpectrumEurocode8Elastic, a_shearBuilding, earthquakeDirection_ ] := 
Module[ {accelerationSpectrum},

accelerationSpectrum[ Tp_ ] := (Tp / (2\[Pi]))^2 * responseSpectrumAccelerationEurocodeElastic2004[ Tp, 
"designGroundAccelerationOnTypeAGround$ag"->localEurocode`valTypeAag,
"dampingRatio$\[Xi]"->shearBuildingGet[ a, shearBuildingDampingRatio ],
"dampingCorrectionFactor$\[Eta]"->localEurocode`valCorrectionFactor\[Eta],

"eurocodeTypeOfElasticResponseSpectra"->localEurocode`spectraType,
"eurocodeGroundType"->localEurocode`groundType,

"lowerLimitPeiodOfConstantAcceleration$TB"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valTB ],
"upperLimitPeiodOfConstantAcceleration$TC"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valTC ],
"valueDefiningBeginningConstantDisplacement$TD"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valTD ],
"soilFactor$S"->If[ localEurocode`spectrumEuroCodeHowToSpecify === "type", Automatic, localEurocode`valS ]
 ];

shearBuildingEarthquakeResultsResponseSpectrumOpenerViewer[ shearBuildingEarthquakeAnalyzeResponseSpectrum[ a, 
shearBuildingCentersOfRotationRules->{_->"centerOfMass"},
shearBuildingDOFOrdering->"building",
shearBuildingEarthquakeMotionDirection->earthquakeDirection,
shearBuildingResponseSpectrumForDisplacementFunction->accelerationSpectrum
] ]
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - response spectrum analysis - ASCE 7*)


internalActionGroupResponseSpectrumAnalysisDataInput[ $actionResponseSpectrumASCE7, a_shearBuilding ] := "NOT YET IMPLEMENTED"


internalActionGroupResponseSpectrumAnalysisExecute[ $actionResponseSpectrumASCE7, a_shearBuilding, earthquakeDirection_ ] := "NOT YET IMPLEMENTED"


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - response spectrum analysis - El Centro*)


localElCentroNF`valScaleFactorForAcceleration = 1;


internalActionGroupResponseSpectrumAnalysisDataInput[ $actionResponseSpectrumElCentro1940NF, a_shearBuilding ] =
Dynamic[ Grid[ {
{"Ground acceleration scaling factor: ", InputField[ Dynamic[localElCentroNF`valScaleFactorForAcceleration ], Number]},
{
Plot[ localElCentroNF`valScaleFactorForAcceleration * responseSpectrumAccelerationElCentro1940[ T, shearBuildingGet[ a, shearBuildingDampingRatio ] ], {T, 0, 4},
ImageSize -> 300,
PlotRange -> {0, All}
  ], SpanFromLeft
}
},
Alignment -> Left,
Spacings -> { Automatic, Automatic},
Dividers -> { {{False}},  { {False}}}
] ];


internalActionGroupResponseSpectrumAnalysisExecute[ $actionResponseSpectrumElCentro1940NF, a_shearBuilding, earthquakeDirection_ ] :=
Module[ {accelerationSpectrum},

accelerationSpectrum[ Tp_ ] := (Tp / (2\[Pi]))^2 * localElCentroNF`valScaleFactorForAcceleration * responseSpectrumAccelerationElCentro1940[ Tp, shearBuildingGet[ a, shearBuildingDampingRatio ] ];

shearBuildingEarthquakeResultsResponseSpectrumOpenerViewer[ shearBuildingEarthquakeAnalyzeResponseSpectrum[ a, 
shearBuildingCentersOfRotationRules->{_->"centerOfMass"},
shearBuildingDOFOrdering->"building",
shearBuildingEarthquakeMotionDirection->earthquakeDirection,
shearBuildingResponseSpectrumForDisplacementFunction->accelerationSpectrum
] ]
]


(* ::Subsubsection::Closed:: *)
(*internalShearBuildingSpecsDataPrepare:   "action" - checking support*)


internalCheckLoadSpec[ loadSpec_ ] := 
Module[ {varUsed},
If[ 
(MatchQ[loadSpec,{ (Verbatim[ Rule ] | Verbatim[ RuleDelayed])[ _, _ ] ...}] && 
(varUsed = Union[ ToLowerCase /@ (Head /@ (First /@ loadSpec)) ];  Length[ Complement[ varUsed, $loadSpecStrings ] ] === 0)) === True,
True,
False
]
]


(* ::Subsection::Closed:: *)
(*shearBuilding:  stick building support*)


makeStickViewApp[ eigVec_, periodsList_, heightList_ ] := 
Manipulate[
dofs = eigVec[[whichMode]];
showStickBuilding[ Sin[\[Alpha] // N]  If[ Head[ dofs ] === Rule, dofs // First, dofs ], heightList, amp {1, 1}, 0.5 ,
Directive[ Thickness[0.006] ],
Directive[ Thickness[0.004] ], 
Directive[ PointSize[0.04] ],
Directive[ PointSize[0.02], Blue ],
{1, 0}, "floor",
"track", trackNum, Opacity[0.2]
 ]// Graphics3D[ #, Boxed -> False, ViewVertical -> {0, 0, 1},
PlotRange -> {{-4, 4}, {-4, 4}, {-0.1,Total[ heightList ] + 0.1}}, 
PlotLabel -> Grid[ {{Row[ {"Mode = ", whichMode}]}, {Row[ {"Period = ", NumberForm[periodsList[[ whichMode ]],3] , " seconds"}]}} ], ImageSize -> imSize ]&,
{dofs, ControlType -> None},
{{\[Alpha], \[Pi]/2., "\[Alpha]"}, 0, 2.\[Pi], 2.\[Pi] / 500., ControlType -> Manipulator, Appearance->"Open",AnimationRate-> 2.5 },
{{ whichMode, 1, "Mode"}, Table[ i, {i, 1, Length[ eigVec ]}],  Appearance -> If[ Length[ eigVec ] <= 3 * 15, "Vertical", Automatic ], ControlType -> If[ Length[ eigVec ] <= 3 * 15, SetterBar, PopupMenu ], ControlPlacement -> If[ Length[ eigVec ] <= 3 * 15, Right, Left ]},
Delimiter,
{{trackNum, 0, Dynamic[ Row[ {"track # = ", trackNum}]]}, {0, 1, 2, 3, 5, 10, 20}, ControlType -> SetterBar },
{{amp, 5, Dynamic[ Row[ {"amp = ", amp//N}]]}, 1, 10, 1/4},
Delimiter,
{{imSize, 300, "Image size:"}, {50, 100, 150, 200, 300, 400}, ControlType -> SetterBar},
Initialization -> (showStickBuilding[ "initial" ];),
ControlPlacement -> Left  ]


(* ::Section::Closed:: *)
(*Earthquake data*)


(* ::Subsection::Closed:: *)
(*Available records*)


shearWallsEarthquakeRecords[  ] = {"El Centro 1940"};


(* ::Subsection::Closed:: *)
(*El-centro 1940 earthquake (acceleration data)*)


(* ::Text:: *)
(*El Centro earthquake,  May 18, 1940,  North-South Component;  time vs acceleration*)
(*Ref: http://www.vibrationdata.com/elcentro.htm*)


shearWallsEarthquakeRecords[ "El Centro 1940" ] =(({1, 9.80665 } * #)&) /@ {{ 0.000000 ,  0.006300 }, {0.020000 ,  0.003640 }, {0.040000 ,  0.000990 }, {0.060000 ,  0.004280 }, {0.080000 ,  0.007580 }, {0.100000 ,  0.010870 }, {0.120000 ,  0.006820 }, {0.140000 ,  0.002770 }, {0.160000 ,  -0.001280 }, {0.180000 ,  0.003680 }, {0.200000 ,  0.008640 }, {0.220000 ,  0.013600 }, {0.240000 ,  0.007270 }, {0.260000 ,  0.000940 }, {0.280000 ,  0.004200 }, {0.300000 ,  0.002210 }, {0.320000 ,  0.000210 }, {0.340000 ,  0.004440 }, {0.360000 ,  0.008670 }, {0.380000 ,  0.012900 }, {0.400000 ,  0.017130 }, {0.420000 ,  -0.003430 }, {0.440000 ,  -0.024000 }, {0.460000 ,  -0.009920 }, {0.480000 ,  0.004160 }, {0.500000 ,  0.005280 }, {0.520000 ,  0.016530 }, {0.540000 ,  0.027790 }, {0.560000 ,  0.039040 }, {0.580000 ,  0.024490 }, {0.600000 ,  0.009950 }, {0.620000 ,  0.009610 }, {0.640000 ,  0.009260 }, {0.660000 ,  0.008920 }, {0.680000 ,  -0.004860 }, {0.700000 ,  -0.018640 }, {0.720000 ,  -0.032420 }, {0.740000 ,  -0.033650 }, {0.760000 ,  -0.057230 }, {0.780000 ,  -0.045340 }, {0.800000 ,  -0.033460 }, {0.820000 ,  -0.032010 }, {0.840000 ,  -0.030560 }, {0.860000 ,  -0.029110 }, {0.880000 ,  -0.027660 }, {0.900000 ,  -0.041160 }, {0.920000 ,  -0.054660 }, {0.940000 ,  -0.068160 }, {0.960000 ,  -0.081660 }, {0.980000 ,  -0.068460 }, {1.000000 ,  -0.055270 }, {1.020000 ,  -0.042080 }, {1.040000 ,  -0.042590 }, {1.060000 ,  -0.043110 }, {1.080000 ,  -0.024280 }, {1.100000 ,  -0.005450 }, {1.120000 ,  0.013380 }, {1.140000 ,  0.032210 }, {1.160000 ,  0.051040 }, {1.180000 ,  0.069870 }, {1.200000 ,  0.088700 }, {1.220000 ,  0.045240 }, {1.240000 ,  0.001790 }, {1.260000 ,  -0.041670 }, {1.280000 ,  -0.085130 }, {1.300000 ,  -0.128580 }, {1.320000 ,  -0.172040 }, {1.340000 ,  -0.129080 }, {1.360000 ,  -0.086130 }, {1.380000 ,  -0.089020 }, {1.400000 ,  -0.091920 }, {1.420000 ,  -0.094820 }, {1.440000 ,  -0.093240 }, {1.460000 ,  -0.091660 }, {1.480000 ,  -0.094780 }, {1.500000 ,  -0.097890 }, {1.520000 ,  -0.129020 }, {1.540000 ,  -0.076520 }, {1.560000 ,  -0.024010 }, {1.580000 ,  0.028490 }, {1.600000 ,  0.080990 }, {1.620000 ,  0.133500 }, {1.640000 ,  0.186000 }, {1.660000 ,  0.238500 }, {1.680000 ,  0.219930 }, {1.700000 ,  0.201350 }, {1.720000 ,  0.182770 }, {1.740000 ,  0.164200 }, {1.760000 ,  0.145620 }, {1.780000 ,  0.161430 }, {1.800000 ,  0.177250 }, {1.820000 ,  0.132150 }, {1.840000 ,  0.087050 }, {1.860000 ,  0.041960 }, {1.880000 ,  -0.003140 }, {1.900000 ,  -0.048240 }, {1.920000 ,  -0.093340 }, {1.940000 ,  -0.138430 }, {1.960000 ,  -0.183530 }, {1.980000 ,  -0.228630 }, {2.000000 ,  -0.273720 }, {2.020000 ,  -0.318820 }, {2.040000 ,  -0.250240 }, {2.060000 ,  -0.181660 }, {2.080000 ,  -0.113090 }, {2.100000 ,  -0.044510 }, {2.120000 ,  0.024070 }, {2.140000 ,  0.092650 }, {2.160000 ,  0.161230 }, {2.180000 ,  0.229810 }, {2.200000 ,  0.298390 }, {2.220000 ,  0.231970 }, {2.240000 ,  0.165540 }, {2.260000 ,  0.099120 }, {2.280000 ,  0.032700 }, {2.300000 ,  -0.033720 }, {2.320000 ,  -0.100140 }, {2.340000 ,  -0.166560 }, {2.360000 ,  -0.232990 }, {2.380000 ,  -0.299410 }, {2.400000 ,  -0.004210 }, {2.420000 ,  0.290990 }, {2.440000 ,  0.223800 }, {2.460000 ,  0.156620 }, {2.480000 ,  0.089430 }, {2.500000 ,  0.022240 }, {2.520000 ,  -0.044950 }, {2.540000 ,  0.018340 }, {2.560000 ,  0.081630 }, {2.580000 ,  0.144910 }, {2.600000 ,  0.208200 }, {2.620000 ,  0.189730 }, {2.640000 ,  0.171250 }, {2.660000 ,  0.137590 }, {2.680000 ,  0.103930 }, {2.700000 ,  0.070270 }, {2.720000 ,  0.036610 }, {2.740000 ,  0.002950 }, {2.760000 ,  -0.030710 }, {2.780000 ,  -0.005610 }, {2.800000 ,  0.019480 }, {2.820000 ,  0.044580 }, {2.840000 ,  0.064680 }, {2.860000 ,  0.084780 }, {2.880000 ,  0.104870 }, {2.900000 ,  0.058950 }, {2.920000 ,  0.013030 }, {2.940000 ,  -0.032890 }, {2.960000 ,  -0.078820 }, {2.980000 ,  -0.035560 }, {3.000000 ,  0.007710 }, {3.020000 ,  0.050970 }, {3.040000 ,  0.010130 }, {3.060000 ,  -0.030710 }, {3.080000 ,  -0.071560 }, {3.100000 ,  -0.112400 }, {3.120000 ,  -0.153240 }, {3.140000 ,  -0.113140 }, {3.160000 ,  -0.073040 }, {3.180000 ,  -0.032940 }, {3.200000 ,  0.007150 }, {3.220000 ,  -0.063500 }, {3.240000 ,  -0.134150 }, {3.260000 ,  -0.204800 }, {3.280000 ,  -0.124820 }, {3.300000 ,  -0.044850 }, {3.320000 ,  0.035130 }, {3.340000 ,  0.115100 }, {3.360000 ,  0.195080 }, {3.380000 ,  0.123010 }, {3.400000 ,  0.050940 }, {3.420000 ,  -0.021130 }, {3.440000 ,  -0.093200 }, {3.460000 ,  -0.026630 }, {3.480000 ,  0.039950 }, {3.500000 ,  0.106530 }, {3.520000 ,  0.173110 }, {3.540000 ,  0.112830 }, {3.560000 ,  0.052550 }, {3.580000 ,  -0.007720 }, {3.600000 ,  0.010640 }, {3.620000 ,  0.029000 }, {3.640000 ,  0.047370 }, {3.660000 ,  0.065730 }, {3.680000 ,  0.020210 }, {3.700000 ,  -0.025300 }, {3.720000 ,  -0.070810 }, {3.740000 ,  -0.041070 }, {3.760000 ,  -0.011330 }, {3.780000 ,  0.002880 }, {3.800000 ,  0.017090 }, {3.820000 ,  0.031310 }, {3.840000 ,  -0.022780 }, {3.860000 ,  -0.076860 }, {3.880000 ,  -0.130950 }, {3.900000 ,  -0.185040 }, {3.920000 ,  -0.143470 }, {3.940000 ,  -0.101900 }, {3.960000 ,  -0.060340 }, {3.980000 ,  -0.018770 }, {4.000000 ,  0.022800 }, {4.020000 ,  -0.009960 }, {4.040000 ,  -0.042720 }, {4.060000 ,  -0.021470 }, {4.080000 ,  -0.000210 }, {4.100000 ,  0.021040 }, {4.120000 ,  -0.014590 }, {4.140000 ,  -0.050220 }, {4.160000 ,  -0.085850 }, {4.180000 ,  -0.121480 }, {4.200000 ,  -0.157110 }, {4.220000 ,  -0.192740 }, {4.240000 ,  -0.228370 }, {4.260000 ,  -0.181450 }, {4.280000 ,  -0.134530 }, {4.300000 ,  -0.087610 }, {4.320000 ,  -0.040690 }, {4.340000 ,  0.006230 }, {4.360000 ,  0.053160 }, {4.380000 ,  0.100080 }, {4.400000 ,  0.147000 }, {4.420000 ,  0.097540 }, {4.440000 ,  0.048080 }, {4.460000 ,  -0.001380 }, {4.480000 ,  0.051410 }, {4.500000 ,  0.104200 }, {4.520000 ,  0.156990 }, {4.540000 ,  0.209790 }, {4.560000 ,  0.262580 }, {4.580000 ,  0.169960 }, {4.600000 ,  0.077340 }, {4.620000 ,  -0.015270 }, {4.640000 ,  -0.107890 }, {4.660000 ,  -0.200510 }, {4.680000 ,  -0.067860 }, {4.700000 ,  0.064790 }, {4.720000 ,  0.016710 }, {4.740000 ,  -0.031370 }, {4.760000 ,  -0.079450 }, {4.780000 ,  -0.127530 }, {4.800000 ,  -0.175610 }, {4.820000 ,  -0.223690 }, {4.840000 ,  -0.271770 }, {4.860000 ,  -0.158510 }, {4.880000 ,  -0.045250 }, {4.900000 ,  0.068020 }, {4.920000 ,  0.181280 }, {4.940000 ,  0.144640 }, {4.960000 ,  0.108000 }, {4.980000 ,  0.071370 }, {5.000000 ,  0.034730 }, {5.020000 ,  0.096660 }, {5.040000 ,  0.158600 }, {5.060000 ,  0.220530 }, {5.080000 ,  0.182960 }, {5.100000 ,  0.145380 }, {5.120000 ,  0.107800 }, {5.140000 ,  0.070230 }, {5.160000 ,  0.032650 }, {5.180000 ,  0.066490 }, {5.200000 ,  0.100330 }, {5.220000 ,  0.134170 }, {5.240000 ,  0.103370 }, {5.260000 ,  0.072570 }, {5.280000 ,  0.041770 }, {5.300000 ,  0.010970 }, {5.320000 ,  -0.019830 }, {5.340000 ,  0.044380 }, {5.360000 ,  0.108600 }, {5.380000 ,  0.172810 }, {5.400000 ,  0.104160 }, {5.420000 ,  0.035510 }, {5.440000 ,  -0.033150 }, {5.460000 ,  -0.101800 }, {5.480000 ,  -0.072620 }, {5.500000 ,  -0.043440 }, {5.520000 ,  -0.014260 }, {5.540000 ,  0.014920 }, {5.560000 ,  -0.020250 }, {5.580000 ,  -0.055430 }, {5.600000 ,  -0.090600 }, {5.620000 ,  -0.125780 }, {5.640000 ,  -0.160950 }, {5.660000 ,  -0.196130 }, {5.680000 ,  -0.147840 }, {5.700000 ,  -0.099550 }, {5.720000 ,  -0.051270 }, {5.740000 ,  -0.002980 }, {5.760000 ,  -0.019520 }, {5.780000 ,  -0.036050 }, {5.800000 ,  -0.052590 }, {5.820000 ,  -0.041820 }, {5.840000 ,  -0.031060 }, {5.860000 ,  -0.029030 }, {5.880000 ,  -0.026990 }, {5.900000 ,  0.025150 }, {5.920000 ,  0.017700 }, {5.940000 ,  0.022130 }, {5.960000 ,  0.026560 }, {5.980000 ,  0.004190 }, {6.000000 ,  -0.018190 }, {6.020000 ,  -0.040570 }, {6.040000 ,  -0.062940 }, {6.060000 ,  -0.024170 }, {6.080000 ,  0.014600 }, {6.100000 ,  0.053370 }, {6.120000 ,  0.024280 }, {6.140000 ,  -0.004800 }, {6.160000 ,  -0.033890 }, {6.180000 ,  -0.005570 }, {6.200000 ,  0.022740 }, {6.220000 ,  0.006790 }, {6.240000 ,  -0.009150 }, {6.260000 ,  -0.025090 }, {6.280000 ,  -0.041030 }, {6.300000 ,  -0.056980 }, {6.320000 ,  -0.018260 }, {6.340000 ,  0.020460 }, {6.360000 ,  0.004540 }, {6.380000 ,  -0.011380 }, {6.400000 ,  -0.002150 }, {6.420000 ,  0.007080 }, {6.440000 ,  0.004960 }, {6.460000 ,  0.002850 }, {6.480000 ,  0.000740 }, {6.500000 ,  -0.005340 }, {6.520000 ,  -0.011410 }, {6.540000 ,  0.003610 }, {6.560000 ,  0.018630 }, {6.580000 ,  0.033650 }, {6.600000 ,  0.048670 }, {6.620000 ,  0.030400 }, {6.640000 ,  0.012130 }, {6.660000 ,  -0.006140 }, {6.680000 ,  -0.024410 }, {6.700000 ,  0.013750 }, {6.720000 ,  0.010990 }, {6.740000 ,  0.008230 }, {6.760000 ,  0.005470 }, {6.780000 ,  0.008120 }, {6.800000 ,  0.010770 }, {6.820000 ,  -0.006920 }, {6.840000 ,  -0.024610 }, {6.860000 ,  -0.042300 }, {6.880000 ,  -0.059990 }, {6.900000 ,  -0.077680 }, {6.920000 ,  -0.095380 }, {6.940000 ,  -0.062090 }, {6.960000 ,  -0.028800 }, {6.980000 ,  0.004480 }, {7.000000 ,  0.037770 }, {7.020000 ,  0.017730 }, {7.040000 ,  -0.002310 }, {7.060000 ,  -0.022350 }, {7.080000 ,  0.017910 }, {7.100000 ,  0.058160 }, {7.120000 ,  0.037380 }, {7.140000 ,  0.016600 }, {7.160000 ,  -0.004180 }, {7.180000 ,  -0.024960 }, {7.200000 ,  -0.045740 }, {7.220000 ,  -0.020710 }, {7.240000 ,  0.004320 }, {7.260000 ,  0.029350 }, {7.280000 ,  0.015260 }, {7.300000 ,  0.018060 }, {7.320000 ,  0.020860 }, {7.340000 ,  0.007930 }, {7.360000 ,  -0.005010 }, {7.380000 ,  -0.017950 }, {7.400000 ,  -0.030890 }, {7.420000 ,  -0.018410 }, {7.440000 ,  -0.005930 }, {7.460000 ,  0.006550 }, {7.480000 ,  -0.025190 }, {7.500000 ,  -0.056930 }, {7.520000 ,  -0.040450 }, {7.540000 ,  -0.023980 }, {7.560000 ,  -0.007500 }, {7.580000 ,  0.008970 }, {7.600000 ,  0.003840 }, {7.620000 ,  -0.001290 }, {7.640000 ,  -0.006420 }, {7.660000 ,  -0.011560 }, {7.680000 ,  -0.026190 }, {7.700000 ,  -0.040820 }, {7.720000 ,  -0.055450 }, {7.740000 ,  -0.043660 }, {7.760000 ,  -0.031880 }, {7.780000 ,  -0.069640 }, {7.800000 ,  -0.056340 }, {7.820000 ,  -0.043030 }, {7.840000 ,  -0.029720 }, {7.860000 ,  -0.016420 }, {7.880000 ,  -0.003110 }, {7.900000 ,  0.010200 }, {7.920000 ,  0.023500 }, {7.940000 ,  0.036810 }, {7.960000 ,  0.050110 }, {7.980000 ,  0.024360 }, {8.000000 ,  -0.001390 }, {8.020000 ,  -0.027140 }, {8.040000 ,  -0.003090 }, {8.060000 ,  0.020960 }, {8.080000 ,  0.045010 }, {8.100000 ,  0.069060 }, {8.120000 ,  0.057730 }, {8.140000 ,  0.046400 }, {8.160000 ,  0.035070 }, {8.180000 ,  0.033570 }, {8.200000 ,  0.032070 }, {8.220000 ,  0.030570 }, {8.240000 ,  0.032500 }, {8.260000 ,  0.034440 }, {8.280000 ,  0.036370 }, {8.300000 ,  0.013480 }, {8.320000 ,  -0.009420 }, {8.340000 ,  -0.032310 }, {8.360000 ,  -0.029970 }, {8.380000 ,  -0.030950 }, {8.400000 ,  -0.031920 }, {8.420000 ,  -0.025880 }, {8.440000 ,  -0.019840 }, {8.460000 ,  -0.013790 }, {8.480000 ,  -0.007750 }, {8.500000 ,  -0.014490 }, {8.520000 ,  -0.021230 }, {8.540000 ,  0.015230 }, {8.560000 ,  0.051700 }, {8.580000 ,  0.088160 }, {8.600000 ,  0.124630 }, {8.620000 ,  0.161090 }, {8.640000 ,  0.129870 }, {8.660000 ,  0.098640 }, {8.680000 ,  0.067410 }, {8.700000 ,  0.036180 }, {8.720000 ,  0.004950 }, {8.740000 ,  0.004200 }, {8.760000 ,  0.003450 }, {8.780000 ,  0.002690 }, {8.800000 ,  -0.059220 }, {8.820000 ,  -0.121120 }, {8.840000 ,  -0.183030 }, {8.860000 ,  -0.120430 }, {8.880000 ,  -0.057820 }, {8.900000 ,  0.004790 }, {8.920000 ,  0.067400 }, {8.940000 ,  0.130010 }, {8.960000 ,  0.083730 }, {8.980000 ,  0.037450 }, {9.000000 ,  0.069790 }, {9.020000 ,  0.102130 }, {9.040000 ,  -0.035170 }, {9.060000 ,  -0.172470 }, {9.080000 ,  -0.137630 }, {9.100000 ,  -0.102780 }, {9.120000 ,  -0.067940 }, {9.140000 ,  -0.033100 }, {9.160000 ,  -0.036470 }, {9.180000 ,  -0.039840 }, {9.200000 ,  -0.005170 }, {9.220000 ,  0.029500 }, {9.240000 ,  0.064170 }, {9.260000 ,  0.098830 }, {9.280000 ,  0.133500 }, {9.300000 ,  0.059240 }, {9.320000 ,  -0.015030 }, {9.340000 ,  -0.089290 }, {9.360000 ,  -0.163550 }, {9.380000 ,  -0.060960 }, {9.400000 ,  0.041640 }, {9.420000 ,  0.015510 }, {9.440000 ,  -0.010610 }, {9.460000 ,  -0.036740 }, {9.480000 ,  -0.062870 }, {9.500000 ,  -0.088990 }, {9.520000 ,  -0.054300 }, {9.540000 ,  -0.019610 }, {9.560000 ,  0.015080 }, {9.580000 ,  0.049770 }, {9.600000 ,  0.084460 }, {9.620000 ,  0.050230 }, {9.640000 ,  0.016000 }, {9.660000 ,  -0.018230 }, {9.680000 ,  -0.052460 }, {9.700000 ,  -0.086690 }, {9.720000 ,  -0.067690 }, {9.740000 ,  -0.048700 }, {9.760000 ,  -0.029700 }, {9.780000 ,  -0.010710 }, {9.800000 ,  0.008290 }, {9.820000 ,  -0.003140 }, {9.840000 ,  0.029660 }, {9.860000 ,  0.062460 }, {9.880000 ,  -0.002340 }, {9.900000 ,  -0.067140 }, {9.920000 ,  -0.040510 }, {9.940000 ,  -0.013880 }, {9.960000 ,  0.012740 }, {9.980000 ,  0.008050 }, {10.000000 ,  0.030240 }, {10.020000 ,  0.052430 }, {10.040000 ,  0.023510 }, {10.060000 ,  -0.005410 }, {10.080000 ,  -0.034320 }, {10.100000 ,  -0.063240 }, {10.120000 ,  -0.092150 }, {10.140000 ,  -0.121070 }, {10.160000 ,  -0.084500 }, {10.180000 ,  -0.047940 }, {10.200000 ,  -0.011370 }, {10.220000 ,  0.025200 }, {10.240000 ,  0.061770 }, {10.260000 ,  0.040280 }, {10.280000 ,  0.018800 }, {10.300000 ,  0.044560 }, {10.320000 ,  0.070320 }, {10.340000 ,  0.096080 }, {10.360000 ,  0.121840 }, {10.380000 ,  0.063500 }, {10.400000 ,  0.005170 }, {10.420000 ,  -0.053170 }, {10.440000 ,  -0.031240 }, {10.460000 ,  -0.009300 }, {10.480000 ,  0.012630 }, {10.500000 ,  0.034570 }, {10.520000 ,  0.032830 }, {10.540000 ,  0.031090 }, {10.560000 ,  0.029350 }, {10.580000 ,  0.045110 }, {10.600000 ,  0.060870 }, {10.620000 ,  0.076630 }, {10.640000 ,  0.092390 }, {10.660000 ,  0.057420 }, {10.680000 ,  0.022450 }, {10.700000 ,  -0.012520 }, {10.720000 ,  0.006800 }, {10.740000 ,  0.026110 }, {10.760000 ,  0.045430 }, {10.780000 ,  0.015710 }, {10.800000 ,  -0.014020 }, {10.820000 ,  -0.043740 }, {10.840000 ,  -0.073470 }, {10.860000 ,  -0.039900 }, {10.880000 ,  -0.006330 }, {10.900000 ,  0.027240 }, {10.920000 ,  0.060800 }, {10.940000 ,  0.036690 }, {10.960000 ,  0.012580 }, {10.980000 ,  -0.011530 }, {11.000000 ,  -0.035640 }, {11.020000 ,  -0.006770 }, {11.040000 ,  0.022100 }, {11.060000 ,  0.050980 }, {11.080000 ,  0.079850 }, {11.100000 ,  0.069150 }, {11.120000 ,  0.058450 }, {11.140000 ,  0.047750 }, {11.160000 ,  0.037060 }, {11.180000 ,  0.026360 }, {11.200000 ,  0.058220 }, {11.220000 ,  0.090090 }, {11.240000 ,  0.121960 }, {11.260000 ,  0.100690 }, {11.280000 ,  0.079430 }, {11.300000 ,  0.058160 }, {11.320000 ,  0.036890 }, {11.340000 ,  0.015630 }, {11.360000 ,  -0.005640 }, {11.380000 ,  -0.026900 }, {11.400000 ,  -0.048170 }, {11.420000 ,  -0.069440 }, {11.440000 ,  -0.090700 }, {11.460000 ,  -0.111970 }, {11.480000 ,  -0.115210 }, {11.500000 ,  -0.118460 }, {11.520000 ,  -0.121700 }, {11.540000 ,  -0.124940 }, {11.560000 ,  -0.165000 }, {11.580000 ,  -0.205050 }, {11.600000 ,  -0.157130 }, {11.620000 ,  -0.109210 }, {11.640000 ,  -0.061290 }, {11.660000 ,  -0.013370 }, {11.680000 ,  0.034550 }, {11.700000 ,  0.082470 }, {11.720000 ,  0.075760 }, {11.740000 ,  0.069060 }, {11.760000 ,  0.062360 }, {11.780000 ,  0.087350 }, {11.800000 ,  0.112350 }, {11.820000 ,  0.137340 }, {11.840000 ,  0.121750 }, {11.860000 ,  0.106160 }, {11.880000 ,  0.090570 }, {11.900000 ,  0.074980 }, {11.920000 ,  0.080110 }, {11.940000 ,  0.085240 }, {11.960000 ,  0.090370 }, {11.980000 ,  0.062080 }, {12.000000 ,  0.033780 }, {12.020000 ,  0.005490 }, {12.040000 ,  -0.022810 }, {12.060000 ,  -0.054440 }, {12.080000 ,  -0.040300 }, {12.100000 ,  -0.026150 }, {12.120000 ,  -0.012010 }, {12.140000 ,  -0.020280 }, {12.160000 ,  -0.028550 }, {12.180000 ,  -0.062430 }, {12.200000 ,  -0.035240 }, {12.220000 ,  -0.008050 }, {12.240000 ,  -0.049480 }, {12.260000 ,  -0.036430 }, {12.280000 ,  -0.023370 }, {12.300000 ,  -0.033680 }, {12.320000 ,  -0.018790 }, {12.340000 ,  -0.003890 }, {12.360000 ,  0.011000 }, {12.380000 ,  0.025890 }, {12.400000 ,  0.014460 }, {12.420000 ,  0.003030 }, {12.440000 ,  -0.008400 }, {12.460000 ,  0.004630 }, {12.480000 ,  0.017660 }, {12.500000 ,  0.030690 }, {12.520000 ,  0.043720 }, {12.540000 ,  0.021650 }, {12.560000 ,  -0.000420 }, {12.580000 ,  -0.022490 }, {12.600000 ,  -0.044560 }, {12.620000 ,  -0.036380 }, {12.640000 ,  -0.028190 }, {12.660000 ,  -0.020010 }, {12.680000 ,  -0.011820 }, {12.700000 ,  -0.024450 }, {12.720000 ,  -0.037070 }, {12.740000 ,  -0.049690 }, {12.760000 ,  -0.058820 }, {12.780000 ,  -0.067950 }, {12.800000 ,  -0.077070 }, {12.820000 ,  -0.086200 }, {12.840000 ,  -0.095330 }, {12.860000 ,  -0.062760 }, {12.880000 ,  -0.030180 }, {12.900000 ,  0.002390 }, {12.920000 ,  0.034960 }, {12.940000 ,  0.043990 }, {12.960000 ,  0.053010 }, {12.980000 ,  0.031760 }, {13.000000 ,  0.010510 }, {13.020000 ,  -0.010730 }, {13.040000 ,  -0.031980 }, {13.060000 ,  -0.053230 }, {13.080000 ,  0.001860 }, {13.100000 ,  0.056960 }, {13.120000 ,  0.019850 }, {13.140000 ,  -0.017260 }, {13.160000 ,  -0.054380 }, {13.180000 ,  -0.012040 }, {13.200000 ,  0.030310 }, {13.220000 ,  0.072650 }, {13.240000 ,  0.114990 }, {13.260000 ,  0.072370 }, {13.280000 ,  0.029750 }, {13.300000 ,  -0.012880 }, {13.320000 ,  0.012120 }, {13.340000 ,  0.037110 }, {13.360000 ,  0.035170 }, {13.380000 ,  0.033230 }, {13.400000 ,  0.018530 }, {13.420000 ,  0.003830 }, {13.440000 ,  0.003420 }, {13.460000 ,  -0.021810 }, {13.480000 ,  -0.047040 }, {13.500000 ,  -0.072270 }, {13.520000 ,  -0.097500 }, {13.540000 ,  -0.122730 }, {13.560000 ,  -0.083170 }, {13.580000 ,  -0.043620 }, {13.600000 ,  -0.004070 }, {13.620000 ,  0.035490 }, {13.640000 ,  0.075040 }, {13.660000 ,  0.114600 }, {13.680000 ,  0.077690 }, {13.700000 ,  0.040780 }, {13.720000 ,  0.003870 }, {13.740000 ,  0.002840 }, {13.760000 ,  0.001820 }, {13.780000 ,  -0.055130 }, {13.800000 ,  0.047320 }, {13.820000 ,  0.052230 }, {13.840000 ,  0.057150 }, {13.860000 ,  0.062060 }, {13.880000 ,  0.066980 }, {13.900000 ,  0.071890 }, {13.920000 ,  0.027050 }, {13.940000 ,  -0.017790 }, {13.960000 ,  -0.062630 }, {13.980000 ,  -0.107470 }, {14.000000 ,  -0.152320 }, {14.020000 ,  -0.125910 }, {14.040000 ,  -0.099500 }, {14.060000 ,  -0.073090 }, {14.080000 ,  -0.046680 }, {14.100000 ,  -0.020270 }, {14.120000 ,  0.006140 }, {14.140000 ,  0.032550 }, {14.160000 ,  0.008590 }, {14.180000 ,  -0.015370 }, {14.200000 ,  -0.039320 }, {14.220000 ,  -0.063280 }, {14.240000 ,  -0.033220 }, {14.260000 ,  -0.003150 }, {14.280000 ,  0.026910 }, {14.300000 ,  0.011960 }, {14.320000 ,  -0.003000 }, {14.340000 ,  0.003350 }, {14.360000 ,  0.009700 }, {14.380000 ,  0.016050 }, {14.400000 ,  0.022390 }, {14.420000 ,  0.042150 }, {14.440000 ,  0.061910 }, {14.460000 ,  0.081670 }, {14.480000 ,  0.034770 }, {14.500000 ,  -0.012120 }, {14.520000 ,  -0.013090 }, {14.540000 ,  -0.014070 }, {14.560000 ,  -0.052740 }, {14.580000 ,  -0.025440 }, {14.600000 ,  0.001860 }, {14.620000 ,  0.029160 }, {14.640000 ,  0.056460 }, {14.660000 ,  0.083760 }, {14.680000 ,  0.017540 }, {14.700000 ,  -0.048690 }, {14.720000 ,  -0.020740 }, {14.740000 ,  0.007220 }, {14.760000 ,  0.035170 }, {14.780000 ,  -0.005280 }, {14.800000 ,  -0.045720 }, {14.820000 ,  -0.086170 }, {14.840000 ,  -0.069600 }, {14.860000 ,  -0.053030 }, {14.880000 ,  -0.036460 }, {14.900000 ,  -0.019890 }, {14.920000 ,  -0.003320 }, {14.940000 ,  0.013250 }, {14.960000 ,  0.029820 }, {14.980000 ,  0.011010 }, {15.000000 ,  -0.007810 }, {15.020000 ,  -0.026620 }, {15.040000 ,  -0.005630 }, {15.060000 ,  0.015360 }, {15.080000 ,  0.036350 }, {15.100000 ,  0.057340 }, {15.120000 ,  0.031590 }, {15.140000 ,  0.005840 }, {15.160000 ,  -0.019920 }, {15.180000 ,  -0.002010 }, {15.200000 ,  0.015890 }, {15.220000 ,  -0.010240 }, {15.240000 ,  -0.036360 }, {15.260000 ,  -0.062490 }, {15.280000 ,  -0.047800 }, {15.300000 ,  -0.033110 }, {15.320000 ,  -0.049410 }, {15.340000 ,  -0.065700 }, {15.360000 ,  -0.082000 }, {15.380000 ,  -0.049800 }, {15.400000 ,  -0.017600 }, {15.420000 ,  0.014600 }, {15.440000 ,  0.046800 }, {15.460000 ,  0.079000 }, {15.480000 ,  0.047500 }, {15.500000 ,  0.016000 }, {15.520000 ,  -0.015500 }, {15.540000 ,  -0.001020 }, {15.560000 ,  0.013470 }, {15.580000 ,  0.027950 }, {15.600000 ,  0.042440 }, {15.620000 ,  0.056920 }, {15.640000 ,  0.037810 }, {15.660000 ,  0.018700 }, {15.680000 ,  -0.000410 }, {15.700000 ,  -0.019520 }, {15.720000 ,  -0.004270 }, {15.740000 ,  0.010980 }, {15.760000 ,  0.026230 }, {15.780000 ,  0.041480 }, {15.800000 ,  0.018210 }, {15.820000 ,  -0.005060 }, {15.840000 ,  -0.008740 }, {15.860000 ,  -0.037260 }, {15.880000 ,  -0.065790 }, {15.900000 ,  -0.026000 }, {15.920000 ,  0.013800 }, {15.940000 ,  0.053590 }, {15.960000 ,  0.093380 }, {15.980000 ,  0.058830 }, {16.000000 ,  0.024290 }, {16.020000 ,  -0.010260 }, {16.040000 ,  -0.044800 }, {16.060000 ,  -0.010830 }, {16.080000 ,  -0.018690 }, {16.100000 ,  -0.026550 }, {16.120000 ,  -0.034410 }, {16.140000 ,  -0.025030 }, {16.160000 ,  -0.015640 }, {16.180000 ,  -0.006260 }, {16.200000 ,  -0.010090 }, {16.220000 ,  -0.013920 }, {16.240000 ,  0.014900 }, {16.260000 ,  0.043720 }, {16.280000 ,  0.034630 }, {16.300000 ,  0.020980 }, {16.320000 ,  0.007330 }, {16.340000 ,  -0.006320 }, {16.360000 ,  -0.019970 }, {16.380000 ,  0.007670 }, {16.400000 ,  0.035320 }, {16.420000 ,  0.034090 }, {16.440000 ,  0.032870 }, {16.460000 ,  0.031640 }, {16.480000 ,  0.024030 }, {16.500000 ,  0.016420 }, {16.520000 ,  0.009820 }, {16.540000 ,  0.003220 }, {16.560000 ,  -0.003390 }, {16.580000 ,  0.022020 }, {16.600000 ,  -0.019410 }, {16.620000 ,  -0.060850 }, {16.640000 ,  -0.102280 }, {16.660000 ,  -0.078470 }, {16.680000 ,  -0.054660 }, {16.700000 ,  -0.030840 }, {16.720000 ,  -0.007030 }, {16.740000 ,  0.016780 }, {16.760000 ,  0.019460 }, {16.780000 ,  0.022140 }, {16.800000 ,  0.024830 }, {16.820000 ,  0.018090 }, {16.840000 ,  -0.002020 }, {16.860000 ,  -0.022130 }, {16.880000 ,  -0.002780 }, {16.900000 ,  0.016560 }, {16.920000 ,  0.035900 }, {16.940000 ,  0.055250 }, {16.960000 ,  0.074590 }, {16.980000 ,  0.062030 }, {17.000000 ,  0.049480 }, {17.020000 ,  0.036920 }, {17.040000 ,  -0.001450 }, {17.060000 ,  0.045990 }, {17.080000 ,  0.040790 }, {17.100000 ,  0.035580 }, {17.120000 ,  0.030370 }, {17.140000 ,  0.036260 }, {17.160000 ,  0.042150 }, {17.180000 ,  0.048030 }, {17.200000 ,  0.053920 }, {17.220000 ,  0.049470 }, {17.240000 ,  0.045020 }, {17.260000 ,  0.040560 }, {17.280000 ,  0.036110 }, {17.300000 ,  0.031660 }, {17.320000 ,  0.006140 }, {17.340000 ,  -0.019370 }, {17.360000 ,  -0.044890 }, {17.380000 ,  -0.070400 }, {17.400000 ,  -0.095920 }, {17.420000 ,  -0.077450 }, {17.440000 ,  -0.058990 }, {17.460000 ,  -0.040520 }, {17.480000 ,  -0.022060 }, {17.500000 ,  -0.003590 }, {17.520000 ,  0.014870 }, {17.540000 ,  0.010050 }, {17.560000 ,  0.005230 }, {17.580000 ,  0.000410 }, {17.600000 ,  -0.004410 }, {17.620000 ,  -0.009230 }, {17.640000 ,  -0.011890 }, {17.660000 ,  -0.015230 }, {17.680000 ,  -0.018560 }, {17.700000 ,  -0.021900 }, {17.720000 ,  -0.009830 }, {17.740000 ,  0.002240 }, {17.760000 ,  0.014310 }, {17.780000 ,  0.003350 }, {17.800000 ,  -0.007600 }, {17.820000 ,  -0.018560 }, {17.840000 ,  -0.007370 }, {17.860000 ,  0.003830 }, {17.880000 ,  0.015020 }, {17.900000 ,  0.026220 }, {17.920000 ,  0.010160 }, {17.940000 ,  -0.005900 }, {17.960000 ,  -0.021960 }, {17.980000 ,  -0.001210 }, {18.000000 ,  0.019530 }, {18.020000 ,  0.040270 }, {18.040000 ,  0.028260 }, {18.060000 ,  0.016250 }, {18.080000 ,  0.004240 }, {18.100000 ,  0.001960 }, {18.120000 ,  -0.000310 }, {18.140000 ,  -0.002580 }, {18.160000 ,  -0.004860 }, {18.180000 ,  -0.007130 }, {18.200000 ,  -0.009410 }, {18.220000 ,  -0.011680 }, {18.240000 ,  -0.013960 }, {18.260000 ,  -0.017500 }, {18.280000 ,  -0.021040 }, {18.300000 ,  -0.024580 }, {18.320000 ,  -0.028130 }, {18.340000 ,  -0.031670 }, {18.360000 ,  -0.035210 }, {18.380000 ,  -0.042050 }, {18.400000 ,  -0.048890 }, {18.420000 ,  -0.035590 }, {18.440000 ,  -0.022290 }, {18.460000 ,  -0.008990 }, {18.480000 ,  0.004310 }, {18.500000 ,  0.017620 }, {18.520000 ,  0.007140 }, {18.540000 ,  -0.003340 }, {18.560000 ,  -0.013830 }, {18.580000 ,  0.013140 }, {18.600000 ,  0.040110 }, {18.620000 ,  0.067080 }, {18.640000 ,  0.048200 }, {18.660000 ,  0.029320 }, {18.680000 ,  0.010430 }, {18.700000 ,  -0.008450 }, {18.720000 ,  -0.027330 }, {18.740000 ,  -0.046210 }, {18.760000 ,  -0.031550 }, {18.780000 ,  -0.016880 }, {18.800000 ,  -0.002220 }, {18.820000 ,  0.012440 }, {18.840000 ,  0.026830 }, {18.860000 ,  0.041210 }, {18.880000 ,  0.055590 }, {18.900000 ,  0.032530 }, {18.920000 ,  0.009460 }, {18.940000 ,  -0.013600 }, {18.960000 ,  -0.014320 }, {18.980000 ,  -0.015040 }, {19.000000 ,  -0.015760 }, {19.020000 ,  -0.042090 }, {19.040000 ,  -0.026850 }, {19.060000 ,  -0.011610 }, {19.080000 ,  0.003630 }, {19.100000 ,  0.018870 }, {19.120000 ,  0.034110 }, {19.140000 ,  0.031150 }, {19.160000 ,  0.028190 }, {19.180000 ,  0.029170 }, {19.200000 ,  0.030150 }, {19.220000 ,  0.031130 }, {19.240000 ,  0.003880 }, {19.260000 ,  -0.023370 }, {19.280000 ,  -0.050620 }, {19.300000 ,  -0.038200 }, {19.320000 ,  -0.025790 }, {19.340000 ,  -0.013370 }, {19.360000 ,  -0.000950 }, {19.380000 ,  0.011460 }, {19.400000 ,  0.023880 }, {19.420000 ,  0.036290 }, {19.440000 ,  0.010470 }, {19.460000 ,  -0.015350 }, {19.480000 ,  -0.041170 }, {19.500000 ,  -0.066990 }, {19.520000 ,  -0.052070 }, {19.540000 ,  -0.037150 }, {19.560000 ,  -0.022220 }, {19.580000 ,  -0.007300 }, {19.600000 ,  0.007620 }, {19.620000 ,  0.022540 }, {19.640000 ,  0.037470 }, {19.660000 ,  0.040010 }, {19.680000 ,  0.042560 }, {19.700000 ,  0.045070 }, {19.720000 ,  0.047590 }, {19.740000 ,  0.050100 }, {19.760000 ,  0.045450 }, {19.780000 ,  0.040800 }, {19.800000 ,  0.028760 }, {19.820000 ,  0.016710 }, {19.840000 ,  0.004670 }, {19.860000 ,  -0.007380 }, {19.880000 ,  -0.001160 }, {19.900000 ,  0.005060 }, {19.920000 ,  0.011280 }, {19.940000 ,  0.017500 }, {19.960000 ,  -0.002110 }, {19.980000 ,  -0.021730 }, {20.000000 ,  -0.041350 }, {20.020000 ,  -0.060960 }, {20.040000 ,  -0.080580 }, {20.060000 ,  -0.069950 }, {20.080000 ,  -0.059310 }, {20.100000 ,  -0.048680 }, {20.120000 ,  -0.038050 }, {20.140000 ,  -0.025570 }, {20.160000 ,  -0.013100 }, {20.180000 ,  -0.000630 }, {20.200000 ,  0.011850 }, {20.220000 ,  0.024320 }, {20.240000 ,  0.036800 }, {20.260000 ,  0.049270 }, {20.280000 ,  0.029740 }, {20.300000 ,  0.010210 }, {20.320000 ,  -0.009320 }, {20.340000 ,  -0.028840 }, {20.360000 ,  -0.048370 }, {20.380000 ,  -0.067900 }, {20.400000 ,  -0.048620 }, {20.420000 ,  -0.029340 }, {20.440000 ,  -0.010060 }, {20.460000 ,  0.009220 }, {20.480000 ,  0.028510 }, {20.500000 ,  0.047790 }, {20.520000 ,  0.024560 }, {20.540000 ,  0.001330 }, {20.560000 ,  -0.021900 }, {20.580000 ,  -0.045130 }, {20.600000 ,  -0.068360 }, {20.620000 ,  -0.049780 }, {20.640000 ,  -0.031200 }, {20.660000 ,  -0.012620 }, {20.680000 ,  0.005960 }, {20.700000 ,  0.024530 }, {20.720000 ,  0.043110 }, {20.740000 ,  0.061690 }, {20.760000 ,  0.080270 }, {20.780000 ,  0.098850 }, {20.800000 ,  0.064520 }, {20.820000 ,  0.030190 }, {20.840000 ,  -0.004140 }, {20.860000 ,  -0.038480 }, {20.880000 ,  -0.072810 }, {20.900000 ,  -0.059990 }, {20.920000 ,  -0.047170 }, {20.940000 ,  -0.034350 }, {20.960000 ,  -0.032310 }, {20.980000 ,  -0.030280 }, {21.000000 ,  -0.028240 }, {21.020000 ,  -0.003960 }, {21.040000 ,  0.020320 }, {21.060000 ,  0.003130 }, {21.080000 ,  -0.014060 }, {21.100000 ,  -0.031240 }, {21.120000 ,  -0.048430 }, {21.140000 ,  -0.065620 }, {21.160000 ,  -0.051320 }, {21.180000 ,  -0.037020 }, {21.200000 ,  -0.022720 }, {21.220000 ,  -0.008430 }, {21.240000 ,  0.005870 }, {21.260000 ,  0.020170 }, {21.280000 ,  0.026980 }, {21.300000 ,  0.033790 }, {21.320000 ,  0.040610 }, {21.340000 ,  0.047420 }, {21.360000 ,  0.054230 }, {21.380000 ,  0.035350 }, {21.400000 ,  0.016470 }, {21.420000 ,  0.016220 }, {21.440000 ,  0.015980 }, {21.460000 ,  0.015740 }, {21.480000 ,  0.007470 }, {21.500000 ,  -0.000800 }, {21.520000 ,  -0.009070 }, {21.540000 ,  0.000720 }, {21.560000 ,  0.010510 }, {21.580000 ,  0.020300 }, {21.600000 ,  0.030090 }, {21.620000 ,  0.039890 }, {21.640000 ,  0.034780 }, {21.660000 ,  0.029670 }, {21.680000 ,  0.024570 }, {21.700000 ,  0.030750 }, {21.720000 ,  0.036940 }, {21.740000 ,  0.043130 }, {21.760000 ,  0.049310 }, {21.780000 ,  0.055500 }, {21.800000 ,  0.061680 }, {21.820000 ,  -0.005260 }, {21.840000 ,  -0.072200 }, {21.860000 ,  -0.063360 }, {21.880000 ,  -0.054510 }, {21.900000 ,  -0.045660 }, {21.920000 ,  -0.036810 }, {21.940000 ,  -0.036780 }, {21.960000 ,  -0.036750 }, {21.980000 ,  -0.036720 }, {22.000000 ,  -0.017650 }, {22.020000 ,  0.001430 }, {22.040000 ,  0.020510 }, {22.060000 ,  0.039580 }, {22.080000 ,  0.058660 }, {22.100000 ,  0.035560 }, {22.120000 ,  0.012450 }, {22.140000 ,  -0.010660 }, {22.160000 ,  -0.033760 }, {22.180000 ,  -0.056870 }, {22.200000 ,  -0.045020 }, {22.220000 ,  -0.033170 }, {22.240000 ,  -0.021310 }, {22.260000 ,  -0.009460 }, {22.280000 ,  0.002390 }, {22.300000 ,  -0.002080 }, {22.320000 ,  -0.006540 }, {22.340000 ,  -0.011010 }, {22.360000 ,  -0.015480 }, {22.380000 ,  -0.012000 }, {22.400000 ,  -0.008510 }, {22.420000 ,  -0.005030 }, {22.440000 ,  -0.001540 }, {22.460000 ,  0.001950 }, {22.480000 ,  0.000510 }, {22.500000 ,  -0.000920 }, {22.520000 ,  0.011350 }, {22.540000 ,  0.023630 }, {22.560000 ,  0.035900 }, {22.580000 ,  0.048180 }, {22.600000 ,  0.060450 }, {22.620000 ,  0.072730 }, {22.640000 ,  0.028470 }, {22.660000 ,  -0.015790 }, {22.680000 ,  -0.060040 }, {22.700000 ,  -0.050690 }, {22.720000 ,  -0.041340 }, {22.740000 ,  -0.031990 }, {22.760000 ,  -0.031350 }, {22.780000 ,  -0.030710 }, {22.800000 ,  -0.030070 }, {22.820000 ,  -0.018630 }, {22.840000 ,  -0.007190 }, {22.860000 ,  0.004250 }, {22.880000 ,  0.015700 }, {22.900000 ,  0.027140 }, {22.920000 ,  0.038580 }, {22.940000 ,  0.029750 }, {22.960000 ,  0.020920 }, {22.980000 ,  0.023340 }, {23.000000 ,  0.025760 }, {23.020000 ,  0.028190 }, {23.040000 ,  0.030610 }, {23.060000 ,  0.033040 }, {23.080000 ,  0.013710 }, {23.100000 ,  -0.005610 }, {23.120000 ,  -0.024940 }, {23.140000 ,  -0.022080 }, {23.160000 ,  -0.019230 }, {23.180000 ,  -0.016380 }, {23.200000 ,  -0.013530 }, {23.220000 ,  -0.012610 }, {23.240000 ,  -0.011700 }, {23.260000 ,  -0.001690 }, {23.280000 ,  0.008330 }, {23.300000 ,  0.018340 }, {23.320000 ,  0.028350 }, {23.340000 ,  0.038360 }, {23.360000 ,  0.048380 }, {23.380000 ,  0.037490 }, {23.400000 ,  0.026600 }, {23.420000 ,  0.015710 }, {23.440000 ,  0.004820 }, {23.460000 ,  -0.006070 }, {23.480000 ,  -0.016960 }, {23.500000 ,  -0.007800 }, {23.520000 ,  0.001360 }, {23.540000 ,  0.010520 }, {23.560000 ,  0.019680 }, {23.580000 ,  0.028840 }, {23.600000 ,  -0.005040 }, {23.620000 ,  -0.038930 }, {23.640000 ,  -0.023420 }, {23.660000 ,  -0.007910 }, {23.680000 ,  0.007590 }, {23.700000 ,  0.023100 }, {23.720000 ,  0.007070 }, {23.740000 ,  -0.008950 }, {23.760000 ,  -0.024980 }, {23.780000 ,  -0.041000 }, {23.800000 ,  -0.057030 }, {23.820000 ,  -0.029200 }, {23.840000 ,  -0.001370 }, {23.860000 ,  0.026450 }, {23.880000 ,  0.054280 }, {23.900000 ,  0.035870 }, {23.920000 ,  0.017460 }, {23.940000 ,  -0.000960 }, {23.960000 ,  -0.019370 }, {23.980000 ,  -0.037780 }, {24.000000 ,  -0.022810 }, {24.020000 ,  -0.007840 }, {24.040000 ,  0.007130 }, {24.060000 ,  0.022100 }, {24.080000 ,  0.037070 }, {24.100000 ,  0.052040 }, {24.120000 ,  0.067010 }, {24.140000 ,  0.081980 }, {24.160000 ,  0.030850 }, {24.180000 ,  -0.020270 }, {24.200000 ,  -0.071400 }, {24.220000 ,  -0.122530 }, {24.240000 ,  -0.086440 }, {24.260000 ,  -0.050350 }, {24.280000 ,  -0.014260 }, {24.300000 ,  0.021830 }, {24.320000 ,  0.057920 }, {24.340000 ,  0.094000 }, {24.360000 ,  0.130090 }, {24.380000 ,  0.036110 }, {24.400000 ,  -0.057870 }, {24.420000 ,  -0.048020 }, {24.440000 ,  -0.038170 }, {24.460000 ,  -0.028320 }, {24.480000 ,  -0.018460 }, {24.500000 ,  -0.008610 }, {24.520000 ,  -0.036520 }, {24.540000 ,  -0.064440 }, {24.560000 ,  -0.061690 }, {24.580000 ,  -0.058940 }, {24.600000 ,  -0.056180 }, {24.620000 ,  -0.060730 }, {24.640000 ,  -0.065280 }, {24.660000 ,  -0.046280 }, {24.680000 ,  -0.027280 }, {24.700000 ,  -0.008290 }, {24.720000 ,  0.010710 }, {24.740000 ,  0.029700 }, {24.760000 ,  0.031380 }, {24.780000 ,  0.033060 }, {24.800000 ,  0.034740 }, {24.820000 ,  0.036420 }, {24.840000 ,  0.045740 }, {24.860000 ,  0.055060 }, {24.880000 ,  0.064390 }, {24.900000 ,  0.073710 }, {24.920000 ,  0.083030 }, {24.940000 ,  0.036050 }, {24.960000 ,  -0.010920 }, {24.980000 ,  -0.057900 }, {25.000000 ,  -0.046960 }, {25.020000 ,  -0.036020 }, {25.040000 ,  -0.025080 }, {25.060000 ,  -0.014140 }, {25.080000 ,  -0.035610 }, {25.100000 ,  -0.057080 }, {25.120000 ,  -0.078550 }, {25.140000 ,  -0.063040 }, {25.160000 ,  -0.047530 }, {25.180000 ,  -0.032030 }, {25.200000 ,  -0.016520 }, {25.220000 ,  -0.001020 }, {25.240000 ,  0.009220 }, {25.260000 ,  0.019460 }, {25.280000 ,  0.029700 }, {25.300000 ,  0.039930 }, {25.320000 ,  0.050170 }, {25.340000 ,  0.060410 }, {25.360000 ,  0.070650 }, {25.380000 ,  0.080890 }, {25.400000 ,  -0.001920 }, {25.420000 ,  -0.084730 }, {25.440000 ,  -0.070320 }, {25.460000 ,  -0.055900 }, {25.480000 ,  -0.041480 }, {25.500000 ,  -0.052960 }, {25.520000 ,  -0.064430 }, {25.540000 ,  -0.075900 }, {25.560000 ,  -0.087380 }, {25.580000 ,  -0.098850 }, {25.600000 ,  -0.067980 }, {25.620000 ,  -0.037100 }, {25.640000 ,  -0.006230 }, {25.660000 ,  0.024650 }, {25.680000 ,  0.055530 }, {25.700000 ,  0.086400 }, {25.720000 ,  0.117280 }, {25.740000 ,  0.148150 }, {25.760000 ,  0.087150 }, {25.780000 ,  0.026150 }, {25.800000 ,  -0.034850 }, {25.820000 ,  -0.095840 }, {25.840000 ,  -0.071000 }, {25.860000 ,  -0.046160 }, {25.880000 ,  -0.021320 }, {25.900000 ,  0.003530 }, {25.920000 ,  0.028370 }, {25.940000 ,  0.053210 }, {25.960000 ,  -0.004690 }, {25.980000 ,  -0.062580 }, {26.000000 ,  -0.120480 }, {26.020000 ,  -0.099600 }, {26.040000 ,  -0.078720 }, {26.060000 ,  -0.057840 }, {26.080000 ,  -0.036960 }, {26.100000 ,  -0.016080 }, {26.120000 ,  0.004800 }, {26.140000 ,  0.025680 }, {26.160000 ,  0.046560 }, {26.180000 ,  0.067440 }, {26.200000 ,  0.088320 }, {26.220000 ,  0.109200 }, {26.240000 ,  0.130080 }, {26.260000 ,  0.109950 }, {26.280000 ,  0.089820 }, {26.300000 ,  0.069690 }, {26.320000 ,  0.049550 }, {26.340000 ,  0.040060 }, {26.360000 ,  0.030560 }, {26.380000 ,  0.021070 }, {26.400000 ,  0.011580 }, {26.420000 ,  0.007800 }, {26.440000 ,  0.004020 }, {26.460000 ,  0.000240 }, {26.480000 ,  -0.003540 }, {26.500000 ,  -0.007320 }, {26.520000 ,  -0.011100 }, {26.540000 ,  -0.007800 }, {26.560000 ,  -0.004500 }, {26.580000 ,  -0.001200 }, {26.600000 ,  0.002100 }, {26.620000 ,  0.005400 }, {26.640000 ,  -0.008310 }, {26.660000 ,  -0.022030 }, {26.680000 ,  -0.035750 }, {26.700000 ,  -0.049470 }, {26.720000 ,  -0.063190 }, {26.740000 ,  -0.050460 }, {26.760000 ,  -0.037730 }, {26.780000 ,  -0.025000 }, {26.800000 ,  -0.012270 }, {26.820000 ,  0.000460 }, {26.840000 ,  0.004820 }, {26.860000 ,  0.009190 }, {26.880000 ,  0.013550 }, {26.900000 ,  0.017910 }, {26.920000 ,  0.022280 }, {26.940000 ,  0.008830 }, {26.960000 ,  -0.004620 }, {26.980000 ,  -0.018070 }, {27.000000 ,  -0.031520 }, {27.020000 ,  -0.022760 }, {27.040000 ,  -0.014010 }, {27.060000 ,  -0.005260 }, {27.080000 ,  0.003500 }, {27.100000 ,  0.012250 }, {27.120000 ,  0.021010 }, {27.140000 ,  0.014370 }, {27.160000 ,  0.007730 }, {27.180000 ,  0.001100 }, {27.200000 ,  0.008230 }, {27.220000 ,  0.015370 }, {27.240000 ,  0.022510 }, {27.260000 ,  0.017130 }, {27.280000 ,  0.011750 }, {27.300000 ,  0.006370 }, {27.320000 ,  0.013760 }, {27.340000 ,  0.021140 }, {27.360000 ,  0.028520 }, {27.380000 ,  0.035910 }, {27.400000 ,  0.043290 }, {27.420000 ,  0.034580 }, {27.440000 ,  0.025870 }, {27.460000 ,  0.017150 }, {27.480000 ,  0.008440 }, {27.500000 ,  -0.000270 }, {27.520000 ,  -0.008980 }, {27.540000 ,  -0.001260 }, {27.560000 ,  0.006450 }, {27.580000 ,  0.014170 }, {27.600000 ,  0.020390 }, {27.620000 ,  0.026610 }, {27.640000 ,  0.032830 }, {27.660000 ,  0.039050 }, {27.680000 ,  0.045270 }, {27.700000 ,  0.036390 }, {27.720000 ,  0.027500 }, {27.740000 ,  0.018620 }, {27.760000 ,  0.009740 }, {27.780000 ,  0.000860 }, {27.800000 ,  -0.013330 }, {27.820000 ,  -0.027520 }, {27.840000 ,  -0.041710 }, {27.860000 ,  -0.028120 }, {27.880000 ,  -0.014530 }, {27.900000 ,  -0.000940 }, {27.920000 ,  0.012640 }, {27.940000 ,  0.026230 }, {27.960000 ,  0.016900 }, {27.980000 ,  0.007560 }, {28.000000 ,  -0.001770 }, {28.020000 ,  -0.011110 }, {28.040000 ,  -0.020440 }, {28.060000 ,  -0.029770 }, {28.080000 ,  -0.039110 }, {28.100000 ,  -0.024420 }, {28.120000 ,  -0.009730 }, {28.140000 ,  0.004960 }, {28.160000 ,  0.019650 }, {28.180000 ,  0.034340 }, {28.200000 ,  0.020540 }, {28.220000 ,  0.006740 }, {28.240000 ,  -0.007060 }, {28.260000 ,  -0.020860 }, {28.280000 ,  -0.034660 }, {28.300000 ,  -0.026630 }, {28.320000 ,  -0.018600 }, {28.340000 ,  -0.010570 }, {28.360000 ,  -0.002540 }, {28.380000 ,  -0.000630 }, {28.400000 ,  0.001280 }, {28.420000 ,  0.003190 }, {28.440000 ,  0.005100 }, {28.460000 ,  0.009990 }, {28.480000 ,  0.014880 }, {28.500000 ,  0.007910 }, {28.520000 ,  0.000930 }, {28.540000 ,  -0.006050 }, {28.560000 ,  0.003420 }, {28.580000 ,  0.012880 }, {28.600000 ,  0.022350 }, {28.620000 ,  0.031810 }, {28.640000 ,  0.041280 }, {28.660000 ,  0.027070 }, {28.680000 ,  0.012870 }, {28.700000 ,  -0.001340 }, {28.720000 ,  -0.015540 }, {28.740000 ,  -0.029750 }, {28.760000 ,  -0.043950 }, {28.780000 ,  -0.036120 }, {28.800000 ,  -0.028280 }, {28.820000 ,  -0.020440 }, {28.840000 ,  -0.012600 }, {28.860000 ,  -0.004760 }, {28.880000 ,  0.003070 }, {28.900000 ,  0.010910 }, {28.920000 ,  0.009840 }, {28.940000 ,  0.008760 }, {28.960000 ,  0.007680 }, {28.980000 ,  0.006610 }, {29.000000 ,  0.012340 }, {29.020000 ,  0.018070 }, {29.040000 ,  0.023800 }, {29.060000 ,  0.029530 }, {29.080000 ,  0.035260 }, {29.100000 ,  0.027840 }, {29.120000 ,  0.020420 }, {29.140000 ,  0.013000 }, {29.160000 ,  -0.034150 }, {29.180000 ,  -0.006280 }, {29.200000 ,  -0.006210 }, {29.220000 ,  -0.006150 }, {29.240000 ,  -0.006090 }, {29.260000 ,  -0.006020 }, {29.280000 ,  -0.005960 }, {29.300000 ,  -0.005900 }, {29.320000 ,  -0.005830 }, {29.340000 ,  -0.005770 }, {29.360000 ,  -0.005710 }, {29.380000 ,  -0.005640 }, {29.400000 ,  -0.005580 }, {29.420000 ,  -0.005520 }, {29.440000 ,  -0.005450 }, {29.460000 ,  -0.005390 }, {29.480000 ,  -0.005320 }, {29.500000 ,  -0.005260 }, {29.520000 ,  -0.005200 }, {29.540000 ,  -0.005130 }, {29.560000 ,  -0.005070 }, {29.580000 ,  -0.005010 }, {29.600000 ,  -0.004940 }, {29.620000 ,  -0.004880 }, {29.640000 ,  -0.004820 }, {29.660000 ,  -0.004750 }, {29.680000 ,  -0.004690 }, {29.700000 ,  -0.004630 }, {29.720000 ,  -0.004560 }, {29.740000 ,  -0.004500 }, {29.760000 ,  -0.004440 }, {29.780000 ,  -0.004370 }, {29.800000 ,  -0.004310 }, {29.820000 ,  -0.004250 }, {29.840000 ,  -0.004180 }, {29.860000 ,  -0.004120 }, {29.880000 ,  -0.004060 }, {29.900000 ,  -0.003990 }, {29.920000 ,  -0.003930 }, {29.940000 ,  -0.003870 }, {29.960000 ,  -0.003800 }, {29.980000 ,  -0.003740 }, {30.000000 ,  -0.003680 }, {30.020000 ,  -0.003610 }, {30.040000 ,  -0.003550 }, {30.060000 ,  -0.003490 }, {30.080000 ,  -0.003420 }, {30.100000 ,  -0.003360 }, {30.120000 ,  -0.003300 }, {30.140000 ,  -0.003230 }, {30.160000 ,  -0.003170 }, {30.180000 ,  -0.003110 }, {30.200000 ,  -0.003040 }, {30.220000 ,  -0.002980 }, {30.240000 ,  -0.002920 }, {30.260000 ,  -0.002850 }, {30.280000 ,  -0.002790 }, {30.300000 ,  -0.002730 }, {30.320000 ,  -0.002660 }, {30.340000 ,  -0.002600 }, {30.360000 ,  -0.002540 }, {30.380000 ,  -0.002470 }, {30.400000 ,  -0.002410 }, {30.420000 ,  -0.002350 }, {30.440000 ,  -0.002280 }, {30.460000 ,  -0.002220 }, {30.480000 ,  -0.002160 }, {30.500000 ,  -0.002090 }, {30.520000 ,  -0.002030 }, {30.540000 ,  -0.001970 }, {30.560000 ,  -0.001900 }, {30.580000 ,  -0.001840 }, {30.600000 ,  -0.001780 }, {30.620000 ,  -0.001710 }, {30.640000 ,  -0.001650 }, {30.660000 ,  -0.001580 }, {30.680000 ,  -0.001520 }, {30.700000 ,  -0.001460 }, {30.720000 ,  -0.001390 }, {30.740000 ,  -0.001330 }, {30.760000 ,  -0.001270 }, {30.780000 ,  -0.001200 }, {30.800000 ,  -0.001140 }, {30.820000 ,  -0.001080 }, {30.840000 ,  -0.001010 }, {30.860000 ,  -0.000950 }, {30.880000 ,  -0.000890 }, {30.900000 ,  -0.000820 }, {30.920000 ,  -0.000760 }, {30.940000 ,  -0.000700 }, {30.960000 ,  -0.000630 }, {30.980000 ,  -0.000570 }, {31.000000 ,  -0.000510 }, {31.020000 ,  -0.000440 }, {31.040000 ,  -0.000380 }, {31.060000 ,  -0.000320 }, {31.080000 ,  -0.000250 }, {31.100000 ,  -0.000190 }, {31.120000 ,  -0.000130 }, {31.140000 ,  -0.000060 }, {31.160000 ,  0.000000 }, {31.180000 ,  0.000000} };


(* ::Section::Closed:: *)
(*Epilogue*)


(* ::Subsubsection::Closed:: *)
(*End the private context*)


End[];


(* ::Subsubsection::Closed:: *)
(*Protect exported symbols - NEEDS TO BE DONE*)


Protect[  shearWalls ];


(* ::Subsubsection::Closed:: *)
(*Re-able annoying spell warnings*)


On[ General::spell1 ];


(* ::Subsubsection::Closed:: *)
(*End the package context*)


EndPackage[];


(* ::Section::Closed:: *)
(*To do*)


(* ::Subsection:: *)
(*Bugs*)


(* ::Subsection:: *)
(*Next stuff - major retooling*)


(* ::Text:: *)
(*Building viewer:*)
(*\[Bullet] Add action to do response spectrum analysis (what editors? how to present results?)*)
(*\[Bullet] Add building floor plan graphics (varies by floor;  provide slider)*)


(* ::Text:: *)
(*Building:*)
(*\[Bullet]  Add value 'shearBuildingAdditionalDeadMassAtCenterOfMassRules' and 'shearBuildingAdditionalDeadMassPolarMomentOfInertiaAtCenterOfMassRules'*)


(* ::Text:: *)
(*Testing:*)
(*\[Bullet]  Redo testing suite after the major retooling (BIG job)*)


(* ::Subsection::Closed:: *)
(*Old Next stuff*)


(* ::Text:: *)
(*Object support:*)


(* ::Text:: *)
(*Wall level:*)
(*\[Bullet]  Allow wall stiffness in 2 directions  (shearWallIncludeStiffnessPerpendicular  ->  allow putting and getting)*)
(*\[Bullet]  Allow inclusion of wall mass (1/2 to nearest floor)   (shearWallSpecificGravity  ->  allow putting and getting)*)
(*\[Bullet]  Allow calculation of mass and mass polar moment of inertia (shearWallMassWallOnly, shearWallMassPolarMomentOfInertiaRelativeToSpecifiedCenter)*)
(*\[Bullet]  Add viewing specs for: shearWallIncludeStiffnessPerpendicular, shearWallIncludeSelfMass, shearWallSpecificGravity, shearWallMassWallOnly*)


(* ::Text:: *)
(*(* new variables *)      {shearWallIncludeStiffnessPerpendicular, shearWallSpecificGravity}; *)
(*(*  new procedures *)  {shearWallCentroid, shearWallMass, shearWallMassPolarMomentOfInertiaRelativeToSpecifiedCenter}  *)


(* ::Text:: *)
(*Floor level:*)
(*\[Bullet] Allow floor to put values of  'shearFloorWallIncludeStiffnessPerpendicular' and 'shearFloorWallSpecificGravity' for all walls in floor*)


(* ::Text:: *)
(*(* new things that can be put but not got *)    {shearFloorIncludeWallStiffnessPerpendicular, shearFloorWallSpecificGravity};*)


(* ::Text:: *)
(*Building level:*)
(*\[Bullet] Allow building to put values of  'shearBuildingIncludeWallStiffnessPerpendicular' and 'shearBuildingWallSpecificGravity' for all floors in building*)
(*\[Bullet] Allow getting:  'shearBuildingCenterOfMassWithoutWallsAtFloor', 'shearBuildingCenterOfMassWithWallsAtFloor', 'shearBuildingSlabMassOnlyAtFloor', 'shearBuildingSlabAndWallMassAtFloor', 'shearBuildingSlabMassPolarMomentOfInertiaRelativeToSpecifiedCenter' and 'shearBuildingSlabAndWallMassPolarMomentOfInertiaRelativeToSpecifiedCenter'*)
(**)
(*\[Bullet] Modify calculation of mass matrix for building to include mass and moment of inertia of walls*)
(**)
(*\[Bullet] Allow viewing: 'shearBuildingCenterOfMassWithoutWallsAtFloor', 'shearBuildingCenterOfMassWithWallsAtFloor', 'shearBuildingSlabMassOnlyAtFloor', 'shearBuildingSlabAndWallMassAtFloor', 'shearBuildingMassPolarMomentOfInertiaRelativeToSpecifiedCenter'*)


(* ::Text:: *)
(*(* new variable *)      {shearBuildingIncludeWallMass}; *)
(*(* new things that can be put but not got *)  {shearBuildingIncludeWallStiffnessPerpendicular, shearBuildingWallSpecificGravity}*)
(*(*  new procedures *)   {*)
(*  shearBuildingCenterOfMass, shearBuildingMassPolarMomentOfInertiaRelativeToSpecifiedCenter,*)
(*  shearBuildingCenterOfMassWithoutWallsAtFloor, shearBuildingCenterOfMassWithWallsAtFloor, shearBuildingSlabMassOnlyAtFloor, shearBuildingSlabAndWallMassAtFloor, shearBuildingSlabMassPolarMomentOfInertiaRelativeToSpecifiedCenter, shearBuildingSlabAndWallMassPolarMomentOfInertiaRelativeToSpecifiedCenter};*)
(*(*  procedure that needs to be modified to account for wall mass *) {shearBuildingMassMatrix, shearBuildingEarthquakeLoadMassVector}*)
(**)
(*(* procedures that need to be renamed *)  {shearBuildingFloorCentroids, shearBuildingFloorAreas, shearBuildingFloorPolarMomentOfInertiaRelativeToCentroids}  "to" {shearBuildingSlabCentroids, shearBuildingSlabAreas, shearBuildingSlabPolarMomentOfInertiaRelativeToCentroids}*)
(**)
(*(* keywords that need to be changed *)  "centroid" "to" "centerOfMass"*)
(*(* calculations that need to be changed *)  "anywhere 'shearBuildingFloorCentroids' is used must be replaced by 'shearBuildingFloorCenterOfMass'"*)
(**)


(* ::Text:: *)
(*Editing:*)
(*\[Bullet] Editors for walls, slabs, floors and buildings*)


(* ::Text:: *)
(*Applet:*)
(*\[Bullet]  Identify outline of kind of applet to build (most of stuff so far is like API)*)
(*\[Bullet]  Create an applet that:*)
(*	i) views and edits a building, *)
(*	ii) selects parameters for analysis.*)
(*	iii) does analysis and views results in detail and in summary.*)
(*	Note:  viewing analysis includes viewing deformed shape and shears forces, bending moments and drifts on every wall with graphical aids*)


(* ::Text:: *)
(*Viewing:*)
(*\[Bullet]  Create an internal method to form crosses depicting movement of floors for modal viewing.  Use this method for both 'internalShowStickBuilding' and 2-D method described next*)
(*\[Bullet]  Add a method to show static view of modes as 2-D cross-shaped floors moving with centerOfMass shown as crosshairs and x-y axis shown;  whole thing to be shown as an array or as a column*)


(* ::Subsection::Closed:: *)
(*Perhaps stuff*)


(* ::Text:: *)
(*\[Bullet]  Consider adding stiffness in transverse direction (not important, especially when bending is included so that transverse stiffness becomes negligible);  only advantage is that a single wall will not give zero eigenvalues.*)


(* ::Text:: *)
(*Separate object to be considered later*)


(* ::Text:: *)
(*\[Bullet]  Add a message to building to do modal analysis:  Gets frequencies and eigenvectors - *)
(*	Consider creating a separate object (eg. shearModalAnalyzer) to store, work with and view eigen results in various ways*)
(*\[Bullet]  Add a message to building to do time integration analysis:  Gets stiffness, damping and mass matrices - *)
(*	Consider creating a separate object (eg. shearDEAnalyzer) to store, work with and view time integration results*)
(**)
(*Note:  Advantages of separate object results:*)
(*	- Isn't affected by changes to original building*)
(*	- Stores time-consuming calculations to avoid recalculations*)
(*	- Reduces complexity of shearBuilding object*)
(*	-> Consider having a message to shearBuilding to animate results from either modal or DE results*)


(* ::Subsection:: *)
(*Notes on app*)

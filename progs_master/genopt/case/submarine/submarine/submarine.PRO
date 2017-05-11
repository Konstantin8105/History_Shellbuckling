 
   5.0 
       This application of GENOPT/BIGBOSOR4 is for an
       externally pressurized tank which has a spherical
       dome connected to a cylindrical shell. The material is
       elastic. The tank is subjected to uniform external
       pressure. Design constraints include stress and buckling.
       Symmetry conditions are applied at the midlength of the
       cylindrical shell. The objective is minimum weight.
       The main aim of the optimization is to determine the
       best distribution of the material in the neighborhood
       of the junction between the spherical dome and the
       cylindrical shell. Hence the position of the reference
       surface and the wall thickness vary in the neighborhood
       of the junction between the spherical dome and the
       cylindrical shell. In the BIGBOSOR4 model the tank
       consists of two shell segments. Segment 1 is the
       spherical dome, and Segment 2 is the cylindrical
       shell. Nodal points are concentrated in the region near
       the junction between dome and cylinder. The INDIC=1
       branch of BIGBOSOR4 is used for the buckling analysis,
       and the INDIC = 0 branch of BIGBOSOR4 is used for the
       stress analysis.
 
  10.1 radius of the tank: RADIUS
  10.2 
       The radius is measured to the reference surface.
 
  15.1 total length of the cylinder: LENGTH
  15.2 
       This is twice the length used in the analysis.
       It is the length of cylindrical shell between the two
       end domes. In the BIGBOSOR4 model half this length is
       included, with symmetry conditions imposed at the end
       of the cylindrical shell which is at the symmetry plane
       of the tank.
 
  20.1 elastic modulus of the shell wall: EMOD
  25.1 Poisson ratio of the shell wall: NU
  30.1 weight density of the shell wall: DENSTY
  30.2 
       For example, aluminum has a weight density of 0.1 lb/in^3.
 
 
  35.0 
       Next, you will be asked to provide the number of
       nodal points to be used in the dome and the number of
       nodal points to be used in the cylinder. Choose odd
       integers between 51 and 91 . You might optimize first
       with the use of 51 nodal points in each shell segment
       (51 nodal points in the spherical dome and 51 nodal
       points in the cylindrical shell), then check your optimum
       design with the use of 91 nodal points in each shell
       segment.
 
  40.1 number of nodal points in the dome: NODSPH
  45.1 number of nodal points in the cylinder: NODCYL
 
  50.0 
       You will next be asked to provide the number of callout
       stations in the dome and the locations of those
       stations in the dome, followed by the number of callout
       stations in the cylinder, followed by the axial locations
       of those stations in the cylinder at which two quantities
       are specified:
       1. the distance from the leftmost surface of the shell
       wall to the reference surface ("leftmost" means the
       left-hand surface of the shell wall as you face in
       the direction of increasing arc length).
       2. the thickness of the shell wall.
       The locations of the reference surface and the wall thicknesses
       are to be decision variables in the optimization problem.
 
  55.1 number of axial callouts in the dome: NPTSPH
  55.2 
       Use a number between 5 and 10, probably 5 at first.
 
  60.1 Number IZSPH   of rows in the array  ZSPH: IZSPH  
  65.1 axial location of callout in the dome: ZSPH
  65.2 
       The axial callout is the axial distance from the apex
       of the dome (where the dome meets the axis of revolution
       of the tank) to the callout point. NOTE: The first callout
       point must be ZSPH(1) = 0.0 (the location of the apex), and
       the last callout point must be the equator of the dome
       (ZSPH(NPTSPH) = RADIUS). You will want the thickness of the
       dome to be constant for most of the arc length of the dome,
       that is, from the dome apex to ZSPH = RADIUS/2, for
       example. ZSPH = RADIUS/2 corresponds to an angle of 60
       degrees from the apex to the second axial callout point.
       Then you provide axial locations of additional callout
       points located on the dome reference surface between
       that second callout point at ZSPH(2) = RADIUS/2 to the
       NPTSPHth callout point, which must correspond to the
       equator of the dome, that is, ZSPH(NPTSPH) = RADIUS.
 
  70.1 Number of axial callouts in the cylinder: NPTCYL
  70.2 
       Use an integer between 5 and 10; probably 5 is best to
       start with. Then you can use more in a re-optimization
       if you wish.
 
  75.1 Number IZCYL   of rows in the array  ZCYL: IZCYL  
  80.1 axial location of callout in the cylinder: ZCYL
  80.2 
       The axial location is measured from the apex of the dome
       to the callout point. As callout points in the cylindrical
       shell you must include the first point in the cylindrical
       shell, that is, ZCYL(1) = RADIUS, and the last point in the
       cylindrical shell, that is, ZCYL(NPTCYL) = RADIUS + LENGTH/2.
       You want most of the length of the cylindrical shell to
       have a constant thickness. Therefore, the second-to-last
       callout point should probably be located at something like
       ZCYL(NPTCYL-1) = RADIUS + LENGTH/2 - LENGTH/4.
 
 
  85.0 
       Next, you will be asked to provide the following decision
       variables:
       ZREFSP = distance from the leftmost shell wall surface to
       the reference surface in the spherical shell.
       THKSPH = thickness of the shell wall at the callout points
       in the spherical shell
       ZREFCY = distance from the leftmost shell wall surface to
       the reference surface in the cylindrical shell
       THKCYL = thickness of the shell wall at the callout points
       in the cylindrical shell.
 
  90.1 Number IZREFSP of rows in the array  ZREFSP: IZREFSP
  95.1 location of ref. surf. in the dome: ZREFSP
  95.2 
       This is the distance from the shell wall leftmost surface to
       the reference surface as you face in the direction of
       increasing arc length in the spherical dome.
 
 100.1 wall thickness in the dome: THKSPH
 105.1 Number IZREFCY of rows in the array  ZREFCY: IZREFCY
 110.1 location of the ref. surf. in the cylinder: ZREFCY
 110.2 
       This is the distance from the leftmost shell wall surface
       to the reference surface. "Leftmost" means the shell wall]
       surface on the left-hand side as you face in the direction
       of increasing arc length along the shell segment.
 
 115.1 thickness of the cylindrical shell: THKCYL
 
 120.0 
       Next you will be asked to provide the range of
       circumferential wave numbers to be used during
       the buckling analysis. You will be asked to provide
       NBUKLO and NBUKHI, where NBUKLO is the low end of the
       range of circumferential wave numbers and NBUKHI is the
       high end of the range of circumferential wave numbers.
       It is best to use NBUKL0 = 0 and NBUKHI = something like
       10
 
 125.1 low end of range of buckling circ. waves: NBUKLO
 125.2 
       Usually you will want to set NBUKLO = 0
 
 130.1 high end of range of buckling circ. waves: NBUKHI
 130.2 
       Use an integer less than 20  . NBUKHI = 10 will probably
       suffice.
 
 
 135.0 
       In this formulation the only environmental parameter (load)
       is the external pressure. Use a positive number.
 
 140.1 Number NCASES  of load cases (environments): NCASES 
 145.1 uniform external pressure: PRESS
 145.2 
       For the deepest part of the ocean (35000 feet) the
       pressure is (64 x 35000)/144 psi.
 
 
 150.0 
       In this formulation there are two "behavioral" design
       constraints: 1 = buckling and 2 = stress. The buckling
       variable is called BUCKL and the stress variable is
       called STRESS. By STRESS is meant, in this case that
       involves only isotropic material, "effective stress",
       which is the VonMises effective stress:
       STRESS = SQRT(sig1^2 +sig2^2 -sig1sig2 +3*sig12^2)
 
 155.0 tank buckling eigenvalue: BUCKL
 160.1 allowable buckling load (Use 1.0): BUCKLA
 160.2 
       The buckling eigenvalue is a buckling load factor. The
       load applied to the shell is PRESS, the external pressure.
       BUCKL is the factor by which PRESS should be multiplied
       in order to get the buckling pressure. For buckling, the
       allowable, BUCKLA, should ordinarily be set to unity,
       because you will be asked to provide a factor of safety
       next. It is the factor of safety that compensates for
       initial imperfections, not the allowable.
 
 165.1 factor of safety for buckling: BUCKLF
 165.2 
       In order to compensate for initial imperfections,
       use a factor of safety for buckling of between 1.4 and 3.0.
       If buckling occurs in the spherical dome, then a factor of
       safety of 3.0 is appropriate. If buckling occurs in the
       cylindrical shell, then a factor of safety of 1.4 or
       something like that is appropriate. Unfortunately, in
       this case the factor of safety depends on which part of
       the tank buckles. For this submarine, which is to operate
       at extreme depths, buckling may well not be critical. It
       may well be that the stress constraint becomes active
       whereas the buckling constraint remains inactive. You
       may have to optimize with one factor of safety, see where
       the optimized tank buckles, then re-optimize using a
       different factor of safety.
 
 170.1 Number JSTRESS of columns in the array, STRESS: JSTRESS
 175.0 effective stress in shell segment: STRESS
 175.2 
       STRESS(ILOADX,ISEG)=SQRT(sig1^2 +sig2^2 -sig1sig2 +3sig12^2)
       in which ILOADX=load set no. & ISEG=shell segment no.
 
 180.1 maximum allowable effective stress: STRESSA
 180.2 
       It is safest to use the proportional limit of the
       material as the allowable. For example, with titanium the
       elastic limit is about 120000 psi.
 
 185.1 factor of safety for stress: STRESSF
 185.2 
       Note that in this formulation the only bending stresses
       are located in the neighborhood of the junction between
       the spherical dome and the cylindrical shell. There are
       no bending stresses due to imperfections. Therefore, it
       might be a good idea to set the factor of safety for
       the effective stress, STRESS, to some value greater than
       unity, such as 1.1 to 1.3.
 
 
 190.0 
       Next, establish the objective. In this case the objective
       is the weight of the part of the tank that is included
       in the BIGBOSOR4 model, that is, the weight of half of
       the tank. The objective is to be called WEIGHT
 
 195.0 weight of the BIGBOSOR4 model: WEIGHT
 195.2 
       In the BIGBOSOR4 model half of the tank is to be included
       Therefore, WEIGHT is the weight of half of the tank. Since
       we are using weight density rather than mass density, the
       objective is in lb at the surface of the earth.
 
 999.0 DUMMY ENTRY TO MARK END OF FILE

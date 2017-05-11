 
   5.0 
       We want to determine the minimum amount of material
       required to span a distance of WIDTH for an axially
       compressed structure (a wall or panel) with a "corrugated"
       cross section. The entire width of the "corrugated" panel is
       composed of a number, 2 x NSEG, of so-called "major" segments,
       each of which may be divided into a number, NSUBSEG, of
       sub-segments. Each segment and each sub-segment is a sector
       of a little cylindrical shell the generators of which run
       in the axial (z) direction. The axial length of the
       corrugated panel is LENGTH. Half of the width, WIDTH, of
       the corrugated panel is included in the model, with symmetry
       conditions applied at x = WIDTH/2 in the prebuckling phase
       of the problem and both symmetry and anti-symmetry conditions
       applied in the bifurcation buckling phase of the problem.
        
       The material is isotropic. There is only one layer.
       The thickness is constant within each major segment of
       the "corrugated" panel. The corrugated panel exists in an
       x,y,z coordinate system in which:
       x = the width-wise coordinate (in the WIDTH direction)
       y = the vertical coordinate (normal to the x,z plane)
       z = the length-wise coordinate (in the LENGTH direction).
       The uniform axial compression is applied in the z-direction.
        
       The corrugated panel is optimized subject to the following
       "behavioral" constraints:
        
       1. local buckling which is symmetric about the symmetry
       plane at x = WIDTH/2. Local buckling is computed in
       SUBROUTINE BEHX1. (See the file, behavior.span9.)
        
       2. general buckling which is symmetric about the symmetry
       plane at x = WIDTH/2. General "symmetric" buckling is
       computed in SUBROUTINE BEHX2. (See behavior.span9.)
        
       3. general buckling which is anti-symmetric about the
       symmetry plane at x = WIDTH/2. General "anti-symmetric"
       buckling is computed in SUBROUTINE BEHX3 in behavior.span9.
        
       4. "classical" buckling of each segment of the corrugated
       panel. "Classical" buckling is computed in SUBROUTINE BEHX4.
       The "Classical" buckling formula includes a suitable
       knockdown factor computed from a table of values that
       depend on the radius/thickness of each cylindrical segment
       as given in the 1975 McGraw-Hill book by Brush and Almroth.
        
       5. maximum allowable stress. The stress is that for the
       corrugated panel in a membrane prebuckled state, that is,
       uniform axial compression (uniform end shortening) in the z
       coordinate direction. The stress is computed in SUBROUTINE BEHX5.
        
       The decision variable candidates are:
        
       1. The thickness, THICK, assumed to be constant over
       each major segment, but can be different in each major segment.
        
       2. The projected width, SUBWID, of each major segment. This
       is the width of the major panel segment projected onto the
       x,z plane, that is, the "x-width" of the major segment.
        
       3. The half-angles, PHISEG(i), of the major corrugation
       segments. "half-angle" (in degrees) means half the angle
       spanned by a single cylindrical corrugation segment of the
       corrugated panel. The major segments are joined width-wise
       longitudinal edge-to-edge. The edges all around the perimeter
       of the corrugated panel are simply supported. NOTE: The
       left-hand longitudinal edge has the three displacement
       components, USTAR,VSTAR,WSTAR, constrained and the rotation
       about the generator, CHI, free. USTAR, VSTAR, WSTAR are the
       vertical (y-direction), axial (z-direction), and width-wise
       (x-direction) displacement components, respectively.
       The two curved edges at z = 0 and z = LENGTH are simply
       supported in the classical sense, that is, buckling is
       antisymmetric about those two edges. Another way of
       expressing this is to write that buckling nodal lines
       occur along the two edges at z = 0 and z = LENGTH.
        
       4. The half-angles, PHISUB(i) (degrees), of the sub-segments.
       The longitudinal edges of each sub-segment have the same
       y-coordinates of the major segment that would exist if
       there were no sub-segments. PHISUB(i) is half the angle
       spanned by a sub-corrugation in the ith major segment.
       All the sub-corrugations within a given major segment
       have the same value of PHISUB. PHISUB(i) can be different
       in different major segments. The thicknesses of all sub-
       corrugations in a given major segment are the same.
        
       5. The distances, YPLATE, that the junctions of the major
       segments and the two longitudinal edges of the model, the
       leftmost edge at x = 0 and the rightmost edge at x=WIDTH/2,
       are raised above the x,z plane if the overall arching
       angle, PHIBIG (defined next), is zero. If PHIBIG is greater
       than zero YPLATE are the vertical distances above the overall
       arch at the x-locations of the junctions of the major segments
       and at the left-most and right-most edges of the panel.
       YPLATE is a vector with NSEG+1 components, in which NSEG
       is the number of major segments over the width, WIDTH/2.
        
       6. An overall arching half-angle, PHIBIG (degrees), that
       spans the distance, WIDTH/2, of the corrugated panel. The
       top of the arch (or bottom of the "valley") is located at
       x = WIDTH/2.
        
       The entire corrugated panel is raised above the
       x,z plane by a y-distance equal to YPLATE(1). The purpose
       of YPLATE(1) is to avoid zero, near-zero, and negative
       values of the decision variable candidates, YPLATE(2),
       YPLATE(3), ... , YPLATE(NSEG+1). YPLATE(1) should NOT be
       a decision variable.
        
       Typical values of design variables for an optimum design
       of a corrugated panel with 5 major segments over WIDTH/2
       and no subsegments are listed in the following table:
       VALUES OF DESIGN VARIABLES FOR THE BEST FEASIBLE DESIGN
       VAR. CURRENT
       NO.   VALUE            DEFINITION
       1 6.382E-02 wall thickness of the major segment:   THICK(1)
       2 6.382E-02 wall thickness of the major segment:   THICK(2)
       3 6.382E-02 wall thickness of the major segment:   THICK(3)
       4 6.382E-02 wall thickness of the major segment:   THICK(4)
       5 6.382E-02 wall thickness of the major segment:   THICK(5)
       6 4.408E+00 projected width(x-width) of sub-plate:SUBWID(1)
       7 5.648E+00 projected width(x-width) of sub-plate:SUBWID(2)
       8 1.276E+01 projected width(x-width) of sub-plate:SUBWID(3)
       9 1.319E+01 projected width(x-width) of sub-plate:SUBWID(4)
       10 1.354E+01 projected width(x-width) of sub-plate:SUBWID(5)
       11 3.409E+01 half-angle(deg.) of major corrugation:PHISEG(1)
       12 3.511E+01 half-angle(deg.) of major corrugation:PHISEG(2)
       13 7.877E+01 half-angle(deg.) of major corrugation:PHISEG(3)
       14 8.447E+01 half-angle(deg.) of major corrugation:PHISEG(4)
       15 8.397E+01 half-angle(deg.) of major corrugation:PHISEG(5)
       16 7.000E+01 half-angle (deg.) of sub-corrugation: PHISUB(1)
       17 7.000E+01 half-angle (deg.) of sub-corrugation: PHISUB(2)
       18 7.000E+01 half-angle (deg.) of sub-corrugation: PHISUB(3)
       19 7.000E+01 half-angle (deg.) of sub-corrugation: PHISUB(4)
       20 7.000E+01 half-angle (deg.) of sub-corrugation: PHISUB(5)
       21 3.000E+01 vertical y above (x,y,z) origin if PHIBIG=0:YPLATE(1)
       22 2.301E+01 vertical y above (x,y,z) origin if PHIBIG=0:YPLATE(2)
       23 2.096E+01 vertical y above (x,y,z) origin if PHIBIG=0:YPLATE(3)
       24 1.986E+01 vertical y above (x,y,z) origin if PHIBIG=0:YPLATE(4)
       25 2.022E+01 vertical y above (x,y,z) origin if PHIBIG=0:YPLATE(5)
       26 2.056E+01 vertical y above (x,y,z) origin if PHIBIG=0:YPLATE(6)
       27 8.866E+00 half-angle (deg.) of overall arching: PHIBIG
        
       Note that sub-segment half-angles, PHISUB(i), i=1,5, are
       listed above (variable numbers 16-20) even though in this
       particular case there are no sub-segments.
        
       Typical behavioral constraints (from which the behavioral
       margins are computed) for the optimized design just
       listed are as follows:
       ***** RESULTS FOR LOAD SET NO.  1  ******
       PARAMETERS THAT DESCRIBE BEHAVIOR(e.g. stress,buckling load)
       BEH. CURRENT
       NO.  VALUE            DEFINITION
       1  2.011E+00  local buckling load factor: LOCBUK(1)
       2  1.503E+00  symmetric general buckling: BUKSYM(1)
       3  1.512E+00  antisymmetric general buckling: BUKASY(1)
       4  1.009E+00  classical buckling load factor: CYLBUK(1,1 )
       5  1.554E+00  classical buckling load factor: CYLBUK(1,2 )
       6  1.084E+00  classical buckling load factor: CYLBUK(1,3 )
       7  1.054E+00  classical buckling load factor: CYLBUK(1,4 )
       8  1.022E+00  classical buckling load factor: CYLBUK(1,5 )
       9  2.181E+04  maximum effective stress: STRESS(1)
        
       The first array index in the behavioral variables, LOCBUK,
       BUKSYM, BUKASY, CYLBUK and STRESS, is the load case number.
       In this work there exists only a single load case.
       The second array index in the behavioral variable, CYLBUK,
       is the major segment number.
        
       Typical margins for the same optimized design are:
       ***** RESULTS FOR LOAD SET NO.  1  ******
       MARGINS CORRESPONDING TO CURRENT DESIGN (F.S.= FACTOR OF SAFETY)
       MARGIN CURRENT
       NO.    VALUE            DEFINITION
       1 9.540E-02  6.05-0.10*V(6)-0.10*V(7)-0.10*V(8)-0.10*V(9)-0.10*V(10)-1
       2 4.600E-03 -3.95+0.10*V(6)+0.10*V(7)+0.10*V(8)+0.10*V(9)+0.10*V(10)-1
       3 5.380E-03 (LOCBUK(1)/LOCBUKA(1))/LOCBUKF(1)-1;F.S.=2.00
       4 2.171E-03 (BUKSYM(1)/BUKSYMA(1))/BUKSYMF(1)-1;F.S.=1.50
       5 8.285E-03 (BUKASY(1)/BUKASYA(1))/BUKASYF(1)-1;F.S.=1.50
       6 8.958E-03 (CYLBUK(1,1 )/CYLBUKA(1,1))/CYLBUKF(1,1)-1;F.S.=1.0
       7 5.542E-01 (CYLBUK(1,2 )/CYLBUKA(1,2))/CYLBUKF(1,2)-1;F.S.=1.0
       8 8.370E-02 (CYLBUK(1,3 )/CYLBUKA(1,3))/CYLBUKF(1,3)-1;F.S.=1.0
       9 5.350E-02 (CYLBUK(1,4 )/CYLBUKA(1,4))/CYLBUKF(1,4)-1;F.S.=1.0
       10 2.183E-02 (CYLBUK(1,5 )/CYLBUKA(1,5))/CYLBUKF(1,5)-1;F.S.=1.0
       11 2.057E+00 (STRESSA(1)/STRESS(1))/STRESSF(1)-1; F.S.= 1.50
        
       The first two margins listed above:
       1 9.540E-02  6.05-0.10*V(6)-0.10*V(7)-0.10*V(8)-0.10*V(9)-0.10*V(10)-1
       2 4.600E-03 -3.95+0.10*V(6)+0.10*V(7)+0.10*V(8)+0.10*V(9)+0.10*V(10)-1
       require an explanation.
       The variables, V(6), V(7), V(8), V(9), V(10), are the
       projected widths, SUBWID(1), SUBWID(2), SUBWID(3), SUBWID(4)
       and SUBWID(5), of the 5 major segments. These 5 variables
       are decision variables, and the sum of them should always
       be very close to the half-width, WIDTH/2, of the corrugated
       panel. In order to accomplish this, two inequality
       constraints are introduced during execution of the GENOPT
       processor called "DECIDE":
       1. The overall half-width should be less than 50.5 inches.
       2. The overall half-width should be greater than 49.5 inches.
       In other words,
       50.5 > V(6) + V(7) + V(8) + V(9) + V(10)
       and
       49.5 < V(6) + V(7) + V(8) + V(9) + V(10)
        
       During the development of this application it was found
       that the numerical behavior was improved by multiplying
       both sides of the two inequality constraints by 0.1.
       Therefore, the two new (equivalent) inequality constraints
       are:
       5.05 > 0.1*V(6) + 0.1*V(7) + 0.1*V(8) + 0.1*V(9) + 0.1*V(10)
       4.95 < 0.1*V(6) + 0.1*V(7) + 0.1*V(8) + 0.1*V(9) + 0.1*V(10)
        
       Item No. 603 of the file, .../genopt/execute/URPROMPT.DAT
       (a permanent file independent of the generic case that
       contains prompting phrases and "help" paragraphs for the
       End user) includes the following lines:
        
       603.1 Identify the type of inequality expression (1 or 2)
       603.2
       The inequality relations have either of the two forms:
       Type 1 is:     1.0 > f(v1,v2,v3,...)
       Type 2 is:     1.0 < f(v1,v2,v3,...)
       in which the expression f(v1,v2,v3,...) has the form:
       f(v1,v2,v3,...)=C0 +C1*v1**D1 +C2*v2**D2 +C3*v3**D3 +
       +etc (up to max. of 15 terms).
        
       In this application we always use inequality constraints of
       Type 2: 1.0 < f(v1,v2,v3,...). Therefore, we multiply both
       sides of the first inequality constraint by -1.0, obtaining
       -5.05 < -0.1*V(6) -0.1*V(7) -0.1*V(8) -0.1*V(9) -0.1*V(10)
       Adding 5.05 to both sides of this first inequality gives:
       0.0 <  5.05 -0.1*V(6) -0.1*V(7) -0.1*V(8) -0.1*V(9) -0.1*V(10)
       and then adding 1.0 to both sides of this inequality gives:
       1.0 <  6.05 -0.1*V(6) -0.1*V(7) -0.1*V(8) -0.1*V(9) -0.1*V(10)
       which is in the proper Type 2 form: 1.0 < f(v1,v2,v3,...).
        
       Subtracting 4.95 from both sides of the second inequality
       and then adding 1.0 to both sides of the second inequality
       gives:
       1.0 < -3.95 +0.1*V(6) +0.1*V(7) +0.1*V(8) +0.1*V(9) +0.1*V(10)
        
       These two inequalities correspond to the first two margins
       listed above.
        
       This work was begun on July 19, 2009. The author is
       David Bushnell.
        
       In this project BIGBOSOR4 is used as the structural
       analysis tool. The corrugated panel is modeled as a true
       prismatic shell, as described in the following references:
        
       1. David Bushnell and Robert P. Thornburgh,"Use of GENOPT
       and BIGBOSOR4 to optimize weld lands in axially compressed
       stiffened cylindrical shells and evaluation of the
       optimized designs by STAGS, AIAA Paper 2010-2927, 51st
       AIAA Structures Conference, 2010
        
       2. David Bushnell, "Comparison of a "huge torus" model
       with a true prismatic model for: 1. an axially compressed
       simple monocoque cylindrical shell, 2. an axially
       compressed optimized truss-core sandwich cylindrical
       shell, and 3. an axially compressed optimized internally
       ring and stringer stiffened cylindrical shell with a T-
       stiffened weld land", Unpublished report for NASA Langley
       Research Center, February 12, 2010 and contained in the
       file, ...bigbosor4/case/prismatic/prismaticshell.pdf
        
       3. David Bushnell and Charles Rankin, "Use of GENOPT and
       BIGBOSOR4 to obtain optimum designs of an axially compressed
       cylindrical shell with a composite truss-core sandwich wall",
       AIAA Paper 2011-1811, 52nd AIAA Structures Conference,
       Denver CO, April, 2011
        
       The use of a shell-of-revolution code (BOSOR) to analyze a
       prismatic shell was first explored in the paper: "Stress,
       buckling and vibration of prismatic shells", AIAA Journal,
       Vol.9, No.10, pp 2004-2013, October, 1971, by David bushnell.
        
       The "huge torus" or "huge corrugated annulus" model is a
       "trick" by means of which a shell-of-revolution computer
       program such as BIGBOSOR4 can be used to compute buckling
       of PRISMATIC shells. As of 2010, BIGBOSOR4 now has two
       branches, one for shells of revolution and the other for
       true prismatic panels and shells, not approximate prismatic
       shells modeled as segments of a huge torus.
        
       The INDIC = 4, IPRE = 0 branch of BIGBOSOR4 is used for the
       local and general buckling analyses. The maximum stress is
       computed as if the corrugated panel were subjected
       to uniform end shortening. The prebuckled state of the
       corrugated panel is a membrane state (no prebuckling
       bending). The prebuckling axial stress resultant is
       everywhere proportional to the wall thickness. Since in the
       present model the thickness, THICK(i), is uniform in the ith
       segment, the axial resultant is uniform in the ith segment.
       There is no width-wise resultant because, under the
       uniform axial compression, each corrugated panel segment
       is free to undergo Poisson-ratio expansion in its
       width-wise (x-coordinate) direction.
 
  10.1 total width of the corrugated panel: WIDTH
  10.2 
       This is the width projected on the x-axis, that is, the
       dimension in the x-coordinate direction. Half of this width
       is to be included in the model, with symmetry conditions
       applied at x = WIDTH/2 in the prebuckling phase of the
       problem and both symmetry and anti-symmetry conditions
       applied in the bifurcation buckling phase of the problem.
 
  15.1 axial length of the corrugated panel: LENGTH
  15.2 
       This is the total axial length of the corrugated panel.
       The axial stress resultant acts in the LENGTH direction
       (the z-coordinate direction).
 
 
  20.0 
       Next, you will be asked to provide the fraction, FACLEN,
       of the axial length, LENGTH, to be used in the model for
       LOCAL buckling of the corrugated panel. FACLEN (should be
       less than 0.5) is used because less computer time is
       required to find the critical (lowest) LOCAL buckling load
       because there are fewer axial halfwaves in the
       length, FACLEN x LENGTH, than in the total length, LENGTH.
       Note that FACLEN is the same for all the panel segments.
       In this study the writer has been using FACLEN = 0.3.
 
  25.1 fraction of LENGTH for local buckling model: FACLEN
  25.2 
       Maybe use FACLEN = 0.3 to begin with. You can first
       optimize with FACLEN = 0.3, then use a bigger value such
       as 0.5 or a smaller value such as 0.1 and re-optimize
       to see if there is any difference.
 
  30.1 number of major segments in WIDTH/2: NSEG
  30.2 
       You might start by using NSEG = 3
       NSEG is the number of MAJOR cylindrical segments over
       HALF the width, WIDTH, of the corrugated panel, that
       is, the number of segments over the distance, WIDTH/2.
       The ith major segment has an overall radius of curvature,
       RPLATE(i), in which RPLATE(i), a derived quantity, is
       related to PHISIG(i), which is a decision variable.
       Hence, the ith major segment is a sector of a little
       cylindrical shell, the radius of which is RPLATE(i),
       the generators of which run in the z direction,
       and the angle spanned of which is 2.*PHISEG(i).
        
       The ith major segment may be divided into NSUBSEG(i)
       sub-segments, each of which is a sector of a little
       cylindrical shell with radius RSUBSEG(j,i), in which
       j = 1, 2, ... , NSUBSEG(i) is the sub-segment number.
       The signs of the major curvatures, 1/RPLATE(i), may
       be plus or minus, depending on the value of UPDOWN(i),
       an input index asked for later. The signs of the
       curvatures, 1/RSUBSEG(j,i), of the jth sub-segment in
       the ith major segment may be plus or minus, depending
       on the value of UPDWNS(j,i), an input index asked for
       later. In the array, UPDWNS(j,i), j = 1,2,...NSUBSEG(i)
       and i = 1,2,...NSEG. All the NSUBSEG(i) sub-segments
       in the ith segment have the same PHISUB(i). The
       PHISUB(i), i = 1,2,...NSEG, may differ from eachother.
       PHISUB(i) are decision variables, to be defined later.
       RSUBSEG(j,i) are derived quantities, not input variables.
 
 
  35.0 
       Next, you will be asked to provide material properties.
       The wall of the corrugated panel is assumed to have only
       one layer and the material is assumed to be isotropic
       and elastic.
 
  40.1 elastic modulus of the material: EMOD
  45.1 Poisson ratio of the panel material: NU
  50.1 weight density of the panel material: DENSTY
 
  55.0 
       Next, you will be asked to provide ranges of the
       number of axial half-waves, M, in the general and local
       buckling modes. You will be asked to provide the following:
        
       1. MLOWGS = low end of the M-range for GENERAL buckling which
       is SYMMETRIC about the symmetry plane at x = WIDTH/2.
        
       2. MHIGHGS = high end of the M-range for GENERAL buckling
       which is SYMMETRIC about the symmetry plane at x=WIDTH/2.
        
       3. MLOWGA = low end of the M-range for GENERAL buckling which
       is ANTI-SYMMETRIC about the symmetry plane at x=WIDTH/2.
        
       4. MHIGHGA = high end of the M-range for GENERAL buckling which
       is ANTI-SYMMETRIC about the symmetry plane at x=WIDTH/2.
        
       5. MLOWL = low end of the M-range for LOCAL buckling. It is
       assumed that the local buckling mode is SYMMETRIC at the
       symmetry plane at x=WIDTH/2.
        
       5. MHIGHL = high end of the M-range for LOCAL buckling.
        
       It is best always to use MLOWGS = MLOWGA = MLOWL = 1  .
       A suggestion: Use from 5 to 10 for MHIGHGS; use 10 for MHIGHGA;
       use 30 for MHIGHL.
 
  60.1 low end of M-range: symmetric GENERAL buckling: MLOWGS
  60.2 
       M is the number of axial halfwaves over the axial length,
       LENGTH. MLOWGS governs GENERAL buckling that is SYMMETRIC
       about the symmetry plane at x = WIDTH/2.
        
       MLOWGS should be 1 (an integer).
 
  65.1 high end of M-range: symmetric GENERAL buckling: MHIGHGS
  65.2 
       M is the number of axial halfwaves over the axial length,
       LENGTH. MHIGHGS governs GENERAL buckling that is SYMMETRIC
       about the symmetry plane at x = WIDTH/2.
       Use an integer such as 5 . You can use a fairly low number
       for MHIGHGS because the local buckling model covers the high
       number of axial halfwaves, and therefore you don't have
       to cover the same range of axial half-wavelengths for
       the general buckling mode which is symmetric about
       the symmetry plane at x=WIDTH/2.
 
  70.1 low end of M-range: antisymmetric GENERAL buckling: MLOWGA
  70.2 
       By "M" is meant the number of axial half-waves in
       the buckling mode over the length, LENGTH, of the
       corrugated panel. In this instance we are referring
       to the GENERAL buckling mode which is ANTISYMMETRIC
       about the symmetry plane at x = WIDTH/2.
       MLOWGA should be 1 (an integer).
 
  75.1 high end of M-range: antisymmetric GENERAL buckling: MHIGHGA
  75.2 
       By "M" is meant the number of axial half-waves in
       the buckling mode over the length, LENGTH, of the
       corrugated panel. In this instance we are referring
       to the GENERAL buckling mode which is ANTISYMMETRIC
       about the symmetry plane at x = WIDTH/2.
       Perhaps one should give a value MHIGHGA=10 (or something
       like that). It depends on how many axial halfwaves
       you think will correspond to the critical GENERAL
       buckling mode. That number depends on the overall axial
       bending stiffness of the corrugated panel wall and
       the axial length of the corrugated panel. Use at least
       double the value of what you think may be the critical
       value, that is, the value that corresponds to the
       lowest GENERAL buckling load. You may have to
       adjust the value of MHIGHG as your project proceeds.
 
  80.1 low end of the M-range: LOCAL buckling: MLOWL
  80.2 
       By "M" is meant the number of axial half-waves in
       the buckling mode over the length, FACLEN x LENGTH, of
       the corrugated panel. In this instance we are referring
       to the LOCAL buckling mode. It is assumed that the
       LOCAL buckling mode is SYMMETRIC about the symmetry
       plane at x = WIDTH/2.
       You should use MLOWL = 1 because the axial length of
       the portion of the corrugated panel to be used in the
       LOCAL buckling analysis is equal to LENGTH x FACLEN,
       in which LENGTH is the actual axial length of the
       corrugated panel, and FACLEN is the fraction of
       LENGTH to be included in the LOCAL buckling model.
 
  85.1 high end of the M-range: LOCAL buckling: MHIGHL
  85.2 
       We're referring here to the range of axial halfwaves
       to be used in the search for the critical LOCAL
       buckling load of the corrugated panel of effective length,
       FACLEN x LENGTH. Use a number such as 30 and adjust
       it later if necessary. The larger that FACLEN is, the
       higher MHIGHL should be.
 
 
  90.0 
       Next, you will be asked to identify which STAGS finite
       element (IELEMNT = 940 or 410 or 480) that you want STAGS
       models to be constructed with. (Generally choose 480).
       NOTE: The STAGS model is NOT used in the optimization loop
       but is used AFTER an optimum design has been obtained.
       The STAGS model is used in order to evaluate the quality
       of the BIGBOSOR4 models used for the buckling analyses.
       The "span" software automatically generates two STAGS input
       files, *.inp and *.inp2, in which "*" represents the user-
       established SPECIFIC name for the case. *.inp is the STAGS
       input for a finite element model that includes half the
       width, WIDTH, of the panel, with symmetry applied at
       x = WIDTH/2; *.inp2 is the STAGS input for a finite element
       model that includes the entire panel of width, WIDTH.
 
  95.1 finite element used in STAGS model: IELMNT
  95.2 
       Generally choose IELMNT = 480
 
 
 100.0 
       Next, you will be asked to provide the number of sub-segments,
       NSUBSEG, within each of the NSEG major segments. NSUBSEG is
       a vector with NSEG elements. Each sub-segment within a
       given major segment, such as major segment i, is curved with
       meridional radius of curvature equal to RSUBSEG, a derived
       quantity that depends on PHISUB, which is possibly a decision
       variable and which is equal to half the angle (degrees)
       that spans the sub-segment. PHISUB(i), i = 1, 2, ... NSEG,
       is the same for all the sub-segments within a given
       major segment, but PHISUB(i) may differ from PHISUB(j).
        
       NSEG is the number of MAJOR panel segments over HALF the
       width, WIDTH, of the corrugated panel, that is, the
       number of segments over the distance, WIDTH/2. The ith major
       panel segment has an overall radius of curvature of
       RPLATE(i), in which RPLATE(i), a derived quantity, is
       related to the decision variable, PHISEG(i) = half the
       angle that spans the ith major corrugation segment.
       Hence, the ith major segment is a sector of a little
       cylindrical shell, the radius of which is RPLATE(i) and
       the circumferential included angle of which is 2*PHISEG(i).
        
       The ith major segment may be sub-divided into NSUBSEG(i)
       sub-segments, each of which is also a sector of a little
       cylindrical shell with radius RSUBSEG(j,i) and with included
       angle 2*PHISUB(i). In the quantities, RSUBSEG(j,i) and PHISUB(i),
       i is the number of the major segment and j is the number of
       the sub-segment within the ith major segment. The signs
       of the major curvatures, 1/RPLATE(i), may be plus
       or minus, depending on the value of UPDOWN(i), an
       input index asked for later. The signs of the curvatures,
       1/RSUBSEG(j,i), of the jth sub-segment in the ith major
       segment may be plus or minus, depending on the value of
       UPDWNS(j,i), an input index asked for later. RSUBSEG is a
       matrix with NSUBSEG(i) rows and NSEG columns. RSUBSEG is a
       derived quantity, related to PHISUB(i), which is constant
       within the ith segment and which may differ from major
       segment to major segment. There can be zero sub-segments
       within a major segment (NSUBSEG(i)=0 or 1). NSUBSEG(i) = 1
       has the same effect as NSUBSEG(i) = 0: With NSUBSEG(i)=1
       there are no sub-segments. Generally, you should use
       a small number for NSUBSEG(i), say from 0 to 5. The more
       major segments you have in a model, the smaller the number
       of sub-segments, NSUBSEG(i), should be.
        
       Note that computer time increases whenever you have
       sub-segments because there are more degrees of freedom in
       the BIGBOSOR4 discretized models for local and general
       buckling than exist in models without sub-segments.
 
 105.1 Number INSUBSE of rows in the array  NSUBSEG: INSUBSE
 110.1 number of sub-segments in major segment: NSUBSEG
 110.2 
       Each of the curved major segments may itself be corrugated,
       with the number of sub-segments equal to NSUBSEG(i) and
       the meridional radii of curvature equal to RSUBSEG(j,i),
       with possibly alternating sign of meridional curvature from
       sub-segment to sub-segment. Within a given major segment
       PHISUB(i) is the same for each sub-segment. PHISUB(i)
       may differ from major segment to major segment. Also,
       NSUBSEG(i) may differ from major segment to major segment.
       The RSUBSEG(j,i), derived quantities, are related to the
       half-angles, PHISUB(i), which may be decision variables.
 
 
 115.0 
       Next, you will be asked to provide a vector of indices called
       UPDOWN(i), i=1,NSEG. UPDOWN(i) = 1 means that the shell major
       segment is convex upward; UPDOWN(i) = 2 means that the major
       segment is convex downward. UPDOWN(i) pertains to the
       MAJOR segments, not to the sub-segments. You will later
       be asked to provide analogous indices for each sub-segment
       within each major segment.
 
 120.1 1 = convex surface up; 2 = convex down: UPDOWN
 120.2 
       SUGGESTION: Start by alternating "convex surface up" and
       "convex surface down" with successive major shell segments.
       Optimize, then experiment with various configurations later.
 
 
 125.0 
       Next, you will be asked to provide an array of indices
       for "convex surface up" and "convex surface down" for each
       of the sub-segments. The array of indices is called "UPDWNS"
       (meaning "convex up or convex down for each sub-segment".
       The array, UPDWNS, is two dimensional: UPDWNS(i,j), in
       which j is the major segment number and i is the sub-segment
       number within the jth segment.
 
 130.1 Number JUPDWNS of columns in the array, UPDWNS: JUPDWNS
 135.1 Number IUPDWNS of rows in this column of UPDWNS: IUPDWNS
 140.1 1=convex up; 2=convex down (subsegments): UPDWNS
 140.2 
       First try alternating orientations of the convex surface in
       successive sub-segments. Optimize. Then experiment with various
       configurations.
 
 
 145.0 
       Next, you will be asked to provide an index, UPDNBIG, governing
       whether RADBIG, which is the overall radius of curvature,
       generates a "convex up" curvature (UPDNBIG = 1) or a
       "convex down" curvature (UPDNBIG = 2). Usually, you will
       want the overall curvature to arch upward ("convex up"),
       like an arch bridge, for example. RADBIG is a derived
       quantity, depending on the angle, PHIBIG, which can be a
       decision variable.
 
 150.1 1=convex up (hill); 2=convex down (valley): UPDNBIG
 150.2 
       UPDNBIG governs the sign of the OVERALL curvature of the
       corrugated panel, (overall curvature) = 1/RADBIG, in which
       RADBIG is the overall radius of curvature and is a
       derived quantity related to the half-angle, PHIBIG, which
       spans the distance, WIDTH/2, and which is to be defined later.
 
 
 155.0 
       Next, you will be asked to provide starting values of
       the decision variables:
        
       1. Thickness, THICK, of a major cylindrical segment, assumed
       to be constant in each major segment of the corrugated panel.
       THICK is a one-dimensional array: THICK(i), i = 1, 2, ..NSEG,
       in which NSEG = the number of major segments over WIDTH/2.
        
       2. Projected widths, SUBWID, of each of the NSEG
       MAJOR segments in the half-model (WIDTH/2) of the corrugated
       panel. SUBWID is the width of a cylindrical major segment as
       projected on the x,z plane, that is, the "x-width".
       NOTE: The sum of NSEG SUBWID(i) must equal WIDTH/2.
        
       3. Half-angle, PHISEG, of each of the NSEG major segments.
       2 x PHISEG(i) is the total angle spanned by the ith major
       corrugation segment. RPLATE(i), a derived quantity, is
       the meridional radius of curvature of a major corrugation
       segment, that is, the radius of the little cylindrical
       sector. RPLATE is constant in that major segment. Hence, each
       major segment is part of a little cylindrical shell the
       generators of which are oriented in the axial (z) direction.
       The sign of the curvature, 1/RPLATE(i), of the ith major
       segment depends on the index, UPDOWN(i) = 1 or 2, that you
       have already supplied [UPDOWN(i) = 1 means "convex surface
       up" (a "hill"), and UPDOWN(i) = 2 means  "convex surface
       down" (a "valley")].
        
       4. Half-angle, PHISUB, of each of the sub-segment corrugations
       within each of the NSEG major segments. 2 x PHISUB(i) is
       the total angle spanned by the ith sub-corrugation. RSUBSEG(j,i),
       a derived quantity, is the meridional radius of curvature of a
       sub-corrugation. For all the NSUBSEG(i) sub-corrugations
       within the ith major segment, PHISUB(i) is the same.
       The sign of the curvature, 1/RSUBSEG(j,i), of the jth sub-
       segment within the ith major segment  depends on the index,
       UPDWNS(j,i) = 1 or 2, that you have already supplied.
       [UPDWNS(j,i)=1 means "convex surface up" (a "hill"), and
       UPDWNS(j,i)=2 means "convex surface down" (a "valley")].
        
       5. Distance, YPLATE, of each of the NSEG-1 panel segment
       junctions above the origin of the x,y,z coordinate system
       and of the left-hand longitudinal edge and of the right-hand
       symmetry plane of the corrugated panel with the assumption
       that PHIBIG = 0 degrees.
       (x = the widthwise coordinate; y = coordinate normal to the
       x-z plane, as if the two longitudinal edges and the
       generators at the major segment junctions all lie in the
       same plane (as if PHIBIG=0 degrees), that is, as if the
       widthwise major segments, SUBWID, all lie in the same plane;
       z = axial coordinate along which the axial compression is
       to be applied.
        
       6. Overall arching half-angle, PHIBIG, over the half-width,
       WIDTH/2, of the corrugated and sub-corrugated panel. The sign
       of the overall curvature, RADBIG, a derived quantity, depends
       on the index, UPDNBIG, that you have already supplied.
 
 160.1 Number ITHICK  of rows in the array  THICK: ITHICK 
 165.1 wall thickness of the major segment: THICK
 165.2 
       In this model the wall thickness is constant over each
       major segment of the corrugated panel and can be
       different in each major segment.
 
 170.1 projected width (x-width) of major segment: SUBWID
 170.2 
       The corrugated panel consists of NSEG cylindrical major segments.
       SUBWID is the width of a major corrugation projected onto
       the x,z plane. NOTE: The total width of all SUBWID(i),
       i = 1, 2,...NSEG, must be equal to WIDTH/2, half the width
       of the entire corrugated panel. In the *.DEC file (input
       for DECIDE) you must introduce two inequality constraints
       in order to enforce this requirement. (See the file, *.DEC.)
 
 175.1 half-angle (deg.) of major corrugation: PHISEG
 175.2 
       The decision variable candidates are the NSEG values,
       PHISEG(i), of the NSEG cylindrical major segments of
       the corrugated panel. PHISEG(i) is half the angle in
       degrees spanned by the cylindrical corrugation of the
       ith major segment of the corrugated panel. PHISEG(i)
       must be positive and be less than 90 degrees and
       greater than zero degrees. It is a good idea to set
       the lower bound of PHISEG(i) to something like 5
       degrees and the upper bound of PHISEG(i) to something
       like 85 degrees. Possibly use starting values of
       PHISEG(i), i = 1, 2, ..., NSEG, that are all the same.
       The sign of the major segment meridional curvature,
       1/RPLATE(i), in the ith major segment may change from
       major segment to major segment, as governed by an
       index, UPDOWN(i) = 1 or 2, that you have already
       provided. RPLATE(i), i=1,NSEG, are derived quantities.
 
 180.1 half-angle (deg.) of sub-corrugation: PHISUB
 180.2 
       The decision variable candidates are the NSEG sub-corrugation
       half-angles, PHISUB(i), i = 1, 2, 3 ... NSEG, which are all
       the same within a major segment but which can differ from
       major segment to major segment. Within any major segment
       the signs of the sub-segment meridional curvatures,
       1/RSUBSEG(j,i), in the ith major segment may change from
       sub-segment to sub-segment within that major segment,
       as governed by an index, UPDWNS(j,i) = 1 or 2, that
       you have already provided. RSUBSEG are derived quantities.
 
 
 185.0 
       Next, you will be asked to provide the vertical distances,
       YPLATE(i), i = 1,2,...NSEG+1, that the left-hand and right-hand
       longitudinal edges of the corrugated panel and the junctions
       between the NSEG major panel segments are raised above
       the origin of the (x,y,z) coordinates neglecting the
       overall arching of the corrugated panel, that is, assuming
       that PHIBIG = 0 degrees. x,y,z are:
       x = widthwise coordinate, increasing from left to right;
       y=coordinate normal to the x-z plane, as if the two
       longitudinal edges and the generators at the major segment
       junctions all lie in the same plane (as if PHIBIG=0 degrees);
       z = axial coordinate along which the axial compression is
       to be applied.
        
       The right-hand longitudinal edge mentioned above is at the
       symmetry plane. The input datum, YPLATE(1) > 0.0, is needed in
       order to avoid negative or zero or near-zero values of
       the other y-coordinates, YPLATE(2), YPLATE(3), ... ,
       YPLATE(NSEG+1), of the corrugated panel during
       optimization cycles. A good choice is: YPLATE(1)=2xWIDTH/NSEG.
       NOTE: You must use a POSITIVE values for all the YPLATE(i).
       ANOTHER NOTE: Use POSITIVE lower bounds for YPLATE(i) in
       the "DECIDE" interactive session.
       YPLATE(1) should NOT be a decision variable.
 
 190.1 Number IYPLATE of rows in the array  YPLATE: IYPLATE
 195.1 vertical y above (x,y,z) origin if PHIBIG=0: YPLATE
 195.2 
       The decision variable candidates are the NSEG + 1 coordinates,
       YPLATE, at the NSEG - 1 junctions between the segments of the
       corrugated panel and at the left-hand longitudinal edge of the
       corrugated  panel and at the symmetry plane of the panel.
       You must use POSITIVE values. You probably should choose
       YPLATE(i) = YPLATE(1) for i = 2, 3 ... NSEG+1, for starting
       values for all the YPLATE(i). When you choose decision
       variables in DECIDE, you should NOT choose YPLATE(1) as
       a decision variable. (YPLATE(1) is the value of YPLATE
       at the left-hand longitudinal edge of the corrugated panel.)
 
 200.1 half-angle (deg.) of overall arching: PHIBIG
 200.2 
       PHIBIG is the overall arching half-angle of
       the corrugated and sub-corrugated panel. The model is
       such that it arches upward above the x,z plane if
       UPDNBIG = 1 and it arches downward below the x,z plane
       if UPDNBIG = 2  .
       A good lower bound for PHIBIG is 5.0 degrees and a
       good upper bound for PHIBIG is 85.0 degrees.
 
 
 205.0 
       Next, provide the total axial load. In this problem there is
       only one load case: overall axial compression. The axial
       stress resultant in each of the NSEG segments of the corrugated
       panel are computed as if the entire corrugated panel is subjected
       to uniform end shortening. In other words, the axial
       resultant at any point across the width of the corrugated panel
       is proportional to the wall thickness of each major segment.
       What will be asked for next is the TOTAL axial load over
       WIDTH (negative for compression, units = lb, for example),
       applied to the entire corrugated panel. It is assumed in this
       model that the applied axial compression does not induce
       any width-wise loading. In other words, the corrugated panel
       is free to expand in the width direction when the axial
       compression is applied.
 
 210.1 Number NCASES  of load cases (environments): NCASES 
 215.1 total axial load (e.g. lb) over WIDTH: TOTLOD
 215.2 
       This is the total axial load in lb for example. It is
       assumed in this model that the axial resultant at each point
       in each segment of the corrugated panel is proportional to
       the wall thickness of the major segment. In this model
       the thickness of each major segment is uniform and the
       same thickness, THICK, exists throughout that segment.
 
 
 220.0 
       Next, you will be asked to provide allowables and factors
       of safety for the following five behaviors:
        
       1. local buckling
        
       2. general buckling with symmetry imposed at the symmetry
       plane at x = WIDTH/2
        
       3. general buckling with anti-symmetry imposed at the
       symmetry plane at x = WIDTH/2
        
       4. "classical" buckling of each of the cylindrical sectors
       that include suitable knockdown factors from Brush & Almroth
       that are automatically obtained from a table of knockdown
       factor vs local radius/thickness for each cylindrical sector
        
       5. maximum effective stress in the entire structure
       The effective stress is given by:
       STRESS = SQRT(sig1^2 +sig2^2 -sig1sig2 +3.sig12^2)
 
 225.0 local buckling load factor: LOCBUK
 225.2 
       LOCBUK is the lowest local buckling load for the entire
       corrugated panel. We do not attempt to find the local buckling
       load of each of the segments in the corrugated panel. That
       is done later (in SUBROUTINE BEHX4) from a much simpler
       "classical" buckling analysis including knockdown factors
       from the book by Brush and Almroth. LOCBUK is computed
       with the use of an effective axial length:
       (effective axial length) = FACLEN x LENGTH .
       The same BIGBOSOR4 true prismatic shell model is
       used for local buckling in SUBROUTINE BEHX1 as is used
       for general buckling in SUBROUTINES BEHX2 and BEHX3.
       The only difference is the effective axial length
       used for local buckling is FACLEN x LENGTH, whereas the
       actual length, LENGTH, is used for general buckling.
 
 
 230.0 
       Usually you should supply the allowable for local buckling
       as 1.0, since the local buckling load is actually a buckling
       load factor. The local buckling load is given by:
       local buckling load = (eigenvalue) x (applied axial compression)
       in which (eigenvalue) is the buckling load factor. You can
       supply 1.0 for the local buckling allowable because you will
       be given the opportunity to supply a factor of safety for
       local buckling in order to compensate for initial imperfections.
 
 235.1 allowable for local buckling: LOCBUKA
 235.2 
       Use 1.0 for the buckling allowable.
 
 240.1 factor of safety for local buckling: LOCBUKF
 240.2 
       You might start by using 2.0, then change it later if you
       want to re-optimize with a different Factor of Safety
       (F.S.). A suggestion: LOCBUKF = 2.0 in order to
       compensate for initial imperfections.
 
 245.0 symmetric general buckling: BUKSYM
 245.2 
       BUKSYM will have a mode shape that is symmetric at
       x = WIDTH/2 (the structural symmetry plane).
 
 250.1 allowable for sym. general buckling: BUKSYMA
 250.2 
       Use 1.0 for the buckling allowable.
 
 255.1 f.s. for symmetric general buckling: BUKSYMF
 255.2 
       You can start by using 1.5, then change it later if you want.
 
 260.0 antisymmetric general buckling: BUKASY
 260.2 
       The buckling mode will be antisymmetric at the symmetry
       plane of the corrugated plate, that is, at x = WIDTH/2.
 
 265.1 allowable for antisym. general buckling: BUKASYA
 265.2 
       Use 1.0 for the buckling allowable.
 
 270.1 f.s. for antisym. general buckling: BUKASYF
 270.2 
       You can start by using 1.5, then change it later if you want.
 
 
 275.0 
       Next, you will be asked to provide an allowable and a
       factor of safety for a behavior called "CYLBUK". CYLBUK
       is the automatically knocked-down buckling load factor for
       "classical" buckling of an imperfect, axially compressed
       cylindrical shell of thickness THICK(i), i=1,NSEG and
       radius, RPLATE(i) (or RSUBSEG).
        
       The classical buckling stress is given by Formula no. 15 in
       Table 15.2 on p. 735 of Roark's formulas for stress and strain,
       by Warren C. Young and Richard G. Budynas (7th Edition),
       McGraw-Hill, 2002. This "classical" buckling formula is:
       sigma(critical) = (EMOD*THICK/RADIUS)/SQRT[3(1-NU**2)]
       in which sigma(critical) is the buckling stress and RADIUS
       is either RPLATE(i) or RSUBSEG(j,i), i = 1, 2, ...NSEG,
       whichever radius is relevant. The buckling load factor is
       sigma(critical)/sigma(axial), in which sigma(axial) is the
       applied axial compressive stress. An appropriate knockdown
       factor is automatically applied to the "classical" buckling
       formula. This appropriate knockdown factor depends on the
       local radius/thickness as set forth in the 1975 book by
       Brush and Almroth. Since the knockdown factor is already
       included in the computation of CYLBUK, you should supply
       a Factor of Safety, F.S.=1.0, for this behavioral constraint.
       CYLBUK is computed including the use of a knockdown factor
       that lies close to the curve shown in Fig. 18 on page 20 of
       COMPUTERIZED BUCKLING ANALYSIS OF SHELLS, D. Bushnell,
       Martinus Nijhoff, publisher (1985). This curve is taken
       from the well-known book by Brush and Almroth, BUCKLING
       OF BARS, PLATES, AND SHELLS, McGraw-Hill, 1975.
        
       CYLBUK is a two-dimensional array, CYLBUK(iload,jseg),
       in which iload is the load set number and jseg is the
       segment number. In this formulation there is only
       one load set (iload = 1), and there are MSEG segments.
       MSEG is the total number of segments in the structure.
       (See SUBROUTINE BEHX1 for a derivation of MSEG.)
       Corresponding to each major segment there is a radius,
       RPLATE(iseg), if there are no sub-segments, and
       RSUBSEG(jseg,iseg) if there are sub-segments. The thickness
       of the corrugated major segment is uniform throughout. Hence,
       the classical buckling load is governed by RADIUS/THICK,
       in which RADIUS is either RPLATE(iseg) or RSUBSEG(jseg,iseg).
 
 280.1 Number JCYLBUK of columns in the array, CYLBUK: JCYLBUK
 285.0 classical buckling load factor: CYLBUK
 285.2 
       CYLBUK [a 2-dimensional array, CYLBUK(iload,jseg)] are
       all those classical buckling load factors corresponding to
       the various segments and/or sub-segments of the corrugated
       panel, including suitable knockdown factors for
       initial imperfections derived from a curve produced by
       Brush and Almroth in their 1975 book.
 
 290.1 allowable for classical buckling: CYLBUKA
 290.2 
       Use 1.0 for this buckling allowable.
 
 295.1 factor of safety for classical buckling: CYLBUKF
 295.2 
       Axially compressed cylindrical shells are notoriously
       sensitive to initial imperfections. However, the formula
       for CYLBUK has INCLUDED IN IT a suitable knockdown factor
       to account for initial imperfections. Therefore, you
       should use 1.0 for CYLBUKF.
 
 300.0 maximum effective stress: STRESS
 300.2 
       This is the maximum effective stress in the entire
       corrugated panel. The formula for effective stress is:
       STRESS = SQRT(sig1^2 +sig2^2 -sig1sig2 +3.sig12^2)
 
 305.1 allowable effective stress: STRESSA
 305.2 
       Usually you will use the proportional limit of the uniaxial
       stress-strain curve for the allowable stress, STRESSA.
 
 310.1 factor of safety for stress: STRESSF
 310.2 
       You might start with 1.0, then raise it later in order
       to account for the effect of initial imperfections
       or other phenomena that give rise to prebuckling bending.
       A suggestion: STRESSF = 1.5.
 
 315.0 weight of the corrugated panel: WEIGHT
 315.2 
       This is the weight (e.g. lb) of the entire corrugated panel,
       the entire width of which is WIDTH.
       In the BIGBOSOR4 computer program the total mass is called
       TOTMAS. If for density you use weight density instead of
       mass density, then TOTMAS, computed by BIGBOSOR4, will be
       the total weight of the corrugated true prismatic
       shell model.
 
 999.0 DUMMY ENTRY TO MARK END OF FILE

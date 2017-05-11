  INFORMATION ABOUT THE PANDA2 SYSTEM FOR PANEL OPTIMIZATION

NOTE: This file is out-of-date. Please see the files
..panda2/doc/panda2.news and ..panda2/doc/panda2.tex .
 **************************************************************

                     TABLE OF CONTENTS

I.   SUMMARY

II.  HOW TO RUN PANDA2

III. PANDA2 COMMANDS

IV.  PANDA2 FILES

V.   PANDA2 DOCUMENTATION

VI.  RECOMPILING SOURCE FILES, REGENERATING LIBRARIES, RE-LINKING
     (VAX version)

VII. PANDA2 SAMPLE CASE

VIII PANDA2.NEWS

IX.  PANDA2 PLOTS

 X.  PANDA2 RUNS ON UNIX-BASED SYSTEMS!

XI.  PANDA2 processors STAGSMODEL and STAGSUNIT create input file for STAGS

XII. New types of analysis with PANDA2: ITYPE=4 and ITYPE=5

XIII New processor AUTOCHANGE and procedure SUPEROPT
********************************************************************

I.  SUMMARY

The purpose of PANDA2 is to find the minimum weight design of a
stiffened panel made of laminated composite material. Of course, simple
isotropic panels can also be designed.  The panel can be loaded by up
to 5 independent sets of loads, (Nx, Ny, Nxy, Mx, My, and p), in which
Nx is the load in the axial direction (negative for compression) and p
is the normal pressure. Mx and My are axial ang hoop moment resultants.
The panel may also be "loaded" by temperatures, which can be different
in each segment of a panel module. Temperatures are uniform in all
segments except for the web(s), in which temperature is assumed to vary
linearly from the root of the web to the tip. Included with each of the
5 load sets are:

 (a) a local imperfection, assumed to be in the form of the
local buckling mode;

 (b) a global imperfection, assumed to be in the shape of the
general buckling mode; 

 (c) a global out-of-roundness, assumed to be prismatic (uniform
in the axial direction) and vary as cos(2*theta) in the circumferential
direction;

 (d) an inter-ring imperfections, assumed to be in the shape of the
inter-ring buckling mode.

PANDA2 represents a more detailed treatment of certain behavior not
handled by the original PANDA [1]. In particular, optimum designs can be
obtained for both perfect and imperfect panels with locally post-buckled
skin and for panels with hat stiffeners and panels with isogrid-stiffened
or truss-core sandwich construction or other sandwich wall construction;
stresses induced by uniform normal pressure are included in the analysis.
Thermal loading and loading by edge moments are also handled. The effects
of further bending of the panel as it is loaded by axial and/or hoop
compression are of course included. Residual stresses from curing the
panel and stiffeners are accounted for. 

Optimization is carried out based on several independently treated
structural models of the panel, as follows: 

1. PANDA-type models [1] for general, local, and panel bucking,
buckling of stiffener parts, and rolling of stiffeners with and without
participation of the panel skin are included.  These models are
described in detail in [1].  (See Table 1 and Figs. 1-4 of [1].) 

2. Buckling load factors and post-local buckling behavior are
calculated for what is termed in PANDA2 a "panel module". Such a module
is depicted in Figs. 1 and 2. A module includes the cross section of a
stiffener plus the panel skin of width equal to the spacing between
stiffeners. In this model the panel module cross section is divided
into segments, each of which is discretized and analyzed via the finite
difference energy method. Variation of deflection in the axial
direction is assumed to be harmonic [sin(n*theta) or cos(n*theta)].
This one-dimensional discretization is similar to that used in the
BOSOR programs for the analysis of shells of revolution.  In fact, many
of the subroutines for buckling and vibration analysis are taken from
BOSOR4 and modified slightly.  The modification is necessary to handle
prismatic structures instead of shells of revolution. Both local and
wide-column instability can be handled with the same structural model. 

3. A discretized model of the entire width of the panel, treated in
this case with stringers smeared out. This model is used only if there
exists normal pressure or if the axial load varies across the width of
the panel. 

4. A discretized module model analgous to that described in Paragraph 2
just above but this time involving one ring and the skin with smeared
stringers between rings. This model is described in detail in ITEM 463
of the file ...panda2/doc/panda2.news.

In the panels designed by PANDA2 the skin between stringers may buckle
well before failure of the panel.  The maximum stress components and
therefore stress constraints in the optimization analysis are computed
including growth and modification of the local skin buckling mode as
predicted in a theory similar to that formulated by Koiter in 1943 [4].

A typical panel module is shown in Fig. 1.
 
 
        Seg. No. 4-.
                    . |<------  w  ------>|
                     ._____________________
                                |   ^   
           Segment No. 3 -----> |   |
                                |   |
               Seg. No. 2-.     |   h
                           .    |   |
         Seg. No. 1-.       .   |   |             .-Seg. No. 1 again
                   .         .  |   V            .
        --------------=====================--------------
                      |<------ b2 ------->|
        |<--- Module width, or stiffener spacing, b --->|
 
   FIGURE 1   SINGLE MODULE OF A PANEL WITH T-SHAPED STRINGERS
              (AXIAL LOAD  Nx  ACTS NORMAL TO THE SCREEN)
 
 
Figure 2 shows how the single module fits into the complete,
multi-module panel: 
 
 
         ___                  ___                   ___
          |                    |                     |
          |                    |                     |
--------=====----------------=====-----------------=====---------
|<---Module No. 1-->|<-- Module No. 2 --->|<--- Module No. 3 -->|
 
 
FIGURE 2   PANEL WITH T-SHAPED STRINGERS, CONSISTING OF 3 MODULES
 
 
 
Symmetry conditions are applied at the left and right edges of the
single module.  After the optimum design is obtained, you can, if there
is no in-plane shear loading Nxy, check the accuracy of the general
instability load predicted from the single-module model by running a
multi-module model with BOSOR4 [2]. The input data file for this
multi-module model are generated automatically by PANEL processor of
the PANDA2 system. You can also check the results by comparing with
results from the STAGS computer program [22,23]. A STAGS input data
file is generated automatically by the STAGSMODEL processor of the
PANDA2 system. 
 
As with PANDA, the program PANDA2 consists of several independently
executable processors which share a common data base.  In the processor
BEGIN you supply a starting design (perhaps a design produced by
PANDA). In DECIDE you choose decision variables for the optimization
analysis and their upper and lower bounds;  you choose linking
variables and their factors of proportionality; and you choose "escape"
variables (explained below).  In MAINSETUP you choose strategy
parameters such as number and range of axial half-waves in the local
buckling mode, number of design iterations in the optimization problem,
and factors of safety for general instability and maximum stress.  In
PANDAOPT you cause the analysis to be performed. PANDAOPT consists of
two main branches:  in one branch the structural analyses (stress,
buckling and postbuckling) are performed and in the other new designs
are produced by the optimizer ADS, written by Gary Vanderplaats. In
CHOOSEPLOT/DIPLOT you can select quantities to be plotted.

Further details in a summary form appear in the file PANDA2.TEX.
********************************************************************

II. HOW TO RUN PANDA2

Please see the files ...panda2/doc/howto.update, ...panda2/doc/customer.let,
...panda2/doc/getting.started.

To operate PANDA2 you must have the BOSOR4 program system on a
subdirectory with the name BOSOR4.  The PANDA2 system uses many of the
libraries from the BOSOR4 system, and certain commands (for example
PANEL followed by BOSORALL) use the BOSOR4 processors in toto. 
 
You first activate PANDA2 commands via the command PANDA2LOG. This
command must be given before you do any PANDA2 work. Upon typing the
command PANDA2LOG, you see the following display on your screen: 

            
           PANDA2 COMMANDS HAVE BEEN ACTIVATED. 
            
          PANDA2 commands are: 
            HELPAN       (get information on PANDA2.) 
            BEGIN        (you provide a starting design) 
            CHOOSETEMP   (you establish temperature-dependence of
                          material properties.)
            SETUP        (PANDA2 generates BOSOR4 input) 
            BOSMODEL     (batch run of BOSOR4 preprocessor) 
            DECIDE       (you choose decision variables) 
            MAINSETUP    (you provide strategy and loads for batch run) 
            PANDAOPT     (launch batch run of mainprocessor) 
            CHOOSEPLOT   (you choose which variables to plot v. iterations)
            DIPLOT       (you obtain plots of variables v. iterations.)
            CHANGE       (assign new values to parameters) 
            PANEL        (generate BOSOR4 input for panel with stringers) 
            PANEL2       (generate BOSOR4 input for curved panel with rings)
            SUPEROPT     (find global optimum design)
            STAGSMODEL   (generate STAGS  input for panel)
            CLEANPAN     (delete many files for a case) 
            
          Please consult the following sources for more 
          information about PANDA2: 
            
            1.  PANDA2.HLP  file    (type HELPAN) 
            2.  SAMPLE.CAS  file    (sample case) 
            3.  Documents listed under HELPAN OVERVIEW REF   
            4.  PANDA2.NEWS file, FLOW.CHARTS file
            5.  PANDA2.TEX, PANDA2.REF, PANDA2ST.ORY files.
            6.  Run tutorial options of BEGIN, DECIDE, etc.

 
You then prepare input data interactively via the BEGIN command. These
data establish a starting design, material properties, and temperature
rise pertaining to residual stresses from curing.  A summary of the
data that you provided interactively is stored on a file NAME.BEG,
which you will find very useful in future analyses of the same design
concept. (NAME is a name that you choose and stick with for the entire
case.) 
 
If you wish to allow for the variation of material properties with
temperature, you next type the command CHOOSETEMP. The interactive
session that follows allows you to choose which properties are
temperature-dependent and to provide tables of temperature vs.
"knockdown" factor for each of these properties. The "knockdown" factor
is a factor applied to the nominal value of the property that you
provided in BEGIN to yield the value of the property at temperature.
PANDA2 uses linear interpolation for "knockdown" factors at
temperatures between those you provide in the Temperature vs.
"knockdown" tables in CHOOSETEMP. You can do CHOOSETEMP at any time in
your analysis. However, once CHOOSETEMP has been done, you cannot
"undo" it and go back to temperature-independent properties unless you
do CHOOSETEMP again and answer that none of the properties is
temperature dependent. 

You next type the command SETUP.
 
A BOSOR4-type of input data file is created by your typing the command
SETUP. (In the VAX-VMS version only, following SETUP, you type the command
BOSMODEL. This launches a batch run of a BOSOR4-type preprocessor which is
almost identical to BOSORREAD--see HELP4 PROGRAMS in the BOSOR4
subdirectory). 
 
The BOSMODEL processor creates a discretized model of a single module
of the panel. (NOTE: in the UNIX version of PANDA2 there is no BOSMODEL
command. The SETUP and BOSMODEL commands are combined into a single
command, SETUP). When the BOSMODEL batch run is finished, you can
either type the command DECIDE or the command MAINSETUP. If you choose
DECIDE, you will be asked to pick decision variables and their upper
and lower bounds, linked variables and linking constants, inequality
constraint expressions that involve only the panel geometry, and escape
variables. If you choose MAINSETUP, you will be asked to provide
strategy parameters, loading, imperfection amplitudes, and factors of
safety. 
 
Suppose you choose DECIDE.  You choose decision variables, their lower
and upper bounds; linked variables; inequality constraint conditions;
and "escape" variables. ("Escape" variables, usually thicknesses) are
variables that are automatically increased in increments of 10 per cent
if the design is so far in the infeasible region that the optimizer ADS
fails to modify it. The input data for the interactive DECIDE session
are stored in a file called NAME.DEC. 

You then type the command MAINSETUP. This leads to an interactive
session in which you provide up to 5 sets of loads, each set of which
consists of "Load set A" and "Load Set B" (explained below under
"MAINSETUP"). You also provide local and general imperfection
amplitudes and certain strategy parameters to be used during the
analysis. The input data for the MAINSETUP session are saved in a file
called NAME.OPT. 

You then type the command PANDAOPT, which launches a batch run of the
PANDA2 mainprocessor. Simple buckling analyses of fixed designs usually
require only a few minutes of time on the VAX 11/780. However, complex
cases with many load sets can require up to about an hour. Six to ten
design iterations in an optimization analysis usually require about 10
to 60 minutes of CPU time, although one very large case, a laminated
hat-stiffened panel with temperature-dependent material properties with
applied pressure and 5 load sets, each with two subcases, required 14
hours on the VAX 11/780 for 10 iterations. The results of the PANDAOPT
run are stored in files called NAME.OPM and NAME.OPP.
 
After inspecting the NAME.OPM file, you may wish to do more design
iterations.  If you feel the strategy parameters established in
MAINSETUP are still good, simply type the command PANDAOPT again. Look
at the new NAME.OPM file. Keep repeating this cycle until you have a
satisfactory design. If along the way you want to change the strategy
parameters, type MAINSETUP again.  If you want to change which
parameters are decision variables or upper or lower bounds, or if you
want to change the linking variables or linking constants of
proportionality, type DECIDE again. 

There are several additional processors in the PANDA2 system. Please read
Item 28 in PANDA2.NEWS (also at the end of this file), and go to
PANDA2.HLP for more details.  These new processors, STORE, CHPLOT, DIPLOT,
allow you to obtain plots of the design variables, design margins, and
objective function v. design iterations since the beginning of the case.
After several "PANDAOPT" commands for a given case, you will probably want
to give the commands CHOOSEPLOT, in which you can choose which variables
and margins you want to plot, and DIPLOT, which leads to generation of the
plots.  You can do several sets of the CHOOSEPLOT - DIPLOT sequence, as in
the following sample runstream: 

            PANDAOPT        (batch run for n design iterations
                             each involving m load sets)
            PANDAOPT        (batch run for n more iterations)
            PANDAOPT        (batch run for n more iterations)
            CHOOSEPLOT      (you choose which design variables
                             you want to have plots of. CHOOSEPLOT
                             will generate a file called *.PL4
                             that contains the names and values of
                             these variables for 3*(n+1) iterations.
                             You choose which (load set,subcase - see
                             item 516 in the PROMPT.DAT file)
                             for which you want plots of margins,
                             and you choose which margins you
                             want to plot.  CHOOSEPLOT will
                             generate a file called *.PL3 that
                             contains the names and values of these
                             margins for 3*(n+1) iterations.
                             (n+1 because each PANDAOPT starts with
                             the 0th "local" iteration.)
                             CHOOSEPLOT will also generate a file
                             called *.PL5 which contains the 
                             3*(n+1) values of the objective.)

            DIPLOT          (You obtain the plots via routines
                             that use DISSPLA plotware. The three
                             files *.PL3, *.PL4, and *.PL5 are
                             input to DIPLOT.) (NOTE: in the UNIX
                             version DIPLOT (modified by Bill
                             Bushnell) produces a POSTSCRIPT file.
                             You do not need DISSPLA).

            CHOOSEPLOT      (You choose different design variables,
                             different margins (from the same or
                             from a different load set)

            DIPLOT          (You obtain plots, as before.)

    
 
All the analysis up to this point is for a single panel module. You
will want to check the accuracy of the general instability load factor
(eigenvalue) from the single-module analysis by comparing it with the
general instability load factor from a multi-module model that
represents the entire panel.  This you do by typing the commands PANEL,
BOSOR4LOG, BOSORALL, and BOSORPLOT, in that order.  PANEL is like
SETUP, except that it sets up an input data file, NAME.ALL, for a
multi-module panel. This file is a regular BOSOR4 input data file.  The
command BOSOR4LOG activates the BOSOR4 command set, and the command
BOSORALL initiates a batch run of the BOSOR4 pre-, main-, and
postprocessors.  BOSORPLOT gets plots of the discretized multi-module
panel and of buckling modes. Please note that the PANEL command should
be given only for cases in which there is only one load set.  In cases
involving multiple load sets, you must first run PANDAOPT in the
no-optimization mode for a selected single load set, then run PANEL. To
obtain plots for each of the load sets in the multiple set, you must
run PANDAOPT, PANEL, BOSOR4LOG, BOSORALL, BOSORPLOT, PLOT in that
sequence for each load set by itself. 

******** IMPORTANT WARNING *********** IMPORTANT WARNING **************
Please note that since BOSOR4 ignores in-plane shear loading in
obtaining buckling load factors, the results from PANEL will not agree
with those from PANDAOPT unless shear is absent. Also, the presence of
D16, D26 and other anisotropic terms in the constitutive matrix may be
large enough to cause discrepancies in the results of the BOSOR4 and
PANDA2 analyses.  To bring these results into agreement, you must use
the appropriate knockdown factors that are calculated in the PANDA2
system and provided in the NAME.OPM file. 
******** END IMPORTANT WARNING *********** END IMPORTANT WARNING ********


See Chapter XI for information about a new PANDA2 processor called
STAGSMODEL which, using output data from PANDA2, generates an input
file suitable for use with the STAGS [22,23] computer program. Also,
see Part XIII below for information on two additional PANDA2 processors,
AUTOCHANGE and SUPEROPT, very useful for obtaining GLOBAL optimum
designs. (See Ref. [15c] for details about AUTOCHANGE and SUPEROPT.
Also, see ITEMs 151, 152, 194 of PANDA2.NEWS.)


 SAMPLE RUNSTREAM WITH PANDA2...
 
            PANDA2LOG        (you activate PANDA2 commands. Please
                             note that you must insert the following
                             two statements in your LOGIN.COM:
                           $ASSIGN userdisk:[username.PANDA2] PANDA2
                           $PANDA2LOG :== @userdisk:[username.PANDA2]PANDA2

            BEGIN           (you establish a starting design)
            CHOOSETEMP      (you establish temperature dependence of
                             material properties.)
            SETUP           (an input file for BOSOR4 is set up)
            BOSMODEL        (BOSOR4-type discrete model of the
                             single panel module is set up)
            DECIDE          (you establish optimization parameters)
            MAINSETUP       (you set up PANDA2 analysis strategy, loads)
            PANDAOPT        (you launch batch run that performs
                             whatever analysis you called for
                             in MAINSETUP)
            PANDAOPT        (you do more iterations with same strategy)
            PANDAOPT        (you do more iterations with same strategy)
            CHOOSEPLOT      (you choose which variables to plot v. iterations)
            DIPLOT          (you get plots of selected variables v. iterat.)
            CHOOSEPLOT      (you choose other variables to plot v. iterations)
            DIPLOT          (you get plots of these other variables.)
            MAINSETUP       (call for "fixed design" with geometry plots)
            PANEL           (PANDA2 sets up an input file NAME.ALL for a
                             discretized multi-module panel. The entire
                             panel width and stringer parts are discretized.
                             This is a branched shell model. The effective
                             axial length of the panel is the distance
                             between adjacent rings. The NAME.ALL file is
                             an input file for BOSOR4.)
            BOSOR4LOG       (activate BOSOR4 command set)
            BOSORALL        (run BOSOR4 to get general buckling
                             of the multi-module panel)
            BOSORPLOT       (get multi-module panel plot file)
            PLOT            (get hard copy of plots from POPFIL.DAT file.)

*********************************************************************


III.  PANDA2 COMMANDS

---------------------------------------------------------------------
 PANDA2LOG
 
   This command activates the PANDA2 command set.  You must use it
   before you can work with PANDA2. It is advisable to use it
   also when you have just worked with BOSOR4 modules and you then wish
   to do more work with PANDA2.
 
  FORMAT:
           PANDA2LOG
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            PANDA2LOG        (you activate PANDA2 commands. VAX-VMS:Please
                             note that you must insert the following
                             four statements in your LOGIN.COM:
                           $ASSIGN userdisk:[username.PANDA2] PANDA2
                           $PANDA2LOG :== @userdisk:[username.PANDA2]PANDA2
                           $ASSIGN userdisk:[username.BOSOR4] BOSOR4
                           $BOSOR4LOG :== @userdisk:[username.BOSOR4]BOSOR4
                ----> NOTE:  For installation and initialization on UNIX-
                             based systems, please see the instructions
                             in the file ...panda2/doc/howto.update and
                             ...panda2/doc/customer.let and
                             ...panda2/doc/getting.started.
                             You must have BOSOR4 in order to use PANDA2!

            BEGIN            (you establish a starting design)
            CHOOSETEMP       (you establish temperature dependence of
                              material properties.)
            SETUP            (an input file for BOSOR4 is set up)
            BOSMODEL         (matrix templates for a panel module
                             are established for later buckling
                             analyses with PANDAOPT)
            MAINSETUP        (set up analysis strategy and loading to be
                             used by PANDAOPT)
            PANDAOPT         (perform PANDA2 analysis)



-------------------------------------------------------------------
BEGIN
 
   You provide, in a conversationally interactive mode, a starting
   design for the panel. The interactive input is saved on a file
   called NAME.BEG, in which NAME is a name of your choice.  In
   future runs of this or a similar case, you can edit the file
   NAME.BEG, then give the command BEGIN, and tell the system that
   you are using an existing file.  If you goof part way through a
   case, you can do a CONTROL Y, edit the NAME.BEG file, and
   re-issue the command BEGIN, telling the system that you are
   adding to an existing file.  The system will answer all the
   questions up to your goof in a "batch" mode, then return
   control to you. You can then complete the interactive input.
 
   Output from the PANDA2 preprocessor BEGIN is stored in a file
   with the name NAME.OPB. You should print this file and inspect
   it to make sure that the case is as you intend it to be.
 
  FORMAT:
           BEGIN
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            PANDA2LOG          (you activate PANDA2 commands)
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates for a panel module
                                are established for later buckling
                                analyses with PANDAOPT)
            MAINSETUP          (set up analysis strategy and loading to
                                be used by PANDAOPT)
            PANDAOPT           (perform PANDA2 analysis)


---------------------------------------------------------------------
 SETUP
 
   This command causes to be set up a file NAME.ALL suitable as 
   input for the BOSOR4 preprocessor to be activated by your
   subsequent command, BOSMODEL.  NAME must be the same name that
   you used in BEGIN.
 
  FORMAT:
 
            SETUP
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates for a panel module
                                are established for later buckling
                                analyses with PANDAOPT)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 analysis)


---------------------------------------------------------------------
 BOSMODEL
 
   NOTE: "BOSMODEL" is used only in the VAX-VMS version of PANDA2.
   This command causes BOSOR4-type templates of stiffness and
   load-geometric matrices to be set up, as well as arc length
   parameters and connectivities.
   NOTE: The command BOSMODEL does not exist in the UNIX version.
         In the UNIX version SETUP + BOSMODEL = SETUP.
 
  FORMAT:
           BOSMODEL
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates are established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 analysis)


----------------------------------------------------------------------
 DECIDE
 
   You provide, in a conversationally interactive mode, strategy
   parameters for PANDA2 optimization.  You choose which of
   the problem parameters are to be decision variables (allowed to
   change) during optimization and their lower and upper bounds.
   You also choose linked parameters, that is parameters that are
   not decision variables but vary in proportion to designated
   decision variables, and you assign factors of proportionality.
   You can also build up inequality constraints based on geometric
   parameters of the problem (See ITEM 29 in PANDA2.NEWS.)
   Finally, you choose "escape" variables, that is variables that
   should be increased during any design iteration in which CONMIN
   fails to change the design. You should choose only thicknesses
   as escape variables. (This can be done via a default option.)
 
   Your interactive input is saved on a file, NAME.DEC, in which
   NAME is the same name you used for BEGIN, SETUP, etc. In
   future runs of this or a similar case, you can edit the file
   NAME.DEC, then give the command DECIDE, and tell the system that
   you are using an existing file.  If you goof part way through a
   case, you can do a CONTROL Y, edit the NAME.DEC file, and
   re-issue the command DECIDE, telling the system that you are
   adding to an existing file.  The system will answer all the
   questions up to your goof in a "batch" mode, then return
   control to you. You can then complete the interactive input.
 
   Output from the PANDA2 processor DECIDE is stored in a file
   with the name NAME.OPD. You should print this file and inspect
   it to make sure that the case is as you intend it to be.
 
  FORMAT:
           DECIDE
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (BOSOR4-type discrete model set up)
            DECIDE             (optimization parameters established)
            MAINSETUP          (set up analysis strategy and loads to be
                                used by PANDAOPT)
            PANDAOPT           (perform PANDA2 optimization)


----------------------------------------------------------------------
 MAINSETUP
 
   You establish strategy parameters, loads, and imperfections
   for the PANDAOPT run to follow.

   Strategy parameters include:
 
       1. type of analysis  (simple buckling or optimization)
       2. do you want to vary the number of axial waves?
       3. factors of safety for buckling and stress
       4. how many design iterations do you want PANDAOPT to do?

   You provide up to 5 load sets. Each load set consists of two
   classes or sets of loads: 1. Load set A   and   2. Load set B.

       1. Load Set A:

          Loads which might be called "eigenvalue" loads. A
          buckling load factor determined by PANDA2, when multiplied
          by these loads, yields the predicted buckling load of the
          structure divided by the user-specified
          factor of safety for that type of buckling. Loads in this
          class are called "Load set A". Mathematically expressed,
          the loads in "Load set A" generate the "load-geometric"
          matrix K2 of the eigenvalue problem

          [ K1 + (eigenvalue*factor-of-safety)*K2 ](eigenvector) = 0

          in which K1 is the stiffness matrix.

       2. Load Set B:

          Loads which are merely parameters of the problem. These
          loads, termed "Load set B", are not multiplied by load
          factors (eigenvalues). Mathematically expressed, these
          loads contribute terms to the stiffness matrix K1 of
          the eigenvalue equation given above.

   Included in each of the up to 5 load sets are temperatures of each
   segment in the skin-stringer panel module and skin-ring panel module
   (thermal loading is always part of Load Set B, except as noted in
   ITEM 57 of PANDA2.NEWS, which concerns the truss-core sandwich
   configuration.), and local and general
   imperfections. The local imperfection is assumed to be in the form
   of the local buckling mode; the user provides an amplitude only.
   The global imperfection is assumed to be in the form of a half
   sine wave over the entire panel axial length.  Applied loads which
   can appear in either or both load sets A and B are the axial
   resultant, Nx, and hoop resultant, Ny. Applied loads which can only
   appear in Load set A are axial moment, Mx, and hoop moment, My, and
   in-plane shear resultant, Nxy.  Pressure, p, can appear in either
   Load set A or Load Set B, but not both. It is generally better to
   consider the pressure as part of Load Set A.

   An image of the interactive session in MAINSETUP is stored on
   a small file with the name NAME.OPT, which is listed at the
   beginning of the output file from PANDAOPT. (See PANDAOPT).

   ***** IMPORTANT NOTE ************ IMPORTANT NOTE *************
   Many of the input data required by MAINSETUP require a rather
   sophisticated knowledge of shell behavior. For these the user
   can obtain the default value simply by hitting "carriage return".
   If you are in doubt as to what your response to a particular
   prompt should be, just hit "return" and accept the value that
   PANDA2 provides.
   ****END IMPORTANT NOTE **********END IMPORTANT NOTE *************
   
 
  FORMAT:
           MAINSETUP
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (BOSOR4-type discrete model set up)
            DECIDE             (optimization parameters established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 optimization)

----------------------------------------------------------------------

 PANDAOPT
 
   This command initiates a batch run of the PANDA2 mainprocessor.
   The results are stored in files NAME.OPM and NAME.OPP, in which
   NAME is the same name you chose for BEGIN, SETUP, BOSMODEL, MAINSETUP...
   To do several sets of design iterations you issue the command
   PANDAOPT again and again. Make sure to inspect the files NAME.OPP and
   NAME.OPM after each batch run corresponding to each PANDAOPT.
   Only the latest NAME.OPM is retained. The file NAME.OPP accumulates
   results from an entire series of PANDAOPT batch runs. (See Part XIII
   on SUPEROPT for an automated series of PANDAOPTs with intermittant
   AUTOCHANGES, a PANDA2 facility that permits automated searches for
   global optimum designs. Details appear in Ref. [15c] and in ITEMS
   151, 152, 194 in the file ...panda2/doc/panda2.news.)
 
  FORMAT:
           PANDAOPT
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates for a panel module
                                are established for later buckling
                                analyses with PANDAOPT)
            MAINSETUP          (set up analysis strategy and loads to be
                                used by PANDAOPT)
            PANDAOPT           (perform PANDA2 analysis)
            PANDAOPT           (more PANDA2 analysis, same strategy)
            PANDAOPT           (more PANDA2 analysis, same strategy)
            CHOOSEPLOT         (you choose which variables to plot
                                v. design iterations since the
                                beginning of the case or since ITRTOT
                                was last set to zero.)
            DIPLOT             (you obtain plots of variables v. iterations)
---------------------------------------------------------------------

 CHOOSEPLOT

   This command allows you to choose, in an interactive mode,
   which design variables and which design margins to obtain
   plots of later via DIPLOT.  See more details in the PANDA2.HLP
   file or by typing HELPAN COMMANDS CHOOSEPLOT, HELPAN PROGRAMS CHPLOT,
   HELPAN LIBRARIES CHPLOT, HELPAN FILES GENERAL, PANDA2.NEWS

  FORMAT:
           CHOOSEPLOT
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates for a panel module
                                are established for later buckling
                                analyses with PANDAOPT)
            MAINSETUP          (set up analysis strategy and loads to be
                                used by PANDAOPT)
            PANDAOPT           (perform PANDA2 analysis)
            PANDAOPT           (more PANDA2 analysis, same strategy)
            PANDAOPT           (more PANDA2 analysis, same strategy)
            CHOOSEPLOT         (you choose which variables to plot
                                v. design iterations since the
                                beginning of the case or since ITRTOT
                                was last set to zero.)
            DIPLOT             (you obtain plots of variables v. iterations)
            CHOOSEPLOT         (you choose other variables to plot.)
            DIPLOT             (you obtain plots of other variables.)
            CHOOSEPLOT         (you choose yet more variables to plot.)
            DIPLOT             (you obtain plot of the yet more variables.)
---------------------------------------------------------------------

 DIPLOT

   This command leads to a file from which hard copies of plots or
   plots on your screen can be obtained.  DIPLOT was originally
   written by Karen Neier of Lockheed and modified by Bushnell for
   use with PANDA2.  It uses DISSPLA plotware. See the PANDA2.HLP
   file for more details, or type HELPAN FILES GENERAL,
   HELPAN COMMANDS DIPLOT, HELPAN PROGRAMS DIPLOT, HELPAN LIBRARIES
   DIPLOT, HELPAN OVERVIEW HOWTORUN

   NOTE: In the UNIX version DIPLOT, modified by Bill Bushnell,
         creates a POSTSCRIPT file.  You do not need DISSPLA.

  FORMAT:
           DIPLOT
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates for a panel module
                                are established for later buckling
                                analyses with PANDAOPT)
            MAINSETUP          (set up analysis strategy and loads to be
                                used by PANDAOPT)
            PANDAOPT           (perform PANDA2 analysis)
            PANDAOPT           (more PANDA2 analysis, same strategy)
            PANDAOPT           (more PANDA2 analysis, same strategy)
            CHOOSEPLOT         (you choose which variables to plot
                                v. design iterations since the
                                beginning of the case or since ITRTOT
                                was last set to zero.)
            DIPLOT             (you obtain plots of variables v. iterations)
            CHOOSEPLOT         (you choose other variables to plot.)
            DIPLOT             (you obtain plots of other variables.)
            CHOOSEPLOT         (you choose yet more variables to plot.)
            DIPLOT             (you obtain plot of the yet more variables.)
---------------------------------------------------------------------

     CHOOSETEMP                 (26 JAN 1989-21 April 1989 ENHANCEMENT)
 
       You choose which material properties are temperature-dependent
       and provide input "tables" of property v. temperature for each
       property that you have chosen as being temperature-dependent.
 
       The results of your interactive session are saved on a file
       called NAME.CPT, which plays a role analogous to the input
       files NAME.BEG, NAME.DEC, NAME.OPT, NAME.CHG, for BEGIN,
       DECIDE, MAINSETUP, and CHANGE, respectively.
 
       Output from CHOOSETEMP appear in a file called NAME.OPTEMP,
       which you should inspect carefully before proceeding with your
       case.
 
      FORMAT:
               CHOOSETEMP
 
      EXAMPLE OF USE IN A RUNSTREAM:
 
                BEGIN              (you establish a starting design.)
                CHOOSETEMP         (you establish matl prop. temperature
                                    dependence.)
                DECIDE             (you choose decision variables, etc.)
                MAINSETUP          (you set up analysis strategy.)
                PANDAOPT           (batch run for the specific case.)
------------------------------------------------------------------------

 PANEL
 
   This command is used to find the general instability buckling
   load of a full-size panel built up of the panel modules such
   as the single panel module used in the PANDA2 optimization
   analysis. In this way the accuracy of the single module
   analysis is checked, at least with regard to general instabil-
   ity, which is more in doubt than is that for the local buckling
   analysis. (You can also check local buckling by choosing an
   appropriate value for the number of axial halfwaves.)
 
   PANEL sets up a file NAME.ALL, which is subsequently used as
   input to the BOSOR4 buckling analysis of the multi-module
   panel that you initiate by subsequently typing the commands
   BOSOR4LOG, BOSORALL, and BOSORPLOT.
 
   Note that the PANEL command should be given only for cases in
   which there is only one load set.  In cases involving multiple
   load sets, you must first run PANDAOPT in the no-optimization
   mode for a selected single load set, then run PANEL. To obtain
   plots for each of the load sets in the multiple set, you must
   run PANDAOPT, PANEL, BOSOR4LOG, BOSORALL, BOSORPLOT, PLOT
   in that sequence for each load set by itself.

   ******** IMPORTANT NOTE ************* IMPORTANT NOTE ************
   Please note that
   since BOSOR4 ignores in-plane shear loading in obtaining buckling
   load factors, the results from PANEL will not agree with
   those from PANDAOPT unless shear is absent. Also, the presence
   of D16, D26 and other anisotropic terms in the constitutive
   matrix may be large enough to cause discrepancies in the results
   of the BOSOR4 and PANDA2 analyses.  To bring these results into
   agreement, you must use the appropriate knockdown factors that
   are calculated in the PANDA2 system and provided in the NAME.OPM
   file. Also, before using PANEL/BOSORALL, run PANDA2 in the analysis
   type 2 (ITYPE = 2) mode with a single load case and subcase.
   ******END IMPORTANT NOTE ***********END IMPORTANT NOTE ************


  FORMAT:
            PANEL
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (BOSOR4-type discrete model of the
                                single panel module is set up)
            DECIDE             (optimization parameters established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 optimization of the
                                single panel module)
            PANEL              (input file for multi-module panel is
                                setup. This is input to BOSOR4)
            BOSOR4LOG          (activate BOSOR4 commands)
            BOSORALL           (run BOSOR4 to get general buckling
                                of the multi-module panel)
            BOSORPLOT          (get multi-module panel plot file)
            PLOT               (get hard copy of plots from POPFIL.DAT)
            DELETE POPFIL.DAT;*

----------------------------------------------------------------------

 PANEL2  - This command is analogous to PANEL, except that it sets up
           a multi-module BOSOR4 model of a ring-stiffened cylindrical shell, 
           whereas PANEL sets up a BOSOR4 model for a multi-module
           skin-stringer model. See ITEM 463 in ...panda2/doc/panda2.news
----------------------------------------------------------------------

 BOSOR4LOG
 
   This command activates the BOSOR4 command set. You need to use
   it after PANEL in order to get general instability of the entire
   panel width with every module treated as a multi-branched structure. 

  FORMAT:
               BOSOR4LOG
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            PANDAOPT           (perform PANDA2 analysis)
            PANEL              (input file for multi-module panel is
                                setup. This is input to BOSOR4)
            BOSOR4LOG          (activate BOSOR4 commands)
            BOSORALL           (run BOSOR4 to get general buckling
                                of the multi-module panel)
            BOSORPLOT          (get multi-module panel plot file)


---------------------------------------------------------------------

 BOSORPLOT
 
   Initiates batch run to set up BOSOR4 plot files.
 
  FORMAT:
               BOSORPLOT
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            PANDAOPT           (perform PANDA2 analysis)
            PANEL              (input file for multi-module panel is
                                setup. This is input to BOSOR4)
            BOSOR4LOG          (activate BOSOR4 commands)
            BOSORALL           (run BOSOR4 to get general buckling
                                of the multi-module panel)
            BOSORPLOT          (get multi-module panel plot file)
 

   On UNIX-based systems you get plots simply by printing the
   file called "metafile.ps" generated by BOSORPLOT on a laser
   printer with POSTSCRIPT capability.
-----------------------------------------------------------------------

PLOT
 
   NOTE: VAX-VMS only. (Even that doesn't work anymore).

   This command is used to produce hard copies of plots at
   Lockheed Palo Alto Research Laboratories. You must have
   a file called POPFIL.DAT before you give this command
   or whatever the equivalent command is at your facility.

   On UNIX-based systems you get plots simply by printing the
   file called "metafile.ps" generated by BOSORPLOT on a laser
   printer with POSTSCRIPT capability.
 
 FORMAT:
               PLOT
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            PANDAOPT           (perform PANDA2 analysis)
            PANEL              (input file for multi-module panel is
                                setup. This is input to BOSOR4)
            BOSOR4LOG          (activate BOSOR4 commands)
            BOSORALL           (run BOSOR4 to get general buckling
                                of the multi-module panel)
            BOSORPLOT          (get multi-module panel plot file)
            PLOT               (obtain hard copies from POPFIL.DAT file)

-----------------------------------------------------------------------

 BOSORALL
 
   A batch run of the three BOSOR4 processors (pre, main, post) is
   initated for calculation of general instability of the multi-
   module panel.  Output is stored in a file NAME.OUT;3 if the run
   terminated successfully. See the BOSOR4 help file for more
   details in case of unsuccessful termination. (To see the BOSOR4
   help file, type the commands BOSOR4LOG, HELP4 COMMAND BOSORALL).
 
  FORMAT:
            BOSORALL
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (BOSOR4-type discrete model of the
                                single panel module is set up)
            DECIDE             (optimization parameters established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 optimization of the
                                single panel module)
            PANEL              (input file for multi-module panel is
                                setup. This is input to BOSOR4)
            BOSOR4LOG          (activate BOSOR4 commands)
            BOSORALL           (run BOSOR4 to get general buckling
                                of the multi-module panel)
            BOSORPLOT          (get multi-module panel plot file)



--------------------------------------------------------------------

 CHANGE
 
  You use the CHANGE command to change parameters without having to
  go back to BEGIN.  The parameters are segregated into three
  groups:
           1. parameters eligible to be decision variables;
           2. parameters not eligible to be decision variables;
           3. allowables (for example, max. strain)
 
   Your interactive input is saved on a file, NAME.CHG, in which
   NAME is the same name you used for BEGIN, SETUP, etc. In
   future runs of this or a similar case, you can edit the file
   NAME.CHG, then give the command CHANGE, and tell the system that
   you are using an existing file.  If you goof part way through a
   case, you can do a CONTROL Y, edit the NAME.CHG file, and
   re-issue the command CHANGE, telling the system that you are
   adding to an existing file.  The system will answer all the
   questions up to your goof in a "batch" mode, then return
   control to you. You can then complete the interactive input.
 
  FORMAT:
           CHANGE
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            CHOOSETEMP         (you establish temperature dependence)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (BOSOR4-type discrete model set up)
            DECIDE             (optimization parameters established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 optimization)
            CHANGE             (change some parameters)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (BOSOR4-type discrete model set up)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 optimization for
                                modified panel module)


----------------------------------------------------------------------

 STAGSMODEL
 
   This command causes files called NAME.inp and NAME.bin to be generated.
   These files can be used directly as input for the
   STAGS computer program [22, 23].  See Chapter XI. here and the file
   panda2.tex for more details.

   STAGSMODEL sets up STAGS input files, *.inp and *.bin, only for panels
   and cylindrical shells with stringers (or unstiffened). Rings are not 
   allowed.
 
  FORMAT:
           STAGSMODEL
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates are established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            PANDAOPT           (perform PANDA2 analysis)
            STAGSMODEL         (you provide some data interactively.
                                These data, plus data from the PANDA2
                                database, cause an input file, NAME.INP,
                                for the STAGS computer program to be
                                created.)
            (Run STAGS).
----------------------------------------------------------------------

 STAGSUNIT

   Same as STAGSMODEL, except both rings and stringers are allowed,
   or either rings or stringers, or unstiffened. See panda2.tex for
   more details. STAGSUNIT sets up STAGS input files, *.inp and *.bin,
   The *.inp file is based on multiple shell units rather than a single
   finite element unit, which is the case for STAGSMODEL. See [15h]
   for more details:
   [15h] David Bushnell and Charles C. Rankin, Optimization of perfect and
    imperfect ring and stringer stiffened cylindrical shells with PANDA2 and
    evaluation of optimum designs with STAGS, AIAA 43rd SDM Meeting, April
    2002, AIAA Paper 2002-1408

------------------------------------------------------------------------

 SUPEROPT
  
   This command is used, possibly repeatedly, to search for a global
   optimum design. Please see Ref. [15c] in the section entitled
   "PANDA2 Documentation" and PANDA2.NEWS ITEMS 151 and 152 for details.
 
  FORMAT:
           SUPEROPT
 
  EXAMPLE OF USE IN A RUNSTREAM:
 
            BEGIN              (you establish a starting design)
            SETUP              (an input file for BOSOR4 is set up)
            BOSMODEL           (matrix templates are established)
            MAINSETUP          (set up PANDA2 analysis strategy, loads)
            SUPEROPT           (performs several sets of
                                PANDAOPT,PANDAOPT,PANDAOPT.../AUTOCHANGE)
--------------------------------------------------------------------------

 CLEANPAN
 
   All files with the name NAME.* are deleted except
   NAME.BEG, NAME.DEC, NAME.OPT, NAME.CHG and  NAME.CPL
 

------------------------------------------------------------------


*********************************************************************

IV.   PANDA2 FILES

GENERAL INFORMATION ON FILES....
 
   Runs of PANDA2 generate many files. Most of these files have
   a name such as NAME.BEG  or  NAME.DEC,  etc., in which
   NAME is a name that you assign the case.  The most important
   of these files from the user's viewpoint are:
 
   NAME.BEG    NAME.DEC    NAME.OPT    NAME.OPM     NAME.OPP


 SUMMARY TABLE CONTAINING INFORMATION ABOUT FILES IN PANDA2....


     PANDA2 PROCESSORS, INPUT/OUTPUT FILES, AND "OPEN" STATEMENTS


                    PART 1: PANDA2 PROCESSORS
==========================================================================
PANDA2          PANDA2         MAIN PROGRAM IN
COMMAND       PROCESS NAME     SOURCE LIBRARY:    PURPOSE OF PROCESS
--------------------------------------------------------------------------
begin     :==@panda2:begin       BEGIN.NEW      provide starting design
setup     :==@panda2:setup       SETUP.NEW      set up BOSOR4 templates
bosmodel  :==@panda2:bosmodel    B4READ.NEW     set up BOSOR4 templates
                                 GLOBST.NEW     set up BOSOR4 templates
decide    :==@panda2:decide      DECIDE.NEW     choose decision variables
mainsetup :==@panda2:mainsetup   MAINSETUP.NEW  input for mainprocessor
pandaopt  :==@panda2:pandaopt    MAIN.NEW       mainprocessor run
                                 STORE.NEW      store mainprocessor results
change    :==@panda2:change      CHANGE.NEW     change values of variables
choosetemp:==@panda2:choosetemp  CHTEMP.NEW     temperature dependent mat'l
chooseplot:==@panda2:chooseplot  CHPLOT.NEW     choose what to plot
diplot    :==@panda2:diplot      DIPLOT.NEW     generate DISSPLA plot files
panel     :==@panda2:panel       BOSPAN.NEW     panel model for BOSOR4
cleanpan  :==@panda2:cleanpan     none          delete unwanted case files
helpan    :==$panda2:helpan.exe  HELPAN.NEW     interactive HELP
superopt                                        global optimization
stagsmodel                                      set up STAGS input files
stagsunit                                       set up STAGS input files
==========================================================================



      PART 2: INPUT AND OUTPUT FILES FOR THE PANDA2 PROCESSORS
=========================================================================
NOTES:  In the following,
         (1) "NAME" represents a user-provided name for the case.
         (2)   "*"  denotes a file that the PANDA2 user must deal with.
-------------------------------------------------------------------------
FILES ASSOCIATED WITH "BEGIN":

  INPUT:
     Interactive input from terminal.

*    NAME.BEG = Summary of interactive session you have just
                completed or are currently working on.
     PROMPT.DAT=Prompt file for interactive input for PANDA2.
     TUTORBEG.DAT=Text file for tutorial option.

  OUTPUT:
     NAME.NAM = This file contains only the name of the case.
*    NAME.BEG = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of BEGIN.
     NAME.DAT = The same or similar to NAME.BEG. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
                (This is an unformatted sequential file.)
*    NAME.OPB = Output from BEGIN. Please list this file and
                inspect it and the NAME.BEG file carefully before
                proceeding.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "SETUP":

  INPUT:
     NAME.NAM = This file contains only the name of the case.

  OUTPUT:
     NAME.ALL = Input data for BOSOR4-type of preprocessor
                for single panel module (abridged version).
                correponding to discretized single panel module.
     NAME.BOS = Input data for BOSOR4-type of preprocessor.
                correponding to discretized entire panel with
                smeared stiffeners.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "BOSMODEL":

  INPUT:
     BOSOR4:PROMPT.DAT = Prompt file for BOSOR4
     BOSOR4:PROMPT2.DAT= Prompt file for BOSOR4
     BOSOR4:PROMPT3.DAT= Prompt file for BOSOR4

     NAME.NAM = This file contains only the name of the case.
     NAME.ALL = Input data for BOSOR4-type of preprocessor
                for single panel module (abridged version).
                correponding to discretized single panel module.
     NAME.BOS = Input data for BOSOR4-type of preprocessor.
                correponding to discretized entire panel with
                smeared stiffeners.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.

  OUTPUT:
     NAME.DOC = Input data for BOSOR4-type of preprocessor
                correponding to discretized single panel module
                (fully annotated version).
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.BL1 = Labelled common blocks for BOSOR4-type discretized
                model of single panel module.
                (This is an unformatted sequential file.)
     NAME.BL2 = Labelled common blocks for BOSOR4-type discretized
                model of entire panel with smeared stiffeners.
                (This is an unformatted sequential file.)')
     NAME.RN1 = Direct access file for data base pertaining to
                BOSOR4-type discretized model of single module.
                (This is an unformatted direct access file.)
     NAME.RN2 = Direct access file for data base pertaining to
                BOSOR4-type discretized model of entire panel
                with smeared stiffeners.
                (This is an unformatted direct access file.)
     NAME.ERR = List output (SCRATCH file).

------------------------------------------------------------------------
FILES ASSOCIATED WITH "DECIDE":

  INPUT:

     Interactive input from terminal.

     NAME.NAM = This file contains only the name of the case.
*    NAME.DEC = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     PROMPT.DAT=Prompt file for interactive input for PANDA2.
     TUTORDEC.DAT=Text file for tutorial option.

  OUTPUT:
*    NAME.DEC = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of DECIDE.
     NAME.DAT = The same or similar to NAME.DEC. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
*    NAME.OPD = Output from DECIDE. Please list this file and
                inspect it and the NAME.DEC file carefully before
                proceeding.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "MAINSETUP":

  INPUT:
     Interactive input from terminal.

     PROMPT.DAT=Prompt file for interactive input for PANDA2.
     NAME.NAM = This file contains only the name of the case.
*    NAME.OPT = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.

  OUTPUT:
*    NAME.OPT = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of MAINSETUP.
     NAME.DAT = The same or similar to NAME.OPT. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
------------------------------------------------------------------------
FILES ASSOCIATED WITH "PANDAOPT":

 (A) THE MAINPROCESSOR, "MAIN":
  INPUT:
     PROMPT.DAT    = Prompt file for interactive input for PANDA2.
     TUTORMAIN.DAT = File containing rather detailed explanations
                     of theories on which PANDA2 is based. Used when
                     the mainprocessor is executed in tutorial mode.

     NAME.NAM = This file contains only the name of the case.
*    NAME.OPT = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.BL1 = Labelled common blocks for single module discretized model.
     NAME.RN1 = Direct access data base for single module discretized model.
     NAME.BL2 = Labelled common blocks for smeared stringer discretized model.
     NAME.RN2 = Direct access data base for smeared stringer discretized model.

  OUTPUT:
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
*    NAME.OPM = Results from mainprocessor for any value of ITYPE.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.BL1 = Labelled common blocks for single module discretized model.
     NAME.RN1 = Direct access data base for single module discretized model.
     NAME.BL2 = Labelled common blocks for smeared stringer discretized model.
     NAME.RN2 = Direct access data base for smeared stringer discretized model.
     NAME.003 = Scratch file similar to the .OPT file.
     NAME.PL1 = Binary file (ITYPE.NE.3) with results for plots
     NAME.SL1 = Binary file (ITYPE.EQ.3) with results for plots


 (B) THE MAINPROCESSOR, "STORE":
  INPUT:
     NAME.NAM = This file contains only the name of the case.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.PL1 = Binary file (ITYPE.NE.3) with results for plots
     NAME.SL1 = Binary file (ITYPE.EQ.3) with results for plots

  OUTPUT:
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
*    NAME.OPP = Design variables, margins, objective v. iterations (ITYPE=1)
*    NAME.OPI = State of the panel v. load steps (ITYPE=3)
     NAME.PL2 = Binary file containing important results for plots
                from all design iterations including those corres-
                ponding to the final PANDAOPT command.
     NAME.PLD = Binary file containing all design parameters that
                are decision variable candidates and the objective
                function for all design iterations.
     NAME.TIT = Binary file containing definitions of margins (ITYPE=1).
     NAME.TTT = File that contains the definitions of the margins (ITYPE=3).
     NAME.Pij = Binary files containing margins for all design iterations
                 i = subcase (1 and 2);  j = load set 1 thru 5; (ITYPE=1)
     NAME.Lij = Binary files containing various behaviors and
                 all margins for all load steps in (i,j), with
                 i = subcase (1 and 2);  j = load set 1 thru 5; (ITYPE=3)

------------------------------------------------------------------------
FILES ASSOCIATED WITH "CHANGE":

  INPUT:

     Interactive input from terminal.

     NAME.NAM = This file contains only the name of the case.
*    NAME.CHG = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     PROMPT.DAT=Prompt file for interactive input for PANDA2.

  OUTPUT:
*    NAME.CHG = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of CHANGE.
     NAME.DAT = The same or similar to NAME.CHG. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
*    NAME.OPC = Output from CHANGE. Please list this file and
                inspect it and the NAME.CHG file carefully before
                proceeding.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "CHOOSETEMP":

  INPUT:

     Interactive input from terminal.

     NAME.NAM = This file contains only the name of the case.
*    NAME.CPT = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     PROMPT.DAT=Prompt file for interactive input for PANDA2.

  OUTPUT:
*    NAME.CPT = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of CHANGE.
     NAME.DAT = The same or similar to NAME.CPT. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
*    NAME.OPTEMP = Output from CHOOSETEMP. Please list this file and
                   inspect it and the NAME.CPT file carefully before
                   proceeding.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "CHOOSEPLOT":

  INPUT:

     Interactive input from terminal.

     NAME.NAM = This file contains only the name of the case.
*    NAME.CPL = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.TIT = Binary file containing definitions of margins (ITYPE=1).
     NAME.TTT = File that contains the definitions of the margins (ITYPE=3).
     NAME.Pij = Binary files containing margins for all design iterations
                 i = subcase (1 and 2);  j = load set 1 thru 5; (ITYPE=1)
     NAME.Lij = Binary files containing various behaviors and
                 all margins for all load steps in (i,j), with
                 i = subcase (1 and 2);  j = load set 1 thru 5; (ITYPE=3)
     PROMPT.DAT=Prompt file for interactive input for PANDA2.

  OUTPUT:
*    NAME.CPL = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of CHOOSEPLOT.
     NAME.DAT = The same or similar to NAME.CPL. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
*    NAME.OPL = Output from CHOOSEPLOT. Please list this file and
                inspect it and the NAME.CPL file carefully before
                proceeding.
     NAME.PL3 = File for margin plots via DIPLOT (ITYPE=1 or 3)
     NAME.PL4 = File for design variable/behavior plots via DIPLOT (ITYPE=1,3)
     NAME.PL5 = File for objective plot (ITYPE=1) or undeformed
                and deformed panel module (ITYPE=3) via DIPLOT
     NAME.PL6 = File for plot of layup of skin-stringer module (ITYPE=3).
     NAME.PL7 = File for "3-D" plot of locally post-buckled panel module.
                (ITYPE=3).
     NAME.PL8 = File for plot of AXIAL or +45deg. extreme fiber strains
                v. a selected load component (ITYPE=3).
     NAME.PL9 = File for plot of HOOP or -45deg. extreme fiber strains
                v. a selected load component (ITYPE=3).
     NAME.PL10= File for plot of SHEAR strains at 0 deg. or 45 deg.
                v. a selected load component (ITYPE=3).


------------------------------------------------------------------------
FILES ASSOCIATED WITH "DIPLOT":

  INPUT:

     Interactive input from terminal.

     NAME.NAM = This file contains only the name of the case.
     NAME.DIP = Summary of interactive session you have just
                completed or are currently working on.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.PL3 = File for margin plots via DIPLOT (ITYPE=1 or 3)
     NAME.PL4 = File for design variable/behavior plots via DIPLOT (ITYPE=1,3)
     NAME.PL5 = File for objective plot (ITYPE=1) or undeformed
                and deformed panel module (ITYPE=3) via DIPLOT
     NAME.PL6 = File for plot of layup of skin-stringer module (ITYPE=3).
     NAME.PL7 = File for "3-D" plot of locally post-buckled panel module.
                (ITYPE=3).
     NAME.PL8 = File for plot of AXIAL or +45deg. extreme fiber strains
                v. a selected load component (ITYPE=3).
     NAME.PL9 = File for plot of HOOP or -45deg. extreme fiber strains
                v. a selected load component (ITYPE=3).
     NAME.PL10= File for plot of SHEAR strains at 0 deg. or 45 deg.
                v. a selected load component (ITYPE=3).
     PROMPT.DAT=Prompt file for interactive input for PANDA2.

  OUTPUT:
     NAME.DIP = Summary of interactive session you have just
                completed. This file can be edited and used for
                future runs of DIPLOT.
     NAME.DAT = The same or similar to NAME.DIP. Has proper annotation.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.ODI = List output from DIPLOT
     FOR033.DAT=Plot file for plotting on QMS laser printer.      
------------------------------------------------------------------------
FILES ASSOCIATED WITH "PANEL":

  INPUT:

     Interactive input from terminal.

     NAME.PAN = Image of interactive "PANEL" session.
     NAME.NAM = This file contains only the name of the case.
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     PROMPT.DAT=Prompt file for interactive input for PANDA2.

  OUTPUT:
     NAME.SET = Summary of interactive session you have just completed
                (SCRATCH file, not saved).
     NAME.CBL = Labelled common blocks for PANDA2 analysis.
     NAME.ALL = file suitable as input for BOSOR4.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "PANEL2":

  INPUT:

     Interactive input from terminal.

     NAME.PAN = Image of interactive "PANEL2" session.

------------------------------------------------------------------------
FILES ASSOCIATED WITH "SUPEROPT":

  INPUT:

     NAME.OPT = Image of interactive "MAINSETUP" session.

  OUTPUT:

     NAME.OPP 

-----------------------------------------------------------------------
FILES ASSOCIATED WITH "STAGSMODEL":

  INPUT:

     NAME.STG

  OUTPUT:

     NAME.inp, NAME.bin  (input files for STAGS)

-----------------------------------------------------------------------
FILES ASSOCIATED WITH "STAGSUNIT":

   INPUT

     NAME.STG

   OUTPUT

     NAME.inp, NAME.bin (input files for STAGS)

-----------------------------------------------------------------------
FILES ASSOCIATED WITH "HELPAN":

  INPUT:
*    PANDA2.HLP = text for interactive PANDA2 "help".

  OUTPUT:
     NONE
=======================================================================


     PART 3:  "OPEN" STATEMENTS IN THE VARIOUS PANDA2 PROCESSORS
               (VAX-VMS version)
=======================================================================
"OPEN" STATEMENTS IN PROMPTER.NEW  (PROMPTER.NEW is used in BEGIN,
                                    DECIDE, MAINSETUP, PANDAOPT, CHANGE,
                                    CHOOSETEMP,CHOOSEPLOT,DIPLOT,PANEL)

      SUBROUTINE REREAD(IOUT,IFILE3,INFILE,VNAME,LINE,CASE,IOUTFL)
      CASE2=CASE//'.010'
      OPEN(UNIT=10,FILE=CASE2,STATUS='SCRATCH')
   EITHER THIS:
      IOUT = 27
      INFILE = 5                                    NOTE:
      OPEN(UNIT=IOUT,FILE=VNAME,STATUS='UNKNOWN')    VNAME = CASE//'.XXX',
   OR THIS:                                          in which XXX is BEG,
      INFILE = 26                                    DEC, OPT, CHG, CPT,
      OPEN(UNIT=INFILE,FILE=VNAME,STATUS='UNKNOWN')  CPL, DIP
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN BEGIN.NEW:

      PROGRAM BEGIN
      CASE2=CASE//'.OPB'
      CASE3=CASE//'.CBL'
      CASE4=CASE//'.NAM'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=4,FILE='PANDA2:TUTORBEG.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE2,STATUS='UNKNOWN')
      OPEN(UNIT=9,FILE=CASE4,STATUS='UNKNOWN')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN SETUP.NEW:

      PROGRAM SETUP
      CASE2=CASE//'.ALL'
      CASE3=CASE//'.CBL'
      CASE4=CASE//'.BOS'
      CASE5=CASE//'.SET'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=14,FILE=CASE2,STATUS='UNKNOWN')
      OPEN(UNIT=1,FILE=CASE4,STATUS='UNKNOWN')
      OPEN(UNIT=3,FILE=CASE5,STATUS='SCRATCH')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN B4READ.NEW:

      PROGRAM B4READ
      OPEN(UNIT=12,STATUS='OLD')
      CALL CASNAM(IUNAME,CASE)
      CLOSE(IUNAME)

      SUBROUTINE READIT
      CASE2=CASE//'.ERR'
      CASE3=CASE//'.OUT'
      CASE4=CASE//'.DOC'
      OPEN(UNIT=2,FILE='BOSOR4:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=4,FILE='BOSOR4:PROMPT2.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=7,FILE='BOSOR4:PROMPT3.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE4,STATUS='SCRATCH')
      OPEN(UNIT=6,FILE=CASE2,STATUS='SCRATCH')
      OPEN(UNIT=8,FILE=CASE3,STATUS='SCRATCH')

File assignment statements in procedure BOSORREAD.BAT:
    $ ASSIGN 'P3'.NAM FOR012
    $ ASSIGN 'P3'.ALL FOR005
    $ ASSIGN 'P3'.BL1 FOR009
    $ ASSIGN 'P3'.RN1 FOR011
    $ RUN PANDA2:BOSORREAD
    $ ASSIGN 'P3'.BOS FOR005
    $ ASSIGN 'P3'.BL2 FOR009
    $ ASSIGN 'P3'.RN2 FOR011
    $ RUN PANDA2:BOSORREAD
    $ RUN PANDA2:GLOBST
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN GLOBST.NEW:

      PROGRAM GLOBST
      OPEN(UNIT=12,STATUS='OLD')
      CALL CASNAM(IUNAME,CASE)
      CLOSE(IUNAME)

      CASE2=CASE//'.ERR
      CASE3=CASE//'.CBL'
      OPEN(UNIT=6,FILE=CASE2,STATUS='SCRATCH')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN DECIDE.NEW:

      PROGRAM DECIDE
      CASE2=CASE//'.OPD'
      CASE3=CASE//'.CBL'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=4,FILE='PANDA2:TUTORDEC.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE2,STATUS='UNKNOWN')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN MAINSETUP.NEW:

      PROGRAM MAINS
      CASE2=CASE//'.OPM'
      CASE3=CASE//'.CBL'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE2,STATUS='UNKNOWN')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN MAIN.NEW:

      PROGRAM MAIN
      OPEN(UNIT=12,STATUS='OLD')
      CALL CASNAM(IUNAME,CASE)
      CLOSE(IUNAME)

      CASE2=CASE//'.OPM'
      CASE3=CASE//'.CBL'
      CASE4=CASE//'.003'
      CASE5=CASE//'.OPT'
      CASE6=CASE//'.OUT'
      CASE7=CASE//'.BL1'
      CASE8=CASE//'.BL2'
      CASE9=CASE//'.000'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=4,FILE='PANDA2:TUTORMAIN.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE4,STATUS='SCRATCH')
      OPEN(UNIT=5,FILE=CASE5,STATUS='UNKNOWN')
      OPEN(UNIT=6,FILE=CASE6,STATUS='SCRATCH')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=9,FILE=CASE7,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=1,FILE=CASE8,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE2,STATUS='UNKNOWN')

      IF (ITYPE.NE.3) CASE13=CASE//'.PL1'
      IF (ITYPE.EQ.3) CASE13=CASE//'.SL1'
      OPEN(UNIT=13,FILE=CASE13,STATUS='UNKNOWN',FORM='UNFORMATTED')

File assignment statements in procedure PANDAOPT:
    $ ASSIGN 'P3'.NAM FOR012
    $ ASSIGN 'P3'.RN1 FOR011
    $ ASSIGN 'P3'.RN2 FOR010
    $ RUN PANDA2:MAIN
    $ ASSIGN 'P3'.NAM FOR010
    $ RUN PANDA2:STORE
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN STORE.NEW:

      PROGRAM STORE
      OPEN(UNIT=10,STATUS='OLD')
      CALL CASNAM(IUNAME,CASE)
      CLOSE(IUNAME)

      CASE7=CASE//'.CBL'
      OPEN(UNIT=7,FILE=CASE7,STATUS='UNKNOWN',FORM='UNFORMATTED')

      SUBROUTINE STORE1(CASE)
      CASE8 =CASE//'.OPP'
      CASE9=CASE//'.PL1'
      CASE2=CASE//'.PL2'
      CASE3=CASE//'.PLD'
      CASE4=CASE//'.TIT'
      OPEN(UNIT=8, FILE=CASE8, STATUS='UNKNOWN')
      OPEN(UNIT=9,FILE=CASE9,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=2,FILE=CASE2,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=3,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=4,FILE=CASE4,STATUS='UNKNOWN',FORM='UNFORMATTED')

      IUNIT = 10*ICASES + ILOADS
      INQUIRE(UNIT=IUNIT,OPENED=YEAH)
      IF (.NOT.YEAH)
     1    OPEN(UNIT=IUNIT,STATUS='SCRATCH',FORM='UNFORMATTED')

      CASEU = CASE//'.P'//CICASE//CILOAD
      INQUIRE(UNIT=IUNIT,OPENED=YEAH)
      IF (.NOT.YEAH)
     1 OPEN(UNIT=IUNIT,FILE=CASEU,STATUS='UNKNOWN',FORM='UNFORMATTED')

      SUBROUTINE STORE2(CASE)
      CASE4=CASE//'.TTT' 
      CASE8=CASE//'.OPI'
      CASE9=CASE//'.SL1'
      CASE7=CASE//'.CBL'
      CASE17=CASE//'.PLD'
      OPEN(UNIT=8, FILE=CASE8, STATUS='UNKNOWN')
      OPEN(UNIT=4,FILE=CASE4,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=9,FILE=CASE9,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=17,FILE=CASE17,STATUS='UNKNOWN',FORM='UNFORMATTED')

      IUNIT = 10*ICASE + ILOAD
      CASEU = CASE//'.L'//CICASE//CILOAD
      OPEN(UNIT=IUNIT,FILE=CASEU,STATUS='UNKNOWN',FORM='UNFORMATTED')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN CHANGE.NEW:

      PROGRAM CHANGE
      CASE2=CASE//'.OPC'
      CASE3=CASE//'.CBL'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE2,STATUS='UNKNOWN')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN CHTEMP.NEW:

      PROGRAM CHTEMP
      CASE8=CASE//'.OPTEMP'
      CASE7=CASE//'.CBL'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE7,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE8,STATUS='UNKNOWN')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN CHPLOT.NEW:

      PROGRAM CHPLOT
      CASE8=CASE//'.OPL'
      CASE7=CASE//'.CBL'
      CASE2=CASE//'.PLD'
      CASE3=CASE//'.PL3'
      CASE4=CASE//'.PL4'
      CASE5=CASE//'.PL5'
      CASE6=CASE//'.PL6'
      CASE17=CASE//'.PL7'
      CASE18=CASE//'.PL8'
      CASE19=CASE//'.PL9'
      CASE20=CASE//'.PL10'
      OPEN(UNIT=1,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=53,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=2,FILE=CASE2,STATUS='OLD',FORM='UNFORMATTED',READONLY)
      OPEN(UNIT=3,FILE=CASE3,STATUS='UNKNOWN')
      OPEN(UNIT=4,FILE=CASE4,STATUS='UNKNOWN')
      OPEN(UNIT=9,FILE=CASE5,STATUS='UNKNOWN')
      OPEN(UNIT=29,FILE=CASE6,STATUS='UNKNOWN')
      OPEN(UNIT=17,FILE=CASE17,STATUS='UNKNOWN')
      OPEN(UNIT=18,FILE=CASE18,STATUS='UNKNOWN')
      OPEN(UNIT=19,FILE=CASE19,STATUS='UNKNOWN')
      OPEN(UNIT=20,FILE=CASE20,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE7,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE8,STATUS='UNKNOWN')

      IF (ITYPE.EQ.1) CASE28=CASE//'.TIT'
      IF (ITYPE.EQ.3) CASE28=CASE//'.TTT'
      OPEN(UNIT=28,FILE=CASE28,STATUS='OLD',FORM='UNFORMATTED',READONLY)

      IUNIT = 10*ICASES + ILOADS
      LX = '.P'
      IF (ITYPE.EQ.3) LX = '.L'
      CASEU = CASE//LX//CICASE//CILOAD
      INQUIRE(UNIT=IUNIT,OPENED=YEAH)
      IF (.NOT.YEAH)
     1 OPEN(UNIT=IUNIT,FILE=CASEU,STATUS='OLD',FORM='UNFORMATTED',
     1      READONLY)
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN DIPLOT.NEW:

      PROGRAM DIPLOT
      CASE7=CASE//'.CBL'
      CASE8=CASE//'.ODI'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=3,FILE=CASE,STATUS='UNKNOWN')
      OPEN(UNIT=7,FILE=CASE7,STATUS='UNKNOWN',FORM='UNFORMATTED')
      OPEN(UNIT=8,FILE=CASE8,STATUS='UNKNOWN')

      IFILE = 7
      DO 35 M = 1,IDF
         IF (IPLTST(M).EQ.0) GO TO 35
         OPEN(UNIT=IFILE,TYPE='OLD',FILE=FILENM(M),ERR=7)
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN BOSPAN.NEW:

      PROGRAM BOSPAN
      CASE2=CASE//'.ALL'
      CASE3=CASE//'.CBL'
      CASE5=CASE//'.SET'
      OPEN(UNIT=2,FILE='PANDA2:PROMPT.DAT',STATUS='OLD',READONLY)
      OPEN(UNIT=14,FILE=CASE2,STATUS='UNKNOWN')
      OPEN(UNIT=3,FILE=CASE5,STATUS='SCRATCH')
      OPEN(UNIT=7,FILE=CASE3,STATUS='UNKNOWN',FORM='UNFORMATTED')
-----------------------------------------------------------------------
"OPEN" STATEMENTS IN HELPAN.NEW:

      NONE
========================================================================


MORE DETAILS ON FILES...
 =================================================================
                PANDA2 FILES GENERATED FROM RUNS
 =================================================================
   ALL           (NAME.ALL  file)       FILE TYPE:  FORMATTED
 
   NAME.ALL  is generated by two processors, SETUP  and  PANEL.
             SETUP generates a NAME.ALL file that represents a
             single module of the panelPANEL generates a
             NAME.ALL file that represents a multi-module panel.
             The single-module NAME.ALL file is used by the PANDA2
             system as input to the BOSMODEL processor. The multi-
             module NAME.ALL file is used by the PANDA2 system as
             input to the BOSORALL processor, which is a BOSOR4
             processor.


   BL1           (NAME.BL1  file)       FILE TYPE:  BINARY
 
   NAME.BL1  contains contents of labelled common blocks of the
             BOSOR4 system of programs corresponding to the
             discretized model of the panel module.


   BL2           (NAME.BL2  file)       FILE TYPE:  BINARY
 
   NAME.BL2  contains contents of labelled common blocks of the
             BOSOR4 system of programs corresponding to the
             discretized model of the entire panel with smeared
             stiffeners.


   DAT           (NAME.DAT  file)       FILE TYPE:  FORMATTED
 
   NAME.DAT  contains a copy of whatever interactive session is
             presently being performed. This file is generally not
             needed, but may be useful in case of accidental
             distruction of the other file that contains the current
             interactive session (NAME.BEG, NAME.DEC, NAME.OPT, or
             NAME.CHG, for examples). Also, NAME.DAT provides a
             properly documented file corresponding to whatever
             interactive session you just completed. For example,
             you may have generated some input for NAME.BEG by
             VAX editing rather than by answering questions
             interactively. You probably did not bother to type
             the definitions corresponding to your new input.
             Therefore your VAX-edited NAME.BEG file will not be
             properly annotated. After completion of the BEGIN
             session and before you do anything else, you should
             replace the improperly annotated NAME.BEG file with
             the properly annotated NAME.DAT file.


   DOC           (NAME.DOC  file)       FILE TYPE:  FORMATTED
 
   NAME.DOC is a re-annotated copy of NAME.ALL.  NAME.DOC
              is generated by the BOSOR preprocessor BOSORREAD.
              It represents a completely annotated input "deck"
              for BOSOR if execution of the preprocessor BOSORREAD
              was successful.


   ERR           (NAME.ERR  file)       FILE TYPE:  FORMATTED
 
   NAME.ERR  contains list output.  This file will not be
              present if BOSORALL ran successfully. If the
              case bombed, it will contain whatever output
              had been generated in the processor (pre-, main-
              or post-) that happened to be executing at the
              time the case bombed out.  List this file for
              debugging purposes.



   LAB           (NAME.LAB  file)       FILE TYPE:  FORMATTED
 
   NAME.LAB  contains labels for plots.  This file must exist
               before the command  BOSORPLOT is given.



   OUT           (NAME.OUT  file)       FILE TYPE:  FORMATTED
 
   NAME.OUT  contains BOSOR4 output.  The version number will
               be 3 if BOSORALL ran successfully to completion.



   PLT           (NAME.PLT  file)       FILE TYPE:  BINARY
 
   NAME.PLT  contains data for plots.  This file must exist
               before the command  BOSORPLOT is given.



   DAT           (POPFIL.DAT file)     TYPE:  BINARY
 
   POPFIL.DAT file contains data for plotter. This file is
              generated via the command  BOSORPLOT.  You can obtain
              hard copies of your plots by giving whatever command
              is appropriate at your facility. (PLOT at LPARL). See
              Sections II. and III.


   RN1           (NAME2.RN1  file)           FILE TYPE:  BINARY
 
   NAME.RN1  contains BOSOR4 and PANDA2 data bases corresponding to
             the discretized model of the panel module.


   RN2           (NAME.RN2  file)           FILE TYPE:  BINARY
 
   NAME.RN2  contains BOSOR4 and PANDA2 data bases corresponding to
             the discretized model of the entire panel with smeared
             stiffeners.



   NAM           (NAME.NAM  file)           FILE TYPE: FORMATTED
 
   NAME.NAM  contains only the name of the PANDA2 case.



   BEG           (NAME.BEG  file)       FILE TYPE:  FORMATTED
 
   NAME.BEG  contains a summary of the interactive session
             initiated with the command BEGIN (establish starting
             design). This file can be edited and used for future
             runs of the BEGIN processor, thus saving you the
             necessity of running through all the questions again
             interactively.  Partial NAME.BEG files are also use-
             ful:  If you make a mistake during the interactive
             session, you can terminate with a CONTROL Y, remove
             any erroneous lines at the end of the NAME.BEG file,
             and issue the command BEGIN again. Upon your indicat-
             ing that you want to add to an existing file, the
             BEGIN processor will use the data in the NAME.BEG
             file first and return to the interactive mode at the
             end of this file. The data that you next provide will
             be added to the NAME.BEG file.


   CBL           (NAME.CBL  file)       FILE TYPE:  BINARY
 
   NAME.CBL  contains contents of labelled common blocks of the
             PANDA2 system of programs.



   DEC           (NAME.DEC  file)       FILE TYPE:  FORMATTED
 
   NAME.DEC  contains a summary of the interactive session
             initiated with the command DECIDE (establish decision
             variables). This file can be edited and used for future
             runs of the DECIDE processor, thus saving you the
             necessity of running through all the questions again
             interactively.  Partial NAME.DEC files are also use-
             ful:  If you make a mistake during the interactive
             session, you can terminate with a CONTROL Y, remove
             any erroneous lines at the end of the NAME.DEC file,
             and issue the command DECIDE again. Upon your indicat-
             ing that you want to add to an existing file, the
             DECIDE processor will use the data in the NAME.DEC
             file first and return to the interactive mode at the
             end of this file. The data that you next provide will
             be added to the NAME.DEC file.


   OPB           (NAME.OPB  file)       FILE TYPE:  FORMATTED
 
   NAME.OPB  contains a summary of output from BEGIN.  It is a
             good idea to list this file before proceeding with
             any optimization in order to insure that the case is
             as you intend it to be.



   OPD           (NAME.OPD  file)       FILE TYPE:  FORMATTED
 
   NAME.OPD  contains a summary of output from DECIDE.  It is a
             good idea to list this file before proceeding with
             any optimization in order to insure that the case is
             as you intend it to be.



   OPM           (NAME.OPM  file)       FILE TYPE:  FORMATTED
 
   NAME.OPM  contains output from the PANDA2 mainprocessor,
             PANDAOPT.  This is the most important file of all
             from the user's viewpoint, because it contains
             warping evaluation, bowing due to loading, general
             and local bifurcation buckling loads, the postbuckled
             state of strain and stress resultants, identification
             of maximum strains and strain margins, and the evolu-
             tion of the design during optimization.
 
             NOTE: make sure you print this file out after every
                   PANDAOPT batch run.  The PANDA2 system only
                   retains the most recent version of NAME.OPM.


   OPP           (NAME.OPP  file)       FILE TYPE:  FORMATTED
 
   NAME.OPP  contains output from the PANDA2 processor called STORE.
             NAME.OPP is one of the most important files because it
             contains the accumulated results from several sequential
             PANDAOPTs. Essentially, the NAME.OPP file presents the
             evolution of the design since the beginning of the case.
             The end part of the NAME.OPP file is perhaps the most
             important because it contains a summary of the panel
             weights, whether the design is FEASIBLE, ALMOST FEASIBLE,
             or NOT FEASIBLE, and the number of critical constraint
             conditions for each of up to five loadsets. The user
             should always inspect the NAME.OPP file after every run,
             and especially after every SUPEROPT run.


   OPT           (NAME.OPT  file)       FILE TYPE:  FORMATTED
 
   NAME.OPT  contains a summary of the short interactive session
             following your command MAINSETUP.  The contents of
             this file are listed at the beginning of NAME.OPM.
             The file is always saved, and you do not have to
             go back to MAINSETUP every time you want to launch
             a batch run via your command PANDAOPT.  For example,
             after looking at the results of the first set of
             design iterations in the file NAME.OPM, you may want
             to do another set of design iterations without
             changing any strategy parameters. If so, you can
             simply type PANDAOPT again.  The PANDA2 system will
             use the strategy parameters in the file NAME.OPT.



   CHG           (NAME.CHG  file)       FILE TYPE:  FORMATTED
 
   NAME.CHG  contains a summary of the interactive session
             initiated with the command CHANGE (modify design).
             This file can be edited and used for future
             runs of the CHANGE processor, thus saving you the
             necessity of running through all the questions again
             interactively.  Partial NAME.CHG files are also use-
             ful:  If you make a mistake during the interactive
             session, you can terminate with a CONTROL Y, remove
             any erroneous lines at the end of the NAME.CHG file,
             and issue the command CHANGE again. Upon your indicat-
             ing that you want to add to an existing file, the
             CHANGE processor will use the data in the NAME.CHG
             file first and return to the interactive mode at the
             end of this file. The data that you next provide will
             be added to the NAME.CHG file.



   OPC           (NAME.OPC  file)       FILE TYPE:  FORMATTED
 
   NAME.OPC  contains a summary of output from CHANGE.  It is a
             good idea to list this file before proceeding with
             any optimization in order to insure that the case is
             as you intend it to be.  Also, if you have made
             substantial changes, it is a good idea before doing
             any optimization, to run a simple buckling analysis
             with the new design fixed.

   STG           (NAME.STG  file)      FILE TYPE: FORMATTED

   NAME.STG  Input data for STAGSMODEL or STAGSUNIT (See Chapter XI.)
   NAME.inp  Output from STAGSMODEL or STAGSUNIT; input for STAGS
   NAME.bin  Output from STAGSMODEL or STAGSUNIT; input for STAGS


   NOTE:      26 JAN 1989  IMPROVEMENT TO PANDA2 FOLLOWS....

      Early in 1989 PANDA2 was enhanced by three processors, STORE,
      CHPLOT, and DIPLOT, which allow results from all design
      iterations since the beginning of the case to be accumulated
      in files and plotted v. design iterations.  These processors
      generate several files, examples of which are listed as follows
      for a particular case called ARIANE:

       ARIANE.CPL;5              2/3       21-FEB-1989 16:27
       ARIANE.DIP;1              1/3       21-FEB-1989 16:29
       ARIANE.ODI;1              9/9       21-FEB-1989 16:29
       ARIANE.OPL;5             14/15      21-FEB-1989 16:27
       ARIANE.OPP;1            124/126     21-FEB-1989 13:56
       ARIANE.P11;1              1/3       21-FEB-1989 13:56
       ARIANE.P12;1              1/3       21-FEB-1989 13:56
       ARIANE.PL1;1             61/63      21-FEB-1989 13:41
       ARIANE.PL2;2              2/3       21-FEB-1989 13:56
       ARIANE.PL3;5              2/3       21-FEB-1989 16:27
       ARIANE.PL4;5              2/3       21-FEB-1989 16:27
       ARIANE.PL5;5              1/3       21-FEB-1989 16:27
       ARIANE.PLD;1              2/3       21-FEB-1989 13:56
       ARIANE.TIT;1              5/6       21-FEB-1989 13:56

  Table:  Names of files having to do with STORE, CHPLOT, DIPLOT
          and their functions.
  ==============================================================
   FILE NAME                 PURPOSE OF THE FILE
  --------------------------------------------------------------
    *.CPL          Input data for CHOOSEPLOT (analogous to *.BEG
                   for BEGIN; *.DEC for DECIDE; *.CHG for CHANGE)

    *.DIP          A very small (two-line) file containing
                   interactive input data for DIPLOT.

    *.ODI          A small file with list output from DIPLOT.

    *.OPL          Contains list output from CHOOSEPLOT. The user
                   should inspect this file before proceeding with
                   DIPLOT.

    *.OPP          Contains list output from STORE. The user should
                   inspect this file before proceeding with
                   CHOOSEPLOT.

    *.P11          Binary file that contains the complete history
                   of all design margins less than MAXMAR (an input
                   datum required by MAINSETUP), for subcase 1,
                   load case 1. (*.P11 = *.Pij, with i = 1, j = 1).
                   This file is generated by STORE and is used as
                   input to CHOOSEPLOT. 

    *.P12          Binary file that contains the complete history
                   of all design margins less than MAXMAR for
                   subcase 1, load case 2. (*.P12 = *.Pij, with i = 1,
                   j = 2). This file is generated by STORE and is
                   used as input to CHOOSEPLOT.  In the ARIANE case
                   there were only two load sets and each had only
                   a single subcase. If there had been m subcases
                   with each of n load sets, there would have been
                   m x n files with names *.Pij, i=1,m; j = 1,n.

    *.PL1          Binary file generated by PANDAOPT and used as input
                   to STORE.  This file contains the history of
                   design variables, margins, and objective for all
                   load sets and subcases for the entire history
                   of design iterations performed by PANDAOPT since
                   the beginning of the case or since the user
                   indicated in MAINSETUP that he/she wanted to
                   reset the total number of iterations to zero.

    *.PL2          Binary file generated by STORE that contains the
                   history of design variables and objective
                   for the last set of design iterations
                   performed by PANDAOPT.

    *.PL3          Formatted file generated by CHOOSEPLOT that contains
                   the entire history of user-selected design margins
                   for a particular load set, ILOADS, and a particular
                   subcase, ICASES. This file is used as input to DIPLOT,
                   which generates plots via DISSPLA software.

    *.PL4          Formatted file generated by CHOOSEPLOT that contains
                   the entire history of user-selected design variables.
                   This file is used as input to DIPLOT,
                   which generates plots via DISSPLA software.

    *.PL5          Formatted file generated by CHOOSEPLOT that contains
                   the entire history of the objective function.
                   This file is used as input to DIPLOT,
                   which generates plots via DISSPLA software.

    *.PL6          Formatted file for plot of layup of skin-stringer
                   module (generated when ITYPE=3).

    *.PL7          Formatted file for "3-D" plot of locally post-buckled
                   skin-stringer panel module (ITYPE=3).

    *.PL8          Formatted file for plot of AXIAL or +45deg. extreme
                   fiber strains v. a selected load component (ITYPE=3).

    *.PL9          Formatted file for plot of HOOP or -45deg. extreme
                   fiber strains v. a selected load component (ITYPE=3).

    *.PL10         Formatted file for plot of SHEAR or extreme fiber
                   strains in axial-hoop (x,y) or 45deg. coordinates
                   v. a selected load component (ITYPE=3).

    *.PLD          Binary file generated by STORE that is like *.PL2,
                   except that it contains the history of design
                   variables and objective for the final set of
                   design iterations performed by PANDAOPT.

    *.TIT          Binary file generated by STORE that contains the
                   definitions of all margins with values less than
                   MAXMAR.  (MAXMAR is a datum provided by the user
                   in MAINSETUP. Only margins less than MAXMAR are
                   accumulated by STORE for future plotting via
                   CHOOSEPLOT and DIPLOT.)
  ===================================================================
********************************************************************

V.  PANDA2 DOCUMENTATION

          DOCUMENTATION THAT YOU SHOULD HAVE AS A USER OF PANDA2
============================================================================
          (Copies, except for the book COMPUTERIZED BUCKLING ANALYSIS
           OF SHELLS, may be obtained free of charge from David Bushnell,
           Dept. 93-30, bldg. 255, Lockheed Palo Alto Research Labs,
           3251 Hanover St., Palo Alto, California 94304, USA,
           Telephone: (415) 424-3237).   The book, COMPUTERIZED BUCKLING
           ANALYSIS OF SHELLS, may be obtained from Kluwer Academic Press,
           P.O. Box 163, 3300 AD Dordrecht, The Netherlands.

    DOCUMENTATION FOR PANDA2....
 
       (A) BACKGROUND MATERIAL ON SHELL BUCKLING....
 
[1]         "Buckling of Shells--Pitfall for Designers", AIAA Journal,
             Vol. 19, No. 9, September, 1981, pp. 1183-1226
 
[2]         "Computerized Analysis of Shells--Governing Equations",
             Computers & Structures, Vol. 18, pp.471-536, 1984
 
[3]          COMPUTERIZED BUCKLING ANALYSIS OF SHELLS, D. Bushnell,
             published by Nijhoff, The Netherlands, 1985, reprinted
             by Kluwer Academic Publishers, 1989
 
       (B) MATERIAL NEEDED FOR USE OF THE BOSOR4 COMPUTER PROGRAM...
 
[4]         "BOSOR4--Program for stress, buckling, and vibration of
             complex shells of revolution," in STRUCTURAL MECHANICS
             SOFTWARE SERIES, vol. 1, Univ. Press of Virginia, pp 11-143,
             1977. Also, see also, STRUCTURAL ANALYSIS SYSTEMS, Vol. 2,
             Editor: A. Niku-Lari, Pergamon Press, 1986, pp 25-54.
 
[5]          BOSOR4ST.ORY  (file contained in the BOSOR4 directory
                            that describes the VAX version of BOSOR4)
 
[6]          HELP4         (interactive help file, data in BOSOR4.HLP)
 
       (C) MATERIAL NEEDED FOR USE OF THE PANDA2 COMPUTER PROGRAM...
 
          ABOUT PANDA...

[7]         "PANDA--Interactive program for minimum weight design of
             stiffened cylindrical panels and shells", Computers and
             structures, Vol. 16, pp 167-185, 1983.
 
[8]         "Theoretical basis of the PANDA computer program for
             preliminary design of stiffened panels under combined in-
             plane loads, COMPUTERS AND STRUCTURES, v. 27, No. 4,
             pp 541-563 (1987).
 
          ABOUT PANDA2...

[9]         "PANDA2 - Program for minimum weight design of stiffened,
             composite, locally buckled panels", COMPUTERS AND STRUCTURES,
             Vol. 25, No. 4, pp 469-605, 1987
 
[10]        "Optimum design, fabrication and test of graphite-epoxy,
             curved, stiffened, locally buckled panels loaded in axial
             compression", in BUCKLING OF STRUCTURES, edited by I. 
             Elishakoff, et al, Elsevier, Amsterdam, pp 61-131, 1988
 
[11]        "Nonlinear equilibrium of imperfect, locally deformed,
             stringer-stiffened panels under combined in-plane loads",
             Computers and Structures, v. 27, No. 4, pp 519-539 (1987).
 
[12]        "Optimization of composite, stiffened, imperfect panels
             under combined loads for service in the postbuckling
             regime", Computer Methods in Applied Mechanics and
             Engineering, Vol. 103 (1993) 43-114 (volume in honor of
             Besseling's 65th birthday).
 
[13]        "Buckling of imperfect, unstiffened cylindrical shells with
             PANDA2", unpublished "handout" distributed with PANDA2,
             November, 1988.
 
[14]        "Improvements to PANDA2", Vol. 1 and Vol. 2 Part 1,
             revisd November, 1991; Vol 2 Part 2, January 1992,
             unpublished "handout" distributed with PANDA2.
 
[15]        "Minimum-weight design of a stiffened panel via PANDA2 and
             evaluation of the optimized panel via STAGS", 33rd AIAA
             Structures, Structural Dynamics and Materials Conference,
             April, 1992. See Computers and Structures, Vol. 50, No. 4,
             pp 569-602 (1994)
 
[15b]       "Optimum design of composite stiffened panels under combined
             loading", unpublished "handout" distributed with PANDA2.
             see also, AIAA Paper No. AIAA-93-1562, presented at the
             34th AIAA SDM meeting, La Jolla, CA Apr 1993. Computers
             and Structures, Vol. 55, No. 5, pp 819-856 (1995)

[15c]       "Recent enhancements to PANDA2" 37th AIAA Structures,
             Structural Dynamics and Materials Conference, April, 1996.

[15d]       "Optimum design via PANDA2 of composite sandwich panels
             with honeycomb or foam cores", 38th AIAA Structures,
             Structural Dynamics and Materials Conference, April, 1997

[15e]       "Optimization of stiffened panels in which mode jumping is
             accounted for", AIAA Paper 97-1141, 38th AIAA SDM Conference,
             April 1997

[15f] Bushnell, D., "Optimization of panels with riveted Z-shaped
          stiffeners via PANDA2, in Advances in the Mechanics of Plates and
          Shells", Durban, D, Givoli, D., and Simmonds, J.G., Eds, Kluwer
          Academic Publishers,  79-102, 2001. See also,  Proc. 39th AIAA
          Structures, Materials and Dynamics meeting, 2357-2388, AIAA. 1998. 

[15g]       "Additional buckling solutions in PANDA2", 40th AIAA SDM
             Conference, pp 302-345,  AIAA Paper 99-1233, April 1999

[15h] David Bushnell and Charles C. Rankin, Optimization of perfect and
    imperfect ring and stringer stiffened cylindrical shells with PANDA2 and
    evaluation of optimum designs with STAGS, AIAA 43rd SDM Meeting, April
    2002, AIAA Paper 2002-1408

[15i] David Bushnell, Global optimum design of externally pressurized
    isogrid stiffened cylindrical shells with added T-rings, Int. J. of
    Non-Linear Mechanics, Vol. 37, Nos 4-5, (special "Arbocz" issue)
    pp???-??? (2002)

[16]        "Truss-core sandwich design via PANDA2", Computers and
             Structures, Vol. 44, No. 5, pp 1091-1119 (1992)

[17]        "Approximate method for the optimum design of ring and
             stringer stiffened cylindrical panels and shells with
             local, inter-ring, and general buckling modal imperfections"
             35th AIAA SDM Meeting, Hilton Head, SC, April 1994.
             AIAA Paper 94-1576. Computers and Structures, Vol 59,
             489-527 (1996)

[18]        "Annotated output from PANDA2 mainprocessor for a fixed
             design", unpublished "handout" distributed with PANDA2,
             November, 1991

[19]        "Stress, buckling and vibration of prismatic shells",
             AIAA Journal, Vol. 9, No. 10, pp 2004-2013, Oct. 1971
 
[20]         PANDA2ST.ORY   (File that describes PANDA2 and how to
                             use it.  You should obtain a list of this.)
 
[21]         HELPAN         (PANDA2  HELP file is called PANDA2.HLP.
                             You should obtain a list of PANDA2.HLP.)
 
[22]         PANDA2.HLP     (The "help" file for HELPAN. It is a good
                             idea to list this file and keep a copy
                             handy.)
 
[23]         SAMPLE.CAS     (Sample case: blade-stiffened, curved panel
                             optimized for two loadsets: (1) pure axial
                             compression and (2) combined axial
                             compresssion and in-plane shear.)
  
[24]         PANDA2.NEWS    (File containing paragraphs that are added
                             as PANDA2 is enhanced and corrected. A hard
                             copy dated 14 December, 1991 is distributed
                             as part of the PANDA2 documentation.)
 
[25]         HOWTO.RUN      (A file that describes how VAX tape is made.)
   
[26]         HOWTO.UPDATE   (A file that describes how to update source
                             libraries and regenerate absolute elements.)

[27]         FLOW.CHARTS    (A file that gives details of the flow of
                             calculations in the major PANDA2 processors
                             and subroutines.)

[28]         PANDA2.TEX      A summary about PANDA2 and its recent
                             improvements.

[29] B. O. Almroth and F. A. Brogan, ``The STAGS Computer Code",
     NASA CR-2950, Nasa Langley Research Center, Hampton, Va., 1978. 

[30] C. C. Rankin, P. Stehlin and F. A. Brogan,
     ``Enhancements to the STAGS computer code", NASA CR 4000,
     NASA Langley Research Center, Hampton, Va, November 1986.
     See also, G. A. Thurston, F. A. Brogan and P. Stehlin,
     ``Postbuckling analysis using a general purpose code", AIAA
     Journal, 24, (6) (1986) pp. 1013-1020. 

             Runs of BEGIN, DECIDE, MAINSETUP, PANDAOPT, CHANGE, etc., with
             use of the tutorial option.  Many of the details of the theory
             are given in the tutorial option of the mainprocessor
             PANDAOPT.
 

             NOTE: PLEASE APPLY TO David Bushnell, address and phone no.
                   given above, if you need any of the above materials.
                   Please let Dr. Bushnell know if you have any problems
                   with PANDA2 or any special needs that are not being
                   met by the code or the documentation of it.
 ==========================================================================

VI. RECOMPILING SOURCE FILES, REGENERATING LIBRARIES, RE-LINKING
    (Vax version)

  Please see the file HOWTO.UPDATE.
 **********************************************************************


VII. PANDA2 SAMPLE CASE

  The sample case is contained in the file SAMPLE.CAS. This case
demonstrates most of the PANDA2 capabilities. The user is referred
to the literature (See HELPAN OVERVIEW REF  or  HELPAN OVERVIEW DOC
for the references. However, if you decide to rerun one or more
of the cases, results for which appear in journal articles that were
written some time ago, expect somewhat different answers now. Many
changes have been made to PANDA2 since those articles were written.
Most of the SAMPLE.CAS is kept up-to-date, however.

 *********************************************************************
 
 VIII.  PANDA2 NEWS (complete log of changes in PANDA2, starting from
        1987.

  Please list the file ..panda2/doc/panda2.news for details.  This file is
kept up-to-date. Also see the file panda2/doc/panda2.tex

 *********************************************************************

IX. PANDA2 PLOTS

The most important part of the plotting capability of PANDA2 is the
CHOOSEPLOT/DIPLOT feature, by means of which you can obtain plots of:

1. with ITYPE = 1 (optimization analysis choice in MAINSETUP)...
design variables, margins, and objective function (weight) as a function
of design iterations since the beginning of the case. Fig. 13 in Ref. [15c]
is an example.

2. with ITYPE = 3 (test simulation choice in MAINSETUP)...
various behaviors, design margins, deformed panel module, extreme fiber
strains as functions of a user-selected load component. Fig. 17 in Ref. [15c]
is an example.

3. with ITYPE = 4 (design sensitivity)...
margins v. user-selected decision variable. Fig. 18 in Ref. [15c] is an
example.

4. with ITYPE = 5 (load interaction curves)...
plots of normalized Nx v Ny  or  Nx v Nxy  or  Ny v Nxy for 
all margins. Fig. 26 in Ref. [15c] is an example.




 X. PANDA2 NOW RUNS ON UNIX-BASED AND LINUX-BASED SYSTEMS

 See ITEM 96 of the file PANDA2.NEWS for details.


XI.  PANDA2 processors STAGSMODEL and STAGSUNIT create input file for STAGS

The new PANDA2 processor, executed by the command STAGSMODEL, creates
input files for STAGS, a nonlinear static/dynamic finite element
analyzer for general shells written by Brogan, Almroth, Rankin,
Stanley, Cabiness, Stehlin, and others of the computational mechanics
department of the Lockheed Palo Alto Research Laboratory during the
past 20 years.  STAGS is described in the following articles:

B. O. Almroth and F. A. Brogan, ``The STAGS Computer Code", NASA
CR-2950, Nasa Langley Research Center, Hampton, Va., 1978. 

C. C. Rankin, P. Stehlin and F. A. Brogan, ``Enhancements to the STAGS
computer code", NASA CR 4000, NASA Langley Research Center, Hampton,
Va, November 1986

G. A. Thurston, F. A. Brogan and P. Stehlin, ``Postbuckling analysis
using a general purpose code", AIAA Journal, 24, (6) (1986) pp.
1013-1020. 

STAGS is widely used throughout the world and is distributed by COSMIC
at the University of Georgia in Athens, Georgia:

COSMIC, 112 Barrow Hall, University of Georgia, Athens, Georgia 30602
Attention: Mr. John Gibson (404) 542-3265 .

With STAGSMODEL and STAGS the load-carrying capacity of optimum designs
obtained by PANDA2 can be checked without the user having to spend time
setting up elaborate finite element models for STAGS. 

The new processor is called STAGFE. (STAGFE.NEW library for "STAGS
Finite Element model").  This program, using the PANDA2 data base and
some interactively provided input from the user, generates input files
for the STAGS computer program (STructural Analysis of General Shells).
STAGS performs linear and nonlinear static and dynamic analyses of
general segmented and/or branched shell structures.

The STAGFE processor can be used to create a succession of STAGS
models by means of which bifurcation buckling behavior and nonlinear
post-local-buckling behavior of a panel optimized by PANDA2 can be
determined. This is a valuable feature because panels designed by the
approximate methods used in PANDA2 can now easily be "tested" by a
rigorous, general, nonlinear finite element general-purpose program.
With STAGFE the PANDA2 user avoids having to learn how to provide
input data for the STAGS computer program. 

The STAGFE processor creates a finite element model of the part of a
panel between adjacent rings. The stiffness along the axes of the rings
is accounted for in the finite element model created by STAGFE/STAGS.
The panel can be loaded by any combination of uniform axial load
Nx, uniform hoop load, Ny, uniform in-plane shear Nxy, and uniform
normal pressure p.

LIMITATIONS: Thermal loading and edge moments cannot be included.
Truss-core sandwich panels cannot be handled. Also, the boundaries of
the axially loaded edges of axially stiffened panels cannot rotate in
either the prebuckling or bifurcation buckling phases of the analysis.
(NOTE THIS EXCEPTION: For UNSTIFFENED panels, the axially loaded edges
can rotate in the bifurcation phase of the analysis.)  STAGSMODEL
cannot handle truss-core sandwich panels or isogrid-stiffened panels.

Depending on a user-selected index, the normal projection of the two
edges parallel to the stringers may be forced to remain straight or may
be allowed to undergo in-plane warping (varying circumferential
displacement). At the axially loaded ends of the panel the cross sections
of the stringers are not allowed to warp. Axial displacement u is
zero at one end of the STAGS model and is uniform at the other end.
Whether or not stringer sidesway is permitted at the axially loaded ends
of the panel is chosen by the user.

The entire STAGS model is created in what in STAGS jargon is called an
"element unit".  The stringer web(s) and outstanding flange are also
modelled with finite elements. The line loads Nx, Ny and Nxy and
pressure p are modelled as nodal point loads. 

The STAGFE processor is invoked with the command STAGSMODEL. In the
interactive session that follows, STAGSMODEL creates three files of
interest to the user: 

  <NAME>.STG  is an echo of the interactive STAGSMODEL session.
  <NAME>.inp  is the input file for the STAGS computer program.
  <NAME>.bin  is a small input file for advanced STAGS (QSTAGS).
  <NAME>.ppn  is the input file for the STAGS postprocessor, POSTP.

Typical input for the STAGSMODEL session appears in the following
two files, the first corresponding to a linear bifurcation buckling
analysis and the second to a nonlinear equilibrium analysis.

 ***************** TEE.STG FILE (LINEAR BUCKLING) *************************
      n         $ Do you want a tutorial session and tutorial output?
      n         $ Is this run for STAGS postprocessing (Y/N)?
         1      $ Choose type of STAGS analysis (1,3,4,5,6),INDIC
         0      $ Restart from ISTARTth load step (0=1st nonlinear soln), ISTART
  0.3500000     $ Local buckling load factor from PANDA2, EIGLOC
      y         $ Are the dimensions in this case in inches?
         0      $ Lowest vibration frequency (cps) from STAGS INDIC=5 run, CPS
         0      $ Percent damping to be used in STAGS transient (INDIC=6) run.
         2      $ Choose 1 = regular STAGS; 2 = QSTAGS: ISTAGS
        30      $ X-direction length of the STAGS model of the panel: XSTAGS
         3      $ Number of modules in the STAGS finite element model, NSTIF
      y         $ Do you want wide-column buckling to constrain the design?
      y         $ Is the nodal point spacing uniform along the stringer axis?
        31      $ Number of nodes in the X-direction: NODEX
         5      $ Number of nodes in the next panel module segment: NNODES( 1)
         3      $ Number of nodes in the next panel module segment: NNODES( 2)
         3      $ Number of nodes in the next panel module segment: NNODES( 3)
         3      $ Number of nodes in the next panel module segment: NNODES( 4)
         5      $ Number of nodes in the next panel module segment: NNODES( 5)
      -500      $ Resultant (e.g. lb/in) normal to the plane of screen, Nx
         0      $ Resultant (e.g. lb/in) in the plane of the screen,    Ny
       500      $ In-plane shear in load set A,                  Nxy
         5      $ Uniform applied pressure [positive upward. See H(elp)], p
         0      $ Initial bowing imperfection amplitude (type H for sign), Wimp
  1.0000000     $ Starting load factor for Load System A, STLD(1)
  0.1000000     $ Load factor increment for Load System A, STEP(1)
   1.200000     $ Maximum load factor for Load System A, FACM(1)
         8      $ How many eigenvalues do you want? NEIGS
       410      $ Choose element type (410 or 411 or 480) for panel skin
         1      $ Nonlinear solution strategy (0=default, 1=full Newton)
      y         $ Is stringer sidesway permitted at the panel ends or rings?
         1      $ Edges normal to screen (0) in-plane deformable; (1) rigid
      n         $ Have you obtained buckling modes from STAGS for this case?
 *********************** END OF THE TEE.STG (LINEAR BUCKLING) **************

 ********************** TEE.STG FILE (NONLINEAR EQUILIBRIUM) **************
      n         $ Do you want a tutorial session and tutorial output?
      n         $ Is this run for STAGS postprocessing (Y/N)?
         3      $ Choose type of STAGS analysis (1,3,4,5,6),INDIC
         0      $ Restart from ISTARTth load step (0=1st nonlinear soln), ISTART
  0.3000000     $ Local buckling load factor from PANDA2, EIGLOC
      y         $ Are the dimensions in this case in inches?
         0      $ Lowest vibration frequency (cps) from STAGS INDIC=5 run, CPS
         0      $ Percent damping to be used in STAGS transient (INDIC=6) run.
         2      $ Choose 1 = regular STAGS; 2 = QSTAGS: ISTAGS
        30      $ X-direction length of the STAGS model of the panel: XSTAGS
         3      $ Number of modules in the STAGS finite element model, NSTIF
      y         $ Do you want wide-column buckling to constrain the design?
      y         $ Is the nodal point spacing uniform along the stringer axis?
        31      $ Number of nodes in the X-direction: NODEX
         5      $ Number of nodes in the next panel module segment: NNODES( 1)
         3      $ Number of nodes in the next panel module segment: NNODES( 2)
         3      $ Number of nodes in the next panel module segment: NNODES( 3)
         3      $ Number of nodes in the next panel module segment: NNODES( 4)
         5      $ Number of nodes in the next panel module segment: NNODES( 5)
      -500      $ Resultant (e.g. lb/in) normal to the plane of screen, Nx
         0      $ Resultant (e.g. lb/in) in the plane of the screen,    Ny
       500      $ In-plane shear in load set A,                  Nxy
         5      $ Uniform applied pressure [positive upward. See H(elp)], p
         0      $ Initial bowing imperfection amplitude (type H for sign), Wimp
  0.1000000     $ Starting load factor for Load System A, STLD(1)
  0.1000000     $ Load factor increment for Load System A, STEP(1)
   1.800000     $ Maximum load factor for Load System A, FACM(1)
         0      $ How many eigenvalues do you want? NEIGS
       410      $ Choose element type (410 or 411 or 480) for panel skin
         1      $ Nonlinear solution strategy (0=default, 1=full Newton)
      y         $ Is stringer sidesway permitted at the panel ends or rings?
         1      $ Edges normal to screen (0) in-plane deformable; (1) rigid
      y         $ Have you obtained buckling modes from STAGS for this case?
      y         $ Do you want to provide initial local imperfection(s)?
  0.3000000E-02 $ Amplitude of the initial buckling modal imperfection, WIMPL( 1)
         0      $ Load step number at which buckling mode computed, ISTEP( 1)
         1      $ Mode number at the load step ISTEP. IMODE( 1)
      y         $ Do you want to provide another imperfection?
  0.2000000E-02 $ Amplitude of the initial buckling modal imperfection, WIMPL( 2)
         0      $ Load step number at which buckling mode computed, ISTEP( 2)
         2      $ Mode number at the load step ISTEP. IMODE( 2)
      y         $ Do you want to provide another imperfection?
  0.1000000E-02 $ Amplitude of the initial buckling modal imperfection, WIMPL( 3)
         0      $ Load step number at which buckling mode computed, ISTEP( 3)
         3      $ Mode number at the load step ISTEP. IMODE( 3)
      y         $ Do you want to provide another imperfection?
  0.8000000E-03 $ Amplitude of the initial buckling modal imperfection, WIMPL( 4)
         0      $ Load step number at which buckling mode computed, ISTEP( 4)
         4      $ Mode number at the load step ISTEP. IMODE( 4)
      y         $ Do you want to provide another imperfection?
  0.5000000E-03 $ Amplitude of the initial buckling modal imperfection, WIMPL( 5)
         0      $ Load step number at which buckling mode computed, ISTEP( 5)
         5      $ Mode number at the load step ISTEP. IMODE( 5)
      y         $ Do you want to provide another imperfection?
  0.3000000E-03 $ Amplitude of the initial buckling modal imperfection, WIMPL( 6)
         0      $ Load step number at which buckling mode computed, ISTEP( 6)
         6      $ Mode number at the load step ISTEP. IMODE( 6)
      y         $ Do you want to provide another imperfection?
  0.2000000E-03 $ Amplitude of the initial buckling modal imperfection, WIMPL( 7)
         0      $ Load step number at which buckling mode computed, ISTEP( 7)
         7      $ Mode number at the load step ISTEP. IMODE( 7)
      y         $ Do you want to provide another imperfection?
  0.1000000E-03 $ Amplitude of the initial buckling modal imperfection, WIMPL( 8)
         0      $ Load step number at which buckling mode computed, ISTEP( 8)
         8      $ Mode number at the load step ISTEP. IMODE( 8)
      n         $ Do you want to provide another imperfection?
 ********************* END OF THE TEE.STG FILE (NONLINEAR EQUILIBRIUM) ********


A small part of the TEE.INP file, which is created by STAGSMODEL,
is listed next.  The TEE.INP file can be used directly as input
for the STAGS program.

 ******************* A SMALL PART OF THE TEE.INP FILE *******************
 STAGS INPUT FROM PANDA2 OUTPUT FOR CASE: TEE
 3, $ INDIC=1 is bifur.buckling; INDIC=3 is nonlinear BEGIN B-1
 1, $ IPOST0=1 means save model data
 1, $ IPOST1=1 means save displacements every IPOST1th step
 1, $ IPOST2=1 means save stress data every IPOST2th step
 0, $ IGRAV =0 means g = 386.4 inches per sec.**2; else B-4
 0, $ ICHECK=0 means normal execution
 0, $ ILIST =0 means normal batch-oriented output
 0, $ IOPTIM=0 means bandwith optimization will be performed
 0  $ IFLU  =0 means no fluid interaction.      END   B-1 rec.
 0, $ NUNITS=0 means no shell units.            BEGIN B-2 rec.
 1, $ NUNITE=1 means there is a finite element unit
 0, $ NSTFS =0 means zero shell units with discrete stiffeners
 0, $ NINTS =0 means zero connections between shell units
 0, $ NPATS =0 means zero records for partial nodal compatibil
  -88, $ NCONST= number of Lagrange constraint conditions
 1  $ NIMPFS=number of bucklng mode imperfectns. END B-2 rec.
 2, $ NTAM = number of entries in material tabl.BEGIN B-3 rec.
 0, $ NTAB = number of beam cross section entries
 5, $ NTAW = number of entries in shell wall table.
 0  $ NTAP = 0 means user parameters not included.END B-3 rec.
 5.830E-03 $ WIMPFA=scale factor for local buckling modal imperf. B-5
 1.000E-01, $ STLD(1) = starting load factor, System A. BEGIN C-1 rec.
 1.000E-01, $ STEP(1) = load factor increment, System A
 1.000E-01, $ FACM(1) = maximum load factor, System A
 0.000E+00, $ STLD(2) = starting load factor, System B
 0.000E+00, $ STEP(2) = load factor increment, System B
 0.000E+00, $ FACM(2) = maximum load factor, System B
 0, $ ITEMP =0 means no thermal loads
 0, $ INERT =0 means no inertial loads
 0, $ IXSTF =0 means normal program flow: stiffness matrix
 0  $ IXFAC =0 means norm. flow: factored matrix. END C-1 rec.
 0, $ ISTART=restart from ISTARTth load step.   BEGIN D-1 rec.
 9999,$ NSEC= number of CPU seconds before run termination
 5, $ NCUT = number of times step size may be cut
 -1,$ NEWT = number of refactorings allowed
-1,$ NSTRAT=path length is used as independent parameter
 0.0001,$ DELX = convergence tolerance
 0. $ WUND = 0 means initial relaxation factor =1.END D-1 rec.
 3  $ NTERMS= no. of terms in linear-v constraint at y=0.  G-3
 1,    1,0, 2,-7.069E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,   32,0, 2, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 1,  931,0, 2,-2.438E+04 $ IU(3),IX(3),IY(3),ID(3),CC(3). G-4
 3  $ NTERMS= no. of terms in linear-v constraint at y=0.  G-3
 1,    1,0, 2,-6.825E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,   63,0, 2, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 1,  931,0, 2,-4.875E+04 $ IU(3),IX(3),IY(3),ID(3),CC(3). G-4


          (LINES SKIPPED IN ORDER TO SAVE SPACE)


 2  $ NTERMS=no. of terms in linear-v constraint at y=CIRC.G-3
 1,   62,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  961,0, 2,-2.438E+04 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in linear-v constraint at y=CIRC.G-3
 1,   93,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  961,0, 2,-4.875E+04 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in linear-v constraint at y=CIRC.G-3
 1,  124,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  961,0, 2,-7.313E+04 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4


        (LINES SKIPPED IN ORDER TO SAVE SPACE)


 2  $ NTERMS=no. of terms in the u=const constraint at x=L.G-3
 1,  931,0, 1, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  932,0, 1,-7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the u=const constraint at x=L.G-3
 1,  931,0, 1, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  933,0, 1,-7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the u=const constraint at x=L.G-3
 1,  931,0, 1, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  934,0, 1,-7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4


         (LINES SKIPPED IN ORDER TO SAVE SPACE)


 2  $ NTERMS=no. of terms in the vf = vb constraint at x=0.G-3
 1,    4,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,    7,0, 3, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the vf = vb constraint at x=0.G-3
 1,   14,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,   17,0, 3, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the vf = vb constraint at x=0.G-3
 1,   24,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,   27,0, 3, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the vf = vb constraint at x=L.G-3
 1,  934,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  937,0, 3, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the vf = vb constraint at x=L.G-3
 1,  944,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  947,0, 3, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
 2  $ NTERMS=no. of terms in the vf = vb constraint at x=L.G-3
 1,  954,0, 2, 7.313E+05 $ IU(1),IX(1),IY(1),ID(1),CC(1). G-4
 1,  957,0, 3, 7.313E+05 $ IU(2),IX(2),IY(2),ID(2),CC(2). G-4
  961, $ NUPT = number of nodal points in model.   BEGIN H-1 rec.
 0, $ NSPRI= number of mount (spring) elements
 0, $ NBM  = number of beam elements defined on data cards
 0, $ NTRI = number of triangular elements defined on cards
  900, $ NQUAD =number of quadrilateral finite elements in model
 0, $ IUWP = 0 means all nodal points defined on data cards
 0  $ IUWE = 0 means all elements on cards.      END H-1 rec.
 1, $ ITAM = material number.                  BEGIN I-1 rec.
 0, $ NESP = 0 means zero points on stress-strain curve
 0, $ IPLST =0 means White-Besseling plasticity theory
 0  $ ITANST=0 means Initial Strain method used. END I-1 rec.
 1.000E+07, $ Matl 1: E1=Modulus along fibers.         BEGIN I-2 rec.
 3.000E-01, $ Matl 1: U12=Poisson ratio NU12 (NU12*E1 = NU21*E2)
 3.846E+06, $ Matl 1: G  = In-plane shear modulus
 1.000E-01, $ Matl 1: RHO=weight density
 0.000E+00, $ Matl 1: A1 =thermal expansion coefficient along fibers
 1.000E+07, $ Matl 1: E2 =Modulus normal to fibers (normal to PHI1)
 0.000E+00 $ Matl 1: A2 =thermal expansion coef. normal to fibers. END I-2 rec.
 2, $ ITAM = material number.                  BEGIN I-1 rec.
 0, $ NESP = 0 means zero points on stress-strain curve
 0, $ IPLST =0 means White-Besseling plasticity theory
 0  $ ITANST=0 means Initial Strain method used. END I-1 rec.
 1.000E+09, $ Matl 2: E1=Modulus along fibers.         BEGIN I-2 rec.
 0.000E+00, $ Matl 2: U12=Poisson ratio NU12 (NU12*E1 = NU21*E2)
 5.000E+08, $ Matl 2: G  = In-plane shear modulus
 0.000E+00, $ Matl 2: RHO=weight density
 0.000E+00, $ Matl 2: A1 =thermal expansion coefficient along fibers
 1.000E+09, $ Matl 2: E2 =Modulus normal to fibers (normal to PHI1)
 0.000E+00 $ Matl 2: A2 =thermal expansion coef. normal to fibers. END I-2 rec.
 1, $ ITAW = wall configuration number.        BEGIN K-1 rec.
 1, $ KWALL = 1 means general layered wall (composite layup)
  1,$ NLAY = number of layers thru the thickness
 0, $ NLIP = 0 means properties are uniform within each layer
 0  $ NSMRS= 0 means no smeared stiffeners.      END K-1 rec.
 1, $ MATL=layer matl no.   Wall type: 1, Layer:  1   BEGIN K-2 rec.
 5.835E-02, $ TL  =layer thickness. Wall type: 1, Layer:  1
 0.000E+00, $ ZETL=fiber angle.     Wall type: 1, Layer:  1
 1  $ LSO = 1 means print stresses this layer.   END K-2 rec.
 2, $ ITAW = wall configuration number.        BEGIN K-1 rec.
 1, $ KWALL = 1 means general layered wall (composite layup)
  2,$ NLAY = number of layers thru the thickness
 0, $ NLIP = 0 means properties are uniform within each layer
 0  $ NSMRS= 0 means no smeared stiffeners.      END K-1 rec.
 1, $ MATL=layer matl no.   Wall type: 2, Layer:  1   BEGIN K-2 rec.
 5.835E-02, $ TL  =layer thickness. Wall type: 2, Layer:  1
 0.000E+00, $ ZETL=fiber angle.     Wall type: 2, Layer:  1
 1  $ LSO = 1 means print stresses this layer.   END K-2 rec.
 1, $ MATL=layer matl no.   Wall type: 2, Layer:  2   BEGIN K-2 rec.
 5.875E-02, $ TL  =layer thickness. Wall type: 2, Layer:  2
 0.000E+00, $ ZETL=fiber angle.     Wall type: 2, Layer:  2
 1  $ LSO = 1 means print stresses this layer.   END K-2 rec.
 3, $ ITAW = wall configuration number.        BEGIN K-1 rec.
 1, $ KWALL = 1 means general layered wall (composite layup)
  1,$ NLAY = number of layers thru the thickness
 0, $ NLIP = 0 means properties are uniform within each layer
 0  $ NSMRS= 0 means no smeared stiffeners.      END K-1 rec.
 1, $ MATL=layer matl no.   Wall type: 3, Layer:  1   BEGIN K-2 rec.
 4.430E-02, $ TL  =layer thickness. Wall type: 3, Layer:  1
 0.000E+00, $ ZETL=fiber angle.     Wall type: 3, Layer:  1
 1  $ LSO = 1 means print stresses this layer.   END K-2 rec.
 4, $ ITAW = wall configuration number.        BEGIN K-1 rec.
 1, $ KWALL = 1 means general layered wall (composite layup)
  1,$ NLAY = number of layers thru the thickness
 0, $ NLIP = 0 means properties are uniform within each layer
 0  $ NSMRS= 0 means no smeared stiffeners.      END K-1 rec.
 1, $ MATL=layer matl no.   Wall type: 4, Layer:  1   BEGIN K-2 rec.
 6.579E-02, $ TL  =layer thickness. Wall type: 4, Layer:  1
 0.000E+00, $ ZETL=fiber angle.     Wall type: 4, Layer:  1
 1  $ LSO = 1 means print stresses this layer.   END K-2 rec.
 5, $ ITAW = wall configuration number.        BEGIN K-1 rec.
 1, $ KWALL = 1 means general layered wall (composite layup)
  1,$ NLAY = number of layers thru the thickness
 0, $ NLIP = 0 means properties are uniform within each layer
 0  $ NSMRS= 0 means no smeared stiffeners.      END K-1 rec.
 2, $ MATL=layer matl no.   Wall type: 5, Layer:  1   BEGIN K-2 rec.
 1.171E+01, $ TL  =layer thickness. Wall type: 5, Layer:  1
 0.000E+00, $ ZETL=fiber angle.     Wall type: 5, Layer:  1
 1  $ LSO = 1 means print stresses this layer.   END K-2 rec.
    1,0,0,0,    0.0000    0.0000    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    2,0,0,0,    0.0000    1.6872    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    3,0,0,0,    0.0000    3.3744    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    4,0,0,0,    0.0000    4.0000    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    5,0,0,0,    0.0000    4.6256    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    6,0,0,0,    0.0000    4.0000    0.6154   11  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    0.0000    1.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    7,0,0,0,    0.0000    4.0000    1.2308   11  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    0.0000    1.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    8,0,0,0,    0.0000    3.6690    1.2308  111  111, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    9,0,0,0,    0.0000    4.3310    1.2308  111  111, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
   10,0,0,0,    0.0000    6.3128    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
   11,0,0,0,    0.0000    8.0000    0.0000   10  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2


              (LINES SKIPPED IN ORDER TO SAVE SPACE)


  960,0,0,0,   30.0000   22.3128    0.0000  110  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
  961,0,0,0,   30.0000   24.0000    0.0000  110  110, 1 $ IUPT,XP,YP,ZP,..S-1
 1.,0.,0., 0.,    1.0000    0.0000 $ XAX,XAY,XAZ; YAX,YAY,YAZ: S-2
    1   32   33    2  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
    2   33   34    3  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
    3   34   35    4  411    2,0.,    0.0294,0,0,1,1 $ N1,N2,N3,N4,..T-4
    4   35   36    5  411    2,0.,    0.0294,0,0,1,1 $ N1,N2,N3,N4,..T-4
    4   35   37    6  410    3,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
    6   37   38    7  410    3,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
    8   39   38    7  410    4,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
    7   38   40    9  410    4,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
    5   36   41   10  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
   10   41   42   11  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
   11   42   43   12  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4

  
             (LINES SKIPPED IN ORDER TO SAVE SPACE)


  920  951  952  921  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  921  952  953  922  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  922  953  954  923  411    2,0.,    0.0294,0,0,1,1 $ N1,N2,N3,N4,..T-4
  923  954  955  924  411    2,0.,    0.0294,0,0,1,1 $ N1,N2,N3,N4,..T-4
  923  954  956  925  410    3,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  925  956  957  926  410    3,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  927  958  957  926  410    4,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  926  957  959  928  410    4,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  924  955  960  929  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
  929  960  961  930  410    1,0.,    0.0000,0,0,1,1 $ N1,N2,N3,N4,..T-4
 5, $ NSYS = no. of load systems (Nx,Ny,Nxy,v,P) BEGIN U-1
 0, $ NICS = 0 means zero sets of initial conditions
 0  $ NAMS = 0 means zero attached masses.         END U-1
 1,   31, 0 $ ISYS=1=LoadSet A;NN=U-3 records;IFLG=0=carddata. U-2
-4.218E+02  1 1  931 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
-8.436E+02  1 1  932 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
-5.782E+02  1 1  933 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
-3.128E+02  1 1  934 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
-5.782E+02  1 1  935 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
 0.000E+00  1 1  936 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
 0.000E+00  1 1  937 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
 0.000E+00  1 1  938 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
 0.000E+00  1 1  939 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
-8.436E+02  1 1  940 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3
-8.436E+02  1 1  941 0 0 $ Nx,LT,LD,LN,LE,LAX (applied Nx) U-3


      (LINES SKIPPED IN ORDER TO SAVE SPACE)


 1,    0, 0 $ ISYS=1=LoadSet A;NN=U-3 records;IFLG=0=carddata. U-2
 1,   62, 0 $ ISYS=1=LoadSet A;NN=U-3 records;IFLG=0=carddata. U-2
-2.500E+02  1 1    1 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1   32 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1   63 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1   94 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1  125 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3


         (LINES SKIPPED IN ORDER TO SAVE SPACE)


-5.000E+02  1 1  807 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1  838 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1  869 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.000E+02  1 1  900 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-2.500E+02  1 1  931 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 2.500E+02  1 1   31 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1   62 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1   93 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1  124 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1  155 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3


       (LINES SKIPPED IN ORDER TO SAVE SPACE)


 5.000E+02  1 1  837 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1  868 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1  899 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 5.000E+02  1 1  930 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 2.500E+02  1 1  961 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 1,   62, 0 $ ISYS=1=LoadSet A;NN=U-3 records;IFLG=0=carddata. U-2
-4.218E+02  1 2    1 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-8.436E+02  1 2    2 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.782E+02  1 2    3 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-3.128E+02  1 2    4 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-5.782E+02  1 2    5 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 0.000E+00  1 2    6 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 0.000E+00  1 2    7 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 0.000E+00  1 2    8 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
 0.000E+00  1 2    9 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-8.436E+02  1 2   10 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3
-8.436E+02  1 2   11 0 0 $ Nxy,LT,LD,LN,LE,LAX (applied Nxy) U-3


       (LINES SKIPPED IN ORDER TO SAVE SPACE)


 1,  961, 0 $ ISYS=1=LoadSet A;NN=U-3 records;IFLG=0=carddata. U-2
 4.218E+00  1 3    1 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 8.436E+00  1 3    2 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 5.782E+00  1 3    3 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 3.128E+00  1 3    4 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 5.782E+00  1 3    5 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3    6 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3    7 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3    8 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3    9 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 8.436E+00  1 3   10 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 8.436E+00  1 3   11 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3


          (LINES SKIPPED IN ORDER TO SAVE SPACE)


 5.782E+00  1 3  953 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 3.128E+00  1 3  954 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 5.782E+00  1 3  955 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3  956 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3  957 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3  958 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 0.000E+00  1 3  959 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 8.436E+00  1 3  960 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
 4.218E+00  1 3  961 0 0 $ P,LT,LD,LN,LE,LAX (applied pressure p) U-3
  0, $ IPRD = 0 means do not print displacements.   BEGIN V-1
  0, $ IPRR = 1 means stress resultants printed every step
  0, $ IPRE = 0 means do not print strains
  0, $ IPRS = 0 means do not print stresses
  0, $ IPRP = 0 means no additional output for pts. with yield
  0, $ IPRF = 0 means do not print nodal point forces
  0, $ NSELD= number of records defining selected displacements
  0, $ NSELS= number of records defining selected stresses
  0, $ IPRSDP=print selected disp. every IPRSDPth load step
  0, $ IPRSTR=print selected stresses every IPRSTRth load step
  1, $ ISL  = 1 means element stuff at integ. points is output
  0, $ ISS  = 0 means no transverse shear stresses are calc.
  1  $ ISD  = 1 means stresses in material coords.   END V-1
 ******************** END OF THE TEE.INP FILE ************************



A typical <NAME>.PPN file, which can be used as input data for the
STAGS postprocessor POSTP follows:

 *********************** TEE.PPN FILE FOLLOWS ************************
 STAGS INPUT FROM PANDA2 OUTPUT FOR CASE: TEE
  1  $ NSTEPS=number of load or time steps for POSTP.  PP-2 rec.
  0  $ ISTART=load step number for postprocessing via POSTP. PP-3
  1, $ IPRD = 1 means print displacements.             BEGIN PP-4
  1, $ IPRR = 1 means stress resultants printed every step
  0, $ IPRE = 0 means do not print strains
  0, $ IPRS = 0 means do not print stresses
  0, $ IPRP = 0 means no additional output for pts. with yield
  0, $ IPRF = 0 means do not print nodal point forces
  0, $ NSELD= number of records defining selected displacements
  0, $ NSELS= number of records defining selected stresses
  0, $ IPRSDP=print selected disp. every IPRSDPth load step
  0, $ IPRSTR=print selected stresses every IPRSTRth load step
  1, $ ISL  = 1 means element stuff at integ. points is output
  0, $ ISS  = 0 means no transverse shear stresses are calc.
  1  $ ISD  = 1 means stresses in material coords.   END PP-4
 ********************* END OF THE TEE.PPN FILE **********************



STAGSUNIT: This processor executes the FORTRAN program called
           stagun.src. Please see ref. [15h] for more details:
    [15h] David Bushnell and Charles C. Rankin, Optimization of perfect and
    imperfect ring and stringer stiffened cylindrical shells with PANDA2 and
    evaluation of optimum designs with STAGS, AIAA 43rd SDM Meeting, April
    2002, AIAA Paper 2002-1408.

           STAGS models with both rings and stringers and either rings
           or stringers, or unstiffened can be handled.

           LIMITATION: Only blades, Tees, Zees, Jays, Is can be handled.
                       Panel must be cylindrical. May be a closed
                       cylindrical shell (360 degees of circumference)
                       or a part of a cylindrical shell.

           For more details see ...panda2/case/sdm43 and Ref [15h].



XII. New types of analysis with PANDA2: ITYPE=4 and ITYPE=5

ITYPE = 4: design sensitivity analysis.  See ITEM 103 in the file
           PANDA2.NEWS

ITYPE = 5: interaction curves for in-plane loads.  See ITEM 106 in
           the file PANDA2.NEWS



XIII New processor AUTOCHANGE and procedure SUPEROPT

See ITEMS 151 and 152 in PANDA2.NEWS for details.  The purpose is to
make it easier to search for global optimum designs.

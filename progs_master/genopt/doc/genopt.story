GENOPT - - A PROGRAM THAT WRITES USER-FRIENDLY OPTIMIZATION CODE

                     David Bushnell

Consulting Scientist, Dept. 93-30/251, Lockheed Palo Alto Research,
3251 Hanover Street, Palo Alto, California, 94304, Tel: (415)424-3237


An abridged version of this file appears as follows:

 D. Bushnell, "A program that writes user-friendly optimization code",
 INTERNATIONAL JOURNAL OF SOLIDS AND STRUCTURES, Vol. 26, No. 9/10,
 pp 1173-1210, 1990. This paper is dedicated to the memory of
 Professor Charles D. Babcock of the California Institute of Technology.


                         ABSTRACT

The purpose of GENOPT (GENeral OPTimization) is to enable an engineer
to create, more or less automatically, a user-friendly system of
programs for analyzing and/or optimizing something. The application
of GENOPT is not limited to the field of structural mechanics. GENOPT
is designed to handle problems with small data bases, not large
finite element models, although it might well be used to provide a
user-friendly ``shell'' within which any analysis could be done. GENOPT
is ideal for generating programs for optimizing things the behavior
(stress, buckling, vibration, etc.) of which can be expressed by
relatively simple tables or formulas such as those that appear in
Roark's handbook [1], or for optimizing things the behavior of which
has been previously encoded in existing subroutines.  The optimizer
used in GENOPT is called ADS, and was written by Vanderplaats [2].
It is based on the method of feasible directions [3].  Two examples
are presented, one relatively simple, the other more complex. 


                        INTRODUCTION

When engineers embark on the task of designing something that must
survive certain environments during service, they often develop or
use computer programs that analyze given, fixed configurations. If,
under the various applied loads, a configuration appears to be
inadequate, certain dimensions, materials, or other parameters are
changed by the engineer and the analysis is repeated. The design
evolves by means of this ``manual'' iterative process, which may
require the expenditure of much labor and the passage of many days.
Should a certain configuration prove satisfactory, that is, should
the analysis program or programs show that this configuration
survives all the environments with adequate margins of safety, the
engineer is sorely tempted to terminate the iteration process and
accept the design even though, while adequate, it may not be optimum.

The step from simple analysis to automated optimization seems to be a
difficult one for many engineers and their managers. In every field
there are many proven computer programs that analyze things with
given configurations and given environments.  Therefore, workers in a
field are willing to accept the results of computerized analyses and
to use these results as a basis for decisions on what to do next.
However, these engineers and managers often seem less willing at
present to allow the computer to make decisions about how the
dimensions and other properties of the configuration are to be
changed in order to minimize cost, minimize weight, or meet some
other objective. Entering the field of automated optimization seems
scary and appears to require mathematical expertise not available in
time to meet the goals of a design project. 

The main purpose of GENOPT is to make this step into the world of
automated optimization easy.  If the engineer has formulas, design
curves, and/or algorithms for predicting the behavior of given
configurations, GENOPT, working with these analysis tools, will
generate a program system that can find the ``best'' design in a
user-friendly way.  The user of GENOPT does not need to know much
about optimization as a mathematical discipline.  The user does need
to know:

1. what types of behavior should be included in the analysis,

2. what allowable should be assigned to each type of behavior,

3. what factor of safety should be assigned to each type of behavior,

4. what the objective of the optimization is. 

Over the past several years the writer has developed several program
systems written in FORTRAN that allow the user to analyze and
optimize certain kinds of structures [4]-[9]. These program systems
have a similar style and structure.  In a preprocessor, usually
called ``BEGIN'', the user is asked in an interactive mode to supply a
starting design, material properties, boundary conditions, and loads.
In a second processor called ``DECIDE'' the user is asked in an
interactive mode to choose decision variables, lower and upper bounds
of decision variables, linked variables, and something called
``escape'' variables (variables that are iteratively increased in size
by ten per cent per iteration until optimization via ADS takes
over). Then in a third processor called ``MAINSETUP'' the user is
asked in an interactive mode to provide certain strategy parameters
for the batch-mode analysis to follow. Finally, the user launches a
batch run involving a mainprocessor.  If the problem is an
optimization problem, this batch run will yield a new design. Three
of the program systems [6-8] have a ``CHANGE'' processor which permits
the user to assign new values to certain of the variables without
having to run a case from ``BEGIN''.  The three program systems [6-8]
have in common a user-friendly feature that definitions of the data
appear throughout the output so that this output is easy to
understand. 

Recently the idea occurred to the writer, why not make it easy for
the engineer to develop analysis/optimization program systems that
have a similar user-friendly style and structure?  Why not write a
``master'' computer program that, eliciting certain information from
its user, generates program systems that perform tasks analogous to
those performed by the program systems described in [6-9], tasks that
are defined by the user of this ``master'' program? 

This paper describes the implementation of this idea.


                     ROLES OF USERS

TWO TYPES OF USER

There are two types of user that are involved here, called ``GENOPT
user'' and ``end user''.  The GENOPT user conceives of a generic class
of things for which a user-friendly (``end user''-friendly) analysis
and/or optimization code is needed. He or she decides what types of
behavior must be accounted for, from where should program coding be
obtained to predict these types of behavior, what input data are
needed, what name, definition, and ``help'' paragraph should be
assocated with each input datum, and how the input data should be
organized.  If the GENOPT user performs these tasks well, GENOPT
generates a user-friendly program system that will yield well
documented, reliable analyses and/or optimum designs.  The end user
finds optimum designs of specific items that fit within the generic
class conceived by the GENOPT user.  The next two subsections provide
more details on the roles of each of these two types of user.  It is
expected that the end user will often be the same person as the
GENOPT user. Both type of user are GENOPT users in a literal sense:
they both use GENOPT.  However, they use GENOPT in different ways, as
listed in Tables 1 and 2. 


ROLE OF THE GENOPT USER

1. Choose a generic class of problems for which an analysis and/or
optimization program is needed. This class should not be so narrow as
to be practically useless, nor should it be so broad that the end
product is difficult to use or overly expensive to run. 

2. Decide which phenomena (behaviors) may affect the design. Since
these behaviors may constrain the design they are commonly termed
``behavioral constraints'' or just ``constraints''.  For example, a
certain structure may experience (a) instability, (b) material
failure, (c) unacceptable modal vibration, (d) unacceptably large
displacement, (f) high drag, (f) violation of clearance tolarances,
etc.  It is very important that every conceivable type of behavior
and contingency be accounted for in order that generation of
impractical designs be avoided. The writer has encountered examples
in which failure to characterize the behavior completely has led to
disappearance of the object as optimization iterations proceed! 

3. Decide what the objective of the optimization is. In the aerospace
industry it is often weight.  In the civil engineering industry it is
often cost. There are of course many other possible objectives.  The
writer has encountered a problem in which the objective was minimum
heat flow [7].  In another problem the objective was minimum
root-mean-squared error of the surface of a mirror [8]. A mixed
objective is possible, with weights assigned to each component of the
objective. 

4. Organize the input data.  For example, are pointers needed? Should
a certain class of item be an array or should each member of this
class be a simple variable with its own unique name?  If a variable
is an array, should it be a one-dimensional or a two-dimensional
array?  In what order should the user be prompted for the input data?
(GENOPT determines this to some extent, as will be seen later.) 

5. Choose (a) a meaningful name, (b) a clear one-line definition,
and, if needed, (c) a supporting ``help'' paragraph or paragraphs for
each input datum. Careful attention to these items will contribute
greatly to the user-friendliness of the program system generated by
GENOPT, since the data names and definitions appear in the output
from this system seen by the end user. 

6. Write or ``borrow'' computer code to calculate the various
behaviors to be included as possible constraints on the design. In
this paper two examples are presented: a simple one in which short
algorithms are written, and a more complex one in which subroutines
are ``borrowed'' from elsewhere and either used directly or modified
and then used. 

7. Test the program system generated by GENOPT. Does the code
introduced in Item 6 work properly?  Are enough behaviors included as
constraining influences on the design?  Are the data names
informative and the data definitions complete enough?  Is there
sufficient ``help'' documentation for a naive end user?  If the end
user looks at the output six months or a year from now will he or she
be able to understand it at once? 

8. Interact with the end user.  If it prooves that additional types
of behavior must be included, incorporate them using the ``INSERT''
command.  (INSERT will be introduced later.) 


ROLE OF THE END USER

1. Choose a specific problem that fits within the generic class
established by the GENOPT user.  For example, it will not do to try
to optimize something in which creep is an important phenomenon if
creep is not part of the ``universe'' conceived by the GENOPT user. 

2. Choose a starting design with appropriate sets of loads and
an allowable and factor of safety for each behavioral constraint.
(This is done in the ``BEGIN'' processor, to be described below.)

3. Choose appropriate decision variables with reasonable lower
and upper bounds. (This is done in the ``DECIDE'' processor, to
be described below.)

4. Choose linked variables and linking expressions (equality
constraints), if any.  (This is done in the ``DECIDE'' processor.)

5. Choose inequality constraint expressions, if any. (Done in
the ``DECIDE'' processor.)

6. Choose ``escape'' variables. These are variables that, when
increased, force the design toward the feasible region. They are
needed sometimes because ADS fails to modify a grossly
unfeasible design. (This is done in ``DECIDE''.)

7. During optimization use enough restarts, iterations, and ``CHANGE''
commands to ensure that a global optimum design has been obtained,
not merely a local optimum.  (The ``CHANGE'' command will be
introduced later.) 

8. Interact with the GENOPT user.  Suggest introduction of new types
of behavior, better data names, definitions, and ``help'' paragraphs.

9. Confirm the appropriateness of the optimum design by detailed
analysis with a general purpose program and/or experiments.


                   PROPERTIES OF GENOPT

The GENOPT program system has the following properties: 

1. An analysis of a fixed design is ``automatically'' converted into
the capability of optimizing that design concept should the end user
wish to do so. 

2. The analysis/optimization problems need not be in fields nor
jargon familiar to the developer of GENOPT.  Although both example
cases are in the field of structural analysis, GENOPT is not limited
to that field. 

3. Input data and textual material are elicited from the GENOPT user
in a general enough way so that he or she can employ whatever data
names, definitions, and ``help'' paragraphs will make subsequent use
of the program system thus generated easy by those less familiar with
the generic class of problems than the GENOPT user.  The data names
and definitions appear in the output of the GENOPT-generated program
system to be used by the end user.  If meaningful data names and
clear definitions and ``help'' paragraphs are supplied by the GENOPT
user, the analysis/optimization capability generated by GENOPT will
be user-friendly for the end user. 

4. GENOPT is a FORTRAN program that writes other FORTRAN programs.
These programs, when augmented by GENOPT-user-supplied coding, form a
menu-driven program system that is user-friendly in the GENOPT-user's
field. In the two examples, (a) and (b), discussed here the GENOPT
user (the writer in this case) had to supply FORTRAN coding that: 

(a) calculates stress, buckling, vibration, and displacement of
rectangular, isotropic flat plates under in-plane loads or pressure,
and 

(b) calculates stress and various kinds of buckling for laminated,
composite, ring and stringer stiffened plates and cylindrical panels
and shells under multiple sets of combined in-plane loading. 

5. The program system generated by GENOPT has the same general
architecture as previous programs written for specific applications
by the developer [4 - 9].  It is driven by a pre-established menu of
commands.  A typical runstream executed by the end user of the
GENOPT-generated program system is: 

       BEGIN       (End user supplies starting design, control
                    integers, material properties, loads,
                    allowables, and factors of safety in
                    an interactive-``help'' mode.)
  
       DECIDE      (End user chooses decision variables, lower
                    and upper bounds of the decision variables,
                    linked variables, inequality constraints
                    based on system dimensions rather than
                    system behavior, and ``escape'' variables.)

       MAINSETUP   (End user chooses output option, whether
                    to perform an analysis of a fixed design
                    or to optimize, and the number of design
                    iterations.)

       OPTIMIZE     (The program system performs, in a batch
                    mode, the work specified in MAINSETUP.)

       CHOOSEPLOT   (End user chooses which variables to plot
                     versus design iterations.)
   
       DIPLOT       (End user obtains plots.)




      THE GENOPT MENU OF COMMANDS AND HOW TO RUN GENOPT

The GENOPT system has a small set of commands.  These are listed in
TABLE 1.  TABLE 2 lists a typical run stream. This is the run stream
used in the first example case.  Two sections are shown in TABLE 2:

1. Section 1 describes what the GENOPT user does.
2. Section 2 describes what the end user does.

Each case has at least two user-assigned names associated with it:

1. The GENOPT user assigns a generic  name;
2. Each  end  user assigns a specific name.


 ARCHITECTURE OF THE GENOPT MAINPROCESSOR AND OPTIMIZATION STRATEGY

Each command ``OPTIMIZE'', which occurs twice in TABLE 2, causes a
batch run of the GENOPT mainprocessor to be launched. The
architecture of this main processor, which is called ``MAIN'', is
depicted in Fig. 1.  It is assumed in Fig. 1 that there are NLOADS
sets of loads for which the object must be designed and the decision
variables have been stored in a vector X of length NDV.  The behavior
of the system being optimized is determined once in SUBROUTINE STRUCT
for the unperturbed design and NDV times, again in SUBROUTINE STRUCT,
for the design in which each of the decision variables X(i) is
perturbed in turn by five per cent [dX(i) = 0.05*ABS(X(i))]. 
Gradients of the behavioral constraints are calculated, yielding a
matrix of numbers with dimensions NCONST x NDV, in which NCONST is
the number of behavioral constraints and NDV is the number of
decision variables. This information is provided in a scaled form as
input to ADS, which derives a new design based on the method of
feasible directions [2,3].  The new design derived by ADS is used
as a new starting design on the left-hand-side of Fig. 1. 
Calculations proceed in this manner until ADS can do no more or
until the maximum number of iterations specified by the end user in
MAINSETUP has been reached. Further iterations are performed by
successive commands ``OPTIMIZE'', as shown in TABLE 2. 

TABLE 2 shows the command ``OPTIMIZE'' being typed twice.  Each
``OPTIMIZE''  run was ``instructed'' by MAINSETUP to permit a maximum
of five design iterations.  One might well ask, ``Why take two sets
of five iterations each, instead of just one set with 10 or more
iterations?'' There are two reasons.  The first is that it is always
a good idea for the user to monitor carefully the output as the
design evolves. Hence, after each set of five iterations the user
should inspect the file NAME.OPM. (In the first example NAME =
PLATE1, as will be seen below). In this way the user ensures that the
intermediate results make sense. 

The second reason has to do with how the optimizer ADS works. 
Figure 2 illustrates the case of two decision variables.  Given the
user's lower and upper bounds of the decision variables, ADS
establishes a more restrictive ``window'' within which the decision
variables are allowed to vary in any given iteration.  The size of
this ``window'' decreases with each design iteration by a factor 0.8. 
These restrictions are placed upon the permitted excursions of the
decision variables in order to prevent wild swings in the design as
it evolves. The example shown in Fig. 2 shows 5 iterations, and the
last design point is labeled ``FINAL DESIGN''. Note that the final
``window'' of permitted excursions is rather small.  To the user it
may appear that design iterations have converged, whereas actually
they may not have.  On the other hand, they really may have
converged.  This can easily be checked simply by executing
``OPTIMIZE'' again.  When this is done, the ``window'' of permitted
excursions is re-expanded to its original size, the new starting
design is the last design obtained in the previous set of iterations,
and new iterations proceed as before. The user should keep executing
``OPTIMIZE'' until the objective does not change very much.  When the
user is satisfied with the current design, he or she should then take
one additional set of design iterations in which the number of
iterations is larger than the number used previously, say twice or
three times as many. 


              SOME ITEMS TO BE AWARE OF

As with any program system, GENOPT has a few ``quirks'' that the user
should be aware of:

1. The objective function must be positive.

2. The version of the optimizer used herein (ADS) does not work if
a decision variable is zero.  In the ``DECIDE'' processor the vector
of decision variables is automatically searched for zero values. If a
zero value is found, the ``DECIDE'' processor ``looks at'' the
corresponding definition of the variable. If the character string
`winding' is found in this definition the value 360.0 is added to the
variable. If the string `winding' is not found the variable is deemed
no longer to be a decision variable. It no longer varies for the
duration of the case unless the ``CHANGE'' processor is used to reset
its value to something different from zero.  In view of this property
of the optimizer, GENOPT users should: 

(a) Use the word `winding' in the definition of fiber angles for
composite laminates and force the end user to provide input for these
angles in degrees, not radians; 

(b) Formulate the generic problems in such a way as to avoid zero
values in the domains of the decision variable candidates the
definitions of which do not contain the character string `winding'. 
The end users should also avoid zero values in the domains of
decision variable candidates, except for variables which are defined
as `winding' angles in laminated composite structures. The program
will probably work even if zero is included in the domain of the
decision variable candidates. However, if a variable approaches zero
it may get "hung up" in that neighborhood because move limits during
optimization cycles are based on percentage change in the variable
from one design iteration to the next. A strategy has been introduced
into a subroutine called VLBVUB (its purpose is to set move limits
for the current design iteration) through which a variable can
"escape" the neighborhood of zero.  However, how well this strategy
works depends upon user-selected lower and upper bounds for that
variable.  It is best to try to define your problem to avoid zero
in the domain of the decision variable candidates.  If this is not
convenient, set wide bounds on any variable for which zero is
included in its domain.

3. It sometimes happens that a starting design is so unfeasible that
more behavioral constraint conditions are violated than the number of
decision variables.  Under certain conditions when this happens,
ADS refuses to predict a new design.  In order to enable the user
to get around this limitation, the writer has introduced the concept
of ``escape variables''.  The ``DECIDE'' processor asks the end user
to identify escape variables.  These are variables such that when
increased ``push'' the design toward the feasible region. There is
a computation loop within the mainprocessor ``OPTIMIZE'' in which
all of the escape variables are increased by ten per cent each time
through the loop until ADS takes over the redesign process.
Almost always thicknesses of parts of a structure are good candidates
for escape variables.  If the thickness of something is increased
its design usually becomes more feasible (even if it may become less
optimum!).  The ``DECIDE'' processor allows the user to choose
escape variables by default. When this choice is made, ``DECIDE''
searches the definitions of the decision variable candidates for the
character string `thickness'. If it finds such a string, and if
that variable has been chosen to be a decision variable, it is
automatically assigned to be one of the escape variables.

4. GENOPT is oriented toward engineering design rather than
mathematical or perhaps what one might call ``academic'' optimization.
Therefore, for feasible designs, the algebraic sign of the behavior
(response) must be the same as that of the allowable.  In the feasible
region the response must be non-zero.  All allowables must be
non-zero. All factors of safety must be positive.  In GENOPT if any
response is found to be zero, it is automatically reset to a value
that will ensure that the corresponding behavioral constraint
condition is far from critical.  Any zero allowables or factors of
safety are automatically reset to unity.  You can always avoid zero
or negative allowables by adding a constant to both sides of the
inequality expression that relates the allowable to the response.

5. There are many optimization problems for which environment (loading)
plays no role.  Yet the GENOPT user must supply at least one
environmental (Role 3) parameter.  The GENOPT user can simply provide
a dummy parameter, using a parameter name, definition, and ``help''
paragraph that makes it clear to the end user how he or she should
respond in BEGIN when asked to supply a value for the dummy environment,
and which makes it clear in the output that a dummy environment is
involved.

6. There are optimization problems for which response (e.g. stress,
buckling, displacement, etc. may play no role. Yet the GENOPT user
must supply at least one response (Role 4) parameter. The GENOPT user
can proceed as described in Item 5.  In GENOPT an allowable and a
factor of safety are always associated with each response. Hence,
a dummy allowable (Role 5) parameter and dummy factor of safety (Role 6)
parameter must be supplied. Again, the GENOPT user can proceed as in
Item. 5.

7. A skeletal subroutine called USRCON is included in the
BEHAVIOR.NEW library in case a GENOPT user should want to provide
a constraint condition which cannot be accommodated within DECIDE
(see TABLE 19) or as a behavioral constraint (see TABLE 11 notes).
It is the writer's intention that this feature be seldom used.
It should be possible to formulate just about any practical
optimization problem in such a way as to avoid the need to use
USRCON.

8. Be aware that a given optimization goal can be formulated in
many different ways.  It may be that the GENOPT user initially
chooses a formulation that does not work well. As a general
guideline, constraints should be formulated so that they have
no poles in the domains of the decision variables and that
zero does not lie within the ranges of the decision variables.


         EXAMPLE 1:  MINIMUM WEIGHT DESIGN OF A PLATE
            PART 1:  TASKS PERFORMED BY THE GENOPT USER

STATEMENT OF THE PROBLEM

This case is a bit contrived. However, it demonstrates a relatively
simple use of GENOPT.  The problem is to find the minimum weight
design of an isotropic, rectangular flat plate simply supported along
all four edges. The plate is subject to the following environments,
each applied separately: 

(1) Uniform axial compression,

(2) Uniform in-plane shear,

(3) Uniform normal pressure.

These separate loadings might represent environments seen by the
structure during different phases of its operation.


The following behavioral constraints apply:

(1) The maximum effective stress in the plate shall not exceed an
allowable value to be specified by the end user; 

(2) The plate is not allowed to buckle under the axial compression or
under the in-plane shear loads to be specified by the end user; 

(3) The minimum natural frequency of the unloaded plate must be
greater than an allowable value to be specified by the end user; 

(4) The maximum normal deflection of the plate under uniform normal
pressure to be specified by the end user shall not exceed an
allowable value to be specified by the end user. 


The following constraints on the geometry of the plate will be
imposed by the end user in the interactive ``DECIDE'' session: 

(1) The area of the plate shall not exceed 100 (units)**2;

(2) The area of the plate shall not be less than 50 (units)**2;

(3) The variable LENGTH shall be greater than the variable WIDTH.
(The names LENGTH and WIDTH and their definitions will be
established by the GENOPT user.) 

This problem is defined and solved by the runstream given in
TABLE 2.


PREPARATION FOR THE ``GENTEXT'' INTERACTIVE SESSION

FINDING MODELS FOR PREDICTING BEHAVIOR OF THE PLATE: The first task
in solving the problem just stated is to find predictors for the four
behavioral constraints listed above. In this case Roark [1] has
formulas for buckling of rectangular, isotropic, simply supported
plates under uniform axial compression (Table XVI, Entry No. 1) and
under uniform in-plane shear (Table XVI, Entry No. 10).  For uniform
axial compression the critical axial stress resultant Nx(cr) (stress
resultant Nx = stress*thickness) is given by: 

   Nx(cr) = K*[E*t/(1-nu**2)]*(t/b)**2                  (1)

in which K is a coefficient that depends on the length/width ratio
a/b of the plate; E is the elastic modulus of the plate material;
t is the plate thickness; nu is the material Poisson ratio; and
b is the width of the plate.  Roark gives a table of K values v.
a/b.  The critical in-plane shear resultant Nxy(cr) has the same
form as Eq. (1).  The coefficient K depends on a/b in a different
way from that for axial compression. Roark gives a table of K vs a/b
for shear buckling in Entry No. 10 of Table XVI.  Since the Roark
formulas are to be used in this case, the GENOPT user will have
to introduce arrays of constant parameters:

(1) K1(i) and  ALPHA1(i) for axial compression buckling coefficients;
(2) K2(j) and  ALPHA2(j) for in-plane shear buckling coefficients,

in which K1 and K2 represent K in Eq. (1), and ALPHA1 and ALPHA2
represent the plate aspect ratios a/b for which Roark gives K in
Entries 1 and 10, respectively, of Table XVI in [1].  The GENOPT
user will also have to use an interpolating routine to calculate
K for values of a/b between the discrete values given in Roark.
In this case a subroutine INTERP, which is located in the UTIL.NEW
library, is used.  The algorithms for compression and shear
buckling appear in TABLE 14(b).  The GENOPT user must set the
maximum permitted values of the indices i and j large enough to
give an end user reasonable freedom to use tabular data from any
source, perhaps from design curves available to him or her.

The paragraphs on the axial and shear buckling behaviors are
an important ingredient of this example because they illustrate
how design curves would be used as input to GENOPT for automated
optimization of systems for which graphical or tabular design data
are available.

Roark [1] also gives formulas for the maximum stress and normal 
deflection of rectangular, isotropic, simply supported plates under
uniform normal pressure (Table X, Entry No. 36).  Formulas for
the maximum stress appear in TABLE 14(a) and for maximum normal
deflection in TABLE 14(d).

Leissa [10] gives a formula for the fundamental vibration
frequency of a simply supported, isotropic, rectangular plate.
The formula appears in TABLE 14(c).

The objective function, WEIGHT, is simply
 
  WEIGHT = (weight density) * a * b * t                         (2)


ORGANIZING AND DECIDING ON NAMES FOR THE INPUT DATA: 
As listed in TABLE 2, GENTEXT forces the GENOPT user to classify
generic problem data into seven categories or roles.  TABLE 3 lists
these roles and shows the data names that the GENOPT user decided to
use in this example. The definitions of each datum appear in TABLE 7
and some supporting ``help'' paragraphs appear in TABLE 8. 


THE ``GENTEXT'' INTERACTIVE SESSION

The following is a list (somewhat abridged to save space) of part of
the interactive session initiated when the GENOPT user types the
command ``GENTEXT'': 


************ BEGINNING OF INTERACTIVE ``GENTEXT'' SESSION ************
$ GENTEXT

    ENTER THE GENERIC CASE NAME:  PLATE

ARE YOU CORRECTING, ADDING TO, OR USING  PLATE.INP ? (y or n): n

You have chosen the following name for this case:  PLATE.
Henceforth, this will be called the ``generic'' name. After you
have completed your tasks in GENOPT, you and other users
will be able to optimize specific things that fit within the
class of optimization problems that you have called PLATE.

Your tasks in GENOPT are:
    1. To provide variable names, definitions and helping
       paragraphs that will make it easy for others to
       optimize things that fit within the problem class PLATE.

    2. To complete subroutines BEHX1, BEHX2, BEHX3,. . .BEHXn
       which calculate PLATE behavior for a given design;
       SUBROUTINE OBJECT, which calculates the objective to
       be minimized; and/or to add any other subroutines,
       common blocks, utilities, etc. that you may wish.

    3. To compile and collect all pertinent software that
       both you and GENOPT have written in order to generate
       the absolute elements:  BEGIN.EXE, DECIDE.EXE,
       MAINSETUP.EXE, OPTIMIZE.EXE, CHANGE.EXE, STORE.EXE,
       CHOOSEPLOT.EXE, and DIPLOT.EXE.

CHOOSE STARTING PROMPT INDEX (integer from 1 to 10. Try 5): 5
CHOOSE INCREMENT FOR PROMPT INDEX (integer from 1 to 10. Try 5): 5
CHOOSE: 0  or  1:
  (0 means ``introductory explanatory text'')
  (1 means ``one-line input datum prompt'')
CHOOSE: 0  or  1: 1

You will next be asked to provide information
about a new variable that will play a role in your program.
The following items relative to this new variable will be
asked of you:
  1. A name of the variable (six characters or less).
  2. The role of the variable in your program.
  3. Is the variable an array? (If yes, give number of rows,
     NROWS and columns, NCOLS.)
  4. A one-line definition of the variable.
  5. Do you want to include a ``help'' paragraph that explains
     more about the variable than the one-line definition?
  6. If you answer 5. with Y, you provide a help paragraph.

Hit RETURN.
<cr>
The variable can have one of the following roles:
  1 = a possible decision variable for optimization,
      typically a dimension of a structure.
  2 = a constant parameter (cannot vary as the design evolves),
      typically a control integer or a material property,
      but not a load, allowable, or factor of safety,
      which are asked for later.
  3 = a parameter characterizing the environment, such
      as a load component or a temperature.
  4 = a quantity that describes the response of the
      structure, (e.g. stress, buckling load, frequency)
  5 = an allowable, such as maximum allowable stress,
      minimum allowable frequency, etc.
  6 = a factor of safety
  7 = the quantity that is to be minimized (e.g. weight)


PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): THICK
IDENTIFY ROLE OF  THICK (1 or 2 or 3 or 4 or 5 or 6 or 7): 
  1 = decision variable candidate(e.g.length, width, thickness)
  2 = fixed parameter (e.g. control integer, material property)
  3 = environmental factor (e.g. load, temperature)
  4 = response quantity (e.g. stress, buckling load, frequency)
  5 = allowable (e.g. maximum stress, minimum frequency)
  6 = factor of safety
  7 = objective (e.g. minimum weight, minimum cost)
CHOOSE:  1  or  2  or  3  or  4  or  5  or  6  or  7: 1
Is the variable  THICK   an array? n
PROVIDE A DEFINITION FOR  THICK.  (LESS THAN 60 CHARACTERS!)
thickness of the plate
THICK = thickness of the plate
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n
ANY MORE DECISION VARIABLE CANDIDATES     (ROLE 1 VARIABLES) 
   OR    FIXED PARAMETERS (e.g. material) (ROLE 2 VARIABLES)? y



      (MANY LINES SKIPPED IN ORDER TO SAVE SPACE)

  
  
CHOOSE AN ENVIRONMENTAL PARAMETER (load)   (ROLE 3 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 0
PROVIDE INTRODUCTORY EXPLANATORY TEXT
NEXT, PROVIDE ALL ENVIRONMENTAL PARAMETERS (LOADS, TEMPERATURES)
ANY MORE LINES IN THIS PARAGRAPH? (y  or  <cr> or  n): n
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): Nx
IDENTIFY ROLE OF  Nx (1 or 2 or 3 or 4 or 5 or 6 or 7): 
  1 = decision variable candidate(e.g.length, width, thickness)
  2 = fixed parameter (e.g. control integer, material property)
  3 = environmental factor (e.g. load, temperature)
  4 = response quantity (e.g. stress, buckling load, frequency)
  5 = allowable (e.g. maximum stress, minimum frequency)
  6 = factor of safety
  7 = objective (e.g. minimum weight, minimum cost)
CHOOSE:  1 or 2 or 3 or 4 or 5 or 6 or 7: 3
PROVIDE A DEFINITION FOR  Nx.  (LESS THAN 60 CHARACTERS!)
Axial tension per unit width of the plate (lb/in)
Nx = Axial tension per unit width of the plate (lb/in)
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y or n): y
PROVIDE HELP PARAGRAPH TO EXPLAIN INPUT
NOTE:  Nx must be negative for axial compression!
ANY MORE LINES IN THIS PARAGRAPH? (y  or  <cr> or  n): n
ANY MORE ENVIRONMENTAL PARAMETERS (loads) (ROLE 3 VARIABLES)? y




     (MANY LINES SKIPPED IN ORDER TO SAVE SPACE) 


  
  
CHOOSE A RESPONSE PARAMETER (e.g. stress)  (ROLE 4 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): FREQ
IDENTIFY ROLE OF  FREQ (1 or 2 or 3 or 4 or 5 or 6 or 7): 
  1 = decision variable candidate(e.g.length, width, thickness)
  2 = fixed parameter (e.g. control integer, material property)
  3 = environmental factor (e.g. load, temperature)
  4 = response quantity (e.g. stress, buckling load, frequency)
  5 = allowable (e.g. maximum stress, minimum frequency)
  6 = factor of safety
  7 = objective (e.g. minimum weight, minimum cost)
CHOOSE:  1 or 2 or 3 or 4 or 5 or 6 or 7: 4
FREQ is an array with the number of rows equal to 20 .
  Each row corresponds to a load case. Max. of 20 load cases permitted.
  Do you want to reset the number of columns in FREQ?
  In this case, if you answer ``no'' FREQ would be dimensioned FREQ(20).
Do you want to reset the number of columns in FREQ? n
PROVIDE A DEFINITION FOR  FREQ.  (LESS THAN 60 CHARACTERS!)
Fundamental frequency of unloaded plate
FREQ = Fundamental frequency of unloaded plate
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n
  
CHOOSE AN ALLOWABLE FOR FREQ (ROLE 5 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): MINCPS
IDENTIFY ROLE OF  MINCPS (1 or 2 or 3 or 4 or 5 or 6 or 7): 5
  MINCPS is an array with the number of rows equal to 20 .
  Each row corresponds to a load case.
PROVIDE A DEFINITION FOR  MINCPS.  (LESS THAN 60 CHARACTERS !)
Minimum allowable value for the fundamental frequency
MINCPS = Minimum allowable value for the fundamental frequency
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n
  
CHOOSE FACTOR OF SAFETY FOR FREQ (ROLE 6 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): FSFREQ
IDENTIFY ROLE OF  FSFREQ (1 or 2 or 3 or 4 or 5 or 6 or 7): 6
  FSFREQ is an array with the number of rows equal to 20 .
  Each row corresponds to a load case.
PROVIDE A DEFINITION FOR  FSFREQ.  (LESS THAN 60 CHARACTERS !)
Factor of safety for FREQ
FSFREQ = Factor of safety for FREQ
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n

ACTUAL RESPONSE    = BEHAV = Fundamental frequency of unloaded
                             plate = FREQ
ALLOWABLE RESPONSE = ALLOW = Minimum allowable value for the
                             fundamental frequency = MINCPS
FACTOR OF SAFETY   = FSAFE = Factor of safety for FREQ = FSFREQ

There are two types of behavioral constraint
conditions in an optimization problem:

   1  For a feasible design the allowable response, ALLOW
      must be greater than the product of the actual
      response, BEHAV, times its factor of safety, FSAFE.
      EXAMPLE: Allowable stress must be greater than the actual
               stress x the factor of safety for stress.

   2  For a feasible design the actual response, BEHAV, must
      must be greater than the product of the allowable
      response, ALLOW, times the factor of safety, FSAFE.
      EXAMPLES: (a) buckling load factor must be greater than
                    the allowable value x the factor of safety
                    for buckling.
                (b) lowest natural frequency must be greater
                    than the allowable value x the factor of
                    safety for the natural frequency.

PLEASE CHOOSE  1  OR  2  FOR THIS CONSTRAINT (FREQ) : 2
ANY MORE RESPONSE VARIABLES (e.g.buckling) (ROLE 4 VARIABLES)? y
  
CHOOSE ANOTHER RESPONSE VARIABLE           (ROLE 4 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): W
IDENTIFY ROLE OF  W (1 or 2 or 3 or 4 or 5 or 6 or 7): 4
  W is an array with the number of rows equal to 20 .
  Each row corresponds to a load case.
  Do you want to reset the number of columns in W?
  In this case, if you answer ``no'' W would be dimensioned W(20).
Do you want to reset the number of columns in W? n
PROVIDE A DEFINITION FOR  W.  (LESS THAN 60 CHARACTERS !)
Normal deflection under uniform pressure
W = Normal deflection under uniform pressure
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n
  
CHOOSE AN ALLOWABLE FOR W (ROLE 5 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): AW
IDENTIFY ROLE OF  AW (1 or 2 or 3 or 4 or 5 or 6 or 7): 5
  AW is an array with the number of rows equal to 20 .
  Each row corresponds to a load case.
PROVIDE A DEFINITION FOR  AW.  (LESS THAN 60 CHARACTERS !)
Maximum allowable normal deflection under pressure
AW = Maximum allowable normal deflection under pressure
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n
  
CHOOSE FACTOR OF SAFETY FOR W (ROLE 6 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): FW
IDENTIFY ROLE OF  FW (1 or 2 or 3 or 4 or 5 or 6 or 7): 6
  FW is an array with the number of rows equal to 20 .
  Each row corresponds to a load case.
PROVIDE A DEFINITION FOR  FW.  (LESS THAN 60 CHARACTERS !)
Factor of safety for max deflection under pressure
FW = Factor of safety for max deflection under pressure
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n

ACTUAL RESPONSE    = BEHAV = Normal deflection
                             under uniform pressure =   W
ALLOWABLE RESPONSE = ALLOW = Maximum allowable normal deflection
                             under pressure         =  AW
FACTOR OF SAFETY   = FSAFE = Factor of safety for max deflection
                             under pressure         =  FW

There are two types of behavioral constraint
conditions in an optimization problem:

   1  For a feasible design the allowable response, ALLOW
      must be greater than the product of the actual
      response, BEHAV, times its factor of safety, FSAFE.

   2  For a feasible design the actual response, BEHAV, must
      must be greater than the product of the allowable
      response, ALLOW, times the factor of safety, FSAFE.

PLEASE CHOOSE  1  OR  2  FOR THIS CONSTRAINT (W) : 1
ANY MORE RESPONSE VARIABLES (e.g.buckling) (ROLE 4 VARIABLES)? n
  
CHOOSE AN OBJECTIVE (e.g. minimum weight)  (ROLE 7 VARIABLE).
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 0
PROVIDE INTRODUCTORY EXPLANATORY TEXT
LAST, AN OBJECTIVE MUST BE CHOSEN, SUCH AS MINIMUM WEIGHT
ANY MORE LINES IN THIS PARAGRAPH? (y  or  <cr> or  n): y
OR MINIMUM COST.
ANY MORE LINES IN THIS PARAGRAPH? (y  or  <cr> or  n): n
CHOOSE: 0=introductory text   or  1=one-line input datum prompt: 1
PROVIDE A NAME FOR THE VARIABLE (6 or less characters, CAPS): WEIGHT
IDENTIFY ROLE OF  WEIGHT (1 or 2 or 3 or 4 or 5 or 6 or 7): 7
CHOOSE:  1 or 2  or  3  or  4  or  5  or  6  or  7: 7
PROVIDE A DEFINITION FOR  WEIGHT.  (LESS THAN 60 CHARACTERS !)
Weight of the plate
WEIGHT = Weight of the plate
DO YOU WANT TO INCLUDE A ``HELP'' PARAGRAPH? (y  or  n): n
 
  
  DUMMY ENTRY WRITTEN AT END OF PLATE.PRO       
  
  STOGET.NEW HAS BEEN CREATED.
  BEGIN.NEW HAS BEEN CREATED.
  STRUCT.NEW HAS BEEN CREATED.
  BEHAVIOR.NEW HAS BEEN CREATED.
  CHANGE.NEW HAS BEEN CREATED.


Next, if necessary, provide the algorithms called for in the
skeletal subroutines listed in the library BEHAVIOR.NEW. (You
may find useful routines in the library UTIL.NEW. In this
example a linear interpolator, INTERP, is used in BEHX2.)

Or, if necessary, complete the skeletal routines STRUCT and
TRANFR.  (You may find useful routines in UTIL.NEW.)
If you are adding subroutine calls to SUBROUTINE STRUCT or
SUBROUTINE TRANFR, store the subroutines themselves in
the libraries called ADDCODEn.NEW, n = 1,2,3,...5. (Please
list one of the ADDCODEn.NEW libraries for instructions.)
Please see the case called PANEL for an example.

After you have done this,  give the command GENPROGRAMS.
GENPROGRAMS will generate the absolute elements needed to
optimize whatever you have chosen as your objective (see
OBJECT routine in BEHAVIOR.NEW) in the presence of whatever
behavior or other factors (e.g. clearance) are quantified by
user-written subroutines collected in the libraries
ADDCODEn.NEW  and/or algorithms added to the skeletal
routines in the library BEHAVIOR.NEW .

PLEASE PRINT OUT THE FILE PLATE.DEF IN ORDER TO OBTAIN A
SUMMARY OF THE PURPOSES OF GENOPT, PROGRAM VARIABLE NAMES,
DEFINITIONS, ROLES, AND OTHER USEFUL INFORMATION FOR WORK
THAT YOU MUST DO NEXT.  THE INSTRUCTIONS JUST GIVEN ARE
REPRODUCED IN THE FILE  PLATE.DEF  .

************ END OF THE ``GENTEXT'' INTERACTIVE SESSION ************



FILES PRODUCED BY THE INTERACTIVE ``GENTEXT'' SESSION

As the interactive ``GENTEXT'' session proceeds, a file called
PLATE.INP is being generated.  This file contains an annotated list
of the GENOPT user's input to GENTEXT.  It is very useful if the
GENOPT user makes a mistake during the interactive session. If this
happens, the GENOPT user can terminate the session at once, edit the
PLATE.INP file to correct any errors in it, and restart GENTEXT,
indicating that he or she is using the existing PLATE.INP file as
input.  The GENTEXT session will use the PLATE.INP file as input
until the end of this file, at which point GENTEXT will return
control to the GENOPT user, who finishes the GENTEXT session by
providing additional input data interactively from his/her terminal. 

Part of the PLATE.INP file is listed in TABLE 4.  In addition to
being useful in case the GENOPT user errs during GENTEXT, this file
is used by INSERT, a processor that the GENOPT user employs to insert
additional parameters he/she overlooked at first and now feels should
be included.  The integers preceeded by dollar signs on the
right-hand-ends of certain lines in PLATE.INP are keywords used by
INSERT to find the appropriate location for the insertion of a small
file generated by an ``INSERT'' interactive session. An example of the
use of INSERT is given near the end of the file PLATE.CAS, which
contains the complete results of this example. 

The purpose of GENTEXT is to generate a file of prompting phrases and
helps called PLATE.PRO and five FORTRAN source libraries, BEGIN.NEW,
STOGET.NEW, STRUCT.NEW, BEHAVIOR.NEW, and CHANGE.NEW.  The roles of
these files are listed in TABLE 5.  Other files are also produced by
GENTEXT. These are identified in TABLE 6.  A glossary of the input
data established and defined by the GENOPT user is given in TABLE 7.
The file of input data prompts for the user of BEGIN is listed in
TABLE 8.  Parts of GENTEXT-generated FORTRAN code are listed in
TABLES 9 - 13. TABLE 14 lists the algorithms contributed by the
GENOPT user.


GENERATION OF ABSOLUTE ELEMENTS

After the GENOPT user has written/gathered all the subroutines and
algorithms to calculate all the types of behavior that he or she has
identified in GENTEXT as possibly constraining the design, he or she
generates all the program system absolute elements needed by the end
user for optimizing specific items within the generic class. The
GENOPT command ``GENPROGRAMS'' generates the absolute elements. TABLE
15 lists the results of a ``GENPROGRAMS'' session.  TABLE 16 lists
the files generated as a result of using the ``1'' option in TABLE 15.

The GENOPT user has now completed his/her tasks. The end user will
now choose a specific case within the generic class. 


         EXAMPLE 1:  MINIMUM WEIGHT DESIGN OF A PLATE
            PART 2:  TASKS PERFORMED BY THE END USER

The end user now performs the tasks listed in Section 2 of TABLE 2.
In this case the end user chooses a specific case name ``PLATE1''.
TABLE 17 shows part of the interactive ``BEGIN'' session;  TABLE 18
lists part of the file PLATE1.BEG; TABLE 19 shows part of the
interactive ``DECIDE'' session;  TABLE 20 lists part of the file
PLATE1.DEC;  TABLE 21 shows the interactive ``MAINSETUP'' session;
TABLE 22 lists the PLATE1.OPT file;  TABLE 23 shows part of the file
PLATE1.OPM, which lists results for the first five design iterations
that are generated from the batch run initiated by the first
``OPTIMIZE'' command;  TABLE 24 shows part of the interactive
``CHOOSEPLOT'' session; and Figures 3 - 5 show plots from the
processor DIPLOT. These plots give the history of the design for both
``OPTIMIZE'' commands.  Two ``OPTIMIZE'' commands were required in
this simple case to obtain a converged solution.  In ``MAINSETUP'' a
maximum of five iterations was specified.  Convergence was achieved
after two iterations in the second ``OPTIMIZE' batch run. Each batch
run requires about ten seconds of CPU time on the VAX 11/785, VMS
operating system 4.7. 

The files generated by actions of the end user are described in an
interactive HELP utility which is activated by the user's typing the
command ``HELPG''.  Further details are given in the file plate.cas .


    EXAMPLE 2:  MINIMUM WEIGHT DESIGN OF A
                COMPOSITE FLAT OR CURVED PANEL OR CYLINDRICAL SHELL
                WITH COMPOSITE STRINGERS AND/OR RINGS
       PART 1:  TASKS PERFORMED BY THE GENOPT USER


INTRODUCTION

Unlike Example 1, which is a bit contrived, this example represents a
practical problem.  The purpose here was to determine how easy it is
to ``borrow'' previously developed software from another source,
creating a new library of subroutines called addcode[n].src, inserting
labelled common blocks and subroutine calls at the appropriate
locations in SUBROUTINE STRUCT, and collecting object elements for
code that required no changes to form the absolute element
``OPTIMIZE'' that would permit minimum weight design of rather
complex, composite, curved, stiffened panels subject to multiple sets
of combined in-plane loads.  The ``borrowed'' subroutines are from
PANDA2 [6]. The theoretical basis of the analysis is described in [6]
and [9]. 


STATEMENT OF THE PROBLEM

The composite, curved or flat, stiffened panels can be subjected to
up to 20 combinations of uniform in-plane stress resultants, Nx, Ny,
Nxy (axial, transverse or ``hoop'', in-plane shear, respectively). 
The multiple combinations might represent environments seen by the
structure during different phases of its operation.  The composite
panel may be made of several different of materials. The panel may
be unstiffened, be reinforced by stringers or rings or be reinforced
by both stringers and rings.

In this example there are, for each load combination, 18 types of
behavior which might constrain the design. Most of these are types of
buckling. The various kinds of buckling are listed in Table 1 of [9].
Types of buckling accounted for are: 

1. general instability,
2. buckling between rings with ``smeared'' stringers [11], curvature
   included,
3. buckling between rings with ``smeared'' stringers, wide column
   model,
4. local buckling between adjacent rings and stringers,
5. local buckling of the various segments (webs, flanges) of
   both stringers and rings,
6. various ``rolling'' or ``tripping'' modes of the stiffeners,
   both including and neglecting participation of the panel skin
   between the stiffeners, and 
7. an axisymmetric ``rolling'' of rings on complete cylindrical shells.

In addition to this variety of buckling phenomena, five types of
stress are computed in material coordinates (referred to the fiber
direction) of each lamina of each segment of the composite
structure: 

1. maximum tensile stress along the fibers,
2. maximum compressive stress along the fibers,
3. maximum tensile stress normal to the fibers,
4. maximum compressive stress normal to the fibers,
5. maximum in-plane shear stress.

Behavioral constraints are introduced for the maximum stress in each
category for each type of material used in the panel.

PREPARATION FOR THE ``GENTEXT'' INTERACTIVE SESSION

FINDING MODELS FOR PREDICTING BEHAVIOR OF THE STIFFENED PANELS: The
first task of the GENOPT user is to assemble the various algorithms
needed to predict the behaviors just listed. In this case all of the
algorithms were ``borrowed'' from the PANDA2 program system [6].

In PANDA2 a stiffened panel is considered to be an assemblage of
panel modules as illustrated in Fig. 6.  Each module is considered to
consist of several segments (four in Fig. 6b), each segment of which
has its own laminated wall construction (Fig. 6c). Both cross
sections of panel skin and stringers and panel skin and rings are
modelled in this way. Figure 6(a) shows a panel with three modules;
6(b) shows a single module with four segments; and 6(c) shows the
layer numbering convention within each segment. Stiffeners with T, J,
Rectangular (blade), or Hat cross sections are permitted. 

TABLE 25 lists the names of the new software required, where it came
from, whether or not it had to be changed, and where it presently
resides in the GENOPT system.  The six subroutines, TRANFR, GETCIJ,
FORCES, STFEIG, BUCPAN, and STRCON are called from SUBROUTINE STRUCT,
as listed in TABLE 26.  Please note that the portion of SUBROUTINE
STRUCT listed in TABLE 26 was written by the GENOPT user, not by
GENTEXT.  In most cases these subroutines call other subroutines
which are contained in libraries as listed in TABLE 25.  TABLE 27
shows the purposes of the six subroutines the names of which appear
on the left-hand-side of TABLE 25. 

In this case it was necessary to modify some of the ``borrowed''
software because, as originally written, it contained calculation of
behavioral constraints, whereas in GENOPT the actual constraint
conditions are calculated in a GENTEXT-generated portion of STRUCT:
the part with the calls to BEHX1, BEHX2,...BEHXn and CONX (TABLE 11).
The way in which stress constraints are calculated in PANDA2 had to
be changed: In PANDA2 behavioral constraints are calculated
corresponding to maximum stress components for each segment for each
material type, whereas in this GENOPT application it was decided that
only the overall maximum stress components for each material type be
calculated in order not to require the introduction of too many
allowables and factors of safety. 

As with Example 1, the objective is minimum weight of the panel.
TABLE 28 shows the portion of behavior.new that must be modified by
the GENOPT user in this case, that is, SUBROUTINE OBJECT. The new
coding in SUBROUTINE OBJECT is largely ``borrowed'' from the PANDA2
subroutine with the same name. 

In this example the presence of many labelled common blocks in
PANDA2, the fact that PANDA2 already is an optimization code and not
simply an analysis code, and the difference in strategy for handling
multiple load sets in PANDA2 and GENOPT made the process of creating
a GENOPT based panel optimization code more onerous than would be
expected in the average case.  Analysis codes that do not contain too
many labelled common blocks that must be included in struct.new would
also be easier to insert and use in the GENOPT system. 

In order to save space, the interactive GENTEXT session and the
GENPROGRAMS session will not be shown here. They proceed in ways very
similar to those shown in the previous example. 


ORGANIZING AND DECIDING ON NAMES FOR THE INPUT DATA:  In this complex
case there are many more names, arrays, and pointers than was the
case in the relatively simple Example 1.  Therefore, the writer will
not introduce a table analogous to TABLE 3, but will reproduce here
only the glossary that GENTEXT produces in the file NAME.DEF. (In
this case NAME = ``PANEL''). The GENTEXT-generated glossary is given
in TABLE 29.  The generic case name is PANEL.  TABLE 30 lists a small
part of the input data prompting file, PANEL.PRO, in which the text
was composed interactively during the GENTEXT session by the GENOPT
user. 


    EXAMPLE 2:  MINIMUM WEIGHT DESIGN OF A
                COMPOSITE FLAT OR CURVED PANEL OR CYLINDRICAL SHELL
                WITH COMPOSITE STRINGERS AND/OR RINGS
       PART 2:  TASKS PERFORMED BY THE END USER

The end user now performs the tasks listed in Section 2 of Table 2.
(The run stream actually used by the end user in this case is listed
in TABLE 31.)

In this case the end user chooses a specific case name ``ARIANE''. A
minimum weight design is to be obtained for the ARIANE4 interstage
between the second and third stages of the ARIANE4 booster. Blaas and
Wiggenraad call it ``Interstage 2/3'' [12]. Many details of the
modelling philosophy and strategy are given in [6]. Figures 7 - 9,
taken from [6], show the structure, which is a complete cylindrical
shell with external T-shaped stringers and internal blade-shaped
rings (Fig. 7), how the complete cylindrical shell with variable
loads around its circumference is modelled as three cylindrical
panels with different uniform loads (Fig. 8), and how a panel
skin-stringer module is to be constructed. 

As explained in more detail in [6], the complete cylindrical shell
under loads that vary around its circumference is modelled as a
single cylindrical panel spanning 40 inches of circumference and
subjected to two sets of uniform in-plane loads: (1) pure axial
compression of 3000 lb/in. and (2) combined axial compression of 1000
lb/in and in-plane shear of 1000 lb/in.  It was found in [6] that the
third load set, pure axial tension of 2000 lb/in, does not generate
any active behavioral constraint conditions during the optimization
process. 

The end user's runstream for the optimization is listed in TABLE 31.
In order to save space, no details will be given here of the
interactive ``BEGIN'', ``DECIDE'', ``MAINSETUP'', and ``CHANGE''
sessions. 

The results from ``CHOOSEPLOT/DIPLOT'' are shown in Figures 10 - 14.
During the first 23 design iterations some of the wall thicknesses
became very small.  These were set equal to zero via an interactive
``CHANGE'' session. (See Fig. 12).  The evolution of the panel weight
and of the design are shown in Figs. 10 - 12.  The variables are
defined in TABLE 29.  Notice that variables of like magnitude are
plotted together.  (In Example 1 (Fig. 4) the thickness ``THICK'' was
plotted with the LENGTH and WIDTH, with the result that the scale
of the plot hides the evolution of the small variable THICK.)

Figure 13 shows the evolution of the more critical design margins
corresponding to the first load set (Nx = -3000 lb/in); Figure 14
shows the evolution of the more critical design margins corresponding
to the second load set (Nx = -1000 lb/in, Nxy = 1000 lb/in). Again,
the variables plotted are defined in TABLE 29.


                       CONCLUSIONS

The GENOPT program system:

(1) is primarily oriented toward the preliminary design phase of a
project, the phase in which the engineer should use relatively
simple, approximate theories to predict behavior; 

(2) is a convenient ``shell'' for making any analysis user-friendly
by giving the GENOPT user the opportunity to assign meaningful data
names and clear one-line data definitions that appear throughout the
output; 

(3) automatically converts a conventional analysis of a fixed design
into an optimization process. 

Part of the GENOPT system called ``GENTEXT'' generates FORTRAN code
and a prompting data file with user-supplied data definitions and
``help'' paragraphs. The two examples, one relatively simple and the
other rather complex illustrate two stategies of incorporating new
algorithms into the skeletal programs generated by GENOPT. 


                     ACKNOWLEDGMENTS

This work was sponsored by the 1987-1988 Lockheed Independent
Development Program. The author is indeed grateful for the continung
support of Mr. Bill Sable, Structural Analysis and Test in Lockheed
Missiles and Space Company's Satellite Systems Division. Ms. Karen
Neier of Dept. 97-10 of the Lockheed Palo Alto Research Laboratories
wrote the original DIPLOT package which was modified for use with
GENOPT.  Harold Cabiness, Chris Dumlao, and Jorgen Skogh of the
Computational Mechanics Section of Dept. 93-30 of the Lockheed Palo
Alto Research Laboratories reviewed this paper, tested GENOPT, and
offered many suggestions for improvements. The author is especially
grateful for the many tests of GENOPT performed by Harold Cabiness and
for his demands for more user-friendliness and the elimination of many
unnecessary pitfalls.


                      REFERENCES

[1] Roark,    ``FORMULAS FOR STRESS AND STRAIN'', 3rd edition,
McGraw-Hill, 1954 

[2] Vanderplaats, G. N. and Sugimoto, H., "A general-purpose
optimization program for engineering design", COMPUTERS AND
STRUCTURES, vol. 24, pp 13-21 (1986)

[3] Vanderplaats, G. N. and Moses, F., ``Structural optimization by
methods of feasible directions'', Computers and Structures, Vol. 3, pp
739-755, 1973 

[4] Bushnell, D., ``BOSOR4: Program for stress, stability, and
vibration of complex, branched shells of revolution'', in STRUCTURAL
ANALYSIS SYSTEMS, Vol. 2, edited by A. Niku-Lari, pp. 25-54, (1986) 

[5] Bushnell, D., ``BOSOR5: Program for buckling of complex, branched
shells of revolution including large deflections, plasticity and
creep,'' in STRUCTURAL ANALYSIS SYSTEMS, Vol. 2,  edited by A.
Niku-Lari, pp. 55-67, (1986) 

[6] Bushnell, D., ``PANDA2--program for minimum weight design of
stiffened, composite, locally buckled panels'', COMPUTERS AND
STRUCTURES, vol. 25, No. 4, pp 469-605, 1987 

[7] Bushnell, D., ``Improved optimum design of dewar supports'',
COMPUTERS and STRUCTURES, Vol. 29, No. 1, pp. 1-56 (1988) 

[8] Bushnell, D., ``ACTUATOR--An interactive computer program for
optimum design of mirror/actuator systems'', unpublished paper written
in 1983. 

[9] Bushnell, D., ``PANDA--Interactive program for minimum weight
design of stiffened cylindrical panels and shells'', COMPUTERS AND
STRUCTURES, Vol. 16, pp. 167-185 (1983).  See also, D. Bushnell,
``Theoretical basis of the PANDA computer program for preliminary
design of stiffened panels under combined in-plane loads'', COMPUTERS
AND STRUCTURES, Vol. 27, No. 4, pp. 541-563 (1987) 

[10] Leissa, A., VIBRATION OF PLATES, NASA SP-160, 1969,
p. 44, Eq. 4.20.

[11] Baruch, M. and Singer, J., ``Effect of eccentricity of stringers
on the general instability of stiffened cylindrical shells under
hydrostatic pressure'', JOURNAL OF MECHANICAL ENGINEERING SCIENCE,
Vol. 5, No. 1, p. 23-27 (1963)

[12] Blass, C. and Wiggenraad, J. F. M., ``Development and test
verification of the ARIANE4 interstage 2/3 in CFRP'', Proceedings of
the AIAA/ASME 27th Structures, Structural Dynamics and Materials
Conference, Part 1,pp. 307-313, May 1986



                      LIST OF FIGURES

Fig. 1  Architecture of the GENOPT mainprocessor ``MAIN''

Fig. 2  Schematic of the evolution of a design with one set of design
iterations and two decision variables, X(1) and X(2).  With each
iteration the optimizer, ADS, establishes a ``window'' of permitted
excursion of the decision variables. In GENOPT this ``window'' shrinks
by a factor of 0.8 with each design iteration.  Upon re-execution of
OPTIMIZE the ``window'' is re-expanded to its original size, which
depends upon lower and upper bounds supplied by the end user in DECIDE
and upon certain strategies used by ADS. 

Fig. 3  Example 1: Minimum weight design of rectangular, isotropic
plate. Weight of the plate v. design iterations for both ``OPTIMIZES''
in Section 2 of TABLE 2.

Fig. 4  Example 1: Minimum weight design of plate. Decision variables
v. design iterations.

Fig. 5  Example 1: Minimum weight design of plate. History of design
margins v. design iterations.

Fig. 6  Example 2: Minimum weight design of stiffened composite panels.
Approach created by the GENOPT user: 
 (a) Panel with T-shaped stringers,
 (b) a single module of the panel with segment numbering convention,
 (c) Layer numbering convention.

Fig. 7  Example 2: Minimum weight design of stiffened composite panels.
Specific case run by end user: ARIANE4 interstage between stage 2 and
stage 3.  The cylindrical shell is reinforced by external stringers and
internal rings.

Fig. 8  Example 2: Minimum weight design of stiffened composite panels.
Specific case run by end user: Applied moment M, axial compression P
and shear S; assumed resulting distributions of line loads Nx and Nxy
in the shell; and replacement of the axtual complete cylindrical shell
with circumferentially varying line loads by a single cylindrical panel
spanning 40 in. of circumference with three separate load sets, each of
which acts along and each of which has uniform line loads Nx and Nxy.
(In Example 2 the load case with Nxy = 0, Nx = +2000 lb/in is not used
because a previous study [6] found that this load set created no
critical behavioral constraints.)

Fig. 9  Example 2: Minimum weight design of stiffened composite panels.
Specific case run by end user: Design concept to be optimized: external
T-shaped stringers made of graphite-epoxy cloth and tape with thickened
areas under the stringer web, and internal aluminum rings with spacing
fixed at 26.75 in.  The spacing of the stringers is to be determined,
as well as the cross section dimensions and thicknesses of the various
composite laminae.

Fig. 10 Example 2: Minimum weight design of stiffened composite panels.
Weight v. design iterations for all nine ``OPTIMIZES'' listed in
TABLE 31. The ``CHANGE'' processor was used after four ``OPTIMIZES'' in
order to set several of the lamina thicknesses equal to zero. (See
Fig. 12).

Fig. 11 Example 2: Minimum weight design of stiffened composite panels.
Cross section dimensions (see TABLE 29) v. design iterations.

Fig. 12 Example 2: Minimum weight design of stiffened composite panels.
Laminae thicknesses (see Fig. 9) v. design iterations.

Fig. 13 Example 2: Minimum weight design of stiffened composite panels.
Significant margins (see TABLE 29) v. design iterations for the first
load set (pure axial compression, Nx = -3000 lb/in)

Fig. 14 Example 2: Minimum weight design of stiffened composite panels.
Significant margins (see TABLE 29) v. design iterations for the second
load set (axial compression, Nx = -1000 lb/in, in-plane shear, Nxy =
1000 lb/in.



                              TABLES


\beginverbatim
          TABLE 1   THE GENOPT MENU OF COMMANDS
 =================================================================
     COMMAND              WHAT THE COMMAND DOES
 -----------------------------------------------------------------
  Commands for the GENOPT user and the end user:

      GENOPTLOG    (activates the GENOPT menu of commands.)
      HELPG        (gets information on GENOPT.) 

  Commands for the GENOPT user:

      GENTEXT      (GENOPT user generates a prompt file, program
                    fragments, and programs.)
      GENPROGRAMS  (GENOPT user generates absolute elements:
                    begin.{machine}, decide.{machine},
                    mainsetup.{machine}, optimize.{machine},
                    change.{machine}, store.{machine},
                    chooseplot.{machine}, diplot.{machine})
      INSERT       (GENOPT user adds parameters to the problem.) 
      CLEANGEN     (GENOPT user cleans up GENeric case files.) 

  Commands for the end user:

      BEGIN        (end user provides starting design, material
                    properties, loads, allowables, and factors
                    of safety.) 
      DECIDE       (end user chooses decision variables, bounds, 
                    linked variables, inequality constraints, and
                    escape variables.)
      MAINSETUP    (end user sets up strategy parameters for
                    simple analysis or optimization.) 
      OPTIMIZE     (end user performs the analysis of a fixed design
                    or optimizes in a batch mode.)
      CHANGE       (end user changes some parameters.) 
      CHOOSEPLOT   (end user chooses which variables to plot versus
                    design iterations.)
      DIPLOT       (end user obtains plots.)
      CLEANSPEC    (end user cleans up SPECific case files.)
 ===================================================================
\endverbatim
\ven
\beginverbatim
   TABLE 2   A TYPICAL  GENOPT  (GENeral OPTimization)  RUNSTREAM
====================================================================
   COMMAND              PURPOSE OF THE COMMAND
--------------------------------------------------------------------
$ GENOPTLOG    (Activate the GENOPT commands.  Please note: you
                must execute "source ~/bin/initialize" before you
                can issue this command.)

SECTION 1      (TASKS TO BE PERFORMED BY THE GENOPT USER.)

First you must decide upon a class of things for which you want to
create a user-friendly analyis/optimization program.  Then you must
think about the following: 

(a) What variables (length, width, thickness,...) are involved?
(b) What environments (loads, temperatures,...) is the class of
    things subjected to?
(c) What types of behavior (stress, buckling, vibration,...)
    should be accounted for?
(d) What is the objective (weight, cost,...) of the optimization?
(e) From where are you going to obtain algorithms for predicting
    the types of behavior in (c) and the objective in (d)?
    In brief, you must have a good idea of your goal before you start.
    You don't need quantitative answers, only a well-formulated plan.

$ GENTEXT     

During an interactive session, you provide data names, definitions,
and help paragraphs for a problem class for which you provide a
generic name. The GENOPT system sets up a data base, a system of
FORTRAN programs, and a prompting file, all of which use data names,
definitions, and ``help'' paragraphs created by you. You are asked by
GENTEXT to provide data names for variables each of which performs
one of seven possible roles: 

1 = a possible decision variable for optimization, typically a
    dimension of a structure. 
2 = a constant parameter (cannot vary as the design evolves),
    typically a control integer or a material property, but not a
    load, allowable, or factor of safety, which are asked for later. 
3 = a parameter characterizing the environment, such as a load
    component or a temperature. 
4 = a quantity that describes the response of the structure,
    (e.g. stress, buckling load, frequency) 
5 = an allowable, such as maximum allowable stress, minimum
    allowable frequency, etc. 
6 = a factor of safety
7 = the design objective (e.g. weight)

You must provide these data names, definitions, and ``help''
paragraphs in the following order: all variables with Roles 1 or 2
first; then all Role 3 variables; then variables with Roles 4, 5 and
6 in the repeating pattern (A4, A5, A6);  (B4, B5, B6);  (C4, C5,
C6); . . . The last variable name and definition you supply is the
single Role 7 variable: the design objective. 

Next, you write/gather FORTRAN code that predicts behavior such as
stress, buckling, vibration frequency, displacement, clearance, etc.
as functions of the data names that you provided via GENTEXT. The
types of behavior for which you must supply algorithms were chosen by
you during the interactive ``GENTEXT'' session. You insert this
FORTRAN code into libraries called behavior.new and/or struct.new and
addcode[n].src .  Skeletal forms of behavior.new and struct.new have
just been created by GENTEXT.  You may create a new library called
addcode[n].src , n = 2, 3,..., if you think this is a good idea. This is
done in the complex example case documented in panel.cas . In order to
learn more about behavior.new, struct.new, addcode[n].src, use the
HELPG command. Information about these libraries appears on your
screen when you type one or more of the following three-word
commands: 
               HELPG LIBRARIES GENOPTUSER
               HELPG LIBRARIES BEHAVIOR
               HELPG LIBRARIES STRUCT
               HELPG LIBRARIES ADDCODEn.

Creating and properly installing new FORTRAN code for predicting the
GENOPT-user-defined behavior that might constrain the design is the
most challenging part of the GENOPT user's activity. When you have
completed this task, type the command GENPROGRAMS.) 

$ GENPROGRAMS  

Runs the "usermake.{machine}" makefile which "makes" the GENOPT-user-
specific libraries, and makes the final executables.

End of Section 1: The user-friendly program system has been
generated.

--------------------------------------------------------------------
 
 SECTION 2     (TASKS PERFORMED BY THE END USER: APPLY THE NEW
                ANALYSIS/OPTIMIZATION PROGRAM TO A SPECIFIC CASE.)

$ BEGIN        

You, or an end user appointed by you, assign a specific case name
which is different from the generic case name. You provide a starting
design, material properties, tables and control integers, loads,
allowables, and factors of safety for the specific case.

$ DECIDE       

You choose decision variables and their lower and upper bounds,
linked variables and their linking coefficients, inequality
constraints based on system dimensions rather than system behavior,
and ``escape'' variables.

$ MAINSETUP    

You choose type of analysis and the number of design iterations to be
performed by OPTIMIZE.

$ OPTIMIZE     

You launch a batch run that does the work specified by MAINSETUP. 
Upon completion of the batch run and inspection of the results
provided in the file called  NAME.OPM, you decide whether to do more
design iterations. (NAME = end-user-assigned specific case name.
NAME = PLATE1 in this example.)

$ OPTIMIZE     

You launch a second batch run for another set of design iterations.
The starting design for this run is the ending design of the previous
run. Upon inspection of the file PLATE1.OPM, you realize that the
process has converged to an optimum design. 

$ CHOOSEPLOT   

You choose which variables should be plotted v. design iterations. 

$ DIPLOT       

You cause the variables chosen by you in CHOOSEPLOT to be plotted. 

The runstream given here is the same as that used in the simpler of
the two example cases, panel.cas . 
====================================================================
\endverbatim
\ven
\beginverbatim
         TABLE 3   SEVEN ROLES OF GENOPT INPUT DATA
      AND DATA NAMES CHOSEN BY THE GENOPT USER FOR THIS CASE
====================================================================
 ROLE OF DATA               DATA NAMES          SHORT DEFINITIONS
--------------------------------------------------------------------
1. Candidates to be     THICK, LENGTH, WIDTH    thickness t, length a,
   decision variables                           width b.

2. Constant parameters  E, NU, RHO              modulus, Poisson ratio,
                                                weight density
                        AOBAXL(i), KAXL(i)      a/b, K values from Roark
                                                for compression buckling
                        AOBSHR(j), KSHR(j)      a/b, K values from Roark
                                                for shear buckling.

3. Environmental        Nx(k), Ny(k), Nxy(k),   axial resultant, trans-
   parameters (loads)   PRESS(k)                verse resultant, in-
                                                plane shear resultant,
                                                normal pressure.

4. Responses (beha-     STRESS(k), BUCKLE(k),   max. stresses, buckling
   vioral constraints)  FREQ(k), W(k)           load factors, natural
                                                frequency, max. normal
                                                displacement.

5. Allowables           MAXSTR(k), MINBUC(k),   allowable stresses,
                        MINCPS(k), AW(k)        buckling load factors,
                                                frequency, normal
                                                displacement.

6. Factors of safety    FSTRES(k), FBUCKL(k),   factors of safety for
                        FSFREQ(k), FW(k)        stress, buckling,
                                                frequency, displacement.

7. Objective function   WEIGHT                  weight of the plate.
=======================================================================
NOTES:  
(1) The GENOPT user decides that there are a maximum of 30 values
    permitted in the table of KAXL(i) v. AOBAXL(i).
(2) The GENOPT user decides that there are a maximum of 20 values
    permitted in the table of KSHR(j) v. AOBSHR(j).
(3) GENTEXT automatically sets the maximum number of load sets
    equal to 20. (The maximum value of k is 20). All loads, responses,
    allowables, and factors of safety are arrays with 20 rows. In
    this case the responses, allowables, and factors of safety are
    all one-dimensional arrays. The more complex example ``PANEL'' has
    several two-dimensional arrays.
\endverbatim
\ven
\beginverbatim
      TABLE 4   FILE  PLATE.INP  THAT CONTAINS AN IMAGE OF
                THE INTERACTIVE ``GENTEXT'' SESSION
=====================================================================
       5  $ starting prompt index in the file PLATE.PRO       
       5  $ increment for prompt index
       0  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 PROGRAM FOR OPTIMIZATION OF A RECTANGULAR PLATE
          $ Are there more lines in the ``help'' paragraph?
 SUBJECTED TO SEVERAL LOADING ENVIRONMENTS AND
          $ Are there more lines in the ``help'' paragraph?
 CONSTRAINTS ON STRESS, BUCKLING, DISPLACEMENT, AND FREQUENCY.
 n        $ Are there more lines in the ``help'' paragraph?
       0  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 FIRST, PROVIDE ALL VARIABLES THAT CAN BE DECISION VARIABLES,
          $ Are there more lines in the ``help'' paragraph?
 THAT IS, VARIABLES THAT CAN CHANGE DURING OPTIMIZATION
 y        $ Are there more lines in the ``help'' paragraph?
 ITERATIONS (ROLE TYPE 1), AND FIXED VARIABLES (ROLE TYPE 2).
 n        $ Are there more lines in the ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt

 THICK    $ Name of a variable in the users program (defined below)
       1  $ Role of the variable in the users program
 n        $ Is the variable  THICK  an array? 
 thickness of the plate
 n        $ Do you want to include a ``help'' paragraph?
 y        $ Any more variables for role types  1  or  2   ?    $15
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 LENGTH   $ Name of a variable in the users program (defined below)
       1  $ Role of the variable in the users program
 n        $ Is the variable  LENGTH  an array? 
 Length of the plate
 n        $ Do you want to include a ``help'' paragraph?
 y        $ Any more variables for role types  1  or  2   ?    $20
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 WIDTH    $ Name of a variable in the users program (defined below)
       1  $ Role of the variable in the users program
 n        $ Is the variable  WIDTH  an array? 
 Width of the plate
 n        $ Do you want to include a ``help'' paragraph?
 y        $ Any more variables for role types  1  or  2   ?    $25


       (MANY LINES SKIPPED IN ORDER TO SAVE SPACE)


 n        $ Any more variables for role types  1  or  2   ?    $
       0  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 NEXT, PROVIDE ALL ENVIRONMENTAL PARAMETERS (LOADS, TEMPERATURES)
 n        $ Are there more lines in the ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 Nx       $ Name of a variable in the users program (defined below)
       3  $ Role of the variable in the users program
 Axial tension per unit width of the plate (lb/in)
 y        $ Do you want to include a ``help'' paragraph?
 NOTE:  Nx must be negative for axial compression!
 n        $ Any more lines in the ``help'' paragraph?
 y        $ Any more variables for role type  3 ?              $95


       (MANY LINES SKIPPED IN ORDER TO SAVE SPACE)


 y        $ Any more variables for role type  4 ?              $145
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 FREQ     $ Name of a variable in the users program (defined below)
       4  $ Role of the variable in the users program
 n        $ Do you want to reset the number of columns in FREQ ?
 Fundamental frequency of unloaded plate
 n        $ Do you want to include a ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 MINCPS   $ Name of a variable in the users program (defined below)
       5  $ Role of the variable in the users program
 Minimum allowable value for the fundamental frequency
 n        $ Do you want to include a ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 FSFREQ   $ Name of a variable in the users program (defined below)
       6  $ Role of the variable in the users program
 Factor of safety for FREQ
 n        $ Do you want to include a ``help'' paragraph?
       2  $ Indicator (1 or 2) for type of constraint
 y        $ Any more variables for role type  4 ?              $160
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 W        $ Name of a variable in the users program (defined below)
       4  $ Role of the variable in the users program
 n        $ Do you want to reset the number of columns in W ?
 Normal deflection under uniform pressure
 n        $ Do you want to include a ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 AW       $ Name of a variable in the users program (defined below)
       5  $ Role of the variable in the users program
 Maximum allowable normal deflection under pressure
 n        $ Do you want to include a ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 FW       $ Name of a variable in the users program (defined below)
       6  $ Role of the variable in the users program
 Factor of safety for max deflection under pressure
 n        $ Do you want to include a ``help'' paragraph?
       1  $ Indicator (1 or 2) for type of constraint
 n        $ Any more variables for role type  4 ?              $ 
       0  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 LAST, AN OBJECTIVE MUST BE CHOSEN, SUCH AS MINIMUM WEIGHT
 y        $ Are there more lines in the ``help'' paragraph?
 OR MINIMUM COST.
 n        $ Are there more lines in the ``help'' paragraph?
       1  $ Type of prompt: 0=``help'' paragraph, 1=one-line prompt
 WEIGHT   $ Name of a variable in the users program (defined below)
       7  $ Role of the variable in the users program
 Weight of the plate
 n        $ Do you want to include a ``help'' paragraph?
======================================================================
\endverbatim
\ven
\beginverbatim
      TABLE 5   FILE OF PROMPTING PHRASES AND HELPS AND
                SOURCE CODE LIBRARIES GENERATED BY ``GENTEXT''
 =====================================================================
PLATE.PRO   

Prompt file for input data for the generic problem that the GENOPT
user has set up for optimization. The Prompt Numbers listed in TABLE
7 below correspond to the prompts in the file PLATE.PRO, which is
listed in TABLE 8.  PLATE.PRO is used by BEGIN.  If the GENOPT user
composes clear one-line prompts and frequent, well-written ``help''
paragraphs, the GENTEXT-generated optimization program system will be
end-user friendly. 

begin.new

Source library for FORTRAN program which will be used by the end user
to read the starting design, material properties, and other input
data. begin.new is a machine-generated processor. It is a
concatenation of the files begin.tmpl (see note), PLATE.COM,
PLATE.NEW, and PLATE.SET.  begin.new uses the input data prompting
file, PLATE.PRO. 

stoget.new

Source library for FORTRAN subroutines which are used to transfer
labelled common blocks. in the BEGIN - DECIDE - MAINSETUP - OPTIMIZE
- CHANGE - CHOOSEPLOT - DIPLOT program system used by the end user. 
The labelled common blocks are the data base of the generic problem
class PLATE. stoget.new is a machine-generated library. It is a
concatenation of stoget.new, PLATE.COM, PLATE.WRI, and PLATE.REA. 

struct.new

FORTRAN subroutines for performing the mainprocessor analysis for a
given design configuration. struct.new is a machine-generated library
that consists of a concatenation of the files struct.tmpl,
PLATE.COM, and PLATE.CON.  The GENOPT user may want to add code to
SUBROUTINE STRUCT, as described in the more complex example ``PANEL''.
struct.new remains unchanged in this simpler example, ``PLATE''. The
library, struct.new, also contains a skeletal routine, SUBROUTINE
TRANFR, that the GENOPT user can modify in order to translate data
names from those just established to others established by the
developer of previously written code that can be incorporated into
this optimization program.  The other sample case, ``PANEL'', provides
an example of how this is done.  See TABLE 13. 

behavior.new

Machine-generated library of skeletal subroutines for calculating
response (e.g. stress, buckling, etc.  behavior.new is a
concatenation of the GENTEXT- generated files PLATE.SUB, PLATE.DEF
and PLATE.COM. The GENOPT user may complete the subroutines BEHX1,
BEHX2, BEHX3,... BEHXn by providing algorithms that calculate the
responses for a given design (TABLE 14). The GENOPT user must provide
coding that calculates the objective function, inserting it into
SUBROUTINE OBJECT, which is located in this FORTRAN source code
library.  See TABLES 12 and 14. 

change.new

FORTRAN program that permits the end user to change certain program
parameters without having to go back to BEGIN and run a case from
scratch. change.new is a machine-generated processor that is a
concatenation of the files change.tmpl, PLATE.COM, and PLATE.CHA. 

=====================================================================
NOTE: The files begin.tmpl, stoget.tmpl, struct.tmpl, change.tmpl
contain fixed FORTRAN code fragments. When GENTEXT-generated FORTRAN
code is added to these fragments, complete programs and subroutines
are the result. These complete programs and subroutines contain
nomenclature created by the GENOPT user, as is seen in TABLES 9 - 14.
Only the FORTRAN source libraries struct.new and behavior.new are
allowed to be further changed by the GENOPT user. 
\endverbatim
\ven
\beginverbatim
   TABLE 6: CONTENTS OF OTHER FILES CREATED BY   ``GENTEXT''
======================================================================
 FILE NAME                DEFINITION OF FILE CONTENTS
----------------------------------------------------------------------
 PLATE.NEW        Part of BEGIN.NEW that contains calls to
                      SUBROUTINE DATUM and SUBROUTINE GETVAR.
                      This coding permits the interactive input
                      for the starting design. TABLE 9 shows part
                      of this file.
 PLATE.INP        See TABLE 4. Input data for GENTEXT.
 PLATE.COM        Labelled common blocks generated specifically
                      for the user-developed class of problems.
                      See TABLE 10.
 PLATE.WRI        Part of subroutine for writing labelled common
                      blocks in SUBROUTINE STORCM (in Library STOGET).
 PLATE.REA        Part of subroutine for reading labelled common
                      blocks in SUBROUTINE GETCOM (in Library STOGET).
 PLATE.SET        Part of SUBROUTINE SETUPC in which new values
                      are installed in labelled common blocks from
                      the array VAR(I), which contains the latest
                      values of all candidates for decision variables.
                      NOTE: SUBROUTINE SETUPC is in the BEGIN library.
 PLATE.CON        Calls to subroutines, BEHX1, BEHX2, BEHX3,...,
                      which calculate behavior such as stresses
                      modal frequencies, buckling loads, etc. for
                      a fixed design configuration.  PLATE.CON also
                      contains calls to CON, which generate the value
                      of the behavioral constraints corresponding
                      to BEHX1, BEHX2, BEHX3,...  PLATE.CON generates
                      phrases that identify the meaning of each
                      behavioral constraint.  See TABLE 11.
 PLATE.SUB        Skeletal subroutines, BEHX1, BEHX2, ..., and the
                      skeletal objective function, OBJECT.
 PLATE.DEF        List of user-established variable names,
                      definitions, and roles that these variables play
                      in the user-generated program.  Also, contains
                      list of files created by GENTEXT and the
                      functions of these files.  TABLE 7 is taken from
                      this file.
 PLATE.CHA        Part of SUBROUTINE NEWPAR (called in the CHANGE
                      processor) in which labelled common values are
                      updated.
 PLATE.DAT        Image of interactive input for user-developed
                      program, generated to save time in case you make
                      a mistake during input. This file is used by
                      the INSERT processor.
======================================================================
\endverbatim
\ven
\beginverbatim
    TABLE 7   GLOSSARY OF VARIABLES INTRODUCED BY THE GENOPT USER
              IN THE GENERIC CASE CALLED ``PLATE''  THIS GLOSSARY IS
              INCLUDED IN THE FILES  PLATE.DEF  AND  BEHAVIOR.NEW.
=======================================================================
ARRAY NUMBER OF        PROMPT  VAR.
 ?   (ROWS,COLS) ROLE  NUMBER  NAME      DEFINITION OF THE VARIABLE
                     (PLATE.PRO)
=======================================================================
 n   (   0,  0)   1      15   THICK  = thickness of the plate
 n   (   0,  0)   1      20   LENGTH = Length of the plate
 n   (   0,  0)   1      25   WIDTH  = Width of the plate
 n   (   0,  0)   2      30   E      = Young's modulus of the plate
                                         material
 n   (   0,  0)   2      35   NU     = Poisson's ratio of the plate
                                         material
 n   (   0,  0)   2      40   RHO    = Weight density (e.g. lb/in**3)
                                         of the plate material
 n   (   0,  0)   2      50   IAOBAX = Number of entries in the table of
                                         axial buckling v. a/b in
                                         AOBAXL(IAOBAX)
 y   (  30,  0)   2      55   AOBAXL = (plate length, LENGTH)/
                                                      (plate width, WIDTH)
 y   (  30,  0)   2      60   KAXL   = Coefficient for buckling under
                                         uniform axial compression
 n   (   0,  0)   2      70   IAOBSH = Number of entries in the table of
                                         shear buckling v. a/b in
                                         AOBSHR(IAOBSH)
 y   (  20,  0)   2      75   AOBSHR = (plate length, LENGTH)/
                                                      (plate width, WIDTH)
 y   (  20,  0)   2      80   KSHR   = Coefficient for buckling under
                                         uniform in-plane shear
 n   (   0,  0)   2      90   NCASES = Number of load cases (number of
                                         environments)  in  Nx(NCASES)
 y   (  20,  0)   3      95   Nx     = Axial tension per unit width
                                         of the plate (lb/in)
 y   (  20,  0)   3     100   Ny     = Transverse tension per unit
                                         length of the plate (lb/in)
 y   (  20,  0)   3     105   Nxy    = In-plane shear per unit edge
                                         length applied to the plate.
 y   (  20,  0)   3     110   PRESS  = Uniform normal pressure on the plate
 y   (  20,  0)   4     120   STRESS = Maximum effective (von Mises) stress
 y   (  20,  0)   5     125   MAXSTR = Maximum effective (von Mises) stress
                                         allowed
 y   (  20,  0)   6     130   FSTRES = Factor of safety for effective
                                         stress
 y   (  20,  0)   4     135   BUCKLE = Buckling load factor
 y   (  20,  0)   5     140   MINBUC = Minimum allowable buckling load
                                         factor (use 1.0)
 y   (  20,  0)   6     145   FBUCKL = Factor of safety for buckling load
                                         factor
 y   (  20,  0)   4     150   FREQ   = Fundamental frequency of unloaded
                                         plate
 y   (  20,  0)   5     155   MINCPS = Minimum allowable value for the
                                         fundamental frequency
 y   (  20,  0)   6     160   FSFREQ = Factor of safety for FREQ
 y   (  20,  0)   4     165   W      = Normal deflection under
                                         uniform pressure
 y   (  20,  0)   5     170   AW     = Maximum allowable normal deflection
                                         under pressure
 y   (  20,  0)   6     175   FW     = Factor of safety for max deflection
                                         under pressure
 n   (   0,  0)   7     185   WEIGHT = Weight of the plate
===========================================================================
\endverbatim
\ven
\beginverbatim
TABLE 8   LIST OF THE FILE  PLATE.PRO  WHICH PROVIDES THE END USER
          WITH PROMPTS AND ``HELPS''  WHEN THE END USER USES ``BEGIN''
===========================================================================
 
   5.0 
       PROGRAM FOR OPTIMIZATION OF A RECTANGULAR PLATE
       SUBJECTED TO SEVERAL LOADING ENVIRONMENTS AND
       CONSTRAINTS ON STRESS, BUCKLING, DISPLACEMENT, AND FREQUENCY.
 
 
  10.0 
       FIRST, PROVIDE ALL VARIABLES THAT CAN BE DECISION VARIABLES,
       THAT IS, VARIABLES THAT CAN CHANGE DURING OPTIMIZATION
       ITERATIONS (ROLE TYPE 1), AND FIXED VARIABLES (ROLE TYPE 2).
 
  15.1 thickness of the plate: THICK
  20.1 Length of the plate: LENGTH
  25.1 Width of the plate: WIDTH
  30.1 Young's modulus of the plate material: E
  35.1 Poisson's ratio of the plate material: NU
  40.1 Weight density (e.g. lb/in**3) of the plate material: RHO
 
  45.0 
       THE FOLLOWING TABLE (FROM ROARK, 3RD EDITION, TABLE XVI,
       ENTRY NO. 1, PAGE 312), GIVES THE RELATIONSHIP OF PLATE
       (LENGTH/WIDTH) TO A COEFFICIENT FOR BUCKLING UNDER UNIFORM
       AXIAL COMPRESSION.
 
  50.1 Number IAOBAX of rows in the array  AOBAXL: IAOBAX
  55.1 (plate length, LENGTH)/(plate width, WIDTH): AOBAXL
  60.1 Coefficient for buckling under uniform axial compression: KAXL
 
  65.0 
       THE FOLLOWING TABLE (FROM ROARK, 3RD EDITION, TABLE XVI,
       ENTRY NO. 10, PAGE 312), GIVES THE RELATIONSHIP OF PLATE
       (LENGTH/WIDTH) TO A COEFFICIENT FOR BUCKLING UNDER UNIFORM
       IN-PLANE SHEAR.
 
  70.1 Number IAOBSH   of rows in the array  AOBSHR: IAOBSH
  75.1 (plate length, LENGTH)/(plate width, WIDTH): AOBSHR
  80.1 Coefficient for buckling under uniform in-plane shear: KSHR
 
  85.0 
       NEXT, PROVIDE ALL ENVIRONMENTAL PARAMETERS (LOADS, TEMPERATURES)
 
  90.1 Number NCASES of load cases (environments): NCASES
  95.1 Axial tension per unit width of the plate (lb/in): Nx
  95.2 
       NOTE:  Nx must be negative for axial compression!
 
 100.1 Transverse tension per unit length of the plate (lb/in): Ny
 105.1 In-plane shear per unit edge length applied to the plate.: Nxy
 110.1 Uniform normal pressure on the plate: PRESS
 
 115.0 
       NEXT, PROVIDE RESPONSE PARAMETERS, ALLOWABLES, AND FACTORS OF
       SAFETY. THE ORDER IN WHICH YOU MUST PROVIDE THESE DATA IS:
       A,B,C; A,B,C; A,B,C; A,B,C; etc, in which
       A = RESPONSE,   B = ALLOWABLE,   C = FACTOR OF SAFETY.
 
 120.0 Maximum effective (von Mises) stress: STRESS
 125.1 Maximum effective (von Mises) stress allowed: MAXSTR
 130.1 Factor of safety for effective stress: FSTRES
 135.0 Buckling load factor: BUCKLE
 140.1 Minimum allowable buckling load factor (use 1.0): MINBUC
 145.1 Factor of safety for buckling load factor: FBUCKL
 150.0 Fundamental frequency of unloaded plate: FREQ
 155.1 Minimum allowable value for the fundamental frequency: MINCPS
 160.1 Factor of safety for FREQ: FSFREQ
 165.0 Normal deflection under uniform pressure: W
 170.1 Maximum allowable normal deflection under pressure: AW
 175.1 Factor of safety for max deflection under pressure: FW
 
 180.0 
       LAST, AN OBJECTIVE MUST BE CHOSEN, SUCH AS MINIMUM WEIGHT
       OR MINIMUM COST.
 
 185.0 Weight of the plate: WEIGHT
 999.0 DUMMY ENTRY TO MARK END OF FILE
======================================================================
NOTE: The GENOPT user provides the starting prompt index and index
increment, the names of the variables, and the text. GENTEXT provides
the prompt numbers and the layout of the prompt file. Informative
data names and clear text will make the GENTEXT- generated
optimization program system easy to use. 
\endverbatim
\ven
\beginverbatim
    TABLE 9  PART OF THE FORTRAN SOURCE CODE  PLATE.NEW
             GENERATED BY  ``GENTEXT''.  THIS FILE FORMS
             PART OF THE PROCESSOR  BEGIN.NEW.
======================================================================
    CALL DATUM(IFILE,  5,0,0,   INT, REALL,CHARAC,IOUT,0,0,0,IPROMP)
    CALL DATUM(IFILE, 10,0,0,   INT, REALL,CHARAC,IOUT,0,0,0,IPROMP)
    CALL DATUM(IFILE, 15,1,1,   INT,THICK  ,CHARAC,IOUT,0,0,0,IPROMP)
    CALL GETVAR(0,0,     THICK  ,    IVAR,  VAR,WORDV)
    CALL DATUM(IFILE, 20,1,1,   INT,LENGTH ,CHARAC,IOUT,0,0,0,IPROMP)
    CALL GETVAR(0,0,     LENGTH ,    IVAR,  VAR,WORDV)
    CALL DATUM(IFILE, 25,1,1,   INT,WIDTH  ,CHARAC,IOUT,0,0,0,IPROMP)
    CALL GETVAR(0,0,     WIDTH  ,    IVAR,  VAR,WORDV)
    CALL DATUM(IFILE, 30,1,1,   INT,E  ,CHARAC,IOUT,0,0,0,IPROMP)    
    CALL GETVAR(0,0,     E      ,    IPAR,  PAR,WORDP)
    CALL DATUM(IFILE, 35,1,1,   INT,NU     ,CHARAC,IOUT,0,0,0,IPROMP)
    CALL GETVAR(0,0,     NU     ,    IPAR,  PAR,WORDP)
    CALL DATUM(IFILE, 40,1,1,   INT,RHO    ,CHARAC,IOUT,0,0,0,IPROMP)
    CALL GETVAR(0,0,     RHO    ,    IPAR,  PAR,WORDP)
    CALL DATUM(IFILE, 45,0,0,   INT, REALL,CHARAC,IOUT,0,0,0,IPROMP)
C
    WRITE(6,'(A)')'   '
    WRITE(6,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, AOBAXL = '
    WRITE(6,'(A)')
   1 '  Number of entries in the table of axial buckling v. a/b'
    WRITE(6,'(A)')'   '
    IF (IPROMP.GT.1) THEN
       WRITE(IFILE8,'(A)')'   '
       WRITE(IFILE8,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, AOBAXL = '
       WRITE(IFILE8,'(A)')
   1 '  Number of entries in the table of axial buckling v. a/b'
       WRITE(IFILE8,'(A)')'   '
    ENDIF
    REWIND IFILE
    CALL DATUM(IFILE, 50,1,1,IAOBAX,REALL,CHARAC,IOUT,0,0,0,IPROMP)
    IF (IAOBAX.EQ.0) GO TO  51
    DO  50  I=1,IAOBAX
    REWIND IFILE
    CALL DATUM(IFILE, 55,1,1,
   1    INT,AOBAXL(I),CHARAC,  IOUT,I,0,1,IPROMP) 
    CALL GETVAR(I,0,     AOBAXL(I),  IPAR,  PAR,WORDP)
 50 CONTINUE
 51 CONTINUE
C
    WRITE(6,'(A)')'   '
    WRITE(6,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, KAXL = '
    WRITE(6,'(A)')
   1 '  Number of entries in the table of axial buckling v. a/b'
    WRITE(6,'(A)')'   '
    IF (IPROMP.GT.1) THEN
       WRITE(IFILE8,'(A)')'   '
       WRITE(IFILE8,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, KAXL = '
       WRITE(IFILE8,'(A)')
   1 '  Number of entries in the table of axial buckling v. a/b'
       WRITE(IFILE8,'(A)')'   '
    ENDIF
    IF (IAOBAX.EQ.0) GO TO  61
    DO  60  I=1,IAOBAX
    REWIND IFILE
    CALL DATUM(IFILE, 60,1,1,
   1    INT,KAXL(I),CHARAC,  IOUT,I,0,1,IPROMP)   
    CALL GETVAR(I,0,     KAXL(I),    IPAR,  PAR,WORDP)
 60 CONTINUE
 61 CONTINUE


        (MANY LINES SKIPPED IN ORDER TO SAVE SPACE)


    CALL DATUM(IFILE, 85,0,0,   INT, REALL,CHARAC,IOUT,0,0,0,IPROMP)
    MCASES = 1
    CALL DATUM(IFILE, 90,1,1,NCASES,REALL,CHARAC,IOUT,0,0,0,IPROMP)
    IF (NCASES.EQ.0) GO TO  96
    DO  95  I=1,NCASES
    REWIND IFILE
    CALL DATUM(IFILE, 95,1,2,
   1    INT,Nx(I),CHARAC,  IOUT,I,0,1,IPROMP)     
    CALL GETVAR(I,0,     Nx(I),      ILAR, FLAR,WORDF)
 95 CONTINUE
 96 CONTINUE


       (MANY LINES SKIPPED IN ORDER TO SAVE SPACE)
 

    WRITE(6,'(A)')'   '
    WRITE(6,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, W = '
    WRITE(6,'(A)')
   1 '  Number of load cases (number of environments) '
    WRITE(6,'(A)')'   '
    IF (IPROMP.GT.1) THEN
       WRITE(IFILE8,'(A)')'   '
       WRITE(IFILE8,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, W = '
       WRITE(IFILE8,'(A)')
   1 '  Number of load cases (number of environments) '
       WRITE(IFILE8,'(A)')'   '
    ENDIF
    IF (NCASES.EQ.0) GO TO 166
    DO 165  I=1,NCASES
    REWIND IFILE
    CALL DATUM(IFILE,165,0,0,
   1    INT,W(I),CHARAC,  IOUT,I,0,1,IPROMP)  
    PHRASE = 
   1 'Normal deflection under uniform pressure: W'
    CALL BLANKX(PHRASE,IBLANK)
    CALL GETVAR(I,0,     W(I),       ICAR,  CAR,WORDB)
165 CONTINUE
166 CONTINUE
C
    WRITE(6,'(A)')'   '
    WRITE(6,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, AW = '
    WRITE(6,'(A)')
   1 '  Number of load cases (number of environments) '
    WRITE(6,'(A)')'   '
    IF (IPROMP.GT.1) THEN
       WRITE(IFILE8,'(A)')'   '
       WRITE(IFILE8,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, AW = '
       WRITE(IFILE8,'(A)')
   1 '  Number of load cases (number of environments) '
       WRITE(IFILE8,'(A)')'   '
    ENDIF
    IF (NCASES.EQ.0) GO TO 171
    DO 170  I=1,NCASES
    REWIND IFILE
    CALL DATUM(IFILE,170,1,1,
   1    INT,AW(I),CHARAC,  IOUT,I,0,1,IPROMP)     
    CALL GETVAR(I,0,     AW(I),    IALLOW,ALLOW,WORDA)
170 CONTINUE
171 CONTINUE
C
    WRITE(6,'(A)')'   '
    WRITE(6,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, FW = '
    WRITE(6,'(A)')
   1 '  Number of load cases (number of environments) '
    WRITE(6,'(A)')'   '
    IF (IPROMP.GT.1) THEN
       WRITE(IFILE8,'(A)')'   '
       WRITE(IFILE8,'(A)')
   1 ' DEFINITION OF THE ROW INDEX OF THE ARRAY, FW = '
       WRITE(IFILE8,'(A)')
   1 '  Number of load cases (number of environments) '
       WRITE(IFILE8,'(A)')'   '
    ENDIF
    IF (NCASES.EQ.0) GO TO 176
    DO 175  I=1,NCASES
    REWIND IFILE
    CALL DATUM(IFILE,175,1,1,
   1    INT,FW(I),CHARAC,  IOUT,I,0,1,IPROMP)     
    CALL GETVAR(I,0,     FW(I),     IFACT,FSAFE,WORDS)
175 CONTINUE
176 CONTINUE
    CALL DATUM(IFILE,180,0,0,   INT, REALL,CHARAC,IOUT,0,0,0,IPROMP)
    CALL DATUM(IFILE,185,0,0,   INT,WEIGHT ,CHARAC,IOUT,0,0,0,IPROMP)
    PHRASE = 
   1 'Weight of the plate: WEIGHT'
    CALL BLANKX(PHRASE,IBLANK)
    CALL GETVAR(0,0,     WEIGHT ,    IOAR, OAR,WORDOB)
=====================================================================
NOTES: 

(1) SUBROUTINE DATUM is located in the library prompter.src . It
searches the prompt file PLATE.PRO for the prompt line with the index
given by the second argument and returns the input datum (fifth
argument of input datum is an integer, sixth if the input datum is
real, and seventh if the input datum is of character type. 

(2) SUBROUTINE GETVAR is located in the library begin.new. It
registers the input datum as belonging to a set with one of the
following roles: 
         =======================================================
          ROLE     SET              DEFINITION OF ROLE
           NO.     NAME
         -------------------------------------------------------
           1       VAR         candidate for decision variable
           2       PAR         constant parameter
           3       FLAR        part of environment (load, temp)
           4       CAR         behavior (stress, buckling, etc.)
           5       ALLOW       allowable
           6       FSAFE       factor of safety
           7       OAR         objective
         =======================================================
\endverbatim
\ven
\beginverbatim
TABLE 10   THE FORTRAN SOURCE CODE FILE  PLATE.COM
          GENERATED BY ``GENTEXT''.  THIS FILE REPRESENTS THE
          DATA BASE FOR THE GENERIC PROBLEM ``PLATE''. THIS
          FILE FORMS PART OF BEGIN.NEW, STOGET.NEW, STRUCT.NEW,
          BEHAVIOR.NEW, AND CHANGE.NEW.
=====================================================================
      COMMON/FV07/AOBAXL(30),IAOBAX
      REAL AOBAXL
      COMMON/FV08/KAXL(30)
      REAL KAXL
      COMMON/FV09/AOBSHR(20),IAOBSH  
      REAL AOBSHR
      COMMON/FV10/KSHR(20)
      REAL KSHR
      COMMON/FV11/Nx(20)
      REAL Nx
      COMMON/FV17/STRESS(20),MAXSTR(20),FSTRES(20)
      REAL STRESS,MAXSTR,FSTRES
      COMMON/FV20/BUCKLE(20),MINBUC(20),FBUCKL(20)
      REAL BUCKLE,MINBUC,FBUCKL
      COMMON/FV23/FREQ(20),MINCPS(20),FSFREQ(20)
      REAL FREQ,MINCPS,FSFREQ
      COMMON/FV26/W(20),AW(20),FW(20)
      REAL W,AW,FW
      COMMON/FV01/THICK,LENGTH,WIDTH,E,NU,RHO,WEIGHT
      REAL THICK,LENGTH,WIDTH,E,NU,RHO,WEIGHT
      COMMON/FV12/Ny(20),Nxy(20),PRESS(20)
      REAL Ny,Nxy,PRESS
=================================================================
NOTE: These labelled common blocks, written and read to auxiliary
storage by STOGET.NEW, represent part of the data base for the
GENTEXT-generated program system.  These labelled common blocks
appear in all of the GENTEXT-generated processors. 
\endverbatim
\ven
\beginverbatim
  TABLE 11  PART OF THE FILE  PLATE.CON  GENERATED BY ``GENTEXT''.
            THIS FILE CONTAINS CALLS TO BEHX1, BEHX2, ... BEHXn  AND
            TO SUBROUTINE CONX, WHICH GENERATES BEHAVIORAL CONSTRAINTS
            FOR OPTIMIZATION.  THIS FILE FORMS PART OF struct.new .
=====================================================================
C
C  Behavior and constraints generated next for STRESS:
C  STRESS = Maximum effective (von Mises) stress
C
      PHRASE =
     1 'Maximum effective (von Mises) stress'
      CALL BLANKX(PHRASE,IENDP4)
      CALL BEHX1  (IFILE8,NPRINX,IMODX, ILOADX  ,
     1 'Maximum effective (von Mises) stress')
      IF (STRESS(ILOADX  ).EQ.0.)  STRESS(ILOADX  ) = 1.E-10
      IF (MAXSTR(ILOADX  ).EQ.0.)  MAXSTR(ILOADX  ) = 1.0
      IF (FSTRES(ILOADX  ).EQ.0.)  FSTRES(ILOADX  ) = 1.0
      KCONX = KCONX + 1
      CARX(KCONX) =STRESS(ILOADX  )
      WORDCX= 'MAXSTR('//CIX//')/[STRESS('//CIX//
     1  ') X FSTRES('//CIX//')]'
      CALL CONX(STRESS(ILOADX  ),MAXSTR(ILOADX  ),FSTRES(ILOADX  )
     1,'Maximum effective (von Mises) stress',
     1 'Maximum effective (von Mises) stress allowed',
     1 'Factor of safety for effective stress',
     1 1,INUMTT,IMODX,CONMAX,ICONSX,IPOINC,CONSTX,WORDCX,
     1 WORDMX,PCWORD,CPLOTX,ICARX)
      IF (IMODX.EQ.0) THEN
         CODPHR =
     1 '  Maximum effective (von Mises) stress: '
         IENDP4 =40
         CODNAM ='STRESS('//CIX//')'
         MLET4 =6 + 4
         WORDBX(KCONX)= CODPHR(1:IENDP4)//CODNAM(1:MLET4)
         IF (NPRINX.GT.0) WRITE(IFILE8,'(I5,6X,G14.7,A,A)')
     1    KCONX,CARX(KCONX),CODPHR(1:IENDP4),CODNAM(1:MLET4)
      ENDIF
  130 CONTINUE
  131 CONTINUE
C
C  Behavior and constraints generated next for BUCKLE:
C  BUCKLE = Buckling load factor
C
      PHRASE =
     1 'Buckling load factor'
      CALL BLANKX(PHRASE,IENDP4)
      CALL BEHX2  (IFILE8,NPRINX,IMODX, ILOADX  ,
     1 'Buckling load factor')
      IF (BUCKLE(ILOADX  ).EQ.0.)  BUCKLE(ILOADX  ) = 1.E+10
      IF (MINBUC(ILOADX  ).EQ.0.)  MINBUC(ILOADX  ) = 1.0
      IF (FBUCKL(ILOADX  ).EQ.0.)  FBUCKL(ILOADX  ) = 1.0
      KCONX = KCONX + 1
      CARX(KCONX) =BUCKLE(ILOADX  )
      WORDCX= 'BUCKLE('//CIX//')/[MINBUC('//CIX//
     1  ') X FBUCKL('//CIX//')]'
      CALL CONX(BUCKLE(ILOADX  ),MINBUC(ILOADX  ),FBUCKL(ILOADX  )
     1,'Buckling load factor',
     1 'Minimum allowable buckling load factor (use 1.0)',
     1 'Factor of safety for buckling load factor',
     1 2,INUMTT,IMODX,CONMAX,ICONSX,IPOINC,CONSTX,WORDCX,
     1 WORDMX,PCWORD,CPLOTX,ICARX)
      IF (IMODX.EQ.0) THEN
         CODPHR =
     1 '  Buckling load factor: '
         IENDP4 =24
         CODNAM ='BUCKLE('//CIX//')'
         MLET4 =6 + 4
         WORDBX(KCONX)= CODPHR(1:IENDP4)//CODNAM(1:MLET4)
         IF (NPRINX.GT.0) WRITE(IFILE8,'(I5,6X,G14.7,A,A)')
     1    KCONX,CARX(KCONX),CODPHR(1:IENDP4),CODNAM(1:MLET4)
      ENDIF
  145 CONTINUE
  146 CONTINUE
C
C  Behavior and constraints generated next for FREQ:
C  FREQ = Fundamental frequency of unloaded plate
C
      PHRASE =
     1 'Fundamental frequency of unloaded plate'
      CALL BLANKX(PHRASE,IENDP4)
      CALL BEHX3  (IFILE8,NPRINX,IMODX, ILOADX  ,
     1 'Fundamental frequency of unloaded plate')
      IF (FREQ(ILOADX  ).EQ.0.)  FREQ(ILOADX  ) = 1.E+10
      IF (MINCPS(ILOADX  ).EQ.0.)  MINCPS(ILOADX  ) = 1.0
      IF (FSFREQ(ILOADX  ).EQ.0.)  FSFREQ(ILOADX  ) = 1.0
      KCONX = KCONX + 1
      CARX(KCONX) =FREQ(ILOADX  )
      WORDCX= 'FREQ('//CIX//')/[MINCPS('//CIX//
     1  ') X FSFREQ('//CIX//')]'
      CALL CONX(FREQ(ILOADX  ),MINCPS(ILOADX  ),FSFREQ(ILOADX  )
     1,'Fundamental frequency of unloaded plate',
     1 'Minimum allowable value for the fundamental frequency',
     1 'Factor of safety for FREQ',
     1 2,INUMTT,IMODX,CONMAX,ICONSX,IPOINC,CONSTX,WORDCX,
     1 WORDMX,PCWORD,CPLOTX,ICARX)
      IF (IMODX.EQ.0) THEN
         CODPHR =
     1 '  Fundamental frequency of unloaded plate: '
         IENDP4 =43
         CODNAM ='FREQ('//CIX//')'
         MLET4 =4 + 4
         WORDBX(KCONX)= CODPHR(1:IENDP4)//CODNAM(1:MLET4)
         IF (NPRINX.GT.0) WRITE(IFILE8,'(I5,6X,G14.7,A,A)')
     1    KCONX,CARX(KCONX),CODPHR(1:IENDP4),CODNAM(1:MLET4)
      ENDIF
  160 CONTINUE
  161 CONTINUE
C
C  Behavior and constraints generated next for W:
C  W = Normal deflection under uniform pressure
C
      PHRASE =
     1 'Normal deflection under uniform pressure'
      CALL BLANKX(PHRASE,IENDP4)
      CALL BEHX4  (IFILE8,NPRINX,IMODX, ILOADX  ,
     1 'Normal deflection under uniform pressure')
      IF (W(ILOADX  ).EQ.0.)  W(ILOADX  ) = 1.E-10
      IF (AW(ILOADX  ).EQ.0.)  AW(ILOADX  ) = 1.0
      IF (FW(ILOADX  ).EQ.0.)  FW(ILOADX  ) = 1.0
      KCONX = KCONX + 1
      CARX(KCONX) =W(ILOADX  )
      WORDCX= 'AW('//CIX//')/[W('//CIX//
     1  ') X FW('//CIX//')]'
      CALL CONX(W(ILOADX  ),AW(ILOADX  ),FW(ILOADX  )
     1,'Normal deflection under uniform pressure',
     1 'Maximum allowable normal deflection under pressure',
     1 'Factor of safety for max deflection under pressure',
     1 1,INUMTT,IMODX,CONMAX,ICONSX,IPOINC,CONSTX,WORDCX,
     1 WORDMX,PCWORD,CPLOTX,ICARX)
      IF (IMODX.EQ.0) THEN
         CODPHR =
     1 '  Normal deflection under uniform pressure: '
         IENDP4 =44
         CODNAM ='W('//CIX//')'
         MLET4 =1 + 4
         WORDBX(KCONX)= CODPHR(1:IENDP4)//CODNAM(1:MLET4)
         IF (NPRINX.GT.0) WRITE(IFILE8,'(I5,6X,G14.7,A,A)')
     1    KCONX,CARX(KCONX),CODPHR(1:IENDP4),CODNAM(1:MLET4)
      ENDIF
  175 CONTINUE
  176 CONTINUE
 1000 CONTINUE
C  END OF LOOP OVER NUMBER OF LOAD SETS (environments)
C
C  NEXT, EVALUATE THE OBJECTIVE, OBJGEN:
      PHRASE ='Weight of the plate'
      CALL BLANKX(PHRASE,IENDP4)
      CALL OBJECT(OBJGEN,'Weight of the plate')
      NCONSX = ICONSX
C
C
      RETURN
      END
C
C  End of the final portion of STRUCT written by "GENTEXT"
=======================================================================
NOTES: 
(1) Skeletal SUBROUTINES BEHXn are listed in TABLE 12. Algorithms
    written by GENOPT user for this case are listed in TABLE 14. 
(2) SUBROUTINE CONX is included in the main.src library.
(3) SUBROUTINE OBJECT is part of the behavior.new library. The
    skeletal version is listed in TABLE 12 and the particular
    algorithm for the objective for this case is listed in TABLE 14.
(4) About ``behavior'', ``behavioral constraint'', ``margin'':
    (i) ``behavior'': refers to a quantity. Example: FREQ(ILOADX).
   (ii) ``behavioral constraint'': refers to a quotient that plays
          a role in constraining the design. The form of a ``type 1''
          constraint (see ``GENTEXT'' interactive session) is:
          (allowable)/[(behavior)*(factor of safety)].
          The form of a ``type 2'' constraint is:
          (behavior)/[(allowable)*(factor of safety)].
          EXAMPLE: MAXSTR(ILOADX)/[STRESS(ILOADX)*FSTRES(ILOADX)] (type 1)
          EXAMPLE: FREQ(ILOADX)/[MINCPS(ILOADX)*FSFREQ(ILOADX)]   (type 2)
  (iii) ``margin'' = ``behavioral constraint'' - 1.0
\endverbatim
\ven
\beginverbatim
TABLE 12   PART OF THE FILE  behavior.new GENERATED BY ``GENTEXT''.
           SKELETAL ROUTINES BEHX1, BEHX2,... BEHXn  AND  SUBROUTINE
           OBJECT ARE TO BE COMPLETED BY THE GENOPT USER IN THIS CASE.
======================================================================
C=DECK      BEHAVIOR.NEW


   (LINES OF DESCRIPTION OMITTED TO SAVE SPACE.)


C=DECK      BEHX1
      SUBROUTINE BEHX1  (IFILE,NPRINX,IMODX,ILOADX,PHRASE)
C
C   PURPOSE: OBTAIN Maximum effective (von Mises) stress
C
C   YOU MUST WRITE CODE THAT, USING
C   THE VARIABLES IN THE LABELLED
C   COMMON BLOCKS AS INPUT, ULTIMATELY
C   YIELDS THE RESPONSE VARIABLE FOR
C   THE ith LOAD CASE, ILOADX:
C
C     STRESS(ILOADX)
C
C   AS OUTPUT. THE ith CASE REFERS
C   TO ith ENVIRONMENT (e.g. load com-
C   bination).
C
C   DEFINITIONS OF INPUT DATA:
C    IMODX  = DESIGN CONTROL INTEGER:
C     IMODX = 0 MEANS BASELINE DESIGN
C     IMODX = 1 MEANS PERTURBED DESIGN
C    IFILE = FILE FOR OUTPUT LIST:
C    NPRINX= OUTPUT CONTROL INTEGER:
C     NPRINX=0 MEANS SMALLEST AMOUNT
C     NPRINX=1 MEANS MEDIUM AMOUNT
C     NPRINX=2 MEANS LOTS OF OUTPUT
C
C     ILOADX = ith LOADING COMBINATION
C     PHRASE = Maximum effective (von Mises) stress
C
C   OUTPUT:
C
C     STRESS(ILOADX)
C
       CHARACTER*80 PHRASE
C  INSERT ADDITIONAL COMMON BLOCKS:
C
       (Common blocks listed in TABLE 10 are inserted here by GENOPT.)
C
C
C  GENOPT USER MAY INSERT SUBROUTINE STATEMENTS HERE.
C
C
       (See Table 14a for the algorithm used in ``PLATE'',
        which must be inserted here by the GENOPT user.)
C
C
C
      RETURN
      END
C
C

     (SUBROUTINES BEHX2 AND BEHX3 ARE OMITTED TO SAVE SPACE.)


C
C=DECK      BEHX4
      SUBROUTINE BEHX4  (IFILE,NPRINX,IMODX,ILOADX,PHRASE)
C
C   PURPOSE: OBTAIN Normal deflection under uniform pressure
C
C   YOU MUST WRITE CODE THAT, USING
C   THE VARIABLES IN THE LABELLED
C   COMMON BLOCKS AS INPUT, ULTIMATELY
C   YIELDS THE RESPONSE VARIABLE FOR
C   THE ith LOAD CASE, ILOADX:
C
C     W(ILOADX)
C
C   AS OUTPUT. THE ith CASE REFERS
C   TO ith ENVIRONMENT (e.g. load com-
C   bination).
C
C   DEFINITIONS OF INPUT DATA:
C    IMODX  = DESIGN CONTROL INTEGER:
C     IMODX = 0 MEANS BASELINE DESIGN
C     IMODX = 1 MEANS PERTURBED DESIGN
C    IFILE = FILE FOR OUTPUT LIST:
C    NPRINX= OUTPUT CONTROL INTEGER:
C     NPRINX=0 MEANS SMALLEST AMOUNT
C     NPRINX=1 MEANS MEDIUM AMOUNT
C     NPRINX=2 MEANS LOTS OF OUTPUT
C
C     ILOADX = ith LOADING COMBINATION
C     PHRASE = Normal deflection under uniform pressure
C
C   OUTPUT:
C
C     W(ILOADX)
C
       CHARACTER*80 PHRASE
C  INSERT ADDITIONAL COMMON BLOCKS:
C
       (Common blocks listed in TABLE 10 are inserted here by GENOPT.)
C
C
C  GENOPT USER MAY INSERT SUBROUTINE STATEMENTS HERE.
C
C
       (See Table 14d for the algorithm used in ``PLATE'',
        which must be inserted here by the GENOPT user.)
C
C
C
      RETURN
      END
C
C

    (SUBROUTINE USRCON NOT LISTED HERE IN ORDER TO SAVE SPACE.)


C
C=DECK      OBJECT
      SUBROUTINE OBJECT(OBJGEN,PHRASE)
C   PURPOSE:Weight of the plate
C
C   YOU MUST WRITE CODE THAT, USING
C   THE VARIABLES IN THE LABELLED
C   COMMON BLOCKS AS INPUT, ULTIMATELY
C   YIELDS THE OBJECTIVE FUNCTION
C         WEIGHT
C   AS OUTPUT. MAKE SURE TO INCLUDE AT
C   THE END OF THE SUBROUTINE, THE
C   STATEMENT: OBJGEN = WEIGHT
C
C   DEFINITION OF PHRASE:
C     PHRASE = Weight of the plate
C
       CHARACTER*80 PHRASE
C  INSERT ADDITIONAL COMMON BLOCKS:
C
       (Common blocks listed in TABLE 10 are inserted here by GENOPT.)
C
C
C  GENOPT USER MAY INSERT SUBROUTINE STATEMENTS HERE.
C
C
       (See Table 14e for the algorithm used in ``PLATE'',
        which must be inserted here by the GENOPT user.)
C
C
      OBJGEN =WEIGHT 
C
C
      RETURN
      END
C
=================================================================
NOTES: 

(1) The GENOPT user inserts certain algorithms for predicting the
behavior. These are listed for the case PLATE in TABLE 14. 

(2) In the more complex case, ``PANEL'', only SUBROUTINE OBJECT was
completed.  (See TABLE 28). The behavioral characteristics were
computed in new subroutines introduced by the GENOPT user into the
library addcode1.src and called from struct.new as listed in TABLE
26. In the more complex case ``PANEL'' the existence of previously
written code made this strategy easier than using BEHX1, BEHX2,...
BEHXn. 

(3) Notice that the argument IMODX appears in the argument lists of
the BEHX1, BEHX2,...BEHXn subroutines.  It may be in some cases that
calculation of the behavior for the perturbed design takes much less
computer time than does calculation of this behavior for the
unperturbed design. (This is true for the complex example, ``PANEL''.)
The GENOPT user may want to include IMODX in his/her strategy for
efficient calculation of the various behaviors for perturbed designs.
\endverbatim
\ven
\beginverbatim
  TABLE 13   PART OF THE FILE struct.new GENERATED BY ``GENTEXT''.
             SUBROUTINE STRUCT PERFORMS ALL THE ANALYSES FOR THE
             VARIOUS GENOPT-USER-DETERMINED BEHAVIORS FOR A GIVEN
             DESIGN CONFIGURATION.
==================================================================
C=DECK      STRUCT
      SUBROUTINE STRUCT(IMODX,CONSTX,OBJGEN,CONMAX,NCONSX,IPOINC,
     1                  PCWORD,CPLOTX)
C
C  PURPOSE IS TO PERFORM THE ANALYSIS FOR A GIVEN DESIGN AND LOADING.
C  CONSTRAINT CONDITIONS ARE ALSO GENERATED.
C
      COMMON/PRMFIL/IFILEX,IFILE2,IOUT,IPRM(5)
      COMMON/PRMOUT/IFILE3,IFILE4,IFILE8,IFILE9,IFILE11
      COMMON/INDAT/INFILE
      COMMON/LWRUPR/VLBX(50),VUBX(50),CLINKX(50,5),VLINKX(50),VBVX(99)
      COMMON/NUMPAR/IPARX,IVARX,IALLOW,ICONSX,NDECX,NLINKX,NESCAP,ITYPEX
      COMMON/PARAMS/PARX(99),VARX(50),ALLOWX(99),CONSXX(99),DECX(50),
     1              ESCX(50)
      COMMON/WORDS1/WORDPX(99),WORDVX(50),WORDAX(99),WORDCC(99),
     1              WORDDX(50)
      COMMON/WORDS2/WORDLX(50),WORDEX(50),WORDIQ(20)
      COMMON/OPTVAR/IDVX(50),ILVX(50),IDLINK(50,5),IEVX(50),JTERMS(20)
      COMMON/NUMPR2/ILARX,ICARX,IOARX,IFLATX,NCASES,NPRINX
      COMMON/PARAM2/FLARX(50),CARX(99),OARX(50),FSAFEX(99),CPWRX(50,5)
      COMMON/PARAM3/CINEQX(5,20),DPWREQ(5,20)
      COMMON/PARAM4/IDINEQ(5,20),NINEQX,JINEQX(20),IEQTYP(20)
      COMMON/WORDS3/WORDFX(50),WORDBX(99),WORDOB(50),WORDSX(99)
      COMMON/WORDS4/WORDMX(99)
      COMMON/PWORD/PHRASE
      COMMON/PWORD2/IBLANK
C
C==========================================================================
C  Start of first part of STRUCT written by "GENTEXT"
C  INSERT ADDITIONAL COMMON BLOCKS HERE: (THESE ARE ``GENTEXT''
C  VARIABLES)

      (Common blocks listed in TABLE 10 inserted here.)

C
C
C
      CHARACTER*80 PHRASE,CODPHR,PCWORD
      CHARACTER*80 WORDPX,WORDVX,WORDAX,WORDCX,WORDDX,WORDLX,WORDEX
      CHARACTER*80 WORDFX,WORDBX,WORDOB,WORDSX,WORDMX,WORDCC,WORDIQ
      CHARACTER*4 ANSOUT,CHARAC,ANSWER
      CHARACTER*2 CIX,CJX
      CHARACTER*13 CODNAM
      DIMENSION ISUBX(100)
      LOGICAL ANSL1
C
      DIMENSION CONSTX(*),IPOINC(*),PCWORD(*),CPLOTX(*)
C  End of first part of STRUCT written by "GENTEXT"
C==========================================================================
C
C  INSERT ADDITIONAL DIMENSION AND/OR LABELLED COMMON BLOCKS HERE,
C  IF NECESSARY. THESE WOULD BE STATEMENTS THAT ARE CONSISTENT WITH
C  SUBROUTINES THAT YOU OR OTHERS MAY HAVE WRITTEN THAT ARE REQUIRED
C  FOR WHATEVER ANALYSIS YOU ARE PERSUING.  MAKE SURE THAT YOU DO NOT
C  INTRODUCE NAME CONFLICTS WITH THE "GENTEXT" LABELLED COMMON BLOCKS
C  LISTED ABOVE.
C
C  Please note that you do not have to modify struct.new if you would
C  rather provide all of your algorithms via the behavior.new library.
C  (See instructions in behavior.new).
C
C  If you are using a lot of software previously written either by
C  yourself or others, or if there are a lot of behavioral constraints
C  that are best generated by looping over array indices (such as
C  occurs, for example, with stress constraints in laminates of
C  composite materials), then it may be best to insert your common
C  blocks and dimension statements here, your subroutine calls
C  below (where indicated), and your subroutines in any of the libraries
C  called addcode[n].src, n = 1,2,...,5.  Please note that you will
C  probably also have to add statements to SUBROUTINE TRANFR, the
C  purpose of which is described below (in TRANFR).
C
C  The two test cases provided with GENOPT demonstrate both methods:
C
C  PLATE (Test Case 1): leave struct.new unchanged and modify behavior.new
C  PANEL (Test Case 2): leave behavior.new unchanged except for the objective
C                       function (SUBROUTINE OBJECT), modify struct.new,
C                       add a subroutine library called addcode1.src, and
C                       augment the usermake.{machine} file to collect object
C                       libraries from other directories (PANDA2, in this
C                       example.)
C
C  THE FOLLOWING CODE WAS WRITTEN BY "GENTEXT":
C
C================================================================
C  Start the second portion of STRUCT written by "GENTEXT":
C
      ICARX   = 0
      INUMTT = 0
      ICONSX = 0
      KCONX   = 0
      IF (IMODX.EQ.0) THEN
         CALL MOVERX(0.,0,CONSTX,1,99)
         CALL MOVERX(0, 0,IPOINC,1,1500)
      ENDIF
C
C  ESTABLISH FIRST ANY CONSTRAINTS THAT ARE INEQUALITY RELATIONSHIPS
C  AMONG THE VARIABLES IN THE ARRAY VARX(*) (THAT IS, VARIABLES THAT
C  ARE EITHER DECISION VARIABLES, LINKED VARIABLES, ESCAPE VARIABLES,
C  OR CANDIDATES FOR ANY OF THESE TYPES OF VARIABLES.
C
      IF (NINEQX.GT.0) CALL VARCON(WORDIQ,WORDMX,CINEQX,DPWREQ,IDINEQ,
     1     NINEQX,JINEQX,IEQTYP,INUMTT,IMODX,CONMAX,IPOINC,
     1     ICONSX,CONSTX,VARX,PCWORD,CPLOTX,ICARX)
C
C  NEXT, ESTABLISH USER-WRITTEN CONSTRAINTS. AT PRESENT, THE PROGRAM
C  ALLOWS ONLY ONE USER-WRITTEN CONSTRAINT. HOWEVER, THE USER CAN
C  EASILY EXPAND THIS CAPABILITY SIMPLY BY ADDING SUBROUTINES THAT
C  ARE ANALOGOUS TO USRCON (WITH NAMES SUCH AS USRCN2, USRCN3, ETC.
C  TO THE  BEHAVIOR.NEW LIBRARY, AND ADD CALLS TO THESE ADDITIONAL
C  SUBROUTINES FOLLOWING THE CALL TO USRCON IMMEDIATELY BELOW.
C
      CALL USRCON(INUMTT,IMODX,CONMAX,ICONSX,IPOINC,CONSTX,WORDCX,
     1            WORDMX,PCWORD,CPLOTX,ICARX,IFILE8)
C
C
C  USER: YOU MAY ADD SUBROUTINE CALLS EITHER HERE OR BELOW (WITHIN
C        THE "DO 1000  ILOADX = 1,NCASES"  LOOP.  YOU MIGHT WANT TO DO
C        THIS IF YOU ARE USING PREVIOUSLY DEVELOPED SOFTWARE, OR IF YOUR
C        PARTICULAR CLASS OF PROBLEMS IS BETTER SOLVED BY PERFORMING
C        CERTAIN CALCULATIONS OUTSIDE THE "DO 1000" LOOP OR OUTSIDE THE
C        INDIVIDUAL "BEHAVIOR" SUBROUTINES, BEH1, BEH2, ... BEHn, CALLED
C        BELOW.
C
C        IF YOU DECIDE TO DO THIS, IT IS BEST TO ASSEMBLE
C        ALL YOUR SUBROUTINES INTO LIBRARIES CALLED ADDCODE2.NEW,
C        ADDCODE3.NEW,...ADDCODEn.NEW.  (THE LIBRARY CALLED ADDCODE1.NEW
C        NOW CONTAINS SUBROUTINES FROM PANDA2 PERTAINING TO BUCKLING AND
C        STRESS OF STRINGER AND RING STIFFENED FLAT OR CYLINDRICAL
C        COMPOSITE PANELS.)  IF POSSIBLE, ASSEMBLE ALL YOUR SUBROUTINES
C        INTO A SINGLE LIBRARY.  MODIFY THE  LINKMAIN.COM  PROCEDURE
C        TO REFLECT YOUR LIBRARY OR LIBRARIES.  FOR AN EXAMPLE OF HOW
C        THIS IS DONE, SEE THE DISCUSSION OF THE CASE CALLED "PANEL".
C
C
C
      IF (NPRINX.GT.0) THEN
         WRITE(IFILE8,'(1X,A,I2,A)')
     1 ' BEHAVIOR FOR ',NCASES,' ENVIRONMENTS (LOADS)'
         WRITE(IFILE8,'(A)')'  '
         WRITE(IFILE8,'(A)')
     1 ' CONSTRAINT  BEHAVIOR              DEFINITION'
         WRITE(IFILE8,'(A)')
     1 '   NUMBER     VALUE'
      ENDIF
C
C  BEGINNING OF LOOP OVER LOAD SETS (environments)
C
      DO 1000 ILOADX = 1,NCASES
C
      CALL CONVR2(ILOADX,CIX)
      IF (NPRINX.GT.0) THEN
         WRITE(IFILE8,'(1X,A)')'  '
         WRITE(IFILE8,'(1X,A,I2)')
     1 ' BEHAVIOR FOR LOAD SET NUMBER, ILOADX=',ILOADX
      ENDIF
C
C  End of the second portion of STRUCT written by "GENTEXT"
C=======================================================================
C
C  USER: YOU MAY WANT TO INSERT SUBROUTINE CALLS FROM SOFTWARE DEVELOPED
C        ELSEWHERE FOR ANY CALCULATIONS PERTAINING TO THIS LOAD SET.
C        (IF YOU WANT, YOU MAY ALSO INSERT CALLS OUTSIDE THE
C        "D0 1000 ILOADX = 1,NCASES"  LOOP, AS DESCRIBED ABOVE.
C
C
C=======================================================================
C  Start of the final portion of STRUCT written by "GENTEXT"
C
C  INSERT THE PROGRAM FILE HERE:
C
C  Behavior and constraints generated next for STRESS:
C  STRESS = Maximum effective (von Mises) stress
C
      PHRASE =
     1 'Maximum effective (von Mises) stress'
      CALL BLANKX(PHRASE,IENDP4)
      CALL BEHX1  (IFILE8,NPRINX,IMODX, ILOADX  ,
     1 'Maximum effective (von Mises) stress')
      IF (STRESS(ILOADX  ).EQ.0.)  STRESS(ILOADX  ) = 1.E-10
      IF (MAXSTR(ILOADX  ).EQ.0.)  MAXSTR(ILOADX  ) = 1.0
      IF (FSTRES(ILOADX  ).EQ.0.)  FSTRES(ILOADX  ) = 1.0


    (MANY LINES SKIPPED TO SAVE SPACE. THIS CODING IS CONTAINED
     IN THE FILE PLATE.CON, PART OF WHICH IS LISTED IN TABLE 11.)


  175 CONTINUE
  176 CONTINUE
 1000 CONTINUE
C  END OF LOOP OVER NUMBER OF LOAD SETS (environments)
C
C  NEXT, EVALUATE THE OBJECTIVE, OBJGEN:
      PHRASE ='Weight of the plate'
      CALL BLANKX(PHRASE,IENDP4)
      CALL OBJECT(OBJGEN,'Weight of the plate')
      NCONSX = ICONSX
C
C
      RETURN
      END
C
C  End of the final portion of STRUCT written by "GENTEXT"
C=======================================================================
C
C=DECK      TRANFR
      SUBROUTINE TRANFR(ARG1,ARG2,ARG3,ARG4,ARG5)
C
C  USER:  DO NOT FORGET TO MODIFY THE ARGUMENT LIST OF TRANFR AS
C         APPROPRIATE FOR YOUR CASE!
C
C  PURPOSE IS TO TRANSFER DATA FROM THE LABELLED COMMON BLOCKS
C  SET UP BY THE GENOPT CODE TO LABELLED COMMON OR ARGUMENTS IN
C  THE SUBROUTINE ARGUMENT LIST THAT MATCH PREVIOUSLY WRITTEN CODE
C  BY YOURSELF OR OTHER PROGRAM DEVELOPERS.  THE USER SHOULD ESTABLISH
C  THE ARGUMENT LIST AND/OR LABELLED COMMON BLOCKS THAT MATCH VARIABLES
C  IN THE PREVIOUSLY WRITTEN CODE.  FOR AN EXAMPLE, SEE THE DISCUSSION
C  OF THE CASE CALLED "PANEL".
C
C==========================================================================
C  Start of part of TRANFR written by "GENTEXT"
C  INSERT ADDITIONAL COMMON BLOCKS HERE: (THESE ARE ``GENTEXT''
C  VARIABLES)

      (Common blocks listed in TABLE 10 inserted here.)

C
C  End of part of TRANFR written by "GENTEXT"
C==========================================================================
C  Start part of TRANFR written by GENOPT user...
C
C  INSERT ADDITIONAL DIMENSION AND/OR LABELLED COMMON BLOCKS HERE,
C  IF NECESSARY. THESE WOULD BE STATEMENTS THAT ARE CONSISTENT WITH
C  SUBROUTINES THAT YOU OR OTHERS MAY HAVE WRITTEN THAT ARE REQUIRED
C  FOR WHATEVER ANALYSIS YOU ARE NOW PERSUING.  MAKE SURE THERE ARE
C  NO NAME CONFLICTS WITH THE "GENTEXT" LABELLED COMMON BLOCKS.
C
C
C  INSERT APPROPRIATE FORTRAN STATEMENTS HERE (DON'T FORGET TO CORRECT
C  THE ARGUMENT LIST OF SUBROUTINE TRANFR!)
C  PROGRAM FILE:
C
C
      RETURN
      END
C
C====================================================================
=====================================================================
NOTE:  In this simple case, ``PLATE'',  struct.new was not modified by
       the GENOPT user.  For an example of modification of STRUCT.NEW,
       see the more complex example, ``PANEL''.
\endverbatim
\ven
\beginverbatim
        TABLE 14  ALGORITHMS USED IN  BEHAVIOR.NEW
                  FOR THE SIMPLE CASE ``PLATE''
=====================================================================

(a) GENOPT-user-written code for insertion into SUBROUTINE BEHX1:

C   PURPOSE: OBTAIN Maximum effective (von Mises) stress
C
      SA1 = Nx(ILOADX)/THICK
      SB1 = Ny(ILOADX)/THICK
      SAB = Nxy(ILOADX)/THICK
      ALPHA = WIDTH/LENGTH
C
C  MAX. EFFECTIVE STRESS UNDER UNIFORM PRESSURE (LINEAR THEORY)
C  (TAKEN FROM ROARK, 3RD EDITION, 1954, TABLE X, FORMULA 36, P. 203
C   VALID FOR POISSON RATIO NU = 0.3) NOTE: VALID ONLY FOR LINEAR
C   BEHAVIOR!!!)
C
      SA2 = (PRESS(ILOADX)*WIDTH**2/THICK**2)*(0.225 +0.382*ALPHA**2
     1                                        -0.320*ALPHA**3)
      SB2 = 0.75*PRESS(ILOADX)*WIDTH**2/
     1               (THICK**2*(1. +1.61*ALPHA**3))
C
C  EFFECTIVE STRESS AT SURFACE WHERE PRESSURE IS APPLIED:
C
      SATOP = SA1 - SA2
      SBTOP = SB1 - SB2
      SEFTOP= SQRT(SATOP**2 +SBTOP**2 - SATOP*SBTOP +3.*SAB**2)
C
C  EFFECTIVE STRESS AT OPPOSITE SURFACE:
C
      SABOT = SA1 + SA2
      SBBOT = SB1 + SB2
      SEFBOT= SQRT(SABOT**2 +SBBOT**2 - SABOT*SBBOT +3.*SAB**2)
C
      STRESS(ILOADX) = MAX(SEFTOP,SEFBOT)
---------------------------------------------------------------------
(b) GENOPT-user-written code for insertion into SUBROUTINE BEHX2:
C
C   PURPOSE: OBTAIN Buckling load factor
C
      BUCKLE(ILOADX) = 0.
C
      GO TO (10,20,30), ILOADX
C
   10 CONTINUE
C
C  BUCKLING LOAD FACTOR UNDER UNIFORM AXIAL COMPRESSION, Nx:
C  TAKEN FROM ROARK, 3RD EDITION, 1954, TABLE XVI, FORMULA 1, P. 312
C
      CALL INTERP(IFILE,IAOBAX,AOBAXL,KAXL,LENGTH/WIDTH,COEFAX)
C     WRITE(6,*)' COEFAX,LENGTH/WIDTH =',COEFAX,LENGTH/WIDTH
      IF (Nx(ILOADX).LT.0.)
     1 BUCKLE(ILOADX) =(COEFAX*(E*THICK/(1.-NU**2))*(THICK/WIDTH)**2)/
     1 ABS(Nx(ILOADX))
      GO TO 50
C
   20 CONTINUE
C
C  BUCKLING UNDER UNIFORM IN-PLANE SHEAR, Nxy:
C  AGAIN, TAKEN FROM ROARK, 3RD EDITION, TABLE XVI, FORMULA 10, P. 313
C
      CALL INTERP(IFILE,IAOBSH,AOBSHR,KSHR,LENGTH/WIDTH,COEFSH)
C     WRITE(6,*)' COEFSH,LENGTH/WIDTH =',COEFSH,LENGTH/WIDTH
      IF (Nxy(ILOADX).NE.0.)
     1 BUCKLE(ILOADX)=(COEFSH*(E*THICK/(1.-NU**2))*(THICK/WIDTH)**2)/
     1 ABS(Nxy(ILOADX))
      GO TO 50
C
   30 CONTINUE
C
C  THERE IS NO BUCKLING UNDER UNIFORM NORMAL PRESSURE.
C
   50 CONTINUE
-------------------------------------------------------------------

(c) GENOPT-user-written code for insertion into SUBROUTINE BEHX3:
C
C   PURPOSE: OBTAIN Fundamental frequency of unloaded plate
C
      FREQ(ILOADX) = 0.
C
      GO TO (50,50,30),ILOADX
C
C  FIND FUNDAMENTAL NATURAL FREQUENCY FOR UNLOADED PLATE.
C  THE VALUE ESTABLISHED FOR ILOADX = 3 IGNORES THE EFFECT OF ANY
C  TENSION THAT MAY DEVELOP IN THE PLATE WHEN IT IS LOADED BY NORMAL
C  PRESSURE.  NO FREQUENCIES ARE CALCULATED FOR THE PLATE AS
C  LOADED AXIALLY (LOAD CASE 1) OR IN UNIFORM IN-PLANE SHEAR
C  (LOAD CASE 2).
C
   30 CONTINUE
      D = E*THICK**3/(12.*(1.-NU**2))
      DMASS = RHO/386.4
      PI = 3.1415927
C
C  CALCULATE FUNDAMENTAL FREQUENCY IN CPS, NOT RADIANS/SECOND:
C  TAKEN FROM LEISSA, ``VIBRATION OF PLATES'', NASA SP-160, P. 44, 
C  EQ. 4.20:
C
      FREQ(ILOADX)
     1       = SQRT(D/DMASS)*((1./LENGTH)**2 + (1./WIDTH)**2)*.5*PI
C
   50 CONTINUE
---------------------------------------------------------------------

(d) GENOPT-user-written code for insertion into SUBROUTINE BEHX4:
C
C   PURPOSE: OBTAIN Normal deflection under uniform pressure
C
C  AS WITH THE VIBRATION OF THE UNLOADED PLATE, HERE WE ARE
C  NOT CONCERNED WITH THE NORMAL DEFLECTION UNDER AXIAL COMPRESSION
C  (Nx, ILOADX=1) OR UNDER UNIFORM IN-PLANE SHEAR (Nxy, ILOADX=2).
C
       W(ILOADX) = 0
       GO TO (50,50,30),ILOADX
C
   30 CONTINUE
C
C  TAKEN FROM ROARK, 3RD EDITION, TABLE X, FORMULA 36, P. 203, 1954:
C  NOTE:  VALID ONLY FOR LINEAR THEORY!!!
C
      W(ILOADX) = .1422*PRESS(ILOADX)*WIDTH**4/
     1          (E*THICK**3*(1. +2.21*(WIDTH/LENGTH)**3))
C
   50 CONTINUE
---------------------------------------------------------------------

(e) GENOPT-user-written code for insertion into SUBROUTINE OBJECT:
C
C   PURPOSE:Weight of the plate
C
C  CALCULATE THE WEIGHT OF THE RECTANGULAR PLATE...
C
      WEIGHT = RHO*LENGTH*WIDTH*THICK
C
=====================================================================
NOTES:
(1) These five algorithms are to be inserted in positions analogous
to those indicated in TABLE 12 for BEHX1, BEHX4, and OBJECT.  (BEHX2
and BEHX3 omitted in TABLE 12 to save space.) 

(2) Notice in (b) that the buckling loads for axial compression and
in-plane shear are calculated from formulas that include the use of
tables of buckling coefficients v. the aspect ratio of the plate,
LENGTH/WIDTH.  The actual tabular values of the buckling load
coefficients KAXL for axial buckling and KSHR for shear buckling will
be provided later by the end user.  The GENOPT user provided the
OPPORTUNITY for the end user to compute the buckling load factors
with the use of interpolated coefficients. This illustrates an
important point:  GENOPT can be used for setting up simple program
systems for optimizing things for which there exist design curves
that can be expressed in the computer in tabular form.  The linear
interpolator, INTERP, is located in the library util.src . 
\endverbatim
\ven
\beginverbatim
  TABLE 15   WHAT HAPPENS WHEN THE GENOPT USER TYPES ``GENPROGRAMS''
====================================================================
$ GENPROGRAMS      (Generate absolute elements for user-friendly
                    optimization program for the class of problems
                    called  PLATE)

The purpose of GENPROGRAMS is to generate absolute elements. 

The file "usermake.{machine}" will be used as a command file for the
UNIX utility "make" and will bring up to date all the executables.
It will only "make" those files that have changed since the previous
"make".  If no previous genprograms has been performed then all the
executables are created.

Next, type the command, BEGIN
=====================================================================
\endverbatim
\ven
\beginverbatim
  TABLE 16  FILES GENERATED AS A RESULT OF THE COMMAND ``GENPROGRAMS''
=====================================================================
  Files produced by GENPROGRAMS (* = executable)
                                (/ = objects, libraries stored here)

      -rwxr-xr-x  1 bushnell   147792 May 14 16:13 store.dec*
      drwxr-xr-x  2 bushnell      512 May 14 16:13 libraries.dec/
      -rwxr-xr-x  1 bushnell   561780 May 14 16:13 optimize.dec*
      drwxr-xr-x  2 bushnell      512 May 14 16:09 objects.dec/
      -rwxr-xr-x  1 bushnell   217468 May 14 16:08 mainsetup.dec*
      -rwxr-xr-x  1 bushnell   391568 May 14 16:08 diplot.dec*
      -rwxr-xr-x  1 bushnell   259704 May 14 16:07 decide.dec*
      -rwxr-xr-x  1 bushnell   245552 May 14 16:05 chooseplot.dec*
      -rwxr-xr-x  1 bushnell   228552 May 14 16:04 change.dec*
      -rwxr-xr-x  1 bushnell   231608 May 14 16:02 begin.dec*

====================================================================
\endverbatim
\ven
\beginverbatim
  TABLE 17   PART OF THE INTERACTIVE ``BEGIN'' SESSION
             CONDUCTED BY THE END USER
====================================================================
$ BEGIN        (PROVIDE STARTING DESIGN, MATERIAL PROPERTIES, ETC.)

THE NAME OF THE PROMPT FILE ASKED FOR NEXT
IS THE NAME OF THE CLASS OF PROBLEMS THAT THE GENOPT-USER
HAS CHOSEN, NOT THE NAME OF THE PARTICULAR CASE BEING
STUDIED HERE. IT IS THE ``NAME'' PART OF ``NAME''.PRO.

ENTER THE GENERIC CASE NAME:  PLATE

FROM HERE ON, WHENEVER THE CASE NAME IS REQUESTED,
YOU PROVIDE THE NAME OF THE PARTICULAR INSTANCE IN THE CLASS
OF PROBLEMS THAT YOU ARE NOW STUDYING.  THIS NAME MUST BE
DIFFERENT FROM THE NAME YOU HAVE JUST PROVIDED ABOVE.

ENTER THE SPECIFIC CASE NAME:  PLATE1


***************************   BEGIN   *****************************
Purpose of BEGIN is to permit you to provide a starting design in an
interactive mode. You give starting dimensions, material properties,
allowables. The interactive session is stored on a file called
PLATE1.BEG, in which PLATE1 is a name that you have chosen for the
specific case. (The name, PLATE1 must remain the same as you use
BEGIN, DECIDE, MAINSETUP, OPTIMIZE, and CHANGE.)  In future runs of
the same or a slightly modified case, you will find it convenient to
use the file PLATE1.BEG as input.  Rather than answer all the
questions interactively, you can use PLATE1.BEG or an edited version
of PLATE1.BEG as input to BEGIN.  BEGIN also generates an output file
called PLATE1.OPB. OPB lists a summary of the case, and if you choose
the tutorial option, the questions, helps, and your answers for each
input datum. 
*******************************************************************
                                                             
Now you start to provide input data. You will be prompted by short
questions. If you need help, just type H as an answer to the prompt
instead of the datum called for. In most instances you will then be
given more information on the datum you must provide. It may be a
good idea to run the tutorial option if you are a new user of this
program. 
                                                   
PROGRAM FOR OPTIMIZATION OF A RECTANGULAR PLATE          
SUBJECTED TO SEVERAL LOADING ENVIRONMENTS AND           
CONSTRAINTS ON STRESS, BUCKLING, DISPLACEMENT, AND FREQUENCY.     
                                             
                                             
FIRST, PROVIDE ALL VARIABLES THAT CAN BE DECISION VARIABLES, 
THAT IS, VARIABLES THAT CAN CHANGE DURING OPTIMIZATION     
ITERATIONS (ROLE TYPE 1), AND FIXED VARIABLES (ROLE TYPE 2)
                                                            
thickness of the plate: THICK=.1
Length of the plate: LENGTH=10
Width of the plate: WIDTH=6.6667
Young's modulus of the plate material: E=10000000.
Poisson's ratio of the plate material: NU=.3
Weight density (e.g. lb/in**3) of the plate material: RHO=.1
                                                              
THE FOLLOWING TABLE (FROM ROARK, 3RD EDITION, TABLE XVI,    
ENTRY NO. 1, PAGE 312), GIVES THE RELATIONSHIP OF PLATE     
(LENGTH/WIDTH) TO A COEFFICIENT FOR BUCKLING UNDER UNIFORM     
AXIAL COMPRESSION.                                  
  
DEFINITION OF THE ROW INDEX OF THE ARRAY, AOBAXL = 
Number of entries in the table of axial buckling v. a/b
   
Number IAOBAX of rows in the array  AOBAXL: IAOBAX=16
(plate length, LENGTH)/(plate width, WIDTH): AOBAXL( 1)=.2
(plate length, LENGTH)/(plate width, WIDTH): AOBAXL( 2)=.3



      (MANY LINES SKIPPED IN ORDER TO SAVE SPACE)



DEFINITION OF THE ROW INDEX OF THE ARRAY, W = 
Number of load cases (number of environments) 
   
Normal deflection under uniform pressure: W
Normal deflection under uniform pressure: W
Normal deflection under uniform pressure: W
   
DEFINITION OF THE ROW INDEX OF THE ARRAY, AW = 
Number of load cases (number of environments) 
   
Maximum allowable normal deflection under pressure: AW( 1)=0
Maximum allowable normal deflection under pressure: AW( 2)=0
Maximum allowable normal deflection under pressure: AW( 3)=.1
   
DEFINITION OF THE ROW INDEX OF THE ARRAY, FW = 
Number of load cases (number of environments) 
   
Factor of safety for max deflection under pressure: FW( 1)=0
Factor of safety for max deflection under pressure: FW( 2)=0
Factor of safety for max deflection under pressure: FW( 3)=1
                                                       
LAST, AN OBJECTIVE MUST BE CHOSEN, SUCH AS MINIMUM WEIGHT 
OR MINIMUM COST.                         
                                        
Weight of the plate: WEIGHT      

DESCRIPTION OF FILES GENERATED BY THIS CASE:

PLATE1.NAM = This file contains only the name of the case.
PLATE1.BEG = Summary of interactive session you have just
             completed. This file can be edited and used for
             future runs of BEGIN.

PLATE1.CBL = Contains the PLATE1 data base.

PLATE1.OPB = Output from BEGIN. Please list this file and
             inspect it and the PLATE1.BEG file carefully before
             proceeding.

For further information about files generated during operation
of GENOPT give the command HELPG FILES.

Next, give the command   DECIDE   .
======================================================================
\endverbatim
\ven
\beginverbatim
   TABLE 18  PART OF THE FILE  PLATE1.BEG  GENERATED BY ``BEGIN''
======================================================================
    N         $ Do you want a tutorial session and tutorial output?
0.1000000     $ thickness of the plate: THICK
      10      $ Length of the plate: LENGTH
 6.666700     $ Width of the plate: WIDTH
0.1000000E+08 $ Young's modulus of the plate material: E
0.3000000     $ Poisson's ratio of the plate material: NU
0.1000000     $ Weight density (lb/in**3) of the plate material: RHO
      16      $ Number IAOBAX of rows in the array  AOBAXL: IAOBAX
0.2000000     $ (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(1)
0.3000000     $ (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(2)



         (MANY LINES SKIPPED IN ORDER TO SAVE SPACE.)



       0   $ Maximum allowable normal deflection under pressure: AW(1)
       0   $ Maximum allowable normal deflection under pressure: AW(2)
0.1000000  $ Maximum allowable normal deflection under pressure: AW(3)
       0   $ Factor of safety for max deflection under pressure: FW(1)
       0   $ Factor of safety for max deflection under pressure: FW(2)
       1   $ Factor of safety for max deflection under pressure: FW(3)
=====================================================================
NOTE:  In the last six entries the loop over 3 corresponds to looping
over the number of load cases.  The allowables AW(1) and AW(2) and
the factors of safety FW(1) and FW(2) are zero because there is no
normal deflection of the plate corresponding to load case 1 (axial
compression) nor to load case 2 (in-plane shear). 
\endverbatim
\ven
\beginverbatim
        TABLE 19  PART OF THE INTERATIVE ``DECIDE'' SESSION
                  CONDUCTED BY THE END USER
====================================================================
$ DECIDE    (CHOOSE DECISION VARIABLES, LINKED VARIABLES, INEQUALITY
             CONSTRAINTS, AND ``ESCAPE'' VARIABLES FOR OPTIMIZATION.)

ENTER THE SPECIFIC CASE NAME:  PLATE1

*************************   DECIDE   *****************************
The purpose of DECIDE is to permit you to choose decision variables,
linked variables, inequality constraints based on dimensions, not
behavior, and escape variables for the optimization run or runs to
follow. The results of the interactive session are saved in a file
called PLATE1.DEC, in which PLATE1 is your name for the case. You may
find this file useful for future runs of DECIDE in which you want to
avoid answering many questions interactively. DECIDE also generates a
file called PLATE1.OPD.  PLATE1.OPD contains a summary of
optimization parameters. If you choose the tutorial option,
PLATE1.OPD contains a complete list of the interactive session,
including prompting questions, all ``help'' paragraphs, your responses
to the prompting questions, and evolving lists of optimization
parameters as they are chosen by you. 
*******************************************************************

PARAMETERS FROM WHICH A DECISION VARIABLE MUST NOW BE CHOSEN     
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK  
  2    1.000E+01  Length of the plate: LENGTH  
  3    6.667E+00  Width of the plate: WIDTH   

Choose a decision variable (1,2,3,...)=H
                                 
Use an index from the left-hand column of the table above.
                                          
Choose a decision variable (1,2,3,...)= 1
Lower bound of variable no.( 1)=.3
Upper bound of variable no.( 1)=1
Any more decision variables (Y or N) ?=Y

            DECISION VARIABLES CHOSEN SO FAR                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK 

PARAMETERS FROM WHICH A DECISION VARIABLE MUST NOW BE CHOSEN     
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  2    1.000E+01  Length of the plate: LENGTH 
  3    6.667E+00  Width of the plate: WIDTH 

Choose a decision variable (1,2,3,...)=2
Lower bound of variable no.( 2)=5
Upper bound of variable no.( 2)=100
Any more decision variables (Y or N) ?=Y

            DECISION VARIABLES CHOSEN SO FAR                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK 
  2    1.000E+01  Length of the plate: LENGTH 

PARAMETERS FROM WHICH A DECISION VARIABLE MUST NOW BE CHOSEN     
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  3    6.667E+00  Width of the plate: WIDTH 
                                 
Choose a decision variable (1,2,3,...)=3
Lower bound of variable no.( 3)=5
Upper bound of variable no.( 3)=10
Any more decision variables (Y or N) ?=N

         DECISION VARIABLES FOR THE OPTIMIZATION PROBLEM          
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK 
  2    1.000E+01  Length of the plate: LENGTH 
  3    6.667E+00  Width of the plate: WIDTH 

LOWER AND UPPER BOUNDS OF THE DECISION VARIABLES                 
 VARIABLE NO.    DEFINITION VALUE        DEFINITION
  1                   3.000E-02  Lower bound of variable no.(1 )
  1                   1.000E+00  Upper bound of variable no.(1 )
  2                   5.000E+00  Lower bound of variable no.(2 )
  2                   1.000E+02  Upper bound of variable no.(2 )
  3                   5.000E+00  Lower bound of variable no.(3 )
  3                   1.000E+01  Upper bound of variable no.(3 ) 
                                        
Next, choose linked variables.
                                
A linked variable is a variable that is not a decision variable, but
is expressed in terms of decision variables, thus: 
                    
  (linked variable)  =  C1*(decision variable no. j1)**D1
                       +C2*(decision variable no. j2)**D2
                       +C3*(decision variable no. j3)**D3  
                       +etc (up to max. of 5 terms)     
                    
in which C1, C2,..; D1, D2,.. are constants. For example, suppose you
have a problem in which the area of a plate is fixed, but either the
length or width may be a decision variable. Suppose we arbitrarily
choose the length to be the decision variable, then we know that 
                                     
               WIDTH = AREA/LENGTH 
                                  
From the general expression above, C1 = AREA and D1 = -1. Decision
variable no. j1 is LENGTH. 
       
Any linked variables (Y or N) ?=N


START BUILDING THE INEQUALITY CONSTRAINTS BASED ON DIMENSIONS.

************ SPECIAL NOTE ADDED FOR THIS SAMPLE CASE: *************

IN THIS CASE THERE ARE THREE INEQUALITY CONSTRAINTS:
  CONSTRAINT 1 ``SAYS'' THE AREA OF THE PLATE MUST BE LESS THAN 100.
  CONSTRAINT 2 ``SAYS'' THE AREA OF THE PLATE MUST BE GREATER THAN 50.
  CONSTRAINT 3 ``SAYS'' THE VARIABLE ``LENGTH'' MUST BE GREATER THAN
                      THE VARIABLE ``WIDTH''.

********************** END OF SPECIAL NOTE ************************
                                                  
Next, establish inequality relations among variables of the two
forms: 
                            
  1.0 < f(v1,v2,v3,...)    or   1.0 > f(v1,v2,v3,...)   
                        
in which the expression f(v1,v2,v3,...) has the form:  
                        
   f(v1,v2,v3,...) = C0 +C1*v1**D1 +C2*v2**D2 +C3*v3**D3 + ... 
                        +etc (up to max. of 5 terms).     
                
The variables, v1, v2, v3,..., can be any of the variables that are
decision variables or potential candidates for decision variables or
linked variables. 
                           
Any inequality relations among variables? (type H)=H
                             
You may want to impose lower and upper bounds on linked variables, or
you may want to force certain expressions involving combinations of
variables to be larger than or less than certain values.  For
example, you may want to force the height of a stiffener segment to
be no more than 15 times its total thickness. Or you may want the
length of a plate always to be greater than 1.5 times its width. 
                        
The inequality relations have either of the two forms: 

  1.0 < f(v1,v2,v3,...)    or   1.0 > f(v1,v2,v3,...) 

in which the expression f(v1,v2,v3,...) has the form:  

   f(v1,v2,v3,...) = C0 +C1*v1**D1 +C2*v2**D2 +C3*v3**D3 + ...
                        +etc (up to max. of 5 terms).    

The variables, v1, v2, v3,..., can be any of the variables that are
decision variables or potential candidates for decision variables or
linked variables. 
                                            
Any inequality relations among variables? (type H)=Y Want to see an
example of how to calculate C0, C1, D1,..?=Y 
                                                 
For example, suppose that you want to impose the condition that the
area of a rectangular plate be greater than 50. Let v1 = length of
plate;  v2 = width of plate. You want 

      v1*v2 > 50                              (1)   

The expression (1) must be expressed in the form 

        1.0 > C0 + C1*v1**D1 + C2*v2**D2      (2)          

If we: (a) divide both sides of (1) by v2 (assume v2 is positive!);
       (b) subtract v1 from both sides of (1); and     
       (c) add 1.0 to both sides of (1), we obtain         

              1.0 > 1.0 -v1 +50/v2            (3)     

From (3) we easily deduce that in (2): C0 = 1.0; C1 = -1.0; D1 = 1.0;
C2 = 50; and D2 = -1.0.  Eq.(3) represents the second type of
expression given above. The actual value of the constraint, CONSTR,
used later by the optimizer would be 

            CONSTR = 1.0/(1.0 -v1 +50/v2). 

This constraint is critical if its value is less than 1.0. 
                      
**************** INEQUALITY CONSTRAINT NO.            1
Identify the type of inequality expression (1 or 2)=H
                                      
The inequality relations have either of the two forms:
                                 
     Type 1 is:     1.0 < f(v1,v2,v3,...)        
     Type 2 is:     1.0 > f(v1,v2,v3,...)  
                               
in which the expression f(v1,v2,v3,...) has the form: 
                                   
   f(v1,v2,v3,...) = C0 +C1*v1**D1 +C2*v2**D2 +C3*v3**D3 + ... 
                        +etc (up to max. of 5 terms).    
                                 
The variables, v1, v2, v3,..., can be any of the variables that are
decision variables or potential candidates for decision variables or
linked variables. 

Identify the type of inequality expression (1 or 2)=1
                           
Now start building the expression: C0 +C1*v1**D1 +C2*v2**D2 +... 
You are allowed up to 5 terms in the expression, including C0. 

Give a value to the constant, C0=1.

LIST OF VARIABLES FROM WHICH YOU MUST NOW CHOOSE ANY ONE         
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK  
  2    1.000E+01  Length of the plate: LENGTH  
  3    6.667E+00  Width of the plate: WIDTH  
                                            
Choose a variable from the list above (1, 2, 3,...)=2
Choose a value for the coefficient, C1=-1.
Choose a value for the power, D1=1.

 1 <1.00-1.00*VAR(2)**(1.00) + ...

Any more terms in the expression: C0 +C1*v1**D1 +C2*v2**D2 +...=Y

LIST OF VARIABLES FROM WHICH YOU MUST NOW CHOOSE ANY ONE         
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK 
  2    1.000E+01  Length of the plate: LENGTH 
  3    6.667E+00  Width of the plate: WIDTH  
                                           
Choose a variable from the list above (1, 2, 3,...)=3
Choose a value for the coefficient, Cn=H
                                      
You are building the expression: C0 +C1*v1**D1 +C2*v2**D2 +...
You are allowed up to 5 terms in the expression, including C0. 
                                     
Choose a value for the coefficient, Cn=100.
Choose a value for the power, Dn=-1.

  1 < 1.00-1.00*VAR(2)**(1.00) +100.0*VAR(3)**(-1.00)
                                  
Any more terms in the expression: C0 +C1*v1**D1 +C2*v2**D2 +...=N
Are there any more inequality expressions?=Y

**************** INEQUALITY CONSTRAINT NO.            2


   (MANY LINES SKIPPED IN ORDER TO SAVE SPACE.  THESE LINES
    CORRESPOND TO THE INEQUALITY CONSTRAINTS NO. 2 AND NO. 3.)


  1 > 1.00-1.00*VAR(2)**(1.00) +1.00*VAR(3)**(1.00)
                                   
Any more terms in the expression: C0 +C1*v1**D1 +C2*v2**D2 +...=N
Are there any more inequality expressions?=N

3 INEQUALITY CONSTRAINTS WHICH MUST BE SATISFIED:
  1 <1.00-1.00*VAR(2)**(1.00)+100.0*VAR(3)**(-1.00) 
  1 >1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00) 
  1 >1.00-1.00*VAR(2)**(1.00)+1.00*VAR(3)**(1.00) 
*********** END OF INPUT FOR            3  INEQUALITY CONSTRAINTS.


Any escape variables (Y or N) ?=H
                                    
An escape variable is a variable that when increased drives the
design toward the feasible region. For example, in designs which are
buckling-critical, local and general instability represent two
constraint conditions that bound the feasible region. Increasing the
thicknesses of any parts while keeping all other dimensions the same
drives the design toward the feasible region (makes buckling less
critical). Hence, a thickness should always be chosen as an escape
variable. Other variables, such as winding angles, should  not be
used as escape variables, since their increase might well result in a
decrease in the buckling load, hence driving the design toward the
infeasible region. 
                                       
 NOTE: YOU MUST INCLUDE THE WORD ``THICKNESS'', SPELLED CORRECTLY,
       IN THE DEFINITIONS OF VARIABLES THAT ARE THICKNESSES! 
       DOING THIS ALLOWS THE DEFAULT OPTION FOR THE CHOICE OF  
       ESCAPE VARIABLES.                
                                    
Any escape variables (Y or N) ?=Y
Want to have escape variables chosen by default?=H
                                 
Generally answer Y.  This code will then automatically choose as
escape variables all of the thicknesses that are decision variables.
This is usually the best strategy and use of the default option saves
you the trouble of doing it interactively. 
                                    
 NOTE: YOU MUST INCLUDE THE WORD ``THICKNESS'', SPELLED CORRECTLY, 
       IN THE DEFINITIONS OF VARIABLES THAT ARE THICKNESSES! 
       DOING THIS ALLOWS THE DEFAULT OPTION FOR THE CHOICE OF 
       ESCAPE VARIABLES. THE CHOICE OF ESCAPE VARIABLES IS
       MADE BY SEARCHING OVER ALL DECISION VARIABLES AND CHOOSING 
       ONLY THOSE WITH THE WORD ``THICKNESS'' IN THEIR DEFINITIONS. 
                                                   
Want to have escape variables chosen by default?=Y

           ESCAPE VARIABLES FOR THE OPTIMIZATION PROBLEM          
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E-01  thickness of the plate: THICK 

          SUMMARY OF INFORMATION FOR OPTIMIZATION ANALYSIS        
VAR. DEC. ESCAPE LINK. LINKED LINKING   LOWER   CURRENT   UPPER  VARIABLE
 NO. VAR.  VAR.  VAR.   TO   CONSTANT   BOUND    VALUE    BOUND    NAME
  1   Y     Y     N     0    0.00E+00   0.03  1.0000E-01   1.00   THICK
  2   Y     N     N     0    0.00E+00   5.00  1.0000E+01 100.0    LENGTH
  3   Y     N     N     0    0.00E+00   5.00  6.6667E+00  10.0    WIDTH 


DESCRIPTION OF FILES GENERATED BY THIS CASE:

 PLATE1.DEC = Summary of interactive session you have just
          completed. This file can be edited and used for
          future runs of DECIDE.

 PLATE1.CBL = Contains the PLATE1 data base.

 PLATE1.OPD = Output from DECIDE. Please list this file and
          inspect it and the PLATE1.DEC file carefully before
          proceeding.

For further information about files generated during operation
of GENOPT give the command HELPG FILES.

Next, give the command   MAINSETUP   .
=====================================================================
\endverbatim
\ven
\beginverbatim
    TABLE 20   PART OF THE PLATE1.DEC FILE GENERATED BY ``DECIDE''
=====================================================================
    N       $ Do you want a tutorial session and tutorial output?
       1    $ Choose a decision variable (1,2,3,...)
0.0300000   $ Lower bound of variable no.( 1)
       1    $ Upper bound of variable no.( 1)
    Y       $ Any more decision variables (Y or N) ?
       2    $ Choose a decision variable (1,2,3,...)
       5    $ Lower bound of variable no.( 2)
     100    $ Upper bound of variable no.( 2)
    Y       $ Any more decision variables (Y or N) ?
       3    $ Choose a decision variable (1,2,3,...)
       5    $ Lower bound of variable no.( 3)
      10    $ Upper bound of variable no.( 3)
    N       $ Any more decision variables (Y or N) ?
    N       $ Any linked variables (Y or N) ?
    Y       $ Any inequality relations among variables? (type H)
    Y       $ Want to see an example of how to calculate C0,C1,D1,..?
       1    $ Identify the type of inequality expression (1 or 2)
 1.000000   $ Give a value to the constant, C0
       2    $ Choose a variable from the list above (1, 2, 3,...)
-1.000000   $ Choose a value for the coefficient, C1
 1.000000   $ Choose a value for the power, D1
    Y       $ Any more terms in the expression:
                           C0 +C1*v1**D1 +C2*v2**D2 +...?
       3    $ Choose a variable from the list above (1, 2, 3,...)
 100.0000   $ Choose a value for the coefficient, Cn
-1.000000   $ Choose a value for the power, Dn
    N       $ Any more terms in the expression:
                           C0 +C1*v1**D1 +C2*v2**D2 +...?
    Y       $ Are there any more inequality expressions?


     (LINES SKIPPED IN ORDER TO SAVE SPACE)


    N       $ Are there any more inequality expressions?
    Y       $ Any escape variables (Y or N) ?
    Y       $ Want to have escape variables chosen by default?
=====================================================================
\endverbatim
\ven
\beginverbatim
   TABLE 21  THE INTERACTIVE ``MAINSETUP'' SESSION
             CONDUCTED BY THE END USER
=====================================================================
$ MAINSETUP                        (CHOOSE STRATEGY FOR ANALYSIS)

ENTER THE SPECIFIC CASE NAME:  PLATE1

**************************** MAINSETUP *****************************
The purpose of MAINSETUP is to permit you to choose an analysis mode
for the case PLATE1.  The control integer is called ITYPE.  If ITYPE
= 1, then design iterations are to be performed and the objective
function minimized.  If ITYPE = 2 a simple analysis for a given
design is to be performed (no optimization).  Results will be stored
on the file called PLATE1.OPM.  Please inspect this file before doing
more design iterations. 
********************************************************************
Choose type of analysis (1=opt., 2=fixed design)=H
1  means an optimization analysis will be performed.    
   Make sure that you have chosen decision variables, linked
   variables, and escape variables
2  means analysis of a fixed design will be performed.
   (no design iterations)            
Choose type of analysis (1=opt., 2=fixed design)=1
How many design iterations in this run (3 to 25)?=H
Choose a number between 3 and 25, usually 5 to 8. If the design
margins seem to jump around quite a bit, or if the objective cycles
from iteration set to iteration set, use a high number of iterations
(25). 
How many design iterations in this run (3 to 25)?=5

DESCRIPTION OF FILES USED AND GENERATED IN THIS RUN:
 PLATE1.NAM = This file contains only the name of the case.
 PLATE1.CBL = Labelled common blocks for analysis.
            (This is an unformatted sequential file.)
 PLATE1.OPT = This file contains the input data for MAINSETUP
             as well as OPTIMIZE. The batch command OPTIMIZE
             can be given over and over again without having
             to return to MAINSETUP because PLATE1.OPT exists.
 URPROMPT.DAT= Prompt file for interactive input.

For further information about files used and generated during
operation of this program, give the command HELPG FILES. 

Menu of commands: OPTIMIZE
=====================================================================
\endverbatim
\ven
\beginverbatim



     TABLE 22   THE FILE  PLATE1.OPT  GENERATED BY ``MAINSETUP''
=====================================================================
      N         $ Do you want a tutorial session and tutorial output?
         1      $ Choose type of analysis (1=opt., 2=fixed design)
         5      $ How many design iterations in this run (3 to 25)?
=====================================================================
\endverbatim
\ven
\beginverbatim
    TABLE 23   PART OF THE FILE  PLATE1.OPM  GENERATED DURING
               THE BATCH RUN LAUNCHED BY THE END USER'S COMMAND
               ``OPTIMIZE''
====================================================================
$ OPTIMIZE     (Launch batch run for first set of 5 design
                iterations)

ENTER THE SPECIFIC CASE NAME:  PLATE1

(YOU HAVE JUST LAUNCHED A BATCH RUN ON THE FAST QUEUE. WHEN IT IS
COMPLETED, YOU INSPECT THE  PLATE1.OPM  FILE TO SEE WHAT TO DO NEXT.)


      N         $ Do you want a tutorial session and tutorial output?
         1      $ Choose type of analysis (1=opt., 2=fixed design)
         5      $ How many design iterations in this run (3 to 25)?

 *********************** MAIN PROCESSOR **********************
 The purpose of the mainprocessor, OPTIMIZE, is to perform,
 in a batch mode, the work specified by MAINSETUP for the case
 called PLATE1.  Results are stored in the file  PLATE1.OPM.
 Please inspect PLATE1.OPM before doing more design iterations.
 ************************************************************




 STRUCTURAL ANALYSIS FOR DESIGN ITERATION NO.   0:
0
          SUMMARY OF INFORMATION FROM OPTIMIZATION ANALYSIS       
 VAR. DEC. ESCAPE LINK. LINKED  LINKING   LOWER     CURRENT    UPPER       DEFINITION
  NO. VAR.  VAR.  VAR.    TO   CONSTANT   BOUND      VALUE     BOUND
   1   Y     Y     N      0    0.00E+00  3.00E-02 1.0000E-01  1.00E+00  thickness of the plate: THICK                            
   2   Y     N     N      0    0.00E+00  5.00E+00 1.0000E+01  1.00E+02  Length of the plate: LENGTH                              
   3   Y     N     N      0    0.00E+00  5.00E+00 6.6667E+00  1.00E+01  Width of the plate: WIDTH                                

 ***** RESULTS FOR LOAD SET NO.  1  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1   -2.655E-01  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  2  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    4.973E-02  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10                            
  2   -1.978E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  3  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    2.722E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00                            
  2   -2.613E-01  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00                              
  3   -5.091E-01  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00                                         

 ***************************************************
 ******************** DESIGN OBJECTIVE *******************
 *************                             ***********
    CURRENT VALUE OF THE OBJECTIVE FUNCTION:                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    6.667E-01  Weight of the plate: WEIGHT                                                     

 *************                          ************
 ******************** DESIGN OBJECTIVE *******************
 *****************************************************


 **********************************
 **********************************
 **********************************

  ADS DID NOT CHANGE THE DESIGN 

 **********************************
 **********************************
 **********************************



 ***************************************************
 ***************************************************
 ***************************************************
 STRUCTURAL ANALYSIS FOR DESIGN ITERATION  0.
 NEW DESIGN WAS OBTAINED VIA CHANGE IN ESCAPE VARIABLES RATHER
 THAN VIA ADS.

0
  CURRENT VALUES OF THE ESCAPE VARIABLES FOR THE OPTIMIZATION RUN 
 VARIABLE NO.    DEFINITION VALUE        DEFINITION
  1                   1.100E-01  thickness of the plate: THICK                               

 ***************************************************
 ***************************************************
 ***************************************************


0
          SUMMARY OF INFORMATION FROM OPTIMIZATION ANALYSIS       
 VAR. DEC. ESCAPE LINK. LINKED  LINKING   LOWER     CURRENT    UPPER       DEFINITION
  NO. VAR.  VAR.  VAR.    TO   CONSTANT   BOUND      VALUE     BOUND
   1   Y     Y     N      0    0.00E+00  3.00E-02 1.1000E-01  1.00E+00  thickness of the plate: THICK                            
   2   Y     N     N      0    0.00E+00  5.00E+00 1.0000E+01  1.00E+02  Length of the plate: LENGTH                              
   3   Y     N     N      0    0.00E+00  5.00E+00 6.6667E+00  1.00E+01  Width of the plate: WIDTH                                

 ***** RESULTS FOR LOAD SET NO.  1  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1   -2.233E-02  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  2  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.547E-01  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10                            
  2    6.772E-02  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  3  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    5.393E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00                            
  2   -1.478E-01  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00                              
  3   -3.466E-01  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00                                         

 ***************************************************
 ******************** DESIGN OBJECTIVE *******************
 *************                             ***********
    CURRENT VALUE OF THE OBJECTIVE FUNCTION:                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    7.333E-01  Weight of the plate: WEIGHT                                                     

 *************                          ************
 ******************** DESIGN OBJECTIVE *******************
 *****************************************************



 STRUCTURAL ANALYSIS FOR DESIGN ITERATION NO.   2:
0
          SUMMARY OF INFORMATION FROM OPTIMIZATION ANALYSIS       
 VAR. DEC. ESCAPE LINK. LINKED  LINKING   LOWER     CURRENT    UPPER       DEFINITION
  NO. VAR.  VAR.  VAR.    TO   CONSTANT   BOUND      VALUE     BOUND
   1   Y     Y     N      0    0.00E+00  3.00E-02 1.1880E-01  1.00E+00  thickness of the plate: THICK                            
   2   Y     N     N      0    0.00E+00  5.00E+00 9.2000E+00  1.00E+02  Length of the plate: LENGTH                              
   3   Y     N     N      0    0.00E+00  5.00E+00 6.1334E+00  1.00E+01  Width of the plate: WIDTH                                

 ***** RESULTS FOR LOAD SET NO.  1  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    4.551E-01  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  2  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    2.471E-01  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10                            
  2    5.891E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  3  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.301E-01  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00                              
  2    1.490E-01  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00                                         

 ***************************************************
 ******************** DESIGN OBJECTIVE *******************
 *************                             ***********
    CURRENT VALUE OF THE OBJECTIVE FUNCTION:                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    6.704E-01  Weight of the plate: WEIGHT                                                     

 *************                          ************
 ******************** DESIGN OBJECTIVE *******************
 *****************************************************



 STRUCTURAL ANALYSIS FOR DESIGN ITERATION NO.   3:
0
          SUMMARY OF INFORMATION FROM OPTIMIZATION ANALYSIS       
 VAR. DEC. ESCAPE LINK. LINKED  LINKING   LOWER     CURRENT    UPPER       DEFINITION
  NO. VAR.  VAR.  VAR.    TO   CONSTANT   BOUND      VALUE     BOUND
   1   Y     Y     N      0    0.00E+00  3.00E-02 1.1120E-01  1.00E+00  thickness of the plate: THICK                            
   2   Y     N     N      0    0.00E+00  5.00E+00 8.6112E+00  1.00E+02  Length of the plate: LENGTH                              
   3   Y     N     N      0    0.00E+00  5.00E+00 5.7408E+00  1.00E+01  Width of the plate: WIDTH                                

 ***** RESULTS FOR LOAD SET NO.  1  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1   -9.834E-02  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)]                             
  2    3.620E-01  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  2  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.673E-01  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10                            
  2    4.874E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  3  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.681E-01  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00                              
  2    2.276E-01  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00                                         

 ***************************************************
 ******************** DESIGN OBJECTIVE *******************
 *************                             ***********
    CURRENT VALUE OF THE OBJECTIVE FUNCTION:                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    5.497E-01  Weight of the plate: WEIGHT                                                     

 *************                          ************
 ******************** DESIGN OBJECTIVE *******************
 *****************************************************



 STRUCTURAL ANALYSIS FOR DESIGN ITERATION NO.   4:
0
          SUMMARY OF INFORMATION FROM OPTIMIZATION ANALYSIS       
 VAR. DEC. ESCAPE LINK. LINKED  LINKING   LOWER     CURRENT    UPPER       DEFINITION
  NO. VAR.  VAR.  VAR.    TO   CONSTANT   BOUND      VALUE     BOUND
   1   Y     Y     N      0    0.00E+00  3.00E-02 1.0550E-01  1.00E+00  thickness of the plate: THICK                            
   2   Y     N     N      0    0.00E+00  5.00E+00 9.0521E+00  1.00E+02  Length of the plate: LENGTH                              
   3   Y     N     N      0    0.00E+00  5.00E+00 5.5038E+00  1.00E+01  Width of the plate: WIDTH                                

 ***** RESULTS FOR LOAD SET NO.  1  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1   -3.262E-02  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)]                             
  2    2.145E-01  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  2  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.075E-01  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10                            
  2    3.543E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  3  ******
 THOSE MARGINS LESS THAN UNITY CORRESPONDING TO CURRENT DESIGN    
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.247E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00                            
  2    1.137E-01  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00                              
  3    1.226E-01  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00                                         

 ***************************************************
 ******************** DESIGN OBJECTIVE *******************
 *************                             ***********
    CURRENT VALUE OF THE OBJECTIVE FUNCTION:                      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    5.256E-01  Weight of the plate: WEIGHT                                                     

 *************                          ************
 ******************** DESIGN OBJECTIVE *******************
 *****************************************************



 STRUCTURAL ANALYSIS FOR DESIGN ITERATION NO.   5:
0
          SUMMARY OF INFORMATION FROM OPTIMIZATION ANALYSIS       
 VAR. DEC. ESCAPE LINK. LINKED  LINKING   LOWER     CURRENT    UPPER       DEFINITION
  NO. VAR.  VAR.  VAR.    TO   CONSTANT   BOUND      VALUE     BOUND
   1   Y     Y     N      0    0.00E+00  3.00E-02 1.0118E-01  1.00E+00  thickness of the plate: THICK                            
   2   Y     N     N      0    0.00E+00  5.00E+00 9.4229E+00  1.00E+02  Length of the plate: LENGTH                              
   3   Y     N     N      0    0.00E+00  5.00E+00 5.2886E+00  1.00E+01  Width of the plate: WIDTH                                

 ***************************************************
 ******************** DESIGN OBJECTIVE *******************
 *************                             ***********
   CURRENT VALUE OF THE OBJECTIVE FUNCTION:                       
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    5.042E-01  Weight of the plate: WEIGHT                                                     

 *************                          ************
 ******************** DESIGN OBJECTIVE *******************
 *****************************************************

 ***** RESULTS FOR LOAD SET NO.  1  ******
 PARAMETERS WHICH DESCRIBE BEHAVIOR (e.g. stress, buckling load)  
 BEH.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.883E+03    Maximum effective (von Mises) stress: STRESS(1 )                              
  2    1.356E+00    Buckling load factor: BUCKLE(1 )                                              
  3    1.000E+10    Fundamental frequency of unloaded plate: FREQ(1 )                             
  4    1.000E-10    Normal deflection under uniform pressure: W(1 )                               

 ***** RESULTS FOR LOAD SET NO.  1  ******
 MARGINS CORRESPONDING TO CURRENT DESIGN (F.S.= FACTOR OF SAFETY) 
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.486E+00  1.00-1.00*VAR(2)**(1.00)+100.0*VAR(3)**(-1.00) -1.                              
  2   -3.135E-02  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)]                             
  3    4.134E+00  1.- [1.00-1.00*VAR(2)**(1.00)+1.00*VAR(3)**(1.00)]                              
  4    1.760E+00  MAXSTR(1 )/[STRESS(1 ) X FSTRES(1 )] -1; F.S.=  1.10                            
  5    1.300E-01  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  2  ******
 PARAMETERS WHICH DESCRIBE BEHAVIOR (e.g. stress, buckling load)  
 BEH.   CURRENT
 NO.     VALUE            DEFINITION
  1    2.568E+04    Maximum effective (von Mises) stress: STRESS(2 )                              
  2    1.521E+00    Buckling load factor: BUCKLE(2 )                                              
  3    1.000E+10    Fundamental frequency of unloaded plate: FREQ(2 )                             
  4    1.000E-10    Normal deflection under uniform pressure: W(2 )                               

 ***** RESULTS FOR LOAD SET NO.  2  ******
 MARGINS CORRESPONDING TO CURRENT DESIGN (F.S.= FACTOR OF SAFETY) 
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    6.214E-02  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10                            
  2    2.674E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20                            

 ***** RESULTS FOR LOAD SET NO.  3  ******
 PARAMETERS WHICH DESCRIBE BEHAVIOR (e.g. stress, buckling load)  
 BEH.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.658E+04    Maximum effective (von Mises) stress: STRESS(3 )                              
  2    1.000E+10    Buckling load factor: BUCKLE(3 )                                              
  3    1.414E+02    Fundamental frequency of unloaded plate: FREQ(3 )                             
  4    9.266E-02    Normal deflection under uniform pressure: W(3 )                               

 ***** RESULTS FOR LOAD SET NO.  3  ******
 MARGINS CORRESPONDING TO CURRENT DESIGN (F.S.= FACTOR OF SAFETY) 
 MAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    8.099E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00                            
  2    8.763E-02  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00                              
  3    7.918E-02  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00                                         
 ***********  ALL 3 LOAD CASES PROCESSED ***********
 *****************************************************


 PARAMETERS WHICH ARE ALWAYS FIXED.  NONE CAN BE DECISION VARIAB. 
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E+07  Young's modulus of the plate material: E                                        
  2    3.000E-01  Poisson's ratio of the plate material: NU                                       
  3    1.000E-01  Weight density (e.g. lb/in**3) of the plate material: RHO                       
  4    2.000E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(1 )                         
  5    3.000E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(2 )                         
  6    4.000E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(3 )                         
  7    6.000E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(4 )                         
  8    8.000E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(5 )                         
  9    1.000E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(6 )                         
 10    1.200E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(7 )                         
 11    1.400E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(8 )                         
 12    1.600E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(9 )                         
 13    1.800E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(10)                         
 14    2.000E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(11)                         
 15    2.200E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(12)                         
 16    2.400E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(13)                         
 17    2.700E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(14)                         
 18    3.000E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(15)                         
 19    3.000E+01  (plate length, LENGTH)/(plate width, WIDTH): AOBAXL(16)                         
 20    2.220E+01  Coefficient for buckling under uniform axial compression: KAXL(1 )              
 21    1.090E+01  Coefficient for buckling under uniform axial compression: KAXL(2 )              
 22    6.920E+00  Coefficient for buckling under uniform axial compression: KAXL(3 )              
 23    4.230E+00  Coefficient for buckling under uniform axial compression: KAXL(4 )              
 24    3.450E+00  Coefficient for buckling under uniform axial compression: KAXL(5 )              
 25    3.290E+00  Coefficient for buckling under uniform axial compression: KAXL(6 )              
 26    3.400E+00  Coefficient for buckling under uniform axial compression: KAXL(7 )              
 27    3.680E+00  Coefficient for buckling under uniform axial compression: KAXL(8 )              
 28    3.450E+00  Coefficient for buckling under uniform axial compression: KAXL(9 )              
 29    3.320E+00  Coefficient for buckling under uniform axial compression: KAXL(10)              
 30    3.290E+00  Coefficient for buckling under uniform axial compression: KAXL(11)              
 31    3.320E+00  Coefficient for buckling under uniform axial compression: KAXL(12)              
 32    3.400E+00  Coefficient for buckling under uniform axial compression: KAXL(13)              
 33    3.320E+00  Coefficient for buckling under uniform axial compression: KAXL(14)              
 34    3.290E+00  Coefficient for buckling under uniform axial compression: KAXL(15)              
 35    3.290E+00  Coefficient for buckling under uniform axial compression: KAXL(16)              
 36    6.667E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(1 )                         
 37    7.143E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(2 )                         
 38    8.333E-01  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(3 )                         
 39    1.000E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(4 )                         
 40    1.200E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(5 )                         
 41    1.400E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(6 )                         
 42    1.500E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(7 )                         
 43    1.600E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(8 )                         
 44    1.800E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(9 )                         
 45    2.000E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(10)                         
 46    2.500E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(11)                         
 47    3.000E+00  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(12)                         
 48    3.000E+01  (plate length, LENGTH)/(plate width, WIDTH): AOBSHR(13)                         
 49    5.840E+00  Coefficient for buckling under uniform in-plane shear: KSHR(1 )                 
 50    6.000E+00  Coefficient for buckling under uniform in-plane shear: KSHR(2 )                 
 51    6.580E+00  Coefficient for buckling under uniform in-plane shear: KSHR(3 )                 
 52    7.750E+00  Coefficient for buckling under uniform in-plane shear: KSHR(4 )                 
 53    6.580E+00  Coefficient for buckling under uniform in-plane shear: KSHR(5 )                 
 54    6.000E+00  Coefficient for buckling under uniform in-plane shear: KSHR(6 )                 
 55    5.840E+00  Coefficient for buckling under uniform in-plane shear: KSHR(7 )                 
 56    5.760E+00  Coefficient for buckling under uniform in-plane shear: KSHR(8 )                 
 57    5.590E+00  Coefficient for buckling under uniform in-plane shear: KSHR(9 )                 
 58    5.430E+00  Coefficient for buckling under uniform in-plane shear: KSHR(10)                 
 59    5.180E+00  Coefficient for buckling under uniform in-plane shear: KSHR(11)                 
 60    5.020E+00  Coefficient for buckling under uniform in-plane shear: KSHR(12)                 
 61    4.400E+00  Coefficient for buckling under uniform in-plane shear: KSHR(13)                 
 PARAMETERS WHICH ARE ENVIRONMENTAL FACTORS (e.g. loads, temps.)  
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1   -1.000E+03  Axial tension per unit width of the plate (lb/in): Nx(1 )                       
  2    0.000E+00  Axial tension per unit width of the plate (lb/in): Nx(2 )                       
  3    0.000E+00  Axial tension per unit width of the plate (lb/in): Nx(3 )                       
  4    0.000E+00  Transverse tension per unit length of the plate (lb/in): Ny(1 )                 
  5    0.000E+00  Transverse tension per unit length of the plate (lb/in): Ny(2 )                 
  6    0.000E+00  Transverse tension per unit length of the plate (lb/in): Ny(3 )                 
  7    0.000E+00  In-plane shear per unit edge length applied to the plate.: Nxy(1 )              
  8    1.500E+03  In-plane shear per unit edge length applied to the plate.: Nxy(2 )              
  9    0.000E+00  In-plane shear per unit edge length applied to the plate.: Nxy(3 )              
 10    0.000E+00  Uniform normal pressure on the plate: PRESS(1 )                                 
 11    0.000E+00  Uniform normal pressure on the plate: PRESS(2 )                                 
 12    1.200E+01  Uniform normal pressure on the plate: PRESS(3 )                                 
 PARAMETERS WHICH ARE CLASSIFIED AS ALLOWABLES (e.g. max. stress) 
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    3.000E+04  Maximum effective (von Mises) stress allowed: MAXSTR(1 )                        
  2    3.000E+04  Maximum effective (von Mises) stress allowed: MAXSTR(2 )                        
  3    3.000E+04  Maximum effective (von Mises) stress allowed: MAXSTR(3 )                        
  4    1.000E+00  Minimum allowable buckling load factor (use 1.0): MINBUC(1 )                    
  5    1.000E+00  Minimum allowable buckling load factor (use 1.0): MINBUC(2 )                    
  6    1.000E+00  Minimum allowable buckling load factor (use 1.0): MINBUC(3 )                    
  7    0.000E+00  Minimum allowable value for the fundamental frequency: MINCPS(1 )               
  8    0.000E+00  Minimum allowable value for the fundamental frequency: MINCPS(2 )               
  9    1.300E+02  Minimum allowable value for the fundamental frequency: MINCPS(3 )               
 10    0.000E+00  Maximum allowable normal deflection under pressure: AW(1 )                      
 11    0.000E+00  Maximum allowable normal deflection under pressure: AW(2 )                      
 12    1.000E-01  Maximum allowable normal deflection under pressure: AW(3 )                      
 PARAMETERS WHICH ARE FACTORS OF SAFETY                           
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.100E+00  Factor of safety for effective stress: FSTRES(1 )                               
  2    1.100E+00  Factor of safety for effective stress: FSTRES(2 )                               
  3    1.000E+00  Factor of safety for effective stress: FSTRES(3 )                               
  4    1.200E+00  Factor of safety for buckling load factor: FBUCKL(1 )                           
  5    1.200E+00  Factor of safety for buckling load factor: FBUCKL(2 )                           
  6    1.000E+00  Factor of safety for buckling load factor: FBUCKL(3 )                           
  7    1.000E+00  Factor of safety for FREQ: FSFREQ(1 )                                           
  8    1.000E+00  Factor of safety for FREQ: FSFREQ(2 )                                           
  9    1.000E+00  Factor of safety for FREQ: FSFREQ(3 )                                           
 10    0.000E+00  Factor of safety for max deflection under pressure: FW(1 )                      
 11    0.000E+00  Factor of safety for max deflection under pressure: FW(2 )                      
 12    1.000E+00  Factor of safety for max deflection under pressure: FW(3 )                      

    3 INEQUALITY CONSTRAINTS WHICH MUST BE SATISFIED

  1 <1.00-1.00*VAR(2)**(1.00)+100.0*VAR(3)**(-1.00)                              
  1 >1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)                               
  1 >1.00-1.00*VAR(2)**(1.00)+1.00*VAR(3)**(1.00)                                


 DESCRIPTION OF FILES USED AND GENERATED IN THIS RUN:

 PLATE1.NAM = This file contains only the name of the case.
 PLATE1.OPM = Output data. Please list this file and inspect
            carefully before proceeding.
 PLATE1.CBL = Labelled common blocks for analysis.
            (This is an unformatted sequential file.)
 PLATE1.OPT = This file contains the input data for MAINSETUP
             as well as OPTIMIZE. The batch command OPTIMIZE
             can be given over and over again without having
             to return to MAINSETUP because PLATE1.OPT exists.
 URPROMPT.DAT= Prompt file for interactive input.

 For further information about files used and generated
 during operation of GENOPT, give the command HELPG FILES.

 Menu of commands: CHOOSEPLOT, OPTIMIZE, MAINSETUP, CHANGE,
                   DECIDE 

==================================================================
\endverbatim
\ven
\beginverbatim
   TABLE 24  PART OF THE INTERACTIVE ``CHOOSEPLOT'' SESSION
             CONDUCTED BY THE END USER
==================================================================
$ CHOOSEPLOT       (Start interactive session to choose which
                    variables to plot v. design iterations.)

ENTER THE SPECIFIC CASE NAME:  PLATE1

************************* CHOOSEPLOT  ****************************
The purpose of CHOOSEPLOT is to permit you to choose:

1. Which design parameters (Role 1 variables) are to be plotted v.
design iterations; 

2. Which design margins are to be plotted v. design iterations. 

The results of the interactive session are saved in a file called
PLATE1.CPL, in which PLATE1 is your name for the case. You may find
this file useful for future runs of CHOOSEPLOT in which you want to
avoid answering many questions interactively. CHOOSEPLOT also
generates the four files: PLATE1.OPL, PLATE1.PL3, PLATE1.PL4, and
PLATE1.PL5 , which are described briefly at the end of this run. If
you choose the tutorial option, PLATE1.OPL contains a complete list
of the interactive session, including prompting questions, all ``help''
paragraphs, your responses to the prompting questions, and evolving
lists of which parameters are to be plotted as they are chosen by
you.  In addition to the parameters chosen here for plotting,
CHOOSEPLOT automatically sets up a file of the objective for
plotting.
*******************************************************************

Any design variables to be plotted v. iterations (Y or N)?=H
                                                   
Usually you answer Y. However, you may have plotted all the design
parameters you want, and still have more design margins to plot.  The
plots will show the design variables you next choose versus design
iterations from the beginning of the case through the iteration most
recently completed. 
                                               
Any design variables to be plotted v. iterations (Y or N)?=Y

LIST FROM WHICH A VARIABLE TO BE PLOTTED MUST NOW BE CHOSEN:
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.526E-02  thickness of the plate: THICK          
  2    1.000E+01  Length of the plate: LENGTH            
  3    5.000E+00  Width of the plate: WIDTH              
Choose a variable to be plotted v. iterations (1,2,3,..)=1
Any more design variables to be plotted (Y or N) ?=Y

       DESIGN VARIABLES CHOSEN SOFAR FOR PLOTTING v. ITERATIONS   
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.526E-02  thickness of the plate: THICK          

     LIST FROM WHICH A VARIABLE TO BE PLOTTED MUST NOW BE CHOSEN  
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  2    1.000E+01  Length of the plate: LENGTH            
  3    5.000E+00  Width of the plate: WIDTH              
Choose a variable to be plotted v. iterations (1,2,3,..)=2
Any more design variables to be plotted (Y or N) ?=Y

       DESIGN VARIABLES CHOSEN SOFAR FOR PLOTTING v. ITERATIONS   
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.526E-02  thickness of the plate: THICK          
  2    1.000E+01  Length of the plate: LENGTH            

     LIST FROM WHICH A VARIABLE TO BE PLOTTED MUST NOW BE CHOSEN  
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  3    5.000E+00  Width of the plate: WIDTH              
Choose a variable to be plotted v. iterations (1,2,3,..)=3
Any more design variables to be plotted (Y or N) ?=N

     DESIGN PARAMETERS TO BE PLOTTED v. DESIGN ITERATIONS         
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    9.526E-02  thickness of the plate: THICK          
  2    1.000E+01  Length of the plate: LENGTH            
  3    5.000E+00  Width of the plate: WIDTH              

Any design margins to be plotted v. iterations (Y or N)?=H
                                                       
Usually you answer Y. However, you may have plotted all the design
margins you want, and still have more design variables to plot.  The
plots will show the design margins you next choose versus design
iterations from the beginning of the case through the iteration most
recently completed. 
                                                       
Any design margins to be plotted v. iterations (Y or N)?=Y

     LIST FROM WHICH A MARGIN TO BE PLOTTED MUST NOW BE CHOSEN    
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E+01  1.00-1.00*VAR(2)**(1.00)+100.0*VAR(3)**(-1.00) -1.  
  2   -6.390E-05  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)] 
  3    5.000E+00  1.- [1.00-1.00*VAR(2)**(1.00)+1.00*VAR(3)**(1.00)]  
  4    1.598E+00  MAXSTR(1 )/[STRESS(1 ) X FSTRES(1 )] -1; F.S.=  1.10
  5    4.185E-02  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20
  8   -1.788E-07  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10
  9    1.463E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20
 12    6.755E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00
 14    5.667E-02  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00  
 15    3.454E-02  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00             

Choose a margin to be plotted v. iterations (1,2,3,..)=2
Any more margins to be plotted (Y or N) ?=Y

     DESIGN MARGINS CHOSEN SO FAR FOR PLOTTING v. ITERATIONS      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  2   -6.390E-05  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)] 

     LIST FROM WHICH A MARGIN TO BE PLOTTED MUST NOW BE CHOSEN    
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E+01  1.00-1.00*VAR(2)**(1.00)+100.0*VAR(3)**(-1.00) -1.  
  3    5.000E+00  1.- [1.00-1.00*VAR(2)**(1.00)+1.00*VAR(3)**(1.00)]  
  4    1.598E+00  MAXSTR(1 )/[STRESS(1 ) X FSTRES(1 )] -1; F.S.=  1.10
  5    4.185E-02  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20
  8   -1.788E-07  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10
  9    1.463E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20
 12    6.755E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00
 14    5.667E-02  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00  
 15    3.454E-02  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00             

Choose a margin to be plotted v. iterations (1,2,3,..)=4
Any more margins to be plotted (Y or N) ?=Y

     DESIGN MARGINS CHOSEN SO FAR FOR PLOTTING v. ITERATIONS      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  2   -6.390E-05  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)] 
  4    1.598E+00  MAXSTR(1 )/[STRESS(1 ) X FSTRES(1 )] -1; F.S.=  1.10

     LIST FROM WHICH A MARGIN TO BE PLOTTED MUST NOW BE CHOSEN    
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  1    1.000E+01  1.00-1.00*VAR(2)**(1.00)+100.0*VAR(3)**(-1.00) -1.  
  3    5.000E+00  1.- [1.00-1.00*VAR(2)**(1.00)+1.00*VAR(3)**(1.00)]  
  5    4.185E-02  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20
  8   -1.788E-07  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10
  9    1.463E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20
 12    6.755E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00
 14    5.667E-02  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00  
 15    3.454E-02  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00             

Choose a margin to be plotted v. iterations (1,2,3,..)=5
Any more margins to be plotted (Y or N) ?=Y

     DESIGN MARGINS CHOSEN SO FAR FOR PLOTTING v. ITERATIONS      
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  2   -6.390E-05  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)] 
  4    1.598E+00  MAXSTR(1 )/[STRESS(1 ) X FSTRES(1 )] -1; F.S.=  1.10
  5    4.185E-02  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20



   (MORE INTERACTIVE INPUT/OUTPUT NOT LISTED HERE TO SAVE SPACE.)



Choose a margin to be plotted v. iterations (1,2,3,..)=15
Any more margins to be plotted (Y or N) ?=N

     DESIGN MARGINS TO BE PLOTTED v. DESIGN ITERATIONS            
 VAR.   CURRENT
 NO.     VALUE            DEFINITION
  2   -6.390E-05  1.- [1.00-1.00*VAR(2)**(1.00)+50.0*VAR(3)**(-1.00)] 
  4    1.598E+00  MAXSTR(1 )/[STRESS(1 ) X FSTRES(1 )] -1; F.S.=  1.10
  5    4.185E-02  BUCKLE(1 )/[MINBUC(1 ) X FBUCKL(1 )] -1; F.S.=  1.20
  8   -1.788E-07  MAXSTR(2 )/[STRESS(2 ) X FSTRES(2 )] -1; F.S.=  1.10
  9    1.463E-01  BUCKLE(2 )/[MINBUC(2 ) X FBUCKL(2 )] -1; F.S.=  1.20
 12    6.755E-01  MAXSTR(3 )/[STRESS(3 ) X FSTRES(3 )] -1; F.S.=  1.00
 14    5.667E-02  FREQ(3 )/[MINCPS(3 ) X FSFREQ(3 )] -1; F.S.=  1.00  
 15    3.454E-02  AW(3 )/[W(3 ) X FW(3 )] -1; F.S.=  1.00


         (LINES SKIPPED IN ORDER TO SAVE SPACE)


 DESCRIPTION OF FILES GENERATED BY THIS CASE:

 PLATE1.CPL = Summary of interactive session you have just
          completed. This file can be edited and used for
          future runs of CHOOSEPLOT.
 PLATE1.CBL = Contains the PLATE1 data base.
 PLATE1.OPL = Output from CHOOSEPLOT. Please list this file and
          inspect it and the PLATE1.CPL file carefully before
          proceeding.
 PLATE1.PL3 = File for margin plots via DIPLOT
 PLATE1.PL4 = File for design parameter plots via DIPLOT
 PLATE1.PL5 = File for objective plot via DIPLOT

 For further information about files generated during operation
 of GENOPT give the command HELPG FILES.

 NEXT, GIVE THE COMMAND:  DIPLOT   .
=================================================================
\endverbatim
\ven
\beginverbatim
 TABLE 25    SOFTWARE MODIFIED AND/OR ``BORROWED'' FROM ELSEWHERE
             FOR THIS COMPLEX EXAMPLE (GENOPT user = D. Bushnell)
 ===================================================================
  SUBROUTINE     ORIGINAL LOCATION     WAS IT     PRESENT LOCATION
    CALLED      OF THE  SUBROUTINE    MODIFIED    OF THE SUBROUTINE
 -------------------------------------------------------------------
    TRANFR     struct.new               YES     struct.new

    GETCIJ  ~/panda2/sources/getcij.src  NO  ~/panda2/sources/getcij.src
            ~/panda2/sources/smrcij.src  NO  ~/panda2/sources/smrcij.src

    FORCES  ~/panda2/sources/forces.src  NO  ~/panda2/sources/forces.src

    STFEIG  ~/panda2/sources/buckle.src YES  ~/genopt/sources/addcode1.src

    BUCPAN ~/panda2/sources/bucpan1.src YES  ~/genopt/sources/addcode1.src
           ~/panda2/sources/bucpan2.src  NO  ~/panda2/sources/bucpan2.src
           ~/panda2/sources/pancom.src  YES  ~/genopt/sources/addcode1.src
           ~/panda2/sources/arrays.src   NO  ~/panda2/sources/arrays.src

    STRCON ~/panda2/sources/strain.src  YES  ~/genopt/sources/addcode1.src
====================================================================
\endverbatim
\ven
\beginverbatim
  TABLE 26  PORTION OF SUBROUTINE STRUCT MODIFIED BY THE GENOPT USER
=====================================================================
C  BEGINNING OF LOOP OVER LOAD SETS (environments)
C
      DO 1000 ILOADX = 1,NCASES
C
      CALL CONVR2(ILOADX,CIX)
      IF (NPRINX.GT.0) THEN
         WRITE(IFILE8,'(1X,A)')'  '
         WRITE(IFILE8,'(1X,A,I2)')
     1 ' BEHAVIOR FOR LOAD SET NUMBER, ILOADX=',ILOADX
      ENDIF
C
C  End of the second portion of STRUCT written by "GENTEXT"
C=======================================================================
C
C  USER: YOU MAY WANT TO INSERT SUBROUTINE CALLS FROM SOFTWARE DEVELOPED
C        ELSEWHERE FOR ANY CALCULATIONS PERTAINING TO THIS LOAD SET.
C        (IF YOU WANT, YOU MAY ALSO INSERT CALLS OUTSIDE THE
C        "D0 1000 ILOADX = 1,NCASES"  LOOP, AS DESCRIBED ABOVE.
C
C
C
C  INSERT SUBROUTINE CALL FOR TRANSLATION OF INPUT DATA FROM
C  THE NOMENCLATURE USED IN GENOPT TO THAT USED IN THE "BORROWED" CODE:
C
      CALL TRANFR(IMODX,ILOADX,NPRINX,EAVEP,EAVEPL,P,RESPRS,EPSPRS,
     1            WPRES,WPRESG,CRACK,FKNOCK)
C
C  INSERT SUBROUTINE CALL FOR WALL STIFFNESS COEFFICIENTS, C(i,j):
C
      CALL GETCIJ(INTEXT,0,IFILE8,ISTIF,B,B2,H,W,W2,
     1           CX,CY,CS,ZPARTX,ZPARTY,THERMX,THERMY,THERMS,
     1           GTX,GTY,GTS,TEFF,CSINV,ETHRMX,ETHRMY,
     1           ICOCUR,ETHERM,CRACK,IFILE4,0,IOUT,
     1           0,NSEG,FSTRN,GSTRN,CSN,CSWIDE,CSREDU,TBASE,IMODX)
C
C  INSERT SUBROUTINE CALL FOR GETTING RESULTANTS IN EACH SEGMENT OF
C  THE STRINGER MODULE AND RING MODULE:
C
      CALL FORCES(IFILE8,0,0,NSEG,CX,CY,CS,FNX,FNY,FNXY,RESULT,
     1        RESFIX,RESEIG,ISTIF,WRESID,WBEND,
     1        ZPARTX,ZPARTY,100000.,EPSLOD,ETHERM,THERMX,THERMY,
     1        LENMOD,CSINV,ETHRMX,ETHRMY,ICOCUR,0,
     1        EPSTOT,EPSFIX,EPSEIG,FSTRN,GSTRN,STIF1L,STIF2L,
     1        FNX0,FNY0,FNXY0,EPSFXL,RESFXL,RESTOT,FNXP0,FNYP0,
     1        0.,EAVEP,RESPGL,EPSPGL,RESPRS,EPSPRS,0.,FNXPL0,FNYPL0,
     1        EAVEPL,0.,EPSLDF,0.,0.,IMODX,0,1.0,0,
     1        0,AMPLIT,ECC,RWBTOT,RWBEIG,2,0,0,1.)
C
C  INSERT SUBROUTINE CALL FOR CALCULATING BIFURCATION BUCKLING OF
C  STIFFENER PARTS...
C
      CALL STFEIG(1,ISTIF,B,B2,H,W,W2,CX,CY,RESEIG,RESTOT,
     1         0,TX,TY,GTX,GTY,1,0,0,MCRIP,NCRIP,IFILE8,0,
     1         RWBTOT,RWBEIG,ILOADX,FLABUC,WFLBUC)
C
C
C  INSERT SUBROUTINE CALL FOR CALCULATING THE VARIOUS BUCKLING LOAD
C  FACTORS FROM PANDA-TYPE THEORY:
C
      CALL BUCPAN(IFILE8,IMODX,ISTIF,RWBEIG,RWBTOT,
     1            ILOADX,MBUCK(1,ILOADX),NBUCK(1,ILOADX),
     1            TBUCK(1,ILOADX),CBUCK(1,ILOADX),EBUCK(1,ILOADX))
C     
C
C  INSERT SUBROUTINE CALL FOR CALCULATING VARIOUS MAXIMUM
C  STRESS COMPONENTS IN THE VARIOUS MATERIAL TYPES:
C
      CALL STRCON(ISTIF,NSEG,NLAYER,LTYPE,EALLOW,MATL,ANGLE,
     1                  B2,W2,TT,TAPE,DEGRAD,
     1                  1.,ETHERM,THERMX,THERMY,0,
     1                  EPSLOD,ZPARTX,ZPARTY,ETHRMX,ETHRMY,CRACK,0,
     1                  EALLST,NPRINT,NAPPL,IFILE8,ITYPEX,0,
     1                  EPSTOT,EPSFIX,EPSEIG,1,INTEXT,1,
     1                  SIG1T,SIG1C,SIG2T,SIG2C,SIG12,ILOADX)
C
C  End of the portion of SUBROUTINE STRUCT written by the GENOPT user.
C====================================================================
C  Start of the final portion of STRUCT written by ``GENTEXT''
C
=====================================================================
NOTE: SUBROUTINE BUCPAN takes by far more computer time than do the
other subroutines called above. This is because rather lengthy
formulas for buckling load factors are calculated over and over again
during an elaborate search over the number of axial halfwaves m,
circumferential halfwaves n, and slope of the buckling nodal lines c.
(See [9]). This elaborate search is needed only for the unperturbed
design. Since the perturbed design is close to the unperturbed
design, the (m, n, c) obtained for the unperturbed design are used
for the perturbed design also. This saves a great deal of computer
time in the ``NDV'' loop shown on the left-hand side of Fig. 1. The
parameter IMODX, which appears in the argument list of SUBROUTINE
BUCPAN is the index which directs the computations in this regard. 
\endverbatim
\ven
\beginverbatim
         TABLE 27  PURPOSES OF ``BORROWED'' SUBROUTINES
=====================================================================
 SUBROUTINE OR             PURPOSE OF SUBROUTINE OR LIBRARY
 LIBRARY NAME
---------------------------------------------------------------------
  TRANFR        Translate data names from ``GENTEXT'' names to
                the names used in subroutines and labelled common
                blocks in PANDA2.

  GETCIJ        Calculate the 6x6 matrix of constitutive coefficients
                C(i,j) for each of the four panel module segments
                (See Fig. 6); Calculate the C(i,j) for the panel with
                ``smeared'' stringers only, with ``smeared'' rings only,
                with ``smeared'' stringers and rings. Theory is given
                in [6].

  FORCES        Determine how much of the overall load on the panel
                is distributed to the panel skin and to each segment
                of the stringers and to each segment of the rings,
                assuming certain continuity conditions set forth in
                [6].

  STFEIG        Calculate buckling load factors for local buckling
                of stiffener parts (web, flange, web and flange).

  BUCPAN        Calculate buckling load factors for the various types
                of buckling listed above, except for local buckling
                of stiffener parts, which is done in STFEIG.

  STRCON        Calculate the five maximum stress components listed
                above for each type of material used in the structure.
======================================================================
\endverbatim
\ven
\beginverbatim
  TABLE 28  PORTION OF BEHAVIOR.NEW WRITTEN BY THE GENOPT USER
======================================================================
C=DECK      OBJECT
      SUBROUTINE OBJECT(OBJGEN,PHRASE)
C   PURPOSE:Weight of the panel
C
C   YOU MUST WRITE CODE THAT, USING
C   THE VARIABLES IN THE LABELLED
C   COMMON BLOCKS AS INPUT, ULTIMATELY
C   YIELDS THE OBJECTIVE FUNCTION
C         WEIGHT
C   AS OUTPUT. MAKE SURE TO INCLUDE AT
C   THE END OF THE SUBROUTINE, THE
C   STATEMENT: OBJGEN = WEIGHT
C
C   DEFINITION OF PHRASE:
C     PHRASE = Weight of the panel
C
       CHARACTER*80 PHRASE
C  INSERT ADDITIONAL COMMON BLOCKS:
      COMMON/FV13/W2R,WEIGHT
C
C
C  INSERT SUBROUTINE STATEMENTS HERE.
C
C  THIS ROUTINE WAS WRITTEN BY THE GENOPT USER, NOT BY ``GENTEXT''.
C
C  PURPOSE IS TO CALCULATE THE OBJECTIVE FUNCTION, WHICH IS THE
C  WEIGHT.
C
      DIMENSION CMASS(5,2),WIDTH(5,2)
      COMMON/GEOM6/IFAY(2),IMISCL(28)
      COMMON/GEOM1/AXIAL,CIRC,R
      COMMON/GEOM2/B(2),B2(2),H(2),W(2),W2(2)
      COMMON/GEOM3/ISTIF(2),NLAYER(4,2),NSEG(2),INTEXT(2)
      COMMON/LAYER/MATLL(90),LTYPE(99,5,2),T(90),ANGLE(90)
      COMMON/MATER1/EE1(20),EE2(20),GG(20),FNU(20),DENS(20)
      COMMON/MATRAN/GG13(20),GG23(20)
      COMMON/MATRN2/GTX(2,5),GTY(2,5),GTS(2),TEFF(2)
C
C  WEIGHT OF PANEL (CODING FROM PANDA2)
C
        IFILE = 8
        OBJ = 0.
        CALL MOVER(0.,0,CMASS,1,10)
        CALL MOVER(0.,0,WIDTH,1,10)
C
        DO 100 ILOOP = 1,2
C
        ISTART = 1
        IEND   = NSEG(ILOOP)
        IF (ILOOP.EQ.2) ISTART = 2
        IF (ISTART.GT.IEND) GO TO 100
C
        DO 60 I = ISTART,IEND
C
        NLAY = NLAYER(I,ILOOP)
C
        DO 30 J = 1,NLAY
C
        K = LTYPE(J,I,ILOOP)
        M = MATLL(K)
C
        CMASS(I,ILOOP) = CMASS(I,ILOOP) + T(K)*DENS(M)
C
   30   CONTINUE
C
        IF (I.EQ.1) WIDTH(I,ILOOP) = B(ILOOP) - B2(ILOOP)
        IF (I.EQ.2) WIDTH(I,ILOOP) = B2(ILOOP)
        IF (ISTIF(ILOOP).NE.4) THEN
           IF (I.EQ.3) WIDTH(I,ILOOP) = H(ILOOP)
           IF (I.EQ.4) WIDTH(I,ILOOP) = W(ILOOP)
        ELSE
           IF (IFAY(ILOOP).EQ.1) THEN
              IF (I.EQ.1) WIDTH(I,ILOOP) = 
     1                     B(ILOOP) - B2(ILOOP) + W2(ILOOP)
              IF (I.EQ.2) WIDTH(I,ILOOP) = B2(ILOOP) - W2(ILOOP)
           ENDIF
           IF (I.EQ.3) WIDTH(I,ILOOP) = 2.*SQRT(H(ILOOP)*H(ILOOP) 
     1                             +(W2(ILOOP) -W(ILOOP) )**2/4.  )
           IF (I.EQ.4) WIDTH(I,ILOOP) = W(ILOOP)
        ENDIF
C
   60   CONTINUE
  100   CONTINUE
C
        OBJ1 = 0.
        NSEG1 = NSEG(1)
        DO 110 I = 1,NSEG1
        OBJ1 = OBJ1 + WIDTH(I,1)*CMASS(I,1)*AXIAL
  110   CONTINUE
        OBJ1 = OBJ1*CIRC/B(1)
C
        OBJ2 = CIRC*(WIDTH(3,2)*CMASS(3,2) +WIDTH(4,2)*CMASS(4,2)
     1        +WIDTH(2,2)*(CMASS(2,2) - CMASS(1,1)))
        OBJ2 = OBJ2*AXIAL/B(2)
C
        OBJ = OBJ1 + OBJ2
        WEIGHT = OBJ
C 
      IF (OBJ.EQ.0.) THEN
         WRITE(IFILE,200)
  200    FORMAT(//' ****** OBJECTIVE FUNCTION IS ZERO *********'/)
  210    WRITE(IFILE,215)
  215    FORMAT(' CHECK TO MAKE SURE THAT DENSITY OF PANEL MATERIAL'/
     1          ' IS NOT ZERO.')
         WRITE(IFILE,240)
  240    FORMAT('  ****** TERMINATING CALCS. IN SUB. OBJECT.*****')
         CALL ERREX
      ENDIF
C
      OBJGEN =WEIGHT 
C
      RETURN
      END
======================================================================
\endverbatim
\ven
\beginverbatim
  TABLE 29   GLOSSARY OF VARIABLES USED IN THE GENERIC CASE  ``PANEL''
=======================================================================
ARRAY NUMBER OF        PROMPT  VAR.
 ?   (ROWS,COLS) ROLE  NUMBER  NAME      DEFINITION OF THE VARIABLE
                     (PANEL.PRO)
-----------------------------------------------------------------------
 n   (   0,  0)   2      10   LENGTH = Panel length normal to the plane
                                         of the screen, L1
 n   (   0,  0)   2      15   WIDTH  = Panel length in the plane
                                         of the screen, L2
 n   (   0,  0)   2      20   RADIUS = Radius of curvature of the middle
                                         surface of the panel skin
 n   (   0,  0)   2      30   STRTYP = Identify type of stiffener along
                                         L1 (stringer) (0,1,2,3,4)
 n   (   0,  0)   2      35   STINEX = Choose external (0) or
                                         internal (1) stringers
 n   (   0,  0)   1      40   BS     = Stringer spacing
 n   (   0,  0)   1      45   B2S    = Width of base under stringer
 n   (   0,  0)   1      50   HS     = Height of the stringer
 n   (   0,  0)   1      55   WS     = Width of the outstanding flange
                                         of the stringer
 n   (   0,  0)   1      60   W2S    = Width of the hat at its base
                                         (use 0 if stringer not a hat)
 n   (   0,  0)   2      70   INLAYS = Index for segment number of skin-
                                         stringer module in NLAYS(INLAYS)
 y   (   5,  0)   2      75   NLAYS  = Number of layers in this segment
                                         of skin-stringer module
 n   (   0,  0)   2      80   JSTRWA = Index for segment number
                                         of skin-stringer module
                                         in STRWAL(ISTRWA,JSTRWA)
 n   (   0,  0)   2      85   ISTRWA = Index for layer number
                                         of skin-stringer segment
                                         in STRWAL(ISTRWA,JSTRWA)
 y   (  99,  5)   2      90   STRWAL = Pointer for a layer of a segment
                                         of skin-stringer module
 n   (   0,  0)   2      95   RNGTYP = Identify type of stiffener along L2
                                         (ring) (0,1,2,3,4)
 n   (   0,  0)   2     100   RGINEX = Choose external (0) or internal (1)
                                         rings (type 0 or 1)
 n   (   0,  0)   1     105   BR     = Ring spacing
 n   (   0,  0)   1     110   B2R    = Width of base under ring
 n   (   0,  0)   1     115   HR     = Height of the ring
 n   (   0,  0)   1     120   WR     = Width of the outstanding flange
                                         of the ring
 n   (   0,  0)   1     125   W2R    = Width of the hat at its base
                                         (use 0 if ring not a hat)
 n   (   0,  0)   2     130   INLAYR = Index for segment number of
                                         skin-ring module in NLAYR(INLAYR)
 y   (   5,  0)   2     135   NLAYR  = Number of layers in each segment
                                         of skin-ring module
 n   (   0,  0)   2     145   JRNGWA = Index for segment number
                                         of skin-ring module
                                         in RNGWAL(IRNGWA,JRNGWA)
 n   (   0,  0)   2     150   IRNGWA = Index for layer number
                                         of skin-ring segment
                                         in RNGWAL(IRNGWA,JRNGWA)
 y   (  99,  5)   2     155   RNGWAL = Pointer for a layer of a segment
                                         of the skin-ring module
 n   (   0,  0)   2     165   IT     = Index for type of layer
                                         (T, ANG, MATL) in T(IT)
 y   (  50,  0)   1     170   T      = Thickness for layer index
 y   (  50,  0)   2     175   ANG    = Layup angle (deg.) for layer index
 y   (  50,  0)   2     180   MATL   = Material property pointer for layer
                                         index
 n   (   0,  0)   2     190   IISOMA = Index for type of material
                                         (MATL pointer) in ISOMAT(IISOMA)
 y   (  20,  0)   2     195   ISOMAT = Control for mat'l type:
                                         0 (zero)=orthotropic; 1=isotropic
 y   (  20,  0)   2     200   E1     = Modulus along the fibers
 y   (  20,  0)   2     205   E2     = Modulus perpendicular to the fibers
 y   (  20,  0)   2     210   G12    = In-plane shear modulus
 y   (  20,  0)   2     215   NU     = Poisson's ratio
                                         (use the ``large'' value)
 y   (  20,  0)   2     220   G13    = Shear modulus for x-z 
                                         (axial-normal) shearing
 y   (  20,  0)   2     225   G23    = Shear modulus for y-z
                                         (circ.-normal) shearing
 y   (  20,  0)   2     230   A1     = Coef. thermal expansion along fibers
 y   (  20,  0)   2     235   A2     = Coef. thermal expansion
                                         perpendicular to fibers
 y   (  20,  0)   2     240   TEMP   = Setting (``cure'') temperature
                                         of material
 y   (  20,  0)   2     245   RHO    = Weight density (e.g. lb/in**3)
                                         for this material
 n   (   0,  0)   2     255   NCASES = Number of load cases (number
                                         of environments)  in Nx(NCASES)
 y   (  20,  0)   3     260   Nx     = Axial resultant (e.g. lb/in),
                                         negative for compression
 y   (  20,  0)   3     265   Ny     = Circumferential resultant
                                         (neg. for compression)
 y   (  20,  0)   3     270   Nxy    = In-plane shear resultant
 y   (  20,  0)   4     280   GENBUC = General instability load factor
 y   (  20,  0)   5     285   AGENBK = Allowable for general instability
                                         load factor (use 1.0)
 y   (  20,  0)   6     290   FSGEN  = Factor of safety for general
                                         instability load factor
 y   (  20,  0)   4     295   WIDCOL = Wide column buckling between rings
                                         load factor
 y   (  20,  0)   5     300   AWIDCL = Allowable for wide column buckling
                                         load factor (use 1.0)
 y   (  20,  0)   6     305   FSWID  = Factor of safety for wide column
                                         buckling load factor
 y   (  20,  0)   4     310   PANBUC = Panel buckling load factor
 y   (  20,  0)   5     315   APANBK = Allowable for panel buckling load
                                         factor (use 1.0)
 y   (  20,  0)   6     320   FSPAN  = Factor of safety for panel buckling
                                         load factor
 y   (  20,  0)   4     325   LOCBUC = Local buckling load factor
                                         (panel skin)
 y   (  20,  0)   5     330   ALOCBK = Allowable for panel skin buckling
                                         load factor (use 1.0)
 y   (  20,  0)   6     335   FSLOC  = Factor of safety for panel skin
                                         buckling load factor
 y   (  20,  0)   4     340   ROLSKN = Local buckling load factor with
                                         stiffener rolling
 y   (  20,  0)   5     345   AROLSK = Allowable local buck. with stiffener
                                         rolling (use 1.0)
 y   (  20,  0)   6     350   FROLSK = Factor of safety for skin buckling
                                         with stiffener rolling
 n   (   0,  0)   2     355   JWEBBU = Index for stringer or ring
                                         (1= stringer, 2=ring)
                                         in WEBBUC(NCASES,JWEBBU)
 y   (  20,  2)   4     360   WEBBUC = Web buckling load factor
 y   (  20,  2)   5     365   AWEBBK = Allowable for web buckling
                                         load factor (use 1.0)
 y   (  20,  2)   6     370   FSWEB  = Factor of safety for web buckling
                                         load factor
 y   (  20,  2)   4     375   WFLBUC = Web-flange buckling load factor
 y   (  20,  2)   5     380   AWFLBK = Allowable web-flange buckling
                                         load factor (use 1.0)
 y   (  20,  2)   6     385   FSWFL  = Factor of safety for web-flange
                                         buckling load factor
 y   (  20,  2)   4     390   FLABUC = Flange buckling load factor
 y   (  20,  2)   5     395   AFLABK = Allowable for flange buckling
                                         load factor (use 1.0)
 y   (  20,  2)   6     400   FSFLBK = Factor of safety for flange
                                         buckling load factor
 y   (  20,  2)   4     405   HATBAS = Hat base buckling load factor
 y   (  20,  2)   5     410   AHATBS = Allowable for hat base buckling
                                         load factor (use 1.0)
 y   (  20,  2)   6     415   FSHATB = Factor of safety for hat base
                                         buckling load factor
 y   (  20,  2)   4     420   HATCRN = Hat crown buckling load factor
 y   (  20,  2)   5     425   AHATBC = Allowable for hat crown buckling
                                         load factor (use 1.0)
 y   (  20,  2)   6     430   FSHATC = Factor of safety for hat crown
                                         buckling load factor
 y   (  20,  2)   4     435   ROLSTF = Rolling of stiffeners
                                         without skin participation
 y   (  20,  2)   5     440   AROLST = Allowable for rolling of stiffener
                                         without skin (use 1.0)
 y   (  20,  2)   6     445   FSROL1 = Factor of safety for rolling
                                         of stiffener, no skin motion
 y   (  20,  2)   4     450   ROLSMR = Rolling of stiffeners with
                                         other set smeared
 y   (  20,  2)   5     455   AROLSM = Allowable for rolling of stiffeners,
                                         other set smeared (use 1.0)
 y   (  20,  2)   6     460   FSROL2 = Factor of safety for rolling
                                         with other set smeared
 y   (  20,  0)   4     465   AXIROL = Axisymmetric rolling of rings
                                         on cylinder
 y   (  20,  0)   5     470   AAXIRL = Allowable for axisymmetic rolling
                                         of rings (use 1.0)
 y   (  20,  0)   6     475   FSROL3 = Factor of safety for
                                         axisymmetric rolling of rings
 n   (   0,  0)   2     485   JSIG1T = Index for type of material
                                         in SIG1T(NCASES,JSIG1T)
 y   (  20,  5)   4     490   SIG1T  = Max. tension along fibers
                                         for matl type
 y   (  20,  5)   5     495   ASIG1T = Allowable stress for tension along
                                         fibers
 y   (  20,  5)   6     500   FSS1T  = Factor of safety for tension along
                                         fibers
 y   (  20,  5)   4     505   SIG1C  = Max. compression along fiber
 y   (  20,  5)   5     510   ASIG1C = Allowable compression along fiber
 y   (  20,  5)   6     515   FSS1C  = Factor of safety for compression
                                         along fibers
 y   (  20,  5)   4     520   SIG2T  = Max. tensile stress normal to fibers
 y   (  20,  5)   5     525   ASIG2T = Allowable tensile stress
                                         normal to fibers
 y   (  20,  5)   6     530   FSS2T  = Factor of safety for tensile stress
                                         normal to fibers
 y   (  20,  5)   4     535   SIG2C  = Max. compressive stress
                                         normal to fibers
 y   (  20,  5)   5     540   ASIG2C = Allowable compressive stress
                                         normal to fibers
 y   (  20,  5)   6     545   FSS2C  = Factor of safety for compressive
                                         stress normal to fibers
 y   (  20,  5)   4     550   SIG12  = Max. in-plane shear stress
 y   (  20,  5)   5     555   ASIG12 = Allowable in-plane shear stress
 y   (  20,  5)   6     560   FSS12  = Factor of safety
                                         for in-plane shear stress
 n   (   0,  0)   7     570   WEIGHT = Weight of the panel
=========================================================================
NOTES:
(1) STRTYP...See the ``help'' material (30.2) for prompt no. 30
               in TABLE 30.
(2) INLAYS...See Fig. 6(b) for segment numbering convention.
(3) NLAYS....The GENOPT user decided on a maximum of 5 segments/module
(4) ISTRWA...See Fig. 6(c) for layer numbering convention.
(5) STRWAL...The GENOPT user decided on a maximum of 99 layers in any
               segment.  See the introductory paragraph 65.0 in Table 30.
(6) IT.......See 160.0 - 180.2 of the prompting file listed in TABLE 30.
(7) T........The GENOPT user decided on a maximum of 50 layer types.
(8) ISOMAT...The GENOPT user decided on a maximum of 20 material typees.
(9) Nx,Ny,Nxy..Three resultants for each load set. GENTEXT sets max. 
               number of load sets to 20.
(10) GENBUC...Number of rows = 20, corresponding to 20 load sets.
(11) WEBBUC...First column of array for stringers, second for rings.
(12) SIG1T....Max. of 5 columns corresponding to 5 different materials.
\endverbatim
\ven
\beginverbatim
  TABLE 30  PORTION OF THE PANEL.PRO FILE
            CREATED DURING THE INTERACTIVE ``GENTEXT'' SESSION
=====================================================================
   5.0 
       THE MINIMUM WEIGHT DESIGN OF STRINGER AND RING STIFFENED FLAT OR
       CYLINDRICAL PANELS.  THE CODING FOR STRESS AND BUCKLING CONSTRIANTS
       IS TAKEN FROM PANDA2 (Computers and Structures, Vol. 25, pp 469-605,
       1987).
       First, provide overall panel dimensions and radius of curvature.
 
  10.1 Panel length normal to the plane of the screen, L1: LENGTH
  10.2 
       The axial direction is the direction normal to the plane of the
       screen. The axial coordinate is called x.
 
  15.1 Panel length in the plane of the screen, L2: WIDTH
  15.2 
       The circumferential (y) direction lies in the plane of the screen
       or parallel to the plane of the screen, and in the plane of the
       panel skin.
 
  20.1 Radius of curvature of the middle surface of the panel skin: RADIUS
  20.2 
       Use a positive number. If the panel is flat, use a number that is
       large compared to the width of the panel (span in y direction).
 
 
  25.0 
       NEXT, PROVIDE FOR INPUT FOR STRINGER CROSS SECTION GEOMETRY:
 
  30.1 Identify type of stiffener along L1 (stringer) (0,1,2,3,4): STRTYP
  30.2 
       Stringer cross section types:
       0 = none
       1 = T-shaped cross section (flange is away from skin)
       2 = J-shaped cross section (flange is away from skin)
       3 = Blade cross section
       4 = Hat cross section
       All of these stringer cross sections have a faying flange,
       that is, a flange that lies against the panel skin.
 
  35.1 Choose external (0) or internal (1) stringers (type 0 or 1): STINEX
  40.1 Stringer spacing: BS
  45.1 Width of base under stringer: B2S
  45.2 
       See Fig. 16, p. 515 of long PANDA2 paper for identification
       of BS, B2S, HS, WS, W2S (called b, b2, h, w, w2 in that figure.)
 
  50.1 Height of the stringer: HS
  50.2 
       See Fig. 4 of the long PANDA2 paper for how HS is measured.
       (Note that HS is called h in that figure.)
 
  55.1 Width of the outstanding flange of the stringer: WS
  60.1 Width of the hat at its base (use 0 if stringer not a hat): W2S
  60.2 
       See Fig. 13, p. 495, of long PANDA2 paper.
 
 
  65.0 
       Next, provide input for details of the cross section of
       the panel that is normal to the stringers.  The panel cross
       section, called a ``module'' in the long PANDA2 paper (See Fig. 1
       of that paper), consists of a small number of segments, each
       of which can have a laminated composite wall (see Fig. 10).
       Each layer of each segment is assigned a pointer called
       STRWAL(ILAYER,ISEG).  Each pointer ``points'' to a bundle
       of properties:
       1. Thickness
       2. Layup angle (see Fig. 11 of long PANDA2 paper)
       3. A pointer for material properties.
       All layers with the same value of pointer, STRWAL, have
       the same thickness, layup angle, and material properties.
       This ``sameness'' holds throughout the optimization
       process.
 
  70.1 Number INLAYS of rows in the array  NLAYS: INLAYS
  75.1 Number of layers in this segment of skin-stringer module: NLAYS
  75.2 
       Segment numbering (See Fig. 1 of PANDA2 paper) is as follows:
       Segment 1  =  panel skin
       Segment 2  =  base under the stringer (width = B2S)
       Segment 3  =  stringer web (height = HS)
       Segment 4  =  outstanding flange of stringer (width = WS)
       The layers are numbered as in PANDA2 (See Fig. 10, p.493 of
       the PANDA2 paper cited above.)
 
  80.1 Number JSTRWA of columns in the array, STRWAL: JSTRWA
  85.1 Number ISTRWA of rows in this column of STRWAL: ISTRWA
  90.1 Pointer for a layer of a segment of skin-stringer module: STRWAL
  90.2 
       For example, STRWAL(15,3), is an integer that points to the
       properties of the 15th layer of segment 3 of a single panel
       module. A single panel module is of width equal to the stringer
       spacing, BS, and contains the panel skin and one stringer.
       Segment numbering (See Fig. 1 of PANDA2 paper) is as follows:
       Segment 1  =  panel skin
       Segment 2  =  base under the stringer (width = B2S)
       Segment 3  =  stringer web (height = HS)
       Segment 4  =  outstanding flange of stringer (width = WS)
       The layers are numbered as in PANDA2 (See Fig. 10, p.493 of
       the PANDA2 paper cited above.)
 
  95.1 Identify type of stiffener along L2 (ring) (0,1,2,3,4): RNGTYP
  95.2 
       Ring cross section types:
       0 = none
       1 = T-shaped cross section (flange is away from skin)
       2 = J-shaped cross section (flange is away from skin)
       3 = Blade cross section
       4 = Hat cross section
       All of these ring cross sections have a faying flange, that is,
       a flange that lies against the panel skin.
 
 100.1 Choose external (0) or internal (1) rings (type 0 or 1): RGINEX
 105.1 Ring spacing: BR
 110.1 Width of base under ring: B2R
 110.2 
       See Fig. 16, p. 515 of long PANDA2 paper for identification
       of BR, B2R, HR, WR, W2R (called b, b2, h, w, w2 in that figure.)
 
 115.1 Height of the ring: HR
 115.2 
       See Fig. 4 of the long PANDA2 paper for how HR is measured.
       (Note that HR is called h in that figure.)
 
 120.1 Width of the outstanding flange of the ring: WR
 125.1 Width of the hat at its base (use 0 if ring not a hat): W2R
 125.2 
       See Fig. 13, p. 495, of long PANDA2 paper.
 
 130.1 Number INLAYR of rows in the array  NLAYR: INLAYR
 135.1 Number of layers in each segment of skin-ring module: NLAYR
 
 140.0 
       Next, provide input for details of the cross section of
       the panel that is normal to the rings.  The panel cross
       section, called a ``module'' in the long PANDA2 paper (See Fig. 1
       of that paper), consists of a small number of segments, each
       of which can have a laminated composite wall (see Fig. 10).
       Each layer of each segment is assigned a pointer called
       RNGWAL(ILAYER,ISEG).  Each pointer ``points'' to a bundle
       of properties:
       1. Thickness
       2. Layup angle (see Fig. 11 of long PANDA2 paper)
       3. A pointer for material properties.
       All layers with the same value of pointer, RNGWAL, have
       the same thickness, layup angle, and material properties.
       This ``sameness'' holds throughout the optimization
       process.
 
 145.1 Number JRNGWA of columns in the array, RNGWAL: JRNGWA
 150.1 Number IRNGWA of rows in this column of RNGWAL: IRNGWA
 155.1 Pointer for a layer of a segment of the skin-ring module: RNGWAL
 155.2 
       For example, RNGWAL(15,3), is an integer that points to the
       properties of the 15th layer of segment 3 of a single panel
       module. A single panel module is of width equal to the ring
       spacing, BR, and contains the panel skin and one ring.
       Segment numbering (See Fig. 1 of PANDA2 paper) is as follows:
       Segment 1  =  panel skin
       Segment 2  =  base under the ring (width = B2R)
       Segment 3  =  ring web (height = HR)
       Segment 4  =  outstanding flange of ring (width = WR)
       The layers are numbered as in PANDA2 (See Fig. 10, p.493 of
       the PANDA2 paper cited above.)
 
 
 160.0 
       NEXT, PROVIDE THICKNESSES, T;  LAYUP ANGLES, ANG;  AND MATERIAL
       POINTERS, MATL;  CORRESPONDING TO ALL THE DIFFERENT TYPES OF
       LAYERS CALLED FOR BY THE NOW ESTABLISHED POINTERS, STRWAL AND
       RNGWAL.
 
 165.1 Number IT     of rows in the array  T: IT    
 170.1 Thickness for layer index: T
 175.1 Layup angle (deg.) for layer index: ANG
 180.1 Material property pointer for layer index: MATL
 180.2 
       The material property pointer ``points'' to a bundle of material
       properties that includes:
       1. E1 = modulus of orthotropic layer in the fiber direction
       2. E2 = modulus normal to the fiber direction
       3. G12= shear modulus in the plane of the layer
       4. NU = Poisson's ratio (the large one)
       5. G13= Shear modulus in the xz plane (axial-normal)
       6. G23= Shear modulus in the yz plane (circ.-normal)
       7. A1=Coefficient of thermal expansion along fibers
       8. A2=Coefficient of thermal expansion normal to fibers
       9. TEMP =thermo-setting temperature.
       10. RHO  =weight density of material.
 
 
 185.0 
       NEXT, PROVIDE MATERIAL PROPERTIES, E1, E2, G12, NU, G13, G23,
       A1, A2, TEMP, RHO,  CORRESPONDING TO EACH MATERIAL POINTER, MATL.
 
 190.1 Number IISOMA of rows in the array  ISOMAT: IISOMA
 195.1 Control for mat'l type: 0 (zero)=orthotropic; 1=isotropic: ISOMAT
 200.1 Modulus along the fibers: E1
 

        (MANY LINES OMITTED TO SAVE SPACE)

=======================================================================
\endverbatim
\ven
\beginverbatim
     TABLE 31  END USER PORTION OF THE PANEL/ARIANE EXAMPLE
===================================================================
  $ BEGIN       (You or your appointed user start a specific case.
                 You call this case  ARIANE.  The BEGIN processor
                 allows you to provide a starting design, material
                 properties, loading, allowables, and factors of
                 safety for multiple (in this case 2) load sets.)

  $ DECIDE      (You choose decision variables, their lower and
                 upper bounds; linked variables and their linking
                 constants; and escape variables.)

  $ MAINSETUP   (You choose what type of analysis to perform, and
                 how many design iterations.)

  $ OPTIMIZE    (You launch a batch run for the first 5 iterations.)
  $ OPTIMIZE    (You launch a batch run for the second 5 iterations.)
  $ OPTIMIZE    (You launch a batch run for the third 5 iterations.)
  $ OPTIMIZE    (You launch a batch run for the fourth 5 iterations.)

  $ CHANGE      (You interactively set some of the layer thicknesses
                 equal to zero. They were getting very small.)

  $ OPTIMIZE    (You launch a batch run for the fifth 5 iterations.)
  $ OPTIMIZE    (You launch a batch run for the sixth 5 iterations.)
  $ OPTIMIZE    (You launch a batch run for the seventh 5 iterations.)
  $ OPTIMIZE    (You launch a batch run for the eighth 5 iterations.)
 
  $ MAINSETUP   (You change number of design iterations from 5 to 10)

  $ OPTIMIZE    (You launch a batch run for the ninth set of
                 iterations.)

  $ CHOOSEPLOT  (You choose several variables to be plotted v.
                 iterations.)
  $ DIPLOT      (You get plots from the laser printer.)
  $ CHOOSEPLOT  (You choose several more variables to be plotted v.
                 iterations.)
  $ DIPLOT      (You get new plots from the laser printer.)
======================================================================
\endverbatim
\ven
\beginverbatim


                              -------------
                             |             |
               ------------->|    MAIN     |<--------------
              |              |             |               |
              |               -------------                |
  ------> DO 20 i = 1,NLOADS                               |
 |            |                                            |
 |            V                                            |
 |     ---------------                                     V
 |    |  STRUCT: DO   |                         -----------------------
 |    |  AN ANALYSIS  |                        |                       |
 |    |  OF THE UN-   |                        |  OBTAIN A NEW DESIGN  |
 |    |  PERTURBED    |                        |  VIA  ADS [2,3]    |
 |    |  DESIGN, D(X) |                        |                       |
 |     ---------------                          -----------------------
 |            |
 |  ----> DO 10 i = 1,NDV
 |  |         |
 |  |    ------------------------
 |  |   | STRUCT: DO AN ANALYSIS |
 |  |   | OF THE PERTURBED       |
 |  |   | DESIGN, D[X+dX(i)]     |
 |  |    ------------------------
 |  |         |
 |  |    ------------------------
 |  |   | GRADG: GET GRADIENTS   |
 |  |   | OF BEHAVIORAL CON-     |
 |  |   | STRAINTS, dG(k)/dX(i)  |
 |  |    ------------------------
 |  |         |
 |   --- 10 CONTINUE
 |            |
 |            |
  ------ 20 CONTINUE

  FIG. 1   Architecture of the GENOPT mainprocessor ``MAIN''.
\endverbatim
\ven
\beginverbatim



 X(2)
 |
 |
 |                 VUB(2)
 |                /
 |  VLB(1)   -------------  VUB(1)
 |        \ |             |/
 |          |             |
 |  initial design  -------------
 |          |     \ |           |
 |          |      0|      -----------
 |          |       |      |         |
 |          |       |     1|     ---------
 |          |       |      |     |       |
 |          |       |      |    2|    -------
 |           -------|      |     |   3|     |
 |            /     -------|     |    |  4-----
 |      VLB(2)             ------|    |   | 5 |
 |                               -------------o <---final design
 |                                                  for this set
 |                                                  of iterations.
 -----------------------------------------------------------------X(1)

Fig. 2  Schematic of the evolution of a design with one set of design
iterations and two decision variables, X(1) and X(2).  With each
iteration the optimizer, ADS, establishes a ``window'' of permitted
excursion of the decision variables. In GENOPT this ``window'' shrinks
by a factor of 0.8 with each design iteration.  Upon re-execution of
OPTIMIZE the ``window'' is re-expanded to its original size, which
depends upon lower and upper bounds supplied by the end user in DECIDE
and upon certain strategies used by ADS. 
\endverbatim
\bye

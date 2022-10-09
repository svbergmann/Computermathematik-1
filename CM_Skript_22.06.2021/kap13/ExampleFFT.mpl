# ExampleFFT.mpl -- External calling example using Maple's FFT procedure.
#
# Copyright (c) 2001 Waterloo Maple, Inc.
#
# THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF WMI
# The copyright notice above does not evidence any
# actual or intended publication of such source code.

# This tutorial example illustrates how you can combine Maple's code generation
# facilities with the new(ish) external calling mechanism to increase the speed
# of some kinds of computations. The procedure described here produces a Fast
# Fourier Transform (FFT) routine that operates at compiled speed, because it
# is compiled. You can modify the example to produce something very similar for
# any Maple procedure designed to be run under the hardware floating point
# evaluator `evalhf'. For the sake of this example, the `FFT' procedure that is
# part of the standard Maple library, and its inverse `iFFT' have been chosen.
#
# This file is designed to be both read as a document explaining itself, and to
# be run through Maple as executable Maple code. To execute this file, you may
# either use the `read' statement within a running Maple session, or run the
# file in batch mode using the command line interface. To read the file in a
# running Maple session, issue the command
#
# > read "ExampleFFT.mpl";
#
# If you prefer to run the file in batch mode, you can issue a command of the
# form
#
# % maple -F ExampleFFT.mpl
#
# from your shell or command prompt.  The `-F' option tells Maple not to exit
# when it reaches the end of the file.  This way you can continue to experiment
# with the externally defined routines.

# The code below performs the following steps:
#
# 1. Use codegen[ C ] to generate single and double precision versions,
#    `sFFT' and `dFFT' of the Maple library procedure `FFT'.
# 2. Compile the generated C code from step 1.
# 3. Make the external code available in Maple by calling `define_external'.
# 4. Use the external code.

# Step 2 is highly platform and site dependent. How to compile a C source file
# depends entirely upon your C compiler installation. The example below is set
# up for using the widely deployed GNU C compiler. Much of the variation in
# compiler setup is contained in a number of global variables defined below.
# Those most likely to require customisation are marked with `[EDIT]'. You
# should change the values assigned to these variables to suit the conventions
# at your site.
#
# Note that several files will be created by running the file in Maple. These
# files are created in the current working directory. The files are:
#
#   sfft.c dfft.c -- C sources for the external routine
#   sfft.o dfft.o -- compiled object files produced from sfft.c and dfft.c
#   libfft.so -- dynamic shared object that is linked into Maple
#   Timing.txt -- a file reporting comparative running times for the example

# STEP 1: Generate the C code

# To generate the C code we need to know the type signature of the `FFT'
# procedure.  It is (for double precision)

# FFT( m::nonnegint, x::array( 1 .. m, float[ 8 ] ), y::array( 1 .. m, float[ 8 ] ) )::float[ 8 ]

# This leads to declarations that we shall use in a call to the C code
# translator.

decls := '[
	m::nonnegint,
	x::'array'( 1 .. 2^m ),
	y::'array'( 1 .. 2^m ),
NULL]':

# The C code translator needs to know the correct dimensions of the array
# arguments so that it can generate the proper array access code. Here, we
# generate both single and double precision versions of the `FFT' routine,
# called `sFFT' and `dFFT', respectively. To get the names of the C functions
# to come out right, we make temporary copies of `FFT' in Maple procedures by
# the names `sFFT' and `dFFT'.

sFFT := eval( FFT, 2 ):
dFFT := eval( FFT, 2 ):

# Now we can generate C code from these. The translated routines will be placed
# on the disk files `sfft.c' and `dfft.c' in the current working directory. If
# you execute the code below, be sure to do it in a directory to which you have
# write permissions, or alter the file names used. Because C code generation
# *appends* to the output file, we remove any copy that may already be in the
# current directory.

traperror( fremove( "sfft.c" ) ):
traperror( fremove( "dfft.c" ) ):

# Now generate the C code.

codegen[ 'C' ]( sFFT, 'declarations' = decls, 'precision' = 'single', 'filename' = "sfft.c" ):
codegen[ 'C' ]( dFFT, 'declarations' = decls, 'precision' = 'double', 'filename' = "dfft.c" ):

# STEP 2: Compile the C code into a dynamic shared object
#
# Now that we have the C source code for the single (sFFT) and double (dFFT)
# precision versions of the Maple `FFT' procedure, this C code must be compiled
# and the resulting position independent object code used to form a dynamic
# shared object. This example assumes that your compiler can be invoked via an
# option-driven command line interface. Most compilers provide an interface of
# this sort that allows them to be called from within other programs, like
# Maple. If your compiler does not provide such an interface, then you may have
# to compile the generated code outside of Maple, using instructions provided
# by your compiler vendor.

# [EDIT] Edit the following string to specify the name of your C compiler.

CC := "gcc": # other typical values are "cc", "c89", "xlc", "acc", "lcc", "cl"

# [EDIT] You many need to change the include path shown here if your Maple
# installation is not located under `/usr/local/maple/'.

#CPPFLAGS := "-I. -I/u/maple/research/extern/include":
#CPPFLAGS := "-I. -I/usr/local/maple/extern/include":
CPPFLAGS := sprintf( "-I. -I%s/extern/include", getenv( "MAPLE" ) ):

# Because most systems do not provide special purpose single precision
# libraries, we must redefine calls to them in the C source using the
# C preprocessor.

CPPFLAGS := cat( CPPFLAGS, " ", "-Dsinf=sin -Dcosf=cos -Dpowf=pow" ):

# [EDIT] The following should be edited to specify compiler optimisations that
# you wish to perform. Those shown here are appropriate for the GNU C compiler
# compiling for a SPARC target. Consulte your compiler documentation for the
# best combination of optimisations for your platform.

#CCOPT := "-O": # should work with most compilers
CCOPT := "-O3 -finline-functions -funroll-loops \
	-fomit-frame-pointer -fschedule-insns2 -ffast-math -mcpu=v8": # gcc on SPARC
#CCOPT := "-O3 -finline-functions -funroll-loops \
#	-fomit-frame-pointer -ffast-math -mcpu=pentium": # gcc on Solaris x86

# [EDIT] If you want to debug the generated C code, you can change this to
# something like "-g" to have debugging information compiled into the object
# code.

CCDEBUG := "": # or "-g"

# [EDIT] This variable holds the compiler option to specify that position
# independent code be produced. Some compilers always produce position
# independent code, so this can be set to the empty string "" for such
# compilers. Consult your compiler documentation for the correct option to use
# here.

CCSHFLAGS := "-fPIC":

# The `CFLAGS' variable contains the concatenation of the various configurable
# fragments above that related directly to compilation.

CFLAGS := StringTools:-Join( [ CPPFLAGS, CCDEBUG, CCOPT ], " " ):

# To make the example easier to modify, we put the names of the source files
# into a list over which operations below will iterate. If you modify this
# example to work with other routines that `FFT', you will likely want to
# change this definition.

SOURCES := [ "sfft", "dfft" ]: # [EDIT]

# This procedure will compile a single source file, given its base name
# (without the `.c' extension). The result will be placed on the file BASE.o if
# the compiled C file is BASE.c.

macro( UI_TRACE = 2 ):

Compile := proc( src )
	description "compile a single C source module";
	local	cmd;
	global	CC, CCSHFLAGS, CFLAGS;
	if type( src, '{ set, list }' ) then
		map( procname, src )
	else
		cmd := sprintf( "%s -c %s %s %s.c", CC, CCSHFLAGS, CFLAGS, src );
		userinfo( UI_TRACE, 'Compile', cmd );
		system( cmd );
	end if
end proc:

# First, the files must be compiled into position independent code. To effect
# the compilation we simply map the `Compile' procedure above onto the source
# files list.

infolevel[ 'Compile' ] := UI_TRACE:
Compile( SOURCES );

# Now that we have our compiled position independent code modules, they can be
# linked together to form a dynamic shared object. Again, how this is done is
# highly platform and site dependent. Here, we use the Sun link editor `ld' to
# perform the operation, but we parameterise the example by using a few global
# variables that you can modify to suit your own compiler tool chain.

# [EDIT]
LD := "ld":
LDSHFLAGS := "-G":
LDFLAGS := "":
LDLIBS := "-lm":
OUTPUT := "-o ": # note space

# The name of the dynamic shared object is important on most systems. It needs
# to conform to the conventions of the host on which it will be used. For this
# purpose, the `ExternalCalling' package provides a routine
# `ExternalLibraryName' that forms a correctly named dynamic shared object file
# name. We store this in the global variable `DSO'. If you are modifying this
# example for a different set of codes, you will likely want to change "fft" in
# the line that follows.

DSO := ExternalCalling:-ExternalLibraryName( "fft", 'HWFloat' );

# As for compilation we provide a simple procedure to abstract the details of
# the linking phase.

Link := proc( dsoname::string )
	description "build a dynamic shared object from position independent object files";
	local	ofiles, cmd;
	global	LD, LDSHFLAGS, LDFLAGS, LDLIBS, OUTPUT;
	if nargs < 2 then
		error "no object files specified"
	elif nargs > 1 and type( args[ 2 ], '{ list, set }' ) then
		procname( dsoname, op( args[ 2 ] ) )
	else
		ofiles := StringTools:-Join( map( rcurry( cat, ".o" ), SOURCES ), " " );
		cmd := sprintf( "%s %s %s%s %s %s",
			LD, LDSHFLAGS, LDFLAGS, OUTPUT, DSO,
			ofiles, LDLIBS );
		userinfo( UI_TRACE, 'Link', cmd );
		system( cmd );
	end if
end proc:

# The procedure `Link' expects the base names of the source files as arguments
# after the name of the dynamic shared object itself. Alternatively, a list or
# set of these names may be passed as shown here.

infolevel[ 'Link' ] := UI_TRACE:
Link( DSO, SOURCES );

# If no error occurs, the result of this command should be the dynamic shared
# object which contains the compiled C versions of Maple's `FFT' routine.

# STEP 3: Link the DSO into Maple.
#
# The next step is to link the compiled C functions stored in the dynamic
# shared object into the Maple process. The effect of this is to make these
# functions available within Maple's address space, as though they were
# functions compiled into Maple's kernel.  This is done by using the builtin
# Maple procedure `define_external'. It is passed the name of the C function to
# link, its location in the file system (the name of the dynamic shared
# object), and the type signature of the external function so that the
# appropriate ``glue'' can be generated that makes Maple understand C data
# types, and vice versa.

dFFT := define_external( 'dFFT', # the name of the C function to call
	n::integer[4], x::REF(ARRAY( float[ 8 ] )), y::REF(ARRAY( float[ 8 ] )), # its type signature
	RETURN::float[ 8 ],	# the return type
	'LIB' = "./libfft.so"	# the name of the dynamic shared object
);

# On the left hand side of this assignment, the name `dFFT' refers to the Maple
# procedure being defined via the assignment. (This overwrites the earlier
# assignment, which value is no longer needed.) The symbol `dFFT' occurring as
# the first argument to the call to `define_external' on the right hand side of
# the assignment refers to the name of the external C function being used.
# Thus, the symbol `dFFT' is used to refer to two different things in this
# expression. It is not necessary to use the same name for the compiled C
# function and the externally defined Maple procedure that it implements; this
# is done here merely because it is convenient.
#
# Similarly, we define the single precision version of the routine.

sFFT := define_external( 'sFFT', # the name of the C function to call
	n::integer[4], x::REF(ARRAY( float[ 4 ] )), y::REF(ARRAY( float[ 4 ] )), # its type signature
	RETURN::float[ 4 ],	# the return type
	'LIB' = "./libfft.so"	# the name of the dynamic shared object
);

# Note that the only difference between these is the width of some of the float
# arrays and values being passed.
#
# At this point we now have the externally defined Maple procedures `dFFT' and
# `sFFT' the compute the Fast Fourier Transform at double and single precision,
# respectively.

# STEP 4: Run the code.
#
# The final step is to run the dynamically linked compiled C code against your
# data. Since our object here is to illustrate the technique, we shall simply
# run a small verification test to ensure that everything is working as
# expected, and then perform some timing comparisons to gain a sense of the
# speed improvements that we have achieved.

# The following example is taken from the Maple help page ?FFT.
x := Array([7.,5.,6.,9.], 'datatype' = float[ 8 ], 'order' = 'Fortran_order' );
y := Array([0,0,0,0], 'datatype' = float[ 8 ], 'order' = 'Fortran_order' );
dFFT( 2, x, y );
#evalhf( FFT( 2, x, y ) ); # check against this
x;
y;


#for m from 5 to 10 do
for m from 5 to 20 do
	x := LinearAlgebra:-RandomVector(2^m, outputoptions=[datatype=float[8]] ):
	y := LinearAlgebra:-RandomVector(2^m, outputoptions=[datatype=float[8]] ):

	xx := copy( x ):
	yy := copy( y ):

	t1 := time( evalhf( FFT( m, xx, yy ) ) ):
	t2 := time( dFFT( m, x, y ) ):

	print( `m = `, m );
	print( `evalhf@FFT `, t1 );
	print( `dFFT `, t2 );

	fprintf( "Timing.txt", "%d\t\t%g\t\t\t%g\n", m, t1, t2 ):
	fflush( "Timing.txt" ):
end do:

# EXERCISE: Modify the example above to produce, in addition to the FFT
# external routines, externally defined versions of the inverse FFT, `iFFT'.
# That is, the external dynamic shared object `libfft.so' should contain four
# routines: single and double precision versions of `FFT' and new single and
# double precision versions of `iFFT'.

# End of File: ExampleFFT.mpl
# vim:showmatch:autoindent:smartindent:magic:ruler:ts=8:syntax=maple

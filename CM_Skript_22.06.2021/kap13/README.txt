This is the file `README' for the directory `${MAPLE}/samples/ExternalCall/fft/'.

This directory contains an example file `ExampleFFT.mpl' that illustrates how
to generate external C code from an evalhf-Maple procedure, and then link that
external code into Maple to run as a compiled routine.

This example requires that you have a C language compiler and perhaps other
associated tools such as a link editor.

The example file is Maple language source code with extensive comments to
explain what is being done at each step. You are encouraged to modify the
example to suit your own computations.

The example may be executed directly in Maple by either of two methods.  First,
you can simply read the file into a running Maple session by using the `read'
statement. For example, issue the command

> read "ExampleFFT.mpl";

from within any Maple session. Second, you can run the example in batch mode by
invoking the command line interface at your shell prompt, as follows:

% maple -F ExampleFFT.mpl

(The "%" is the UNIX shell prompt; you do not need to type it. Your prompt may
not appear identical to the one shown above. ) The `-F' option prevents Maple
from exiting when it reaches the end of the file. This allows you to continue
experimenting with the externally defined routines defined in the file.

Because the details of compiling C language source code vary widely and depend
upon your platform, compiler and even how it is installed, it is unlikely that
the defaults coded in the example file will work as is. It is likely that you
will have to modify the compiler, linker and options passed to them to suit
your own compiler installation. In particular, you must have a C compiler to
run this example.

Note that running this file in Maple produces several new files in the current
working directory. These are

	sfft.c dfft.c -- generated C source code
	sfft.o dfft.o -- compiled object code from sfft.c dfft.c
	libfft.so -- a dynamic shared object that is linked into Maple
	Timing.txt -- a file reporting comparative timings for the example

It is possible that some compilers may produce files in addition to those
listed above.

Copyright (c) 2001 Waterloo Maple, Inc.

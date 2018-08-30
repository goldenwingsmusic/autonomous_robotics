#
# Makefile for serial communication MATLAB <-> Robot on Un*x systems
#
# Installation:
#     - untar the files into a directory of its own (recommended)
#
#     - type 'make' to compile.  It should compile on any system that
#       claims to be POSIX compliant.  Tested on Solaris.
#
#     - add a path to the just compiled function in MATLAB.  If you
#       add a command to ~/matlab/startup.m the path gets added everytime
#       you start MATLAB automatically
#
#     - Have fun!
#
# 'kheperacmd' is a little tool for the commandline.  It sends a command to
# to the robot and prints the response.  Useful for quicktesting if the
# kheperarobot is connected correctly.  The serial port device is hardcoded;
# to change it edit 'kheperacmd.c' and recompile.
#
# (C) 1999 Matthias Grimrath <m.grimrath@tu-bs.de>

LIBS	= -ltermcap
CC	= cc

# Specify here the extension 'mex' gives to the matlab function.  If you really
# have time it could be figured out automatically.  You can read the extensions
# in the (online) Matlab manuals or just call 'mex' from within the commandline
# and see what extensions it adds.
EXT     = glx

HDRS	= 

OTHERS	= Makefile

DEPS    = $(HDRS) $(OTHERS)

CFLAGS	= -O

%.mex$(EXT) : %.c
	mex $(CFLAGS) $<

all:		kheperacmd kopen.mex$(EXT) kclose.mex$(EXT) ksend.mex$(EXT)

kheperacmd:	kheperacmd.o
		$(CC) $(LFLAGS) -o $@ $^ $(LIBS)

kheperacmd.o:	kheperacmd.c $(DEPS)

kopen.mex$(EXT): kopen.c $(DEPS)

kclose.mex$(EXT): kclose.c $(DEPS)

ksend.mex$(EXT): ksend.c $(DEPS)

clean:		
	rm -f *.o *.mex??? *~ kheperacmd

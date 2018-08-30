/**
 * Closes the serial communication to the robot on Unix machines
 *
 *		kclose(ref)
 *
 *              ref: Reference obtained from kopen
 *
 * (C) Matthias Grimrath <m.grimrath@tu-bs.de>
 */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <termios.h>
#include <fcntl.h>

#include <math.h>
#include "mex.h"


void mexFunction(int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    double *arg;

    /* Check for proper number of arguments */
    if (nrhs != 1) {
	mexErrMsgTxt("KCLOSE requires one input argument.");
    } else if (nlhs > 0) {
	mexErrMsgTxt("KCLOSE requires no output arguments.");
    }
    
    /* Check the dimensions */
    if ((mxGetM(prhs[0])!=1) || (mxGetN(prhs[0])!=2)) {
	mexErrMsgTxt("KCLOSE requires argument to be reference obtained"
		     "from KOPEN.");
    }
    if (!mxIsDouble(prhs[0])) {
	mexErrMsgTxt("The argument must be of type double!");
    }  
    
    /* Close down serial connection */
    arg = mxGetPr(prhs[0]);
    close(*(int *)arg);
}



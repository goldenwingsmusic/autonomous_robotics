/**
 * See ksend.m
 *
 * (C) 1999 Matthias Grimrath <m.grimrath@tu-bs.de>
 */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <termios.h>
#include <fcntl.h>

#include <math.h>
#include "mex.h"

#define CMDLEN 1024
#define RCVLEN 1024

void mexFunction(int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    int     m;
    int     ret;
    int     fd;
    int     cmdlen;         /* So 0-bytes can be sent as well */
    char    cmdbuf[CMDLEN];
    char    rcvbuf[RCVLEN];
    char   *rcvptr;
    int     rcv;
    double *arg;
    int     alwayswaittimeout;
    int     timeoutvalue;
    fd_set  readfds;
    fd_set  junkfds;
    struct timeval tv;

    /* Check for proper number of arguments */
    if (nrhs!=2 && nrhs!=3)
	mexErrMsgTxt("KSEND requires two or three input arguments.");

    /* Check and eval string argument */
    m = mxGetM(prhs[0]);
    if (m!=1)
	mexErrMsgTxt("Input must be a row vector!");
    if (!mxIsChar(prhs[0]))
	mexErrMsgTxt("Input must be a string");
    cmdlen = m * mxGetN(prhs[0]);
    ret = mxGetString(prhs[0], cmdbuf, CMDLEN);
    if (ret)
	mexErrMsgTxt("Command exceeds outputbufferlength");

    /* Check and eval fd argument */
    if ((mxGetM(prhs[1])!=1) || (mxGetN(prhs[1])!=2))
	mexErrMsgTxt("'ref' must be reference obtained from KOPEN.");
    if (!mxIsDouble(prhs[1]))
	mexErrMsgTxt("'ref' must be of type double!");
    arg = mxGetPr(prhs[1]);
    fd = *(int *)(arg++);
    timeoutvalue = *(int *)(arg++);

    /* Check and eval multiline, if present */
#if 0
    if (nrhs==3)
        mexErrMsgTxt("Multiline unimplemented!");
#endif

    /* Send the string */
    write(fd, cmdbuf, cmdlen);

    /* Wait for response */
    FD_ZERO(&readfds);
    FD_SET(fd, &readfds);
    tv.tv_sec  = timeoutvalue / 1000000;
    tv.tv_usec = timeoutvalue % 1000000;
    
    rcvptr = rcvbuf;
    while (rcvptr != rcvbuf + RCVLEN) {
	junkfds = readfds;
	rcv = select(fd+1, &junkfds, NULL, NULL, &tv);
	if (rcv<0) {
	    if (errno!=EINTR) {
		char buff[1024];
		snprintf(buff,1023,"KSEND select error: %s",strerror(errno));
		buff[1023]=0;
		mexErrMsgTxt(buff);
	    } else
		continue;
	}
	if (rcv==0) 
	    break; /* timeout */
	rcv = read(fd, rcvptr, rcvbuf + RCVLEN - rcvptr);
        if (rcv<0) {
            char buff[1024];
            snprintf(buff,1023,"KSEND read error: %s",strerror(errno));
            buff[1023]=0;
            mexErrMsgTxt(buff);
        }
	rcvptr += rcv;
	/* The khepera sends both 'cr' and 'lf', despite the documentation 
	 * says only 'lf', but maybe just these stupid unix terminalmodes
         * mess it up
	 */
	if (rcvptr-rcvbuf>=2 && strncmp(rcvptr-2,"\r\n",2)==0) {
	    rcvptr[-2]=0; /* Discard cr and lf */
	    plhs[0]=mxCreateString(rcvbuf);
	    return;
	}
    }
    /* Come here if no valuable response received */
    plhs[0] = mxCreateString("");
}

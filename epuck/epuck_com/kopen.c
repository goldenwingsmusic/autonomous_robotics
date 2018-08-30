/**
 * Opens the serial communication to the robot on Unix machines
 *
 *		ref = kopen([portid, baudrate, timeout])
 *
 *                    portid: 0 = /dev/ttya (serial port A)
 *                            1 = /dev/ttyb (serial port B)
 *
 *                    baudrate: Must be 9600.
 *
 *                    timeout: Number of seconds to wait for the 
 *                             respond of the robot.
 *
 *                    ref:  Handle to be used with the other serial
 *                          communication routines.
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


/* Settings for the serial communication */

#define ROBOTDEVICE "/dev/tty"
#define ROBOTDEVICEBLUETOOTH "/dev/rfcomm0"
#define MAXTIMEOUT 10000000   /* equals 10s */

static int kopen(int portid, int baudrate) 
{
    int fd;
    int i;
    struct termios tio;
    char devname[sizeof(ROBOTDEVICE)+10];

    /* create device name */
    if (portid==0)
    {
    strcpy(devname, ROBOTDEVICE);
      strcat(devname, "S0"); /* serielle Schnittstelle*/
    }
    else if (portid==1)
    {
    strcpy(devname, ROBOTDEVICE);
	strcat(devname, "S1");  /* hier soll noch die Video-Anschluss-Stelle rein */
    }
    else
    {
    strcpy(devname, ROBOTDEVICEBLUETOOTH);
    }

    /* Open modem device for reading and writing and not as
     * controlling tty because we don't want to get killed if
     * linenoise sends CTRL-C.  */
    fd = open(devname, O_RDWR | O_NOCTTY | O_NDELAY);
    fcntl(fd, F_SETFL, 0); /*Blocking*/
    if (fd < 0)
	return fd;
    tcgetattr(fd,&tio); /* save current modem settings */

    switch (baudrate) {
    case 9600:  baudrate = B9600; break;
    case 19200: baudrate = B19200; break;
    case 38400: baudrate = B38400; break;
    case 115200: baudrate = B115200; break;
    default:    baudrate = -1;
    }
    i =  cfsetospeed(&tio, B115200);
    i |= cfsetispeed(&tio, B115200);

    /* Set bps rate and hardware flow control and 8n2 (8bit,no
     * parity,2 stopbit).
     */
    tio.c_cflag |= (CS8|CLOCAL|CREAD);

    tio.c_lflag &= ~(ICANON | ECHO);

    /*
     * Ignore bytes with parity errors and make terminal raw and dumb.
     */
    tio.c_iflag = IGNPAR;
 
    /*
     * Raw output.
     */
    tio.c_oflag = 0;
 
    /* 
     * Don't echo characters 
     */
    tio.c_lflag = 0;
/*
    if (i)
        goto close_exit;
 */
    tio.c_cc[VMIN]=0;
    tio.c_cc[VTIME]=1;
 
    /* now clean the serial line and activate settings */
    tcflush(fd, TCIOFLUSH);
    tcsetattr(fd,TCSANOW,&tio);
    return fd;

close_exit:
    close(fd);
    return -1;
}

/* Gateway to MATLAB */

void mexFunction(int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    int portid;
    int baudrate;
    int timeoutvalue;
    int retval;
    double *arg;
    
    /* Check for proper number of arguments */
    if (nrhs != 1) {
	mexErrMsgTxt("KOPEN requires one input argument.");
    } else if (nlhs > 1) {
	mexErrMsgTxt("KOPEN requires one output argument.");
    }
    
    /* Check the dimensions */
    if ((mxGetM(prhs[0])!=1) || (mxGetN(prhs[0])!=3)) {
	mexErrMsgTxt("KOPEN requires argument to be [portid,baudrate,timeout].");
    }
    if (!mxIsDouble(prhs[0])) {
	mexErrMsgTxt("The arguments must be of type double!");
    }  
  
    /* Create a matrix for the return argument */
    plhs[0] = mxCreateDoubleMatrix(1, 2, mxREAL);
  
    /* Assign pointers to the various parameters */
    arg = mxGetPr(prhs[0]);
    portid        = (int)arg[0];
    baudrate      = (int)arg[1];
    timeoutvalue  = (int)(arg[2]*1000000);  /* timeout in �s */
    
    if (portid!=0 && portid!=1 && portid!=2)
	mexErrMsgTxt("Illegal portid. Only ttya (=0) and ttyb (=1) are "
		     "supported!");
    if (baudrate!=9600 && baudrate!=19200 && baudrate!=38400 && baudrate!=115200)
	mexErrMsgTxt("Only baudrate of 9600, 19200 or 38400 or 115200  is supported)!");
    if (timeoutvalue==0)
	mexErrMsgTxt("You WANT to specify a timeoutvalue!");
    if (timeoutvalue>=MAXTIMEOUT)
	mexErrMsgTxt("Timeoutvalue >10s, that's too much");

    /* Open the serial port */
    retval = kopen(portid, baudrate);
    if (retval < 0) {
        char buff[1024];
        snprintf(buff,1023,"KOPEN system error: %s",strerror(errno));
        buff[1023]=0;
        mexErrMsgTxt(buff);
    }

    arg = mxGetPr(plhs[0]);
    *(int *)(arg++) = retval;       /* Store as int in double to avoid */
    *(int *)(arg++) = timeoutvalue; /* conversion time */
}

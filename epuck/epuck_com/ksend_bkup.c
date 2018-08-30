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
#define RCVLEN 4096

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
    int send;
    double *arg;
    int     alwayswaittimeout;
    int     timeoutvalue;
    fd_set  readfds;
    fd_set  junkfds;
    struct timeval tv;
    float red[40*40];
    float blue[40*40];
    float green[40*40];

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

    /* PREP */
    tcflush(fd, TCIOFLUSH);

    tcflush(fd, TCIOFLUSH);
    const char *camera_settings = "J,1,80,20,8,0,0\n";
    int n = write(fd,camera_settings,strlen(camera_settings));
    char rec[RCVLEN];
    char *p_rec = rec;
    int bytes, bytes_tot = 0, failed = 0;

    while (failed < 16){
        bytes = read(fd, p_rec, 1);

        if (bytes == 0){
            failed++;
            continue;
        }

  if (bytes > 0){
    p_rec += bytes;
          bytes_tot += bytes;
  }

        if (bytes < 0)
            break;

        if (p_rec[-1] == 'j')
            break;
    }
    tcflush(fd, TCIOFLUSH);
    /* END PREP */

    /* Send the string */
    /*write(fd, cmdbuf, cmdlen);*/
    char    cmdbuffer[CMDLEN];
    char    buff[CMDLEN];
    /*cmdbuffer[0] = -'D';*/
   /* cmdbuffer[0] = -68;*/ /* D */
   /* cmdbuffer[0] = -69;*/ /* E */
   /* cmdbuffer[0] = -78;*/ /* N */
    cmdbuffer[0] = -'I'; /* I */
    cmdbuffer[1] = (char)0;
    cmdbuffer[2] = 1;
    cmdbuffer[3] = 1;
    cmdbuffer[4] = 1;
    cmdbuffer[5] = 0;
    /*int toWrite = 2;*/
    /*tcflush(fd, TCIFLUSH);*/
    /*tcflush(fd, TCOFLUSH);*/
    send = write(fd, cmdbuffer, 2);
    snprintf(buff,1023,"send length->: %i\n",send);
    mexPrintf(buff);
    snprintf(buff,1023,"send ->: %d,%d,%d,%d,%d\n",cmdbuffer[0],cmdbuffer[1],cmdbuffer[2],cmdbuffer[3],cmdbuffer[4]);
    mexPrintf(buff);
    char receivebuffer[RCVLEN];
    receivebuffer[0] = 0;
    receivebuffer[1] = 0;
    receivebuffer[2] = 0;
    char *bufptr = receivebuffer;
    int read_bytes, read_bytes_tot = 0, failed_reads = 0;
    /*NEW*/
    while (failed_reads < 16)
    {
      snprintf(buff,1023,"no. %d", failed_reads);
      mexPrintf(buff);
      read_bytes = read(fd, bufptr, 3 - read_bytes_tot);
      if (read_bytes == 0)
      {
        failed_reads++;
        snprintf(buff,1023,"failed read");
        mexPrintf(buff);
        continue;
      }
      if (read_bytes < 0)
      {
        snprintf(buff,1023,"read < 0");
        mexPrintf(buff);
        break;
      }
      bufptr += read_bytes;
      read_bytes_tot += read_bytes;

      if (read_bytes_tot >= 3)
        break;
    }
    snprintf(buff,1023,"receive ->: %d,%d,%d\n",receivebuffer[0],receivebuffer[1],receivebuffer[2]);
    mexPrintf(buff);
    int cam_width = receivebuffer[1];
    int cam_height = receivebuffer[2];
    bufptr = receivebuffer;
    read_bytes_tot = 0;
    failed_reads = 0;
    while (failed_reads < 16)
    {
      read_bytes = read(fd, bufptr, 2*cam_width*cam_height - read_bytes_tot);
      if (read_bytes == 0)
      {
        failed_reads++;
        snprintf(buff,1023,"failed read");
        mexPrintf(buff);
        continue;
      }
      if (read_bytes < 0)
      {
        snprintf(buff,1023,"read < 0");
        mexPrintf(buff);
        break;
      }
      bufptr += read_bytes;
      read_bytes_tot += read_bytes;

      if (read_bytes_tot >= 2*cam_width*cam_height)
        break;
    }
    snprintf(buff,1023,"received %d bytes\n",read_bytes_tot);
    mexPrintf(buff);

    /* ok, we read the whole image and all seems fine.
       now copy it to the RED/GREEN/BLUE output channels!*/
    /*
    plhs[0]=mxCreateDoubleMatrix(40,40,mxREAL);
    plhs[1]=mxCreateDoubleMatrix(40,40,mxREAL);
    plhs[2]=mxCreateDoubleMatrix(40,40,mxREAL);
    */
    /*
    double *p_red=(double*)mxGetPr(plhs[0]);
    double *p_green=(double*)mxGetPr(plhs[1]);
    double *p_blue=(double*)mxGetPr(plhs[2]);
    */
    int shift = cam_width*cam_height;
    int double_shift = 2*cam_width*cam_height;
    int dims[3]={cam_width,cam_height,3};
    plhs[0]=mxCreateNumericArray(3,dims,mxUINT8_CLASS,mxREAL);
    unsigned char *p_image=(unsigned char*)mxGetPr(plhs[0]);
    int msgidx = 0;
    int w,h;
    for (w = 0; w < cam_width; w++)
    {
        for (h = cam_height - 1; h > -1; h--)
        {
            int Pix_1 = receivebuffer[msgidx++];
            int Pix_2 = receivebuffer[msgidx++];

            int Red_pix=(int)((Pix_1&0xF8));
            int Green_pix=(int)(((Pix_1 & 0x07)<<5)|((Pix_2 & 0xE0)>>3));
            int Blue_pix=(int)((Pix_2 & 0x1F)<<3);

            if (Red_pix > 255) Red_pix = 255;
            if (Green_pix > 255) Green_pix = 255;
            if (Blue_pix > 255) Blue_pix = 255;
            p_image[w + h*cam_width] = Red_pix;
            p_image[w + h*cam_width+shift] = Green_pix;
            p_image[w + h*cam_width+double_shift] = Blue_pix;
        }
    }
    /*ENDNEW*/
    /*
    FD_ZERO(&readfds);
    FD_SET(fd, &readfds);
    tv.tv_sec  = timeoutvalue / 1000000;
    tv.tv_usec = timeoutvalue % 1000000;
int toRead = 16;
    while (failed_reads < 150)
    {
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
        {
            snprintf(buff,1023,"timeout");
            mexPrintf(buff);
	    break;
        }
        read_bytes = read(fd, bufptr, toRead - read_bytes_tot);
        snprintf(buff,1023,"read_bytes ->: %i\n",read_bytes);
        mexPrintf(buff);
        if (read_bytes == 0){
            failed_reads++;
            continue;
        }

        if (read_bytes < 0)
            break;

        bufptr += read_bytes;
        read_bytes_tot += read_bytes;

        if (read_bytes_tot >= toRead)
            break;
    }
    snprintf(buff,1023,"first read->: %d %d %d %d\n",receivebuffer[0],receivebuffer[1],receivebuffer[2],receivebuffer[3]);
    snprintf(buff,1023,"first read->: %d %d\n",(unsigned int)receivebuffer[0]+(unsigned int)receivebuffer[1]<<8,(unsigned int)receivebuffer[2]+(unsigned int)receivebuffer[3]<<8);
    mexPrintf(buff);
    int size = receivebuffer[1] * receivebuffer[2];
    bufptr = receivebuffer;
    read_bytes_tot = 0;
    failed_reads = 0;
*/
/*
    FD_ZERO(&readfds);
    FD_SET(fd, &readfds);
    tv.tv_sec  = timeoutvalue / 1000000;
    tv.tv_usec = timeoutvalue % 1000000;
    junkfds = readfds;
    rcv = select(fd+1, &junkfds, NULL, NULL, &tv);
    snprintf(buff,1023,"rcv->: %i\n",rcv);
    buff[1023]=0;
    mexPrintf(buff);
    read(fd, rcvbuf, 3);
    snprintf(buff,1023,"->: %i %i %i",rcvbuf[0],rcvbuf[1],rcvbuf[2]);
    mexPrintf(buff);
*/
/*
    FD_ZERO(&readfds);
    FD_SET(fd, &readfds);
    tv.tv_sec  = timeoutvalue / 1000000;
    tv.tv_usec = timeoutvalue % 1000000;
    junkfds = readfds;
    rcv = select(fd+1, &junkfds, NULL, NULL, &tv);
    snprintf(buff,1023,"rcv->: %i\n",rcv);
    buff[1023]=0;
    mexPrintf(buff);
    read(fd, rcvbuf, 3);
    read(fd,rcvbuf,40*40);
    int count = 0;

    for (i = 0; i < RCVLEN; i++)
    {
      if (rcvbuf[i] != 0)
	count++;
    }
    plhs[0]=mxCreateString(rcvbuf);

snprintf(buff,1023,"->: %i %i %i",rcvbuf[0],rcvbuf[1],count);
buff[1023]=0;
mexPrintf(buff);
    return;
*/
}

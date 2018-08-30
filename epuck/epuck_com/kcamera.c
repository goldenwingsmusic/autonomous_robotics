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
    int     rcv;
    int send;
    double *arg;
    int     alwayswaittimeout;
    int     timeoutvalue;
    char    buff[CMDLEN];

    /* Check for proper number of arguments */
    if (nrhs!=2 && nrhs!=3)
	mexErrMsgTxt("KCAMERA requires two or three input arguments.");

    /* Check and eval string argument
    m = mxGetM(prhs[0]);
    if (m!=1)
	mexErrMsgTxt("Input must be a row vector!");
    if (!mxIsChar(prhs[0]))
	mexErrMsgTxt("Input must be a string");
    cmdlen = m * mxGetN(prhs[0]);
    ret = mxGetString(prhs[0], cmdbuf, CMDLEN);
    if (ret)
	mexErrMsgTxt("Command exceeds outputbufferlength");
	*/

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
    /* END PREP */

    /* Send the string */
    char cmdbuffer[2];
    cmdbuffer[0] = -'I'; /* I */
    cmdbuffer[1] = (char)0;
    send = write(fd, cmdbuffer, 2);
    char receivebuffer[RCVLEN];
    char *bufptr = receivebuffer;
    int read_bytes, read_bytes_tot = 0, failed_reads = 0;
    /*NEW*/
    while (failed_reads < 16)
    {
      read_bytes = read(fd, bufptr, 3 - read_bytes_tot);
      if (read_bytes == 0)
      {
        failed_reads++;
        continue;
      }
      if (read_bytes < 0)
      {
        snprintf(buff,1023,"read < 0\n");
        mexPrintf(buff);
        break;
      }
      bufptr += read_bytes;
      read_bytes_tot += read_bytes;

      if (read_bytes_tot >= 3)
        break;
    }
    int mode = receivebuffer[0];
    int cam_width = receivebuffer[1];
    int cam_height = receivebuffer[2];
    bufptr = receivebuffer;
    read_bytes_tot = 0;
    failed_reads = 0;
    int multiplier;
    if (mode == 0)
      multiplier = 1;
    else
      multiplier = 2;
    while (failed_reads < 16)
    {
      read_bytes = read(fd, bufptr, multiplier*cam_width*cam_height - read_bytes_tot);
      if (read_bytes == 0)
      {
        failed_reads++;
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

      if (read_bytes_tot >= multiplier*cam_width*cam_height)
        break;
    }
    int msgidx = 0;
    int w,h;
    if (mode == 0)
    {
      plhs[0]=mxCreateNumericMatrix(cam_height,cam_width,mxUINT8_CLASS,mxREAL);
      unsigned char *p_image=(unsigned char*)mxGetPr(plhs[0]);
      int Pix_1;
      for (w = 0; w < cam_height; w++)
      {
          for (h = cam_width - 1; h > -1; h--)
          {
              Pix_1 = receivebuffer[msgidx++];
              if (Pix_1 > 255) Pix_1 = 255;
              p_image[w + h*cam_height] = (int)Pix_1;
          }
      }
    }
    if (mode == 1)
    {
      int dims[3]={cam_height,cam_width,3};
      plhs[0]=mxCreateNumericArray(3,dims,mxUINT8_CLASS,mxREAL);
      unsigned char *p_image=(unsigned char*)mxGetPr(plhs[0]);
      int shift = cam_width*cam_height;
      int double_shift = 2*cam_width*cam_height;
      int Pix_1, Pix_2, Red_pix, Green_pix, Blue_pix;
      for (w = 0; w < cam_height; w++)
      {
          for (h = cam_width - 1; h > -1; h--)
          {
              Pix_1 = receivebuffer[msgidx++];
              Pix_2 = receivebuffer[msgidx++];

              Red_pix=(int)((Pix_1&0xF8));
              Green_pix=(int)(((Pix_1 & 0x07)<<5)|((Pix_2 & 0xE0)>>3));
              Blue_pix=(int)((Pix_2 & 0x1F)<<3);

              if (Red_pix > 255) Red_pix = 255;
              if (Green_pix > 255) Green_pix = 255;
              if (Blue_pix > 255) Blue_pix = 255;
              p_image[w + h*cam_height] = Red_pix;
              p_image[w + h*cam_height+shift] = Green_pix;
              p_image[w + h*cam_height+double_shift] = Blue_pix;
          }
      }
    }
    /*ENDNEW*/
}

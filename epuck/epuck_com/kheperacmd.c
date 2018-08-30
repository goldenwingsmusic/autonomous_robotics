/**
 * Small program to talk to the Khepera robot
 */
#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/signal.h>
#include <string.h>

#define BAUDRATE B38400
#define ROBOTDEVICE "/dev/ttyS0"

/**
 * main()
 */
int main(int argc, char **argv)
{
    int fd;
    struct termios oldtio,newtio;
    char buff[255];
    char ch;
    char *buffptr;
 
    if (argc!=2) {
	fprintf(stderr,"Usage: kheperacmd <command>\n");
	return 1;
    }
    /* Open modem device for reading and writing and not as
     * controlling tty because we don't want to get killed if
     * linenoise sends CTRL-C.  */
    fd = open(ROBOTDEVICE, O_RDWR | O_NOCTTY); 
    if (fd <0) {perror(ROBOTDEVICE); exit(-1); }
 
    tcgetattr(fd,&oldtio); /* save current modem settings */
    newtio = oldtio;

    /*
     * Ignore bytes with parity errors and make terminal raw and dumb.
     */
    newtio.c_iflag = IGNPAR;
 
    /*
     * Raw output.
     */
    newtio.c_oflag = 0;
 
    /* Don't echo characters */
    newtio.c_lflag = 0;

    /* Set bps rate and hardware flow control and 8n2 (8bit,no
     * parity,2 stopbit).
     */
    newtio.c_cflag = CLOCAL|CREAD|CSTOPB|CS8;
    cfsetospeed(&newtio, BAUDRATE);
    cfsetispeed(&newtio, BAUDRATE);
 
    /* blocking read until 1 char arrives */
    newtio.c_cc[VMIN]=1;
    newtio.c_cc[VTIME]=0;
 
    /* now clean the serial line and activate settings */
    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);

    strcpy(buff,argv[1]);
    strcat(buff,"\n");
    write(fd, buff, strlen(buff));

    buffptr = buff;
    do {
	read(fd, &ch, 1);
	*buffptr++ = ch;
    } while(ch!='\n');
    *buffptr = 0;
    write(0, buff, strlen(buff));

    close(fd);
    return 0;
}

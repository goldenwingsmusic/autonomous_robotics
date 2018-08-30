%Opens the serial communication to the robot on Un*x machines
%
%handle = kopen([portid, baudrate, timeout])
%
%portid: 0 = /dev/ttya (serial port A, COM1 on PC hardware)
%           1 = /dev/ttyb (serial port B, COM2 on PC hardware)
%
%   baudrate: Must be one of 9600, 19200, 38400.  Other speeds unimplemented.
%
%   timeout: Maximum number of seconds to wait for the 
%            respond of the robot.
%
%   handle: Handle to be used with the other robot communication routines.
%
%(C) 1999 Matthias Grimrath <m.grimrath@tu-bs.de>

function kBraitenberg(ref,ksp)
%KRBRBERG   Basic Braitenberg mode
%
%kbrberg(ref)
%  Avoid obstacles with the Braitenberg algorithm
%  (ctrl-c to stop).
%  Use the reference obtained with kopen.
%
%kbrberg(ref,speed)
%  Use a speed factor, < 1 to go slower

% Written by Yves Piguet, 8/98.

if nargin<2
   ksp = 0.7;
end

gain = [-5,-15,-18,6,4,4,3,5;4,4,6,-18,-15,-5,5,3] / 400;
offset = 10 * [1;1];

gain = gain * ksp;
offset = offset * ksp;
sensors=ones(1,8);
while (sensors(7)+sensors(8))/mean(sensors)<4
   sensors = kProximity(ref);			% read the proximity sensors
   speed = gain * sensors + offset;	% calculate the speed
	kSetSpeed(ref,speed(2),speed(1));		% write the speed
end
kSetSpeed(ref,0,0)
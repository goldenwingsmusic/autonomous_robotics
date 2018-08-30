clc;
clear;
close all;

h= kOpenPort();
kSetEncoders(h,0,0);
velocity = 600;
points = [70,90;210,340;90,250;230,60;210,340];

hold on;
axis([0 9 0 9]);

navigate(h,points,velocity);
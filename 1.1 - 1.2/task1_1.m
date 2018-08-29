clear;
clc;

h= kOpenPort();

l = 60;
r = 60;
velocity = 400;

points = [70,90;210,340;70,90;90,250;230,60];
navigate(h,points,velocity);

kClose(h);
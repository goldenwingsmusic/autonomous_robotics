clc;
clear;
close all;
hold on;

%% Initialize robot comm

h= kOpenPort();
kSetEncoders(h,0,0);

%% Set constants

velocity = 300;
points = [230,60;210,340;230,60;210,340];


%% Navigate

navigate(h,points,velocity,(pi/2));



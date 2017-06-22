clc;
close all;
clear all;

x = ones(5000, 1);
h = ones(1000, 1);

y = myFastConvolution(x, h);
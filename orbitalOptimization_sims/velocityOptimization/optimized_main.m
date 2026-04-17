clear; clc; close all; 

% Guess
delta_v = -50;

% Set up the handle for the objective function 
fun = @(delta_v)optFunction(delta_v);

% Set limit for the number of iterations
options = optimset('MaxIter',5);

% xSol is the lowest delta_v that leads to a return to Earth
[xSol,feval] = fminsearch(fun,delta_v, options);

% Output
disp(['The lowest delta_v that results in the S/C returning to Earth is ', num2str(xSol), ' (m/s).'])

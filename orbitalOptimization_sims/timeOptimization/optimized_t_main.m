clear; clc; close all; 

% Main for the time minimization

% Guess of initial velocity
x = 990;

% Set up the handle for the objective function 
fun = @(x)opt_t_Function(x);

% Set limit for the number of iterations
options = optimset('MaxIter',5);

% xSol is the initial velocity that minimizes time to return
% feval is the time to return
[xSol,feval] = fminsearch(fun,x, options);

% Output
disp(['The velocity that returns the S/C to Earth the fastest is ', num2str(xSol), ' (m/s). The S/C returns in  ', num2str(feval), ' (s)']);


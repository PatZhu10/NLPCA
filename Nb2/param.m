function param
% function param
% Set default parameters for the NLPCA model run
% Note: the parameters 'penalty' and 'm' are reset in the nlpca1.m program.

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
%------------------------------------------------------------------------
% Parameters are classified into 3 categories, '%**' means user normally
%  has to change the value to fit the problem. '%++' means user may want to
%  change the value, and '%-- means user rarely has to change the value.
%------------------------------------------------------------------------ 
warning off; %-- turn off warning messages
iprint = 2; %++ iprint = 0, 1, 2, 3 increases the amount of printout
Err_norm = 2; %++ 1 or 2 (L1 or L2 norm to measure error, i.e. using mean
              % absolute error (MAE) or mean square error (MSE) for Err. 
linear = 0; %-- linear = 0 for nonlinear PCA, 1 for linear PCA.
nensemble = 25; %++ Number of ensemble runs

testfrac = 0.15; %-- fraction of data selected for testing to prevent overfitting
segmentlength = 1; %++ data selected in segments of length segmentlength.
overfit_tol = 0; %-- tolerance for overfitting, should be a small
                 % positive number (0.1 or less). If 0, program
                 % calculates a new overfit_tol2, and may accept
                 % some ensemble members previously rejected.
info_crit = 1; %-- 1 = information criterion H used in model selection.
               %   0 = Err (MSE or MAE) used in model selection.
xscaling = 1; %** controls scaling of x variables. -1 means no scaling.
              % 0 scales all x variables by removing the mean and
              % dividing by the standard deviation of each variable. 
              % 1 scales all x variables by removing the mean and
              % dividing by the standard deviation of the 1st x variable.
penalty_store = [1  0.1  0.01  0.001  0.0001 0];  %++ penalty values to try

maxiter = 1; %--  scale for the maximum number of function iterations during
             %    optimization. Start with 1, increase if needed.

%++ choose positive integer to initialize random no. generator
initRand = 1;  %++
rand('state', initRand);

initwt_radius = 1; %-- scales the radius of initial random wt. distribution

% input dimensions of the networks:--------------------------------
l = 3;  %** l is the no. of x variables
%**  m, the no. of hidden neurons, is now assigned in the main program
%    (nlpca1.m) from values specified by m_store.

nbottle = 2; %-- no. of bottleneck neurons
%-----------------------------------------------------------------

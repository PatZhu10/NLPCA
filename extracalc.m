function [xi,u] = extracalc(W,xdata,unew)
% function [xi,u] = extracalc(W,xdata,unew)
% Performs extra calculations with NLPCA. Three uses:
%
% (1) To generate xi & u from xdata, as needed by plotting programs such 
% as plmode1.m. Usage:
% [xi,u] = extracalc(W,xdata);
% (Do NOT supply the arguments unew).
% 
% (2) When new data xdatanew become available, then to get the xi and u
% for the new data (without retraining the neural network), use:
% [xi,u] = extracalc(W,xdatanew);
% (Do NOT supply the arguments unew).
% 
% (3) Given unew, to generate xi, use:
% [xi] = extracalc(W,xdata,unew);
% (xdata being a dummy argument, i.e. not used).
%
global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H

if nargin < 3 %[[[----------- 
%%%% scales xdata  if xscaling >=0.
if xscaling >=0; %((
[xdata] = nondimen(xdata',xscaling,xmean,xstd);
xdata = xdata';
end %))

[u] = mapu(xdata,W);
else %-----------------
u = unew;
end; %]]]-------------

[xi] = invmapx(u,xdata,W);

%%%% scale x variables if needed
if xscaling >= 0; %((
% restore xdata to original size
[xdata] = dimen(xdata',xmean,xstd,xscaling)'; 
[xi] = dimen(xi',xmean,xstd,xscaling)';
end %))

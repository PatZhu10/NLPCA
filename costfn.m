function [J] = costfn(W);
% function [J] = costfn(W);
% cost function

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
[utrain] = mapu(xtrain,W); % forward map from x to u
[xitrain,J,junk] = invmapx(utrain,xtrain,W); % inverse map from u to xi
iter = iter+1;







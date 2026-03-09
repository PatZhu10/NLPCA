function [u]  = mapu(x,W)
% function [u]  = mapu(x,W)
% Maps from x to u.

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
[mm,nn]= size(x);
one = ones(1,nn);

iend=m*l;
wx = reshape(W(1:iend),[m,l]);
ibeg=iend+1;
iend=iend+m;
bx = W(ibeg:iend);
ibeg=iend+1;
iend=iend+m*nbottle;
whx = reshape(W(ibeg:iend),[m,nbottle]);
ibeg=iend+1;
iend =iend + nbottle;
bhx = W(ibeg:iend);

hx = zeros(m,nn);

if linear == 0 %((( nonlinear
hx = tanh(wx*x + bx*one);
else %--- linear
hx = wx*x + bx*one;
end %)))

u = whx'*hx + bhx*one;

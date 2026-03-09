function [xi,J,J0] = invmapx(u,x,W)
% function [xi,J,J0] = invmapx(u,x,W)
% Inverse map from u to xi. J is the cost fn; J0 is the Err*Jscale.
%
% J and J0 are not calculated if one uses [xi] = invmapx(u,x,W) or
% [xi] = invmapx(u,dummy,W).
%
% Note xi is nondimensionalized if xscaling >= 0. To dimensionalize xi:
% [xi] = dimen(xi',xmean,xstd,xscaling)';

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
[mm,nn]= size(u);
one = ones(1,nn);
lm = l*m;

ibeg = (lm+m+(m+1)*nbottle) + 1;
iend= ibeg -1 + m*nbottle;
wu = reshape(W(ibeg:iend),[m,nbottle]);
ibeg=iend+1;
iend=iend+m;
bu = W(ibeg:iend);
ibeg=iend+1;
iend=iend+lm;
whu = reshape(W(ibeg:iend),[l,m]);
ibeg=iend+1;
iend=iend+l;
bhu = W(ibeg:iend);

hu = zeros(m,nn);

if linear == 0 %((( nonlinear
hu = tanh(wu*u + bu*one);
else %--- linear
hu = wu*u + bu*one;
end %)))

xi = whu*hu + bhu*one;

if (nargout>1); %[[[[
%=====================================================================
% calculate J0 (i.e. the MSE or MAE), then the cost function J
%=====================================================================

if Err_norm == 2;
J0 = sum(diag((xi-x)*(xi-x)'))/nn*Jscale;
else;
J0 = sum(sum(abs(xi-x)))/nn*Jscale;
end;

% add the normalization condition u*u'/nn = 1, and mean(u) = 0
J = J0 +(sum(diag((u*u'/nn - ones(nbottle,nbottle)).^2))...
    + sum(mean(u').^2))*max(1,penalty);

if penalty ~= 0; J = J + penalty*norm(W(1:lm))^2; end; % add penalty term?

%-----------------------------------------------------------------------
% if nbottle > 1, force the bottleneck neurons to be uncorrelated with
% each other. If you don't want this, delete the next 10 lines of code.
%-----------------------------------------------------------------------
if nbottle > 1; %[[[----------------------------------------------------
Jnb = 0;
for nb = 1 : nbottle-1 %(((
for nb1 = nb+1 : nbottle %((
Jnb = Jnb + (u(nb,:)*u(nb1,:)')^2;
end; %))
end; %)))
J = J + Jnb/nn;
end; %]]]---------------------------------------------------------------



end; %]]]]
 




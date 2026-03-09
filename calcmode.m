function [u,xi,W] = calcmode(xdata)
% function [u,xi,W] = calcmode(xdata)
% Copyright (C) 2001,2007   William W. Hsieh
% Calculates 1 NLPCA (or PCA) mode
% If there are convergence problems, one could adjust some of the
% parameters marked by '>>>>' (maxiterations, overallexpand & options) 
% in calcmode.m directly, though this is usu. not necessary.

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
    xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
%%%% scales xdata  if xscaling >=0.
if xscaling >=0; %((
[xdata,xmean,xstd] = nondimen(xdata',xscaling);
xdata = xdata';
end; %))

if iprint >=2; %(((
 if linear == 0; 
   fprintf(1,'\n\nNonlinear mode: m = %3i,  penalty =%10.5g\n',m,penalty); end;
 if linear == 1; 
   fprintf(1,'\n\nLinear mode: m = %3i,  penalty =%10.5g\n',m,penalty); end;
 if iprint == 2; %((
   fprintf(1,'\n run  no.iter Err(train) Err(test)  Err(all)');
   fprintf(1,'     I         H');
 end; %))
end; %)))

%%%% Initialize variables 
Err_ens = 1.e88;  H_ens = 1.e88;  Jtest = 0;  Errtest = 0; 
ens_accept = zeros(1,nensemble);
ens_Err = zeros(1,nensemble); 
ens_delErr = zeros(1,nensemble); 
ens_I = zeros(1,nensemble); ens_H = zeros(1,nensemble);

% Set the factor to expand random wt. radius between ensemble members.
overallexpand = 4; %>>>> wt. radii expand by this overall factor between
                   % the 1st ensemble member and the last.
expand = overallexpand^(1./nensemble); % wt. expand factor between
                                      % adjacent ensemble members.

% ===================================================================
for iensemble = 1: nensemble %{{{{{{ ensemble

% The record xdata is randomly divided into training
% part xtrain and testing part xtest. 
% testfrac is the fraction selected for testing.
[n,xtrain,ntrain,xtest,ntest,testsetindex] = ...
                      chooseTestSet(xdata,testfrac,segmentlength,0);

%%%% setup various matrices in the forward mapping
normx = zeros(1,ntrain);
for i = 1:ntrain; normx(i)= norm(xtrain(:,i)); end;
xscale = mean(normx);
wx = ones(m,l)/xscale;
bx = ones(m,1);
whx = ones(m,nbottle);
bhx = ones(nbottle,1);
wu = ones(m,nbottle);
bu = ones(m,1);
whu = ones(l,m)*xscale;
bhu = ones(l,1)*xscale;
utrain = zeros(nbottle,ntrain);

%%%% combine all the weight and bias parameters into a single wt vector
Wscale=[reshape(wx,[m*l,1]);bx;reshape(whx,[m*nbottle,1]);bhx;...
        reshape(wu,[m*nbottle,1]);bu;reshape(whu,[l*m,1]);bhu];
% random initial weights.
W=(expand^iensemble)*initwt_radius*0.25*(2.*rand(size(Wscale))-1.).*Wscale;

if iensemble == 1; %[[[ set up matrices for the ensemble
ens_W = zeros(size(W,1),size(W,2),nensemble);
end; %]]]

%%%% find the optimal solution: ---------------------------------

%>>>> max. no. of function iterations during optimization.
maxiterations = maxiter*600*max(size(W));

% For more info on the options in the optimization m-file fminunc, 
% type: help foptimset
options = optimset('Display','off','TolX',1.e-5,'TolFun',1.e-5,...
                    'MaxFunEvals', maxiterations);

if iprint >= 3; fprintf(1,'\nRun no.%4.0f \n',iensemble);end;

iter = 0; 

% set up scale factor Jscale for the cost fn J
if Err_norm == 2 ; 
Jscale = 1/(sum(diag(xtrain*xtrain'))/ntrain); 
else
Jscale = 1/(sum(sum(abs(xtrain)))/ntrain);
end;
[utrain] = mapu(xtrain,W); % forward map to u (training data)
% map back to x
[xitrain,Jtrain,J0train] = invmapx(utrain,xtrain,W);
Errtrain = J0train/Jscale;  
if testfrac > 0.; %((
[utest] = mapu(xtest,W);  % test data
[xitest,Jtest,J0test] = invmapx(utest,xtest,W);
Errtest = J0test/Jscale;
end; %))

if iprint >= 3;  % print results prior to training
fprintf(1,' no.iter.  Err(train)  Err(test)   J(train)   J(test)\n');
fprintf(1,' %6.0f  %10.5f  %10.5f %10.5g %10.5g\n',...
   iter,Errtrain,Errtest,Jtrain,Jtest); 
end;
%===================================================================

%%%% work on training data
W = fminunc('costfn',W,options);
[utrain] = mapu(xtrain,W);
[xitrain,Jtrain,J0train] = invmapx(utrain,xtrain,W);
Errtrain = J0train/Jscale; 

%%%% work on test data
if testfrac > 0.; %(((
[utest] = mapu(xtest,W);
[xitest,Jtest,J0test] = invmapx(utest,xtest,W);
Errtest = J0test/Jscale;
end; %)))

if iprint ==2;
fprintf(1,'\n%4i %7.0f%10.5f%10.5f',iensemble,iter,Errtrain,Errtest); 
end;

if iprint ==3;
fprintf(1,' %6.0f  %10.5f  %10.5f %10.5g %10.5g\n',...
  iter,Errtrain,Errtest,Jtrain,Jtest);
end;


%==========================================================

Err = (Errtrain*ntrain + Errtest*ntest)/n;
ens_delErr(iensemble) = Errtest - Errtrain; 

[u] = mapu(xdata,W); [xi,J,junk] = invmapx(u,xdata,W);

u1 = nondimen(u'); u1 = u1'; % standardize u


%%%% Calculate inconsistency index I 

u1nearest = u(:,inearest); % NLPC of nearest neighbours
u1nearest = nondimen(u1nearest'); % standardize u1nearest
u1nearest = u1nearest'; 

if nbottle == 1; %[[[
  corr = corrcoef(u1,u1nearest);  I = 1 -corr(1,2);

else  %+++  nbottle > 1   +++
  sum_corr = 0;
 for nb = 1:nbottle %((
  corr = corrcoef(u1(nb,:),u1nearest(nb,:)); 
  sum_corr = sum_corr + corr(1,2);
 end; %))
  ave_corr = sum_corr/nb;  I = 1 - ave_corr; 
end; %]]]

% holistic information criterion H

if Err_norm == 2;  H = Err*I;  else;  H = (Err^2)*I;  end;

%--------------------------------------------------------------

if iprint == 2; fprintf(1,' %10.5f%10.5f%10.5f',Err,I,H); end;

if iprint >= 3; %(((
 fprintf(1,'  Err(all) =%10.5f, I =%8.5f, H =%10.5f',Err, I, H);
end; %)))

%%%% if Errtest <= Errtrain*(1+overfit_tol), no overfitting, 
%    so accept sol'n:
if Errtest <= Errtrain*(1+overfit_tol) %[[[[---------------

ens_accept(iensemble) = 1; % index indicating accepted ensemble member

if iprint == 2; fprintf(1,' accept'); end;
if iprint >= 3; fprintf(1,' , accept'); end;

%[[[ choose as best in the ensemble?
if (info_crit > 0 & H < H_ens)|(info_crit == 0 & Err < Err_ens) ;
H_ens = H;  I_ens = I;  Err_ens = Err; 
soln_xitrain = xitrain; soln_utrain = utrain; soln_W = W;
if testfrac > 0; soln_xitest = xitest;  soln_utest = utest; end;
end; %]]]

end; %]]]]----------------------

%%%% save ensemble solutions
ens_Err(iensemble) = Err;  
ens_I(iensemble) = I; ens_H(iensemble) = H;  ens_W(:,:,iensemble) = W;
 
end; %}}}}}}===========================================================

if Err_ens == 1.e88; 
err_msg1 = '\n### NOTE ###: No ensemble member has been accepted as solution.';
err_msg2 = ' Increase nensemble or overfit_tol, or decrease m, or avoid small penalty';
err_msg = [err_msg1, err_msg2];
error(err_msg)
end;

%%%% if overfit_tol = 0, program estimates a new overfit_tol2 
%    and looks over the ensemble solutions with overfit_tol2
%    to accept some previously rejected solutions.
if testfrac > 0 & overfit_tol == 0; %{{{{{ ---------------------------------
zz = ens_accept./ens_Err;
overfit_tol2 = abs(zz*ens_delErr')/sum(zz);
if iprint >=2;
fprintf(1,'\n\nProgram estimates new overfit_tol2 = %9.4g',overfit_tol2); 
end;

inewbestsoln=0;
for iensemble = 1: nensemble; %[[[[
if ens_accept(iensemble)==0 & ens_delErr(iensemble)<overfit_tol2; %[[[
ens_accept(iensemble) = 1;
if iprint >= 2; 
fprintf(1,'\n Run no. %4.0f is now accepted',iensemble); 
end;

%[[ New 'best' sol'n ?
if (info_crit > 0 & ens_H(iensemble) < H_ens)|...
 (info_crit == 0 & ens_Err(iensemble) < Err_ens) ;
Err_ens = ens_Err(iensemble);  
I_ens = ens_I(iensemble); H_ens = ens_H(iensemble);  
W = ens_W(:,:,iensemble); inewbestsoln =1;
end; %]]
end; %]]]
end; %]]]]

if inewbestsoln == 1; %[[[ calculate the new best sol'n
[utrain] = mapu(xtrain,W); % forward map to u (training data)
% map back to x
[xitrain,Jtrain,J0train] = invmapx(utrain,xtrain,W); 
soln_xitrain = xitrain; soln_utrain = utrain; soln_W = W;
[utest] = mapu(xtest,W); 
[xitest,Jtest,J0test] = invmapx(utest,xtest,W);
soln_xitest = xitest;  soln_utest = utest;
end; %]]]

end; %}}}}}-------------------------------------------------

%%%% Rename variables before saving
W = soln_W; Err = Err_ens; I = I_ens; H = H_ens; 
xitrain = soln_xitrain;  utrain = soln_utrain;
if testfrac >0; xitest = soln_xitest;  utest = soln_utest; end;
[u] = mapu(xdata,W);
[xi,J,junk] = invmapx(u,xdata,W);

%%%% scale x variables to original dimensions if needed
if xscaling >= 0; %((
% restore xdata to original size
[xdata] = dimen(xdata',xmean,xstd,xscaling)'; 
[xi] = dimen(xi',xmean,xstd,xscaling)';
[xitrain] = dimen(xitrain',xmean,xstd,xscaling)';
if testfrac >0; [xitest] = dimen(xitest',xmean,xstd,xscaling)'; end;
end; %))

if iprint >=2; fprintf(1,'\n\nChosen run:'); end;

if iprint >=1; %((( --- printout some summary results --------------------
fprintf(1,'\n### m =%2i, penalty =%8.3g, Err =%10.5f',m,penalty,Err);

Errdim = Err;
if xscaling >=0; %((  calculate dimensionalized Err
if Err_norm == 2;
Errdim = sum(diag((xi-xdata)*(xi-xdata)'))/n;
else
Errdim = sum(sum(abs(xi-xdata)))/n;
end;
fprintf(1,' =  %10.5g (dimensionalized)',Errdim);
end; %))

% calculate variance explained (%)
xdev = xdata' - ones(n,1)*mean(xdata'); xdev = xdev';
var_data = sum(diag(xdev*xdev'))/(n-1);
MSE = sum(diag((xi-xdata)*(xi-xdata)'))/n;
percent_var = 100*(1- n/(n-1)*MSE/var_data);

fprintf(1,'\n## %% var.=%7.3f,  I =%10.5g,  H =%10.5g',percent_var,I,H);

if testfrac > 0; %((
zz='\n#%4.0f out of %4.0f ensemble members accepted by the overfit test.';
fprintf(1,zz,sum(ens_accept),nensemble); 
end; %))
meanu2 = diag(u*u'/n); 
fprintf(1,'\n mean(u^2) = %7.4g  %7.4g  %7.4g  %7.4g  %7.4g  %7.4g',meanu2);
if max((meanu2-1).^2) > 0.04;  %((
fprintf(' <### NOTE: ###: mean(u^2) not close to unity')
end; %))
end; %)))

% Nonlinear principal component analysis (NLPCA) program by W.Hsieh.
% Extracts mode 2.
% <<<< indicates where the user may need to modify the code <<<< 

clear all;
path('..',path); %<<<<< may need to set directory path <<<<

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
load data1; %<<<< load data  <<<<<
load mode1;  % <<<<< load NLPCA mode 1 solution  <<<<<<<

% you could select the particular combination of m and penalty
% from m_store(im) and penalty_store(ip) by specifying im and ip 
% instead of using the default best option below 
im = im_best; ip = ipenalty_best; %<<<<<<<<<<

m = m_store(im); penalty = penalty_store(ip);
fprintf(1,'\nMode 1 chosen has  m =%3i,  penalty = %8.3g',m,penalty);
W = W_store{ip,im};
[xi,u] = extracalc(W,xdata); % calculate mode 1 solution xi

%  remove contributions from mode 1 from original data.
xdata2 = xdata - xi;

[inearest] = nearest(xdata2); % find nearest neighbours in the dataset

cputime0 = cputime;
param  % read default parameters from file param.m
%-----------------------------------------------------------------
% Uses function calcmode to calculate PCA mode 2 (linear mode) 

linear = 1; m = nbottle; testfrac = 0; penalty = 0; info_crit = 0;
nensemble = 7;
fprintf(1,'\n\n###> Linear mode:');

[u,xi,W] = calcmode(xdata2); 

% store output from linear mode
Wlin = W; Errlin = Err; Ilin = I; Hlin = H;

fprintf(1,'\n# cputime = %11.4g\n',cputime-cputime0); cputime0=cputime;


%-----------------------------------------------------------------------
% Calculate the NLPCA mode 2.
% Specify the range of m values in m_store  <<<<<<<

param;  % reread default parameters from file param.m
m_store = [2:4]; %<<<<<<<<<

msize = size(m_store,2);  psize = size(penalty_store,2); 
Err_store = zeros(psize,msize); I_store = zeros(psize,msize);
H_store = zeros(psize,msize);  H_best = 1e9;  Err_best = 1e9;

fprintf(1,'\n\n###> Nonlinear mode:');

for j = 1:msize; %{{{{{
for i = 1:psize; %[[[[[
m = m_store(j);
penalty = penalty_store(i);
[u,xi,W] = calcmode(xdata2); 
  
 W_store{i,j} = W;  Err_store(i,j) = Err;  
 I_store(i,j) = I;  H_store(i,j) = H;

if (info_crit > 0 & H < H_best)|(info_crit == 0 & Err < Err_best) %((((
  H_best = H;  Err_best = Err; 
  penalty_best = penalty;  ipenalty_best = i;
  m_best = m;  im_best = j;
end; %))))

fprintf(1,'\n### Err/Err(lin) =%7.4g, I/I(lin) =%7.4g, H/H(lin) =%7.4g',...
  Err/Errlin, I/Ilin, H/Hlin);
fprintf(1,'\n# cputime = %11.4g\n',cputime-cputime0); cputime0=cputime;

% save output to a file
save mode2   n l nbottle initRand xscaling xmean xstd linear inearest ...
   penalty_store m_store W_store Err_store I_store H_store Err_best ...
   H_best penalty_best ipenalty_best m_best im_best Wlin Errlin ...
   Ilin Hlin xdata2

end; %]]]]]
end; %}}}}}

fprintf(1,'\n##### Best: m = %3i, penalty = %9.3g,',m_best,...
 penalty_best);
fprintf(1,' Err/Err(lin) = %8.4g, H/H(lin) = %8.4g\n',...
 Err_best/Errlin, H_best/Hlin);

%-----------------------------------------------------------------



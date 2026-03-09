% Plot mode 2 from NLPCA program.
% Produces (encapsuled) postscript file plmode2.eps.
% 
% May need to set directory path to access the directory containing the
% extracalc.m program.
% 
% plot_lin = 1 plots linear mode; 
%          = 0 does not plot linear mode.
%
% plot_orig_data = 1 plots the original data (i.e. xdata);
%                = 0 plots the data after NLPCA mode 1 has been removed
%                    (i.e. xdata2).
%
% <<<< indicates where the user may need to modify the code <<<<

clear all;
path('..',path); %<<<<< may need to set directory path <<<<

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
plot_lin = 1 %<<<<<<<<<
plot_orig_data = 1  %<<<<<<<<<

load mode2  % <<<<< load NLPCA mode 2 solution  <<<<<<<


if plot_lin == 1; %[[[  plot linear mode 2 or not ---------------

% note this is the linear mode after the NLPCA.cir mode 1 has been
% extracted, i.e. not the same as PCA mode 2.
 linear = 1;  m = 1;
[xi,u] = extracalc(Wlin,xdata2);

% locate the end coordinates of the line described by the linear mode.
[xl(1,1),imax] = max(xi(1,:)); [xl(1,2),imin] = min(xi(1,:));
for i = 2:l; xl(i,1) = xi(i,imax); xl(i,2) = xi(i,imin); end;

end; %


% generate nonlinear mode 2 ---------------------------------
linear = 0;

% you could select the particular combination of m and penalty
% from m_store(im) and penalty_store(ip) by specifying im and ip 
% instead of using the default best option below
 
im = im_best; ip = ipenalty_best; %<<<<<<<<<<

m = m_store(im); penalty = penalty_store(ip);
fprintf(1,'\nPlot mode 2 for  m =%3i,  penalty = %8.3g',m,penalty);

W = W_store{ip,im};
[xi,u] = extracalc(W,xdata2); % calculate mode 2 solution xi

%--- plot original data, or data with NLPCA mode 1 removed -----------
if plot_orig_data == 1; %(((
load data1; %<<<<< load dataset containing xdata  <<<<<<<<<<<
x = xdata; 
else %---
x = xdata2; 
end; %)))

% plot the x variables  ------------------------------------------
set(0,'DefaultLineLineWidth',1.3)
set(0,'DefaultAxesFontSize',12);
figure;
subplot(2,2,1);
if plot_lin == 1; %(((
plot(xl(1,:),xl(2,:),'k--',x(1,:),x(2,:),'b.',xi(1,:),xi(2,:),'ro','Markersize',4);
else
plot(x(1,:),x(2,:),'b.',xi(1,:),xi(2,:),'ro','Markersize',4);
end; %))) 
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
if plot_lin == 1; %(((
plot(xl(1,:),xl(3,:),'k--',x(1,:),x(3,:),'b.',xi(1,:),xi(3,:),'ro','Markersize',4);
else
plot(x(1,:),x(3,:),'b.',xi(1,:),xi(3,:),'ro','Markersize',4);
end %)))
title('(b)','FontSize',13)
xlabel('x_1','FontSize',12)
ylabel('x_3','FontSize',12)

subplot(2,2,3);
if plot_lin == 1; %(((
plot(xl(2,:),xl(3,:),'k--',x(2,:),x(3,:),'b.',xi(2,:),xi(3,:),'ro','Markersize',4);
else
plot(x(2,:),x(3,:),'b.',xi(2,:),xi(3,:),'ro','Markersize',4);
end;
title('(c)','FontSize',13)
xlabel('x_2','FontSize',12)
ylabel('x_3','FontSize',12)

subplot(2,2,4);
if plot_lin == 1; %(((
plot3(xl(1,:),xl(2,:),xl(3,:),'k--',xi(1,:),xi(2,:),xi(3,:),'ro','Markersize',4)
;
else
plot3(xi(1,:),xi(2,:),xi(3,:),'ro','Markersize',4);
end %)))
view([-32.5,40]); %<<<<< vary view angles for different 3D perspective

title('(d)','FontSize',13)
xlabel('x_1','FontSize',12)
ylabel('x_2','FontSize',12)
zlabel('x_3','FontSize',12)
box off; grid on;

%- print -deps plmode2.eps  % save plot as black and white eps file
print -depsc plmode2.eps  % save plot as colour eps file


% Plot mode 2 from NLPCA program. (Note: Ignore 1st figure)
% Produces (encapsuled) postscript files plmode2x.eps and plmode2y.eps.
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

end; %]]] 


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


% plot the x variables -------------------------------


set(0,'DefaultLineLineWidth',1.3)
figure;  % ignore first plot 
if plot_lin == 1; %((
plot3(x(1,:),x(2,:),x(3,:),'.',xi(1,:),xi(2,:),xi(3,:),'square',...
xl(1,:),xl(2,:),xl(3,:),'--');
l1=get(gca,'XLim'); z1=max(l1); 
l2=get(gca,'YLim'); z2=max(l2);
l3=get(gca,'ZLim'); z3=min(l3);
zl1 = z1*ones(1,size(xl,2)); z1 = z1*ones(1,size(xi,2)); 
zl2 = z2*ones(1,size(xl,2)); z2 = z2*ones(1,size(xi,2)); 
zl3 = z3*ones(1,size(xl,2)); z3 = z3*ones(1,size(xi,2));
else
plot3(x(1,:),x(2,:),x(3,:),'.',xi(1,:),xi(2,:),xi(3,:),'square')
l1=get(gca,'XLim'); z1=max(l1); 
l2=get(gca,'YLim'); z2=max(l2);
l3=get(gca,'ZLim'); z3=min(l3);
end; %))
xlabel('x_{1}','FontSize',15)
ylabel('x_{2}','FontSize',15)
zlabel('x_{3}','FontSize',15)


figure; % 2nd plot is the desired plot
h = axes('GridLineStyle','--','FontSize',12);

if plot_lin == 1; %((
plot3(xi(1,:),xi(2,:),xi(3,:),'ksquare',xl(1,:),xl(2,:),xl(3,:),'r--',...
xl(1,:),xl(2,:),zl3,'k-',x(1,:),x(2,:),z3,'b.',xi(1,:),xi(2,:),z3,'ro',...
xl(1,:),zl2,xl(3,:),'k-',x(1,:),z2,x(3,:),'b.',xi(1,:),z2,xi(3,:),'ro',...
zl1,xl(2,:),xl(3,:),'k-',z1,x(2,:),x(3,:),'b.',z1,xi(2,:),xi(3,:),'ro',...
'Markersize',5);
else
plot3(xi(1,:),xi(2,:),xi(3,:),'ksquare',x(1,:),x(2,:),z3,'b.',...
xi(1,:),xi(2,:),z3,'ro',x(1,:),z2,x(3,:),'b.',xi(1,:),z2,xi(3,:),'ro',...
z1,x(2,:),x(3,:),'b.',z1,xi(2,:),xi(3,:),'ro','Markersize',5)
end; %))

set(gca,'XLim',l1,'YLim',l2,'ZLim',l3,...
'XLimmode','manual','YLimmode','manual','ZLimmode','manual');

view([-32.5,40]); %<<<<< vary view angles for different 3D perspective

xlabel('x_{1}','FontSize',15)
ylabel('x_{2}','FontSize',15)
zlabel('x_{3}','FontSize',15)

box off; grid on;

%- print -deps pltmode2.eps  % save plot as black and white eps file
print -depsc pltmode2.eps  % save plot as colour eps file

% Plot mode 1 from NLPCA program.  (Note: Ignore 1st figure)
% May need to set directory path to access the directory containing the
% extracalc.m program.
% <<<< indicates where the user may need to modify the code <<<< 

clear all;
%- path('~/Directory',path); %<<<<< may need to set directory path <<<<

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err inearest I H
 
load data1 %<<<< load data  <<<<<
load mode1  % <<<<< load NLPCA mode 1 solution  <<<<<<<

% Generate linear mode 1 -------------------------------------
x= xdata;  linear = 1;  m = nbottle;
[xi,u] = extracalc(Wlin,xdata);

% locate the end coordinates of the line described by the linear mode.
[xl(1,1),imax] = max(xi(1,:)); [xl(1,2),imin] = min(xi(1,:));
for i = 2:l; xl(i,1) = xi(i,imax); xl(i,2) = xi(i,imin); end;


% Generate nonlinear mode 1 -------------------------------------
% you could select the particular combination of m and penalty
% from m_store(im) and penalty_store(ip) by specifying im and ip 
% instead of using the default best option below 
im = im_best; ip = ipenalty_best; %<<<<<<<<<<
im
ip

m = m_store(im); penalty = penalty_store(ip);
fprintf(1,'\nPlot for  m =%3i,  penalty = %8.3g',m,penalty);

linear = 0;   W = W_store{ip,im};

[xi,u] = extracalc(W,xdata); % calculate u and xi from xdata and W

% plot the x variables  ------------------------------------------
set(0,'DefaultLineLineWidth',1.3)
figure;  % ignore first plot 
plot3(x(1,:),x(2,:),x(3,:),'.',xi(1,:),xi(2,:),xi(3,:),'square',...
xl(1,:),xl(2,:),xl(3,:),'--');
l1=get(gca,'XLim'); z1=max(l1); 
l2=get(gca,'YLim'); z2=max(l2);
l3=get(gca,'ZLim'); z3=min(l3);
zl1 = z1*ones(1,size(xl,2)); z1 = z1*ones(1,size(xi,2)); 
zl2 = z2*ones(1,size(xl,2)); z2 = z2*ones(1,size(xi,2)); 
zl3 = z3*ones(1,size(xl,2)); z3 = z3*ones(1,size(xi,2));
xlabel('x_{1}','FontSize',15)
ylabel('x_{2}','FontSize',15)
zlabel('x_{3}','FontSize',15)


figure; % 2nd plot is the desired plot
h = axes('GridLineStyle','--','FontSize',12);

plot3(xi(1,:),xi(2,:),xi(3,:),'ksquare',xl(1,:),xl(2,:),xl(3,:),'r--',...
xl(1,:),xl(2,:),zl3,'k-',x(1,:),x(2,:),z3,'b.',xi(1,:),xi(2,:),z3,'ro',...
xl(1,:),zl2,xl(3,:),'k-',x(1,:),z2,x(3,:),'b.',xi(1,:),z2,xi(3,:),'ro',...
zl1,xl(2,:),xl(3,:),'k-',z1,x(2,:),x(3,:),'b.',z1,xi(2,:),xi(3,:),'ro',...
'Markersize',5);

set(gca,'XLim',l1,'YLim',l2,'ZLim',l3,...
'XLimmode','manual','YLimmode','manual','ZLimmode','manual');

view([-32.5,40]); %<<<<< vary view angles for different 3D perspective

xlabel('x_{1}','FontSize',15)
ylabel('x_{2}','FontSize',15)
zlabel('x_{3}','FontSize',15)

box off; grid on;

%- print -deps pltmode1.eps  % save plot as black and white eps file
print -depsc pltmode1.eps  % save plot as colour eps file

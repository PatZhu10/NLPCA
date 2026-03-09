% Plot mode 1 from NLPCA program.
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
set(0,'DefaultAxesFontSize',12);
figure;
subplot(2,2,1);
plot(xl(1,:),xl(2,:),'k--',x(1,:),x(2,:),'b.',xi(1,:),xi(2,:),'ro','Markersize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(xl(1,:),xl(3,:),'k--',x(1,:),x(3,:),'b.',xi(1,:),xi(3,:),'ro','Markersize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(xl(2,:),xl(3,:),'k--',x(2,:),x(3,:),'b.',xi(2,:),xi(3,:),'ro','Markersize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(xl(1,:),xl(2,:),xl(3,:),'k--',xi(1,:),xi(2,:),xi(3,:),'ro','Markersize',4);

view([-32.5,40]); %<<<<< change view angles for different 3-D perspective


title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)
box off; grid on;

%- print -deps plmode1.eps  % save plot as black and white eps file
print -depsc plmode1.eps  % save plot as colour eps file

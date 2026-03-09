% Setup data1.mat for NLPCA test problem. The data contains 2
% theoretical modes (instead of only 1 as setup by setdat1.m) plus noise.
% Produces postscript files data1.eps for the x data

clear all;
n = 500 % generate 500 samples

rand('state',0); % intialize uniform random no. generator
randn('state',0); % intialize normal distr. random no. generator
x = zeros(3,n);
x1 = zeros(3,n);
x2 = zeros(3,n);
t = 2*rand(1,n)-1.; % random number converted to lie in the interval (-1,1)
s = 2*rand(1,n)-1.; % random number converted to lie in the interval (-1,1)
 
% mode 1 variables
x1(1,:) = t;
x1(2,:) = t;
x1(3,:) = t.^2; 

% generate mode 1 for plotting
mx1 = zeros(3,41);

tt = [-1:0.05:1];
mx1(1,:) = tt;
mx1(2,:) = tt;
mx1(3,:) = tt.^2;

% mode 2 variables
x2(1,:) =  -s;
x2(2,:) =  s;
x2(3,:) =  -s.^4;


% generate mode 2 for plotting
mx2 = zeros(3,41);

ss =[-1:0.05:1];
 
mx2(1,:) =  -ss;
mx2(2,:) =  ss;
mx2(3,:) = -ss.^4;


% add mode 1 and mode 2 contributions
x2 = 0.5*x2; % scale mode 2 to have only about 1/2 the amplitude of mode 1
mx2 = 0.5*mx2;
x = x1 + x2;

x = x+0.1*randn(3,n); % add about 10% Gaussian noise <<<<<<<<<<

% rename and save data onto a file data1.mat
xdata = x; tx = t;
save data1 xdata  tx s  mx1  mx2 ;

% plot x variables ------------------------------------------------
set(0,'DefaultLineLineWidth',1.5)
set(0,'DefaultAxesFontSize',9);
figure;
subplot(2,2,1);
plot(x(1,:),x(2,:),'k.',mx1(1,:),mx1(2,:),'bo',mx2(1,:),mx2(2,:),'r+',...
'MarkerSize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(x(1,:),x(3,:),'k.',mx1(1,:),mx1(3,:),'bo',mx2(1,:),mx2(3,:),'r+',...
'MarkerSize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(x(2,:),x(3,:),'k.',mx1(2,:),mx1(3,:),'bo',mx2(2,:),mx2(3,:),'r+',...
'MarkerSize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(mx1(1,:),mx1(2,:),mx1(3,:),'bo',mx2(1,:),mx2(2,:),mx2(3,:),'r+',...
'MarkerSize',4);
title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)

print -depsc data1.eps




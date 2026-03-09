% setup data1.mat for NLPCA test problem
% produces postscript files data1.eps for the x data
clear all;
n = 500 % generate 500 samples

rand('state',2); % intialize uniform random no. generator
randn('state',2); % intialize normal distr. random no. generator
x = zeros(3,n);
x1 = zeros(3,n);
t = 2*rand(1,n)-1.; % random number converted to lie in the interval (-1,1)

 
% mode 1 variables
x1(1,:) = t;
x1(2,:) = t.^2;
x1(3,:) = t.^3; 

% generate mode 1 for plotting
mx1 = zeros(3,41);

tt = [-1:0.05:1];
mx1(1,:) = tt;
mx1(2,:) = tt.^2;
mx1(3,:) = tt.^3;


x = x1 + 0.2*randn(3,n); % add about 20% Gaussian noise <<<<<<<<

% rename and save data onto a file data1.mat
xdata = x; tx = t;
save data1 xdata  tx  mx1  ;

% plot x variables ------------------------------------------------
set(0,'DefaultLineLineWidth',1.5)
set(0,'DefaultAxesFontSize',9);
figure;
subplot(2,2,1);
plot(x(1,:),x(2,:),'k.',mx1(1,:),mx1(2,:),'bo','MarkerSize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(x(1,:),x(3,:),'k.',mx1(1,:),mx1(3,:),'bo','MarkerSize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(x(2,:),x(3,:),'k.',mx1(2,:),mx1(3,:),'bo','MarkerSize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(mx1(1,:),mx1(2,:),mx1(3,:),'bo','MarkerSize',4);
title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)

print -depsc data1.eps




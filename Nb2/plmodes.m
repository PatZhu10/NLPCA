% Separate out and plot individual modes from the NLPCA solution.
% First plot (plmodes.eps) is the NLPCA solution with nbottle no. of 
% neurons, i.e. a hyper-surface of nbottle dimensions.
% Then 1-dimensional curves are extracted, and plotted as separate
% modes (i.e. plmode1.eps, plmode2.eps, ...), starting with the mode
% explaining the largest amount of variance.
%
% May need to set directory path to access the directory containing the
% extracalc.m program.
% <<<< indicates where the user may need to modify the code <<<< 
% if linear solution is also to be plotted (separately after the 
% nonlinear solution), set plot_linear = 1 (otherwise = 0).

clear all;
path('..',path); %<<<<< may need to set directory path <<<<

global  iprint Err_norm linear nensemble testfrac segmentlength ...
  overfit_tol info_crit xscaling penalty penalty_store maxiter initRand ...
  initwt_radius options  n l m nbottle iter Jscale xmean xstd ntrain ...
  xtrain utrain xitrain ntest xtest utest xitest Err Err1 inearest I H

load data1  %<<<< load data  <<<<<
load mode1  % <<<<< load NLPCA solution  <<<<<<<
plot_linear = 1; %<<<< linear solution is to be plotted afterwards <<<<

% you could select the particular combination of m and penalty
% from m_store(im) and penalty_store(ip) by specifying im and ip 
% instead of using the default best option below 
im = im_best; ip = ipenalty_best; %<<<<<<<<<<

m = m_store(im); penalty = penalty_store(ip);
fprintf(1,'\nPlot for  m =%3i,  penalty = %8.3g',m,penalty);

x = xdata;  W = W_store{ip,im};

[xi,u] = extracalc(W,xdata); % calculate u and xi from xdata and W

% plot the x variables  ------------------------------------------
set(0,'DefaultLineLineWidth',1.3)
set(0,'DefaultAxesFontSize',12);
figure;
subplot(2,2,1);
plot(x(1,:),x(2,:),'b.',xi(1,:),xi(2,:),'ro','Markersize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(x(1,:),x(3,:),'b.',xi(1,:),xi(3,:),'ro','Markersize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(x(2,:),x(3,:),'b.',xi(2,:),xi(3,:),'ro','Markersize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(xi(1,:),xi(2,:),xi(3,:),'ro','Markersize',4);

view([-32.5,40]); %<<<<< change view angles for different 3-D perspective


title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)
box off; grid on;

%- print -deps plmodes.eps  % save plot as black and white eps file
print -depsc plmodes.eps  % save plot as colour eps file

%----------------------------------------------------------------

% calculate the variance of the data
xdev = xdata' - ones(n,1)*mean(xdata'); xdev = xdev';
var_data = sum(diag(xdev*xdev'))/(n-1);

%==================================================================
% Separate the NLPCA solution into nbottle no. of modes
%==================================================================

MSE = zeros(1,nbottle);  MAE = zeros(1,nbottle); 
percent_var = zeros(1,nbottle);
xi_store = zeros(nbottle,size(xi,1),size(xi,2));

for nb = 1:nbottle %(((

% u_nb is u with all rows set to zero except for row nb.
u_nb = zeros(nbottle,n);
u_nb(nb,:) = u(nb,:);

% calculate xi corresponding to u_nb, ensure same mean as xdata
[xi_nb] = invmapx(u_nb,xdata,W);
xi_nb = xi_nb - (mean(xi_nb,2) + mean(xdata,2))*ones(1,n);
if xscaling >= 0; %((  rescale xi_nb to original dimension
[xi_nb] = dimen(xi_nb',xmean,xstd,xscaling)';
end %))

xi_store(nb,:,:) = xi_nb;

% calculate error and variance explained (%) by u_nb only
MSE(nb) = sum(diag((xi_nb-xdata)*(xi_nb-xdata)'))/n;
percent_var(nb) = 100*(1- n/(n-1)*MSE(nb)/var_data);
MAE(nb) = sum(sum(abs(xi_nb-xdata)))/n;
end %)))

% sort the modes into ascending order of MSE or MAE

if Err_norm == 1; Err_nb = MAE; else; Err_nb = MSE; end;
[Err_nb_sort, isort] = sort(Err_nb);

fprintf(1,'\n\nbottleneck neuron no.   %% var. explained    MSE      MAE\n')

for nb = 1:nbottle %(((
fprintf(1,'          %3.0f,          %9.4g     %10.5g %10.5g\n',...
isort(nb), percent_var(isort(nb)), MSE(isort(nb)), MAE(isort(nb)));
end; %)))

%====================================================================
% plot each mode separately, with largest variance mode first, etc.

for nb = 1:nbottle; %[[[[

xi_nb(:,:) = xi_store(isort(nb),:,:);

figure; 
subplot(2,2,1);
plot(x(1,:),x(2,:),'b.',xi_nb(1,:),xi_nb(2,:),'ro','Markersize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(x(1,:),x(3,:),'b.',xi_nb(1,:),xi_nb(3,:),'ro','Markersize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(x(2,:),x(3,:),'b.',xi_nb(2,:),xi_nb(3,:),'ro','Markersize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(xi_nb(1,:),xi_nb(2,:),xi_nb(3,:),'ro','Markersize',4);

view([-32.5,40]); %<<<<< change view angles for different 3-D perspective


title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)
box off; grid on; hold off;

filename = ['plmode' num2str(nb)]; %<<<< give filename of plotfile
print('-depsc',filename) % save plot as colour eps file

end; %]]]]

%=================================================================
% plot linear solution separately if desired

if plot_linear == 1; %[[[[

fprintf(1,'\n\n Linear solution:')
linear = 1;
m = nbottle;

x = xdata;  W = Wlin;

[xi,u] = extracalc(W,xdata); % calculate u and xi from xdata and W


% plot the x variables  ------------------------------------------
set(0,'DefaultLineLineWidth',1.3)
set(0,'DefaultAxesFontSize',12);
figure;
subplot(2,2,1);
plot(x(1,:),x(2,:),'b.',xi(1,:),xi(2,:),'ro','Markersize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(x(1,:),x(3,:),'b.',xi(1,:),xi(3,:),'ro','Markersize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(x(2,:),x(3,:),'b.',xi(2,:),xi(3,:),'ro','Markersize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(xi(1,:),xi(2,:),xi(3,:),'ro','Markersize',4);

view([-32.5,40]); %<<<<< change view angles for different 3-D perspective


title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)
box off; grid on;

%- print -deps pllinmodes.eps  % save plot as black and white eps file
print -depsc pllinmodes.eps  % save plot as colour eps file

%----------------------------------------------------------------

% calculate the variance of the data
xdev = xdata' - ones(n,1)*mean(xdata'); xdev = xdev';
var_data = sum(diag(xdev*xdev'))/(n-1);

%==================================================================
% Separate the linear solution into nbottle no. of modes
%==================================================================

MSE = zeros(1,nbottle);  MAE = zeros(1,nbottle); 
percent_var = zeros(1,nbottle);
xi_store = zeros(nbottle,size(xi,1),size(xi,2));

for nb = 1:nbottle %(((

% u_nb is u with all rows set to zero except for row nb.
u_nb = zeros(nbottle,n);
u_nb(nb,:) = u(nb,:);

% calculate xi corresponding to u_nb, ensure same mean as xdata
[xi_nb] = invmapx(u_nb,xdata,W);
xi_nb = xi_nb - (mean(xi_nb,2) + mean(xdata,2))*ones(1,n);
if xscaling >= 0; %((  rescale xi_nb to original dimension
[xi_nb] = dimen(xi_nb',xmean,xstd,xscaling)';
end %))

xi_store(nb,:,:) = xi_nb;

% calculate error and variance explained (%) by u_nb only
MSE(nb) = sum(diag((xi_nb-xdata)*(xi_nb-xdata)'))/n;
percent_var(nb) = 100*(1- n/(n-1)*MSE(nb)/var_data);
MAE(nb) = sum(sum(abs(xi_nb-xdata)))/n;
end %)))

% sort the modes into ascending order of MSE or MAE

if Err_norm == 1; Err_nb = MAE; else; Err_nb = MSE; end;
[Err_nb_sort, isort] = sort(Err_nb);

fprintf(1,'\n\nbottleneck neuron no.   %% var. explained    MSE      MAE\n')

for nb = 1:nbottle %(((
fprintf(1,'          %3.0f,          %9.4g     %10.5g %10.5g\n',...
isort(nb), percent_var(isort(nb)), MSE(isort(nb)), MAE(isort(nb)));
end; %)))

%====================================================================
% plot each mode separately, with largest variance mode first, etc.

for nb = 1:nbottle; %[[[[

xi_nb(:,:) = xi_store(isort(nb),:,:);

figure; 
subplot(2,2,1);
plot(x(1,:),x(2,:),'b.',xi_nb(1,:),xi_nb(2,:),'ro','Markersize',4);
title('(a)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)

subplot(2,2,2);
plot(x(1,:),x(3,:),'b.',xi_nb(1,:),xi_nb(3,:),'ro','Markersize',4);
title('(b)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,3);
plot(x(2,:),x(3,:),'b.',xi_nb(2,:),xi_nb(3,:),'ro','Markersize',4);
title('(c)','FontSize',13)
xlabel('x_{2}','FontSize',12)
ylabel('x_{3}','FontSize',12)

subplot(2,2,4);
plot3(xi_nb(1,:),xi_nb(2,:),xi_nb(3,:),'ro','Markersize',4);

view([-32.5,40]); %<<<<< change view angles for different 3-D perspective


title('(d)','FontSize',13)
xlabel('x_{1}','FontSize',12)
ylabel('x_{2}','FontSize',12)
zlabel('x_{3}','FontSize',12)
box off; grid on; hold off;

filename = ['pllinmode' num2str(nb)]; %<<<< give filename of plotfile
print('-depsc',filename) % save plot as colour eps file

end; %]]]]
end; %]]]]]

function [n,xtrain,ntrain,xtest,ntest,testsetindex] = ...
                          chooseTestSet(xdata,testfrac,segmentlength,iprint);
% function [n,xtrain,ntrain,xtest,ntest,testsetindex] = ...
%                         chooseTestSet(xdata,testfrac,segmentlength,iprint);
% From the original data xdata, randomly choose testfrac
% fraction as test data xtest, and the remainder as training
% data xtrain. testsetindex = 0 if the original sample is selected to be
% in the training set, and 1 if in the test set.
% If segmentlength is set to integer values greater than 1, then
% the test data will be selected in segments of length 'segmentlength',
% to account for the autocorrelation in the data.
% Set segmentlength = 1 if autocorrelation is not a problem.

%-initRand = 1; % choose positive integer to initialize random no. generator
%-rand('state', initRand); % initialize random number generator
[mx,n] = size(xdata);  % n is the number of samples
nx = n;
segment = round(segmentlength);
nsegments = floor(n/segment); 
testsegmentindex = zeros(1,nsegments);
testsetindex = zeros(1,n);
ntestselected = 0;
ntest = round(n*testfrac/segment)*segment;

% Select test data
while ntestselected < ntest; %[[[[[
location = round(1+(nsegments-1)*rand);
if testsegmentindex(1,location) ~=1,  %(((( 
 testsegmentindex(1,location) = 1;
 testsetindex(1,(location-1)*segment+1:location*segment) = 1;
 ntestselected = ntestselected + segment;
end %))))
end %]]]]]

ntrain = n - ntest;
xtest = zeros(mx,ntest);
xtrain = zeros(mx,ntrain);

itest=1;
itrain=1;
for i=1:n %[[[[[[
if testsetindex(1,i) == 1
xtest(:,itest) = xdata(:,i);
itest = itest + 1;
else
xtrain(:,itrain) = xdata(:,i);
itrain = itrain + 1;
end
end %]]]]]]

if iprint > 0;
fprintf(1,'\nn =%6.0f,  ntrain =%6.0f,  ntest = %6.0f,  testfrac =%6.3f\n',...
  n,ntrain,ntest,testfrac);
end;

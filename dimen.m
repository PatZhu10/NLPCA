function [x] = dimen(xnondimen,xmean,xstd,index)
% function [x] = dimen(xnondimen,xmean,xstd,index)
% After using
% function [xnondimen,xmean,xstd] = nondimen(x,index)
% to standardize a variable x (column vector), (or a matrix of column vectors),
% by removing the mean (xmean) and dividing by the standard deviation (xstd),
% to yield the nondimen. variables (xnondimen);
% to get back the dimensional variables, use
% function [x] = dimen(xnondimen,xmean,xstd,index).
%
% If the optional argument `index' is supplied, dimensionalization is
% performed using the mean & std of the `index' column.
% (If index <=0, same as if the argument was not supplied).
%
% type: help nondimen  to get instructions on nondimen.m, & on the case
%  with row vectors.
one = ones(size(xnondimen,1),1);
if (nargin==4); %((( see if the optional argument `index' is supplied
 if index >0; %((
 x = xstd(index)*xnondimen + one*xmean; 
 else
 x = (one*xstd).*xnondimen + one*xmean;
 end; %))
else
x = (one*xstd).*xnondimen + one*xmean;
end; %)))

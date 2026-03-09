function [xnondimen,xmean,xstd] = nondimen(x,index,xmean0,xstd0)
% function [xnondimen,xmean,xstd] = nondimen(x,index,xmean0,xstd0)
% standardize a variable x (column vector), (or a matrix of column vectors),
% by removing the mean (xmean) and dividing by the standard deviation (xstd),
% to yield the nondimen. variables (xnondimen).
%
% If the optional argument `index' is supplied, nondimensionalization is
% performed using the std of the `index' column.
% (If index <= 0, same as if the argument was not supplied).
% If optional arguments xmean0 and xstd0 are supplied, the program
% nondimensionalizes using xmean0 and xstd0 instead of xmean and xstd. 
%
% To get back the dimensional variables, use
% function [x] = dimen(xnondimen,xmean,xstd,index)
%
% For row vector x: use [xnondimen,xmean,xstd] = nondimen(x',index),
% then: xnondimen = xnondimen';
% to get back the dimensional variables, use:
% function [x] = dimen(xnondimen',xmean,xstd,index)'


one = ones(size(x,1),1);
xmean = mean(x);
xstd = max(std(x), 1.e-29);

if(nargin ~= 4); %(((( 
 if (nargin>=2); %((( see if the optional argument `index' is supplied
  if(index > 0); %((
  xnondimen = (x-one*xmean)/xstd(index); 
  else
  xnondimen = (x-one*xmean)./(one*xstd);
  end; %))
 else
 xnondimen = (x-one*xmean)./(one*xstd);
 end %)))
else   %---- use xmean0 and xstd0 instead of xmean and xstd:
 if (nargin>=2); %((( see if the optional argument `index' is supplied
  if(index > 0); %((
  xnondimen = (x-one*xmean0)/xstd0(index); 
  else
  xnondimen = (x-one*xmean0)./(one*xstd0);
  end; %))
 else
 xnondimen = (x-one*xmean0)./(one*xstd0);
 end %)))
end %))))

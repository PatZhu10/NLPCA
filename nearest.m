function [inearest] = nearest(xdata)
% function [inearest] = nearest(xdata)
% Given xdata, this function looks at each sample point and finds its
% nearest neighbour in the dataset, and stores the sample index in 
% inearest.
n = size(xdata,2); % number of samples
for i = 1:n %[[[[
minDistance2=1e99;
 for j = 1:n %[[[
   if i ~= j; %(((
    distance2 = (xdata(:,i) - xdata(:,j))'*(xdata(:,i) - xdata(:,j));
    if distance2 < minDistance2; %((
      minDistance2 = distance2;  inearest(i) = j;
    end; %))
   end; %)))
  end; %]]]
end; %]]]]
 

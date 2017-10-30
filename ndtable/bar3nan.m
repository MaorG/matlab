function [ h ] = bar3nanColor( z, c )


h = bar3(z);
for i = 1:numel(h)
  index = logical(kron(-Inf ==(z(:,i)),ones(6,1)));
  zData = get(h(i),'ZData');
  zData(index,:) = nan;
  set(h(i),'ZData',zData);
end

end
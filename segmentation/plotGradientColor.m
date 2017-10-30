function [ h ] = plotGradientColor( X, Y, C )

for i = 1:size(X,1)
x = X(i,:);
y = Y(i,:);
z = zeros(size(x));
col = C(i,:);  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
%colorbar

end
end
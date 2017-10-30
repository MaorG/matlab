function [result] = getLinearRegression (input, varargin)

vname = varargin{1}{1};

V = input.(vname);

x = V(1,:);
y = V(2,:);

result = polyfit(x,y,1);



end

function [result] = getRelativeMixArea (input, varargin)

world = input.world;

[h, w] = size(world);

r = varargin{1}{1};
se = strel('disk',r);        

I = zeros(size(world));

I1 = world == 1;
I2 = world == 2;

I1d = imdilate(I1,se);
I2d = imdilate(I2,se);

It = I1d & I2d;
Ir = I1d | I2d;

result = sum(sum(It)) / sum(sum(Ir));

end
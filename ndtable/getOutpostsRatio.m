function [result] = getOutpostsRatio (input, varargin)

world = input.world;

[h, w] = size(world);

r = varargin{1}{1};
se = strel('disk',r);        

I = zeros(size(world));

% populations
I1 = world == 1;
I2 = world == 2;

% dilated populations - teritory
I1d = imdilate(I1,se);
I2d = imdilate(I2,se);

% mixing area
Im = I1d & I2d;

% segregated area
Is = I1d | I2d & (Im == 0);

% individuals in mixing area
Imd = Im & (world ~= 0);

% concentration in mixing area
cm = sum(sum(Imd)) / sum(sum(Im));

% individuals in segregated area
Isd = Is & (world ~= 0);

% concentration in segregated area
cs = sum(sum(Isd)) / sum(sum(Is));

result = cm / (cs + cm);

%result = cm/cs;
% mixing hot spots
%Iind = imerode(Ir,se);

%It = Iind & (world ~= 0);

% figure;
% 
% subplot(1,4,1);
% print_world(world);
% subplot(1,4,2);
% imshow(Ir);
% subplot(1,4,3);
% imshow(Iind);
% subplot(1,4,4);
% imshow(It)
% 


end
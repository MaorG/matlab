function [] = show_zones (data, varargin)

world = data.world;

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

% pure area
I1p = I1d & (I2d == 0);
I2p = I2d & (I1d == 0);

IpMask = zeros(w,h,3);
IpMask(:,:,1) = I1p;
IpMask(:,:,3) = I2p;

% mixing area
Im = I1d & I2d;

% segregated area
Is = I1p | I2p;

ImMask = zeros(w,h,3);
ImMask(:,:,1) = Im;
ImMask(:,:,2) = Im;

% individuals in mixing area

Imd = Im;%imerode(Im,se);
Imd2 = imerode(Im,se);
% Imd2 = Imd & (world ~= 0);

ImdMask = zeros(w,h,3);
ImdMask(:,:,1) = Imd + Imd2;
ImdMask(:,:,2) = Imd + Imd2;
ImdMask(:,:,3) = Imd + Imd2;


CMap = [
    0, 0, 0;
    1, 0.2, 0.2;
    0.2, 0.2, 1];
colorMat  = ind2rgb(world + 1, CMap);

%I = imfuse(colorMat, IpMask);
I = 0.5 * colorMat + 0.25 * IpMask + 0.25 * ImMask + 0.25 * ImdMask;
imshow(I);


% individuals in segregated area
%Isd = Is & (world ~= 0);

%I1pMask = zeros(h,w,3);
%I1pMask(1,:,:) = I1p;
%I2pMask = zeros(h,w,3);
%I2pMask(:,:,1) = I2p;


% concentration in mixing area
%cm = sum(sum(Imd)) / sum(sum(Im));



% concentration in segregated area
%cs = sum(sum(Isd)) / sum(sum(Is));

end

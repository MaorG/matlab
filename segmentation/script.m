for ii = 1:numel(allData)
   counts = cat(1, allData(ii).Seg.clusters.count);
   [maxCount, maxIdx] = max(counts);
   cim = allData(ii).Seg.clusters(maxIdx).Image;
   figure
   imshow(cim);
   title([allData(ii).dirName, allData(ii).fileName, '  -- count: ', num2str(maxCount)]);
end



fileName = 'C:\school\microscopy\seg_exp\exp2.tif';


I = imread(fileName);
imagesc(I);

I = double(I);

lap = [...
    -9, -9, -9, -9, -9 ; ...
    -9, 16, 16, 16, -9 ; ...
    -9, 16, 16, 16, -9 ; ...
    -9, 16, 16, 16, -9 ; ...
    -9, -9, -9, -9, -9 ; ...
    ];
    
I1 = conv2(I, lap, 'same');

nI = I - min(I(:));
nI = nI ./ max(nI(:));

nI1 = I1 - min(I1(:));
nI1 = nI1 ./ max(nI1(:));

bw = edge(I);
BW = nI1 > 0.25;

CC = bwconncomp(BW);
rp = regionprops(CC, 'Centroid', 'PixelIdxList', 'Area');
areas = cat(1, rp.Area);
ids = find(areas > 10 & areas < 1000);

BW1 = false(size(BW));

for id = ids'
    BW1(CC.PixelIdxList{id}) = 1;
end

SE1 = strel('disk', 1)
BW2 = imerode(BW1, SE1);
SE4 = strel('disk', 4)
BWgroup = imdilate(BW1, SE4);

figure
imshow(cat(3,double(BW1),double(BW2),double(BWgroup)));


S = Segmentation
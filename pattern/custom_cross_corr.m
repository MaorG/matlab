function result = custom_cross_corr(rfpName, gfpName, outputDirName, envelopeIters)

BWrfp = imread(rfpName);
se = strel('disk',2);
BWrfpO = imclose(BWrfp,se);
BWgfp = imread(gfpName);

%BWgfp = BWgfp & (~BWrfpO);


% BWrfp = BWrfp(1000:4000, 1000:4000);
% BWgfp = BWgfp(1000:4000, 1000:4000);

Lgfp = logical(BWgfp);
CCgfp = bwconncomp(Lgfp);
Sgfp = regionprops(Lgfp, 'Area', 'Centroid', 'PixelIdxList');
area_values_gfp = [Sgfp.Area];
centroids = cat(1, Sgfp.Centroid);
pixels = cat(1, Sgfp.PixelIdxList);
idx = find(10 <= area_values_gfp);
BWgfp2 = ismember(labelmatrix(CCgfp), idx);  

Lrfp = logical(BWrfp);
CCrfp = bwconncomp(Lrfp);
Srfp = regionprops(Lrfp, 'Area', 'Centroid', 'PixelIdxList');
area_values_rfp = [Srfp.Area];
pixels = cat(1, Srfp.PixelIdxList);
idx2 = find(10 <= area_values_rfp);
BWrfp2 = ismember(labelmatrix(CCrfp), idx2);  
CCrfp2 = bwconncomp(BWrfp2);
Srfp2 = regionprops(CCrfp2, 'Area', 'Centroid', 'PixelList');



figure
imshow(BWrfp2)
hold on
plot(centroids(idx,1),centroids(idx,2), 'g*')
hold off


Prfp = cat(1, Srfp2.PixelList);
Pgfp = [centroids(idx,1),centroids(idx,2)];

dr = 10;
maxR = 250;
blksize = 1000;

    x2 = Prfp(:,1);
    y2 = Prfp(:,2);

figure
hold on

allcorrfun = 0 * (dr:dr:maxR);
for i = 1:envelopeIters
    i
    xmax = size(BWgfp,1);
    ymax = size(BWgfp,2);
    count = numel(idx);
    x1 = rand(count,1)*xmax;
    y1 = rand(count,1)*ymax;
    [ corrfun r rw] = twopointcrosscorr( x1,y1,x2,y2,dr,maxR,blksize,false);
    
    
    corrfun = padarray(corrfun,[0, numel(dr:dr:maxR)-numel(corrfun)],0,'post');
    
    
    allcorrfun = cat(1, allcorrfun, corrfun);
    
end

    sortedallcorrfun = sort(allcorrfun,1);


x1 = Pgfp(:,1);
y1 = Pgfp(:,2);
x2 = Prfp(:,1);
y2 = Prfp(:,2);






[ corrfun r rw] = twopointcrosscorr( x1,y1,x2,y2,dr,maxR,blksize,false)

corrfun = padarray(corrfun,[0, numel(dr:dr:maxR)-numel(corrfun)],0,'post');

% sortedallcorrfun = ttt2.allcorr;
% corrfun = ttt2.corr;
pixelSize = 5*0.333
x = pixelSize:pixelSize:numel(dr:dr:maxR)*pixelSize;
figure
hold on


result = struct;
result.gfp = BWgfp;
result.rfp = BWrfp;
result.gfpName = gfpName;
result.rfpName = rfpName;
result.corrfun = corrfun;
result.allcorrfun = allcorrfun;
result.sortedallcorrfun = sortedallcorrfun;
result.x = x;

if envelopeIters > 1
    bottomEnvIdx = max(1, floor(envelopeIters / 20));
    topEnvIdx = min(envelopeIters, 1+ ceil((19/20)*envelopeIters));

    plot(result.x,result.sortedallcorrfun(bottomEnvIdx,:), '-g');
    plot(result.x,result.sortedallcorrfun(topEnvIdx,:), '-g');
end
plot(result.x,result.corrfun, '-r');
hold off
ylim([0,2.5])

save([outputDirName, 'result.mat'], 'result');
end
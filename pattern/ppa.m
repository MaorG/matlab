rfpName = 'C:\Imaging\putida 19.03.2017\a1\rfp_big.tif';
gfpName = 'C:\Imaging\putida 19.03.2017\a1\gfp_big.tif';

rfpName = 'C:\school\microscopy\exp170405\dual\AFTER_SEG\Export_RFP.tif';
gfpName = 'C:\school\microscopy\exp170405\dual\AFTER_SEG\export_gfp.tif';

rfpName = 'C:\school\microscopy\24.4.17\dist\c1\rfp_t10_t00.tif';
gfpName = 'C:\school\microscopy\24.4.17\dist\c1\gfp_t10_t00.tif';


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
maxR = 200;
blksize = 1000;

    x2 = Prfp(:,1);
    y2 = Prfp(:,2);

figure
hold on

allcorrfun = 0 * (dr:dr:maxR);
for i = 1:100
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
pixelSize = 0.325
x = (dr:dr:maxR)*pixelSize;
figure
hold on
plot(x,sortedallcorrfun(5,:), '-g');
plot(x,sortedallcorrfun(end-4,:), '-g');
plot(x,corrfun, '-r');
hold off
ylim([0,2.5])



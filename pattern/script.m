rfpName = 'C:\Imaging\putida 19.03.2017\a1\rfp_big.tif';
gfpName = 'C:\Imaging\putida 19.03.2017\a1\gfp_big.tif';

rfpName = 'C:\school\microscopy\exp170405\dual\AFTER_SEG\export_rfp.tif';
gfpName = 'C:\school\microscopy\exp170405\dual\AFTER_SEG\export_gfp.tif';

rfpName = 'C:\school\microscopy\24.4.17\dist\c1\rfp_t10_t00.tif';
gfpName = 'C:\school\microscopy\24.4.17\dist\c1\gfp_t10_t00.tif';

BWrfp = imread(rfpName);
se = strel('disk',2);
BWrfpO = imclose(BWrfp,se);
BWgfp = imread(gfpName);

%BWgfp = BWgfp & (~BWrfpO);



% BWrfp = BWrfp(1000:2000, 1000:2000);
% BWgfp = BWgfp(1000:2000, 1000:2000);

% display
% Lgfp = logical(BWgfp);
% CCgfp = bwconncomp(Lgfp);
% Sgfp = regionprops(Lgfp, 'Area', 'Centroid', 'PixelIdxList');
% area_values_gfp = [Sgfp.Area];
% centroids = cat(1, Sgfp.Centroid);
% idx = find(10 <= area_values_gfp);
% figure
% imshow(BWrfp)
% hold on
% 
% rrr = 80 * ones(numel(centroids(:,1)),1);
% 
% arr = cat(2, centroids, rrr)
% 
% RGB = insertShape(BWrfp,'circle',arr,'LineWidth',1);
% 
% hold off


radii = [40];
results = [];
result = struct;
for ri = 1:numel(radii)
    
    radius = radii(ri)
    realDist = analyzeNgh(BWrfp,BWgfp,radius,false);
    randDist = [];
    for i = 1:100
        random = analyzeNgh(BWrfp,BWgfp,radius,true);
        randDist = [randDist, random];
    end
    
    result.radius = radius;
    result.real = realDist;
    result.rand = randDist;
    
    results = [results; result];
end

for i = 1:numel(results)
    bins = 0:0.1:1;
    
    realDist = histcounts(results(i).real, bins);
    realDist = realDist ./ sum(realDist);
    randDist = [];
    for j = 1:size(results(i).rand, 2) 
        temp = histcounts(results(i).rand(:,j), bins);
        temp = temp ./ sum (temp);
        randDist = [randDist; temp];
    end
    
    sortedrand = sort(randDist,1);
    
    figure
    title(num2str(results(i).radius));
    hold on
    plot(bins(1:end-1), (realDist), 'r');
    plot(bins(1:end-1), (sortedrand(5,:)), 'g--');
    plot(bins(1:end-1), (sortedrand(end-4,:)), 'g--');
    ylim([0,0.1]);
end
    
    
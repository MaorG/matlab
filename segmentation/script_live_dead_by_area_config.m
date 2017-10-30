function allData = script_live_dead_by_area_config(configName)

addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable');

% function allData = getAllData(dirName)

allData = config2data(configName);

imageRect = [];

if (~isempty(imageRect))
    for i = 1:numel(allData)
        allData(i).I = (allData(i).I(imageRect(1):imageRect(2),imageRect(3):imageRect(4)));
    end
else
    for i = 1:numel(allData)
        allData(i).I = (allData(i).I);
    end  
end

allData = getLiveDeadChannels(allData, [0.5,0.5]);

allData = scoreAllData(allData, 'clusters', @getClustersFromBitmap,...);
        'minClusterArea', 10,...
        'clusterDilation', 4,...
        'threshold', 5000,...
        'nameI', 'I');

for i = 1:numel(allData)
    
    allData(i).cc = getLiveDeadInClustersByArea( allData(i), {'liveDeadIntensityCoeff', [1.0,0.75], 'verbose', '0'});
    
end
    
%doStuff(allData);

end
% R = allData(1).SegDead.BWcells;
% G = allData(1).SegLive.BWcells;
% B = allData(1).Seg.BWcells;
% imshow(double(cat(3,R,G,B)))
% 
% R = allData(2).SegDead.BWcells;
% G = allData(2).SegLive.BWcells;
% B = allData(2).Seg.BWcells;
% imshow(double(cat(3,R,G,B)))
% 
% figure
% imshow(cat(3, allData(1).deadI, allData(1).liveI, zeros(size(allData(1).deadI))));
% figure
% imshow(cat(3, allData(2).deadI, allData(2).liveI, zeros(size(allData(2).deadI))));
% 

function x()
figure
R = allData(ii).deadI;
R = double(R) ./ 65500;
G = allData(ii).liveI;
G = double(G) ./ 65500;
B = zeros(size(R));

imshow(cat(3, R, G ,B));

end

function doStuff(allData, ii)

d = allData(ii);
%cc = getLiveDeadInClustersByArea(d, {'liveDeadIntensityCoeff', [1.0,0.75]})
cc = allData(ii).cc;
figure
scatter(cc.areas, cc.liveRatio)

hold on

bins = power(2,2:14);
[N,edges,bin] = histcounts(cc.areas,bins);
averageRatioOfBin = zeros(size(N));
for i = 1:numel(N)
    val = i;
    binRatios = cc.liveRatio(find(bin == i));
    averageRatioOfBin(i) = mean(binRatios);
    
    SErrOfBin(i) = std(binRatios) ./ sqrt(numel(binRatios));
    
end


top = averageRatioOfBin;
top(isnan(top)) = 0;
bot = zeros(size(top));
left = bins(1:end-1);
right = bins(2:end);
height = top - bot;
width = right - left;


for ii=1:length(top)
    rectangle('Position',[left(ii) bot(ii) width(ii)   height(ii) ])
    line([left(ii) + right(ii),left(ii) + right(ii)]*0.5, [height(ii) + SErrOfBin(ii), height(ii) - SErrOfBin(ii)],'Color','black');
end

% fitobject = fit(cc.areas, cc.liveRatio, 'smoothingspline','SmoothingParam',0.00000000000001);
% hold on
% plot(fitobject)

xlim([min(bins), max(bins)]);

xlabel('aggregate size - #(pixels)')
ylabel('ratio of living *pixels*')

end


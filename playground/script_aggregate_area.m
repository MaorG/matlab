%% area distribution

init

%%

configName = 'C:\school\microscopy\27.11.17\configAll.txt';
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

allData = scoreAllData(allData, 'clusters', @getClustersFromBitmap,...);
    'minClusterArea', 10,...
    'clusterDilation', 4,...
    'threshold', 500,...
    'nameI', 'I');

%% substract background

allData = scoreAllData(allData, 'BG', @getBGMorph,...);
    'radius', 100,...
    'nameI', 'I');


for i = 1:numel(allData)
    allData(i).I2 = allData(i).I - allData(i).BG;
    
end

allData = scoreAllData(allData, 'clusters2', @getClustersFromBitmap,...);
    'minClusterArea', 10,...
    'clusterDilation', 0,...
    'threshold',400,...
    'nameI', 'I2');



%%
allData = scoreAllData(allData, 'areaHist', @getClusterPropHistogram, 'bins', power(2,[0:20]), 'propName', 'areas', 'clustersName', 'clusters2');

pNames = {'time', 'well', 'channel'};
rt1 = createNDResultTable(allData, 'areaHist', pNames);
myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log')
ylog = @(h) set(h,'yscale','log')
ylimit = @(h) ylim([0,10000]);
xlimit = @(h) xlim([1,2^21]);
tableUI(rt1,myplot, [{ylog},{xlog}, {ylimit}, {xlimit}]);

%%

for idx = 153:1:156
    figure
    
    BW = allData(idx).I2 > 400;
    
    CC = bwconncomp(BW);
    rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
    areas = cat(1, rp.Area);
    L = labelmatrix(CC);
    
    sI2 = size(allData(idx).I2);
    
    II = zeros(sI2);
    for ii = 1:numel(L(:))
        if (L(ii) ~= 0)
            II(ii) = log2(areas(L(ii)));
        end
    end
    
    imagesc(II)
    caxis([0,20]);
end


%% aggregatograms

sA4 = getDataByParams(allData, 'well', 'A4');

sA4 = get_cluster_evolution(sA4, {'clustersName', 'clusters2', 'minArea', 1000});

mmm = getSimpleClustersIndices(sA4);

%%
firsts = [10];


for first = firsts
    m1 = [];
    for i = 1:size(mmm,2)
        mc = mmm(:,i);

        if (sum(~isnan(mc)) > 0) && (all(isnan(mc(1:first-1)))) && (~isnan(mc(first)))
            %            mc(19 : end) = nan;
            mc
            m1 = cat(2,m1,mc);
        end
    end
   
    getSimpleClusterGrowthOverTime(sA4,m1,[1,0,0]);
end


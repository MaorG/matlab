function AvCvD = getAttachVsCountVsDist2(data, varargin)

%params = parseInput(varargin);

nVarargs = length(varargin{1});
if (nVarargs == 4) 
    RclustersName = varargin{1}{1};
    GclustersName = varargin{1}{2};
    countBins = varargin{1}{3};
    distBins = varargin{1}{4};
    accumDist = false;
end

if (nVarargs == 5) 
    RclustersName = varargin{1}{1};
    GclustersName = varargin{1}{2};
    countBins = varargin{1}{3};
    distBins = varargin{1}{4};
    accumDist = varargin{1}{5};
end

imageSize = size(data.I);


Rclusters = data.(RclustersName);
Gclusters = data.(GclustersName);
%countBins = [countBins, inf];
% note - cumulative (i.e. up to dist or in range) ?

% create bitmap for each cluster count bin

countDistHist = [];

relativeCountDistHist = [];
expectedCountsDistHist = [];
topConfCountsDistHist = [];
botConfCountsDistHist = [];
topConfCountsDistHistAnalytic = [];
botConfCountsDistHistAnalytic = [];

verbose = false;
if (numel(countBins) == 2) && (numel(distBins) == 2)
    verbose = true;
    figure;
end



for countIdx = 1:(numel(countBins) - 1)

    minCount = countBins(countIdx);
    maxCount = countBins(countIdx + 1);
    
    blank = false((imageSize)); 
    
    
    clustersIdxInBin = find(Rclusters.count >= minCount & Rclusters.count < maxCount);
    
    for cIdx = clustersIdxInBin'
        pixels = Rclusters.pixels{cIdx};
        px = pixels(:,1);
        py = pixels(:,2);
        
        ind = sub2ind(imageSize, py, px);
        blank(ind) = 1;
        
    end
    
    % create dist map

    clusterDilation = 26;
    se = strel('disk',clusterDilation);
    blank2 = imdilate(blank, se);
    distMap = bwdist(blank2);
    
    %distMap(distMap == 0) = nan;
    

    % (compare to rand or normalize by total aera of bin of distances? or both, for error margin around 1?)
    
    % get values of points on dist map
    dists = [];
    for pIdx = 1:numel(Gclusters.pixels)
        center = Gclusters.centers(pIdx,:);
        cx = round(center(1));
        cx = min(max(1,cx),imageSize(1));
        cy = round(center(2));
        cy = min(max(1,cy),imageSize(2));
        dists = [dists, distMap(cy,cx)]; 
    end
    % hist by dist bins - counting attachments
    distHist = histcounts(dists,distBins);
    if (accumDist)
        distHist = cumsum(distHist);
    end
    
    
    
    % hist by dist bins - # of attachments relative to random, i.e. total
    % area of the diatance
    totalAreaAtDist = histcounts(distMap(:), distBins) ./ sum(~isnan(distMap(:)));

    
%     viablePixels = find(~(data.dpI));
%     totalAreaAtDist = histcounts(distMap(viablePixels), distBins)./sum(~(data.dpI(:)));

    totalAreaAtDist = histcounts(distMap(:), distBins)./(size(distMap,1)*size(distMap,2));
    if (accumDist)
        totalAreaAtDist = cumsum(totalAreaAtDist);
    end
    
    expectedAttachmentsAtDist = (numel(Gclusters.pixels)) * totalAreaAtDist;
    expectedCountsDistHist = [expectedCountsDistHist; expectedAttachmentsAtDist];
    


    
    topConfDistHistAnalytic = totalAreaAtDist + sqrt(totalAreaAtDist ./ (numel(Gclusters.pixels)));
    botConfDistHistAnalytic = totalAreaAtDist - sqrt(totalAreaAtDist ./ (numel(Gclusters.pixels)));

    topConfCountsDistHistAnalytic = [topConfCountsDistHistAnalytic; topConfDistHistAnalytic];
    botConfCountsDistHistAnalytic = [botConfCountsDistHistAnalytic; botConfDistHistAnalytic];
    
    relDistHist = distHist ./ expectedAttachmentsAtDist;
    
    % store dist hist
    
    countDistHist = [countDistHist ; distHist];
    relativeCountDistHist = [relativeCountDistHist; relDistHist];
    
    
    
    % random repetitions 
    allRndDistHist = [];
    
    % get list of viable pixels
    %viablePixels = find(~(data.dpI));
    viablePixels = ones(size(distMap));
    for repeat = 1:1000
        randomIdx = randi([1,numel(viablePixels)],numel(Gclusters.areas), 1);
        %randomPixels = viablePixels(randomIdx);
        
        rndDists = distMap(randomIdx);
                
        rndDistHist = histcounts(rndDists,distBins);
        if (accumDist)
            rndDistHist = cumsum(rndDistHist);
        end
        allRndDistHist = [allRndDistHist ; rndDistHist];
    end
    sortedRndDistHist = sort(allRndDistHist,1);
    topConfDistHist = sortedRndDistHist(951,:);
    botConfDistHist = sortedRndDistHist(50,:);
    
    topConfCountsDistHist = [topConfCountsDistHist ; topConfDistHist];
    botConfCountsDistHist = [botConfCountsDistHist ; botConfDistHist];
    
    if verbose
        R = 0.8 * data.SegYFP.BWcells;
        G = 0.8 * data.SegCFP.BWcells;
        B = 0.75 * (distMap >= distBins(1) & distMap < distBins(2)) * 255;
        imshow(cat(3,R,G,B));
        hold on;
        indists = dists >= distBins(1) & dists < distBins(2);
        outdists = dists < distBins(1) | dists >= distBins(2);
        plot(Gclusters.centers(outdists,1),Gclusters.centers(outdists,2), ...
            'o', 'MarkerSize',20, 'LineWidth', 1,...
            'MarkerEdgeColor',[1,1,1],...
            'MarkerFaceColor','none')
%         plot(data.Gclusters.centers(outdists,1),data.Gclusters.centers(outdists,2), ...
%             'o', 'MarkerSize',20, 'LineWidth', 1,...
%             'MarkerEdgeColor',[1,0,0],...
%             'MarkerFaceColor','none')
        plot(Gclusters.centers(indists,1),Gclusters.centers(indists,2),...
            'o', 'MarkerSize',20, 'LineWidth', 1,...
            'MarkerEdgeColor',[1,0,0],...
            'MarkerFaceColor','none')
%         plot(data.Gclusters.centers(indists,1),data.Gclusters.centers(indists,2),...
%             'o', 'MarkerSize',20, 'LineWidth', 1,...
%             'MarkerEdgeColor',[0,0,1],...
%             'MarkerFaceColor','none')
        text(100,100,['totalAttach: ', num2str(numel(indists))],'Color','w','FontSize',10);
        text(100,250,['in dist: ', num2str(sum(indists))],'Color','w','FontSize',10);
        text(100,400,['relevant area: ', num2str(totalAreaAtDist)],'Color','w','FontSize',10);
        text(100,550,['expected in dist: ', num2str(expectedCountsDistHist)],'Color','w','FontSize',10);
        text(100,700,['95% confidence: ', num2str([topConfCountsDistHist, botConfCountsDistHist])],'Color','w','FontSize',10);
        
    end
    
end



% store area hist

AvCvD.hist = countDistHist;
AvCvD.relHist = relativeCountDistHist;

AvCvD.expHist = expectedCountsDistHist;

AvCvD.topConf = topConfCountsDistHist;
AvCvD.botConf = botConfCountsDistHist;

AvCvD.topConfAnalytic = topConfCountsDistHistAnalytic;
AvCvD.botConfAnalytic = botConfCountsDistHistAnalytic;

% store area and dist bins

AvCvD.countBins = countBins;
AvCvD.distBins = distBins;

AvCvD.countBinsStr = [num2str(countBins), '-', num2str(countBins )];
AvCvD.distBins = distBins;

AvCvD.accumDist = accumDist;
end
    
    
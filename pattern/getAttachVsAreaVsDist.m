function AvAvD = getAttachVsAreaVsDist(data, varargin)

%params = parseInput(varargin);

nVarargs = length(varargin{1});
if (nVarargs == 4) 
    RclustersName = varargin{1}{1};
    GclustersName = varargin{1}{2};
    areaBins = varargin{1}{3};
    distBins = varargin{1}{4};
    accumDist = false;
end

if (nVarargs == 5) 
    RclustersName = varargin{1}{1};
    GclustersName = varargin{1}{2};
    areaBins = varargin{1}{3};
    distBins = varargin{1}{4};
    accumDist = varargin{1}{5};
end


Rclusters = data.(RclustersName);
Gclusters = data.(GclustersName);
areaBins = [areaBins];
% note - cumulative (i.e. up to dist or in range) ?

% create bitmap for each cluster area bin

areaDistHist = [];

relativeAreaDistHist = [];
expectedAreaDistHist = [];
topConfAreaDistHist = [];
botConfAreaDistHist = [];
topConfAreaDistHistAnalytic = [];
botConfAreaDistHistAnalytic = [];


for areaIdx = 1:(numel(areaBins) - 1)

    minArea = areaBins(areaIdx);
    maxArea = areaBins(areaIdx + 1);
    
    blank = false((Gclusters.imageSize)); 
    
    
    clustersIdxInBin = find(Rclusters.areas >= minArea & Rclusters.areas < maxArea);
    
    for cIdx = clustersIdxInBin'
        pixels = Rclusters.pixels{cIdx};
        px = pixels(:,1);
        py = pixels(:,2);
        
        ind = sub2ind(Gclusters.imageSize, px, py);
        blank(ind) = 1;
        
    end
    
    % create dist map

    distMap = bwdist(blank);
    

    % (compare to rand or normalize by total aera of bin of distances? or both, for error margin around 1?)
    
    % get values of points on dist map
    dists = [];
    for pIdx = 1:numel(Gclusters.pixels)
        center = Gclusters.centers(pIdx,:);
        cx = round(center(1));
        cx = min(max(1,cx),Gclusters.imageSize(1));
        cy = round(center(2));
        cy = min(max(1,cy),Gclusters.imageSize(2));
        dists = [dists, distMap(cx,cy)]; 
    end
    % hist by dist bins - counting attachments
    distHist = histcounts(dists,distBins);
    if (accumDist)
        distHist = cumsum(distHist);
    end
    
    
    % hist by dist bins - # of attachments relative to random, i.e. total
    % area of the diatance
    totalAreaAtDist = histcounts(distMap(:), distBins) ./ numel(distMap(:));
    if (accumDist)
        totalAreaAtDist = cumsum(totalAreaAtDist);
    end
    
    expectedAttachmentsAtDist = (numel(Gclusters.pixels)) * totalAreaAtDist;
    expectedAreaDistHist = [expectedAreaDistHist; expectedAttachmentsAtDist];
    
    
    topConfDistHistAnalytic = totalAreaAtDist + sqrt(totalAreaAtDist ./ (numel(Gclusters.pixels)));
    botConfDistHistAnalytic = totalAreaAtDist - sqrt(totalAreaAtDist ./ (numel(Gclusters.pixels)));

    topConfAreaDistHistAnalytic = [topConfAreaDistHistAnalytic; topConfDistHistAnalytic];
    botConfAreaDistHistAnalytic = [botConfAreaDistHistAnalytic; botConfDistHistAnalytic];
    
    relDistHist = distHist ./ expectedAttachmentsAtDist;
    
    % store dist hist
    
    areaDistHist = [areaDistHist ; distHist];
    relativeAreaDistHist = [relativeAreaDistHist; relDistHist];
    
    
    
    % random repetitions 

    allRndDistHist = [];
    for repeat = 1:1000
        rndDists = [];
        
        cx = randi([1,Gclusters.imageSize(1)], numel(Gclusters.pixels), 1);
        cy = randi([1,Gclusters.imageSize(2)], numel(Gclusters.pixels), 1);
        linearInd = sub2ind(Gclusters.imageSize, cx, cy);
        rndDists = distMap(linearInd);
                
        rndDistHist = histcounts(rndDists,distBins);
        if (accumDist)
            rndDistHist = cumsum(rndDistHist);
        end
        allRndDistHist = [allRndDistHist ; rndDistHist];
    end
    sortedRndDistHist = sort(allRndDistHist,1);
    topConfDistHist = sortedRndDistHist(951,:);
    botConfDistHist = sortedRndDistHist(50,:);
    
    topConfAreaDistHist = [topConfAreaDistHist ; topConfDistHist];
    botConfAreaDistHist = [botConfAreaDistHist ; botConfDistHist];
    
    
    
end

if true

    G = zeros(Gclusters.imageSize);
    for i = 1:numel(Gclusters.pixels)
   
        pixels = Gclusters.pixels{i};
        px = pixels(:,1);
        py = pixels(:,2);
        indices = sub2ind(Gclusters.imageSize, px, py);
        
        G(indices) = 1;
        
    end
    
    R = zeros(Rclusters.imageSize);
    for i = 1:numel(Rclusters.pixels)
   
        pixels = Rclusters.pixels{i};
        px = pixels(:,1);
        py = pixels(:,2);
        indices = sub2ind(Rclusters.imageSize, px, py);
        
        R(indices) = 1;
        
    end
    B = 0.75 * (distMap >= distBins(1) & distMap < distBins(2));
    figure
    imshow(cat(3,R,G,B));
    title(data.fullFileName);
            hold on;
        indists = dists >= distBins(1) & dists < distBins(2);
        outdists = dists < distBins(1) | dists >= distBins(2);
        plot(Gclusters.centers(outdists,2),Gclusters.centers(outdists,1), 'wx')
        plot(Gclusters.centers(indists,2),Gclusters.centers(indists,1), 'wo')
        text(100,100,['totalAttach: ', num2str(numel(indists))],'Color','w','FontSize',10);
        text(100,250,['in dist: ', num2str(sum(indists))],'Color','w','FontSize',10);
        text(100,400,['relevant area: ', num2str(totalAreaAtDist)],'Color','w','FontSize',10);
        text(100,550,['expected in dist: ', num2str(expectedAreaDistHist)],'Color','w','FontSize',10);
        text(100,700,['95% confidence: ', num2str([topConfAreaDistHist, botConfAreaDistHist])],'Color','w','FontSize',10);
end

% store area hist

AvAvD.hist = areaDistHist;
AvAvD.relHist = relativeAreaDistHist;

AvAvD.expHist = expectedAreaDistHist;

AvAvD.topConf = topConfAreaDistHist;
AvAvD.botConf = botConfAreaDistHist;

AvAvD.topConfAnalytic = topConfAreaDistHistAnalytic;
AvAvD.botConfAnalytic = botConfAreaDistHistAnalytic;

% store area and dist bins

AvAvD.areaBins = areaBins;
AvAvD.distBins = distBins;

AvAvD.areaBinsStr = [num2str(areaBins), '-', num2str(areaBins)];
AvAvD.distBins = distBins;

AvAvD.accumDist = accumDist;
end
    
    
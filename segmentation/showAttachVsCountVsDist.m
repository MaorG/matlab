function showAttachVsCountVsDist(m, varargin)

distBinInd = 0;
countBinInd = 0;
toShow2d = 0;
nVarargs = length(varargin{1});
if (nVarargs == 1) 
    toShow2d = 1;
    distBinInd = varargin{1};
elseif (nVarargs == 2) 
    toShow2d = 2;
    countBinInd = varargin{1}(2);
end

n = m;
if (toShow2d == 1)
    n.hist = n.hist(:,distBinInd);
    n.relHist = n.relHist(:,distBinInd);
    n.expHist = n.expHist(:,distBinInd);
    n.topConf = n.topConf(:,distBinInd);
    n.botConf = n.botConf(:,distBinInd);
    n.topConfAnalytic = n.topConfAnalytic(:,distBinInd);
    n.botConfAnalytic = n.botConfAnalytic(:,distBinInd);
    if (m.accumDist)
        n.distBins = n.distBins([1,(distBinInd+1)]);
    else
        n.distBins = n.distBins([distBinInd,(distBinInd+1)]);
    end
    n.xBins = n.countBins;
    n.titleBin = n.distBins;
elseif (toShow2d == 2) 
    n.hist = n.hist(countBinInd,:);
    n.relHist = n.relHist(countBinInd,:);
    n.expHist = n.expHist(countBinInd,:);
    n.topConf = n.topConf(countBinInd,:);
    n.botConf = n.botConf(countBinInd,:);
    n.topConfAnalytic = n.topConfAnalytic(countBinInd,:);
    n.botConfAnalytic = n.botConfAnalytic(countBinInd,:);

    n.xBins = n.distBins;
    n.titleBin = n.countBins([countBinInd, countBinInd+1]);
end
m = n;
if (toShow2d && size(m.hist,1) == 1 || size(m.hist,2) == 1)
    show2d(m)
else
    show3d(m)
end

end

function show3d(m)


    c = zeros(size(m.hist));
    for k = 1:numel(m.hist)
        
        val = m.hist(k);
        mean = m.expHist(k);
        top95 = m.topConf(k);
        bot95 = m.botConf(k);
        interval = top95 - bot95;
        if val > top95
            cval = (val - top95) / interval;
        elseif val < bot95
            cval = (val - bot95) / interval;
        else 
            cval = 0;
        end
        c(k) = cval;
    end
    
    colormap(cool);
    caxis([-3,3]);

    matbar = m.hist;
    matbar(matbar == 0) = nan;
    bar3nanColor( matbar, c );

    view([1,-1,5]);
    h = gca;

    set(h, 'XTick', 1:(numel(m.distBins)-1));
    strs = [];
    if m.accumDist == 0
        strs = [];
        for i = 2:numel(m.distBins)
            str = {[num2str(m.distBins(i-1)), ' - ',  num2str(m.distBins(i))]};
            strs = [strs, str];
        end
    else
        for i = 2:numel(m.distBins)
            str = {[num2str(m.distBins(1)), ' - ',  num2str(m.distBins(i))]};
            strs = [strs, str];
        end
    end
    set(h, 'XTickLabel', strs);

        
    set(h, 'YTick', 1:(numel(m.countBins)-1));
    set(h, 'YTickLabel', round(m.countBins(2:end)));
    
end


function show2d(m)

    h = gca;

    set(h, 'XTick', 1:(numel(m.xBins)-1));
    set(h, 'XTickLabel', round(m.xBins(2:end)));
    
    x = 1:(numel(m.xBins)-1);
    y = m.hist;
    
    ye = m.expHist;
    yt = m.topConf;
    yb = m.botConf;
    yta = m.topConfAnalytic;
    yba = m.botConfAnalytic;    
    
    hold on
    xx = x(y<yb | y > yt);
    yy = y(y<yb | y > yt);
    scatter(x,y,'bo');
    scatter(xx,yy,'ro');
    %ea = errorbar(x,ye,yba-ye,ye-yta,'Color', 'yellow', 'LineWidth', 3, 'CapSize', 0.1);
    %ea = errorbar(x,ye,yba-ye,ye-yta,'mx');
    e = errorbar(x,ye,yb-ye,ye-yt,'kx');
    %e = errorbar(x,ye,yba-ye,ye-yta,'mx');

    str = {[num2str(m.titleBin(1)), ' - ',  num2str(m.titleBin(2))]};
    title(str);


end


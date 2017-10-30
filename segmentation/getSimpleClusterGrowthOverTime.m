function result = getSimpleClusterGrowthOverTime(series, m_cidx, color)
% assuming sidx and cidx point to a simple cluster!
allCounts = nan(size(m_cidx,1), size(m_cidx,2));

hold on;
for clusterId = 1:size(m_cidx,2)
    counts = getCounts(series, m_cidx(:,clusterId));
    allCounts(:,clusterId) = counts;
    X = 0.5* (1:size(counts,1));
    plot(X(1:2:end),counts(1:2:end),'Color', 0.25 * color + 0.75*[1,1,1]);
end

allGrowth = allCounts(2:end,:) ./ allCounts(1:end-1,:);
allGrowth (allGrowth > 3) = nan;
%time scale is 0.5
allGrowth = (allGrowth);
sortedCountMat = sort(allCounts ,2);

Yvals = nan(size(sortedCountMat,1),1);
YvalsLow = nan(size(sortedCountMat,1),1);
YvalsHigh = nan(size(sortedCountMat,1),1);
for i = 1:size(sortedCountMat,1)-1
    vals = sortedCountMat(i,:);
    vals = vals(~isnan(vals));
    
    N = numel(vals);
    lowConfIdx = floor(N/ 20) + 1;
    highConfIdx = ceil(N * (19.0/20.0));
    
     Yvals(i) = mean(vals);
%      YvalsLow(i) = vals(lowConfIdx);
%      YvalsHigh(i)  = vals(highConfIdx);

     YvalsLow(i) =-  std(vals)./sqrt(numel(vals));
     YvalsHigh(i)  = std(vals)./sqrt(numel(vals));


end

X = 0.5* (1:numel(Yvals))';



% get each row values
X = X(~isnan(Yvals));
Y = Yvals(~isnan(Yvals));
Ylow = YvalsLow(~isnan(Yvals));
Yhigh = YvalsHigh(~isnan(Yvals));
% X = X(2:end);
% Y = Y(2:end);
fit = polyfit(X,log(Y),1);
m = fit(1);
b = fit(2);

fitLogY = b + m*X;



result = struct;
result.x = X;
result.y = Y;
result.ytop = YvalsHigh;
result.ybot = YvalsLow;
result.xFit = X;
result.yFit = exp(fitLogY);
result.m = m;
result.b = b;

if (~isempty(color) && numel(X) > 0)
    X = X(1:end-1);
    Y = Y(1:end-1);
    Ylow = Ylow(1:end-1);
    Yhigh = Yhigh(1:end-1);
    
    errorbar(X,...
        Y,...
        Ylow,...
        Yhigh,...
        ['-'], 'Color', color, 'LineWidth', 2)
    plot(X,exp(fitLogY(1:end-1)),['--'],'Color',color, 'LineWidth', 2);

    text(X(end),Y(end),[num2str(exp(m))], 'Color', color, 'fontsize', 18);
end

meanGrowth = Yvals(2:end) ./ Yvals(1:end-1);

%plot(meanGrowth, styleStr, 'LineWidth', 3);


return














for j = 1:size(allImages,2)
    rowHeight = 0;
    rowWidth = 0;
    for i = 1:size(allImages,1)
        [h,w] = size(allImages{i,j});
        rowWidth = rowWidth + w + 1;
        rowHeight = max(rowHeight, h);
    end
    totalWidth = max(rowWidth, h);
    totalHeight = totalHeight + rowHeight + 1;
end

big = zeros(totalHeight, totalWidth);

currY = 1;
for j = 1:size(allImages,2)
    rowHeight = 1;
    currX = 1;
    for i = 1:size(allImages,1)
        [h,w] = size(allImages{i,j});
        rowHeight = max(rowHeight, h);
        big(currY:currY + h - 1, currX:currX + w - 1) = allImages{i,j};
        currX = currX + w + 1;
        big(currY:currY + h - 1,currX - 1) = 1;
    end
    currY = currY + rowHeight + 1;
    big(currY-1,:) = 1;
end
imshow(big);
hold on
% currX = 1;
% for i = 1:numel(images)
%     [h,w] = size(images{i});
%     if ~isnan(v_cidx(i))
%         text(currX, totalHeight - 10, num2str(series(i).clusters.count(v_cidx(i))),'Color','r');
%     end
%     currX = currX + w + 1;
% end

end

function [counts, v_cidx] = getCounts(series, v_cidx)

counts = nan(numel(series), 1);


for sidx = 1:numel(v_cidx)
    cidx = v_cidx(sidx);
    if (~isnan(cidx))
        counts(sidx) = series(sidx).clusters.count(cidx);
    end
end


end
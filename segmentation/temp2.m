function temp2(series, styleStr)
 hold on;
countMat = getSimpleClusterCountsVsTime(series);

growthMat =[];
filteredCountMat = [];

hold on
counter = 0;
for i = 1:size(countMat,2)
    counts = countMat(:,i);
    if sum(~isnan(counts)) >= 7 && sum(counts(2:end) == 1) < 1
        growth = 1.0 * counts(2:end) ./ counts(1:end-1);
        growthMat = cat(2,growthMat,growth);
        filteredCountMat = cat(2,filteredCountMat ,counts);
        %plot(growth, styleStr)
        counter = counter + 1;
    end
    
end

%growthMat = countMat(2:end,:) ./ countMat(1:end-1,:);


sortedCountMat = sort(filteredCountMat ,2);

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

     YvalsLow(i) = std(vals)./sqrt(numel(vals));
     YvalsHigh(i)  = std(vals)./sqrt(numel(vals));

    
end

X = 0.5* (1:numel(Yvals))';
errorbar(X,...
    Yvals,...
    YvalsLow,...
    YvalsHigh,...
    [styleStr, '-'])

xlim([1,numel(Yvals)]);

% get each row values
X = X(~isnan(Yvals));
Y = Yvals(~isnan(Yvals));
% X = X(2:end);
% Y = Y(2:end);
fit = polyfit(X,log(Y),1);
m = fit(1);
b = fit(2);

fitLogY = b + m*X;


plot(X,exp(fitLogY),[styleStr, ':']);

text(X(end),Y(end),num2str(exp(m)));


meanGrowth = Yvals(2:end) ./ Yvals(1:end-1);

%plot(meanGrowth, styleStr, 'LineWidth', 3);

counter

end

function [countMat] = getSimpleClusterCountsVsTime(series)


countMat = nan(numel(series), 0);
for sidx = 1:numel(series)
    countMatSingle = nan(numel(series), numel(series(sidx).clusters.count));
    for cidx =  1:numel(series(sidx).clusters.count)
        [counts] = getClusterCountsOverTime(series, sidx, cidx);
        countMatSingle(:, cidx) = counts;
%         if sum(~isnan(counts)) >= 7 && sum(counts(2:end) == 1) < 1
%             countMatSingle = cat(2, countMatSingle, counts);
%         end
    end
    countMat = cat(2,countMat, countMatSingle);
end

end

function [counts] = getClusterCountsOverTime(series, sidx, cidx)


counts = nan(numel(series), 1);

% make sure we are at the start of a single line - 0 or > 2 prevIds
if (sidx > 1)
    prevIds = series(sidx).clusters.prevIds{cidx};
else
    prevIds = [];
end
    
if (sidx < numel(series) && numel(prevIds) ~= 1)
    
    counts(sidx) = series(sidx).clusters.count(cidx);
    % now follow the nextIds, until end of line
    nextIds = series(sidx).clusters.nextIds{cidx};
    while (sidx + 1 < numel(series) && numel(nextIds) == 1)
        sidx = sidx + 1;
        cidx = nextIds;
        
        counts(sidx) = series(sidx).clusters.count(cidx);
        nextIds = series(sidx).clusters.nextIds{cidx};
    end
end
end





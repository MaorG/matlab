function temp(series, styleStr)
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


meanGrowth = nanmean(growthMat, 2)

plot(meanGrowth, styleStr, 'LineWidth', 3);

counter

end

function countMat = getSimpleClusterCountsVsTime(series)


countMat = nan(numel(series), 0);
for sidx = 1:numel(series)
    countMatSingle = nan(numel(series), numel(series(sidx).clusters.count));
    for cidx =  1:numel(series(sidx).clusters.count)
        counts = getClusterCountsOverTime(series, sidx, cidx);
        countMatSingle(:, cidx) = counts;
%         if sum(~isnan(counts)) >= 7 && sum(counts(2:end) == 1) < 1
%             countMatSingle = cat(2, countMatSingle, counts);
%         end
    end
    countMat = cat(2,countMat, countMatSingle);
end

end

function counts = getClusterCountsOverTime(series, sidx, cidx)


counts = nan(numel(series), 1);

% make sure we are at the start of a single line - 0 or > 2 prevIds
if (sidx > 1)
    prevIds = series(sidx).clusters.prevIds{cidx};
else
    prevIds = [];
end
if (numel(prevIds) ~= 1)
    
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





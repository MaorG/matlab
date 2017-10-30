function plotSimpleClusterCountsVsTime(series, styleStr)

hold on;
counter = 0;

for sidx = 1:5 %numel(series)
    for cidx =  1:numel(series(sidx).clusters.count)
        counts = getClusterCountsOverTime(series, sidx, cidx);
        if sum(~isnan(counts)) >= 7 && sum(counts(2:end) == 1) < 2
            plot(counts, styleStr)
            counter = counter + 1;
        end
    end
end

counter
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





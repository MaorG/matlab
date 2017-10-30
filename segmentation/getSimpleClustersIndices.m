function cidxMat = getSimpleClustersIndices(allData)

[cidxMat] = getAllSimpleClusterLineages(allData);
end


function [cidxMat] = getAllSimpleClusterLineages(series)


cidxMat = nan(numel(series), 0);
for sidx = 1:numel(series)
    countMatSingle = nan(numel(series), numel(series(sidx).clusters.count));
    for cidx =  1:numel(series(sidx).clusters.count)
        v_cidx = getClusterSimpleLineageAux(series, sidx, cidx);
        if (sum(~isnan(v_cidx)))
            cidxMat = cat(2,cidxMat, v_cidx);
        end

    end
end

end

function [v_cidx] = getClusterSimpleLineageAux(series, sidx, cidx)


v_cidx = nan(numel(series), 1);

% make sure we are at the start of a single line - 0 or > 2 prevIds
if (sidx > 1)
    prevIds = series(sidx).clusters.prevIds{cidx};
else
    prevIds = [];
end
    
if (sidx < numel(series) && numel(prevIds) ~= 1)
    
    v_cidx(sidx) = cidx;
    % now follow the nextIds, until end of line

    nextIds = series(sidx).clusters.nextIds{cidx};
    while (sidx + 1 < numel(series) && numel(nextIds) == 1)
        sidx = sidx + 1;
        cidx = nextIds;
        
        v_cidx(sidx) = cidx;
        nextIds = series(sidx).clusters.nextIds{cidx};
    end
end
end

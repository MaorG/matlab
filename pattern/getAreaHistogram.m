function H = getAreaHistogram(data, varargin)
    
nVarargs = length(varargin{1});

bins = [];
if (nVarargs >= 1)
    bins = varargin{1}{1};
end
infBins = 1;
if (nVarargs >= 2)
    infBins = varargin{1}{2};
end

areas = data.clusters.areas;

if (infBins)
    [N,edges] = histcounts(areas,[-inf, bins + 1, inf]);
    H = [N ; [bins, inf]];
else
    [N,edges] = histcounts(areas,bins);
    H = [N ; [bins(1:end-1)]];
end    

end
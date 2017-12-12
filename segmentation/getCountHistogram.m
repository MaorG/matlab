function H = getCountHistogram(data, varargin)
    
nVarargs = length(varargin{1});

bins = [];
if (nVarargs >= 1)
    bins = varargin{1}{1};
end

count = numel(data.clusters.count;

[N,edges] = histcounts(count,[-inf, bins + 1, inf]);
H = [N ; [bins, inf]];

end
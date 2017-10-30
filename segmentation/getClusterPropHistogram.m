function [hist] = getClusterPropHistogram (data, varargin)
props = parseVarargin(varargin{1});

values = data.clusters.(props.propName);
bins = props.bins;

[N,edges] = histcounts(values,[-inf, bins + 1, inf]);
hist = [N ; [bins, inf]];

end


function props = parseVarargin(v)
% default:
props = struct(...
    'propName', 'count',...
    'bins', [1,10,100,1000,10000]...
    );

for i = 1:numel(v)
    
    if (strcmp(v{i}, 'propName'))
        props.propName = v{i+1};
    elseif (strcmp(v{i}, 'bins'))
        props.bins = v{i+1};
    end
end

end
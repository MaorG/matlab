function [indices] = getAgentIndcesByProperties (data, varargin)


nvars = length(varargin{1});
pNames = [];
pVals = [];

for i = 1:2:nvars
   pNames = [pNames; varargin{1}(i)];
   pVals = [pVals; varargin{1}(i+1)];
end

indices = ones(1,numel(extractfield(data.agents, pNames{1})));

for i = 1:numel(pNames)
    a = extractfield(data.agents, pNames{i});
    if (ischar(pVals{i}))
        indices = indices & strcmp(a, pVals{i});
    else
        indices = indices & (a == pVals{i});
    end
end

end
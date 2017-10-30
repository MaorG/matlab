function [ratio] = getACount(data, varargin)
if (numel(data.agents) == 0)
    ratio = [];
    return
end
nVarargs = length(varargin{1});
if (nVarargs == 1) 
    speciesName = varargin{1}{1};
end

species = extractfield(data.agents, 'species'); 

thisSpeciesCount = numel(find(strcmp(species, speciesName)));

ratio = thisSpeciesCount;

end
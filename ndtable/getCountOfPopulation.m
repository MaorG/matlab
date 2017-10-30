function [count] = getCountOfPopulation (data, varargin)
popName = varargin{1}{1};
if isfield(data.population, popName)
    count = data.population.(popName);
else
    count = 0;
end
end
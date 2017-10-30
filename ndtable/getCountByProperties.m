function [count] = getCountByProperties (data, varargin)
indices = getAgentIndcesByProperties(data, varargin{1});
count = sum(indices);
end
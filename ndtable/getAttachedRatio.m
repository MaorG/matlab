function [ratio] = getAttachedRatio (data)
if (numel(data.agents) == 0)
    ratio = 0;
else
    ratio = sum(extractfield(data.agents, 'attached') == 1) / numel(data.agents);
end

end
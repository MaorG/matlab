function [ratio] = getABCRatio (data)
    world = data.world;
    countA = sum(sum(world == 1));
    countB = sum(sum(world == 2));
    countC = sum(sum(world == 3));
    countAll = sum(sum(world ~= 0));
    ratio = [countA countB countC] ./ countAll;

end
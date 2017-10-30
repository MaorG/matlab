function [allData] = scoreAllData(allData, scoreNames, scoringFunction, varargin)
for i = 1:size(allData,1)
    scoreNames
    i
    if nargin > 3
        result = scoringFunction(allData(i), varargin);
    else
        result = scoringFunction(allData(i));
    end
    
    
    
    if (size(scoreNames,1) == 1)
        allData(i).(scoreNames) =  result;
    else
        scoreNames = cellstr(scoreNames);
        for iName = 1:size(scoreNames,1)
            allData(i).(scoreNames{iName}) = result(iName);
        end
    end
end
end
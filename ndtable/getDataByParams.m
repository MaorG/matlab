function [dataWithParams] = getDataByParams (allData, varargin)
dataWithParams = [];

% get parameters name and value
nvars = length(varargin);
pNames = [];
pVals = [];

for i = 1:2:nvars
    pNames = [pNames; varargin(i)];
    pVals = [pVals; varargin(i+1)];
end


for datum = allData'
    
    belong = true;
    
    for i = 1:size(pNames,1)
        if ischar( pVals{i} )
            
            if ~strcmp(datum.(pNames{i}), pVals{i})

                datum.(pNames{i})
                pVals{i}
                belong = false;
            end
        else
            if datum.(pNames{i}) ~= pVals{i}
                belong = false;
            end
        end
    end
    
    if belong
        dataWithParams = [dataWithParams ; datum];
    end
end
end
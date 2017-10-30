function [runs] = getRunsByParams (cruns, varargin)

nvars = length(varargin);
pNames = [];
pVals = [];

runs = [];

for i = 1:2:nvars
    pNames = [pNames; varargin(i)];
    pVals = [pVals; varargin(i+1)];
end


for runi = 1:numel(cruns)
    
    
    runGroup = cruns(runi);
    for j = 1:numel(runGroup{1})
        belong = true;
        run = runGroup{1}(j);
        
        for i = 1:size(pNames,1)
            if run{1}(1).(pNames{i}) ~= pVals{i}
                belong = false;
            end
        end

        if belong
            runs = [runs ; run];
        end
        
    end
end

end
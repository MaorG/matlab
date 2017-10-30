function [resultTable] = createResultTable (allData, paramA, paramB, operation, resultName, resultIndexA, resultIndexB)

%should make this much much more elegant, or find a way around it :(

valsA = extractfield(allData, paramA);
valsB = extractfield(allData, paramB);

valsA = sort(unique(valsA));
valsB = sort(unique(valsB));
T = zeros(size(valsA,2), size(valsB,2));

for idxA = 1:size(valsA,2)
    for idxB = 1:size(valsB,2)
        dataByParams = getDataByParams(allData, paramA, valsA(idxA), paramB, valsB(idxB));
        if (~ isempty(dataByParams))
            switch nargin
                case 5
                    tempVal = extractfield(dataByParams, resultName);
                case 6
                    tempVal = extractfield(dataByParams, resultName);
                    tempVal = tempVal(resultIndexA);
                case 7
                    tempVal = [];
                    for ii = 1:size(dataByParams,1)
                        tempVal = [tempVal, dataByParams(ii).(resultName)(resultIndexA, resultIndexB)];
                    end
            end
            
            if strcmp(operation, 'var')
                T(idxA, idxB) = nanvar(tempVal);
            elseif strcmp(operation, 'std')
                T(idxA, idxB) = nanstd(tempVal);
            else
                T(idxA, idxB) = nanmean(tempVal);
            end
        end
    end
end

resultTable.valsA = valsA;
resultTable.valsB = valsB;
resultTable.T = T;

end
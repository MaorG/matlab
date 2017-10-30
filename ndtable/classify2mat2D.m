function [resultTable] = classify2mat2D (allData, paramA, paramB)

%should make this much much more elegant, or find a way around it :(

valsA = extractfield(allData, paramA);
valsB = extractfield(allData, paramB);

valsA = sort(unique(valsA));
valsB = sort(unique(valsB));
T = cell(size(valsA,2), size(valsB,2));
a = [];

%arrayfunc(@(data) a = [a,2], allData);
%arrayfunc(@() T(paramA == data.paramA, paramB == data.paramB) = data, allData);

for idxA = 1:size(valsA,2)
    for idxB = 1:size(valsB,2)
        T(idxA, idxB) = {getDataByParams(allData, paramA, valsA(idxA), paramB, valsB(idxB))};
        
    end
end

resultTable.valsA = valsA;
resultTable.valsB = valsB;
resultTable.T = T;

end
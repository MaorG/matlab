allData = parseDir('c:\school\netlogo\dual\toMatlab\');

resultTable = createResultTable(allData);

summer = zeros(size(resultTable.valsA,1), size(resultTable.valsB,1),size(allData,1));


% todo move into result table, add SI func as parameter
for w = 1:size(allData,1)
    SI = getSI(allData(w).world);
    
    idxA = find(~(resultTable.valsA - allData(w).paramA), 1);
    idxB = find(~(resultTable.valsB - allData(w).paramB), 1);

    summer(idxA, idxB, w) = SI;
end

for idxA = 1:size(resultTable.valsA,1)
    for idxB = 1:size(resultTable.valsB,1)
        resultTable.T(idxA, idxB) = mean(nonzeros(summer (idxA, idxB, :))); % ave!!!!
    end
end

print_world(allData(w).world)


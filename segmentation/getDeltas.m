function allDeltas = getDeltas(allData, verbose)

allDeltas = [];

for i = 1:numel(allData)
    for j = 1:numel(allData)
        if (allData(i).conc == allData(j).conc) && (allData(i).signal == allData(j).signal) && (allData(i).time +1 == allData(j).time)
            delta = comparePair(allData(i), allData(j),verbose);
            allDeltas = [delta, allDeltas];
        end
    end
end
    


end


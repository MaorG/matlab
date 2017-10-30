function allDeltas = getChannelLiveDead(allData, verbose)

allDeltas = [];

for i = 1:numel(allData)
    for j = 1:numel(allData)
        if (allData(i).conc == allData(j).conc) && (allData(i).signal == allData(j).signal) && (allData(i).time== allData(j).time) && ...
                (strcmpi(allData(i).channel, 'yfp') && strcmpi(allData(j).channel, 'cfp'))
            delta = getYFP2CFPdelta(allData(i), allData(j),verbose);
            allDeltas = [delta, allDeltas];
        end
    end
end
    


end
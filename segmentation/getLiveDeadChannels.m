function allData = mergeChannels(allData, channel1Name, channel2Name)

allDeltas = [];

for i = 1:numel(allData)
    for j = i:numel(allData)
        if      (allData(i).time == allData(j).time) && ...
                (strcmpi(allData(i).channel, channel1Name) && strcmpi(allData(j).channel, channel2Name))
            delta = mergeChannelsAux(allData(i), allData(j), channel1Name, channel2Name);
            allDeltas = [delta, allDeltas];
        end
    end
end
    


end

function delta = mergeChannelsAux(data1, data2, channel1Name, channel2Name)

delta = data1;
delta.[channel1Name] = data1.I;
delta.[channel2Name] = data2.I;

delta.I = (weights(1) * liveData.I + weights(2) * deadData.I) ./ sum(weights);
end
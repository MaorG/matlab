function delta = mergeLiveDeadChannels(liveData,deadData,weights)

delta = liveData;
delta.liveI = liveData.I;
delta.deadI = deadData.I;

delta.I = (weights(1) * liveData.I + weights(2) * deadData.I) ./ sum(weights);


end

allData = dir2data


for i = 1:numel(allData)
    allData(i).experiment = allData(i).fileName(end-5:end-4)
end

for i = 1:numel(allData)
    allData(i).time = allData(i).fileName(end-8:end-7)
end

for i = 1:numel(allData)
    C = strsplit(allData(i).dirName, '\');
    allData(i).color = C(6);
end



timeVals = unique(extractfield(allData,'time'))
expVals = unique(extractfield(allData,'experiment'))

uData = [];

for timeVal = timeVals
    for expVal = expVals
        data = struct;
        relevantData = getDataByParams(allData, 'time', timeVal, 'experiment', expVal);
        
        for i = 1:numel(relevantData)
            if strcmp(relevantData(i).color, 'RFP')
                data.R = relevantData(i).I;
                data.Rclusters = relevantData(i).clusters;
            elseif strcmp(relevantData(i).color, 'GFP')
                data.G = relevantData(i).I;
                data.Gclusters = relevantData(i).clusters;
            end
        end
        
        data.time = timeVal{1};
        data.experiment = expVal{1};
        
        uData = [uData; data];
    end
end

[uData.I] = deal([]);
for i = 1:numel(uData)
    uData(i).I = uData(i).R | uData(i).G;
end
uData = scoreAllData(uData, 'clusters', @getClustersFromBitmap,10,2);

uData = scoreAllData(uData, 'tecon', @getTecon);

pNames = {'time', 'experiment'};
rt1 = createNDResultTable(uData, 'tecon', pNames);

tableUI(rt1,@showTecon,[]);
tableUI(rt2,@imshow,[]);

my_disp = @(m) imshow()

uSeries = [];

for expVal = expVals
    series = getDataByParams(uData, 'experiment', expVal);
    series = get_cluster_evolution(series);
    uSeries = [uSeries, series];
end
            
for i = 1:size(uSeries,2)
   show_cluster_evo(uSeries(:,i));
   title(uSeries(1,i).experiment)
end
    
        
        
allData = dir2data('C:\school\microscopy\26.4.17\', true);


for i = 1:numel(allData)
    C = strsplit(allData(i).dirName, '\');
    temp = C(end-1);
    allData(i).experiment = temp{1};
    if strcmp(allData(i).experiment, 'A6')
        allData(i).experiment = 'A5';
    end
end

for i = 1:numel(allData)
    allData(i).color = upper(allData(i).fileName(1:3));
end

for i = 1:numel(allData)
    C = strsplit(allData(i).dirName, '\');
    temp = C(5);
    allData(i).time = temp{1}(4:5);
end



addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable')  

allData = scoreAllData(allData, 'clusters', @getClustersFromBitmap,10,2);

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


pNames = {'time', 'experiment'};


% show clusters
for i = 1:numel(uData)
    uData(i).I = cat(3, uData(i).R, uData(i).G, zeros(size(uData(i).G)));
end
for i = 1:numel(uData)
    uData(i).Ismall = imresize(uData(i).I,0.1);
end



rtI = createNDResultTable(uData, 'I', pNames);
tableUI(rtI, @imshow, []);


rtIs = createNDResultTable(uData, 'Ismall', pNames);
tableUI(rtIs, @imshow, []);


% show cluster dist
for i = 1:numel(uData)
    uData(i).clusters = uData(i).Rclusters
end
uData = scoreAllData(uData, 'areaHist', @getAreaHistogram, power(1.5,5:25));
rt1 = createNDResultTable(uData, 'areaHist', pNames);

myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log')
ylog = @(h) set(h,'yscale','log')
ylimit = @(h) ylim([0,1000])
tableUI(rt1,myplot, [ {ylimit}, {xlog}]); 




uData = scoreAllData(uData, 'AvAvD_3_33_168', @getAttachVsAreaVsDist,'Rclusters','Gclusters',[power(1.5,4:24)], [3:33:168]);
uData = scoreAllData(uData, 'AvAvD_3_33_168_c', @getAttachVsAreaVsDist,'Rclusters','Gclusters',[power(1.5,4:24)], [3:33:168], 1);

uData = scoreAllData(uData, 'AvAvD_3_33_168_4', @getAttachVsAreaVsDist,'Rclusters','Gclusters',[power(4,2.5:8)], [3:33:168]);
uData = scoreAllData(uData, 'AvAvD_3_33_168_c_4', @getAttachVsAreaVsDist,'Rclusters','Gclusters',[power(4,2.5:8)], [3:33:168], 1);



rt5 = createNDResultTable(uData, 'AvAvD_3_33_168_4', pNames);
tableUI(rt5,@showAttachVsAreaVsDist,[]);
rt6 = createNDResultTable(uData, 'AvAvD_3_33_168_c_4', pNames);
tableUI(rt6,@showAttachVsAreaVsDist,[]);

rt7 = createNDResultTable(uData, 'AvAvD_6_66_336_4', pNames);
tableUI(rt7,@showAttachVsAreaVsDist,[]);
rt8 = createNDResultTable(uData, 'AvAvD_6_66_336_c_4', pNames);
tableUI(rt8,@showAttachVsAreaVsDist,[]);

sss = @(m) showAttachVsAreaVsDist(m,1);
tableUI(rt5,sss,[]);
tableUI(rt6,sss,[]);
        
        
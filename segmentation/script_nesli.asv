function allData = script_nesli(dirName, op)


% if op == 1
%     allData = getAllData(dirName);
% else
%     allData = getDelta
% end



% function allData = getAllData(dirName)

allData = dir2data(dirName,true);

for i = 1:numel(allData)
    allData(i).time = str2num(allData(i).fileName(6));
    
    if strcmpi('A1', allData(i).fileName(8:9))
        allData(i).conc = 20;
    elseif strcmpi('A4', allData(i).fileName(8:9))
        allData(i).conc = 2;
    end
    
    if strcmpi('cfp', allData(i).fileName(11:13))
        allData(i).channel = 'cfp';
    elseif strcmpi('yfp', allData(i).fileName(11:13))
        allData(i).channel = 'yfp';
    end

    
end


imageRect = [];

if (~isempty(imageRect))
    for i = 1:numel(allData)
        allData(i).I = (allData(i).I(imageRect(1):imageRect(2),imageRect(3):imageRect(4)));
    end
else
    for i = 1:numel(allData)
        allData(i).I = (allData(i).I);
    end  
end



for i = 1:numel(allData)
    allData(i).Seg = Segmentation;
    allData(i).Seg.BWcells = allData(i).I;
end  


pNames = {'time', 'conc', 'channel'};
allData = scoreAllData(allData, 'countHist1', @getCountHistogram, 'bins', power(2,[0:20]), 'clustersName', 'clusters');
rt1 = createNDResultTable(allData, 'countHist1', pNames);
myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log')
ylog = @(h) set(h,'yscale','log')
ylimit = @(h) ylim([0,10000]);
xlimit = @(h) xlim([0,2^15]);
tableUI(rt1,myplot, [{ylog},{xlog}, {ylimit}, {xlimit}]); 

% explict cluster dilation and creation of BWclusters

for i = 1:numel(allData)
    allData(i).Seg.clusterDilateRadius = 4;
    allData(i).Seg = allData(i).Seg.getClusters;
end



allDeltas = getChannelDeltas(allData, 1);

for i = 1:numel(allDeltas)
    allDeltas(i).SegYFP.clusterDilateRadius = 10;
    allDeltas(i).SegCFP.clusterDilateRadius = 10;
    allDeltas(i).SegYFP = allDeltas(i).SegYFP.getClusters;
    allDeltas(i).SegCFP = allDeltas(i).SegCFP.getClusters;
end

allDeltas = scoreAllData(allDeltas, 'Yclusters', @getClustersFromSeg, 'segName', 'SegYFP');
allDeltas = scoreAllData(allDeltas, 'Cclusters', @getClustersFromSeg, 'segName', 'SegCFP');

allDeltas = scoreAllData(allDeltas, 'rac', @getAttachVsCountVsDist,...
    'RclustersName', 'Yclusters', ...
    'GclustersName', 'Cclusters', ...
    'countBins',[1,25,10000],...
    'distBins', 1+[0, 60, 120],...
    'accumDist', 1, ...
    'compareTo', [1, 121] ...
    );



allDeltas = scoreAllData(allDeltas, 'aad3c', @getAttachVsCountVsDist2, 'Yclusters', 'Cclusters', [1,16,1000],0+[0,30, 60,120,240,480,960,inf],1);

rt5 = createNDResultTable(allDeltas, 'rac', pNames);
tableUI(rt5,@showAttachVsCountVsDist,[]);

sss = @(m) showAttachVsCountVsDist(m,[1]);
tableUI(rt5,sss,[]);


dd = getDataByParams(allDeltas,'time', 6, 'conc', 20);
dd = scoreAllData(dd, 'demo', @getAttachVsCountVsDist, ... 
    'RclustersName', 'Yclusters', ...
    'GclustersName', 'Cclusters', ...
    'countBins',[1,64,10000],...
    'distBins', 1+[0, 60, 120],...
    'accumDist', 1, ...
    'compareTo', [1, 121] ...
    );

rt2 = createNDResultTable(dd, 'demo', pNames);
tableUI(rt2,@showAttachVsCountVsDist,[]);

sss = @(m) showAttachVsCountVsDist(m,[1]);
tableUI(rt2,sss,[]);



end


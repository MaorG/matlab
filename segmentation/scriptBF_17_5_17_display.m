tic
seriesC1 = scriptBF_17_5_17('C:\school\microscopy\23.5.17\gfp\c1\');
seriesC2 = scriptBF_17_5_17('/home/maor/school/microscopy/17.5.17/example/c2/');
seriesD1 = scriptBF_17_5_17('/home/maor/school/microscopy/17.5.17/example/d1/');
seriesD2 = scriptBF_17_5_17('/home/maor/school/microscopy/17.5.17/example/d2/');

allData = [seriesC1, seriesC2, seriesD1, seriesD2];




allData = scriptBF_17_5_17('/home/maor/school/microscopy/17.5.17/example/');





allData = scoreAllData(allData, 'aad3', @getAttachVsAreaVsDist, 'Rclusters', 'Gclusters', [power(2,4:20)],3+[0,60,120,240,480,inf]);
scoreAllData(dbp, 'aad5c', @getAttachVsAreaVsDist, 'Rclusters', 'Gclusters', [power(2,4:20)],1+[0,60,120,240,480,960,1920,3840,inf],1);

dbp = getDataByParams(allData','time', 3, 'conc', 0.22, 'signal', 0);

toc
pNames = {'time', 'conc', 'signal'};

allData = scoreAllData(allData, 'areaHist', @getAreaHistogram, power(2,4:20));
rt1 = createNDResultTable(allData, 'areaHist', pNames);
myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log')
ylog = @(h) set(h,'yscale','log')
ylimit = @(h) ylim([0,10000]);
xlimit = @(h) xlim([0,2^20]);
tableUI(rt1,myplot, [{xlog},{ylog},{xlimit},{ylimit}]); 



rt5 = createNDResultTable(allData, 'aad4c', pNames);
tableUI(rt5,@showAttachVsAreaVsDist,[]);

sss = @(m) showAttachVsAreaVsDist(m,[2]);
tableUI(rt5,sss,[]);


dbp1 = getDataByParams(allData,'time', 1, 'conc', 22, 'signal', 1);
dbp2 = getDataByParams(allData,'time', 2, 'conc', 22, 'signal', 1);
aaaData = [dbp1;dbp2];
aaaData = scoreAllData(aaaData, 'aad3c', @getAttachVsAreaVsDist, 'Rclusters', 'Gclusters', [power(2,4:20)],3+[0,60,120,240,480,960,1920,3840,inf],1);


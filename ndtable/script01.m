%filter = @(d) (d.intervalNum == 160);
filter = @(d) (1);

dirname = '/home/maor/repast/output_gd02/c_5strat01const/';
allData = processOutput(dirname, filter);

% dirname = '/home/maor/repast/output_gd02/c_18strat01long/';
% allData1 = processOutput(dirname, filter);
% 
% dirname = '/home/maor/repast/output_gd02/c_18strat01long2/';
% allData2 = processOutput(dirname, filter);
% 
% dirname = '/home/maor/repast/output_gd02/c_18strat01long3/';
% allData3 = processOutput(dirname, filter);
%  
% allData = [allData1; allData2; allData3];



allData = scoreAllData(allData, 'p10', @getCountOfPopulation, 'dbact10');
allData = scoreAllData(allData, 'p11', @getCountOfPopulation, 'dbact11');

expression = '[\w\.]*';

if isfield(allData(1), 'stratexpr1')
    for i = 1:numel(allData)
        nums = regexp(allData(i).stratexpr1,expression,'match');
        allData(i).schance1 = str2double(nums{1});
        allData(i).sslope1 = str2double(nums{6});
        allData(i).sthresh1 = str2double(nums{8});
        allData(i).s1 = allData(i).sthresh1;
    end
end
if isfield(allData(1), 'death')
    for i = 1:numel(allData)
        nums = regexp(allData(i).death,expression,'match');
        allData(i).d1 = str2double(nums{1});
    end
end


% for i = 1:numel(allData)
%    nums = regexp(allData(i).stratexpr2,expression,'match');
%    allData(i).schance2 = str2double(nums{1});
%    allData(i).sslope2 = str2double(nums{6});
%    allData(i).sthresh2 = str2double(nums{8});
% end



for i = 1:numel(allData)
   
   allData(i).time = allData(i).interval*allData(i).intervalNum;
     
%   allData(i).s2 = allData(i).sthresh2;
end





pNames = {'time', 's1', 'conc', 'd1', 'repeat'}; 
pNames = {'time', 'conc', 'd1', 's1'}; 
colateBy = 's1';

% pNames = {'time', 'conc', 'd1', 'attachRandom'}; 
% colateBy = 'attachRandom';

%rt = stepTimeAnalysis(allData, pNames, 'd1');

stepTimeAnalysis(allData, pNames, colateBy);
%stepTimeAnalysis(allData, pNames, 's1');
stepTimeAnalysis(allData, pNames, 'time');

%showOptimum(rt, 'pNames', pNames,'colateBy', colateBy, 'fit', 1);
%scoreProfile(rt);

postPosterPlots(allData, pNames, colateBy)


%postPosterPlots(allData,pNames,'s1');

tic
save(strcat(dirname, 'allData.mat'), 'allData', '-v7.3');
toc


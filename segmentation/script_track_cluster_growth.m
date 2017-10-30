function script_track_cluster_growth(allData)

% allDataC1 = setupAllAllData('C:\school\microscopy\23.5.17\configC1.txt');
% allDataC2 = setupAllAllData('C:\school\microscopy\23.5.17\configC2.txt');
% allDataC4 = setupAllAllData('C:\school\microscopy\23.5.17\configC4.txt');
% allDataC5 = setupAllAllData('C:\school\microscopy\23.5.17\configC5.txt');

% allData = [allDataC1; allDataC2; allDataC4; allDataC5];

% 
% figure;
% hold on;
% showGrowth(allData, 'r')
% 
% figure;
% hold on;
% showGrowthByAttachTime(allData, 'r')
% 
% 
% return;


allDataC1 = getDataByParams(allData, 'conc', 2.2, 'signal', 0);
allDataC2 = getDataByParams(allData, 'conc', 2.2, 'signal', 1);
allDataC4 = getDataByParams(allData, 'conc', 22, 'signal', 0);
allDataC5 = getDataByParams(allData, 'conc', 22, 'signal', 1);
%showSimpleClustersByLastFrame(allDataC2, 21, 'r')

figure;
hold on;
showGrowth(allDataC1, [0,0,1])
showGrowth(allDataC2, [1,0,0])
%showGrowth(allDataC4, 'b')
%showGrowth(allDataC5, 'm')

% figure;
% hold on;
% showGrowthByAttachTime(allDataC1, 'r')
% showGrowthByAttachTime(allDataC2, 'g')
%showGrowthByAttachTime(allDataC4, 'b')
%showGrowthByAttachTime(allDataC5, 'm')

% legend(...
%     ['conc 22 signal 0'],...
%     ['conc 22 signal 1'],...
%     ['conc 2.2 signal 0'],...
%     ['conc 2.2 signal 1']...
%     );

end

% 
% figure
% temp2(allData,'y')

function showGrowth(allData, color)
mmm = getSimpleClustersIndices(allData);


    firsts = [1];


    for first = firsts
            m1 = [];
    for i = 1:size(mmm,2)
        mc = mmm(:,i);
        if (sum(~isnan(mc)) > 7) && (all(isnan(mc(1:first-1)))) && (~isnan(mc(first))) && ...
                (allData(first).clusters.count(mc(first)) <= 4);
            mc(19 : end) = nan;
            m1 = cat(2,m1,mc);
        end
    end
    
    
    getSimpleClusterGrowthOverTime(allData,m1,color);
    end

end


function showGrowthAll(allData, styleStr)
mmm = getSimpleClustersIndices(allData);


    first = 1;

    m1 = [];
    for i = 1:size(mmm,2)
        mc = mmm(:,i);
        if (sum(~isnan(mc)) > 3)
            mc(10 : end) = nan;
            m1 = cat(2,m1,mc);
        end
    end
    
    
    getSimpleClusterGrowthOverTime(allData,m1,styleStr);

end


function showGrowthByAttachTime(allData, styleStr)


mmm = getSimpleClustersIndices(allData);

startTimes = 1:15;
rateByStart = zeros(size(startTimes));
temp = zeros(size(startTimes));


for first = startTimes
    m1 = [];
    for i = 1:size(mmm,2)
        mc = mmm(:,i);
        if (sum(~isnan(mc)) > 5) && (all(isnan(mc(1:first-1)))) && (~isnan(mc(first))) && ...
                (allData(first).clusters.count(mc(first)) >= 2);
            idx = min(first+5, numel(mc));
            mc(idx : end) = nan;
            m1 = cat(2,m1,mc);
        end
    end
    
   
    res = getSimpleClusterGrowthOverTime(allData,m1,[]);
    % exlude non reliable or empty results
    if (size(m1,2) < 3)|| isempty(res.x)
        rateByStart(first) = nan;
    else
        rateByStart(first) = exp(res.m);
        rateByStart(first) = mean(res.y .^ 2);
        
    end
    temp(first) = size(m1,2);
    
    
    
    % write a fucn for this!
    % and use bounding boxes, not images!
    
%     I2 = showSimpleClusterOverTime(allData,m1);
%     imwrite(I2,['C:\school\microscopy\23.5.17\y\clusters_',...
%         num2str(allData(1).conc), ' - ', num2str(allData(1).signal), ' - ',  num2str(first),'.png'])
end

plot(startTimes(~isnan(rateByStart)), rateByStart(~isnan(rateByStart)),[styleStr,'o-'])
end

function showSimpleClustersByLastFrame(allData, last, styleStr)


mmm = getSimpleClustersIndices(allData);

startTimes = 1:15;
rateByStart = zeros(size(startTimes));
temp = zeros(size(startTimes));


    m1 = [];
    for i = 1:size(mmm,2)
        mc = mmm(:,i);
        if (sum(~isnan(mc(1:last))) > 10) &&  (~isnan(mc(last)))
                        idx = min(last-3, numel(mc));
            mc(idx : end) = nan;
            m1 = cat(2,m1,mc);
        end
    end
    

    
    
    
    % and use bounding boxes, not images!
    
     I2 = showSimpleClusterOverTime(allData,m1,2);
     imwrite(I2,['C:\school\microscopy\23.5.17\y\clusters_by_last_',...
         num2str(allData(1).conc), ' - ', num2str(allData(1).signal), ' - ',  num2str(last),'.png'])
end





function allData = setupAllAllData(configName)

allData = config2data(configName);
allData = prepareAllDataGrowth(allData);
allData = get_cluster_evolution(allData);
end



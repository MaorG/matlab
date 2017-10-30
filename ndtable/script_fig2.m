if false
    expDirName = 'C:\simulators\NetLogo 5.2.1\matlab\models\triple_g12_2\';
    expOutName = strcat(expDirName, 'output\');

    % parse input
    allData = parseExperimentDir(expOutName);

    allData = scoreAllData(allData, 'g24', @getPairCorrelation, 4, 2, 4);
    %allData = scoreAllData(allData, 'g22', @getPairCorrelation, 4, 2, 2);
    classifyRuns
    %cruns{1} = cruns{1}(2:end);
    %cruns{2} = [cruns{2}(1) , cruns{2}(3:end)];
end
figure;
temp3_g12_tt (cruns, 'g24', 0, 0, 0, 2)
axis([-inf 40 0 inf 0.6 inf]);
caxis([-0.1 0.1]);
colorbar

% figure;
% temp3_g12_tt (cruns, 'g22', 0, 2, 1, 2)
% axis([4 40 0 inf -inf inf]);
% caxis([-0.05 0.05]);
% colorbar


            

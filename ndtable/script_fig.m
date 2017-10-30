process3

% allData = scoreAllData(allData, 'g14', @getPairCorrelation, 4, 1, 4);
% classifyRuns
% 
% temp3_g12(cruns, 'g14', 0)


allData = allData([allData.time] < 11000);
classifyRuns

for i = 1:numel(allData)
    allData(i).paramA = 0;
    allData(i).paramB = 0;
end
temp2a

% 
% someData = allData([allData.id] == allData(1).id)
% someData = scoreAllData(someData, 'g14', @getPairCorrelation, 4, 1, 4);
% someData = scoreAllData(someData, 'g24', @getPairCorrelation, 4, 1, 4);
% someData = scoreAllData(someData, 'g34', @getPairCorrelation, 4, 1, 4);
% classifyRuns
% 
% temp3_g12(cruns, 'g14', 0)
% temp3_g12(cruns, 'g24', 0)
% temp3_g12(cruns, 'g34', 0)
filteredData = allData;%([allData.time] >= 2000);

classifiedData = [];

classifiedData{1} = filteredData([filteredData.paramA] > 0 & [filteredData.paramB] > 0);
classifiedData{2} = filteredData([filteredData.paramA] > 0 & [filteredData.paramB] == 0);
classifiedData{3} = filteredData([filteredData.paramA] > 0 & [filteredData.paramB] < 0);

classifiedData{4} = filteredData([filteredData.paramA] == 0 & [filteredData.paramB] > 0);
classifiedData{5} = filteredData([filteredData.paramA] == 0 & [filteredData.paramB] == 0);
classifiedData{6} = filteredData([filteredData.paramA] == 0 & [filteredData.paramB] < 0);

classifiedData{7} = filteredData([filteredData.paramA] < 0 & [filteredData.paramB] > 0);
classifiedData{8} = filteredData([filteredData.paramA] < 0 & [filteredData.paramB] == 0);
classifiedData{9} = filteredData([filteredData.paramA] < 0 & [filteredData.paramB] < 0);

scaleColor = true;


figure(305);
suptitle('mix mean')

rtSI = createResultTable([classifiedData{1} ; classifiedData{4} ; classifiedData{7}], 'paramA', 'time', 'mean', 'mix', 1, 2);
subplot(2,3,1)
displayResultTable(rtSI, scaleColor);
title('coop growth - mix')

rtSI = createResultTable([classifiedData{2} ; classifiedData{5}; classifiedData{8}], 'paramA', 'time', 'mean', 'mix', 1, 2);
subplot(2,3,2)
displayResultTable(rtSI, scaleColor);
title('neutral growth - mix')

rtSI = createResultTable([classifiedData{3} ; classifiedData{6};classifiedData{9}], 'paramA', 'time', 'mean', 'mix', 1, 2);
subplot(2,3,3)
displayResultTable(rtSI, scaleColor);
title('inter growth - mix')

rtSI = createResultTable([classifiedData{1} ; classifiedData{4}; classifiedData{7}], 'paramA', 'time', 'mean', 'ratio');
subplot(2,3,4)
displayResultTable(rtSI, false);
title('coop growth - count')

rtSI = createResultTable([classifiedData{2} ; classifiedData{5}; classifiedData{8}], 'paramA', 'time', 'mean', 'ratio');
subplot(2,3,5)
displayResultTable(rtSI, false);
title('neutral growth - count')

rtSI = createResultTable([classifiedData{3} ; classifiedData{6}; classifiedData{9}], 'paramA', 'time', 'mean', 'ratio');
subplot(2,3,6)
displayResultTable(rtSI, false);
title('inter growth - count')

% rtSI = createResultTable([classifiedData{1} ; classifiedData{4}; classifiedData{7}], 'paramA', 'time', 'std','energy');
% subplot(2,3,4)
% displayResultTable(rtSI, scaleColor);
% title('coop growth')
% 
% rtSI = createResultTable([classifiedData{2} ; classifiedData{5}; classifiedData{8}], 'paramA', 'time', 'std','energy');
% subplot(2,3,5)
% displayResultTable(rtSI, scaleColor);
% title('neutral growth')
% 
% rtSI = createResultTable([classifiedData{3} ; classifiedData{6}; classifiedData{9}], 'paramA', 'time', 'std','energy');
% subplot(2,3,6)
% displayResultTable(rtSI, scaleColor);
% title('inter growth')

% 
% figure(303);
% suptitle('homogeneity mean')
% 
% rtSI = createResultTable([classifiedData{1} ; classifiedData{4}; classifiedData{7}], 'paramA', 'time', 'mean','homogeneity');
% subplot(1,3,1)
% displayResultTable(rtSI, scaleColor);
% title('coop growth')
% 
% rtSI = createResultTable([classifiedData{2} ; classifiedData{5}; classifiedData{8}], 'paramA', 'time', 'mean','homogeneity');
% subplot(1,3,2)
% displayResultTable(rtSI, scaleColor);
% title('neutral growth')
% 
% rtSI = createResultTable([classifiedData{3} ; classifiedData{6}; classifiedData{9}], 'paramA', 'time', 'mean','homogeneity');
% subplot(1,3,3)
% displayResultTable(rtSI, scaleColor);
% title('inter growth')

% rtSI = createResultTable([classifiedData{1} ; classifiedData{4}; classifiedData{7}], 'paramA', 'time', 'std','homogeneity');
% subplot(2,3,4)
% displayResultTable(rtSI, scaleColor);
% title('coop growth')
% 
% rtSI = createResultTable([classifiedData{2} ; classifiedData{5}; classifiedData{8}], 'paramA', 'time', 'std','homogeneity');
% subplot(2,3,5)
% displayResultTable(rtSI, scaleColor);
% title('neutral growth')
% 
% rtSI = createResultTable([classifiedData{3} ; classifiedData{6}; classifiedData{9}], 'paramA', 'time', 'std','homogeneity');
% subplot(2,3,6)
% displayResultTable(rtSI, scaleColor);
% title('inter growth')

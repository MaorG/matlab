filteredData = allData;%([allData.time] >= 2000);

classifiedData = classify2mat2D(filteredData, 'paramA', 'paramB');

scaleColor = true;


cruns = cell(size(classifiedData));

%use arrayfunc
for ii = 1:numel(classifiedData.T)

    data = classifiedData.T(ii);
   ids = extractfield(data{1}, 'id');
   ids = unique(ids);
   runs = cell(size(ids(ids~=0)));
   jj = 0;
    for id = ids
        if (id ~= 0) % ???
            jj = jj + 1;
            run = data{1}([data{1}.id] == id);
            times = extractfield(run, 'time');
            [t,order] = sort(times);
            run = run(order);
            runs(jj)= {run};
        end
    end
    
    cruns(ii) = {runs};

end


figure(206);
suptitle('mix mean')

[cols, rows] = size(classifiedData.T);

for i = 1:size(cruns,2)
    subplot(rows,cols,i);
    
    
    
    
    for run = cruns{i}
        rtMix = createResultTable(run{1}, 'paramA', 'time', 'mean', 'mix', 1, 2);
        %rtRatio = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio');
        rtCount = createResultTable(run{1}, 'paramA', 'time', 'mean', 'count');
        y = rtMix.T;
        x = rtMix.valsB;
        z = zeros(size(rtMix.T));
        c = rtCount.T;
        surface([x;x],[y;y],[z;z],[c;c],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',1);
        
        %plot(rtMix.T);
        caxis([0,5000]);
        hold on;
    end
    
        title(['d: ', num2str(cruns{i}{1}(1).paramA), ' g: ', num2str(cruns{i}{1}(1).paramB)]);

    axis([-inf,inf,0,1])
end

% subplot(3,3,1)
% %displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% title('+g +d')
% 
% rtSI = createResultTable([classifiedData{2}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,2)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('0g +d')
% 
% rtSI = createResultTable([classifiedData{3}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,3)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('-g +d')
% 
% rtSI = createResultTable([classifiedData{4}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,4)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('+g 0d')
% 
% rtSI = createResultTable([classifiedData{5}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,5)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('0g 0d')
% 
% rtSI = createResultTable([classifiedData{6}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,6)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('-g 0d')
% 
% rtSI = createResultTable([classifiedData{7}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,7)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('+g -d')
% 
% rtSI = createResultTable([classifiedData{8}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,8)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('0g -d')
% 
% rtSI = createResultTable([classifiedData{9}], 'paramA', 'time', 'mean', 'mix', 1, 2);
% subplot(3,3,9)
% displayResultTable(rtSI, scaleColor);
% plot(rtSI.T);
% axis([-inf,inf,0,1])
% title('-g -d')
% 

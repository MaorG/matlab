%filteredData = allData;%([allData.time] >= 2000);


filteredData = allData;%([allData.time] <= 11000);

classifiedData = classify2mat2D(filteredData, 'paramA', 'paramB');

scaleColor = true;


cruns = cell(size(classifiedData.T));

%use arrayfunc
for ii = 1:numel(classifiedData.T)
    
    data = classifiedData.T(ii);
    if (size(data{1},1) ~= 0)
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
end
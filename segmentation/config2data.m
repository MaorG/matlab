function allData = config2data(configFileName)


formatSpec = '%C';

T = readtable(configFileName,'Delimiter',',');
%, ...
%    'Format',formatSpec);

delim = '\';
           if isunix
                delim = '/';
            elseif ispc
                delim = '\';
            end
allData = [];
for i = 1:height(T)
    if T{i,1}{1}(1) ~= '#'
        C = strsplit(char(T{i,'fullFileName'}),delim);
        dirName = [strjoin(C(1:end-1),delim), delim];
        fileName = C{end};
        data = file2data(dirName, fileName);
        for j = 1:width(T)
            if iscell(T{i,j})
                val = T{i,j}{1};
            else
                val = T{i,j};
            end
            data.(T.Properties.VariableNames{j}) = val;
        end
        allData = [allData; data];
    end
end

end
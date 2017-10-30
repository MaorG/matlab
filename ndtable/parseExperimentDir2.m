function [parsedData] = parseExperimentDir2( dirName, recursive )

fileNames = dir(dirName);

allData = struct.empty;

for i = 1:size(fileNames)
    
    fileName = strcat(dirName, fileNames(i).name);
    if ((length(fileName) > 3) && (strcmp(fileName(end-3:end), '.txt') == 1))
        % open the file
        fid = fopen(fileName);

        % parse the file
        data = parseOutputFile(fid);
        
        
        data = scoreAllData(data, 'p0', @getCountByProperties, 'species', 'dbact1');

data = scoreAllData(data, 'p00', @getCountByProperties, 'species', 'dbact1', 'attached', 0);
data = scoreAllData(data, 'p01', @getCountByProperties, 'species', 'dbact1', 'attached', 1);
data = scoreAllData(data, 'p10', @getCountByProperties, 'species', 'dbact2', 'attached', 0);
data = scoreAllData(data, 'p11', @getCountByProperties, 'species', 'dbact2', 'attached', 1);
data = scoreAllData(data, 'clusters', @getClusters, 2);
data = scoreAllData(data, 'clusterHist', @getClusterHistogram, [power(2,0:10)]);
data = scoreAllData(data, 'clusterHistL', @getClusterHistogramRarefaction, [power(2,0:10)]);
data = scoreAllData(data, 'clusterHist2', @getClusterHistogram, [10:10:1000]);
data = scoreAllData(data, 'clusterHist2L', @getClusterHistogramRarefaction, [10:10:1000]);

data.agents = struct;

        ['parse ', fileName, ' done']        
        % close the file
        fclose(fid);
        allData = [allData ; data];
    end
    if (recursive && isdir(fileName) && strcmp(fileNames(i).name(1), '.') == 0)
        dataRec = parseExperimentDir2([fileName, '/'], true);
        allData = [allData ; dataRec];        
    end
end



parsedData = allData;

end

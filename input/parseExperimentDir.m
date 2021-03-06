function [parsedData] = parseExperimentDir( dirName, recursive, filter )

fileNames = dir(dirName);

allData = struct.empty;

for i = 1:size(fileNames)
    
    fileName = strcat(dirName, fileNames(i).name);
    if ((length(fileName) > 3) && (strcmp(fileName(end-3:end), '.txt') == 1))
        % open the file
        fid = fopen(fileName);

        % parse the file
        
        data = parseOutputFile(fid, filter);
        ['parse ', fileName, ' done']        
        % close the file
        fclose(fid);
        allData = [allData ; data];
    end
    if (recursive && isdir(fileName) && strcmp(fileNames(i).name(1), '.') == 0)
        dataRec = parseExperimentDir([fileName, '/'], true, filter);
        allData = [allData ; dataRec];        
    end
end



parsedData = allData;

end

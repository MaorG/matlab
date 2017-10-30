function [parsedData] = parseDirToImages( dirName, recursive )

fileNames = dir(dirName);

allData = struct.empty;

for i = 1:size(fileNames)
    
    fileName = strcat(dirName, fileNames(i).name);
    if ((length(fileName) > 3) && (strcmp(fileName(end-3:end), '.txt') == 1))
        % open the file
        fid = fopen(fileName);

filter = @(d) (mod(d.ticks, 500) == 0);        
filter = @(d) (1);        
        % parse the file
        data = parseOutputFile(fid, filter);
        ['parse ', fileName, ' done']        
        % close the file
        fclose(fid);
        if (~isempty(data))
            img = getAgentsImageCustom(data, {1});

            imgName = strcat(dirName, num2str(1000000 + data.ticks), '.png');
            imwrite(img,imgName)

            ['written ', fileName, ' done']        
        end
    end
    if (recursive && isdir(fileName) && strcmp(fileNames(i).name(1), '.') == 0)
        dataRec = parseExperimentDir([fileName, '\'], true);
        allData = [allData ; dataRec];        
    end
end



parsedData = allData;

end

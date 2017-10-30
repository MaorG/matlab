function allData = dir2data(dirName, recursive)

    fileNames = dir(dirName);
    allData = [];
    for i = 1:size(fileNames)
    
        srcFileName = strcat(dirName, fileNames(i).name);
        if ((length(srcFileName) > 2) && (strcmp(srcFileName(end-3:end), '.tif') == 1))
            % open the file
            data = file2data(dirName, fileNames(i).name);
            
            allData = [allData; data];
        end
        if (recursive && isdir(srcFileName) && strcmp(fileNames(i).name(1), '.') == 0)
            dataRec = dir2data([srcFileName, '\'], true);
            allData = [allData ; dataRec];        
        end
        
    end

end


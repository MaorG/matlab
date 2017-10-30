function data = file2data(dirName, fileName)


fullName = strcat(dirName, fileName);

data = struct;
data.dirName = dirName;
data.fileName = fileName;
data.I = imread(fullName);

end
function showPropertiesOfCellSegmentation(fileName, propName, thresholds)

%fileName = 'C:\school\microscopy\5.5.17\putida\A1\img_T06_A1.tif';


I = imread(fileName);

S = Segmentation;

S.I = I;

S = S.createLaplacian(3);

mal = struct;

%propName = 'MajorAxisLength';

for th = thresholds
    S.threshold = th;

    S = S.toBinary;

    S = S.getCells;

    expression = '\.';
    replace = '\_';
    fieldname = ['th',  regexprep(num2str(th),expression,replace)]
    mal.(fieldname) = S.getCellsProperty(propName);
    
end

figure
hold on

propOptimalRange = [1:0.5:20];

thresholdResults = [];
for fn = fieldnames(mal)'
    res = cat(1,mal.(fn{1})(:).(propName));
    [N,edges] = histcounts(res,propOptimalRange);
    thresholdResults = [thresholdResults N];
    
    plot((edges(1:end-1)),N);
end
legend(fieldnames(mal)');

% figure;
% plot(thresholds, thresholdResults)

[~, optThrsIdx] = max(thresholdResults);
bestThreshold = thresholds(optThrsIdx);

S.threshold = bestThreshold;
S = S.toBinary;
S = S.getCells;
S = S.getclusters;
imshow(S.BWclusters)


end
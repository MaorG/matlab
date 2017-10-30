function script_live_dead_workbench(allData)

for i = 1:numel(allData)
   x(allData, i);
end


end

function x(allData, ii)
figure
R = allData(ii).deadI;
R = double(R) ./ 65500;
G = allData(ii).liveI;
G = double(G) ./ 65500;
B = zeros(size(R));

imshow(cat(3, R, G ,B));

end

function doStuff(allData, ii)

if (isfield(allData(ii), 'estCellArea'))
    singleCellArea = allData(ii).estCellArea;
else
    singleCellArea = 20;
end

d = allData(ii);
%cc = getLiveDeadInClustersByArea(d, {'liveDeadIntensityCoeff', [1.0,0.75]})
cc = allData(ii).cc;
cc.estCount = cc.areas / singleCellArea;

bins = [0,power(2,0:8)];
[N,edges,bin] = histcounts(cc.estCount,bins);
averageRatioOfBin = zeros(size(N));
for i = 1:numel(N)
    val = i;
    binRatios = cc.liveRatio(find(bin == i));
    averageRatioOfBin(i) = mean(binRatios);
    
    SErrOfBin(i) = std(binRatios) ./ sqrt(numel(binRatios));
    
end


top = averageRatioOfBin;
top(isnan(top)) = 0;
bot = zeros(size(top));
left = bins(1:end-1);
right = bins(2:end);
height = top - bot;
width = right - left;

figure
errorbar(left, height, SErrOfBin, 'ok-','MarkerFaceColor','white');
ylim([0,1])
xlim([0,150])
set(gca,'xscale','log')
end

function doStuff2(allData, ii)

if (isfield(allData(ii), 'estCellArea'))
    singleCellArea = allData(ii).estCellArea;
else
    singleCellArea = 120;
end

d = allData(ii);
%cc = getLiveDeadInClustersByArea(d, {'liveDeadIntensityCoeff', [1.0,0.75]})
cc = allData(ii).cc;
cc.estCount = cc.areas / singleCellArea;



figure
scatter(cc.estCount, cc.liveRatio)

hold on

bins = [0,power(2,0:12)];
[N,edges,bin] = histcounts(cc.estCount,bins);
averageRatioOfBin = zeros(size(N));
for i = 1:numel(N)
    val = i;
    binRatios = cc.liveRatio(find(bin == i));
    averageRatioOfBin(i) = mean(binRatios);
    
    SErrOfBin(i) = std(binRatios) ./ sqrt(numel(binRatios));
    
end


top = averageRatioOfBin;
top(isnan(top)) = 0;
bot = zeros(size(top));
left = bins(1:end-1);
right = bins(2:end);
height = top - bot;
width = right - left;

for i=1:length(top)
    rectangle('Position',[left(i) bot(i) width(i)   height(i) ])
    line([left(i) + right(i),left(i) + right(i)]*0.5, [height(i) + SErrOfBin(i), height(i) - SErrOfBin(i)],'Color','black');
end

% fitobject = fit(cc.areas, cc.liveRatio, 'smoothingspline','SmoothingParam',0.00000000000001);
% hold on
% plot(fitobject)

xlim([min(bins), max(bins)]);
title(allData(ii).dirName);
xlabel('aggregate size - estimated no of cells')
ylabel('ratio of living *pixels*')
set(gca,'xscale','log')

figure
boxplot(cc.liveRatio, bin, 'Labels',  (bins(unique(bin))));
title(allData(ii).dirName);

end
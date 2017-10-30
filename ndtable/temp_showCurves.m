function [] = showPairCorrelationCurves (cruns, gNames, cluster, timeValues)

%  cr = cell([1,2]);
%  cr{1} = cruns{3,3};
%  cr{2} = cruns{3,5};

gNamesCells = cellstr(gNames);

cr = cruns;
% [cols, rows] = size(cr);
% for row = 1:rows
%     for col = 1:cols
%         chosenRun = [];
%         for run = cr{col, row}
%             if (run{1}(1).paramC == cluster)
%                  chosenRun = run;
%             end
%         end
%         cr{col, row} = chosenRun;
%     end
% % end
% 
% hetruns = getRunsByParams(cruns, 'paramA', 0, 'paramB', 0, 'paramC', cluster);
% zMats = cell(size(hetruns));
% for i = 1:numel(hetruns)
%     [~,~, zMat1] = getGSurf(hetruns{i}, gName);
%     zMats{i} = zMat1;
% end
% [minHetZMat, maxHetZMat] = zEnvelope(zMats);

%figure;
[cols, rows] = size(cr);
for row = 1:rows
    for col = 1:cols
        h = subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
        hold on;
        ax=get(h,'Position');
        ax(4)=ax(4)*1.25; 
        ax(3)=ax(3)*1.25; 
        set(h,'Position',ax);
        
        
        hold on;       
        for run = cr{col, row}
            runDatas = run{1};
            for ii = 1:numel(runDatas)
                if sum(runDatas(ii).time == timeValues) > 0 
%                if runDatas(ii).paramC == cluster && sum(runDatas(ii).time == timeValues) > 0 
                    for jj = 1:numel(gNamesCells)
                        gName = gNamesCells(jj);
                        info = runDatas(ii).(gName{1});
                        color = zeros(3,1);
                        color(1) = jj / numel (gNamesCells);
                        color(2) = 1 - jj / numel (gNamesCells);
                        color(3) = ii / numel(runDatas);
                        %plot(info(1,:), info(2,:), 'color', color);
                        plot(info(1,:));
                        hold on;   
                    end
                end
            end
        end
        
        %axis([0,50,0,2]);
        
        title(['d: ', num2str(cr{col, row}{1}(1).paramA), ' g: ', num2str(cr{col, row}{1}(1).paramB)]);
    end
end

suptitle(['cluster size: ', num2str(cluster), ' time: ', num2str(timeValues)]);

end

function [zMin, zMax] = zEnvelope(zMats)

zMax = zMats{1};
zMin = zMats{1};

for i = 2:numel(zMats)
    zMax = max(zMax, zMats{i});
    zMin = min(zMin, zMats{i});
end
end

function [xVec, yVec, zMat] = getGSurf(run, gname)
xVec = zeros(size(run));
yLength = 0;
for ii = 1:size(xVec,1)
    
    data = run(ii);
    corr = data.(gname);
    
    yLength = max (yLength, sum(corr(1,:) < min(size(data.world))*0.5));
end
yVec = zeros(yLength,1);
%zMat = zeros(size(xVec,1), size(yVec,1));
zMat = zeros(size(xVec,1), yLength);
for ii = 1:size(xVec,1)
    
    data = run(ii);
    xVec(ii) = data.time;
    corr = data.(gname);
    
    if ((size(corr(1,:), 2)) > 1)
        if size(corr(1,:), 2) >= yLength
            yVec = corr(1,1:yLength);
        else
            corr = padarray(corr,[2, yLength] - size(corr),'post');
        end

%    end
%    zMat(ii,:) = padarray(corr(2,:),[1, yLength] - size(corr(2,:)),'post');
        zMat(ii,:) = corr(2,1:yLength);
    end
    
end

end
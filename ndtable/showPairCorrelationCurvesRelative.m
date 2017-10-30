function [] = showPairCorrelationCurvesRelative(cruns, gName, cluster, timeValues)

%  cr = cell([1,2]);
%  cr{1} = cruns{3,3};
%  cr{2} = cruns{3,5};

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
hetruns = getRunsByParams(cruns, 'paramA', 0, 'paramB', 0, 'paramC', cluster);
zMats = cell(size(hetruns));
for i = 1:numel(hetruns)
    [~,~, zMat1] = getGSurf(hetruns{i}, gName);
    zMats{i} = zMat1;
end
[minHetZMat, maxHetZMat] = zEnvelope(zMats);

figure;
[cols, rows] = size(cr);
for row = 1:rows
    for col = 1:cols
        subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
        hold on;       
        for run = cr{col, row}
            runDatas = run{1};
            for ii = 1:numel(runDatas)
                if runDatas(ii).paramC == cluster && sum(runDatas(ii).time == timeValues) > 0 
                    info = runDatas(ii).(gName);
                   
                    x = info(1,:);
                    y = info(2,:);
                    z = zeros(size(x));
                    
                    C = zeros(numel(x),3);
                    
                    upperEnv = zeros(size(y));
                    upperEnv(1:size(maxHetZMat,2)) = maxHetZMat(ii,:);
                    lowerEnv = zeros(size(y));
                    lowerEnv(1:size(maxHetZMat,2)) = minHetZMat(ii,:);
                    
                    if (numel(y) == numel(upperEnv))
                        C(:,1) = min(1,0.3 + 0.2 * (y > upperEnv) + 0.5 * (y > upperEnv) .* (y - upperEnv) * 2);
                        C(:,2) = 0.5;
                        C(:,3) = min(1,0.3 + 0.2 * (y < lowerEnv) - 0.5 * (y < lowerEnv) .* (y - lowerEnv) * 2);
                    end
                    CC = max(C(:,3), C(:,1));
                    surface([x;x],[y;y],[z;z],[CC';CC'],...
                        'facecol','no',...
                        'edgecol','interp',...
                        'linew',1);

                    hold on;   
                end
            end
        end
        
        axis([0,50,0,2]);
        
        title(['d: ', num2str(cr{col, row}{1}(1).paramA), ' g: ', num2str(cr{col, row}{1}(1).paramB)]);
    end
end

suptitle([gName, ', cluster size: ', num2str(cluster)]);

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
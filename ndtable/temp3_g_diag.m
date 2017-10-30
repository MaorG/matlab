function [] = temp3_g_diag (cruns, gName, cluster)

 cr = cell([1,2]);
 cr{1} = cruns{3,3};
 cr{2} = cruns{3,5};

cr = cruns;
[cols, rows] = size(cr);




figure;
minMatDia = cell([rows + cols - 1,1]);
maxMatDia = cell([rows + cols - 1,1]);
for row = 1:rows
    calibRuns = cr{1, row};
    
    hetruns = calibRuns;
    zMats = cell(size(hetruns));
    for i = 1:numel(hetruns)
        if (hetruns{i}(1).paramC == cluster)
            [~,~, zMat1] = getGSurf(hetruns{i}, gName);
            zMats{i} = zMat1;
        end
    end
    zMats = zMats(~cellfun(@isempty, zMats));
    [minHetZMat, maxHetZMat] = zEnvelope(zMats);
    minMatDia{row} = minHetZMat;
    maxMatDia{row} = maxHetZMat;
end

for col = 2:cols
    calibRuns = cr{col,1};
    
    hetruns = calibRuns;
    zMats = cell(size(hetruns));
    for i = 1:numel(hetruns)
        if (hetruns{i}(1).paramC == cluster)
            [~,~, zMat1] = getGSurf(hetruns{i}, gName);
            zMats{i} = zMat1;
        end
    end
    zMats = zMats(~cellfun(@isempty, zMats));
    [minHetZMat, maxHetZMat] = zEnvelope(zMats);
    minMatDia{rows + col -1} = minHetZMat;
    maxMatDia{rows + col -1} = maxHetZMat;
end

 for row = 1:rows   
    for col = 1:cols
        subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
        
        zMatSum = zeros(1);
        counter = 0;
        for run = cr{col, row}
            
            if (run{1}(1).paramC == cluster)
                counter = counter + 1;
                [xVec, yVec, zMat1] = getGSurf(run{1}, gName);
                
                if (size(zMat1,1) > size(zMatSum,1) || size(zMat1,2) > size(zMatSum,2))
                    w = max(size(zMat1,1), size(zMatSum,1));
                    h = max(size(zMat1,2), size(zMatSum,2));
                    zMatSum = padarray(zMatSum, [w - size(zMatSum,1), h - size(zMatSum,2)], 'post');
                end
                
                if (size(zMat1,1) < size(zMatSum,1) || size(zMat1,2) < size(zMatSum,2))
                    w = max(size(zMat1,1), size(zMatSum,1));
                    h = max(size(zMat1,2), size(zMatSum,2));
                    zMat1 = padarray(zMat1, [w - size(zMat1,1), h - size(zMat1,2)], 'post');
                end
                
                
                
                zMatSum = zMatSum + zMat1;
            end
        end
        
        zMatSum = zMatSum ./ counter;
        
        hold on;
        
        if (row >= col)
            minHetZMat = minMatDia{row - col + 1};
            maxHetZMat = maxMatDia{row - col + 1};
        else
            minHetZMat = minMatDia{col - row + rows};
            maxHetZMat = maxMatDia{col - row + rows};
        end
        
        C = ones(size(zMatSum,1), size(zMatSum,2), 3) .* 0.3;
        
        
        C(:,:,1) = 0.3 + 0.2 * (zMatSum > maxHetZMat) + 0.5 * (zMatSum > maxHetZMat) .* (zMatSum - maxHetZMat) * 10;
        %C(:,:,2) = (zMat1 < maxHetZMat & zMat1 > minHetZMat);
        C(:,:,3) = 0.3 + 0.2 * (zMatSum < minHetZMat) - 0.5 * (zMatSum < minHetZMat) .* (zMatSum - minHetZMat) * 10;
        surf(yVec, xVec, zMat1, C, 'EdgeColor', 'black');
        %imagesc(C);
        title([num2str(row) ', ' num2str(col) ' d: ', num2str(cr{col, row}{1}(1).paramA), ' g: ', num2str(cr{col, row}{1}(1).paramB)]);
    end
end


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
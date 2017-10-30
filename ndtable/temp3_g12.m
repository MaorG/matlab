function [] = temp3_g12 (cruns, gName, cluster)

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
% end


hetruns = getRunsByParams(cruns, 'paramA', 0, 'paramB', 1);
zMats = cell(size(hetruns));
for i = 1:numel(hetruns)
    [~,~, zMat1] = getGSurf(hetruns{i}, gName);
    zMats{i} = zMat1;
end
[minHetZMat, maxHetZMat] = zEnvelope(zMats);

figure;
colormap(jet);
[cols, rows] = size(cr);
for iii = 1:numel(cruns)
   % for col = 1:cols
        
        if (isempty(cruns{iii}) == 0)
            % subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
            subplot(rows,cols,iii);

            
            zMatSum = zeros(1);
            counter = 0;
            for run = cr{iii}
                

                
                
                if true %row == 3 && col == 3
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
            
            
            
            C = ones(size(zMatSum,1), size(zMatSum,2), 3) .* 0.3;
            
            
            C(:,:,1) = 0.3 + 0.2 * (zMatSum > maxHetZMat) + 0.5 * (zMatSum > maxHetZMat) .* (zMatSum - maxHetZMat) * 2;
            %C(:,:,2) = (zMat1 < maxHetZMat & zMat1 > minHetZMat);
            C(:,:,3) = 0.3 + 0.2 * (zMatSum < minHetZMat) - 0.5 * (zMatSum < minHetZMat) .* (zMatSum - minHetZMat) * 2;
            
            CC = (zMatSum - maxHetZMat);
%            surf(yVec, xVec, zMat1, CC, 'EdgeColor', 'none', 'FaceColor','interp','FaceLighting','gouraud');
            surf(yVec, xVec, zMat1, CC, 'EdgeColor', [0.25, 0.25, 0.25], 'FaceColor','interp','FaceLighting','gouraud');
            %imagesc(C);
            title(['d: ', num2str(cr{iii}{1}(1).paramA), ' g: ', num2str(cr{iii}{1}(1).paramB)]);
           
            
            axis([-inf 28 -inf inf -inf inf]);
        end
%    end
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
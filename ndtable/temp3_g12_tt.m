function [] = temp3_g12_tt (cruns, gName, eA, eB, rA, rB)


envruns = getRunsByParams(cruns, 'paramA', eA, 'paramB', eB);
zMats = cell(size(envruns));
for i = 1:numel(envruns)
    [~,~, zMat1] = getGSurf(envruns{i}, gName);
    zMats{i} = zMat1;
end
[minHetZMat, maxHetZMat] = zEnvelope(zMats);
minHetZMat = minHetZMat - 0.00;
maxHetZMat = maxHetZMat + 0.00;
%  [xVec, yVec, zMat1] = getGSurf(envruns{1}, gName);
%  s1 = surf(yVec, xVec, minHetZMat, 'EdgeColor', [0.25, 0.25, 0.25], 'FaceColor',[0.25, 0.25, 0.25],'FaceLighting','gouraud');
%  alpha(s1, 0.5);
%  hold on;
%  [xVec, yVec, zMat1] = getGSurf(envruns{1}, gName);
%  s1 = surf(yVec, xVec, maxHetZMat, 'EdgeColor', [0.25, 0.25, 0.25], 'FaceColor',[0.25, 0.25, 0.25],'FaceLighting','gouraud');
%  alpha(s1, 0.5);


%%%%%%%%%%%%%%%%%%%%%%%

relruns = getRunsByParams(cruns, 'paramA', rA, 'paramB', rB);

zMatSum = zeros(1);
counter = 0;
for run = relruns
    
    
    
    
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

CC = (zMatSum > maxHetZMat) .* (zMatSum - maxHetZMat) + (zMatSum < minHetZMat) .* (zMatSum - minHetZMat);
%            surf(yVec, xVec, zMat1, CC, 'EdgeColor', 'none', 'FaceColor','interp','FaceLighting','gouraud');
surf(yVec, xVec, zMat1, CC, 'EdgeColor', [0.25, 0.25, 0.25], 'FaceColor','interp','FaceLighting','gouraud');
%title(gName);
%%%%%%%%%%%%%%%%%%%%%%%


mapR = 1.0:-0.1:0.0;
mapG = [0.0: 0.1 : 0.5 , 0.4 : -0.1 : 0.0] * 0.5 + 0.25;
mapB = 0.0:0.1:1.0;

coeff = 0:0.2*pi:2*pi;
coeff = sin(coeff) .* 0.2 + 0.8;

map = [mapR; mapG; mapB]';
map(:,1) = map(:,1) .* coeff';
map(:,2) = map(:,2) .* coeff';
map(:,3) = map(:,3) .* coeff';

map = map .* 0.8 + 0.2;

colormap(map);




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
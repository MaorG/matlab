function [] = tempctpc2 (cruns)

figure();

hetruns = getRunsByParams(cruns, 'paramA', 0, 'paramB', 0, 'paramC', -3);
zMats = cell(size(hetruns));
for i = 1:numel(hetruns)
    [~,~, zMat1] = getGSurf(hetruns{i}, 'g12');
    zMats{i} = zMat1;
end
[minHetZMat, maxHetZMat] = zEnvelope(zMats); 


runs = getRunsByParams(cruns, 'paramA', -1, 'paramB', 1, 'paramC', -3);

run = runs{4};

[xVec, yVec, zMat1] = getGSurf(run, 'g12');
hold on;

% surf(yVec, xVec, maxHetZMat, 'FaceColor','yellow','EdgeColor','none');
% surf(yVec, xVec, minHetZMat, 'FaceColor','green','EdgeColor','none');


C = zeros(size(zMat1,1), size(zMat1,2), 3);
C(:,:,1) = (zMat1 > maxHetZMat) ;
C(:,:,2) = (zMat1 < maxHetZMat & zMat1 > minHetZMat);
C(:,:,3) = (zMat1 < minHetZMat);
%surf(yVec, xVec, zMat1, C);
hold on;
runs = getRunsByParams(cruns, 'paramA', -1, 'paramB', 1, 'paramC', -3);

run = runs{4};

[xVec, yVec, zMat1] = getGSurf(run, 'g12');
hold on;

C = ones(size(zMat1,1), size(zMat1,2), 3) .* 0.5;


C(:,:,1) = 0.5 + 10 * (zMat1 > maxHetZMat) .* (zMat1 - maxHetZMat) ./ maxHetZMat;
%C(:,:,2) = (zMat1 < maxHetZMat & zMat1 > minHetZMat);
C(:,:,3) = 0.5 + (zMat1 < minHetZMat) .* (zMat1 - minHetZMat)./ minHetZMat;
surf(yVec, xVec, zMat1, C);
hold on;

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
    
    yLength = max (yLength, numel(corr(1,:)));
end
yVec = zeros(yLength,1);
%zMat = zeros(size(xVec,1), size(yVec,1));
zMat = zeros(size(xVec,1), yLength);
for ii = 1:size(xVec,1)
     
    data = run(ii);
    xVec(ii) = data.time;
    corr = data.(gname);
    if (size(corr(1,:)') == size(yVec)) 
        %yVec = padarray(corr(1,:),[1, yLength] - size(corr(1,:)),'post');
        yVec = corr(1,:);
    end
    zMat(ii,:) = padarray(corr(2,:),[1, yLength] - size(corr(2,:)),'post');
    
end

end


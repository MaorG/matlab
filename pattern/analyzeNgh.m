function density = analyzeNgh(est, col, radius, randomize)

% get density at nieghborhood of different radii

% get points of colonizations

pts = getCenters(col);

if randomize
    xmax = size(col,1);
    ymax = size(col,2);
    ptcount = size(pts,1);
    x1 = rand(ptcount,1)*xmax;
    y1 = rand(ptcount,1)*ymax;

    pts = [x1,y1];
end

columns = size(est,1);
rows = size(est,2);


% get pixels of established population

density = zeros(size(pts,1),1);

    blankPaddedMask = false(size(est));
    blankPaddedMask = padarray(blankPaddedMask, [radius, radius]);
    circleMask = false(2*radius + 1, 2*radius + 1);
    [x, y] = meshgrid(1:(2*radius + 1), 1:(2*radius + 1)); 
    circleMask((x - radius - 1).^2 + (y - radius - 1).^2 <= radius.^2) = true; 
    circleMaskArea = sum(circleMask(:));
    for i = 1:size(pts,1)
        
        ptx = round(pts(i,2));
        pty = round(pts(i,1));

        if (ptx <= radius || ptx >= columns - radius || pty <= radius || pty >= rows - radius)
            density(i) = nan;
        else
            ngh = est( (ptx - radius) : (ptx + radius), (pty - radius) : (pty + radius));
            density(i) = sum(sum(circleMask & ngh)) / circleMaskArea;
        end
            
            
        
%         mask = embedMask(blankPaddedMask, circleMask, ptx, pty, radius);
%         count(i) = sum(sum(mask & est));

    end

end

function mask = embedMask(blankPadded, circleMask, centerX, centerY, radius)
%     columns = size(blankPadded,1);
%     rows = size(blankPadded,2);
%     circleMask = false(2*radius + 1, 2*radius + 1);
%     [x, y] = meshgrid(1:(2*radius + 1), 1:(2*radius + 1)); 
%     circleMask((x - radius - 1).^2 + (y - radius - 1).^2 <= radius.^2) = true; 

%    blankPadded = padarray(blankPadded, [radius, radius]);
    cX = round(centerX);
    cY = round(centerY);
    blankPadded(cY:(cY + 2*radius),cX:(cX + 2*radius)) = circleMask;
    mask = blankPadded((1+radius):(end-radius), (1+radius):(end-radius));
end

function pts = getCenters(bw)

Lgfp = logical(bw);
Sgfp = regionprops(Lgfp, 'Area', 'Centroid', 'PixelIdxList');
area_values_gfp = [Sgfp.Area];
centroids = cat(1, Sgfp.Centroid);
idx = find(10 <= area_values_gfp);
pts = [centroids(idx,1),centroids(idx,2)];

end
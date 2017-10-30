function big = showSimpleClusterOverTime(series, m_cidx,dispType)
if dispType == 1
    big = showSimpleClusterOverTimeLeft(series, m_cidx);
else
    big = showSimpleClusterOverTimeRight(series, m_cidx);
end
end
function big = showSimpleClusterOverTimeLeft(series, m_cidx)
% assuming sidx and cidx point to a simple cluster!
allImages = cell(size(m_cidx,1), size(m_cidx,2));

for clusterId = 1:size(m_cidx,2)
    images = getAllImages(series, m_cidx(:,clusterId));
    allImages(:,clusterId) = images;
end

totalWidth = 0;
totalHeight = 0;

for j = 1:size(allImages,2)
    rowHeight = 0;
    rowWidth = 0;
    for i = 1:size(allImages,1)
        [h,w] = size(allImages{i,j});
        rowWidth = rowWidth + w + 1;
        rowHeight = max(rowHeight, h);
    end
    totalWidth = max(rowWidth, h);
    totalHeight = totalHeight + rowHeight + 1;
end

big = zeros(totalHeight, totalWidth);

currY = 1;
for j = 1:size(allImages,2)
    rowHeight = 1;
    currX = 1;
    for i = 1:size(allImages,1)
        [h,w] = size(allImages{i,j});
        rowHeight = max(rowHeight, h);
        big(currY:currY + h - 1, currX:currX + w - 1) = allImages{i,j};
        currX = currX + w + 1;
        big(currY:currY + h - 1,currX - 1) = 1;
    end
    currY = currY + rowHeight + 1;
    big(currY-1,:) = 1;
end



end

function big = showSimpleClusterOverTimeRight(series, m_cidx)
allImages = cell(size(m_cidx,1), size(m_cidx,2));

for clusterId = 1:size(m_cidx,2)
    images = getAllImages(series, m_cidx(:,clusterId));
    allImages(:,clusterId) = images;
end

margin = 3;
totalWidth =  margin;
totalHeight = margin;

for j = 1:size(allImages,2)
    rowHeight = margin;
    rowWidth = margin;
    for i = 1:size(allImages,1)
        [h,w] = size(allImages{i,j});
        if(h > 0)
            rowWidth = rowWidth + w + 2 * margin;
            rowHeight = max(rowHeight, h + margin);
        end
    end
    totalWidth = max(rowWidth, totalWidth);
    totalHeight = totalHeight + rowHeight + margin;
end

big = zeros(totalHeight, totalWidth);

currY = 1;
for j = 1:size(allImages,2)
    rowHeight = 1;
    currX = totalWidth;
    for i = size(allImages,1):-1:1
        [h,w] = size(allImages{i,j});
        rowHeight = max(rowHeight, h);
    end
    for i = size(allImages,1):-1:1
        [h,w] = size(allImages{i,j});
        if (h > 0)
            big(currY+ floor(rowHeight/2) - floor(h/2):currY+ floor(rowHeight/2) + ceil(h/2) - 1, currX - w + 1:currX) = allImages{i,j};
            currX = currX - w - margin;
            big([(currY:currY + margin),(currY+rowHeight - margin:currY+rowHeight + 1)],currX  + 1 + floor(margin / 2)) = 1;
        end
    end
    currY = currY + rowHeight + margin;
    big(currY - floor(margin / 2),:) = 1;
end



end




function [images, v_cidx] = getAllImages(series, v_cidx)

images = cell(numel(series), 1);


for sidx = 1:numel(v_cidx)
    cidx = v_cidx(sidx);
    if (~isnan(cidx))
        images{sidx} = series(sidx).clusters.Images{cidx};
    end
end


end
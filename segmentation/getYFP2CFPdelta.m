function delta = getYFP2CFPdelta(YFPdata,CFPdata,verbose)

imageSize = size(YFPdata.Seg.BWcells);

% in principle, segmented BF cells appear only in the BF pic, while GFP
% cells appear in both.
% the recipe to compare the 2 cell segmentation images:
% if a BF cell has response in GFP image, remove from segmented image

% BFBWcells = false(size(BFdata.Seg.BWcells));
% BFcells = getCellsInBWImage(BFdata.Seg.BWcells);
% for i = 1:numel(BFcells.areas)
%     cellPixels = BFcells.pixels{i};
%     linear = sub2ind(imageSize, cellPixels(:,2), cellPixels(:,1));
%     hasGFP = sum(GFPdata.Seg.BWcells(linear));
%     if true && ~hasGFP
%         suspectIdx(i) = 0;
%         BFBWcells(linear) = 1;
%     end
% end

delta = YFPdata;
delta.SegYFP = delta.Seg;
delta.SegCFP = CFPdata.Seg;





end

function cells = getCellsInBWImage(I)

% push into a func!
cells = struct;
CC = bwconncomp(I);
rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
centers = cat(1, rp.Centroid);
pixels = cell(numel(rp),1);
for ii = 1:numel(rp)
    pixels{ii} = rp(ii).PixelList;
end
areas = cat(1, rp.Area);
ids = find(areas > 10 & areas < 500);
cells.centers = centers(ids,:);
cells.areas = areas(ids,:);
cells.pixels = pixels(ids,:);
end
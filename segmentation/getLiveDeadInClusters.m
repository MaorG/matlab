function [clusters] = getLiveDeadInClusters(data, varargin)

props = parseInput(varargin{1});

S = data.(props.SegName);
liveI = data.(props.liveImgName);
deadI = data.(props.deadImgName);
w = (props.liveDeadIntensityCoeff);

cellsCC = bwconncomp(S.BWcells);
LabeledCells = labelmatrix(cellsCC);

rp = regionprops(cellsCC, 'PixelIdxList');

clusters = data.clusters;
clusters.liveRatio = nan(numel(clusters.cellIds), 1);

% idxs = cell(numel(clusters.cellIds), 1);
% for i = 1:numel(LabeledCells)
%     if (LabeledCells(i) ~= 0)
%         idxs{LabeledCells(i)} = [idxs{LabeledCells(i)}, i]; 
%     end
% end


IliveTemp = zeros(size(data.I));
IdeadTemp = zeros(size(data.I));

for i = 1:numel(clusters.cellIds)
   
    ids = clusters.cellIds{i};
    
    liveCount = 0;
    deadCount = 0;
    
    for id = ids'
        
%        idx2 = find(LabeledCells == id);
        
        idx = rp(id).PixelIdxList;
        
        cellLife = sum(liveI(idx)) * w(1);
        cellDeath = sum(deadI(idx)) * w(2);
        
        if (cellLife > cellDeath)
            liveCount = liveCount + 1;
            IdeadTemp(idx) = 1;
        else
            deadCount = deadCount + 1;
            IliveTemp(idx) = 1;
        end
        
    end
    
    clusters.liveRatio(i) = liveCount ./ (liveCount + deadCount) ;
    
end

figure;

halo = S.BWclusters - S.BWcells;
halo = 0.25 * halo;
imshow(cat(3,IliveTemp + halo,IdeadTemp + halo,halo));

end

function props = parseInput(varargin)
    props = struct(...
        'SegName','Seg',...
        'liveImgName', 'liveI',...
        'deadImgName', 'deadI',...
        'liveDeadIntensityCoeff', [1,1]...
    );
    
    for i = 1:numel(varargin{1})
        if strcmpi(varargin{1}{i}, 'SegName')
            props.SegName = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'liveImgName')
            props.liveImgName = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'deadImgName')
            props.deadImgName = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'liveDeadIntensityCoeff')
            props.liveDeadIntensityCoeff = varargin{1}{i+1};
        end
    end
end
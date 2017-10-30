function [clusters] = getLiveDeadInClustersByArea(data, varargin)

props = parseInput(varargin{1});

liveI = data.(props.liveImgName);
deadI = data.(props.deadImgName);
w = (props.liveDeadIntensityCoeff);
imageSize = size(liveI);

clusters = data.clusters;
clusters.liveRatio = nan(numel(clusters.pixels), 1);

IliveTemp = zeros(size(data.I));
IdeadTemp = zeros(size(data.I));

for i = 1:numel(clusters.pixels)
   
    pixels = clusters.pixels{i};
    px = pixels(:,1);
    py = pixels(:,2);
        
    indices = sub2ind(imageSize, py, px);
    liveCount = 0;
    deadCount = 0;
    
    for idx = indices'
        
%        idx2 = find(LabeledCells == id);
        
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

if (strcmp(props.verbose, '1'))
    figure;
    imshow(cat(3,IliveTemp,IdeadTemp,zeros(size(IliveTemp))));
end

end

function props = parseInput(varargin)
    props = struct(...
        'liveImgName', 'liveI',...
        'deadImgName', 'deadI',...
        'liveDeadIntensityCoeff', [1,1],...
        'verbose', '0' ...
    );
    
    for i = 1:numel(varargin{1})
        if strcmpi(varargin{1}{i}, 'liveImgName')
            props.liveImgName = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'deadImgName')
            props.deadImgName = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'liveDeadIntensityCoeff')
            props.liveDeadIntensityCoeff = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'verbose')
            props.verbose = varargin{1}{i+1};
        end
    end
end
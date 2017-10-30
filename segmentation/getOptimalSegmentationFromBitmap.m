function [Seg] = getOptimalSegmentationFromBitmap (data, varargin)
props = parseVarargin(varargin{1});
Seg = Segmentation;

Seg.I = data.(props.imageName);
if (~isempty(props.sampleRect))
    Seg.I = Seg.I(props.sampleRect(1):props.sampleRect(2),props.sampleRect(3):props.sampleRect(4));
end
Seg = Seg.createLaplacian(props.laplacianSize);
Seg.clusterDilateRadius = props.clusterDilateRadius;

thresholds = props.thresholds;
optimalPropNames = props.optimalPropNames;
optimalPropRanges = props.optimalPropRanges;


scores = struct;
for th = thresholds
    Seg.threshold = th;
    
    Seg = Seg.toBinary;
    Seg = Seg.getCells;
    
    
    expression = '\.';
    replace = '\_';
    thresholdStr = ['th',  regexprep(num2str(th),expression,replace)];

    scores.(thresholdStr) = struct;
    for pidx = 1:numel(optimalPropNames)
        scores.(thresholdStr).(optimalPropNames{pidx}) = Seg.getCellsProperty(optimalPropNames{pidx});
    end
    
%     figure;
%     imshow(Seg.BWcells);
%     title(thresholdStr);
end

thresholdResults = [];
scoresMat = nan(numel(thresholds), numel(optimalPropNames)+1);
    
    tempi = 1;
    
for thresholdStr = fieldnames(scores)'

    thvals = nan(numel(scores.(thresholdStr{1}).(optimalPropNames{1})),numel(optimalPropNames));
    res = true(numel(scores.(thresholdStr{1}).(optimalPropNames{1})),1);
    for pidx = 1:numel(optimalPropNames)
        range = optimalPropRanges{pidx};

        % voodoo
        vals = cat(1,scores.(thresholdStr{1})(:).(optimalPropNames{pidx}));
        vals = cat(1,vals.(optimalPropNames{pidx}));
        
        if numel(vals > 0)
            thvals(:, pidx) = vals;
        end
        valsInRange = (vals >= range(1) & vals < range(2));
        

        if(~isempty(valsInRange))
            res = res & valsInRange;
        end
        s = valsInRange * 2 - 1;

        scoresMat(tempi,pidx) = sum(res);

    end
    
    


    thresholdResults = [thresholdResults, sum(s)];
end

% figure
% h = plot(scoresMat')
% set(gca, 'yscale','log');
% legend(fieldnames(scores)');

[~, optThrsIdx] = max(thresholdResults);
bestThreshold = thresholds(optThrsIdx);

Seg.I = data.(props.imageName);
Seg.threshold = bestThreshold;
Seg = Seg.toBinary;
Seg = Seg.getCells;
end


function props = parseVarargin(v)

% default:
props = struct(...
    'imageName', 'I',...
    'laplacianSize', 3, ...
    'thresholds', 0.2:0.05:0.8,...
    'optimalPropNames', {'MinorAxisLength'},...
    'optimalPropRanges', {[3,4]},...
    'clusterDilateRadius', 6, ...
    'sampleRect', [] ...
    );

for i = 1:numel(v)
    
    if (strcmp(v{i}, 'imageName'))
        props.imageName = v{i+1};
    elseif (strcmp(v{i}, 'laplacianSize'))
        props.laplacianSize = v{i+1};
    elseif (strcmp(v{i}, 'thresholds'))
        props.thresholds = v{i+1};
    elseif (strcmp(v{i}, 'optimalPropNames'))
        props.optimalPropNames = v{i+1};
    elseif (strcmp(v{i}, 'optimalPropRanges'))
        props.optimalPropRanges = v{i+1};
    elseif (strcmp(v{i}, 'clusterDilateRadius'))
        props.clusterDilateRadius = v{i+1};
    elseif (strcmp(v{i}, 'sampleRect'))
        props.sampleRect = v{i+1};
    end
    
    
end

end

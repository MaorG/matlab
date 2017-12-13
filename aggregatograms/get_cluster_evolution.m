function series = get_cluster_evolution(series, varargin)

props = parseVarargin(varargin{1});

minArea = props.minArea;

for i = numel(series)-1:-1:1
    [ 'series ' , num2str(i) ]
    
    [matchNext, matchPrev] = OverlappingClusters(series(i).(props.clustersName), series(i+1).(props.clustersName),minArea);
    series(i).(props.clustersName).nextIds = matchNext;
    series(i+1).(props.clustersName).prevIds = matchPrev;
end


% for i = 1:numel(series)
%     series(i).clusters.growth = get_growth_vs_count_frame(series, i);
% end

end

function growth = get_growth_vs_count_frame(series, idx)

growth = nan * zeros(numel(series(idx).clusters.count),1);

for j = 1:numel(series(idx).clusters.areas)
    if (any(strcmp('prevIds',fieldnames(series(idx).clusters))) && ...
            ~isempty(series(idx).clusters.prevIds{j}))
        oldCount = 0;
%         for ii = 1:numel(series(idx).clusters.prevIds{j})
%             id = series(idx).clusters.prevIds{j}(ii);
%             oldCount = oldCount + series(idx-1).clusters.count(id);
%         end
        if (numel(series(idx).clusters.prevIds{j}) == 1)
            id = series(idx).clusters.prevIds{j}(1);
            oldCount = oldCount + series(idx-1).clusters.count(id);  
        end
        growth(j) = series(idx).clusters.count(j) / oldCount;
            
    end
    
end

end


function [matchNext, matchPrev] = OverlappingClusters(bot, top, minArea)
matchNext = cell(numel(bot.pixels), 1);
matchPrev = cell(numel(top.pixels), 1);

% for each top cluster, find all bottom clusters that overlap it.
for topi = 1:numel(top.pixels)
    
    if top.areas(topi) < minArea
        continue;
    end
     topx = top.pixels{topi}(:,1);
     topy = top.pixels{topi}(:,2);
%     maxtopx = max(topx);
%     maxtopy = max(topy);
%     mintopx = min(topx);
%     mintopy = min(topy);
%     
    BBtop = ceil(top.BB(topi,:));
    mintopx = BBtop(1);
    mintopy = BBtop(2);
    maxtopx = BBtop(3);
    maxtopy = BBtop(4);
    
    for boti = 1:numel(bot.pixels)
        
        if bot.areas(boti) < minArea
            continue;
        end
         botx = bot.pixels{boti}(:,1);
         boty = bot.pixels{boti}(:,2);
%         
%         maxbotx = max(botx);
%         maxboty = max(boty);
%         minbotx = min(botx);
%         minboty = min(boty);
        BBbot = ceil(bot.BB(boti,:));
        minbotx = BBbot(1);
        minboty = BBbot(2);
        maxbotx = BBbot(3);
        maxboty = BBbot(4);

        % bounding boxes intersect?
        if true || (~ (maxtopx < minbotx || maxbotx < mintopx) && ...
                 ~ (maxtopy < minboty || maxboty < mintopy) )
            
            [~,xi,~] = intersect(botx, topx);
            [~,yi,~] = intersect(boty, topy);
            
            found = intersect(xi,yi);
            if (~isempty(found))
                matchNext{boti} = [matchNext{boti}, topi];
                matchPrev{topi} = [matchPrev{topi}, boti];
            end
            
        end
    end
    
    
end



end

function props = parseVarargin(v)
% default:
props = struct(...
    'clustersName', 'clusters',...
    'minArea', 100 ...
    );

for i = 1:numel(v)
    
    if (strcmp(v{i}, 'clustersName'))
        props.clustersName = v{i+1};
    elseif (strcmp(v{i}, 'minArea'))
        props.minArea = v{i+1};
    end
end

end

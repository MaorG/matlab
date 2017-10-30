function show_cluster_evo_count(series)

%show_tracking_frame(series, 8)
%show_tracking(series)
show_growth_vs_count(series)


end

function show_growth_vs_count(series)

figure;
hold on;

colors = hsv(numel(series));
for i = 1:numel(series)
    show_growth_vs_count_frame(series, i, colors(i,:));
    
end
% set(gca, 'XScale', 'log');
% set(gca, 'YScale', 'log');
end

function show_growth_vs_count_frame(series, idx, color)

growth = nan * zeros(numel(series(idx).clusters.count),1);

for j = 1:numel(series(idx).clusters.count)
    if (any(strcmp('prevIds',fieldnames(series(idx).clusters))) && ...
            ~isempty(series(idx).clusters.prevIds{j}))
        oldCount = 0;
%         for ii = 1:numel(series(idx).clusters.prevIds{j})
%             id = series(idx).clusters.prevIds{j}(ii);
%             oldCount = oldCount + series(idx-1).clusters.count(id);
%         end
        if (series(idx).clusters.count(j) > 10) && (numel(series(idx).clusters.prevIds{j}) ==1)
            id = series(idx).clusters.prevIds{j}(1);
            oldCount = oldCount + series(idx-1).clusters.count(id);
        end
        growth(j) = series(idx).clusters.count(j) / oldCount; 
    end
    
end

counts = (series(idx).clusters.count);
scatter(counts,growth,'.','MarkerEdgeColor',color);


vidx = find(~isnan(growth) & ~isinf(growth) & growth < 3);

linearCoefficients = polyfit(counts(vidx), growth(vidx), 1);

xFit = linspace(min(counts), max(counts));
% Get the estimated values with polyval()
yFit = polyval(linearCoefficients, xFit);
% Plot the fit
plot(xFit, yFit, 'Color', color, 'LineWidth', 2);

% set(gca, 'XScale', 'log');
% set(gca, 'YScale', 'log');


end

function show_area_evo(series)

figure
hold on

for i = 1:numel(series)
    scatter(i*ones(size(series(i).clusters.areas)), (series(i).clusters.areas))
    
end

for i = 1:numel(series)-1
    for j = 1:numel(series(i).clusters.areas)
        if (~isempty(series(i).clusters.nextIds{j}))
            id = series(i).clusters.nextIds{j};
            x1 = i;
            x2 = i+1;
            y1 = series(i).clusters.areas(j);
            y2 = series(i+1).clusters.areas(id);
            plot([x1,x2],([y1,y2]));
        end
        
    end
    
end
set(gca, 'YScale', 'log');
end

function show_tracking(series)

figure;
imshow(series(end).Seg.BWcells);
hold on

colors = hsv(numel(series)-1);

for i = 1:numel(series)-1
    show_single_tracking(series(i).clusters, series(i+1).clusters, colors(i,:));
end

end

function show_tracking_frame(series, idx)

figure;

B = zeros(size(series(idx).I));

RGB = cat(3, series(idx).I, series(idx+1).I, B);

imshow(RGB);
hold on

show_single_tracking(series(idx).clusters, series(idx+1).clusters, [0,0,1]);

end

function show_single_tracking(clustersBegin, clustersEnd, color)

x1 = clustersBegin.centers(:,1);
y1 = clustersBegin.centers(:,2);

x2 = x1;
y2 = y1;

for i = 1:numel(x1)
    for ii = 1:numel(clustersBegin.nextIds{i})
        id = clustersBegin.nextIds{i}(ii);
        
        x2 = clustersEnd.centers(id,1);
        y2 = clustersEnd.centers(id,2);
        plot([x1(i),x2],[y1(i),y2],'Color', color);
        scatter([x1(i)],[y1(i)],'x','MarkerEdgeColor',color,'MarkerFaceColor',color,...
            'LineWidth',1);
        scatter([x2],[y2],'o','MarkerEdgeColor',color,'MarkerFaceColor',color,...
            'LineWidth',1);
    end
end





end
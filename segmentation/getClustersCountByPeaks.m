function clusters = getClustersCountByPeaks(data)
    clusters = data.clusters;
    clusters.count2 = zeros(size(clusters.count));
    %clusters.Images2
    for i = 1:numel(clusters.count)
         CI = clusters.Images{i};
         CI = CI == 1;
         
         BW = bwulterode(CI);
         c1 = clusters.count(i);
         c2 = numel(unique(bwlabel(BW)))-1;
         clusters.count2(i) = c2;
         
    end
end
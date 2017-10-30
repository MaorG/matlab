function [data] = simbasic (strat)

CN = 1000;
area = 10000;
CC = 100000;
wet = 0;
maxtime = 400;

swimming_growth_wet = 1;
sitting_growth_wet = 0.07;
swimming_growth_dry = 0.05;
sitting_growth_dry = 0.035;

small_death_wet = 0.0;
big_death_wet = 0.00;
small_death_dry = 0.08;
big_death_dry = 0.00;

big_thresh = 50;

detach_chance = 0.002;
attach_chance = 0.0000;
attach_to_cluster_coeff = 1;
%strat = 4;

swimming = 1000;
clusters = zeros(CN,1);
clusters_delta = zeros(CN,1);

clusters(1:40) = (1:40) ./ 1 ;

time = 0;
data = struct;
data.clusters = zeros(maxtime, CN);
data.swimming = zeros(maxtime,1);

flag = 0;

while (time < maxtime)
    time = time + 1;
    if (mod(time,20) < 10)
        swimming_growth = swimming_growth_wet;
        sitting_growth = sitting_growth_wet;
        small_death = small_death_wet;
        big_death = big_death_wet;
    else 
        swimming_growth = swimming_growth_dry;
        sitting_growth = sitting_growth_dry;
        small_death = small_death_dry;
        big_death = big_death_dry;
    end        
    
    % growth
    tot = swimming + sum(clusters);
    swimming_growth = (swimming_growth) * swimming * (1 - tot/CC);
    clusters_growth =  (sitting_growth) * clusters * (1 - tot/CC) .* (1 - clusters ./ 3000);
    swimming = swimming + swimming_growth;
    clusters = clusters + clusters_growth;
    
    % death
    swimming_death = swimming * (small_death);
    swimming = swimming - swimming_death;
    clusters_death = (clusters < big_thresh) .* (small_death) .* clusters + (clusters >= big_thresh) .* (big_death) .* clusters;
    clusters = clusters - clusters_death;
    
    % detach
    clusters_detach =  (detach_chance) * clusters;
    clusters = clusters - clusters_detach;
    swimming = swimming + sum(clusters_detach);
    
    % attach
    % attach to a cluster
    % chance of attachment to a specific cluster =
    % [cluster size] / [world area]) * [attachment strategy(cluster size)]
    attachment_to_cluster_chance = attach_to_cluster_coeff .* (sqrt(clusters)).* (clusters > strat) ./ area;

    cum_attach = min(cumsum(attachment_to_cluster_chance), 1.0);
    cum_attach = (cum_attach * swimming);
    clusters_attach = [cum_attach(1); diff(cum_attach)];
    clusters = clusters + clusters_attach;
    swimming = swimming - sum(clusters_attach);
    if (flag == 0 && sum(attachment_to_cluster_chance) > 0)
       flag = 1;
    end
    % attach random:
    % attachment_chance = attach_alone_coeff;
    clusters_attach =  (attach_chance) * (clusters == 0);
    clusters = clusters + clusters_attach;
    swimming = swimming - sum(clusters_attach);
    
    % detach
    clusters_detach = clusters  * detach_chance;
    clusters = clusters - clusters_detach;
    swimming = swimming + sum(clusters_detach);
    
    data.clusters(time,:) = clusters;
    data.swimming(time) = swimming;

%     formatSpecSwi = 'swi: %.2f | born %.2f | dead %.2f | attach %.2f \n';
%     formatSpecSit = 'sit: %.2f | born %.2f | dead %.2f | detach %.2f | mean %.2f | max %.2f \n';
%     fprintf(formatSpecSwi, swimming, swimming_growth, swimming_death, sum(clusters_attach)); 
%     fprintf(formatSpecSit, sum(clusters), sum(clusters_growth), sum(clusters_death), sum(clusters_detach), mean(clusters(clusters > 0)), max(clusters)); 

    
end

end
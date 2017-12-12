function plot2d(m, mode)
    
if (strcmp(mode, 'single'))
    plot2d1(m);
elseif (strcmp(mode, 'combo'))
    plot2dcombo(m);
elseif (strcmp(mode, 'combo_dual_axes'))
    plot2dcombo_dual(m);
end

end

function plot2d1(m)

r = m;



% hold on;
% errorbar(r(1,:), r(2,:), r(3,:));
% scatter(r(1,:), r(2,:),[],r(4,:)./(r(4,:) + r(5,:)));
% 
% errorbar(mean(r(1,:)), p(1), p(2));
% scatter(mean(r(1,:)), p(1),[],p(3)./(p(3) + p(4)));
% caxis([0,1]);
% ylim([0,2000]);

plot(r(1,:),r(4,:)./(r(4,:) + r(5,:)));
hold on;
scatter(mean(r(1,:)),p(3)./(p(3) + p(4)));
ylim([0,1]);

end

function plot2dcombo(m)

r = m(1).r{1};
p = m(1).p{1};


% hold on;
% errorbar(r(1,:), r(2,:), r(3,:));
% scatter(r(1,:), r(2,:),[],r(4,:)./(r(4,:) + r(5,:)));
% 
% errorbar(mean(r(1,:)), p(1), p(2));
% scatter(mean(r(1,:)), p(1),[],p(3)./(p(3) + p(4)));
% caxis([0,1]);
% ylim([0,2000]);

plot(r(1,:),r(4,:)./(r(4,:) + r(5,:)));
hold on;
scatter(mean(r(1,:)),p(3)./(p(3) + p(4)));
ylim([0,1]);

end

function plot2dcombo_dual(m)

r = m(1).r{1};
p = m(1).p{1};


hold on;

%scatter(r(1,:), r(2,:),[],r(4,:)./(r(4,:) + r(5,:)));

maxy1 = max(r(2,:)+r(3,:));
maxy2 = max(p(2,:)+p(3,:));
maxy11 = max(r(2,:));
maxy22 = max(p(2,:));

if true 
    ax = gca;
    if (maxy1 == 0 && maxy2 == 0)
        ax.Color = [0.6,0.6,0.6];
    elseif (maxy1 > 45000 && maxy2 > 45000)
        ax.Color = [0.8,0.6,0.8];
%     elseif (maxy11 > maxy2)
%         ax.Color = [1,0.5,0.5]*(maxy2/(maxy1 + maxy2));
%     elseif (maxy1 < maxy22)
%         ax.Color = [0.5,0.5,1]*(maxy1/(maxy1 + maxy2));
    elseif (maxy11 > maxy2) ||  (maxy1 < maxy22)
        ax.Color = [(maxy1/(maxy1 + maxy2)),0,(maxy2/(maxy1 + maxy2))]*0.8;
    end
end


maxy = max(maxy1,maxy2);
%maxy = 50000;



%ylim([1,maxy]);

ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');

ax1.XColor = [0.5,0,0];
ax1.YColor = [0.5,0,0];
ax2.XColor = [0,0,0.5];
ax2.YColor = [0,0,0.5];

hold on;
errorbar(r(1,:), r(2,:), r(3,:),'Parent',ax1,'or');
errorbar(p(1,:), p(2,:), p(3,:),'Parent',ax2,'xb');

set(ax1,'xscale','log')

% set(ax1,'yscale','log')
% set(ax2,'yscale','log')

ylim(ax1,[1,maxy]);
ylim(ax2,[1,maxy]);

caxis(ax1, [0,1]);
caxis(ax2, [0,1]);

end
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
errorbar(r(1,:), r(2,:), r(3,:),'r');
%scatter(r(1,:), r(2,:),[],r(4,:)./(r(4,:) + r(5,:)));

maxy1 = max(r(2,:)+r(3,:));
maxy2 = max(p(2,:)+p(3,:));
maxy = max(maxy1,maxy2);
maxy = 50000;

caxis([0,1]);
set(gca,'yscale','log')
ylim([1,maxy]);

ax1 = gca; % current axes
ax1.XColor = [0.5,0,0];
ax1.YColor = [0.5,0,0];
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
hold on;
errorbar(p(1,:), p(2,:), p(3,:),'Parent',ax2,'xb');


set(gca,'yscale','log')
ylim([1,maxy]);

%scatter(p(1,:), p(2,:),[],p(4,:)./(p(4,:) + p(5,:)));




caxis([0,1]);
% ylim([0,2000]);

% plot(r(1,:),r(4,:)./(r(4,:) + r(5,:)));
% hold on;
% scatter(mean(r(1,:)),p(3)./(p(3) + p(4)));
% ylim([0,1]);

end
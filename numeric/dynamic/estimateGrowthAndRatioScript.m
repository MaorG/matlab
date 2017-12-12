%estimateGrowthScript

c = [0.1:0.1:7];
cmax = 180;
cmin = 0.0018;
c = exp(log(cmin):0.1:log(cmax));

d = [0.01:0.01:0.9];

totalTime = 960;
dt = 1;
wetVsDry = [0,24];
Ks = 0.3;
muMaxAttached = 0.3;
muMaxDetached = 0.4;
initNum = 100000;
initRatio = 0.1;
attachChance = 0.01;
detachChance = 0.01;


[C,D] = meshgrid(c,d);

result = nan(size(C));
ratio = nan(size(result));
for i = 1:numel(C)
    [res, rat] = estimateGrowth(totalTime, dt, wetVsDry, Ks, muMaxAttached, muMaxDetached, C(i), D(i), initNum, initRatio, attachChance, detachChance);
    result(i) = res/ initNum;
    ratio(i) = rat;
end

% imagesc(c,d,log10(result));
% colorbar;

figure

hold on
result2 = result;
result2(result2 == inf) = 10000;
result2 = log10(result2);
maskMin = result2 > -Inf;
result2(result2 == -Inf) = min(result2(maskMin));
%surf(C,D,result2,'CData',result2, 'Linestyle','none')
contour(C,D,result2,'ShowText','on','LineWidth',3);
%contour(C,D,ratio,'ShowText','on','LineWidth',3);

set(gca,'xscale','log')
xlabel('concentration')
ylabel('death rate [1/h]')
%colorbar;

ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');

%[ccc, h] = contour(C,D,ratio,'ShowText','on','LineWidth',3,'parent',ax2);

%colormap(ax2,spring)

set(ax2,'Color','none')
% 
% allH = allchild(h);
% valueToHide = 1;
% patchValues = cell2mat(get(allH,'UserData'));
% patchesToHide = patchValues == valueToHide;
% set(allH(patchesToHide),'FaceColor','k','FaceAlpha',0.8);




hold on

CCC = CC(:);
DDD = DD(:);
RRR = RR(:);
AAA = AA(:);

III = 1:numel(AAA);
scatter3(CCC(III), DDD(III), (15)*(DDD(III)~=0),(300)*(DDD(III)~=0),log10(AAA(III)/10), 'filled','MarkerEdgeColor','w','LineWidth',1, 'parent', ax2)
%[ccc, h] = contour(reshape(CC(1,:,:),9,12),reshape(DD(1,:,:),9,12),log10(reshape(AA(1,:,:),9,12)/1),'ShowText','on','LineWidth',3,'parent',ax2);

III = find((AA(:) > 10 & AA(:) < 45000));
% scatter3(CCC(III), DDD(III), (15)*(DDD(III)~=0),(300)*(DDD(III)~=0),log10(AAA(III)/10), 'filled','MarkerEdgeColor','w','LineWidth',1, 'parent', ax1)




%scatter3(CCC(III), DDD(III), (15)*(DDD(III)~=0),(100)*(DDD(III)~=0),(RRR(III)), 'filled','MarkerEdgeColor','w','LineWidth',1)

% set(ax1,'xscale','log')
% set(ax2,'xscale','log')
xlim(ax1,[min(c),max(c)]);
ylim(ax1,[min(d),max(d)]);
xlim(ax2,[min(c),max(c)]);
ylim(ax2,[min(d),max(d)]);
caxis(ax2,[-4,4]);
caxis(ax1,[-4,4]);
view(ax1,0,90)
view(ax2,0,90)
set(ax1,'Color','none')
set(ax2,'Color','none')
set(ax2, 'Visible', 'off')


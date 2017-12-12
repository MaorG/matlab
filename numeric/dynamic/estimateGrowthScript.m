%estimateGrowthScript

c = [0.1:0.1:18];
cmax = 180;
cmin = 0.0018;
c = exp(log(cmin):0.1:log(cmax));

d = [0.01:0.01:0.9];

totalTime = 240;
dt = 1;
wetVsDry = [0,24];
Ks = 0.4;
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
result2 = result;
result2(result2 == inf) = 10000;
result2 = log10(result2);
maskMin = result2 > -Inf;
result2(result2 == -Inf) = min(result2(maskMin));
%surf(C,D,result2,'CData',result2, 'Linestyle','none')
contour(C,D,result2,'ShowText','on','LineWidth',3);
%contour(C,D,ratio,'ShowText','on','LineWidth',3);
xlim([min(c),max(c)]);
ylim([min(d),max(d)]);
ylim([min(d),0.4]);

view(0,90)
set(gca,'xscale','log')
xlabel('concentration')
ylabel('death rate [1/h]')
colorbar;


%xlim([0.08,0.28]);
%ylim([0.00,0.25]);

hold on;

CCC = CC(:);
DDD = DD(:);
RRR = RR(:);
AAA = AA(:);

III = 1:numel(AAA);
scatter3(CCC(III), DDD(III), (15)*(DDD(III)~=0),(300)*(DDD(III)~=0),log10(AAA(III)/10), 'filled','MarkerEdgeColor','w','LineWidth',1, 'parent', ax1)

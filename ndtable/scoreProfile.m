function scoreProfile(rt)

tableUI(rt,@customPlotPop);
    
end

function customPlotPop(m)

%errorbar((m(1,:)), m(2,:), m(3,:));
hold on

x = (m(1,:));
y = (m(2,:));

x = smooth(x);

xq = linspace(min(x),max(x));
yq = interp1(x,y,xq);

d1yq = diff(yq);

trend1yq = ones(size(d1yq));
trend1yq(d1yq > 0) = -1;

pattern = [1, -1];

changes = conv(trend1yq, pattern, 'valid');

idx = find(changes > 0) + 1;
plot(xq,yq);
hold on;
scatter(xq(idx),yq(idx));

maxY = max(y);

ylim([0, maxY*1.1]);

%ylim([0,log(40000)]);
%xlim([0,log(40000)]);
%set(gca,'xscale','log')
%set(gca,'yscale','log')

end

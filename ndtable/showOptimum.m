function [] = showOptimum(rt, varargin)

props = parseInput(varargin);

pNames = props.pNames;
colateBy = props.colateBy;
fit = props.fit;

fit2mean(rt, pNames, colateBy, fit);

end

function fit2mean(rt, pNames, colateBy, fitParams)


rt3 = rt;

rt4 = rt3;

for i = 1:numel(rt3.T)
    TT = rt4.T;
    for i = 1:numel(rt3.T)
        if (~isempty(rt3.T{i}))
            
            m = rt3.T{i};
            m = m{1};
            
            [maxVal, maxI] = max(m(2,:));
            meanVal = mean(m(2,:));

            bestStrat = m(1,maxI);
            
            TT{i} = {(bestStrat)};
        else
            TT{i} = {nan};
        end
    end
end

rt4.T = TT;

x = [4,6,8,10,12,14,16,32,100];
Nx = length(x);
clim = [min(x) max(x)];
dx = min(diff(x));
y = clim(1):dx:clim(2);
for k=1:Nx-1, y(y>x(k) & y<=x(k+1)) = x(k+1); end 
cmap = colormap(jet(Nx));
cmap2 = [...
    interp1(x(:),cmap(:,1),y(:)) ...
    interp1(x(:),cmap(:,2),y(:)) ...
    interp1(x(:),cmap(:,3),y(:)) ...
];

ccmap = @(h) (colormap(cmap2));
cclim = @(h) (caxis([4,100]));
ccticks = @(h) (set(colorbar(h), 'YTick', [4,6,8,10,12,14,16,32]));

tableUI(rt4,[],[{ccmap},{cclim},{ccticks}]);
%tableUI(rt3,@customSurfPlot,[]);

end

function customPlotPop(m)
% errorbar((m(1,:)), m(2,:), m(3,:));
gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
startPoints = [1000 10 2 1000];

f = fit(m(1,:)', m(2,:)',gaussEqn, 'Start', startPoints);
plot(f,m(1,:), m(2,:))
end

function props = parseInput(varargin)
    props = struct(...
        'pNames', [],...
        'colateBy', [],...
        'fit', []...
        );
    
    for i = 1:numel(varargin{1})
        if strcmpi(varargin{1}{i}, 'pNames')
            props.pNames = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'colateBy')
            props.colateBy = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'fit')
            props.fit = varargin{1}{i+1};
        end
    end
end


function posterPlots(allData, pNames, colateBy)


slideStrat1(allData, pNames, colateBy)

end

function slideStrat1(allData, pNames, colateBy)

    

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    
    rt00m = rt00;
    rt00m.T =  cellfun(@(t) {mean(cell2mat(t))}, rt00.T, 'UniformOutput', false);
    rt00s = rt00;
    rt00s.T =  cellfun(@(t) {std(cell2mat(t)) / sqrt(length(cell2mat(t)))}, rt00.T, 'UniformOutput', false);
    
    rt01m = rt01;
    rt01m.T =  cellfun(@(t) {mean(cell2mat(t))}, rt01.T, 'UniformOutput', false);
    rt01s = rt01;
    rt01s.T =  cellfun(@(t) {std(cell2mat(t)) / sqrt(length(cell2mat(t)))}, rt01.T, 'UniformOutput', false);
    
    rt02m = rt00;
    rt02m.T =  cellfun(@(t, s) {mean(cell2mat(t) + cell2mat(s))}, rt01.T, rt00.T, 'UniformOutput', false);
    rt02s = rt00;
    rt02s.T =  cellfun(@(t, s) {std(cell2mat(t) + cell2mat(s))  / sqrt(length(cell2mat(t)))}, rt01.T, rt00.T, 'UniformOutput', false);
    
   
    TT = rt00m.T;
    for i = 1:numel(TT)
        if (~isempty(rt00m.T{i}))
            p00m = rt00m.T{i}{1};
            p00s = rt00s.T{i}{1};
            p01m = rt01m.T{i}{1};
            p01s = rt01s.T{i}{1};
            p02m = rt02m.T{i}{1};
            p02s = rt02s.T{i}{1};

            
            TT{i} = {[p00m,p00s,p01m,p01s,p02m,p02s]};
        else
            TT{i} = {nan};
        end
    end



rt2 = rt02m;
rt2.T = TT;
rt3 = colateFieldResultTable(rt2, colateBy);
TT = rt3.T;
    for i = 1:numel(TT)
         A = TT{i}{1};
         B = [0.25, 0.25, 0.25, 0.25];
         TT{i}{1} = conv2(A,B,'valid');
         
    end
rt4=rt3;
rt4.T = TT;
ptc = @(m, color) ...
    errorbar(m(1,:), (m(2,:)), (m(3,:)), '-',  'Color', color);

ptrc = @(m, color) ...
    plot(m(1,:), (m(2,:)) ./ (m(2,:) + m(3,:)), 'Color', color);
xx = @(h) xlim(h,[0,120]);
yy = @(h) ylim(h,[0,(30000)]);
ylog = @(h) set(h,'yscale','log');

wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [0.75, 0.75, 1.0]);
%tableUI(rt3,ptc,[{xx}, {wl1},{wl2}]);
tableUI(rt3,@plotAndFit,[]);
end

function plotAndFit(m, color)

    m = m(:,1:end-1);

    x = m(1,:)
    y = m(6,:);
    yerror = m(7,:);
    
    yl = (y);
    yb = y - yerror;
    yt = y + yerror;
    
    ybl = (yb);
    ytl = (yt);

    errorbar(x,yl,yl-ybl, ytl-yl, '-k',  'LineWidth', 2);
    hold on;
    plot ([0,100], [1550,1550], '--', 'Color', [0.5,0.5,0.5], 'LineWidth', 2);
    xlim([0,36]);    
    yl = ylim;
    ylim([0,4500]);    
    
    AxesHandle=findobj(gca,'Type','axes');
pt1 = get(AxesHandle,{'Position','tightinset','PlotBoxAspectRatio'});
    

    
    ratio = m(2,:) ./ (m(2,:) + m(4,:));
    
    for i = 1:numel(ratio)
        centerX = x(i);
        centerY = ytl(i) + 250;
        
        unitsAspectRatio = daspect;
        ax = gca;
        ax.Units = 'pixels';
        pixelsAspectRatio = ax.Position;
        ax.Units = 'normalized';
        
        aspectRatio = (unitsAspectRatio(2) / unitsAspectRatio(1)) * (pixelsAspectRatio(3) / pixelsAspectRatio(4));
        
        w = 0.5;
        h = w * aspectRatio;
        
       
        s = 0;
        e = 2*pi*(1-ratio(i));
        color = [1,0,0];
        plot_arc(centerX,centerY,h,w,s,e, color)
        e = 2*pi;
        s = 2*pi*(1-ratio(i));
        color = [112, 173, 71] / 255;
        plot_arc(centerX,centerY,h,w,s,e, color)
    end
    
    set(gca, 'XTick', [4,6,8,10,12,14,16,32,100]);
    set(gca, 'XTickLabel', ([4,6,8,10,12,14,16,32,100]));
    %set(gca, 'YTick', [1000:1000:4000]);
    %set(gca, 'YTickLabel', ([4,6,8,10,12,14,16,32,100]));
    set(gca, 'TickLength', [0,0]);
end

function P = plot_arc(cx,cy,h,w,s,e, color)
% Plot a circular arc as a pie wedge.
% a is start of arc in radians, 
% b is end of arc in radians, 
% (h,k) is the center of the circle.
% r is the radius.
% Try this:   plot_arc(pi/4,3*pi/4,9,-4,3)
% Author:  Matt Fig
t = linspace(s,e);
x = w*cos(t) + cx;
y = h*sin(t) + cy;
x = [x cx x(1)];
y = [y cy y(1)];
P = fill(x,y, color);
% axis([h-r-1 h+r+1 k-r-1 k+r+1]) 
% axis square;
if ~nargout
    clear P
end

end
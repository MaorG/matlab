function postPresPlayground01(allData, pNames, colateBy)


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
    rt02m.T =  cellfun(@(t, s) {std(cell2mat(t) + cell2mat(s))  / sqrt(length(cell2mat(t)))}, rt01.T, rt00.T, 'UniformOutput', false);
    
   
    TT = rt00m.T;
    for i = 1:numel(TT)
        if (~isempty(rt00m.T{i}))
            p00m = rt00m.T{i}{1};
            p00s = rt00s.T{i}{1};
            p01m = rt01m.T{i}{1};
            p01s = rt01s.T{i}{1};

            TT{i} = {[p00m,p00s,p01m,p01s]};
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
tableUI(rt3,@plotAndFit,[{xx},{yy},{ylog}]);
end

function plotAndFit(m, color)


    x = m(1,:)
    y = m(2,:)
    yerror = m(3,:);
    'hi'
    errorbar(x,y,yerror, '-',  'Color', color);
    hold on;
%     ft = fittype('a*exp(b*x)');
%     
%     options = fitoptions('a*exp(b*x)');
%     options.Lower = [0 -1]
%     
%     f1 = fit(x',y',ft,'StartPoint',[100,1], options);
% 
%     plot(f1, x, y);

x1 = x(~isnan(x+y));
y1 = y(~isnan(x+y)); 
%     Eqn = 'a*exp((b*x))';
%     startPoints = [100, 0]
% 
%     f1 = fit(x1',y1',Eqn,'Start', startPoints);
%     plot(f1,'b');

    

end

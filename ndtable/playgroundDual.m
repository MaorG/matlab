function [] = playgroundDual(allData)

expression = '[\w\.]*';
for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr1,expression,'match');
   allData(i).ga1 = str2double(nums{8});
   nums = regexp(allData(i).stratexpr2,expression,'match');
   allData(i).ga2 = str2double(nums{8});
   
   if (false && allData(i).ga1 > allData(i).ga2)
       temp = allData(i).ga1;
       allData(i).ga1 = allData(i).ga2;
       allData(i).ga2 = temp;
   end
end


pNames = {'ticks', 'width', 'ga'};    
%slide1(allData, pNames);

imhist(allData)

end

function si (allData)

rt1 = createNDResultTable(allData, 'image', 'ga1', 'ga2', 'repeat', 'ticks');
tableUI(rt1, [@imshow], []);

end


function allData = repairColor(allData)
    for i = 1:numel(allData)
       species = extractfield(allData(i).agents, 'species') ;
       for j = 1:numel(species)
           if (strcmp(species(j), 'dbact2')==1)
               allData(i).agents(j).colorR = 0.0;
               allData(i).agents(j).colorG = 255;
               allData(i).agents(j).colorB = 0.0;
           end
       end
    end
end

function imhist(allData)
    pNames = {'ga1', 'ga2', 'ticks', 'repeat'};
    rt1 = createNDResultTable(allData, 'image', pNames);
    rt2 = createNDResultTable(allData, 'clusterHist', pNames); 

    rt = rt2;
    for i = 1:numel(rt.T)
        rt.T{i} = {{rt1.T{i};  rt2.T{i}}};
    end

    tableUI(rt, @showimhist, []);
end

function showimhist(m)
hold on;
    imshow(m{1}{1})
    bar(m{2}{1}(1,:))
end

function pair(allData)

rt11 = createNDResultTable(allData, 'pairCorr11', 'repeat',  'ga1', 'ga2', 'ticks');
rt12 = createNDResultTable(allData, 'pairCorr12', 'repeat',  'ga1', 'ga2', 'ticks');
rt22 = createNDResultTable(allData, 'pairCorr22', 'repeat',  'ga1', 'ga2', 'ticks');


rt1 = rt11;
    for i = 1:numel(rt1.T)
        b = rt11.T{i}{1}(2,:);
        c = rt12.T{i}{1}(2,:);        
        d = rt22.T{i}{1}(2,:);
        if (numel(b) > numel(c))
            if (numel(b) > numel(d))
                a = rt11.T{i}{1}(1,:);
            else
                a = rt22.T{i}{1}(1,:);
            end
        else
            if (numel(c) > numel(d))
                a = rt12.T{i}{1}(1,:);
            else
                a = rt22.T{i}{1}(1,:);
            end
        end

        N = max(numel(b), numel(c));
        na = nan(1,N);
        na(1:numel(a)) = a;
        nb = nan(1,N);
        nb(1:numel(b)) = b;
        nc = nan(1,N);
        nc(1:numel(c)) = c;
        nd = nan(1,N);
        nd(1:numel(d)) = d;
        rt1.T{i} = {[na;nb;nc;nd]};
    end

ptc = @(m, color) ...
    plot(m(1,:), (m(2,:)), '--', m(1,:), m(3,:),'-','Color', color);
pt = @(m) ...
    plot(m(1,:), (m(2,:)), '--r', m(1,:), m(3,:), '--g', m(1,:), m(4,:), '-k');
yLim = @(h) ylim(h,[0, 2]);


xLim = @(h) xlim(h,[0,100]);
tableUI(rt1, pt, [{yLim},{xLim}]);
end

function dual(allData, pNames, colateBy) 




    pNames = {'ga1', 'ga2', 'ticks'};
    rt0 = createNDResultTable(allData, 'p0', pNames);
    pNames = {'ga2', 'ga1', 'ticks'};
    rt1 = createNDResultTable(allData, 'p1', pNames);
    
    rt = rt0;
    
    for i = 1:numel(rt.T)
        rt.T{i} = [rt0.T{i};  rt1.T{i}];
    end
    
    rtm = rt;
    rtm.T =  cellfun(@(t) {mean(cell2mat(t))}, rt.T, 'UniformOutput', false);
    %tableUI(rtm,[],[]) ;
    
    rtc = rtm;
    
    CC = zeros(size(rtm.T,1), size(rtm.T,2),3);
    
    for k = 1:size(rtm.T, 3)
        for i = 1:size(rtm.T, 1)
            for j = 1:size(rtm.T, 2)
                if (rtm.T{i,j,k}{1} > rtm.T{i,i,k}{1})
                    if (rtm.T{j,i,k}{1} > rtm.T{j,j,k}{1})
                        rtc.T{i,j,k} = {2};
                    else
                        rtc.T{i,j,k} = {-1};
                    end
                else
                    if (rtm.T{j,i,k}{1} > rtm.T{j,j,k}{1})
                        rtc.T{i,j,k} = {0};
                    else
                        rtc.T{i,j,k} = {1};
                    end
                end
                if i == j
                    rtc.T{i,j,k} = {1}
                end
            end
        end
    end
    tableUI(rtc,[],[]) ;

end

function dualHist(allData, pNames, colateBy) 

expression = '[\w\.]*';
for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr1,expression,'match');
   allData(i).ga1 = str2double(nums{8});
   nums = regexp(allData(i).stratexpr2,expression,'match');
   allData(i).ga2 = str2double(nums{8});
end




yy = @(h) ylim(h,[0,5000]);
    pNames = {'ga1', 'ga2', 'ticks', 'width'};
    colateBy = 'ticks';
    rt = createNDResultTable(allData, 'clusterHistByType', pNames);
    
    rtu = createNDResultTable(allData, 'clusterHist', pNames);
    rtut = colateFieldResultTable(rtu, colateBy);
    bar3plotLog = @(m) bar3nan(log10(m(:,:,3)));
    
    
    rt1 = rt;
    rt2 = rt;
    rt3 = rt;
    
    for i = 1:numel(rt.T)
       rt1.T{i} = {[rt.T{i}{1}(2,:); rt.T{i}{1}(1,:)] };
       rt2.T{i} = {[rt.T{i}{1}(3,:); rt.T{i}{1}(1,:)] };
       rt3.T{i} = {[rt.T{i}{1}(4,:); rt.T{i}{1}(1,:)] };
    end
    
    rt1t = colateFieldResultTable(rt1, colateBy);
    rt2t = colateFieldResultTable(rt2, colateBy);
    rt3t = colateFieldResultTable(rt3, colateBy);

    rtt = rt1t;
    for i = 1:numel(rtt.T)
       rtt.T{i} = {cat(3, ...
           rt1t.T{i}{1}(:,:,1), ...
           rt1t.T{i}{1}(:,:,2), ...
           rt1t.T{i}{1}(:,:,3), ...
           rt2t.T{i}{1}(:,:,3), ...
           rt3t.T{i}{1}(:,:,3)  )};

    end
    
    for i = 1:numel(rtt.T)
        m = rtt.T{i}{1};
        n = rtut.T{i}{1};
        
        mm = m(:,:,3) + m(:,:,4) + m(:,:,5);
        nn = n(:,:,3);
    end
    
    
    
    
    numOfRows = 12;
    numOfCols = 2;
    labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
    labelX2 = @(h) set(h, 'XTickLabel', [power(2,0:numOfRows), inf]);
    labelX2 = @(h) set(h, 'XTickLabel', [{1, '', 4,'',16,'',64,'',256,'',1024, ''}]);
    %labelX2 = @(h) set(h, 'XTickLabel', [10:10:1000, inf]);
    labelY1 = @(h) set(h, 'YTick', 1:numOfCols);
    labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,colateDim))));
    labelY2 = @(h) set(h, 'YTickLabel', []);
    xLim = @(h) xlim(h,[0, numOfRows+1]);
    yLim = @(h) ylim(h,[0, numOfCols+1]);
    zLim = @(h) zlim(h,[0, 4]);
    font = @(h) set(h,'FontSize',16);
    %rot = @(h) rotate(h,[0,0,1],25);
    rot = @(h) view([1,-1,1]);
    gl1 = @(h) grid(h, 'on');
    cLim =  @(h) caxis([0, 1]);
    col =  @(h) colormap('cool');
    tableUI(rtt,@plotTypeHist,...
     [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}, {font}, {col}, {cLim}]);


end

function plotTypeHist(m)
hold on;

mz = log10(m(:,:,3) + m(:,:,4) + m(:,:,5));
mc = ( m(:,:,3) + m(:,:,4) ) ./ (m(:,:,3) + m(:,:,4) + m(:,:,5));

bar3nanColor(mz, mc)
end

function customPlotDual(m)
hold on;
plot((m(1,:)), (m(2,:) + m(3,:) + m(4,:) + m(5,:)), '-k' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
end

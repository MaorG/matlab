filteredData = allData;%([allData.time] >= 2000);






classifiedData = classify2mat2D(filteredData, 'paramA', 'paramB');

scaleColor = true;


cruns = cell(size(classifiedData.T));

%use arrayfunc
for ii = 1:numel(classifiedData.T)

    data = classifiedData.T(ii);
   ids = extractfield(data{1}, 'id');
   ids = unique(ids);
   runs = cell(size(ids(ids~=0)));
   jj = 0;
    for id = ids
        if (id ~= 0) % ???
            jj = jj + 1;
            run = data{1}([data{1}.id] == id);
            times = extractfield(run, 'time');
            [t,order] = sort(times);
            run = run(order);
            runs(jj)= {run};
        end
    end
    
    cruns(ii) = {runs};
end

figure('Color',[1, 1, 1]);
suptitle('mix mean')

r = 1;
pA = r * [sin(2 * pi), cos( 2 * pi)];
pB = r * [sin(2 * pi * 0.333), cos( 2 * pi * 0.333 )];
pC = r * [sin(2 * pi * 0.667), cos( 2 * pi * 0.667 )];

[cols, rows] = size(cruns);

for i = 1:numel(cruns)
    subplot(rows,cols,i);
    
    
    minT = 0;
    maxT = 0;
    
    for run = cruns{i}
        rtRatioA = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio', 1, 1);
        rtRatioB = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio', 1, 2);
        rtRatioC = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio', 1, 3);
        rtMix = createResultTable(run{1}, 'paramA', 'time', 'mean', 'mix', 1, 2);

        minT = rtMix.valsB(1);
        maxT = rtMix.valsB(end);

        a = rtRatioA.T;
        b = rtRatioB.T;
        c = rtRatioC.T;
        
        XY = zeros(0,2);
        for t = 1:numel(a)
            xy = a(t)*pA + b(t)*pB + c(t)*pC;
            XY = [XY ; xy];
        end
        
        z = XY(:,1)';
        y = XY(:,2)';
        x = rtMix.valsB;
        %z = zeros(size(rtMix.T));
        color = rtMix.T;
        surface([x;x],[y;y],[z;z],[color;color],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',2);
        hold on;
        xg = ones(size(z)) * -0.5*maxT ;
        surface([xg;xg],[y;y],[z;z],[color;color],...
            'facecol','no',...
            'edgecol',[0.25,0.25,0.25] + [0.5,0.5,0.5]*rand,...
            'linew',2);
        
       
      
        %caxis([0,5000]);
        
        
        hold on;
    end
    
    hold on;
    plot3(...
        [minT; minT; minT; minT], ...
        [pA(2); pB(2); pC(2); pA(2)], ...
        [pA(1); pB(1); pC(1); pA(1)], ...
        'k');
    plot3(...
        [maxT; maxT; maxT; maxT],...
        [pA(2); pB(2); pC(2); pA(2)],...
        [pA(1); pB(1); pC(1); pA(1)],...
        'k');

        plot3(...
        [-0.5*maxT; -0.5*maxT; -0.5*maxT; -0.5*maxT],...
        [pA(2); pB(2); pC(2); pA(2)],...
        [pA(1); pB(1); pC(1); pA(1)],...
        'k');

    
    points = [pA ; pB ; pC];
    for pointIndex = 1:3
        for ii = 0.125:0.125:0.875

             plot3(...
                [minT; minT], ...
                [points(mod(pointIndex,3) + 1, 2) * ii + points(mod(pointIndex + 1,3) + 1, 2) * (1 - ii) ; points(mod(pointIndex,3) + 1, 2) * ii + points(mod(pointIndex + 2,3) + 1, 2) * (1 - ii)], ...
                [points(mod(pointIndex,3) + 1, 1) * ii + points(mod(pointIndex + 1,3) + 1, 1) * (1 - ii) ; points(mod(pointIndex,3) + 1, 1) * ii + points(mod(pointIndex + 2,3) + 1, 1) * (1 - ii)], ...
                'Color', [0.75,0.75,0.75]);

             plot3(...
                [maxT; maxT], ...
                [points(mod(pointIndex,3) + 1, 2) * ii + points(mod(pointIndex + 1,3) + 1, 2) * (1 - ii) ; points(mod(pointIndex,3) + 1, 2) * ii + points(mod(pointIndex + 2,3) + 1, 2) * (1 - ii)], ...
                [points(mod(pointIndex,3) + 1, 1) * ii + points(mod(pointIndex + 1,3) + 1, 1) * (1 - ii) ; points(mod(pointIndex,3) + 1, 1) * ii + points(mod(pointIndex + 2,3) + 1, 1) * (1 - ii)], ...
                'Color', [0.75,0.75,0.75]);

             plot3(...
                [-0.5*maxT; -0.5*maxT], ...
                [points(mod(pointIndex,3) + 1, 2) * ii + points(mod(pointIndex + 1,3) + 1, 2) * (1 - ii) ; points(mod(pointIndex,3) + 1, 2) * ii + points(mod(pointIndex + 2,3) + 1, 2) * (1 - ii)], ...
                [points(mod(pointIndex,3) + 1, 1) * ii + points(mod(pointIndex + 1,3) + 1, 1) * (1 - ii) ; points(mod(pointIndex,3) + 1, 1) * ii + points(mod(pointIndex + 2,3) + 1, 1) * (1 - ii)], ...
                'Color', [0.75,0.75,0.75]);

        end
    end

    
    
    txtA = '\leftarrow A';
    txtB = '\leftarrow B';
    txtC = '\leftarrow C';

    text(0,pA(2),pA(1), txtA)
    text(0,pB(2),pB(1),txtB)
    text(0,pC(2),pC(1),txtC)

    text(-0.5*maxT,pA(2),pA(1), txtA)
    text(-0.5*maxT,pB(2),pB(1),txtB)
    text(-0.5*maxT,pC(2),pC(1),txtC)

        %title(['d: ', num2str(cruns{i}{1}(1).paramA), ' g: ', num2str(cruns{i}{1}(1).paramB)]);
    axis off;
    %axis([-inf,inf,0,1])
end


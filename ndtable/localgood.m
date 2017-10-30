function [] = localgood(cruns)


figure;

my_plotyy(cruns, 'outpost4norm',  'outpost4');
% temp3_print_worlds(cruns, 10000, 0);

end

function [] = my_plotyy(cruns, leftName, rightName)
[cols, rows] = size(cruns);
maxY1 = 0;
maxY2 = 0;
for i = 1:numel(cruns)

    
    subplot(rows,cols,i);
    for run = cruns{i}
        rtLeft = createResultTable(run{1}, 'paramA', 'time', 'mean', leftName);
        rtRight = createResultTable(run{1}, 'paramA', 'time', 'mean', rightName);
        y1 = rtLeft.T;
        %y1 = y1 .* (1 - y1);
        y2 = rtRight.T;
        x = rtLeft.valsB;
        
        maxY1 = max(maxY1, max(y1));
        maxY2 = max(maxY2, max(y2));

    end
end

for i = 1:numel(cruns)

    
    subplot(rows,cols,i);
    for run = cruns{i}
        rtLeft = createResultTable(run{1}, 'paramA', 'time', 'mean', leftName);
        rtRight = createResultTable(run{1}, 'paramA', 'time', 'mean', rightName);
        y1 = rtLeft.T;
        %y1 = y1 .* (1 - y1);
        y2 = rtRight.T;
        x = rtLeft.valsB;
        
        hold on;
        [AX,H1,H2] = plotyy(x,y1,x,y2,'plot');
        
        set(H1,'LineStyle','-');
        set(H1,'color','red');
        set(H2,'LineStyle','-');
        set(H2,'color','blue');
        
        set(AX,{'ycolor'},{'r';'b'})  % Left color red, right color blue..
        set(AX(1),'YLim',[0 maxY1])
        set(AX(2),'YLim',[0 maxY2])
       
    end

    title(['A: ', num2str(cruns{i}{1}(1).paramA), 'B: ', num2str(cruns{i}{1}(1).paramB)]);
end

suptitle([leftName, ' |-| ', rightName, ', vs time']);


% figure
% for i = 1:numel(cruns)
% 
%     
%     subplot(rows,cols,i);
%     
%     
%     coeff = [];
%     
%     for run = cruns{i}
%         rtMix = createResultTable(run{1}, 'paramA', 'time', 'mean', 'mix', 1, 2);
%         rtRatio = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio');
%         y = rtRatio.T;
%         x = rtRatio.valsB;
%         z = zeros(size(rtRatio.T));
%         c = rtMix.T;
%         surface([x;x],[y;y],[z;z],[c;c],...
%             'facecol','no',...
%             'edgecol','interp',...
%             'linew',1);
%         hold on;
%         
%         colorbar;
%     
%         axis([-inf,inf,0,1]);
%         caxis([0,1]);
%         hold on;
%     end
%     
%     title(['A radius: ', num2str(cruns{i}{1}(1).paramA), ' init pop {A  B}: ', num2str(cruns{i}{1}(1).paramB)]);
% 
% end

end
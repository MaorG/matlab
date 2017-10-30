[cols, rows] = size(cruns);

figure();
title('mixed area ratios')
for i = 1:numel(cruns)
    h = subplot(rows,cols,i);
    
        
        ax=get(h,'Position');
        ax(4)=ax(4)*1.25; 
        ax(3)=ax(3)*1.25; 
        set(h,'Position',ax);
    
    coeff = [];
    allY = [];
    for run = cruns{i}
        rtMix = createResultTable(run{1}, 'paramA', 'time', 'mean', 'outpost');
        rtCount = createResultTable(run{1}, 'paramA', 'time', 'mean', 'count');
        rtParamC = createResultTable(run{1}, 'paramA', 'time', 'mean', 'paramC');
        y = rtMix.T;
        
%         if size(allY,2) - size(y,2) > 0
%             %allY = [allY; padarray(y, size(allY,2) - size(y,2))];
%         elseif size(allY,2) > 0 && size(allY,2) - size(y,2) < 0
%             %allY = [allY; y(1:size(allY,2))];
%         else 
%             allY = [allY; y];
%         end
        x = rtMix.valsB;
        z = zeros(size(rtMix.T));
        c = rtParamC.T;
        
        if run{1}(1).paramC > 0
        surface([x;x],[y;y],[z;z],[c;c],...
            'facecol','no',...
            'edgecol','red',...
            'linew',1);
        hold on;
        else 
        surface([x;x],[y;y],[z;z],[c;c],...
            'facecol','no',...
            'edgecol','blue',...
            'linew',1);
        hold on;
        end
        offset = 0;
        
%         if (size(x,2) > offset + 2)
%             f = @(p,x) p(1) + p(2) ./ (1 + exp(-(x-p(3))/p(4)));
%             p = nlinfit(x(1+offset:end),y(1+offset:end),f,[0 0.5 5000 -2000]);
%             %f = @(p,x) p(1) - p(1) ./ (1 + exp(-(x-p(2))/p(3)));
%             %p = nlinfit(x(1+offset:end),y(1+offset:end),f,[0.5 5000 -2000]);
%             line(x(1+offset:end),f(p,x(1+offset:end)),'color','r')
%             
%             if p(4) < 0 && p(4) > -5000 && p(3) > 0
%                 coeff = [coeff ; p(4)];
%             end
%         end
        
        
        
    
        axis([-inf,inf,0,1]);
        caxis([0,5000]);
        hold on;
    end
    
%     y = nanmean(allY,1);
%     surface([x;x],[y;y],[z;z]);
    if (numel(cruns{1}) > 0)
       % title([cruns{i}{1}(1).nameA, ': ', num2str(cruns{i}{1}(1).paramA), ' ', ...
      %      cruns{i}{1}(1).nameB  ,': ', num2str(cruns{i}{1}(1).paramB), ' c: ']);
        %, num2str(floor(nanmean(coeff)))]);
    end

end

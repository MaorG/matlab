[cols, rows] = size(cruns);



for i = 1:numel(cruns)
    subplot(rows,cols,i);
    
    
    coeff = [];
    
    for run = cruns{i}
        rtCount = createResultTable(run{1}, 'paramA', 'time', 'mean', 'count');
        rtRatio = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio');
        y = rtCount.T;
        x = rtCount.valsB;
        z = zeros(size(rtCount.T));
        c = rtRatio.T;
        surface([x;x],[y;y],[z;z],[c;c],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',1);
        hold on;
        
        offset = 2;
        
        if (size(x,2) > offset + 2)
            f = @(p,x) p(1) + p(2) ./ (1 + exp(-(x-p(3))/p(4)));
            p = nlinfit(x(1+offset:end),y(1+offset:end),f,[0.5 0.5 5000 -2000]);
            line(x(1+offset:end),f(p,x(1+offset:end)),'color','r')
            
            if p(4) < 0 && p(3) > 0
                coeff = [coeff ; p(4)];
            end
        end
        
        
        
    
        %axis([-inf,inf,0,1]);
        caxis([0,5000]);
        hold on;
    end
    
    title(['d: ', num2str(cruns{i}{1}(1).paramA), ' g: ', num2str(cruns{i}{1}(1).paramB), ' c: ', num2str(floor(nanmean(coeff)))]);

end

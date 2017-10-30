[cols, rows] = size(cruns);


figure;
for row = 1:rows
    for col = 1:cols
        
        subplot(rows,cols,((row - 1) * rows) + (cols + 1 - col));
        
        %data specific :(
        
        coeff = [];
        allY = [];
        
        for run = cruns{row, col}
            found = false;
            for j = 2:size(run{1},1)
                %if found == false && run{1}(j).mix(1,2) > 0.5
                if found == false && j == size(run{1},1)
                    found = true;
                    
                    
                    CMap = [
                        0, 0, 0;
                        1, 0.2, 0.2;
                        0.2, 0.2, 1] .* 0.33 + 0.66;
                    colorMat  = ind2rgb(run{1}(j).world + 1, CMap);
                    
                    imagesc([0, 10000], [0,1], flipud(colorMat));
                    
                    
                    
                    
                end
            end
            hold on;
            
        end;
        for run = cruns{row, col}
            
            
            T = [0,   0,   255; 
                0, 0,  0;
                255, 0, 0]./255;
            ranges = [0, 0.5, 1];
            
            map = interp1(ranges,T,linspace(0,1,255));
            
            
            rtMix4 = createResultTable(run{1}, 'paramA', 'time', 'mean', 'mix', 1, 2);
            rtMix16 = createResultTable(run{1}, 'paramA', 'time', 'mean', 'mix', 2, 2);
            %rtBorder = createResultTable(run{1}, 'paramA', 'time', 'mean', 'outpostR');
            rtParamC = createResultTable(run{1}, 'paramA', 'time', 'mean', 'paramC');
            rtRatio = createResultTable(run{1}, 'paramA', 'time', 'mean', 'ratio');
            y = rtMix4.T;
            
            x = rtMix4.valsB;
            z = zeros(size(rtMix16.T));

            c = rtParamC.T;
            surface([x;x],[y;y],[z;z],[c;c],...
                'facecol','no',...
                'edgecol','interp',...
                'linew',1);

            
%             c = rtRatio.T;
%             if run{1}(1).paramC < 0
%             surface([x;x],[y;y],[z;z],[c;c],...
%                 'facecol','no',...
%                 'edgecol','interp',...
%                 'linew',1);
%             end
            hold on;
            
            offset = 3;
            %
            %         if (size(x,2) > offset + 2)
            %             f = @(p,x) p(1) + p(2) ./ (1 + exp(-(x-p(3))/p(4)));
            %             p = nlinfit(x(1+offset:end),y(1+offset:end),f,[0 0.5 5000 -2000]);
            %             f = @(p,x) p(1) - p(1) ./ (1 + exp(-(x-p(2))/p(3)));
            %             p = nlinfit(x(1+offset:end),y(1+offset:end),f,[0.5 5000 -2000]);
            %            line(x(1+offset:end),f(p,x(1+offset:end)),'color','r')
            %
            %             if p(4) < 0 && p(4) > -5000 && p(3) > 0
            %                 coeff = [coeff ; p(4)];
            %             end
            %         end
            
            
            
            
            axis([-inf,inf,0,1]);
            colormap(map)
            caxis([0,1]);
            set(gca,'ydir','normal');
        end
        
        %     y = nanmean(allY,1);
        %     surface([x;x],[y;y],[z;z]);
        %title(['d: ', num2str(cruns{row, col}{1}(1).paramA), ' g: ', num2str(cruns{row, col}{1}(1).paramB), ' c: ', num2str(floor(nanmean(coeff)))]);
        title(['d: ', num2str(cruns{row, col}{1}(1).paramA), ' g: ', num2str(cruns{row, col}{1}(1).paramB)]);
    end
end

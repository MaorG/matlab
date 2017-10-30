function [] = temp3_print_worlds (cruns, time, paramC)

% cr = cell([1,1]);
% cr{1} = cruns{3,3};
%  cr{2} = cruns{3,5};
% 
cr = cruns;
[cols, rows] = size(cr);

figure;
 %title('homogeneous');
for iii = 1:numel(cruns)

    
%        h = subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
        h = subplot(rows,cols,iii);
        ax=get(h,'Position');
%         ax(4)=ax(4)*1.25; 
%         ax(3)=ax(4); 
        set(h,'Position',ax);
        hold on;

        
       for run = cr{iii}
            
            if true %(run{1}(1).paramC == paramC)
                for frame = run{1}'
                    if frame.time == time;
                        
                       
                        print_world(frame.world);
                                            CMap = [
                        0, 0, 0;
                        1, 0, 0;
                        0, 0, 1
                        0, 1, 0];
                        colorMat  = ind2rgb(frame.world + 1, CMap);
                    
                        imshow(colorMat);
                       imagesc([0,2], [0,2], flipud(colorMat));
                    
                    end
                end
            end
        end
        
        hold on;

       %imagesc(C);
       %title([cruns{iii}{1}(1).nameA, ': ', num2str(cruns{iii}{1}(1).paramA), ' ', cruns{iii}{1}(1).nameB  ,': ', num2str(cruns{iii}{1}(1).paramB)]);%, num2str(floor(nanmean(coeff)))]);

       title(['d: ', num2str(cr{iii}{1}(1).paramA), ' g: ', num2str(cr{iii}{1}(1).paramB)]);
end


end

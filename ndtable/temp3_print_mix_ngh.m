function [] = temp3_print_worlds (cruns, time, paramC)

% cr = cell([1,1]);
% cr{1} = cruns{3,3};
%  cr{2} = cruns{3,5};
% 
cr = cruns;
[cols, rows] = size(cr);

figure;
 %title('homogeneous');
for row = 1:rows
    for col = 1:cols
        
%        h = subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
        h = subplot(rows,cols,rows * (row - 1) + col);
        ax=get(h,'Position');
         ax(4)=ax(4)*1.25; 
         ax(3)=ax(4); 
        set(h,'Position',ax);
        hold on;
        
        if row == rows
           %text(ax(1) - 1, ax(2), ['d = ', num2str(cr{col, row}{1}(1).paramA)]); 
        end
        if col == 1
           %text(ax(1), ax(2) + 1, ['g = ', num2str(cr{col, row}{1}(1).paramB)]); 
        end
        
       for run = cr{col, row}
            
            if (run{1}(1).paramC == paramC)
                for frame = run{1}'
                    if frame.time == time;
                        
                        ttt = frame.mixngh;
                        
                        avx = 0;
                        avy = 0;
                        
                        for iii = 1:size(ttt,1)
                            for jjj = 1:size(ttt,2)
                                avx = avx + iii * ttt(iii, jjj);
                                avy = avy + jjj * ttt(iii, jjj);
                            end
                        end
                        
                        avx = avx / sum(sum(ttt));
                        avy = avy / sum(sum(ttt));
                        
                        neCount = sum(sum(ttt(floor(avx):end, floor(avy):end)));
                        
                        clims = [0 20];
                        imagesc(frame.mixngh4, clims)
                        
                        hold on; % Prevent image from being blown away.
                        %plot(avy,avx,'r+', 'MarkerSize', 50);
                        
                        %text(25, 25, num2str(neCount/sum(sum(ttt)))); 
                        
                        
                        %print_world(frame.world);
%                                             CMap = [
%                         0, 0, 0;
%                         1, 0, 0;
%                         0, 0, 1];
%                         colorMat  = ind2rgb(frame.world + 1, CMap);
%                     
%                         imshow(colorMat);
%                        imagesc([0,2], [0,2], flipud(colorMat));
                    
                    end
                end
            end
        end
        
        hold on;

       %imagesc(C);
       % title(['d: ', num2str(cr{col, row}{1}(1).paramA), ' g: ', num2str(cr{col, row}{1}(1).paramB)]);
    end
end


end

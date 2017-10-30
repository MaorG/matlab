FigHandle = figure(4);
set(FigHandle, 'Position', [100, 100, 750, 250]);

pp = [
    -1, 30000;
    0, 30000;
    1, 30000
]; 

for i = 1:size(pp,1)
    
    pA = pp(i,1);
    pB = pp(i,2);
    
    g = getDataByParams(allData, 'paramB', 'time', pA, pB);
subplot(1,size(pp,1),i)
    print_world(g(1).world);
    
end
    
    
     
     energy = g(1).mix;
%         fitResult = fit(Lacunarity(:,1),Lacunarity(:,2),'exp1');
         %plot(Lacunarity(:,1),Lacunarity(:,2));
         title(mix)
    
        
    subplot(2,size(pp,1),i)
    print_world(g(1).world);
    title(sprintf( '%d, %d',pA , pB));

end
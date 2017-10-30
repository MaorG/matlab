function [] = showRun(run) 

    figure();
    length = numel(run{1});
    
    rows = ceil(sqrt(length));
    
    for i = 1:length
        
        subplot(rows, rows, i);
        print_world(run{1}(i).world);
        
        title (run{1}(i).time);
        
    end

    
end
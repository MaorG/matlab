for ii = 1:size(data)
    
    figure(1);
    si = getSI(data(ii).world);
    print_world(data(ii).world);
    title(si);
    waitforbuttonpress;
    
end
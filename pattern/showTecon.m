function showTecon(m)
    
    hold on;
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    scatter(m.R(:,1),m.R(:,2),'or');
    scatter(m.G(:,1),m.G(:,2),'og');
    scatter(m.RandG(:,1),m.RandG(:,2),'xk');
    scatter(m.all(:,1),m.all(:,2),'ok');

end
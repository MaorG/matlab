function plot2d(m, mode)
    
if mode == 1
    plot2d1(m);
end

end

function plot2d1(m)

errorbar(m(1,:), m(2,:),m(3,:));

end
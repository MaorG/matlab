function [] = popCC ()

    figure();
    hold on;
    [T,Y] = ode23(@popCCNew,[0 5000], 100);
    plot(T,Y)
    
    
    
    [T,Y] = ode23(@popCCOld,[0 5000], 100);
    plot(T,Y)

    xlabel('Time');
    ylabel('pop(t)');
    legend('New CC: dx/dt = x * (beta * (1 - (x/k)) - gamma)','Old CC: dx/dt = x * (beta - gamma) * (1 - (x/k))')

    function dx_dt = popCCNew (t, x)
        beta = 0.01;
        gamma = 0.005;
        k = 5000;
        dx_dt = x * (beta * (1 - (x/k)) - gamma);
    end

    function dx_dt = popCCOld (t, x)
        beta = 0.01;
        gamma = 0.005;
        k = 5000;
        dx_dt = x * (beta - gamma) * (1 - (x/k));
    end

end
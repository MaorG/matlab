function out = estimateGrowth(totalTime, dt, wetVsDry, Ks, muMax, conc, deathPerHour, initNum)


count = initNum;

deathPerDt = power(deathPerHour, 1/dt);

for time = 0:dt:totalTime
    
    % growth
    mu = (muMax * conc) / (Ks + conc);
    count = count * exp(mu * dt);
    
    % death
    isDry = rem(time, sum(wetVsDry)) > wetVsDry(1);
    if isDry
        count = count * (1 - deathPerDt);
    end
    
    %bounds
    if count > initNum * 10^4;
        out = initNum * 10^4;
        return;
    elseif count < 1
        out = 0;
        return;
    end
    
end

out = count;
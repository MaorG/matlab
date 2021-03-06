function [count, ratio] = estimateGrowth(totalTime, dt, wetVsDry, Ks, muMaxAttached, muMaxDetached, initConc, deathPerHour, initNum, initRatio, attachChancePerHour, detachChancePerHour)


count = initNum;
ratio = initRatio;
conc = initConc;
countAttached = initNum * ratio;
countDetached = initNum * (1 - ratio);

deathPerDt = power(deathPerHour, 1/dt);
attachChancePerDt = power(attachChancePerHour, 1/dt);
detachChancePerDt = power(detachChancePerHour, 1/dt);
permeationRateDt = power(0.00083, 1/dt);

for time = 0:dt:totalTime
    
    % growth
    mu = (muMaxAttached * conc) / (Ks + conc);
    countAttached = countAttached * exp(mu * dt);
    mu = (muMaxDetached * conc) / (Ks + conc);
    countDetached = countDetached * exp(mu * dt);
    
    % uptake and permeation
    conc = conc - (countAttached + countDetached - count) * 0.0000000001;
    conc = conc + (initConc - conc) * permeationRateDt;
    
    % death
    isDry = rem(time, sum(wetVsDry)) > wetVsDry(1);
    if isDry
        countAttached = countAttached * (1 - 0.5 * deathPerDt);
        countDetached = countDetached * (1 - deathPerDt);
    end
    
    % attach detach
    a2d = countAttached * detachChancePerDt;
    d2a = countDetached * attachChancePerDt;

    countAttached = countAttached - a2d + d2a;
    countDetached = countDetached - d2a + a2d;
    
    count = countAttached + countDetached;
    ratio = countAttached / count;
    %bounds
    if count > initNum * 10^4
        out = initNum * 10^4;
        return;
    elseif count < 1
        out = 0;
        return;
    end
    
end


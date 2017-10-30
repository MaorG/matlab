tic
expOutName = 'C:\simulators\RepastSimphony-2.3.1\Maor\output_dist05log\';
allLogs = parseExperimentLogDir(expOutName, true);
toc

% extract simple timeline of events

log = allLogs(1);

maxTick = max(extractfield(log.events, 'tick'));
ticks = 1:maxTick;
'attachRandom';
'attachNgh';
'detach';
'split';
'dead';

attachR = zeros(maxTick,1);
attachN = zeros(maxTick,1);
detach = zeros(maxTick,1);
split = zeros(maxTick,1);
dead = zeros(maxTick,1);


for i = 1:numel(log.events)
    event = log.events(i);
    sp = event.species;
    if (strcmp(sp, 'dbact1')) 
       tick = event.tick;
       ev = event.event;
       if (strcmp(ev, 'attachRandom'))
           attachR(tick) = attachR(tick)+1;
       elseif (strcmp(ev, 'attachNgh'))
           attachN(tick) = attachN(tick) + 1;
       elseif (strcmp(ev, 'detachRandom'))
           detach(tick) = detach(tick) + 1;
       elseif (strcmp(ev, 'split'))
           split(tick) = split(tick) + 1;
       elseif (strcmp(ev, 'dead'))
           dead(tick) = dead(tick) + 1;   
       else
           ' >_< '
       end
    end
end

plot(ticks, attachR, '-m', ticks, attachN, '-r', ticks, detach, '-g', ticks, split, '-b', ticks, dead, '-k');

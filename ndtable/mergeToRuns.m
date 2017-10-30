function [runs] = mergeToRuns(data, mergedPropertyName)

prop = mergedPropertyName;

ids = extractfield(data, 'id');

ids = unique(ids);

runGroups = cell(size(ids))';

% group by id
for ii = 1:numel(data)
    
    index = find(ids == data(ii).id);
    runGroups{index} = [runGroups{index} ; data(ii)];
    
end

runs = struct([]);

for runGroup = runGroups'
    
    % sort by time
    times = extractfield(runGroup{1}, 'time');
    [t,order] = sort(times);
    runGroup{1} = runGroup{1}(order);
    
    
    % merge into data format (todo: better data format)
    run = struct();
    run.timez = t;
    run.paramA = runGroup{1}(1).paramA;
    run.nameA = runGroup{1}(1).nameA;
    run.paramB = runGroup{1}(1).paramB;
    run.nameB = runGroup{1}(1).nameB;
    run.paramC = runGroup{1}(1).paramC;
    run.nameC = runGroup{1}(1).nameC;
    run.id = runGroup{1}(1).id;
    
    
    run.(prop) = [];
    
    pv = runGroup{1}(1).(prop);
    
    if numel(pv)==length(pv)
        
    else
        for frame = runGroup{1}'
            
            timeVec = frame.time .* ones(1,size(frame.(prop),2));
            pvt = cat(1,timeVec,frame.(prop));
            if (numel(run.(prop)) == 0)
                run.(prop) = pvt;
            else
                
                
                maxMeasurements = max(size(run.(prop),2), size(pvt,2));    %# Get the maximum vector size
                fcn = @(x) cat(2, x, nan(3,maxMeasurements-size(x,2), size(x,3)));  %# Create an anonymous function
                
                pvt = fcn(pvt);
                run.(prop) = fcn(run.(prop));
                run.(prop) = cat(3,run.(prop), pvt);
            end
        end
        run.(prop) = permute(run.(prop), [2,3,1]);
        runs = [runs; run];
    end
    

    
end

end






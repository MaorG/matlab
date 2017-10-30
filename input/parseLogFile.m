function [log] = parseLogFile( fid )
%data = struct;
log = parseParameters(fid);
if (true)
    log.events = parseEvents(fid);
else
    log = [];
end
%data.solutes = parseSolutes(fid);
end

function [parameters] = parseParameters (fid)
frewind(fid)
parameters = [];
s = '';
while (feof(fid) == 0 && strcmp (s,'{parameters}') == 0)
    s = fscanf(fid, '%s\n', 1);
end
% todo - this is somewhat duplicate of agent parsing
s = fgets(fid);

expr = '[a-z0-9.-]+';
[propertiesHeader,tok,ext] = regexpi(s, expr, 'match');
s = fgets(fid);
expr = ',';
[propertiesValues,tok,ext] = regexpi(s, expr, 'split');
for ii = 1:numel(propertiesHeader)
    val = propertiesValues{ii};
    numval = str2double(val);
    if isnan(numval)
        if strcmp(val, 'true') == 1
            parameters.(propertiesHeader{ii}) = 1;
        elseif strcmp(val, 'false') == 1
            parameters.(propertiesHeader{ii}) = 0;
        else
            parameters.(propertiesHeader{ii}) = val;
        end
    else
        parameters.(propertiesHeader{ii}) = numval;
    end
end

end


function [events] = parseEvents( fid )
frewind(fid)
s = '';
while (feof(fid) == 0 && strcmp (s,'{events}') == 0)
    s = fscanf(fid, '%s\n', 1);
end

s = fgets(fid);
% get header for events
expr = '[a-z0-9.-]+';
[eventsHeader,tok,ext] = regexpi(s, expr, 'match');
s = fgets(fid);
events = struct;
% agents = [];
event = struct;

% count events, prepare struct
count = 0;
while (feof(fid) == 0 && strncmp (s,'{',1) == 0)
    s = fgets(fid);
    count = count+1;
end
if (count == 0)
    for ii = 1:numel(eventsHeader)
        events(1).(eventsHeader{ii}) = [];
    end
    return
end
for ii = 1:numel(eventsHeader)
    events(count).(eventsHeader{ii}) = [];
end

frewind(fid)
s = '';
while (feof(fid) == 0 && strcmp (s,'{events}') == 0)
    s = fscanf(fid, '%s\n', 1);
end
s = fgets(fid);
s = fgets(fid);

% get values for each agent
count = 0;
while (feof(fid) == 0 && strncmp (s,'{',1) == 0)
    count = count + 1;
    [eventValues,tok,ext] = regexpi(s, expr, 'match');
    for ii = 1:numel(eventValues)
        val = eventValues{ii};
        numval = str2double(val);
        if isnan(numval)
            if strcmp(val, 'true') == 1
                event.(eventsHeader{ii}) = 1;
            elseif strcmp(val, 'false') == 1
                event.(eventsHeader{ii}) = 0;
            else
                event.(eventsHeader{ii}) = val;
            end
        else
            event.(eventsHeader{ii}) = numval;
        end
    end
    events(count) = event;
    %agents = [agents; agent];
    s = fgets(fid);
end


end

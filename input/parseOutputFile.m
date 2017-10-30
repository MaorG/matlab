function [data] = parseOutputFile( fid , filter)
%data = struct;
data = parseParameters(fid);
if (filter(data)) %% && mod(data.ticks,20000) == 0)
    data.agents = parseAgents(fid);
    data.population = parsePop(fid);
else
    data = [];
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
function [population] = parsePop (fid)
frewind(fid)
population = [];
s = '';
while (feof(fid) == 0 && strcmp (s,'{population}') == 0)
    s = fscanf(fid, '%s\n', 1);
end
% todo - this is somewhat duplicate of agent parsing
s = fgets(fid);

expr = '[a-z0-9.-]+';
if (s == -1)
    return;
end
[populationHeader,tok,ext] = regexpi(s, expr, 'match');
s = fgets(fid);
expr = ',';
[populationValues,tok,ext] = regexpi(s, expr, 'split');
for ii = 1:numel(populationHeader)
    val = populationValues{ii};
    numval = str2double(val);
    if isnan(numval)
        if strcmp(val, 'true') == 1
            population.(populationHeader{ii}) = 1;
        elseif strcmp(val, 'false') == 1
            population.(populationHeader{ii}) = 0;
        else
            population.(populationHeader{ii}) = val;
        end
    else
        population.(populationHeader{ii}) = numval;
    end
end

end


function [solutes] = parseSolutes (fid)
frewind(fid)
solutes = [];
s = '';
while (feof(fid) == 0 && strcmp (s,'{solutes}') == 0)
    s = fscanf(fid, '%s\n', 1);
end
s = fgets(fid);
% get solutes, get name then get values
while (feof(fid) == 0 && strncmp (s,'{',1) == 0)
    % get name
    expr = '[a-z0-9.-]+';
    [soluteHeader,tok,ext] = regexpi(s, expr, 'match');
    solute = struct;
    solute.name = soluteHeader{1};
    solute.width = str2double(soluteHeader{2});
    solute.height = str2double(soluteHeader{3});
    solute.conc = zeros(solute.width, solute.height);
    for ii = 1:solute.height
        s = fgets(fid);
        [soluteValuesRow,tok,ext] = regexpi(s, expr, 'match');
        numval = str2double(soluteValuesRow);
        solute.conc(ii,:) = numval;
    end
        
    solutes = [solutes, solute];
    s = fgets(fid);
end



end

function [agents] = parseAgents( fid )
frewind(fid)
s = '';
while (feof(fid) == 0 && strcmp (s,'{agents}') == 0)
    s = fscanf(fid, '%s\n', 1);
end

if (feof(fid) == 1)
    agents = [];
    return;
end

s = fgets(fid);
% get header for agents
expr = '[a-z0-9.-]+';
[agentsHeader,tok,ext] = regexpi(s, expr, 'match');
s = fgets(fid);
agents = struct;
% agents = [];
agent = struct;

% count agents, prepare struct
count = 0;
while (feof(fid) == 0 && strncmp (s,'{',1) == 0)
    s = fgets(fid);
    count = count+1;
end
if (count == 0)
    for ii = 1:numel(agentsHeader)
        agents(1).(agentsHeader{ii}) = [];
    end
    return
end
for ii = 1:numel(agentsHeader)
    agents(count).(agentsHeader{ii}) = [];
end

frewind(fid)
s = '';
while (feof(fid) == 0 && strcmp (s,'{agents}') == 0)
    s = fscanf(fid, '%s\n', 1);
end
s = fgets(fid);
s = fgets(fid);

% get values for each agent
count = 0;
while (feof(fid) == 0 && strncmp (s,'{',1) == 0)
    count = count + 1;
    [agentValues,tok,ext] = regexpi(s, expr, 'match');
    for ii = 1:numel(agentValues)
        val = agentValues{ii};
        numval = str2double(val);
        if isnan(numval)
            if strcmp(val, 'true') == 1
                agent.(agentsHeader{ii}) = 1;
            elseif strcmp(val, 'false') == 1
                agent.(agentsHeader{ii}) = 0;
            else
                agent.(agentsHeader{ii}) = val;
            end
        else
            agent.(agentsHeader{ii}) = numval;
        end
    end
    agents(count) = agent;
    %agents = [agents; agent];
    s = fgets(fid);
end


end

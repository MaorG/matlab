%new script

init

% read and score
dirname = 'C:\simulators\RepastSimphony-2.3.1\simulations\s_vs_no_s_01\';
filter = @(d) (d.intervalNum == 160);
allData = processOutput(dirname, filter);
allData = scoreAllData(allData, 'p10', @getCountOfPopulation, 'dbact10');
allData = scoreAllData(allData, 'p11', @getCountOfPopulation, 'dbact11');


expression = '[\w\.]*';

% interpret
if isfield(allData(1), 'stratexpr1')
    for i = 1:numel(allData)
        nums = regexp(allData(i).stratexpr1,expression,'match');
        allData(i).prefrate = str2double(nums{1});
        allData(i).randrate = str2double(nums{9});
        allData(i).sthresh1 = str2double(nums{8});
        allData(i).s1 = allData(i).sthresh1;
    end
end

if isfield(allData(1), 'death')
    for i = 1:numel(allData)
        nums = regexp(allData(i).death,expression,'match');
        allData(i).d1 = str2double(nums{1});
    end
end

for i = 1:numel(allData)
    if (allData(i).prefrate > 0)
        allData(i).attach = 1;
    else
        if (allData(i).randrate > 0.5 )
            allData(i).attach = 2;
        else
            allData(i).attach = 0;
        end
    end
end



% store in ndtable
pNames = {'time', 'conc', 'd1', 's1', 'attach'}; 

rt10 = createNDResultTable(allData, 'p10', pNames);
rt11 = createNDResultTable(allData, 'p11', pNames);

% get mean and ste

TT = rt10.T;
for i = 1:numel(TT)
    if (~isempty(TT{i}))

        m10 = mean(cell2mat(rt10.T{i}));
        m11 = mean(cell2mat(rt11.T{i}));
        s10 = std(cell2mat(rt10.T{i}))/sqrt(cell2mat(rt10.T{i}));
        s11 = std(cell2mat(rt11.T{i}))/sqrt(cell2mat(rt11.T{i}));

        m1 = mean(cell2mat(rt10.T{i}) + cell2mat(rt11.T{i}));
        s1 = std(cell2mat(rt11.T{i}) + cell2mat(rt10.T{i})) / sqrt(numel(cell2mat(rt10.T{i})));
        TT{i} = {[m1,s1, m10, m11]};
    else
        TT{i} = {nan};
    end
end

% manipulate data
rt2 = rt10;
rt2.T = TT;


rt3 = colateFieldResultTable(rt2, 'd1');

ppp = @(m) plot2d(m,1);
tableUI(rt3,ppp,[])

rt3 = colateFieldResultTable(rt2, 'attach');

% table 2 mat
TT = rt3.T;
mat = nan(size(TT));
for i = 1:numel(TT)
    if (~isempty(TT{i}))
        v0 = TT{i}{1}(2,1);
        v1 = TT{i}{1}(2,2);
        v2 = TT{i}{1}(2,3);
        
        if v0 > v1 && v0 > v2
            mat(i) = 0;
        elseif v1 > v2
            mat(i) = 1;
        else
            mat(i) = 2;
        end
    else
        TT{i} = {nan};
    end
end

mat2 = reshape(mat,[4,6]);





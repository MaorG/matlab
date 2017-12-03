%%new script

init

%% read and score
dirname = 'C:\simulators\RepastSimphony-2.3.1\simulations\s_vs_no_s_01\light\';
filter = @(d) (d.intervalNum == 160);
allData = parseExperimentDir(dirname, true, filter);
allData = scoreAllData(allData, 'p10', @getCountOfPopulation, 'dbact10');
allData = scoreAllData(allData, 'p11', @getCountOfPopulation, 'dbact11');


expression = '[\w\.]*';

%% interpret
if isfield(allData(1), 'stratexpr1')
    for i = 1:numel(allData)
        nums = regexp(allData(i).stratexpr1,expression,'match');
        allData(i).prefrate = str2double(nums{1});
        allData(i).randrate = str2double(nums{9});
        allData(i).sthresh1 = str2double(nums{8});
        allData(i).s1 = allData(i).sthresh1;
        
        if (allData(i).prefrate > 0)
            allData(i).strat = 1;
        else
            allData(i).strat = 0;
        end
    end
end

if isfield(allData(1), 'death')
    for i = 1:numel(allData)
        nums = regexp(allData(i).death,expression,'match');
        allData(i).d1 = str2double(nums{1});
    end
end

randData = [];
prefData = [];
for i = 1:numel(allData)
    if (allData(i).strat)
        prefData = [prefData; allData(i)];
    else
        randData = [randData; allData(i)];
    end
end

% store in ndtable

pNames = {'time', 'conc', 'd1', 'randrate'}; 
rt10 = createNDResultTable(randData, 'p10', pNames);
rt11 = createNDResultTable(randData, 'p11', pNames);

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
rtrand = rt10;
rtrand.T = TT;
rtrand = colateFieldResultTable(rtrand, 'randrate');

pNames = {'time', 'conc', 'd1'}; 
rt10 = createNDResultTable(prefData, 'p10', pNames);
rt11 = createNDResultTable(prefData, 'p11', pNames);

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
rtpref = rt10;
rtpref.T = TT;

TTr = rtrand.T;
TTp = rtpref.T;
for i = 1:numel(TTr)
    if (~isempty(TTr{i}))
        m = struct;
        m.r = TTr{i};
        m.p = TTp{i};
        

        
        % get slope of fraction of planktonic along the random variables
         x = m.r{1}(2,:);
         y = m.r{1}(4,:) ./ ( m.r{1}(4,:) + m.r{1}(5,:) );
         
         p = polyfit(x,y,1);
        
        
        TT{i} = {[m,m]};
    else
        TT{i} = {nan};
    end
end

% manipulate data
rtcomb = rtpref;
rtcomb.T = TT;



%show
sss = @(m) plot2d(m,'combo_dual_axes');
tableUI(rtcomb,sss,[]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555
% just extracting some value
TT = rtcomb.T;
for i = 1:numel(TT)
    if (~isempty(TT{i}))
        TT{i} = mean(rtcomb.T{i}{1}(1).r{1}(2,:));
    else
        TT{i} = {nan};
    end
end

% manipulate data
rtval1 = rt10;
rtval1.T = TT;

TT = rtcomb.T;
for i = 1:numel(TT)
    if (~isempty(TT{i}))
        TT{i} = rtcomb.T{i}{1}(1).p{1}(1);
    else
        TT{i} = {nan};
    end
end

% manipulate data
rtval2 = rt10;
rtval2.T = TT;




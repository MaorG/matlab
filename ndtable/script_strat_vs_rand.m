function script_strat_vs_rand(allDataStrat, allDataRand)

    pNames = {'time', 'conc', 'd1', 's1'}; 
    rtStrat = createRT(allDataStrat, pNames, 's1');
    rtRand = createRT(allDataRand, pNames, 'attachRandom');

end

function rt = mergeRT(rtStrat, rtRand)

    rt = 

    resultTable.dims = dims;
    resultTable.names = pNames;
    resultTable.vals = pVals;
    resultTable.strvals = cell(size(pVals));
    for ii = 1:numel(pVals)
        strs = cell(0);
        for jj = 1:numel(pVals{ii})
            if isnumeric(pVals{ii}(jj))
                str = num2str(pVals{ii}(jj));
            else
                str = pVals{ii}(jj);
            end  
        strs = [strs str];
        end
        resultTable.strvals{ii} = strs;
    end
    
end

function rt = createRT(allData, pNames, colateBy)

    

    rt00 = createNDResultTable(allData, 'p10', pNames);
    rt01 = createNDResultTable(allData, 'p11', pNames);
    
    rt00m = rt00;
    rt00m.T =  cellfun(@(t) {mean(cell2mat(t))}, rt00.T, 'UniformOutput', false);
    rt00s = rt00;
    rt00s.T =  cellfun(@(t) {std(cell2mat(t)) / sqrt(length(cell2mat(t)))}, rt00.T, 'UniformOutput', false);
    
    rt01m = rt01;
    rt01m.T =  cellfun(@(t) {mean(cell2mat(t))}, rt01.T, 'UniformOutput', false);
    rt01s = rt01;
    rt01s.T =  cellfun(@(t) {std(cell2mat(t)) / sqrt(length(cell2mat(t)))}, rt01.T, 'UniformOutput', false);
    
    rt02m = rt00;
    rt02m.T =  cellfun(@(t, s) {mean(cell2mat(t) + cell2mat(s))}, rt01.T, rt00.T, 'UniformOutput', false);
    rt02s = rt00;
    rt02s.T =  cellfun(@(t, s) {std(cell2mat(t) + cell2mat(s))  / sqrt(length(cell2mat(t)))}, rt01.T, rt00.T, 'UniformOutput', false);
    
   
    TT = rt00m.T;
    for i = 1:numel(TT)
        if (~isempty(rt00m.T{i}))
            p00m = rt00m.T{i}{1};
            p00s = rt00s.T{i}{1};
            p01m = rt01m.T{i}{1};
            p01s = rt01s.T{i}{1};
            p02m = rt02m.T{i}{1};
            p02s = rt02s.T{i}{1};

            
            TT{i} = {[p00m,p00s,p01m,p01s,p02m,p02s]};
        else
            TT{i} = {nan};
        end
    end
    
    rt2 = rt02m;
    rt2.T = TT;
    rt = colateFieldResultTable(rt2, colateBy);
    
end
function [resultTable] = flattenResultTable(resultTable, fieldName)

lengths = cellfun(@(x) (numel(x(:))), resultTable.T);
lengths = cellfun('length', resultTable.T);
maxLength = max(reshape(lengths,1,[]));

newDims = [resultTable.dims, maxLength];
newNames = [resultTable.names; {fieldName}];
newVals = [resultTable.vals; cell({1:maxLength})];

A = cellfun(@(x) padcellarray(x(:), maxLength), resultTable.T, 'UniformOutput', false);
newT = cell(newDims);

N = prod(resultTable.dims);
M = maxLength;

for i = 1:N
    for j = 1:M
        
        out = cell(size(resultTable.dims));
        [out{:}] = ind2sub(resultTable.dims, i);
        
        
        subb = [cell2mat(out), j]';
        args = cell([numel(newDims) + 1,1]);
        args{1} = newDims;
        for k = 1:numel(subb)
            args{k+1} = subb(k);
        end
        
        indn = sub2ind(args{:});
        newT{indn} = A{i}(j);
    end
end

resultTable.dims = newDims;
resultTable.names = newNames;
resultTable.vals = newVals;
resultTable.T = newT;

end
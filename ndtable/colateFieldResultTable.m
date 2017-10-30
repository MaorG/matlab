function [resultTable] = colateFieldResultTable(resultTable, fieldName)

dimIndex = cellfun(@(x) strcmp(x, fieldName), resultTable.names);

[~,newDimOrder] = sort(dimIndex);

newDims = resultTable.dims(newDimOrder(1:end-1));
newNames = resultTable.names(newDimOrder(1:end-1));
newVals = resultTable.vals(newDimOrder(1:end-1));
newStrvals = resultTable.strvals(newDimOrder(1:end-1));

X =  cell2mat(resultTable.vals(dimIndex));

permutedDims = resultTable.dims(newDimOrder);
permutedT = permute(resultTable.T, newDimOrder);
newT = cell(newDims);

N = prod(newDims);
M = numel(X);

examplaryIndex = 1;
% while(isempty(permutedT{examplaryIndex}) || sum(sum(isnan(permutedT{examplaryIndex}{1}))) > 0)
%     examplaryIndex = examplaryIndex + 1;
% end

if (numel(permutedT{examplaryIndex}{1}) == 1)
%input is scalar, create 1D vec
    for i = 1:N
        newSub = cell(size(newDims));
        [newSub{:}] = ind2sub(newDims, i);
        Y = zeros(size(X));
        for j = 1:M
            permutedSub = [newSub, j];
            args = cell([numel( resultTable.dims) + 1, 1]);
            args{1} = permutedDims;
            for k = 1:numel(permutedSub)
                args(k+1) = permutedSub(k);
            end

            indn = sub2ind(args{:});
            ~isempty(cell2mat(permutedT{indn}))
            ~isnan(permutedT{indn}{1})
            if (~isempty(cell2mat(permutedT{indn})) & ~isnan(permutedT{indn}{1}))
                Y(j) = cell2mat(permutedT{indn});
            else
                
            end
        end
        newT{i} = {[X ; Y]};
    end
elseif (isvector(permutedT{examplaryIndex}{1}))
%input is vector, create 2D mat
   for i = 1:N
        newSub = cell(size(newDims));
        [newSub{:}] = ind2sub(newDims, i);
        Y = zeros(numel(permutedT{examplaryIndex}{1}), numel(X));
        for j = 1:M
            permutedSub = [newSub, j];
            args = cell([numel( resultTable.dims) + 1, 1]);
            args{1} = permutedDims;
            for k = 1:numel(permutedSub)
                args(k+1) = permutedSub(k);
            end
            indn = sub2ind(args{:});
            try
            if (~isempty( permutedT{indn}))
                Y(:,j) = cell2mat(permutedT{indn});
            end
            catch
               a = 1 
            end
        end
        newT{i} = {[X ; Y]};
    end
else  
%2D
    % assuming T cells all contain 2-by-K, where first row is the value
    % and the second is the param
    Y = permutedT{examplaryIndex}{1}(1,:);
    for i = 1:N
        newSub = cell(size(newDims));
        [newSub{:}] = ind2sub(newDims, i);
        Z = zeros([numel(X), numel(Y)]);
        for j = 1:M
            permutedSub = [newSub, j];
            args = cell([numel( resultTable.dims) + 1, 1]);
            args{1} = permutedDims;
            for k = 1:numel(permutedSub)
                args(k+1) = permutedSub(k);
            end

            indn = sub2ind(args{:});
            if (~isempty( permutedT{indn}))
                Z(j,:) = permutedT{indn}{1}(2,:);
            end
        end
        [YY, XX] = meshgrid(Y, X);
        newT{i} = {cat(3, XX, YY, Z)};
    end
    
end

resultTable.dims = newDims;
resultTable.names = newNames;
resultTable.vals = newVals;
resultTable.strvals = newStrvals;
resultTable.T = newT;

end
classdef ScoreTable
    properties
        paramAName
        paramBName
        XY
        raw
        T
    end
    
    methods
        function ST = ScoreTable(data, paramN, paramB, result)
            % returns a 2d cell mat of size determined by occurences of properties named
            % paramA and paramB, a cell for each result
            % if data is composed of individual data entries, create a table of cells,
            % each containing a value, a vector or a matrix, created by getting all the
            % results named "result"
            % creates a table of cells, each containing a cell array of the
            % results
            
            
            valsA = extractfield(data, paramA);
            valsB = extractfield(data, paramB);
            
            valsA = sort(unique(valsA));
            valsB = sort(unique(valsB));
            
            ST.XY = meshgrid(valsA, valsB);
            
            rawT = cell(numel(valsA),numel(valsB));
            
            for ii = 1:numel(rawT)
                rawT{ii}{1} = cell(0);
            end
            
            for frame = data'
                idxA = find(valsA == frame.(paramA));
                idxB = find(valsB == frame.(paramB));
                
                
                rawT{idxA, idxB}{1} = [rawT{idxA, idxB}{1}; frame.(result)];
            end
            
            ST.raw = rawT;
        end
        
        function [] = show(ST)
            
            data = ST.raw{1,1}{1};
            
            if ( numel(data) == 1)
                % single entry per ST cell
                
                datum = data{1};
                
                if ( numel(datum) == 1)
                    % the data in the entries is a scalar
                    'single scalar per cell'
                else
                    % the data in the entires is not a scalar
                    'single matrix per cell'
                    
                end
                
            else
                
                % there are multiple entries per ST cell
                datum = data{1};
                
                if ( numel(datum) == 1)
                    % the data in the entries is a scalar
                    'many scalars per cell'
                else
                    % the data in the entires is not a scalar
                    'many matrices per cell'
                    showTable(ST)
                end
            end
            
            
        end
        
        
        function [] = showTable(ST)
            figure;
            [cols, rows] = size(ST.raw);
            for row = 1:rows
                for col = 1:cols
                    
                    h = subplot(rows,cols,((col - 1) * cols) + (rows + 1 - row));
                    
                    ax=get(h,'Position');
                    ax(4)=ax(4)*1.25;
                    ax(3)=ax(3)*1.25;
                    set(h,'Position',ax);
                    
                    
                    hold on;
                    
                    
                    data = ST.raw{col, row}{1};
                    for entry = data'
                        vx = entry{1}(1,:);
                        vy = entry{1}(2,:);
                        plot(vx, vy);
                    end
                end
            end
        end
        
    end
    
    
    
    
    methods (Static)
        
    end
    
    
    
end


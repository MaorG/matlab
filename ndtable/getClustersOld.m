function [ids] = getClustersOld (data, varargin)

tol = 0.1;
nVarargs = length(varargin{1});
if (nVarargs == 1) 
    tol = varargin{1}{1};
end

if (numel(data.agents) == 0)
    ids = [];
    return
end

width = data.width*data.scale;
height = data.height*data.scale;
x = extractfield(data.agents, 'X');
y = extractfield(data.agents, 'Y');
r = extractfield(data.agents, 'radius');
attached = extractfield(data.agents, 'attached');
ids = zeros(numel(x),1);
next_id = 1;

% ignore detached
if true

    x(attached == 0) = nan;
    y(attached == 0) = nan;
    r(attached == 0) = nan;
end

entry_x = x - r;
exit_x = x + r + tol;

[entry_x, entry_indices] = sort(entry_x);
[exit_x, exit_indices] = sort(exit_x);

[scanline_y, scanline_indices] = sort(y);
scanline_member = zeros(numel(y), 1);
inverse_scanline_indices (scanline_indices) = 1:numel(scanline_y);

i_entry = 1;
i_exit = 1;

% scan line algorithm
for i = 1:2 * numel(x(~isnan(x)))
    
    %dirty limits business - in the end it's gonna be a torus so maybe....
    if (i_entry <= numel(entry_x))
        next_x_entry = entry_x(i_entry);
    else
        next_x_entry = (exit_x(end) + 100000);
    end
    
    if (i_exit <= numel(entry_x))
        next_x_exit = exit_x(i_exit);
    else
        next_x_exit = (exit_x(end) + 100000);
    end
    
    if (next_x_entry < next_x_exit)
        % insertion event: put in scan line
        index = entry_indices(i_entry);
        scanline_member(inverse_scanline_indices(index)) = 1;
        
        % since 2 clusters can meet at current index, this flag marks that
        % we alreay found a neighbor. if we find another we need to set the
        % same id for both clusters
        firstId = 0;
        for j = 1:numel((~isnan(x)))

            % if turtle #j is in the scanline, and not the same as #i
            if j ~= index && scanline_member(inverse_scanline_indices(j)) == 1
                if check_overlap(x(index), y(index), r(index), x(j), y(j), r(j), tol) || ...
                   check_overlap(x(index), height + y(index), r(index), x(j), y(j), r(j), tol) || ...
                   check_overlap(x(index), y(index), r(index), x(j), height + y(j), r(j), tol)
                    if (firstId == 0)
                        ids(index) = ids(j);
                        firstId = ids(j);
                    elseif (firstId == ids(j))
                        %already in the same cluser...
                       ids(ids == ids(j)) = firstId; 
                    else
                       ids(ids == ids(j)) = firstId; 
                    end
                end
            end
        end
        if (ids(index) == 0)
            ids(index) = next_id;
            next_id = next_id + 1;
        end
        
        

        i_entry = i_entry + 1;
    else
        index = exit_indices(i_exit);
        scanline_member(inverse_scanline_indices(index)) = 0;
       
        i_exit = i_exit + 1;
    end
end

% now do the same +-tol from left and right edges

entry_x = x;
exit_x = x;

[entry_x, entry_indices] = sort(entry_x);
[exit_x, exit_indices] = sort(exit_x);

% get the indices of the leftmostt entries and rightmost exits

left_entries_mask = entry_x < 0 + tol;
right_exits_mask = exit_x > width - tol;

left_entries_indices = find(left_entries_mask);
right_exits_indices = find(right_exits_mask);

% just compare all pairs

for entry_index = left_entries_indices
    for exit_index = right_exits_indices
        real_entry_index = entry_indices(entry_index);
        real_exit_index = exit_indices(exit_index);
        
        %[x(real_entry_index)+width, y(real_entry_index), x(real_exit_index), y(real_exit_index)]
        if check_overlap(x(real_entry_index) + width, y(real_entry_index), r(real_entry_index), x(real_exit_index), y(real_exit_index), r(real_exit_index), tol)
            entry_id = ids(real_entry_index);
            ids(ids == ids(real_exit_index)) = entry_id; 
        end
    end
end




[~, ~, ids] = unique(ids);

ids(attached == 0) = nan;

end

function [isOverlapping] = check_overlap(x1, y1, r1, x2, y2, r2, tol)
isOverlapping = (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) < (r1 + r2 + tol) * (r1 + r2 + tol);
end



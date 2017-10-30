function [ids] = getClusterSizeHist (data, varargin)


tol = 0.1;
x = data.turtles.xcor;
y = data.turtles.ycor;
r = data.turtles.size .* 0.5;
ids = zeros(numel(x),1);
next_id = 1;

entry_x = x - r;
exit_x = x + r;

[entry_x, entry_indices] = sort(entry_x);
[exit_x, exit_indices] = sort(exit_x);

[scanline_y, scanline_indices] = sort(y);
scanline_member = zeros(numel(y), 1);
inverse_scanline_indices (scanline_indices) = 1:numel(scanline_y);

i_entry = 1;
i_exit = 1;

% scan line algorithm
for i = 1:2 * numel(x)
    
    %dirty limits business - in the end it's gonna be a torus so maybe....
    if (i_entry <= numel(entry_x))
        next_x_entry = entry_x(i_entry);
    else
        next_x_entry = (exit_x(end) + 1000);
    end
    
    if (i_exit <= numel(entry_x))
        next_x_exit = exit_x(i_exit);
    else
        next_x_exit = (exit_x(end) + 1000);
    end
    
    if (next_x_entry < next_x_exit)
        % insertion event: put in scan line
        index = entry_indices(i_entry);
        scanline_member(inverse_scanline_indices(index)) = 1
        ['entry: ', num2str(index)]%, ' ', num2str(inverse_scanline_indices(index))]
        for j = 1:numel(x)
            firstId = 0;
            inverse_scanline_indices(j)
            
            % if turtle #j is in the scanline, and not the same as #i
            if j ~= index && scanline_member(inverse_scanline_indices(j)) == 1
                if check_overlap(x(index), y(index), r(index), x(j), y(j), r(j), tol)
                    if (firstId == 0)
                        ids(index) = ids(j);
                        firstId = ids(j);
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
        index = entry_indices(i_exit);
        scanline_member(inverse_scanline_indices(index)) = 0;
        ['exit: ', num2str(index)]%, ' ', num2str(inverse_scanline_indices(index))]
        
        i_exit = i_exit + 1;
    end
end

ids
end

function [isOverlapping] = check_overlap(x1, y1, r1, x2, y2, r2, tol)
isOverlapping = (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) < (r1 + r2) * (r1 + r2) * (1+tol);
end



function [result] = getMixNgh (input, varargin)

    world = input.world;
  
    result = calcMixNghAtScale(world, 4);
end

function [mixMap] = calcMixNghAtScale (world, scale)

    w1 = padarray(world, [scale, scale]);
    w2 = padarray(world, [scale, scale], 'circular');

    [row1, col1] = find(w1 ~= 0);

    %prepare mask

    
    cx = scale + 1;
    cy = scale + 1;
    r = scale;
    
    [x,y]=meshgrid(1:1+2*scale, 1:1+2*scale);
    c_mask = ((x-cx).^2 + (y-cy).^2 <= r^2);
    
    mixMap = zeros(sum(sum(c_mask)) + [1,1]);
    
    %for each agent, look at ngh and count similar and dissimilar
    
    for i = 1:numel(row1)
       
        type = w1(row1(i), col1(i));

        ngh = w2((row1(i) - scale):(row1(i) + scale), (col1(i) - scale):(col1(i) + scale));
        
        circ_ngh = ngh.*c_mask;
        
        countSame = sum(sum(circ_ngh == type));
        countOther = sum(sum(circ_ngh ~= 0 & circ_ngh ~= type));
        
        mixMap(countSame+1, countOther+1) = mixMap(countSame+1, countOther+1) + 1;
    
    end    
end
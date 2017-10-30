function [ score ] = getH (I)
    [G, S] = graycomatrix(I, 'NumLevels', 3, 'offset', [0 1; 1 0 ; 1 1; 1 -1], 'Symmetric', true, 'g', [1, 2]);
    
    tot = sum(sum(sum(G(2:3, 2:3, :))));
    frontline = sum(G(2,3,:)) + sum (G(3,2,:));
    
    score  = frontline / tot;
end
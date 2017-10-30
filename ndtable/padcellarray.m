function [B] = padcellarray(A, dim)

    B = cell(dim, 1);
    
    nA = numel(A);
    
    B(1:nA) = A;
    

end
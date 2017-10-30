function [energy] = getHomogenity (data)
    world = data.world;
    ngh = 3;
    offsets = [];
    for ii = 1:ngh
        offsets = [offsets ; [0,ii]];
        for jj = -ngh:ngh
            offsets = [offsets ; [ii,jj]];
        end
    end
    
    glcm = graycomatrix(world, 'NumLevels', 3, 'offset', offsets, 'Symmetric', true, 'GrayLimits', []);

    glcm = glcm(2:3, 2:3, :);
    stats = graycoprops(glcm,{'Homogeneity'});
    energy = mean(stats.Homogeneity);
end
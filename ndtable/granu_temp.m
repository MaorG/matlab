% granularity experimants
runs = getRunsByParams(cruns, 'paramA', 1, 'paramB', 1, 'paramC', -3);

run = runs{1};
granu = [];

for step = 1:size(run,1)
    snapshot = run(step);
    
    I = snapshot.world;
    
    I1 = I==1;
    I1d = imclose(I1, strel('disk', 2));
    
    figure(2);
    imshow(I1)
    
    figure(3);
    imshow(I1d);
    
    radius_range = 0:22;
    intensity_area = zeros(size(radius_range));
    for counter = radius_range
        remain = imopen(I1d, strel('disk', counter));
        intensity_area(counter + 1) = sum(remain(:));
    end
    %     figure
    %     plot(intensity_area, 'm - *')
    %     grid on
    %     title('Sum of pixel values in opened image versus radius')
    %     xlabel('radius of opening (pixels)')
    %     ylabel('pixel value sum of opened objects (intensity)')
    
    intensity_area_prime = diff(intensity_area);
    %     plot(intensity_area_prime, 'm - *')
    %     grid on
    %     title('Granulometry (Size Distribution) of Snowflakes')
    %     ax = gca;
    %     ax.XTick = [0 2 4 6 8 10 12 14 16 18 20 22];
    %     xlabel('radius of snowflakes (pixels)')
    %     ylabel('Sum of pixel values in snowflakes as a function of radius')
    
    granu = [granu ; intensity_area_prime];
    
end

figure;
surf(granu);

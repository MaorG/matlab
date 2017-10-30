function [] = print_world( world )

CMap = [
    0, 0, 0;
    1, 0.2, 0.2;
    0.2, 1, 0.2;
    0.2, 0.2, 1
    ];
colorMat  = ind2rgb(world + 1, CMap);

imshow(colorMat);

end


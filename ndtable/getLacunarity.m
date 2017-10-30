function [Lacunarity] = getLacunarity (input, varargin)

%     show = false;
%     if (length(varargin) > 0 && varargin{1} == true)
%         show = true;
%     end
    world = input.world;
    w = size(world, 1);
    h = size(world, 2);
    tiled = repmat(world,2);
    
    max_scale = min([w,h]);
    scale = 2;
    Lacunarity = [];
    Z1 = 0;
    Z2 = 0;
    while (scale <= max_scale) 
        
        s = calcMassAtScale(tiled, 1, w, h, scale);
        
        Lacunarity = [ Lacunarity ; [double(scale), (double(s))]];
                
        scale = 2 * scale;
    end
    
%     while (size(ratioAtScale,1) > 1 && ratioAtScale(end,2)==0 && ratioAtScale(end-1,2)==0) 
%         ratioAtScale(end,:) = []; 
%     end
    
    try
        %fitResult = fit(Lacunarity(:,1),Lacunarity(:,2),'exp1');
        %plot(fitResult,Lacunarity(:,1),(Lacunarity(:,2)));
        %result = coeffvalues(fitResult);
    catch
        %result = [NaN, NaN]; 
    end
    

end

function [Lacu] = calcMassAtScale (tiledworld, type, w, h, scale)
    Z1 = 0;
    Z2 = 0;
    for i = 1:w
        for j = 1:h
           
            temp = sum(sum((tiledworld(i:(i+scale-1), j:(j+scale-1)) == type)));
            
            Z1 = Z1 + temp;
            Z2 = Z2 + temp*temp;
            
        end
    end

    Z1 = Z1 / (w*h);
    Z2 = Z2 / (w*h);
    Lacu = Z2 / (Z1 * Z1);
end
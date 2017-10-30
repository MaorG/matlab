function [result] = getHausDim (input)

 world = input.world;
 
 world = world(world == 1);
 
 result = hausDim(world);
 
end

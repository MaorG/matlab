function [SI] = getSI (input)

for index=1:2
    world = input.world;
    
    temp = (world == index);
    se = strel('disk',1);
    counter(index) = sum(sum(temp));
    temp = imdilate(temp,se); % try erode!
    ccAmount = size(unique(ccPeriodic(temp)),1) - 1;
    cc(index) = ccAmount;
end

if (cc(1) == 0 || cc(2) == 0)
    SI = 0;
else
%    SI = ((counter(1)/ cc(1)) + (counter(2)/ cc(2)));
    SI = ( cc(1) / (counter(1)) + (cc(2) / counter(2)));
end

end
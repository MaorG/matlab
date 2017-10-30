function [result] = getBorderArea (input, varargin)

world = input.world;

[h, w] = size(world);

r = varargin{1}{1};
se = strel('disk',r);        

I = zeros(size(world));

I1 = world == 1;
I2 = world == 2;

I1d = imdilate(I1,se);
I2d = imdilate(I2,se);

Ir = I1d & I2d;

Iind = imerode(Ir,se);

It = Iind & (world ~= 0);

figure;

subplot(1,4,1);
print_world(world);
subplot(1,4,2);
imshow(Ir);
subplot(1,4,3);
imshow(Iind);
subplot(1,4,4);
imshow(It)

% for i = 1:h
%     for j = 1:w
%         [rr, cc] = meshgrid(1:h, 1:w);
%         mask = sqrt((rr-j).^2+(cc-i).^2) < r;
%         
%         maskArea = sum(sum(mask));
%         if (maskArea > 0)
%             masked = world.*mask;
%             amount = any (masked(:) == 2) && any(masked(:) == 1);
%             
%             I(i,j) = amount;
%             
%             
%             
%         end
%     end
% end

result = sum(sum(It)) / sum(sum(I1 + I2));

end
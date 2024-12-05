function im = diverging_imagesc(x, y, C)
% `imagesc` with a diverging color map.

color_range = max(abs(C), [], "all");

im = imagesc(x, y, C, [-1, 1] * color_range);
colorbar;
colormap(slanCM("PiYG"));

end

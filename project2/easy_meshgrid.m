function [X, Y, dx] = easy_meshgrid(XV, YV)
    %m = size(polygon, 1);
    n = 100; % Larger is slower
    
    xmin = min(XV, [], 1);
    xmax = max(XV, [], 1);
    
    ymin = min(YV, [], 1);
    ymax = max(YV, [], 1);
    
    width = xmax-xmin;
    height = ymax-ymin;
    
    xmin = xmin-0.1*width;
    xmax = xmax+0.1*width;
    ymin = ymin-0.1*height;
    ymax = ymax+0.1*height;
    
    dx = (xmax-xmin) / n;
    
    x1d = xmin:dx:xmax;
    y1d = ymin:dx:ymax;
    
    [X, Y] = meshgrid(x1d, y1d);
    
end
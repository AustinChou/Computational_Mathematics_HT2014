function [XV, YV] = polygonal_boundary(fname, make_plots)
    % Use crystal_bdy.txt for default in this case
    if nargin < 2
        make_plots = false;
    end
    
    fid = fopen(fname, 'r');
    %Vertices = [];
    XV = []; YV = [];
    
    tline = fgetl(fid);
    while ischar(tline)
        p = sscanf(tline, ' %g %g', [1,2]);
        x = p(1,1);
        y = p(1,2);
        %Vertices = [Vertices;x,y];
        XV = [XV;x];
        YV = [YV;y];
        %disp([num2str(x), '|', num2str(y)]);
        tline = fgetl(fid);
    end
    
    if make_plots
        m = size(XV, 1);
        %clf;
        for i = 1:m
            hold on;
            %plot(Vertices(i,1), Vertices(i,2), 'Color', 'red', 'Marker', 'o');
            if i == m
                j = 1;
            else
                j = i+1;
            end
            plot([XV(i,1), XV(j,1)], [YV(i,1), YV(j,1)], 'Color', 'k', 'LineWidth', 2);
            hold off;
        end
    end
end
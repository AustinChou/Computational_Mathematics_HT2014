function [M, Faces] = compute_vertices(evs, x, y, dx, G)
    [Vertices, Faces] = simple_ply_loader('crystal_flat.ply'); 
    ev = abs(evs(:,2));
    u = zeros(size(G));
    u(G>0) = ev;
    
    M = [];
    m = size(Vertices,1);
    
    % This loop is to find the cloest point to a point in 
    % Vertices matrix on the meshgrid we defined, I use a 
    % dirty and quick method.
    for i = 1:m
        p = 0; q = 0;
        point = Vertices(i,:);
        
        for j = 1:size(x,2)
            if abs(point(1,1)-x(1,j)) <= dx/2
                break;
            end
        end
        
        for k = 1:size(y,1)
            if abs(point(1,2)-y(k,1)) <= dx/2
                break;
            end
        end
        % now the point z axis value is in u(q,p)
        point(1,3) = u(k,j);
        
        M = [M; point];
    end
end
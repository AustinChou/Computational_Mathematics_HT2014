function ret = is_planar_embedding(V, E, opt)
    points = 0;
    edges = 0;
    L = zeros(0, 4);
    n = size(V,1);
    for i = 1:n
        for j = 1:i
            if E(i, j) == 1
                XY = [V(i,1) V(i,2) V(j,1) V(j,2)];
                L = [L; XY];
                edges = edges + 1;
            end
        end
    end
    for i = 1:edges-1
        for j = i:edges
            XY1 = L(i,:);
            XY2 = L(j,:);
            if ~isequal(XY1(1:2),XY2(1:2)) && ~isequal(XY1(3:4),XY2(1:2)) && ~isequal(XY1(1:2),XY2(3:4)) && ~isequal(XY1(3:4),XY2(3:4))
                result = lineSegmentIntersect(XY1, XY2);
                p = result.intAdjacencyMatrix;
                points = points + p;
                if nargin > 2 && opt == true && p > 0
                    hold on;
                    plot(result.intMatrixX, result.intMatrixY, 'Color', [127/255 15/255 127/255], 'Marker', '^', 'MarkerSize', 12);
                    hold off;
                end
            end
        end
    end
    if points > 0
        ret = false;
    else
        ret = true;
    end
end
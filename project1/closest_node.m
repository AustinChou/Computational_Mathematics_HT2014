function index = closest_node(V, x, y)
    index = 1;
    n = size(V,1);
    min_dist = 0;
    if n < 3
        error('n is less than 3');
    end
    for i = 1:n
        l = sqrt((x-V(i,1))^2 + (y-V(i,2))^2);
        if i == 1 || l < min_dist
            index = i;
            min_dist = l;
        end
    end
end
function plot_graph(V,E)
    n = size(V,1);
    if n ~= size(E,1)
        error('V and E have different size');
    else
        clf;
        axis([0 1 0 1]);
        hold on;
        for i = 1:n
            plot(V(i,1), V(i,2), 'Color', 'red', 'Marker', 'o', 'MarkerSize', 12);
        end
        for i = 1:n
            for j = 1:i
                if E(i, j) == 1
                    plot([V(i,1), V(j,1)],[V(i,2), V(j,2)], 'Color', 'blue', 'LineWidth', 0.5);
                end
            end
        end
        hold off;
    end
end
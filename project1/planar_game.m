function planar_game(n)
    %% Start a planar game
    %  n stands for vertices amount
    %  m stands for line amount
    %  If any lines doesn't have intersect, user win
    
    if nargin < 1
        error('Vertices mount n is required!');
    end
    
    m = randi([n, 3*n-6]);
    clear V E;
    V = rand(n, 2);
    % In case user win at the game start
    % Matlab doesn't support do...while... statement
    E = make_rand_edges(n, m);
    while is_planar_embedding(V, E) == true
        E = make_rand_edges(n, m);
    end
    
    figure;
    plot_graph(V, E);
    cmode = 1;
    index = 1;
    while(1)
        [x, y, button] = ginput(1);
        if button == 'q'
            title('quiting');
            break;
        end
        title(['Playing --- Mode', num2str(cmode)]);
        if cmode == 1
            index = closest_node(V, x, y);
            hold on;
            plot(V(index,1), V(index,2), 'Color', 'red', 'Marker', 'p');
            hold off;
            cmode = 2;
            continue;
        end
        if cmode == 2
            V(index, 1) = x;
            V(index, 2) = y;
            plot_graph(V, E);
            if is_planar_embedding(V, E, true) == true
                title('You win this game!');
                return;
            end
            cmode = 1;
            continue;
        end
    end
end
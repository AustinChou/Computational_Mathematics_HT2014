function E = make_rand_edges(n, m)
    if m < n
        error('m is less than n');
    else
        E = zeros(n, n);
        % We make sure each node has a edge connect to it
        for i = 1:n
            index = randi([1,n]);
            % Dumb ways to use do...while
            while index == i || E(i, index) == 1
                index = randi([1,n]);
            end
            E(i, index) = 1;
            E(index, i) = 1;
        end
        edges = m - n;
        % Be careful when m > sum(1:n-1)
        while edges && ~isequal(ones(n,n) - diag(ones(n,1)), E)
            row = randi([1, n]);
            col = randi([1, n]);
            while row == col || E(row, col) == 1
                row = randi([1, n]);
                col = randi([1, n]);
            end
            E(row, col) = 1;
            E(col, row) = 1;
            edges = edges - 1;
        end
    end
end
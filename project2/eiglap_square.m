function [ef, lambda] = eiglap_square(m, n, x, y)
    % See project1.pdf exercise 1 for detail solution
    % Now that we just hard-code it by hand
    ef = sin(m*x)*sin(n*y);
    lambda = n^2 + m^2;
end

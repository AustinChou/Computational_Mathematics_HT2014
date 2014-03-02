function eiglap_square(n,m,x,y)
% n and m should be non-zero integer parameters. x and y should be symbolic
% variables.
if  rem(n,1) ~= 0 || rem(m,1) ~= 0 || n == 0 || m == 0
    error('n and m must be non-zero integers')
else
    ef = sin(n*x)*sin(m*y);
    lambda = double(n^2 + m^2);
end
[ef,lambda]
end  
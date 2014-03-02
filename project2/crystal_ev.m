function [ews, evs] = crystal_ev(xv,yv, make_plots)
% xv and yv should be the x and y coordinates of the vertices respectively
% and make_plots returns true or false.

  if nargin < 3
    make_plots = true;
  end

  n = 200;  % larger value gives more accuracy but slower

  %% make a rectangular grid that will contain the polygon
 x1 = min(xv);  x2 = max(xv);
y1 = min(yv);  y2 = max(yv);
w = min(x2-x1, y2-y1);
x1 = x1-0.1*w; x2 = x2+0.1*w;
y1 = y1-0.1*w; y2 = y2+0.1*w;
dx = (x2-x1) / n;
x1d = x1:dx:x2; y1d = y1:dx:y2;
[x,y] = meshgrid(x1d,y1d);

  %% An implicit representation of the shape
  % 0 inside and positive outside.
in_out_code = inpolygon(x,y,xv,yv);
G = zeros(size(in_out_code));
G(in_out_code) = 1;


  %% Build a grid
  % this is from numgrid.m: we choose an ordering for the points
  % inside the ellipse (all other points are labeled 0).
 k = find(G > 0.5);     % now find the linear index of these.
G = zeros(size(x));    % new all zero matrix
G(k) = (1:length(k))'; % label them inside ones from 1 upwards

  %figure(2); clf;
  %spy(G)
  %axis equal

  % build a finite different approximation to the Laplacian based on
  % the grid G
  L = delsq(G);
  L = 1/dx^2 * L;

  %% find the first 20 smallest magnitude eigenvalues
 tic
[evs, ews, flag] = eigs(L, 20, 'sm');
toc
if flag ~= 0
    error('convergence problem');
end
ews = diag(ews);
% sort the eigenvalues, we want the smallest first
[ews,I] = sort(ews);
% and re-arrange the eigenvectors too
evs = evs(:,I);
if (make_plots)
    figure(1); clf
    tic;
    for s = 1:16
        ev = abs(evs(:,s)); u = zeros(size(G)); u(G>0) = ev;
        u(G==0) = nan;   % optional, hide the outside
        subplot(4,4,s);
        % careful with this nan trick: its good for plotting but
        % could lead to trouble if u is used in a later computation.
        pcolor(x,y,u); shading flat; axis equal; axis tight;
        title(['em ' num2str(s) ' /ev=' num2str(ews(s))]);
    end
    figure(2); clf
    ev = abs(evs(:,2)); lambda = ews(2);
    u = zeros(size(G)); u(G>0) = ev; 
    
    surf(x,y,u);

    title(sprintf('2nd eigenmode, lambda = %g',lambda)); toc
    drawnow; pause(0);
end


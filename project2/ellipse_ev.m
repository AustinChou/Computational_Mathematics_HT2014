function [ews, evs, x, y, G] = ellipse_ev(a, b, make_plots)
%ELLIPSE_EV  Calculate Laplacian eigenvalues/functions of ellipse
%   [ews] = ellipse_ev(a,b);
%      returns the first 20 eigenvalues in 'ews' for an ellipse with
%      major semi-axis a and minor semi-axis b.
%
%   [ews] = ellipse_ev(a,b,false);
%   [ews] = ellipse_ev(a,b,true);
%      disables/enables the eigenmode plots.
%
%   [ews,evs] = ellipse_ev(a,b);
%      if you want the eigenfunctions and the eigenvalues.  The
%      eigenfunctions are the columns of evs.  See plotting code
%      for how to use them.
%
%   [ews,evs,x,y,G] = ellipse_ev(a,b);
%      Also return [x,y] the underlying meshgrid and G the list of
%      points actually used.  See the plotting code for how to use.
%
%   This code is inspired by:
%     <matlabroot>/toolbox/matlab/sparfun/numgrid.m
%   and uses matlab's DELSQ to build an approximate Laplacian.


  if nargin < 3
    make_plots = true;
  end

  n = 100;  % larger value gives more accuracy but slower

  %% make a rectangular grid that will contain the ellipse
  x1 = -a;  x2 = a;
  y1 = -b;  y2 = b;
  % now expand it a bit: add a margin of roughly 10%
  w = min(x2-x1, y2-y1);
  x1 = x1-0.1*w;
  x2 = x2+0.1*w;
  y1 = y1-0.1*w
  y2 = y2+0.1*w
  %x1 = floor(x1-0.1*w)    % or could round to integers
  %x2 = ceil(x2+0.1*w)

  dx = (x2-x1) / n;
  x1d = x1:dx:x2;
  y1d = y1:dx:y2;  % note last y pt isn't y2
  [x,y] = meshgrid(x1d,y1d);


  %% An implicit representation of the shape
  % negative inside and positive outside.
  % ellipse: x^2/a^2 + y^2/b^2 = 1
  A = x.^2 / a^2 + y.^2 / b^2 - 1;
  % or a rectangle:
  %A = max(abs(x)-a, abs(y)-b);

  %% Build a grid
  % this is from numgrid.m: we choose an ordering for the points
  % inside the ellipse (all other points are labeled 0).
  G = A < 0;             % first, label points inside with a 1.
  k = find(G);           % now find the linear index of these.
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
      ev = evs(:,s);
      subplot(4,4,s);
      u = zeros(size(G));
      u(G>0) = ev;
      % careful with this nan trick: its good for plotting but
      % could lead to trouble if u is used in a later computation.
      u(G==0) = nan;   % optional, hide the outside
      pcolor(x,y,u);
      shading flat;
      axis equal
      axis tight;
      hold on;
      th = linspace(0,2*pi,512);
      H = plot(a*cos(th),b*sin(th),'k-');
    end

    figure(2); clf
    ev = evs(:,10);
    lambda = ews(10);
    u = zeros(size(G));
    u(G>0) = ev;
    pcolor(x,y,u);
    shading flat;
    axis equal
    axis tight;
    hold on;
    th = linspace(0,2*pi,512);
    H = plot(a*cos(th),b*sin(th),'k-');
    set(H, 'linewidth', 2);

    title(sprintf('10th eigenmode, lambda = %g,  a = %g, b = %g', ...
                  lambda, a, b));
    toc
    drawnow
    pause(0);
  end


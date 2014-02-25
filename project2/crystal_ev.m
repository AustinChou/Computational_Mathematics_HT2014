function [ews, evs, x, y, dx, G] = crystal_ev(XV, YV, make_plots)
%%  This file is modified from ellipse_ev.m
%   Calculate Laplacian eigenvalues/functions of polygon
%   
%   [ews,evs] = crystal_ev(a,b);
%      if you want the eigenfunctions and the eigenvalues.  The
%      eigenfunctions are the columns of evs.  See plotting code
%      for how to use them.
%
%   [ews,evs,x,y,dx,G] = crystal_ev(a,b);
%      Also return [x,y] the underlying meshgrid and G the list of
%      points actually used.  See the plotting code for how to use.
%
%   This code is inspired by:
%     <matlabroot>/toolbox/matlab/sparfun/numgrid.m
%   and uses matlab's DELSQ to build an approximate Laplacian.

  if nargin < 3
    make_plots = true;
  end
  
  %% An implicit representation of the shape
  % 1 inside and 0 outside.
  
  [x,y,dx] = easy_meshgrid(XV,YV);
  G = inpolygon(x,y,XV,YV);
  

  %% Build a grid
  % this is from numgrid.m: we choose an ordering for the points
  % inside the polygon (all other points are labeled 0).
  %G = A < 0;             % first, label points inside with a 1.
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
      % Drawing boundary of polygon
      plot([XV;XV(1,:)],[YV;YV(1,:)],'k','linewidth',2);
    end

    figure(2); clf
    ev = evs(:,2);
    lambda = ews(2);
    u = zeros(size(G));
    u(G>0) = ev;
    % We need a 3D plot of 2th eigenmode
    surf(x,y,u);
    %shading flat;
    %axis equal
    %axis tight;
    hold on;
    plot([XV;XV(1,:)],[YV;YV(1,:)],'k','linewidth',2);
    title(sprintf('2th eigenmode of polygon, lambda = %g', lambda));
    toc
    drawnow
    pause(0);
  end


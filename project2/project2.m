%% Project 2 The South Crystal

%% Exercise 1
% Firstly we plot Annie's pig.
figure(1)
[Verticesannie, Facesannie] = simple_ply_loader('annies_pig.ply');
trimesh(Facesannie,Verticesannie(:,1),Verticesannie(:,2),Verticesannie(:,3));

%%
% Now we plot Stanford's bunny.
figure(2)
[Verticesstanford, Facesstanford] = simple_ply_loader('stanford_bunny.ply');
trisurf(Facesstanford,Verticesstanford(:,1),Verticesstanford(:,2),Verticesstanford(:,3));

%% Exercise 2
% *Write a code that draws the boundary of the polygon.*
%%
% |dlmread| read ASCII delimited file so we can use this to import the
% data.
close all
V = dlmread('crystal_bdy.txt');
XV = [V(:,1);V(1,1)]; YV = [V(:,2);V(1,2)]; % Since we want the polygon to be closed.
plot(XV,YV,'Color','k','LineWidth',2)

%%
% *Creat the meshgrid that is large enough to enclose the polygon.*
%%
% This part is actually similar to the code inside the function
% |ellipse_ev.m|.
close all
width = max(XV)-min(XV); height = max(YV)-min(YV);
xmin = min(XV)-0.1*width; % Let the rectangle to be 10% larger in width and height.
xmax = max(XV)+0.1*width;
ymin = min(YV)-0.1*height;
ymax = max(YV)+0.1*height;
dx = (xmax-xmin)/100; % I pick up this number since it's neither too small to be accurate nor too large to calculate.
xd = xmin:dx:xmax;
yd = ymin:dx:ymax; % These are the parameters for the meshgrid function
[X,Y] = meshgrid(xd,yd);

%% 
% *Define a function that is 0 outside the polygon and 1 inside and plot this function.*
IN = double(inpolygon(X,Y,XV,YV)); % X and Y are returned by meshgrid
% We use 'double' since the surface command in pcolor must take numerical
% values.
hold on;
pcolor(X,Y,IN); % IN specifies the colour according to the 'output' from IN.
hold off;

%% Exercise 3
 % *Introduction - Mathematical techniques involved*
   %%
   % We are going to solve the eigenfunction _u_ such that
   % $u_{xx}+u_{yy}=\lambda\times u$ and $u(0,y) = u(\pi,y) = u(x,0) = u(x,\pi)
   % = 0$
   %%
   % By separation of variables, suppose $u = F(x)G(x)$, then we may have
   % an equation as $F''(x)G(y)+F(x)G''(y) = \lambda F(x)G(y)$.
   
   %%
   % Divide both sides of the equation by $F(x)G(y)$ so that we will have
   % $\frac{F''(x)}{F(x)} = \lambda-\frac{G''(y)}{G(y)} = c$, where _c_ is
   % a constant independent of _x_ and _y_.
   %%
   % Therefore this PDE is converted into a system of linear differential
   % equations:
   % $F''(x)-cF(x) = 0$ where $F(0) = F(\pi) = 0$ and
   % $G''(y)+(c-\lambda)G(y) = 0$ where $G(0) = G(\pi) = 0$.
   % If _c>0_, then we can denote _c_ by $m^2$ and thus the first
   % differential equation becomes $F''(x)-m^2F(x)=0$.
   %%
   % Then we get the general solution $F(x) = C_1e^{mx}+C_2e^{-mt}$
   %%
   % By plugging in the boundary condition $F(0) = F(\pi) = 0$, we will
   % have $C_1 = C_2 = 0$, which is a trivial solution. Therefore, _c_ must
   % be a non-positive constant.
   %%
   % Hence, we may have an expression for the _F_, which is $F(x) =
   % A\cos(nx)+B\sin(nx)$ where _n_ is an integer which is a parameter for
   % the function |eiglap_square| and constants _A_ and _B_ are arbitrary constants.
   %%
   % Plugging in the boundary condition to determine _A_ and _B_ to have
   % _A=0_ and thus we have $F(x) = B\sin(nx)$.
   %%
   % Similarly we may have $G(y) = b\sin(my)$ for some integer _m_.
   %%
   % This gives the eigenfunction $u(x,y) = C\sin(nx)\sin(my)$ for an
   % arbitrary constant _C_. Similar to how we deal with eigenvectors in
   % the linear algebra, we now have an eigenspace
   % ${C\sin(nx)\sin(my):C\in R}$ with $\sin(nx)\sin(my)$ as a basis. 
   %% 
   % Back to the original equation defining eigenfunctions and eigenvalues,
   % we may see that $-(u_{xx}+u_{yy})=\lambda u$ and this gives the value
   % of the eigenvalue $\lambda = n^2+m^2$.
   
   %%  
   % *Admissible values for _n_ and _m_*
   %%
   % So as to ensure that $F(0) = F(\pi) = 0$ and $G(0) = G(\pi) = 0$ are
   % both satisfied, _n_ and _m_ must be integers. And since apparently we
   % don't want a trivial solution, we need _n_ and _m_ both to be taking non-zero
   % values.
   close all
 type eiglap_square.m
 
 
 %% Exercise 4 and 5
 % *A list of all the changes that I have made*
 %%
 % 
 % * |Line 9 - 17| of |crystal_ev.m| is the meshgrid created to enclose the
 % polygon instead of the ellipse.
 % * |Line 19 - 23| has defined a 'characteristic function' for the polygon.
 % * |Line 29| requires _k_ to find the entries in _G_ that are greater than
 % 0.5 since we are no longer defining points outside the boundary to be
 % negative, instead, those points are assigned to be 0.
 % * |Line 58| and |67| has changed the eigenmode to its absolute value.
 % * |Line 67| plots the 2nd eigenmode instead of the 10th.
 % * |Line 70| a small change in the title.
 % 
 % 
 
 %%
 % 
 close all
 type crystal_ev.m
 [ews, evs] = crystal_ev(XV, YV, 1); % make_plot == 1 means we need a graph here.
 
 %% Exercise 6
 close all;
 %%
 % *Restriction of value for z*
 %%
 % As the manual suggests, the height of the skylight can't exceed 2.25
 % meters. We can do this by multiply the eigenmode by a scalar to restrain
 % the maximum value of _z_ . This can be done by
 %%
 % |z(G>0) = 2.25*abs(evs(:,2))/abs(evs(Imax,2));|
 %%
 % This means where _G_ is greater than 0 (i.e. the point falls inside the
 % polygon) we assign z to be the absolute value of the eigenmode at that
 % point. And then we multiply it by |2.25/abs(evs(Imax,2))| so
 % that the maximum height will be exactly 2.25 meters.
 %%
 % The following is the code for the function.
type compute_vertices.m;
%% Exercise 7
% We just need to put all pieces together.
close all;
[Vertices, Faces] = simple_ply_loader('crystal_flat.ply');
Vertices = compute_vertices(XV,YV,Vertices); % We add the z value column to the Vertices matrix.
figure; hold on;
plot(XV,YV,'k','linewidth',2); % We want to plot the boundary as well.
H = trimesh(Faces,Vertices(:,1),Vertices(:,2),Vertices(:,3));
set(H,'facealpha',0);
axis equal; view(3);
title('South Crystal Skylight');
%% Exercise 8
% From |crystal_ev.m| we can extract the second eigenvalue.
ews(2)
%%
% *Decimal Places*
%%
% Take a look at the code of |ellipse_ev.m| to learn how eigenvalues are
% derived.
%%
% |delsq| constructs five-point finite difference Laplacian.
%%
% Then we assigned _L_ a value such that |L = 1/dx^2 * L| . 
dx
%%
% according to our choice of _n_, which equals to 200. Therefore, the error
% is $\mathrm{dx}^2$ , which equals to 0.04915.
% i.e. we can be confident in 2 decimal places.
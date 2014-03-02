function Vertices = compute_vertices (xv,yv,Vertices)
% xv and yv are the x,y coordinate matrices respectively and Vertices
% matrix is the matrix with all the vertices of triangles in 2D plane.
[ews, evs] = crystal_ev(xv,yv, 0);
[Vmax,Imax] = max(abs(evs(:,2)));

%% meshgrid again
x1 = min(xv);  x2 = max(xv);
y1 = min(yv);  y2 = max(yv);
w = min(x2-x1, y2-y1);
x1 = x1-0.1*w; x2 = x2+0.1*w;
y1 = y1-0.1*w; y2 = y2+0.1*w;
dx = (x2-x1) / 200;
x1d = x1:dx:x2; y1d = y1:dx:y2;
[x,y] = meshgrid(x1d,y1d);
% logic matrix G
in_out_code = inpolygon(x,y,xv,yv);

G = zeros(size(in_out_code));
G(in_out_code) = 1;
%% assign values to z
z = zeros(size(x));
z(G>0) = 2.25*abs(evs(:,2))/abs(evs(Imax,2));
Vertices(:,3) = interp2(x,y,z,Vertices(:,1),Vertices(:,2));
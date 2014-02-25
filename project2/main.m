function main(show_animation)
    clear all; close all;
    [xv,yv] = polygonal_boundary('crystal_bdy.txt');
    [ews, evs, x, y, dx, G] = crystal_ev(xv, yv, false);
    [Vertices, Faces] = compute_vertices(evs,x,y,dx,G);
    trisurf(Faces,Vertices(:,1),Vertices(:,2),Vertices(:,3));
    %axis square;
    
    if nargin == 1
        for i = -90:1:90
        view(i,30);
        alpha(abs(i)/90);
        pause(0.1);
        end 
    end
    
    % Want see annies_pig?
    figure(2); clf;
    clear Vertices Faces;
    [Vertices, Faces] = simple_ply_loader('annies_pig.ply');
    trimesh(Faces, Vertices(:,1),Vertices(:,2),Vertices(:,3));
    axis equal;
    
    % Want see stanford_bunny.ply
    figure(3); clf;
    clear Vertices Faces;
    [Vertices, Faces] = simple_ply_loader('stanford_bunny.ply');
    trimesh(Faces, Vertices(:,1),Vertices(:,2),Vertices(:,3));
    axis equal;
    
end
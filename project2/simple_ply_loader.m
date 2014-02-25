function [Vertices, Faces] = simple_ply_loader(fname)
%SIMPLE_PLY_LOADER  Load an ASCII ply file
%

  f = fopen(fname, 'r');

  %% process the header
  s = fgetl(f);
  assert(strcmpi(s, 'ply'));
  while (1)
    s = fgetl(f);
    if (strncmpi('element face', s, 12))
      numf = sscanf(s, 'element face %d', 1);
    end
    if (strncmpi('element vertex', s, 14))
      numv = sscanf(s, 'element vertex %d', 1);
    end
    if (strcmpi(s, 'end_header'))
      break
    end
  end

  %% now load vertices and faces
  Vertices = fscanf(f, '%g', [3, numv]);
  Faces = fscanf(f, '%g', [4, numf]);

  fclose(f);

  %  3  ix iy iz
  if any(Faces(1,:) ~= 3)
    error('non-triangle in .ply file')
  end
  % discard triangles columns and c-based indexing to matlab
  Faces = transpose(Faces(2:4,:)) + 1;

  Vertices = transpose(Vertices);


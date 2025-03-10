function test_bug2370

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_filetype ft_read_headshape ft_write_headshape read_ply write_ply
% DATA no

filename = [tempname '.ply'];

[pos, tri] = mesh_sphere(162);

% combine them in a structure
mesh1.pos = pos;
mesh1.tri = tri;

ft_write_headshape(filename, mesh1, 'format', 'ply');
mesh2 = ft_read_headshape(filename);
assert(isequal(mesh1.tri, mesh2.tri));
ratio = mesh1.pos(:)\mesh2.pos(:);
assert(ratio>0.99 && ratio<1.01);
delete(filename);

ft_write_headshape(filename, mesh1, 'format', 'ply_ascii');
mesh2 = ft_read_headshape(filename);
assert(isequal(mesh1.tri, mesh2.tri));
ratio = mesh1.pos(:)\mesh2.pos(:);
assert(ratio>0.99 && ratio<1.01);
delete(filename);

ft_write_headshape(filename, mesh1, 'format', 'ply_binary');
mesh2 = ft_read_headshape(filename);
assert(isequal(mesh1.tri, mesh2.tri));
ratio = mesh1.pos(:)\mesh2.pos(:);
assert(ratio>0.99 && ratio<1.01);
delete(filename);




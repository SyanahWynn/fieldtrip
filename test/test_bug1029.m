function test_bug1029

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_read_headmodel ft_headmodel_bem_asa ft_prepare_headmodel
% DATA no

% tests the functionality of the forward models after changing the names of
% the headmodels

%%%%%%%%%%%%%%%%
% BEM_ASA
%%%%%%%%%%%%%%%%
filename = dccnpath('/home/common/matlab/fieldtrip/template/headmodel/skin/standard_skin_1222.vol');
vol = ft_read_headmodel(filename);

vol = ft_headmodel_asa(filename);

cfg = [];
cfg.method = 'asa';
cfg.hdmfile = filename;
vol = ft_prepare_headmodel(cfg);

%%%%%%%%%%%%%%%%
% BEMCP
%%%%%%%%%%%%%%%%
% create the BEM geometry
[pnt, tri] = mesh_sphere(162);
geom = [];
geom.bnd(1).pnt = pnt * 100;
geom.bnd(1).tri = tri;
geom.bnd(2).pnt = pnt * 90;
geom.bnd(2).tri = tri;
geom.bnd(3).pnt = pnt * 80;
geom.bnd(3).tri = tri;

vol = ft_headmodel_bemcp(geom, 'conductivity', [1 1/80 1]);

cfg=[];
cfg.method = 'bemcp';
cfg.conductivity = [1 1/80 1];
vol = ft_prepare_headmodel(cfg, geom);

%%%%%%%%%%%%%%%%
% DIPOLI
%%%%%%%%%%%%%%%%
vol = ft_headmodel_dipoli(geom, 'conductivity', [1 1/20 1]);

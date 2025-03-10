function test_ft_headmodel_bemcp

% MEM 12gb
% WALLTIME 03:00:00
% DEPENDENCY ft_headmodel_localspheres ft_prepare_localspheres
% DATA no

% to test actual numerical output of bemcp, rather than simply successful
% running and correct inputs (which is what test_ft_prepare_headmodel tests).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% method 1: segment MRI then compute bnd from it

% read in the mri, this is already (non?)linearly aligned with MNI
mri = ft_read_mri(dccnpath('/home/common/matlab/fieldtrip/template/headmodel/standard_mri.mat'));

cfg = [];
cfg.output = {'brain', 'skull', 'scalp'};
segmentedmri_new = ft_volumesegment(cfg, mri);

cfg = [];
cfg.tissue = {'brain', 'skull', 'scalp'};
cfg.numvertices = [1500 1000 500]; % these numbers later match the precomputed bnd
mesh_new = ft_prepare_mesh(cfg, segmentedmri_new);

% the segmentation is flawed: both the brain and the skull touch the base of the volume
% hence the meshes of brain, skull and scalp touich each other at the base
% as of approx 1 Feb 2023, ft_headmodel_bemcp checks for correctness of the meshes
% shift the meshes to ensure that they don't touch or intersect
mesh_new(1).pos(:,3) = mesh_new(1).pos(:,3) - 0; % brain
mesh_new(2).pos(:,3) = mesh_new(2).pos(:,3) - 1; % skull
mesh_new(3).pos(:,3) = mesh_new(3).pos(:,3) - 2; % scalp

% I'm choosing 'mm' as units since that is what both the MRI and the
% standard_bem are in already. Whether that is optimal for 'bemcp' is not
% clear to me.

% Create simple concentricspheres to compare to BEMCP
cfg = [];
cfg.method = 'concentricspheres';
vol_new_cs = ft_prepare_headmodel(cfg, ft_convert_units(mesh_new, 'mm'));

cfg = [];
cfg.method = 'bemcp';
vol_new_bemcp = ft_prepare_headmodel(cfg, ft_convert_units(mesh_new, 'mm'));

try
  cfg = [];
  cfg.method = 'dipoli';
  vol_new_dipoli = ft_prepare_headmodel(cfg, ft_convert_units(mesh_new, 'mm'));
catch
  vol_new_dipoli = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% method 2: compute bnd from segmented MRI

% read in the already-segmented mri (in case its segmentation is better than above)
segmentedmri = ft_read_mri(dccnpath('/home/common/matlab/fieldtrip/template/headmodel/standard_seg.mat'));

cfg = [];
cfg.tissue = [3 2 1]; % brain, skull, scalp
cfg.numvertices = [3000 2000 1000];
mesh_seg = ft_prepare_mesh(cfg, segmentedmri);

figure;
ft_plot_mesh(mesh_new(1), 'facecolor', [0.2 0.2 0.2], 'facealpha', 0.3, 'edgecolor', [1 1 1], 'edgealpha', 0.05);
hold on;
ft_plot_mesh(mesh_seg(3), 'facecolor', [0.4 0.6 0.4], 'facealpha', 0.3, 'edgecolor', 'none');
% aside from possible different order, they should align spatially

% Create simple concentricspheres to compare to BEMCP
cfg = [];
cfg.method = 'concentricspheres';
vol_seg_cs = ft_prepare_headmodel(cfg, ft_convert_units(mesh_seg, 'mm'));

cfg = [];
cfg.method = 'bemcp';
vol_seg_bemcp = ft_prepare_headmodel(cfg, ft_convert_units(mesh_seg, 'mm'));

try
  cfg = [];
  cfg.method = 'dipoli';
  vol_seg_dipoli = ft_prepare_headmodel(cfg, ft_convert_units(mesh_new, 'mm'));
catch
  vol_seg_dipoli = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% method 3: use existing bnd in standard_bem

% presumably the mesh that was used to create this 'standard' output from
% dipoli should work (irrespective of segmentation above).
load(dccnpath('/home/common/matlab/fieldtrip/template/headmodel/standard_bem.mat'));
vol_exist_dipoli = vol;
mesh_exist = vol.bnd;
mesh_exist = ft_convert_units(mesh_exist, 'mm');
clear vol

figure;
ft_plot_mesh(mesh_new(3), 'facecolor', [0.2 0.2 0.2], 'facealpha', 0.3, 'edgecolor', [1 1 1], 'edgealpha', 0.05);
hold on;
ft_plot_mesh(mesh_exist(3), 'edgecolor', 'none', 'facecolor', [0.4 0.6 0.4]);
% aside from possible different order, they should align spatially

% Create simple concentricspheres to compare to BEMCP
cfg = [];
cfg.method = 'concentricspheres';
vol_exist_cs = ft_prepare_headmodel(cfg, mesh_exist);

cfg = [];
cfg.method = 'bemcp';
vol_exist_bemcp = ft_prepare_headmodel(cfg, mesh_exist);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check coregistration and view results

load standard_sourcemodel3d8mm;
sourcemodel = ft_convert_units(sourcemodel, 'mm');

elec = ft_read_sens(dccnpath('/home/common/matlab/fieldtrip/template/electrode/standard_1005.elc'));
elec = ft_convert_units(elec, 'mm');

% check for general spatial alignment
figure; ft_plot_mesh(vol_new_bemcp.bnd(3), 'facecolor', [0.2 0.2 0.2], 'facealpha', 0.3, 'edgecolor', [1 1 1], 'edgealpha', 0.05);
hold on; ft_plot_sens(elec);
hold on; ft_plot_mesh(sourcemodel.pos(sourcemodel.inside, :));

figure; ft_plot_mesh(vol_seg_bemcp.bnd(3), 'facecolor', [0.2 0.2 0.2], 'facealpha', 0.3, 'edgecolor', [1 1 1], 'edgealpha', 0.05);
hold on; ft_plot_sens(elec);
hold on; ft_plot_mesh(sourcemodel.pos(sourcemodel.inside, :));

figure; ft_plot_mesh(vol_exist_bemcp.bnd(3), 'facecolor', [0.2 0.2 0.2], 'facealpha', 0.3, 'edgecolor', [1 1 1], 'edgealpha', 0.05);
hold on; ft_plot_sens(elec);
hold on; ft_plot_mesh(sourcemodel.pos(sourcemodel.inside, :));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% View leadfields

% make sure vol*.mat of bemcp not NaN
% see bug 1954
if any(isnan(vol_new_bemcp.mat(:)))
  warning('NaN in vol_new_bemcp.mat')
end


close all
clear volnames vol
volnames = whos('vol*');

% these would need to be recomputed given the headmodel geometry
% sourcemodel = rmfield(sourcemodel, 'inside');
% sourcemodel = rmfield(sourcemodel, 'outside');

% or even faster
sourcemodel = [];
sourcemodel.pos = [-20 0 50];
sourcemodel.unit = 'mm';

for ll = 1:length(volnames)
  vol = eval(volnames(ll).name);
  
  if ~isempty(vol)
    % vol can be empty in case it failed to be created above, e.g. one of
    % the dipoli examples, for one reason or another
    cfg = [];
    cfg.sourcemodel = sourcemodel;
    cfg.elec = elec;
    cfg.headmodel = vol;
    
    lf = ft_prepare_leadfield(cfg);
    
    % Hack: to make LF appear as if it were an ERP
    tlock = [];
    tlock.time = [1 2 3];
    tlock.avg = lf.leadfield{dsearchn(sourcemodel.pos, [-20 0 50])};
    tlock.label = lf.cfg.channel;
    tlock.dimord = 'chan_time';
    
    cfg = [];
    cfg.layout = 'elec1010.lay';
    cfg.xlim = [0.9 1.1];
    figure;
    ft_topoplotER(cfg, tlock);
    title(volnames(ll).name)
    cfg.xlim = [1.9 2.1];
    figure;
    ft_topoplotER(cfg, tlock);
    title(volnames(ll).name)
    cfg.xlim = [2.9 3.1];
    figure;
    ft_topoplotER(cfg, tlock);
    title(volnames(ll).name)
    
    disp(volnames(ll).name)
  end
end
% For me, sensible patterns come from the vol*cs and vol*dipoli, but not from the vol*bemcp

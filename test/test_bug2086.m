function test_bug2086

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_databrowser
% DATA private

warning('this test should not run automatically');
return

load(dccnpath('/home/common/matlab/fieldtrip/data/test/bug2086.mat'));

cfg = [];
cfg.continuous = 'no';
cfg.preproc.channel = {'all'  };
cfg.preproc.demean = 'yes';
cfg.viewmode = 'butterfly';
cfg.ylim = [-200 200];
cfg.channel = 'all';
cfg = ft_databrowser(cfg,data);

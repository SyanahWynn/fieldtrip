function test_ft_globalmeanfield

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_singleplotER
% DATA private
load(dccnpath('/home/common/matlab/fieldtrip/data/test/bug2630/avg_tms_clean.mat'));

cfg = [];
cfg.channel = 'all';
cfg.method = 'power'; % amplitude/power

gmfp = ft_globalmeanfield(cfg, avg_tms_clean);


cfg.method = 'amplitude';
gmfa = ft_globalmeanfield(cfg, avg_tms_clean);

% plot
figure;
cfg = [];
ft_singleplotER(cfg, gmfa, gmfp);

end


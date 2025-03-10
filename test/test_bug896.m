function test_bug896

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_multiplotTFR ft_prepare_layout ft_datatype ft_datatype_freq
% DATA private

load(dccnpath('/home/common/matlab/fieldtrip/data/test/bug896.mat'));

ft_checkdata(stat_coh, 'datatype', 'freq');
ft_checkdata(stat_coh_full, 'datatype', 'freq');
ft_checkdata(stat_coh, 'datatype', 'freq', 'cmbstyle', 'full');
ft_checkdata(stat_coh_full, 'datatype', 'freq', 'cmbstyle', 'full');

if ~ft_datatype(stat_coh, 'freq')
  error('ft_datatype failed on the "stat_coh" input data');
end

if ~ft_datatype(stat_coh_full, 'freq')
  error('ft_datatype failed on the "stat_coh_full" input data');
end

figure
ft_multiplotTFR(cfg, stat_coh);
close

figure
ft_multiplotTFR(cfg, stat_coh_full);
close

function test_bug811

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_checkdata spm2fieldtrip
% DATA private

addpath(dccnpath('/home/common/matlab/spm8'));

filename = dccnpath('/home/common/matlab/fieldtrip/data/test/bug811/cespm8_LD031286_DOELLER_20100223_01.mat');

D = spm_eeg_load(filename);
fnamedat = dccnpath('/home/common/matlab/fieldtrip/data/test/bug811/cespm8_LD031286_DOELLER_20100223_01.dat');
E = clone(D, fnamedat);

data = spm2fieldtrip(E);
ft_checkdata(data, 'datatype', 'raw');

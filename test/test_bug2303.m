function test_bug2303

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_read_header read_eeglabheader
% DATA private

filename = dccnpath('/home/common/matlab/fieldtrip/data/test/bug2303/Dopa2_Quart2_Av.set');

hdr = ft_read_header(filename);

% hdr =
%
%              Fs: 500
%          nChans: 14
%        nSamples: 450
%     nSamplesPre: 100
%         nTrials: 1
%           label: {14x1 cell}
%            elec: [1x1 struct]
%            orig: [1x1 struct]
%        chantype: {14x1 cell}
%        chanunit: {14x1 cell}

assert(ft_filetype(filename, 'eeglab_set'))
assert(hdr.Fs==500);
assert(hdr.nChans==14);
assert(hdr.nSamplesPre==100);

function test_bug2061

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_timelockanalysis
% DATA no

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create some test data
data = [];
data.label = {'Cz'};
data.time = {
  [0 1 2 3 4 5]
  [0 1 2 3 4 5]
  [0 1 2 3 4 5 6 7]
  [0 1 2 3 4 5 6 7]
  [0 1 2 3 4 5 6 7 8 9]
};
data.trial =  {
  [1 1 1 1 1 1]
  [2 2 2 2 2 2]
  [3 3 3 3 3 3 3 3]
  [4 4 4 4 4 4 4 4]
  [5 5 5 5 5 5 5 5 5 5]
};

cfg = [];
cfg.vartrllength = 2;
avg = ft_timelockanalysis(cfg, data);

% the variance should not be all-zero
assert(~all(avg.var(:)==0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create some test data
data = [];
data.label = {'Cz'};
data.time = {
  [0 1 2 3 4 5]
};
data.trial =  {
  [1 1 1 1 1 1]
};

cfg = [];
cfg.vartrllength = 2;
avg = ft_timelockanalysis(cfg, data);

% the variance should be nan
assert(all(isnan(avg.var(:))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create some test data, now with multiple channels
data = [];
data.label = {'Cz', 'Fz'};
data.time = {
  [0 1 2 3 4 5]
};
data.trial =  {
  [1 1 1 1 1 1; 2 2 2 2 2 2]
};

cfg = [];
cfg.vartrllength = 2;
avg = ft_timelockanalysis(cfg, data);

% the variance should be nan
assert(all(isnan(avg.var(:))));

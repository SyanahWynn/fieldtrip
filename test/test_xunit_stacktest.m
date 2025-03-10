function test_xunit_stacktest

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_defaults ft_warning
% DATA no

ft_defaults

stack = dbstack('-completenames');
if size(stack) < 1
  fname = [];
  line = [];
  return;
end
i0 = 1;

fname = horzcat(stack(end).name);

fprintf('The fieldname would be tmpstrct.%s\n', fname);

tmpstrct = [];
setsubfield(tmpstrct, fname, [])
tmpstrct2 = [];
eval(['tmpstrct2.' fname ' =[]'])

for i=1:10
    ft_warning('Tthis is a test');
end
ft_warning('Tthis is another test');

ft_warning('-clear');

fprintf('Completed!\n');

end

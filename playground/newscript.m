%new script

init
dirname = 'C:\simulators\RepastSimphony-2.3.1\simulations\s_vs_no_s_01\';

filter = @(d) (d.intervalNum == 160);

allData = processOutput(dirname, filter);



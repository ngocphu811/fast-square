addpath('~/repos/fast-square/src/matlab/');
addpath('~/repos/fast-square/src/matlab/bjt');

cd ~/temp/diversity_data/ipsn16/stationary_tee_interference_obstructed/
analyzeHSCOMBData_bjt('operation','localization','system_setup','diversity','anchor',3,'ignore_freq_steps',[23,24]);
%analyzeHSCOMBData_bjt('operation','diversity_localization','system_setup','diversity');
%analyzeHSCOMBData_bjt('operation','post_localization','system_setup','diversity');

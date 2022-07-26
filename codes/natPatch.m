clear all;
n = 37; % number of runs
colNames = {'condition names'};
load('*.mat'); % load (pooled) SC stuctures

myStr = [pooled.BN', pooled.BU', pooled.FN', pooled.FU', ...
    pooled.MN', pooled.MU', pooled.FBN', pooled.FBU'];
myStr = cell2mat(myStr);
diffData = myStr - (repmat(mean(myStr, 2), 1, 8)); % subtract mean per run to normalize (reduce run variablilty)
ci = bootci(1000, {@mean, diffData}, 'Type', 'per');
uci = ci(2, :);
uer = uci - mean(diffData, 1);
lci = ci(1, :);
ler = mean(diffData, 1) - lci;
% plot



       
        
        
        
        
        
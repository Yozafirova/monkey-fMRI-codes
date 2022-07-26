clear all;
b = load('*.mat'); % load SC structures for the Roi

bn = b.str.BN; fn = b.str.FN; mn = b.str.MN; 
bu = b.str.BU; fu = b.str.FU; mu = b.str.MU;
numRuns = size(bn, 1); numVox = size(bn, 2);

bncoeff = []; fncoeff = []; bucoeff = []; fucoeff = [];
RNsq = []; RUsq = [];

for i = 1:1000 % resample by row with replacement 1000 times
    runs = (1:1:numRuns)';
    sampleData = datasample(runs, numRuns);
  
    meanBN = mean(bn(sampleData, :))'; meanFN = mean(fn(sampleData, :))'; meanMN = mean(mn(sampleData, :))'; 
    meanBU = mean(bu(sampleData, :))'; meanFU = mean(fu(sampleData, :))'; meanMU = mean(mu(sampleData, :))'; 
    bfn = [meanBN, meanFN]; bfu = [meanBU, meanFU];
    
    mdlN = fitlm(bfn, meanMN, 'Intercept', false); mdlU = fitlm(bfu, meanMU, 'Intercept', false);
    bnc = table2array(mdlN.Coefficients(1, 1)); fnc = table2array(mdlN.Coefficients(2, 1));
    buc = table2array(mdlU.Coefficients(1, 1)); fuc = table2array(mdlU.Coefficients(2, 1));
    rnq = mdlN.Rsquared.Adjusted; ruq = mdlU.Rsquared.Adjusted;
    bncoeff = [bncoeff; bnc]; fncoeff = [fncoeff; fnc]; RNsq = [RNsq; rnq]; 
    bucoeff = [bucoeff; buc]; fucoeff = [fucoeff; fuc]; RUsq = [RUsq; ruq]; 
end

str.BNcoeff = bncoeff; str.FNcoeff = fncoeff; str.RNsq = RNsq; 
str.BUcoeff = bucoeff; str.FUcoeff = fucoeff; str.RUsq = RUsq;
%plot



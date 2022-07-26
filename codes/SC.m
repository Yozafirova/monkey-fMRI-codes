clear all;
dataFolder = ('dataFolder'); % folder with the beta niis, exp 2
outFolder = ('outFolder'); % mkdir (outFolder);
currentRoi = niftiread('roiName.nii'); % change accordingly
roiName = ('roiName');
strName = ('strName.mat');

numVoxels =  length(currentRoi(currentRoi>0)); % take the number of voxels in the ROI
[rows, cols, pges] = ind2sub(size(currentRoi),find(currentRoi>0)); % take coord rows, columns and pages of the roi ones, ROIs are 3d binaries
numRuns = 37; % specify the total number of runs
meanNetBN = []; meanNetBU = []; meanNetFN = []; meanNetFU = []; meanNetMN = []; meanNetMU = [];

fixFiles = dir([dataFolder, 'fix*.nii']);
BNFiles = dir([dataFolder, 'BN*.nii']);
BUFiles = dir([dataFolder, 'BU*.nii']);
FNFiles = dir([dataFolder, 'FN*.nii']);
FUFiles = dir([dataFolder, 'FU*.nii']);
MNFiles = dir([dataFolder, 'MN*.nii']);
MUFiles = dir([dataFolder, 'MU*.nii']);

% extract the beta values for that roi for each condition, each run and each voxel
for a = 1:numRuns
    Fixnii = niftiread(fixFiles(a).name); % read all betas as matrices
    BNnii = niftiread(BNFiles(a).name); BUnii = niftiread(BUFiles(a).name);
    FNnii = niftiread(FNFiles(a).name); FUnii = niftiread(FUFiles(a).name);
    MNnii = niftiread(MNFiles(a).name); MUnii = niftiread(MUFiles(a).name);
    for aa = 1:numVoxels
        fixValues{aa, 1} = Fixnii(rows(aa), cols(aa), pges(aa)); % store the values for each voxel
        BNValues{aa, 1} = BNnii(rows(aa), cols(aa), pges(aa)); BUValues{aa, 1} = BUnii(rows(aa), cols(aa), pges(aa)); 
        FNValues{aa, 1} = FNnii(rows(aa), cols(aa), pges(aa)); FUValues{aa, 1} = FUnii(rows(aa), cols(aa), pges(aa)); 
        MNValues{aa, 1} = MNnii(rows(aa), cols(aa), pges(aa)); MUValues{aa, 1} = MUnii(rows(aa), cols(aa), pges(aa));    
    end
    fixValues = cell2mat(fixValues); fixValues = rmmissing(fixValues); fixValues = num2cell(fixValues); % TAKE CARE OF NANS!!!
    BNValues  = cell2mat(BNValues); BNValues = rmmissing(BNValues); BNValues = num2cell(BNValues);
    BUValues = cell2mat(BUValues); BUValues = rmmissing(BUValues); BUValues = num2cell(BUValues);
    FNValues = cell2mat(FNValues); FNValues = rmmissing(FNValues); FNValues = num2cell(FNValues);
    FUValues = cell2mat(FUValues); FUValues = rmmissing(FUValues); FUValues = num2cell(FUValues);
    MNValues = cell2mat(MNValues); MNValues = rmmissing(MNValues); MNValues = num2cell(MNValues);
    MUValues = cell2mat(MUValues); MUValues = rmmissing(MUValues); MUValues = num2cell(MUValues);
    fixBetas{a} = fixValues; % store the values for each run
    BNBetas{a} = BNValues; BUBetas{a} = BUValues;
    FNBetas{a} = FNValues; FUBetas{a} = FUValues;
    MNBetas{a} = MNValues; MUBetas{a} = MUValues;
end
numVoxels = length(fixValues); % take num of voxels without missing values

for d = 1:numRuns % calculate signal change
    ff = cell2mat(fixBetas{d});
    cbn = cell2mat(BNBetas{d}); ntBN = cbn-ff; mNetBN = mean(ntBN(:), 'omitnan'); % take the net value and the mean net value
    netBN{d,1} = ntBN; meanNetBN = [meanNetBN, mNetBN]; % store the values
    cbu = cell2mat(BUBetas{d}); ntBU = cbu-ff; mNetBU = mean(ntBU(:), 'omitnan'); 
    netBU{d,1} = ntBU; meanNetBU = [meanNetBU, mNetBU];
    cfn = cell2mat(FNBetas{d}); ntFN = cfn-ff; mNetFN = mean(ntFN(:), 'omitnan'); 
    netFN{d,1} = ntFN; meanNetFN = [meanNetFN, mNetFN];
    cfu = cell2mat(FUBetas{d}); ntFU = cfu-ff; mNetFU = mean(ntFU(:), 'omitnan'); 
    netFU{d,1} = ntFU; meanNetFU = [meanNetFU, mNetFU];
    cmn = cell2mat(MNBetas{d}); ntMN = cmn-ff; mNetMN = mean(ntMN(:), 'omitnan'); 
    netMN{d,1} = ntMN; meanNetMN = [meanNetMN, mNetMN];
    cmu = cell2mat(MUBetas{d}); ntMU = cmu-ff; mNetMU = mean(ntMU(:), 'omitnan'); 
    netMU{d,1} = ntMU; meanNetMU = [meanNetMU, mNetMU];
end


for s = 1:numRuns % calculate sums
    netFBN{s,1} = (vertcat(netBN{s}) + vertcat(netFN{s}));
    netFBU{s,1} = (vertcat(netBU{s}) + vertcat(netFU{s}));
end

% do the same per voxel
nbn = cell2mat(netBN'); nfn = cell2mat(netFN'); nmn = cell2mat(netMN'); 
nbu = cell2mat(netBU'); nfu = cell2mat(netFU'); nmu = cell2mat(netMU'); 
nfbn = cell2mat(netFBN'); nfbu = cell2mat(netFBU');

for z = 1:numVoxels
    netBNr{z} = nbn(z, :); netFNr{z} = nfn(z, :); netMNr{z} = nmn(z, :); 
    netBUr{z} = nbu(z, :); netFUr{z} = nfu(z, :); netMUr{z} = nmu(z, :); 
    netFBNr{z} = nfbn(z, :); netFBUr{z} = nfbu(z, :);
end

% !! create structure
str.BNv = netBN; str.FNv = netFN; str.MNv = netMN; 
str.BUv = netBU; str.FUv = netFU; str.MUv = netMU;
str.FBNv = netFBN; str.FBUv = netFBU;

str.BNr = netBNr'; str.FNr = netFNr'; str.MNr = netMNr'; 
str.BUr = netBUr'; str.FUr = netFUr'; str.MUr = netMUr';
str.FBNr = netFBNr'; str.FBUr = netFBUr';

% add the mean of all voxels per run
str.meanBNv = meanNetBN'; str.meanFNv = meanNetFN'; str.meanMNv = meanNetMN'; 
str.meanBUv = meanNetBU'; str.meanFUv = meanNetFU'; str.meanMUv = meanNetMU';
str.meanFBNv = meanNetBN'+meanNetFN'; str.meanFBUv = meanNetBU'+meanNetFU';

% add the mean of all runs per voxel
catBN = vertcat(netBN{:}); catFN = vertcat(netFN{:}); catMN = vertcat(netMN{:}); 
catBU = vertcat(netBU{:}); catFU = vertcat(netFU{:}); catMU = vertcat(netMU{:}); 
catFBN = vertcat(netFBN{:}); catFBU = vertcat(netFBU{:}); 
for v = 1:numVoxels
    meanBNr{v} = mean(catBN(v:numVoxels:end)); meanFNr{v} = mean(catFN(v:numVoxels:end)); meanMNr{v} = mean(catMN(v:numVoxels:end)); 
    meanBUr{v} = mean(catBU(v:numVoxels:end)); meanFUr{v} = mean(catFU(v:numVoxels:end)); meanMUr{v} = mean(catMU(v:numVoxels:end)); 
    meanFBNr{v} = mean(catFBN(v:numVoxels:end)); meanFBUr{v} = mean(catFBU(v:numVoxels:end));
end
str.meanBNr = cell2mat(meanBNr'); str.meanFNr = cell2mat(meanFNr'); str.meanMNr = cell2mat(meanMNr'); 
str.meanBUr= cell2mat(meanBUr'); str.meanFUr = cell2mat(meanFUr'); str.meanMUr= cell2mat(meanMUr');
str.meanFBNr = cell2mat(meanFBNr'); str.meanFBUr = cell2mat(meanFBUr');

save(strName, 'str');
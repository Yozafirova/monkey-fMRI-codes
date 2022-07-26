clear all
mN = []; mU = [];
monN = []; monU = []; 
MonRLUCi = []; MonRLLCi = []; MonIrLUCi = []; MonIrLLCi = [];
files = dir('pooledRoi*.mat'); % load Rois pooled across hemispheres
filesList = {files.name}; % take the names of the files
num = regexp(filesList, '\d*', 'match'); % take the number from the name into cell array
out = str2double(cat(1, num{:})); % take the numbers only
[~, index] = sort(out); % sort the numbers and take the index
files = files(index); % sort the file list according to index

for k = 1:length(files)
    load(files(k).name);
    ciStr = cell2mat([pooled.meanMN', pooled.meanMU', pooled.meanFBN', pooled.meanFBU']);
    meanMN = mean(cell2mat(pooled.meanMN'))-mean(cell2mat(pooled.meanFBN'));
    meanMU = mean(cell2mat(pooled.meanMU'))-mean(cell2mat(pooled.meanFBU'));
    monN = [monN, meanMN]; monU = [monU, meanMU];
    for i = 1:1000 % resample by column with replacement 1000 times
        ciData = datasample(ciStr(:, (1:end)), n);
        bootMeans = mean(ciData, 1);
        natDiff = bootMeans(1) - bootMeans(3);
        unnatDiff = bootMeans(2) - bootMeans(4);
        mN = [mN, natDiff]; 
        mU = [mU, unnatDiff];
    end
    MonRLCi = prctile(mN,[2.5, 97.5]);
    uRCi = MonRLCi(:, 2); % upper ci 
    uMonRLBar = uRCi - meanMN; % upper error bar
    lRCi = MonRLCi(:, 1); % lower ci
    lMonRLBar = meanMN - lRCi; % lower error bar

    MonIrLCi = prctile(mU,[2.5, 97.5]);
    uIrCi = MonIrLCi(:, 2); % upper ci 
    uMonIrLBar = uIrCi - meanMU; % upper error bar
    lIrCi = MonIrLCi(:, 1); % lower ci
    lMonIrLBar = meanMU - lIrCi; % lower error bar

    MonRLUCi = [MonRLUCi, uMonRLBar]; %save values
    MonRLLCi = [MonRLLCi, lMonRLBar];
    MonIrLUCi = [MonIrLUCi, uMonIrLBar];
    MonIrLLCi = [MonIrLLCi, lMonIrLBar];
    
    mN = []; mU = [];
end
% plot
        
        
        
        
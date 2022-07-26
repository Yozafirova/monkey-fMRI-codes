clear all
Mon = [];Sum = []; 
MonLLCi = []; MonLUCi = []; SumLLCi = []; SumLUCi = [];

files = dir('pooledRoi*.mat'); % load Rois pooled across hemispheres
filesList = {files.name}; % take the names of the files
num = regexp(filesList, '\d*', 'match'); % take the number from the name into cell array
out = str2double(cat(1, num{:})); % take the numbers only
[~, index] = sort(out); % sort the numbers and take the index
files = files(index); % sort the file list according to index, posterior to anterior

% % FOR THE SUMS
for k = 1:length(files)
    load(files(k).name);
    myStr = cell2mat([pooled.meanBN', pooled.meanBU', pooled.meanFN', pooled.meanFU', pooled.meanMN', ...
    pooled.meanMU', pooled.meanFBN', pooled.meanFBU']);
    meanM = mean(cell2mat(pooled.meanMN));
    meanS = mean(cell2mat(pooled.meanFBN));
    Mon = [Mon, meanM]; 
    Sum = [Sum, meanS];
    diffData = myStr - (repmat(mean(myStr, 2), 1, 8)); % subtract mean per run to normalize (reduce run variablilty)
    ci = bootci(1000, {@mean, diffData}, 'Type', 'per');
    uci = ci(2, :);
    uer = uci - mean(diffData, 1);
    lci = ci(1, :);
    ler = mean(diffData, 1) - lci;
    MonLLCi = [MonLLCi, ler(1)]; MonLUCi = [MonLUCi, uer(1)];
    SumLLCi = [SumLLCi, ler(2)]; SumLUCi = [SumLUCi, uer(2)]; 
end
% plot


        
        
        
        
        
clear all; close all; clc

%% Load Data

% Load every participant with both test and retest
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");
allData = cell(ceil(length(filePaths)/2), 8, 2);
row = 0;
page = 1;
testRowNum = 0;
retestRowNum = 0;

for i = 1:length(filePaths)
    splitNames = split(filePaths{i}, '_');

    if contains(filePaths{i}, 'RETEST')
        page = 2;
        retestRowNum = retestRowNum + 1;
        row = retestRowNum;
    else
        page = 1;
        testRowNum = testRowNum + 1;
        row = testRowNum;
    end
    allData{row, 1, page} = splitNames{2};
    allData{row, 2, page} = load(append(fileRoot, filePaths{i})).testDataFinal.X;
    allData{row, 3, page} = load(append(fileRoot, filePaths{i})).testDataFinal.fps;
    allData{row, 4, page} = max(load(append(fileRoot, filePaths{i})).testDataFinal.time);
    i
end

load 'Test Retest Data 25Feb2025.mat';


outliersRemoved = allData([1:15 17:size(allData,1)], :, :);
%% Calculate ICCs for all Data

allPercentages = nan(size(allData, 1), 15, 15, 2);
% series of cell functions to get deviations -> get the lengths of each ->
% get the time of tecah -> convert to percentage of total test time
% repeat with the threshold being 1-15 PD and the min deviation size being
% 1:15 seconds
for threshold = 1:15
    for seconds = 1:15
        for timepoint = 1:2
            allPercentages(:, threshold, seconds, timepoint) = cellfun(@(x, y) (x(1)/y)*100, cellfun(@(x) sum(x(:,2)), cellfun(@(x,y) getDeviationLengths(x,y), cellfun(@(x,y) getDeviations(abs(x), threshold, y, seconds)', allData(:, 2, timepoint), allData(:, 3, timepoint), 'UniformOutput', false), allData(:, 3, timepoint), 'UniformOutput', false), 'UniformOutput', false), allData(:, 4, timepoint));
        end
    end
    threshold
end


allDataTotalICCScores = nan(size(allPercentages, 2), size(allPercentages, 3), 2);
for threshold = 1:size(allDataTotalICCScores, 1)
    for seconds = 1:size(allDataTotalICCScores, 2)
        for control = 0:1
            allDataTotalICCScores(threshold, seconds, control+1) = round(ICC([allPercentages(testRetestTable.isControl == control, threshold, seconds, 1) allPercentages(testRetestTable.isControl == control, threshold, seconds, 2)], 'A-1', 0.95), 2, "significant");
        end
    end
end

allData_12_1(:,:) = allPercentages(testRetestTable.isControl == control,12,1,:);

%% Calculate for outlier removed

outlierPercentages = nan(size(outliersRemoved, 1), 15, 15, 2);
for threshold = 1:15
    for seconds = 1:15
        for timepoint = 1:2
            outlierPercentages(:, threshold, seconds, timepoint) = cellfun(@(x, y) (x(1)/y)*100, cellfun(@(x) sum(x(:,2)), cellfun(@(x,y) getDeviationLengths(x,y), cellfun(@(x,y) getDeviations(abs(x), threshold, y, seconds)', outliersRemoved(:, 2, timepoint), outliersRemoved(:, 3, timepoint), 'UniformOutput', false), outliersRemoved(:, 3, timepoint), 'UniformOutput', false), 'UniformOutput', false), outliersRemoved(:, 4, timepoint));
        end
    end
    threshold
end

outliersTotalICCScores = nan(size(outlierPercentages, 2), size(outlierPercentages, 3), 2);
for threshold = 1:size(outliersTotalICCScores, 1)
    for seconds = 1:size(outliersTotalICCScores, 2)
        for control = 0:1
            outliersTotalICCScores(threshold, seconds, control+1) = round(ICC([outlierPercentages(testRetestTable.isControl([1:15 17:size(allData,1)]) == control, threshold, seconds, 1) outlierPercentages(testRetestTable.isControl([1:15 17:size(allData,1)]) == control, threshold, seconds, 2)], 'A-1', 0.95), 2, "significant");
        end
    end
end

outlierRemoved_12_1(:,:) = outlierPercentages(testRetestTable.isControl([1:15, 17:size(allData,1)]) == control,12,1,:);


%% cronbach's alpha

allDataCronbach = nan(size(allPercentages, 2), size(allPercentages, 3), 2);
for threshold = 1:size(allDataCronbach, 1)
    for seconds = 1:size(allDataCronbach, 2)
        for control = 0:1
            allDataCronbach(threshold, seconds, control+1) = round(cronbach([allPercentages(testRetestTable.isControl== control, threshold, seconds, 1) allPercentages(testRetestTable.isControl == control, threshold, seconds, 2)]), 2, "significant");
        end
    end
end

%% Pearson Correlation

allDataPearson = nan(size(allPercentages, 2), size(allPercentages, 3), 2);
for threshold = 1:size(allDataPearson, 1)
    for seconds = 1:size(allDataPearson, 2)
        for control = 0:1
            r = round(corr([allPercentages(testRetestTable.isControl == control, threshold, seconds, 1) allPercentages(testRetestTable.isControl == control, threshold, seconds, 2)]), 2, "significant");
            allDataPearson(threshold, seconds, control+1) = r(1,2);      
        end
    end
end

%% Plot
% Create heatmaps to show the results
xvalues = cellstr(string(1:15));
yvalues = cellstr(string(15:-1:1));

figure()
heatmap(xvalues,yvalues,flipud(allDataTotalICCScores(:,:,1)), 'Colormap', parula);
xlabel('Min Deviation Time (s)')
ylabel('Min Deviation Threshold (PD)')
title('Heatmap with all data')

figure()
heatmap(xvalues,yvalues,flipud(outliersTotalICCScores(:,:,2)), 'Colormap', parula);
xlabel('Min Deviation Time (s)')
ylabel('Min Deviation Threshold (PD)')
title('Heatmap with NJIT020 Removed')

figure()
heatmap(xvalues,yvalues,flipud(allDataCronbach(:,:,2)), 'Colormap', parula);
xlabel('Min Deviation Time (s)')
ylabel('Min Deviation Threshold (PD)')
title('Cronbach Heatmap with all data')

figure()
heatmap(xvalues,yvalues,flipud(allDataPearson(:,:,2)), 'Colormap', parula);
xlabel('Min Deviation Time (s)')
ylabel('Min Deviation Threshold (PD)')
title('Pearson Heatmap with all data')


%% 

% M = allData_12_1;
M = outlierRemoved_12_1;

n = size(M, 1);
k = size(M, 2);
SStotal = var(M(:)) *(n*k - 1);
MSR = var(mean(M, 2)) * k;
MSW = sum(var(M,0, 2)) / n;
MSC = var(mean(M, 1)) * n;
MSE = (SStotal - MSR *(n - 1) - MSC * (k -1))/ ((n - 1) * (k - 1));

r = (MSR - MSE) / (MSR + (k-1)*MSE + k*(MSC-MSE)/n)


%% 
SEM = (std(outlierRemoved_12_1, 0, "all")/size(outlierRemoved_12_1, 1))^2;
S = std(outlierRemoved_12_1, 0, "all")^2;

ICC = 1-(SEM/S)


%% Log transformation







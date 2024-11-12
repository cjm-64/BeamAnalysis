clear all; close all; clc

%% Load Data

clearvars -except currData currStD prevData prevStD

[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

% Calculate Z Scores

if exist('currData', 'var')
    clear prevData prevStD
    prevStD = currStD;
    prevData = currData;
    clear currData currStD
end

% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        cellData{cellIndex} = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
    end
catch
    cellData{1} = lload(append(fileRoot, filePaths)).testDataFinal.X;
end

% Calculate Subsample Average and STDEVs
perCellAverage = cellfun(@mean, cellData);
perCellSize = cellfun(@length, cellData);
perCellStDev = cellfun(@std, cellData);

% Calculate Group Level Behaviors
masterSamplePoints = sum(perCellSize);
masterWeights = perCellSize/masterSamplePoints;

% Apply Weights for Summation
masterAverage = sum(perCellAverage.*masterWeights);
masterStDev = sqrt(sum(perCellStDev.^2 ./ size(filePaths,2)));

% Run the Scores
sampleZScores = cellfun(@(x) createZScore(x, masterAverage, masterStDev), cellData,'UniformOutput', false);

% Stack 
colStackScores = nan(max(perCellSize),size(sampleZScores,2));
for fileInput = 1:size(sampleZScores,2)
    colStackScores(1:size(sampleZScores{fileInput}',1),fileInput) = sampleZScores{fileInput}';
end

currData = colStackScores;
currStD = perCellStDev;

%% Check Kurtosis and Skewness
data = currData;
% data = prevData;
n = size(data, 2);
a = [skewness(data(:,2:2:n)); skewness(data(:,1:2:n)); kurtosis(data(:,1:2:n)); kurtosis(data(:,2:2:n))];

%% Plot
binSize = 0.01;
figure()
subplot(2, 1, 1)
histogram(prevData, 'BinWidth', binSize)
xlim([-15, 15])
ylim([0 15*10e3])

subplot(2, 1, 2)
histogram(currData, 'BinWidth', binSize)
xlim([-15, 15])
ylim([0 15*10e3])

figure()
histogram(prevData, FaceColor="red", FaceAlpha=0.5)
hold on
histogram(currData, FaceColor="blue", FaceAlpha=0.5)
xlim([-25, 25])
ylim([0 2*10e4])




%% Fitting
prevFit = fitdist(reshape(prevData, [size(prevData, 1)*size(prevData, 2), 1]),'Normal');
currFit = fitdist(reshape(currData, [size(currData, 1)*size(currData, 2), 1]),'Normal');

figure()
subplot(2, 1, 1)
histfit(reshape(prevData, [size(prevData, 1)*size(prevData, 2), 1]))
xlim([-15, 15])
ylim([0 12*10e3])

subplot(2, 1, 2)
histfit(reshape(currData, [size(currData, 1)*size(currData, 2), 1]))
xlim([-15, 15])
ylim([0 12*10e3])









clear all; close all; clc

%% Script to analyze BEAM data
makeBEAMDataLocations()

%% Get File Names
% fileNames = uigetfile('Data\Raw\BEAM_DATA\*.csv', "MultiSelect","on");
fileNames = uigetfile('Data\Raw\TestData\*.csv', "MultiSelect","on");


%% Process all files

if ~iscell(fileNames)
    disp(fileNames)
    BEAMAnalysisAutomaticCalibration(fileNames)
else
    for fileName = 1:size(fileNames, 2)
        disp(fileNames{fileName})
        BEAMAnalysisAutomaticCalibration(fileNames{fileName})
    end
end

%% Prep For Export - BNC v IXT

load isControlList.mat

sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
numParticipants = strings(length(dir([sourceDirectory, '\BEAM*'])), 1);
timepoint = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
isControl = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationTimes = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationPercentages = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationMaxes = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationMeans = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationMedians = nan(length(dir([sourceDirectory, '\BEAM*'])), 1);
writeRowLocation = 1;
for i = 1:length(fileList)
    loadedFileName = fileList(i).name;
    if contains(loadedFileName, 'BEAM')
        load(append(sourceDirectory,'\', fileList(i).name))
        disp(loadedFileName);
    else
        continue;
    end
    if contains(loadedFileName, '_BASE') || contains(loadedFileName, '_TEST')
        timepoint(writeRowLocation) = 0;
    else
        timepoint(writeRowLocation) = 1;
    end
    numParticipants(writeRowLocation) = extractBefore(loadedFileName, '.mat');
    deviationTimes(writeRowLocation) = deviations.time;
    deviationPercentages(writeRowLocation) = deviations.percentage;
    deviationMaxes(writeRowLocation) = deviations.maxSize;
    deviationMeans(writeRowLocation) = deviations.meanSize;
    deviationMedians(writeRowLocation) = deviations.medianSize;
    isControl(i,writeColLocation) = isControlList.isControl(isControlList.participantName == longitudinalParticipants(i));

    writeRowLocation = writeRowLocation + 1;
end


testRetestTable = table(numParticipants, timepoint, deviationTimes, deviationPercentages, deviationMaxes, deviationMeans, deviationMedians);
writetable(testRetestTable, append(extractBefore(sourceDirectory, 'Data'), 'BNC v IXT Output ', char(datetime("today")), '.csv'))

%% Prep For Export - Test-Retest
sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
splitFileNames = split(cellfun(@string, {fileList(3:end).name}'), "_");

longitudinalParticipants = strings(2, 1);
partLoc = 1;
inRange = 1;
i = 1;
while inRange == 1
    if i > size(splitFileNames, 1)
        inRange = 0;
        break;
    end

    if sum(strcmp(splitFileNames(i,2), splitFileNames(:,2))) > 1
        % This participant has both files
        longitudinalParticipants(partLoc, 1) = splitFileNames(i, 2);
        partLoc = partLoc + 1;
        i = i + 2;
    else
        % This participant has one file - do nothing
        i = i + 1;
    end
end

deviationTimes = zeros(size(longitudinalParticipants, 1), 2);
deviationPercentages = zeros(size(longitudinalParticipants, 1), 2);
deviationMaxes = zeros(size(longitudinalParticipants, 1), 2);
deviationMeans = zeros(size(longitudinalParticipants, 1), 2);
deviationMedians = zeros(size(longitudinalParticipants, 1), 2);
timepoint = zeros(size(longitudinalParticipants, 1), 2);
isControl = zeros(size(longitudinalParticipants, 1), 2);


load isControlList.mat
writeColLocation = 1;
fileNameSuffixes = unique(splitFileNames(:,3));
for i = 1:length(longitudinalParticipants)
    for j = 1:size(fileNameSuffixes,1)
        loadedFileName = join([longitudinalParticipants(i) fileNameSuffixes(j)], '_');
        load(append(sourceDirectory,'\BEAM_', loadedFileName));
        disp(loadedFileName);

        if contains(loadedFileName, 'RETEST')
            writeColLocation = 2;
        else
            writeColLocation = 1;
        end
    
        deviationTimes(i,writeColLocation) = deviations.time;
        deviationPercentages(i,writeColLocation) = deviations.percentage;
        deviationMaxes(i,writeColLocation) = deviations.maxSize;
        deviationMeans(i,writeColLocation) = deviations.meanSize;
        deviationMedians(i,writeColLocation) = deviations.medianSize;
        timepoint(i,writeColLocation) = writeColLocation;
        isControl(i,writeColLocation) = isControlList.isControl(isControlList.participantName == longitudinalParticipants(i));
    end
end

% load isControlList.mat
% isControl = zeros(size(longitudinalParticipants, 1), 1);
% for i = 1:length(longitudinalParticipants)
%     isControl(i) = isControlList.isControl(isControlList.participantName == longitudinalParticipants(i));
% end

%% Create table for test-retest
testRetestTable = table(longitudinalParticipants, deviationTimes, deviationPercentages, deviationMaxes, deviationMeans, deviationMedians, isControl(:,1));
testRetestTable.Properties.VariableNames(7) = {'isControl'};
writetable(testRetestTable, append(extractBefore(sourceDirectory, 'Data'), 'Test-Retest ', char(datetime("today")), '.csv'))

%% Create table for anova
anovaTable = table([longitudinalParticipants; longitudinalParticipants], deviationTimes(:), deviationPercentages(:), deviationMaxes(:), deviationMeans(:), deviationMedians(:), isControl(:), timepoint(:));
anovaTable.Properties.VariableNames = {'Name', 'deviationTime', 'deviationPercentage', 'deviationMax', 'deviationMean', 'deviationMedian', 'isControl', 'Timepoint'};
writetable(anovaTable, append(extractBefore(sourceDirectory, 'Data'), 'Anova ', char(datetime("today")), '.csv'))



%% ARVO Export
% Pull only patient files
[fileNames, filePath] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

% Metrics to pull
% Percentage - Also convert to OCS
% Mean/Median Deviations 
arraySize = flip(size(fileNames));
name = strings(arraySize);
timepoint = zeros(arraySize);
percentages = zeros(arraySize);
BEAMofficeControlScore = cell(arraySize);
meanDeviation = zeros(arraySize);
medianDeviation = zeros(arraySize);

for i = 1:length(fileNames)
    load(append(filePath,'\', fileNames{i}));
    disp(fileNames{i})
    splitFileName = split(fileNames{i}, '_');
    name(i) = splitFileName{2};

    if contains(fileNames{i}, 'RETEST')
        timepoint(i) = 1;
    else
        timepoint(i) = 0;
    end
    
    percentages(i) = deviations.percentage;
    meanDeviation(i) = deviations.meanSize;
    medianDeviation(i) = deviations.medianSize;

    if deviations.percentage == 100
        BEAMofficeControlScore(i) = {'5'};
    elseif deviations.percentage < 100 && deviations.percentage >= 50
        BEAMofficeControlScore(i) = {'4'};
    elseif deviations.percentage < 50 && deviations.percentage > 0
        BEAMofficeControlScore(i) = {'3'};
    else
        BEAMofficeControlScore(i) = {'2 or less'};
    end
end

testRetestTable = table(fileNames', timepoint, percentages, BEAMofficeControlScore, meanDeviation, medianDeviation);
% writetable(outputTable, append(extractBefore(filePath, 'Data'), 'BEAM ARVO Export ', char(datetime("today")), '.csv'))

%% All data into 1 mat

sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
numParticipants = strings(length(dir([sourceDirectory, '\BEAM*'])), 1);
allData = cell(length(numParticipants), 9);
isControl = [ones(1,16), 0, ones(1,16), zeros(1, 6), ones(1,6), zeros(1, 16), ones(1,4), [0, 0, 1, 1, 0, 0]]';
for i = 3:length(fileList)
    load(append(sourceDirectory, '\', fileList(i).name));
    allData{i-2,1} = extractBefore(extractAfter(fileName, 'BEAM_'), '_');
    allData{i-2,2} = deviations.time;
    allData{i-2,3} = deviations.percentage;
    allData{i-2,4} = deviations.maxSize;
    allData{i-2,5} = deviations.meanSize;
    allData{i-2,6} = deviations.medianSize;
    if contains(fileName, 'RETEST')
        allData{i-2,7} = 2;
    else
        allData{i-2,7} = 1;
    end
    allData{i-2,8} = isControl(i-2);
    allData{i-2,9} = testDataFinal.X;
end













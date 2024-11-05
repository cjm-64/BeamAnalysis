clear all; close all; clc

%% Script to analyze BEAM data
makeBEAMDataLocations()

%% Get File Names
fileNames = uigetfile('Data\Raw\BEAM_DATA\*.csv', "MultiSelect","on");


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

sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
numParticipants = strings(length(dir([sourceDirectory, '\BEAM*'])), 1);
timepoint = zeros(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationTimes = zeros(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationPercentages = zeros(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationMaxes = zeros(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationMeans = zeros(length(dir([sourceDirectory, '\BEAM*'])), 1);
deviationMedians = zeros(length(dir([sourceDirectory, '\BEAM*'])), 1);
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
    writeRowLocation = writeRowLocation + 1;
end

outputTable = table(numParticipants, timepoint, deviationTimes, deviationPercentages, deviationMaxes, deviationMeans, deviationMedians);
writetable(outputTable, append(extractBefore(sourceDirectory, 'Data'), 'BNC v IXT Output ', char(datetime("today")), '.csv'))

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
        longitudinalParticipants(partLoc, 1) = join(splitFileNames(i, 1:2), '_');
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

writeColLocation = 1;
fileNameSuffixes = unique(splitFileNames(:,3));
for i = 1:length(longitudinalParticipants)
    for j = 1:size(fileNameSuffixes,1)
        loadedFileName = join([longitudinalParticipants(i) fileNameSuffixes(j)], '_');
        load(append(sourceDirectory,'\', loadedFileName));
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
    end
end

%%
outputTable = table(longitudinalParticipants, deviationTimes, deviationPercentages, deviationMaxes, deviationMeans, deviationMedians);
writetable(outputTable, append(extractBefore(sourceDirectory, 'Data'), 'Test-Retest ', char(datetime("today")), '.csv'))



%% ARVO Export
% Pull only patient files
fileNames = uigetfile('Data\Final\*.mat', "MultiSelect","on")';
filePath = 'C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final';

% Metrics to pull
% Percentage - Also convert to OCS
% Mean/Median Deviations 

timepoint = zeros(size(fileNames));
percentages = zeros(size(fileNames));
BEAMofficeControlScore = cell(size(fileNames));
meanDeviation = zeros(size(fileNames));
medianDeviation = zeros(size(fileNames));

for i = 1:length(fileNames)
    load(append(filePath,'\', fileNames{i}));
    disp(fileNames{i})

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

outputTable = table(fileNames, timepoint, percentages, BEAMofficeControlScore, meanDeviation, medianDeviation);
writetable(outputTable, append(extractBefore(filePath, 'Data'), 'BEAM ARVO Export ', char(datetime("today")), '.csv'))
















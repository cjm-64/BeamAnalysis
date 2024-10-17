clear all; close all; clc

%% Script to analyze BEAM data
makeBEAMDataLocations()

%% Get File Names
fileNames = uigetfile('Data\Raw\BEAM_DATA\*.csv', "MultiSelect","on");

%% Process all files
for fileName = 1:size(fileNames, 2)
    if iscell(fileNames)
        BEAMAnalysisAutomaticCalibration(fileNames{fileName})
    else
        BEAMAnalysisAutomaticCalibration(fileNames)
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
splitFileNames = split(cellfun(@string, {fileList(3:end).name}'), ["_", "."]);
participantNames = strings(length(unique(splitFileNames(:,2))), 1);

for i = 1:size(splitFileNames,1)
    
end

deviationTimes = zeros(length(unique(splitFileNames(:,2))), 2);
deviationPercentages = zeros(length(unique(splitFileNames(:,2))), 2);
deviationMaxes = zeros(length(unique(splitFileNames(:,2))), 2);
deviationMeans = zeros(length(unique(splitFileNames(:,2))), 2);
deviationMedians = zeros(length(unique(splitFileNames(:,2))), 2);

writeRowLocation = 1;
writeColLocation = 1;
for i = 1:length(fileList)
    loadedFileName = fileList(i).name;
    splitName = split(loadedFileName, '_');
    if contains(splitName{1}, 'BEAM')
        load(append(sourceDirectory,'\', loadedFileName))
        disp(loadedFileName);
    else
        continue;
    end

    if ~contains(participantNames, splitName{2})
        participantNames(writeRowLocation) = splitName{2};
        writeColLocation = 1;
        deviationTimes(writeRowLocation, writeColLocation) = deviations.time;
        deviationPercentages(writeRowLocation, writeColLocation) = deviations.percentage;
        deviationMaxes(writeRowLocation, writeColLocation) = deviations.maxSize;
        deviationMeans(writeRowLocation, writeColLocation) = deviations.meanSize;
        deviationMedians(writeRowLocation, writeColLocation) = deviations.medianSize;
        writeRowLocation = writeRowLocation + 1;
    else
        writeColLocation = 2;
        deviationTimes(writeRowLocation, writeColLocation) = deviations.time;
        deviationPercentages(writeRowLocation, writeColLocation) = deviations.percentage;
        deviationMaxes(writeRowLocation, writeColLocation) = deviations.maxSize;
        deviationMeans(writeRowLocation, writeColLocation) = deviations.meanSize;
        deviationMedians(writeRowLocation, writeColLocation) = deviations.medianSize;
    end    
end

%%





clear all; close all; clc

%% Test-retest 
% Pull only certain files
fileList = uigetfile('Data\Final\*.mat', "MultiSelect","on")';
filePath = 'C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final\';

allData = zeros(ceil(size(fileList, 1)/2), 2);
loc = 1;
for i = 1:length(fileList)
    disp(fileList{i})
    load(append(filePath, fileList{i}))

    threshold = 10;
    deviations = calculateDeviations(testDataFinal, threshold);
    if ~isnan(deviations.X.startAndEnds(1,1)) 
        deviations.time = sum(deviations.X.lengths(:,2));
        deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100;
        deviations.maxSize = max(deviations.X.magnitude(:,1));
        deviations.meanSize = mean(deviations.X.magnitude(:,1));
        deviations.medianSize = median(deviations.X.magnitude(:,1));
    else
        deviations.time = 0;
        deviations.percentage = 0;
        deviations.maxSize = 0;
        deviations.meanSize = 0;
        deviations.medianSize = 0;
    end
    if contains(fileList{i}, 'RETEST')
        allData(loc, 2) = deviations.percentage;
    else
        allData(loc, 1) = deviations.percentage;
        loc = loc + 1;
    end
end
[r, LB, UB,F, df1, df2, p] = ICC(allData(:,1:2), '1-1', 0.05);

%% Weight deviation Percentages based on recording lengths - Test Retest

clear

% Load Data
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");


% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        testData{cellIndex, 1} = extractBefore(filePaths{cellIndex}, '.mat');
        testData{cellIndex, 2} = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
        % deviationData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).deviations.time;
        deviationData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).deviations.percentage;
    end
catch
    testData{1} = load(filePaths).testDataFinal.X;
end

% Scale time and percentage by weight
totalNumberSamples = sum(cellfun(@(x) size(x, 1), testData(:,2)));
weightForEachRecording = num2cell(cellfun(@(x) size(x, 1)/totalNumberSamples, testData(:,2)));
% timeDeviationForEachRecording = cellfun(@(x, y) x.*y, deviationData(:,1), weightForEachRecording);
percentDeviationForEachRecording = cellfun(@(x, y) x.*y, deviationData(:,1), weightForEachRecording);

% Organize into test-retest
participantIDs = strings(size(testData, 1)/2, 1);
organizedTestData = cell(size(testData, 1)/2, 4);
row = 1;
nameCol = 1;
timeCol = 1;
percentCol = 1;
for i = 1:size(testData, 1)
    nameSplit = split(testData{i,1}, '_');
    if contains(testData{i, 1}, 'RETEST')
        timeCol = 2;
        percentCol = 4;
    else
        timeCol = 1;
        percentCol = 3;
    end
    if i == 1
        participantIDs(row) = nameSplit{2};
    elseif sum(cellfun(@(x) contains(x, nameSplit{2}), participantIDs(:,1))) == 0 && i ~= 1
        row = row + 1;
        participantIDs(row) = nameSplit{2};
    end
    % organizedTestData{row, timeCol} = timeDeviationForEachRecording(i,1);
    organizedTestData{row, percentCol} = percentDeviationForEachRecording(i,1);
end

[r, LB, UB,F, df1, df2, p] = ICC(cell2mat(organizedTestData(:,3:4)), '1-1', 0.05)



%% BNC vs IXT
% Load all files 
sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
fileList = fileList(3:end);

% Pre allocate
firstRecordingParticipantName = strings(5, 1);
firstRecordingData = zeros(5, 5);
firstRecordingBNC = [ones(8, 1); 0; ones(8, 1); zeros(3, 1); ones(3, 1); zeros(4, 1)];
firstRecordingLoc = 1;

secondRecordingParticipantName = strings(5, 1);
secondRecordingData = zeros(5, 5);
secondRecordingBNC = [ones(8, 1); ones(8, 1); zeros(3, 1); ones(3, 1); zeros(4, 1)];
secondRecordingLoc = 1;

for i = 1:size(fileList, 1)
    disp(fileList(i).name)
    load(append(sourceDirectory, '\', fileList(i).name))
    data = [deviations.time, deviations.percentage, deviations.maxSize, deviations.meanSize, deviations.medianSize];
    if contains(fileList(i).name, 'RETEST')
        secondRecordingData(secondRecordingLoc, :) = data;
        secondRecordingParticipantName(secondRecordingLoc) = extractBefore(fileList(i).name, strfind(fileList(i).name, '.mat'));
        secondRecordingLoc = secondRecordingLoc + 1;
    else
        firstRecordingParticipantName(firstRecordingLoc) = extractBefore(fileList(i).name, strfind(fileList(i).name, '.mat'));
        firstRecordingData(firstRecordingLoc, :) = data;
        firstRecordingLoc = firstRecordingLoc + 1;
    end
end

firstRecordingTable = table(firstRecordingParticipantName, firstRecordingData, firstRecordingBNC);
secondRecordingTable = table(secondRecordingParticipantName, secondRecordingData, secondRecordingBNC);

writetable(firstRecordingTable, append(extractBefore(sourceDirectory, 'Data'), 'BNC v IXT First Recording ', char(datetime("today")), '.csv'))
writetable(secondRecordingTable, append(extractBefore(sourceDirectory, 'Data'), 'BNC v IXT Second Recording ', char(datetime("today")), '.csv'))

%% Weight deviation Percentages based on recording lengths - IXT v BNC

clear

% Load Data - Only IXT or BNC, not both at same time
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

testData = cell(flip(size(filePaths)));
deviationData = cell(size(filePaths, 2), 2);
maxDeviationSize = zeros(flip(size(filePaths)));
meanDeviationSize = zeros(flip(size(filePaths)));
medianDeviationSize = zeros(flip(size(filePaths)));
% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        testData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
        deviationData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).deviations.time;
        deviationData{cellIndex, 2} = load(append(fileRoot, filePaths{cellIndex})).deviations.percentage;
        maxDeviationSize(cellIndex) = load(append(fileRoot, filePaths{cellIndex})).deviations.maxSize;
        meanDeviationSize(cellIndex) = load(append(fileRoot, filePaths{cellIndex})).deviations.meanSize;
        medianDeviationSize(cellIndex) = load(append(fileRoot, filePaths{cellIndex})).deviations.medianSize;
    end
catch
    testData{1} = load(filePaths).testDataFinal.X;
end

% Calculate total weight
totalNumberSamples = sum(cellfun(@(x) size(x, 1), testData));
weightForEachRecording = num2cell(cellfun(@(x) size(x, 1)/totalNumberSamples, testData));
weightedTimeOfDeviation = cellfun(@(x, y) x.*y, deviationData(:,1), weightForEachRecording);
weightedPercentDeviated = cellfun(@(x, y) x.*y, deviationData(:,2), weightForEachRecording);

% Organize data into Test and Retest
participantIDs = strings(size(filePaths, 2), 1);
timepoint = zeros(size(participantIDs));
isControl = zeros(size(participantIDs));

tries = 1;
while tries < 10
    controlOrPatient = input('Is this data Controls (1) or Patient (0): ');
    if controlOrPatient == 0 || controlOrPatient == 1
        isControl = isControl + controlOrPatient;
        break
    else
        disp('Please input either 1 for controls or 0 for patients')
        tries = tries + 1;
    end
end


for fileIndex = 1:size(filePaths, 2)
    nameSplit = split(filePaths{1,fileIndex}, '_');
    participantIDs(fileIndex, 1) = nameSplit{2};
    if contains(filePaths{1,fileIndex}, 'RETEST')
        timepoint(fileIndex) = 1;
    else
        timepoint(fileIndex) = 0;
    end
end

outputTable = table(participantIDs, timepoint, isControl, weightedTimeOfDeviation, weightedPercentDeviated, maxDeviationSize, meanDeviationSize, medianDeviationSize);

if controlOrPatient == 1
    fileTitle = 'BNC Data ';
else
    fileTitle = 'IXT Data ';
end
writetable(outputTable, append(extractBefore(fileRoot, 'Data'), fileTitle, char(datetime("today")), '.csv'))









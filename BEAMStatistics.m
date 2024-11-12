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
[r, LB, UB,F, df1, df2, p] = ICC(allData(:,1:2), '1-1', 0.05)

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







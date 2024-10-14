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

%% Prep For Export

sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
for i = 1:length(fileList)
    loadedFileName = fileList(i).name
    if contains(loadedFileName, 'BEAM')
        load(loadedFileName)
    else
        % Do Nothing
    end
end
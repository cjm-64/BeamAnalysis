clear all; close all; clc

%% Script to analyze BEAM data
makeBEAMDataLocations()

%% Load File
[importedData, fileName] = importBEAMData(uigetfile('*.csv'));

% tic
%% Split into calibraiton data and test data then save
[calibrationDataRaw, testDataRaw] = splitBEAMData(importedData);

% Save to preproccesed folder
save(strcat('Data/Preprocessed/', fileName, '.mat'), "calibrationDataRaw", "testDataRaw")

%% Get calibration coeffs and save
calibrationCoeffs = getCalibrationCoeffs(calibrationDataRaw);

save(strcat('Data/Coefficients/', fileName, '.mat'), "calibrationCoeffs")

%% Center Data
testDataCentered = centerData(testDataRaw);

%% Apply Calibration
testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);

%% Filter Data
testDataFiltered = filterBEAMData(testDataCalibrated);

%% Save Processed Data
save(strcat('Data/Processed/', fileName, '.mat'), "testDataCentered", "testDataCalibrated", "testDataFiltered")


%% Subtract Left from Right
testDataFinal = getFinalData(testDataFiltered);

save(strcat('Data/Processed/', fileName, '.mat'), "testDataFinal")

%% Locate Deviations
threshold = 15;
deviations = calculateDeviations(testDataFinal, threshold);
if ~isnan(deviations.X.startAndEnds) 
    sum(deviations.X.lengths(:,2))
    max(deviations.X.magnitude(:,1))
else
    disp ("No Deviations")
end

save(strcat('Data/Metrics/', fileName, '.mat'), "threshold", "deviations")

% toc
%% Plot steps
plotBEAMProcessingSteps(testDataRaw, testDataFiltered, testDataCentered, testDataCalibrated)

%% Plot data with deviations
plotBEAMFinalData(testDataFinal, deviations)

%% Do Z score for histogram

%% Save all data to one file
save(strcat('Data/Final/', fileName, '.mat'), '-regexp', '^(?!(importedData|threshold)$).')









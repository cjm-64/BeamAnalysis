clear all; close all; clc

%% Script to analyze BEAM data
makeBEAMDataLocations()

%% Load File
[importedData, fileName] = importBEAMData(uigetfile('.csv'));

% tic
%% Split into calibraiton data nd test data
[calibrationDataRaw, testDataRaw] = splitBEAMData(importedData, fileName);

%% Get calibration coeffs
calibrationCoeffs = getCalibrationCoeffs(calibrationDataRaw, fileName);

%% Center Data
testDataCentered = centerData(testDataRaw, fileName);
% plotTypeVSType_Test(testDataFiltered, testDataCentered);

%% Apply Calibration
testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs, fileName);
% plotTypeVSType_Test(testDataCentered, testDataCalibrated);

%% Filter Data
testDataFiltered = filterBEAMData(testDataCalibrated, fileName);
% plotRawVSFiltered_cal(calibrationDataRaw, calibrationDataFiltered)
% plotTypeVSType_Test(testDataRaw, testDataFiltered);


%% Subtract Left from Right
testDataFinal = getFinalData(testDataFiltered, fileName);
figure()
plot(testDataFinal.time, testDataFinal.X)
title('Eye Alignment over time')
xlabel('Time (s)')
ylabel('Deviation (PD)')

%% Locate Deviations
threshold = 15;
deviations = calculateDeviations(testDataFinal, threshold, fileName);

% toc
%% Plot steps
plotBEAMProcessingSteps(testDataRaw, testDataFiltered, testDataCentered, testDataCalibrated)

%% Plot data with deviations
plotBEAMFinalData(testDataFinal, deviations)

%% Do Z score for histogram

%% Save all data to one file
save(strcat('Data/Final/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), '-regexp', '^(?!(importedData|threshold)$).')









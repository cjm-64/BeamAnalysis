clear all; close all; clc

%% Load File
importedData = importBEAMData(uigetfile('.csv'));
numericData = table2array(importedData(:,2:6));

%% Find where to split
[headers, headerLocs] = getHeaders(importedData.Header);
headerLocs(length(headerLocs) + 1) = size(numericData, 1);

%% Split into calibraiton data nd test data
% Data Organization [RightCal_5PD_RightEye_x, RightCal_5PD_LeftEye_x, R10Rx, R10Lx, R15Rx, R15Lx, L5Rx, L5Lx, L10Rx, L10Lx, L15Rx, L15Lx]
calibrationRaw = getCalData(numericData, length(headers)-1, headerLocs);

% Data Organization [RightEyeX LeftEyeX]
testDataRaw = numericData(headerLocs(7):headerLocs(8), [1 3]);

%% Create time vector
time = getTime(headers, size(testDataRaw,1));

%% Filter Calibration Data
calibrationDataFiltered = filterBEAMData(calibrationRaw, 35);
% calibrationDataFiltered = calibrationRaw;

%% Plot
calibrationLimits = CoG_getCalibrationLimits(calibrationDataFiltered);

%% Get Calibration Coeffs
rightEyeCalibrationCoeffs = abs(CoG_getCalibrationCoeffs(calibrationLimits(:,1:2:11), calibrationDataFiltered(:,1:2:11)))';
rightEyeCalibration = mean(rightEyeCalibrationCoeffs);
leftEyeCalibrationCoeffs = abs(CoG_getCalibrationCoeffs(calibrationLimits(:,2:2:12), calibrationDataFiltered(:,2:2:12)))';
leftEyeCalibration = mean(rightEyeCalibrationCoeffs);

%% Filter Test Data
testDataFiltered = filterBEAMData(testDataRaw, 35);

%% Center Data
testDataCentered = centerData(testDataFiltered);

%% Apply Calibration
testDataCalibrated = [testDataCentered(:,1)/rightEyeCalibration testDataCentered(:,2)/leftEyeCalibration];

%% Subtract Left form Right
finalData = abs(testDataCalibrated(:,1) - testDataCalibrated(:,2));

%% Locate Deviations
threshold = 15;
deviationStartAndEnds = getDeviations(finalData, threshold)';

%% Calculate Deviation Length
deviationLengths = getDeviationLengths(deviationStartAndEnds);

%% Calculate Deviation Magnitudes
deviationMagnitudes = getDeviationMagnitudes(finalData, deviationStartAndEnds);

%% Save Data
finalCoeffs = array2table([rightEyeCalibrationCoeffs leftEyeCalibrationCoeffs], "VariableNames",["rightEyeCalibrationCoeffs", "leftEyeCalibrationCoeffs"]);
finalDeviations = array2table([deviationStartAndEnds deviationLengths deviationMagnitudes], 'VariableNames',["deviationStart", "deviationEnds", "deviationLengthFrames", "deviationLengthTime", "deviationMagnitude", "deviationMagLocations"]);
save(input("Enter file name (no extension): ", "s"), "finalCoeffs", "testDataRaw", "testDataFiltered", "testDataCentered", "testDataCalibrated", "finalData", "finalDeviations", "time",  "threshold");

%% Plot

figure()
subplot (2,2,1)
plot(time, testDataRaw(:,1), 'r')
hold on
plot(time, testDataRaw(:,2), 'b')
title("Raw Data")
legend("Right Eye", "Left Eye")

subplot (2,2,2)
plot(time, testDataFiltered(:,1), 'r')
hold on
plot(time, testDataFiltered(:,2), 'b')
title("Smoothed")
legend("Right Eye", "Left Eye")

subplot(2,2,3)
plot(time, testDataCentered(:,1), 'r')
hold on
plot(time, testDataCentered(:,2), 'b')
title("Centered")
legend("Right Eye", "Left Eye")

subplot(2,2,4)
plot(time, testDataCalibrated(:,1), 'r')
hold on
plot(time, testDataCalibrated(:,2), 'b')
title("Calibrated")
legend("Right Eye", "Left Eye")

figure()
plot(time, finalData,'b')
hold on
yline(threshold)
plot(time(deviationStartAndEnds(:,1)), finalData(deviationStartAndEnds(:,1)), 'g*')
plot(time(deviationStartAndEnds(:,2)), finalData(deviationStartAndEnds(:,2)), 'm*')
plot(time(deviationMagnitudes(:,2)), deviationMagnitudes(:,1),'k*')
xlabel('time (s)')
ylabel('prism diopters')
title('Short recording of IXT patient with deviations')
legend('Deviation Amount','Threshold','Deviation Onset', 'Deviation End', 'Max deviation', 'Location','northwest')

figure()
histogram(finalData, 'BinWidth', 5, 'FaceColor', 'c')
xlabel('Prism Diopters')
ylabel('Frame Count')
title('Histogram of deviation over time')





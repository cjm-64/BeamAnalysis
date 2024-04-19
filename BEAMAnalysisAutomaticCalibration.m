clear all; close all; clc

%% Script to analyze BEAM data

%% Load File
[importedData, fileName] = importBEAMData(uigetfile('.csv'));

% tic
%% Split into calibraiton data nd test data
[calibrationDataRaw, testDataRaw] = splitBEAMData(importedData, fileName);

%% Filter Data
[calibrationDataFiltered, testDataFiltered] = filterBEAMData(calibrationDataRaw, testDataRaw);
% plotCalVSFiltered(calibrationDataRaw, calibrationDataFiltered)

%% Get calibration coeffs
rightEyeCalibrationCoeffs = abs(getCalibrationCoeffs(calibrationDataFiltered(:,1:2:11)));
rightEyeCalibration = mean(rightEyeCalibrationCoeffs);
leftEyeCalibrationCoeffs = abs(getCalibrationCoeffs(calibrationDataFiltered(:,2:2:12)));
leftEyeCalibration = mean(leftEyeCalibrationCoeffs);



%% Center Data
testDataCentered = centerData(testDataFiltered);

%% Apply Calibration
testDataCalibrated = [testDataCentered(:,1)/rightEyeCalibration testDataCentered(:,2)/leftEyeCalibration];

%% Subtract Left from Right
finalData = abs(testDataCalibrated(:,1)) - abs(testDataCalibrated(:,2));

%% Locate Deviations
threshold = 15;
deviationStartAndEnds = getDeviations(finalData, threshold)';

%% Calculate Deviation Length
deviationLengths = getDeviationLengths(deviationStartAndEnds);
sum(deviationLengths(:,2))

%% Calculate Deviation Magnitudes
deviationMagnitudes = getDeviationMagnitudes(finalData, deviationStartAndEnds);


toc
%% Save Data
finalCoeffs = array2table([rightEyeCalibrationCoeffs leftEyeCalibrationCoeffs], "VariableNames",["rightEyeCalibrationCoeffs", "leftEyeCalibrationCoeffs"]);
finalDeviations = array2table([deviationStartAndEnds deviationLengths deviationMagnitudes], 'VariableNames',["deviationStart", "deviationEnds", "deviationLengthFrames", "deviationLengthTime", "deviationMagnitude", "deviationMagLocations"]);
save(input("Enter file name (no extension): ", "s"), "finalCoeffs", "testDataRaw", "testDataFiltered", "testDataCentered", "testDataCalibrated", "finalData", "finalDeviations", "time",  "threshold");
%% Plot steps

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

%% Plot data with deviations

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

%% Plot histogram

figure()
histogram(finalData, 'BinWidth', 5, 'FaceColor', 'c')
xlabel('Prism Diopters')
ylabel('Frame Count')
title('Histogram of deviation over time')






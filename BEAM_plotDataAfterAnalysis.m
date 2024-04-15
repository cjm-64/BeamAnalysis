clear all; close all; clc

%% Load data

load(uigetfile('.mat'));

%% Plot each step

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

%% Plot Final data with deviations

figure()
plot(time, finalData,'b')
hold on
yline(threshold)
plot(time(finalDeviations.deviationStart), finalData(finalDeviations.deviationStart), 'g*')
plot(time(finalDeviations.deviationEnds), finalData(finalDeviations.deviationEnds), 'm*')
plot(time(finalDeviations.deviationMagLocations), finalDeviations.deviationMagnitude,'k*')
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

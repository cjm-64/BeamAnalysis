clear all; close all; clc

%% Load data

load(append('Data\Final\', uigetfile('Data\Final\*.mat')));

%% Plot each step

figure()
subplot (3,2,1)
plot(testDataFinal.time, testDataRaw.rightEye.X, 'r')
hold on
plot(testDataFinal.time, testDataRaw.leftEye.X, 'b')
title("Raw Data")
legend("Right Eye", "Left Eye")

subplot (3,2,2)
plot(testDataFinal.time, testDataCentered.rightEye.X, 'r')
hold on
plot(testDataFinal.time, testDataCentered.leftEye.X, 'b')
title("Centered")
legend("Right Eye", "Left Eye")

subplot(3,2,3)
plot(testDataFinal.time, testDataCalibrated.rightEye.X, 'r')
hold on
plot(testDataFinal.time, testDataCalibrated.leftEye.X, 'b')
title("Calibrated")
legend("Right Eye", "Left Eye")

subplot(3,2,4)
plot(testDataFinal.time, testDataFiltered.rightEye.X, 'r')
hold on
plot(testDataFinal.time, testDataFiltered.leftEye.X, 'b')
ylim([-50, 50])
title("Filtered")
legend("Right Eye", "Left Eye")

subplot(3,2,5:6)
plot(testDataFinal.time, testDataFinal.X)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
ylim([-50, 50])

%% Plot Final data with deviations

figure()
plot(testDataFinal.time, testDataFinal.X,'b')
hold on
yline(deviations.threshold, 'r--')
yline(-1*deviations.threshold, 'r--')
if ~isnan(deviations.X.startAndEnds(1,1))
    plot(testDataFinal.time(deviations.X.startAndEnds(:,1)), testDataFinal.X(deviations.X.startAndEnds(:,1)), 'g*')
    plot(testDataFinal.time(deviations.X.startAndEnds(:,2)), testDataFinal.X(deviations.X.startAndEnds(:,2)), 'm*')
    plot(testDataFinal.time(deviations.X.magnitude(:,2)), testDataFinal.X(deviations.X.magnitude(:,2)),'k*')
    legend('Deviation Amount','Threshold','Threshold','Deviation Onset', 'Deviation End', 'Max deviation', 'Location','northwest')
else
    legend('Deviation Amount','Threshold','Threshold', 'Location','northwest')
end
ylim([-50, 50])
xlabel('Time (s)')
ylabel('<--- Left Eye Trope      Prism Diopters (PD)      Right Eye Trope --->')
title('Short recording of IXT patient with deviations')


%% Plot histogram
figure()
histogram(testDataFinal.X, 'BinWidth', 2, 'FaceColor', 'c')
xlabel('Prism Diopters')
ylabel('Frame Count')
title('Histogram of deviation over time')

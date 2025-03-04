close all;

% samplingRate = 71;
% 
% for timeAmount = 1:5:120
%     clf
%     minute = [];
%     totalMinutes = (size(testDataFinal.time,1))/(timeAmount*samplingRate) - (mod(size(testDataFinal.time,1), (timeAmount*samplingRate)))/(timeAmount*samplingRate)
%     for i = 1:(timeAmount*samplingRate):size(testDataFinal.time,1)-(timeAmount*samplingRate)
%         minute = [minute; mean((testDataFinal.X (i:i+(timeAmount*samplingRate))))];
%     end
%     plot(minute)
% end

dummyRaw = testDataRaw;
dummyCalibration = calibrationCoeffs;

dummyRaw.rightEye.X = dummyRaw.rightEye.X - median(dummyRaw.rightEye.X);
dummyRaw.rightEye.X = dummyRaw.rightEye.X/dummyCalibration.rightEye;
dummyRaw.leftEye.X = dummyRaw.leftEye.X - median(dummyRaw.leftEye.X);
dummyRaw.leftEye.X = dummyRaw.leftEye.X/dummyCalibration.leftEye;


% Identify Raw Outliers Right Eye
figure()
plot(dummyRaw.time, dummyRaw.rightEye.X, 'r')
hold on
% plot(dummyRaw.leftEye.X,'g')
[tf, l, u, c] = isoutlier(dummyRaw.rightEye.X);
plot(dummyRaw.time(tf), dummyRaw.rightEye.X(tf),'k*')
yline(l,'b')
yline(u,'m')
hold off



% Conditionally Check Outlier AND >20 CALIBRATED
% NEEDS CALIBRATION CODE
uf = (abs(dummyRaw.rightEye.X)>45 | dummyRaw.rightEye.Radius==0 | ~dummyRaw.rightEye.Found);
uf = logical(uf);
figure()
plot(dummyRaw.time, dummyRaw.rightEye.X, 'r')
hold on
% plot(dummyRaw.leftEye.X,'g')
plot(dummyRaw.time(uf), dummyRaw.rightEye.X(uf),'k*')
hold off

% Replace Outliers with Median Right Eye
dummyRaw.rightEye.X_NaN = dummyRaw.rightEye.X;
dummyRaw.rightEye.X_NaN(uf) = NaN;
dummyRaw.rightEye.X_NaN = fillmissing(dummyRaw.rightEye.X_NaN, 'previous');

% Replace Outliers with Median Left Eye
[tf, l, u, c] = isoutlier(dummyRaw.leftEye.X);
uf = (tf | abs(dummyRaw.leftEye.X)>45 | ~dummyRaw.leftEye.Found);
uf = logical(uf);
dummyRaw.leftEye.X_NaN = dummyRaw.leftEye.X;
dummyRaw.leftEye.X_NaN(uf) = NaN;
dummyRaw.leftEye.X_NaN = fillmissing(dummyRaw.leftEye.X_NaN, 'previous');

% Check Outlier Removal
figure()
plot(dummyRaw.time, dummyRaw.rightEye.X_NaN, 'r')

% Assess Filtering (NEEDS time conversion and data collapse)
figure()
plot(dummyRaw.rightEye.X, 'k')
hold on
plot(dummyRaw.rightEye.X_NaN, 'r')
hold off


samplingRate = 71;

meanScatter = figure();
meanScatterAxes = axes(meanScatter);
for timeAmount = 1:5:120
    minute = [];
    totalMinutes = (size(dummyRaw.time,1))/(timeAmount*samplingRate) - (mod(size(dummyRaw.time,1), (timeAmount*samplingRate)))/(timeAmount*samplingRate);
    for i = 1:(timeAmount*samplingRate):size(dummyRaw.time,1)-(timeAmount*samplingRate)
        minute = [minute; mean((dummyRaw.rightEye.X_NaN (i:i+(timeAmount*samplingRate))))];
    end
    scatter(meanScatterAxes, timeAmount, mean(minute))
    hold on
end
hold off

stdScatter = figure();
stdScatterAxes = axes(stdScatter);
for timeAmount = 1:5:120
    minute = [];
    totalMinutes = (size(dummyRaw.time,1))/(timeAmount*samplingRate) - (mod(size(dummyRaw.time,1), (timeAmount*samplingRate)))/(timeAmount*samplingRate);
    for i = 1:(timeAmount*samplingRate):size(dummyRaw.time,1)-(timeAmount*samplingRate)
        minute = [minute; mean((dummyRaw.rightEye.X_NaN (i:i+(timeAmount*samplingRate))))];
    end
    scatter(stdScatterAxes, timeAmount, std(minute))
    hold on
end
hold off

minute = [];
timeAmount = 15;
totalMinutes = (size(dummyRaw.time,1))/(timeAmount*samplingRate) - (mod(size(dummyRaw.time,1), (timeAmount*samplingRate)))/(timeAmount*samplingRate);
for i = 1:(timeAmount*samplingRate):size(dummyRaw.time,1)-(timeAmount*samplingRate)
    minute = [minute; mean((dummyRaw.rightEye.X_NaN (i:i+(timeAmount*samplingRate))))];
end
figure()
plot(minute)

%%
time = 1:15*71:size(dummyRaw.time,1);
y = dummyRaw.rightEye.X(time);
xx = 1:size(dummyRaw.time,1);
yy = spline(time, y, xx);
figure()
plot(xx, yy)









dummy = testDataFinal.X;
time = testDataFinal.time;


for i = 1:60
    dummyBool(:,i) = isoutlier(testDataFinal.X, 'movmedian', 70*i);
end

dummySum = sum(dummyBool);

figure()
scatter(1:60, dummySum/size(dummy, 1))

% figure()
% plot(time, dummy, 'b')
% hold on
% plot(time(dummyBool(:,30)), dummy(dummyBool(:,30)), 'r*')


dummyOutlierRemoved = dummy;
dummyOutlierRemoved(dummyBool(:,30)) = median(dummyOutlierRemoved(~dummyBool(:,30)));
figure()
plot(time, dummy, 'b')
hold on
plot(time, dummyOutlierRemoved, 'r')
yline(15, 'k')
yline(-15, 'k')

%%
rawData = [testDataCalibrated.rightEye.X testDataCalibrated.leftEye.X];
dummy = zeros(size(rawData));
[b, a] = butter(8, 1/ceil(120/2), "low");
dummy = filtfilt(b, a, rawData);
dummy = movmedian(dummy, 5*120, 1,'Endpoints', 'shrink');
% plot(dummy)
% plot(abs(dummy(:,1))-abs(dummy(:,2)))
% hold on
% yline(10, 'k')
% yline(0, 'k')
% yline(-10, 'k')
% ylim([-50,50])

subtracted = abs(dummy(:,1))-abs(dummy(:,2));
fps = testDataCalibrated.fps;
numSecs = 10;
groupByFPS = fps * numSecs;
groupedPlaceholder = zeros(ceil(size(subtracted, 1)/groupByFPS), 1);
loc = 1;
inRange = 1;
windowStartLoc = 1;
while inRange == 1
    windowEndLoc = windowStartLoc + groupByFPS-1;
    if windowEndLoc < size(subtracted, 1)
        % Window end in range, group full window
        groupedPlaceholder(loc) = median(subtracted(windowStartLoc:windowStartLoc+groupByFPS));
        windowStartLoc = windowEndLoc;
        loc = loc + 1;
    else
        % Window end out of range, group up to end
        groupedPlaceholder(loc) = median(subtracted(windowStartLoc:size(subtracted, 1)));
        inRange = 0;
    end
end
% figure()
% plot(linspace(0,5400, size(groupedPlaceholder, 1)), smooth(groupedPlaceholder))
% yline(10, 'k')
% yline(0, 'k')
% yline(-10, 'k')
% ylim([-50,50])

figure()
plot(linspace(0,5400, size(subtracted, 1)), subtracted, 'r')
hold on
plot(linspace(0,5400, size(groupedPlaceholder, 1)), groupedPlaceholder, 'b')
yline(10, 'g')
yline(0, 'k')
yline(-10, 'k')
legend('Upper Bound', '0', 'Lower Bound', 'Current', 'New')
ylim([-50,50])
xlim([0 5400])

% figure()
% subplot(2, 1, 1)
% plot(linspace(0,5400, size(dummy, 1)),abs(dummy(:,1))-abs(dummy(:,2)))
% hold on
% yline(10, 'r')
% yline(0, 'k')
% yline(-10, 'r')
% ylim([-50,50])
% xlim([0 5400])
% title('Current Filtering')
% subplot(2, 1, 2)
% plot(linspace(0,5400, size(groupedPlaceholder, 1)), groupedPlaceholder)
% yline(10, 'r')
% yline(0, 'k')
% yline(-10, 'r')
% ylim([-50,50])
% xlim([0 5400])
% title('Desampled')

%%
linearRegressionCoeff = linspace(0,5400,size(dummy,1))'\subtracted;
[p, ~,mu] = polyfit(linspace(0,5400,size(dummy,1))', subtracted, 3);
f = polyval(p, time, [], mu);

figure()
plot(time, f);
hold on
plot(time, subtracted)

%%
dummy = testDataCalibrated.rightEye.X;
time = testDataCalibrated.time;
filtered = zeros(size(dummy));

for i = 1:length(dummy)
    winStart = i-60;
    winEnd = i+60;

    if winStart < 1
        filtered(i) = medianReplace(dummy(1:winEnd));
    elseif winEnd > length(dummy)
        filtered(i) = medianReplace(dummy(winStart:length(dummy)));
    else
        filtered(i) = medianReplace(dummy(winStart:winEnd));
    end
end

figure()
plot(time, dummy, 'r')
hold on
plot(time,filtered, 'b')
plot(time, testDataFiltered.rightEye.X)
legend('raw', 'newFilt', 'oldFilt')

%% 011 testing

rawRight = testDataRaw.rightEye.X;
rawLeft = testDataRaw.leftEye.X;
fs = 124;
[b, a] = butter(4, 5/ceil(fs/2), "low");
filteredRight = filtfilt(b, a, rawRight);
filteredLeft = filtfilt(b, a, rawLeft);
filteredRight = movmedian(filteredRight, 5*fs, 1,'Endpoints', 'shrink');
filteredLeft = movmedian(filteredLeft, 5*fs, 1,'Endpoints', 'shrink');

figure()
plot(testDataFinal.time, filteredRight, 'r')
hold on
plot(testDataFinal.time, filteredLeft, 'b')
legend('Right', 'Left')
xlabel('Time (s)')
ylabel('<- Eye is moving right      Pixel Position      Eye is moving left ->')
title('Filtered Raw Data - No Calibration or Centering')

%% Detrend before filtering
rawData = [testDataCalibrated.rightEye.X testDataCalibrated.leftEye.X];
time = testDataCalibrated.time;

pFitR = polyfit(time, rawData(:,1),1);
pFitL = polyfit(time, rawData(:,2),1);
pValR = polyval(pFitR, time);
pValL = polyval(pFitL, time);

figure()
subplot(4, 2, 1)
plot(time, rawData(:,1), 'b')
subplot(4, 2, 3)
plot(time, pValR, 'r')
subplot(4, 2, 5)
plot(time, rawData(:,1)-pValR,'m')

subplot(4, 2, 2)
plot(time, rawData(:,2), 'b')
subplot(4, 2, 4)
plot(time, pValL, 'r')
subplot(4, 2, 6)
plot(time, rawData(:,2)-pValL,'m')

subplot(4, 2, 7:8)
plot(time, abs() - abs(rawData(:,2)-pValL))
%% Double derivative, to get acceleration

detrendedRawData = [rawData(:,1)-pValR, rawData(:,2)-pValL];
velocity = [[0 0]; diff(detrendedRawData, 1, 1)];
acceleration = [[0 0]; diff(velocity)];

% Find Outliers, where rawData >45, radius not found, or eye not found
uf = (abs(detrendedRawData) > 60 | abs([[0 0]; diff([[0 0]; diff(detrendedRawData)])])>5);
uf = logical(uf);

% Replace Outliers with previous 
dummy = rawData;
dummy(uf) = NaN;
if isempty(uf)
    % Do nothing
elseif uf(1) == 1
    dummy(1) = median(dummy, 'omitnan');
end
dummy = fillmissing(dummy, 'previous');

% Low Pass Filter, cutoff of 5 Hz
[b, a] = butter(4, 5/ceil(fs/2), "low");
dummy = filtfilt(b, a, dummy);

% Moving median to smooth signal, windowsize based on seconds of data
dummy = movmedian(dummy, seconds*fs, 1,'Endpoints', 'shrink');


filteredData = dummy;

%% Gaussian filter

w = gausswin(124*5);
w = w/sum(w);
y1 = filter(w, 1, testDataCalibrated.rightEye.X);
y2 = filter(w, 1, testDataCalibrated.leftEye.X);
figure()
plot(y1)
hold on
plot(y2)

%% FFT
fs = 124;
t = 1/fs;
L = size(rawData,1);
time= testDataRaw.time;

Y = fftshift(fft(rawData));
plot(fs/L*(0:L-1),abs(Y))

%% pspectrum
[p,f,t] = pspectrum(rawData, fs,'spectrogram');

figure()
waterfall(f,t,p')
xlabel('Frequency (Hz)')
ylabel('Time (seconds)')
wtf = gca;
wtf.XDir = 'reverse';
view([30 45])

%%
M = 62;
L = floor(62*0.2);
lk = 0.7;
pspectrum(rawData,fs,"spectrogram", ...
    TimeResolution=M/fs,OverlapPercent=L/M*100, ...
    Leakage=lk)
title("pspectrum")
cc = clim;
xl = xlim;

%%
scatterData = [testDataRaw.leftEye.X, [0; diff([0; diff(testDataRaw.leftEye.X)])]];
uniquePositionValues = unique(scatterData(:,1));
positionAccelerationPairs = nan(size(uniquePositionValues,1), 3);
positionAccelerationPairs(:,1) = uniquePositionValues;
for i = 1:size(uniquePositionValues,1)
    positionAccelerationPairs(i,2) = mean(scatterData(find(scatterData(:,1)==uniquePositionValues(i)), 2));  
end

fitCoeffs = polyfit(positionAccelerationPairs(:,1), positionAccelerationPairs(:,2),3);
fitData = polyval(fitCoeffs, positionAccelerationPairs(:,1));
fitDistances = fitData - positionAccelerationPairs(:,2);

figure()
scatter(positionAccelerationPairs(:,1),positionAccelerationPairs(:,2))
hold on
plot(positionAccelerationPairs(:,1), fitData)
title(fileName, 'Interpreter','none')
xlabel('Position')
ylabel('Acceleration')

figure()
histogram(fitDistances, BinWidth=2)

%%
load("isControlList11Feb2025.mat")
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

allFits = array2table(nan(length(filePaths)*2, 7), ...
    'VariableNames',{'isControl', 'Timepoint','Eye','X3', 'X2', 'X1', 'X0'});

rowNum = 1;
for i = 1:length(filePaths)
    splitName = split(load(append(fileRoot, filePaths{i})).fileName, '_');

    isCurrentFileControl = isControlList.isControl(strcmp(isControlList.Var1, splitName{2}))

    if contains(load(append(fileRoot, filePaths{i})).fileName, 'RETEST')
        timepoint = 2;
    else
        timepoint = 1;
    end

    for j = 1:2
        allFits.isControl(rowNum) = isCurrentFileControl;
        allFits.Timepoint(rowNum) = timepoint;
        allFits.Eye(rowNum) = j;

        if j == 1
            [X3, X2, X1, X0] = getFit(load(append(fileRoot, filePaths{i})).testDataCalibrated.rightEye.X);
        else
            [X3, X2, X1, X0] = getFit(load(append(fileRoot, filePaths{i})).testDataCalibrated.leftEye.X);
        end
        allFits.X3(rowNum) = X3;
        allFits.X2(rowNum) = X2;
        allFits.X1(rowNum) = X1;
        allFits.X0(rowNum) = X0;
        rowNum = rowNum + 1;
    end    
end

avgControlFitCoeffs = [mean(allFits.X3(allFits.isControl == 1)), mean(allFits.X2(allFits.isControl == 1)),mean(allFits.X1(allFits.isControl == 1)),mean(allFits.X0(allFits.isControl == 1))];
avgPatientFitCoeffs = [mean(allFits.X3(allFits.isControl == 0)), mean(allFits.X2(allFits.isControl == 0)),mean(allFits.X1(allFits.isControl == 0)),mean(allFits.X0(allFits.isControl == 0))];

figure()
plot(-50:2:50, polyval(avgControlFitCoeffs, -50:2:50))
hold on
plot(-50:2:50, polyval(avgPatientFitCoeffs, -50:2:50))
legend('Controls', 'Patients')


%% Functions

function [X3, X2, X1, X0] = getFit(inputData)
    acceleration = [0; diff([0; diff(inputData)])];
    uniquePositionValues = unique(inputData);
    positionAccelerationPairs = nan(size(uniquePositionValues,1), 2);
    positionAccelerationPairs(:,1) = uniquePositionValues;
    for i = 1:size(uniquePositionValues,1)
        positionAccelerationPairs(i,2) = mean(acceleration(find(inputData(:,1)==uniquePositionValues(i))));  
    end
    fitCoeffs = polyfit(positionAccelerationPairs(:,1), positionAccelerationPairs(:,2),3);
    X3 = fitCoeffs(1);
    X2 = fitCoeffs(2);
    X1 = fitCoeffs(3);
    X0 = fitCoeffs(4);
end

function returnPoint = medianReplace(segment)
    dataPoint = segment(round(length(segment)/2));
    
    if dataPoint > median(abs(segment)) + 5 || dataPoint < median(abs(segment)) - 5
        returnPoint = median(segment);

    else
        returnPoint = dataPoint;
    end
end






















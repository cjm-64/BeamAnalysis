clear all; close all; clc;
load("Data\Final\BEAM_SALUS001_BASE.mat")

%% 

dummy = testDataFinal.X;
location = 1;
for seconds = 1:6
    binned = zeros(ceil((length(dummy)/testDataFinal.fps)/seconds), 2);
    time = linspace(0, 90, size(binned, 1));
    for j = 1:length(binned)
        winStart = j*testDataFinal.fps*seconds;
        winEnd = (j+1)*testDataFinal.fps*seconds;
        if winEnd > length(dummy) 
            binned(j, 1) = mean(dummy(j*testDataFinal.fps:length(dummy)));
            binned(j, 2) = median(dummy(j*testDataFinal.fps:length(dummy)));
        else
            binned(j, 1) = mean(dummy(j*testDataFinal.fps:(j+1)*testDataFinal.fps));
            binned(j, 2) = median(dummy(j*testDataFinal.fps:(j+1)*testDataFinal.fps));
        end
    end
%     if seconds == 1
%         figure(1)
%         plot(time, binned(:,1))
%         title('Mean')
%         hold on
% 
%         figure(2)
%         plot(time, binned(:,2))
%         title('Median')
%         hold on
%     else
%         figure(1)
%         plot(time, binned(:,1))
%         title('Mean')
% 
%         figure(2)
%         plot(time, binned(:,2))
%         title('Median')
%     end
%     figure()
    subplot(2, 3, location)
    plot(time, binned(:,1), 'r')
    hold on
    plot(time, binned(:,2), 'b')
    yline(10,'--k')
    yline(0,'--r')
    yline(-10,'--k')
    title(num2str(seconds))
    legend('Mean','Median')


    legendNames{location} = strcat(num2str(seconds));
    location = location + 1;
end
% figure(1)
% legend(legendNames)
% figure(2)
% legend(legendNames)


%%
figure()
subplot(2,1,1)
plot(TDFil.time, TDFil.rightEye.X, 'r')
hold on
plot(TDFil.time, TDFil.leftEye.X, 'b')
yline(10, 'g')
yline(-10, 'g')
yline(0, 'c')
title("Smoothed")
legend("Right Eye", "Left Eye")

subplot(2,1,2)
plot(testDataFinal.X, 'k')
hold on
plot(TDFil.rightEye.X, 'r')
plot(TDFil.leftEye.X, 'b')
yline(10, 'g')
yline(-10, 'g')
yline(0, 'c')



%% 

filterDummy = TDCal.rightEye.X;
uf = (abs([0; diff(filterDummy)])>50);
plot(filterDummy, 'r')
hold on

median(filterDummy)

% Replace Outliers with previous 
filterDummy(uf) = NaN;
if uf(1) == 1
    filterDummy(1) = median(filterDummy, 'omitnan');
end
filterDummy = fillmissing(filterDummy, 'previous');

plot(filterDummy, 'b')
median(filterDummy)


%% 

for i = 1:30
    a(i) = median(testDataRaw.rightEye.X(124*i));
end
plot(a)
figure()
plot(testDataRaw.rightEye.X, 'r')
hold on
plot(testDataRaw.rightEye.X - median(testDataRaw.rightEye.X(124*30)), 'b')

figure()
plot(testDataRaw.rightEye.X - median(testDataRaw.rightEye.X(124*30)), 'r')
hold on
plot(testDataRaw.leftEye.X - median(testDataRaw.leftEye.X(124*30)), 'b')
legend('Right', 'Left')


%% Detrending

x = TDFil.time;
yRight = TDFil.rightEye.X;
yLeft = TDFil.leftEye.X;

b1Right = x\yRight;
yCalcRight1 = b1Right*x;

b1left = x\yLeft;
yCalcLeft1 = b1left*x;

newYRight = yRight - yCalcRight1;
newYleft = yLeft - yCalcLeft1;

figure()
subplot(2,2,1)
plot(x, yRight, 'r')
hold on
plot(x, yCalcRight1, 'b')
plot(x, newYRight, 'g')
title('Right')
legend('Raw', 'Trendline', 'Detrended')

subplot(2,2,2)
plot(x,yLeft, 'r')
hold on
plot(x, yCalcLeft1, 'b')
plot(x, newYleft, 'g')
title('Left')
legend('Raw', 'Trendline', 'Detrended')

subplot(2,2,3:4)
plot(x, abs(yRight) - abs(yLeft), 'b')
hold on
plot(x,abs(newYRight)-abs(newYleft), 'r')
yline(10, 'k')
yline(-10, 'k')
ylim([-15 15])
title('Total')
legend('Original', 'Detrended')

%%

TDCen = centerData(testDataRaw);
TDCal = calibrateBEAMData(TDCen, calibrationCoeffs);
TDFil = filterBEAMData(TDCal);
TDReCen.rightEye.X = TDFil.rightEye.X - median(TDFil.rightEye.X(1:TDFil.fps*10));
TDReCen.leftEye.X = TDFil.leftEye.X - median(TDFil.leftEye.X(1:TDFil.fps*10));

figure()
subplot(2,1,1)
plot(TDReCen.rightEye.X, 'r')
hold on
plot(TDReCen.leftEye.X, 'b')
legend('Right Eye', 'Left Eye')

subplot(2,1,2)
plot(abs(TDReCen.rightEye.X) - abs(TDReCen.leftEye.X))
close 1


data = [TDFil.rightEye.X, TDFil.leftEye.X];
calibrationFigure = figure();
line1 = plot(data(:,1));
line2 = yline(0,'k');
startXLine = xline(1, 'g');
endXLine = xline(size(data(:,1), 1), 'm');
locations = zeros(2,2);
for i = 1:size(data,2)
    lineLocation = 1;
    startAndEndLocations = [1 size(data(:,1), 1)];
    button = 0;
    
    set(line1, 'YData', data(:,i))
    while button <= 2
        drawnow
        [x, y, button] = ginput(1);
        [breakflag, lineLocation, startAndEndLocations] = CoG_buttonPressed(round(x), button, lineLocation, startAndEndLocations, startXLine, endXLine);
        breakflag
        button
        if breakflag == true
            breakflag = false;
            break;
        end
    end
    set(startXLine, 'Value', 1)
    set(endXLine, 'Value', size(data(:,1), 1))
    locations(:,i) = startAndEndLocations;
end
close 1

TDReCen.rightEye.X = TDFil.rightEye.X - median(TDFil.rightEye.X(locations(1,1):locations(2,1), 1));
TDReCen.leftEye.X = TDFil.leftEye.X - median(TDFil.leftEye.X(locations(1,2):locations(2,2)));
TDReCen.fps = TDFil.fps;

figure()
subplot(2,1,1)
plot(TDReCen.rightEye.X, 'r')
hold on
plot(TDReCen.leftEye.X, 'b')
legend('Right Eye', 'Left Eye')

subplot(2,1,2)
plot(TDReCen.rightEye.X - TDReCen.leftEye.X)
hold on
yline(10, 'k')
yline(0, 'k')
yline(-10, 'k')

%%

calSide = fieldnames(calibrationDataRaw);
locations = zeros(12,2);
loc = 1;

calibrationFigure = figure();
line1 = plot(calibrationDataRaw.rightCal.fivePD.rightEye.X);
line2 = yline(0,'k');
startXLine = xline(1, 'g');
endXLine = xline(calibrationDataRaw.rightCal.fivePD.rightEye.X);
for CS = 1:numel(calSide)
    calAmount = fieldnames(calibrationDataRaw.(calSide{CS}));
    for CA = 1:numel(calAmount)
        calEye = fieldnames(calibrationDataRaw.(calSide{CS}).(calAmount{CA}));
        for CE = 1:numel(calEye)
            calDirection = fieldnames(calibrationDataRaw.(calSide{CS}).(calAmount{CA}).(calEye{CE}));
            for CD = 1:numel(calEye)
                if calDirection{CD} == "Radius" || calDirection{CD} == "Found" 
                    countinue
                else
                    lineLocation = 1;
                    startAndEndLocations = [1 size(calibrationDataRaw.(calSide{CS}).(calAmount{CA}).(calEye{CE}).(calDirection{CD}))];
                    button = 0;
                    
                    set(line1, 'YData', calibrationDataRaw.(calSide{CS}).(calAmount{CA}).(calEye{CE}).(calDirection{CD}))
                    while button <= 2
                        drawnow
                        [x, y, button] = ginput(1);
                        [breakflag, lineLocation, startAndEndLocations] = CoG_buttonPressed(x, button, lineLocation, startAndEndLocations, startXLine, endXLine);
                        breakflag
                        button
                        if breakflag == true
                            breakflag = false;
                            break;
                        end
                    end
                    set(startXLine, 'Value', 1)
                    set(endXLine, 'Value', size(data(:,1), 1))
                    locations(loc,:) = startAndEndLocations;
                    loc = loc + 1;
                end
            end
        end
    end
end

% fig1 = figure();
% line1 = plot(data(:,1));
% line2 = yline(0,'k');
% locations = zeros(2,2);
% for i = 1:size(data,2)
%     lineLocation = 1;
%     startAndEndLocations = [1 size(data(:,1), 1)];
%     button = 0;
%     
%     set(line1, 'YData', data(:,i))
%     while button <= 2
%         drawnow
%         [x, y, button] = ginput(1);
%         [breakflag, lineLocation, startAndEndLocations] = CoG_buttonPressed(x, button, lineLocation, startAndEndLocations, startXLine, endXLine);
%         breakflag
%         button
%         if breakflag == true
%             breakflag = false;
%             break;
%         end
%     end
%     set(startXLine, 'Value', 1)
%     set(endXLine, 'Value', size(data(:,1), 1))
%     locations(:,i) = startAndEndLocations;
% end

%%
figure(1)
while ishandle(1)
    calibrationCoeffs

    clf
    testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);
    testDataFiltered = filterBEAMData(testDataCalibrated); 
    testDataDetrended = detrendBEAMData(testDataFiltered);
    testDataFinal = getFinalData(testDataDetrended);

    threshold = 10;
    deviations = calculateDeviations(testDataFinal, threshold);
    if ~isnan(deviations.X.startAndEnds(1,1)) 
        deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100;
        deviations.meanSize = mean(deviations.X.magnitude(:,1));
        deviations.medianSize = median(deviations.X.magnitude(:,1))
    else
        deviations.percentage = 0;
        deviations.meanSize = 0;
        deviations.medianSize = 0;
        disp ("No Deviations")
    end
    
    subplot(2,1,1)
    plot(testDataDetrended.rightEye.X, 'r')
    hold on
    plot(testDataDetrended.leftEye.X, 'g')
    yline(0,'k')
    legend('Right', 'Left')
    
    subplot(2, 1, 2)
    plot(abs(testDataDetrended.rightEye.X) - abs(testDataDetrended.leftEye.X))
    yline(10, '--r')
    yline(-10, '--r')
    yline(0, 'k')
    ylim([-50,50])
    
    calibrationCoeffs.rightEye = input("Right eye coeff: ");
    calibrationCoeffs.leftEye = input("Left eye coeff: ");
end

%% Grouping to lower temporality to binary classification 

rawData = [testDataCalibrated.rightEye.X testDataCalibrated.leftEye.X];

grouping = zeros(360, 2, ceil(size(rawData, 1)/360));
loc = 1;
for i = 1:360:size(rawData,1)-360
    grouping(:, :, loc) = rawData(i:i+359, :);
    loc = loc + 1;
end

%% Combinging calibration and centering

set(0, 'units', 'pixels')
screenSizePixel = get(0,'screensize');

close all
calibrationFigure = figure("Position",[screenSizePixel(3)/2 + 2 42 ...
    screenSizePixel(3)/2 - 2 screenSizePixel(4)-126]);

xLines = [1, size(testDataFiltered.rightEye.X, 1); 1, size(testDataFiltered.leftEye.X, 1)];

while ishandle(1)
    clf
    testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);
    testDataFiltered = filterBEAMData(testDataCalibrated); 
    [testDataDetrended, xLines] = manualCenteringBEAM(detrendBEAMData(testDataFiltered), xLines);

    calibrationCoeffs

    subplot(2,1,1)
    plot(testDataDetrended.rightEye.X, 'r')
    hold on
    plot(testDataDetrended.leftEye.X, 'g')
    yline(0,'k')
    legend('Right', 'Left')
    hold off
    
    subplot(2, 1, 2)
    plot(testDataDetrended.rightEye.X - testDataDetrended.leftEye.X)
    yline(10, '--r')
    yline(-10, '--r')
    yline(0, 'k')
    ylim([-50,50])

    rCoeff = input("Right eye coeff: ");
    if ~isempty(rCoeff)
        calibrationCoeffs.rightEye = rCoeff;
    end

    lCoeff = input("Left eye coeff: ");
    if ~isempty(lCoeff)
        calibrationCoeffs.leftEye = lCoeff;
    end
    clear rCoeff lCoeff;

end


%% 
clear zdata
% data = [testDataDetrended.rightEye.X, testDataDetrended.leftEye.X];
data = testDataFinal.X;
averages = mean(data,1);
standardDevs = std(data,1);
zdata(:,1) = (data(:,1) - averages(1))/standardDevs(1);
% zdata(:,2) = (data(:,2) - averages(2))/standardDevs(2);
figure()
histogram(zdata(:,1))

%% 
figure()
histogram(testDataFinal.X,'BinWidth', 2)

%%

files = uigetfile('Data\Final\*.mat', "MultiSelect","on");
allData = cell(size(files, 2), 3);

for i = 1:length(files)
    disp(files{i})
    load(append('Data\Final\', files{i}))
    allData(i,1) = {testDataFinal.X};
    allData(i,2) = {mean(testDataFinal.X)};
    allData(i,3) = {std(testDataFinal.X)};
end

allMeans = mean([allData{:,2}])
allStD = mean([allData{:,3}])

%% 
files = uigetfile('Data\Final\*.mat', "MultiSelect","on");
allData = cell(size(files, 2), 3);

for i = 1:length(files)
    disp(files{i})
    load(append('Data\Final\', files{i}))
    allData(i,1) = {testDataFinal.X};
    allData(i,2) = {mean(testDataFinal.X)};
    allData(i,3) = {std(testDataFinal.X)};
    figure()
    histogram(testDataFinal.X,'BinWidth', 2)
    title(files{i}, Interpreter="none")
end

allMeans = mean([allData{:,2}])
allStD = mean([allData{:,3}])


%% Quick test for increasing threshold
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

thresholdAmounts = 1:15;
deviationPercentages = zeros(size(filePaths, 2)/2, length(thresholdAmounts)*2);
participantNames = strings(size(filePaths, 2)/2,1);

loc = 1;
for i = 1:length(filePaths)
    load(append(fileRoot,'\', filePaths{i}));
    disp(filePaths{i})
    if ~contains(participantNames(loc), 'BEAM')
        % Name not written, put it
        participantNames(loc) = extractBefore(filePaths{i}, 'RETEST');
    else
        %Do nothing
    end

    for j = 1:length(thresholdAmounts)
        threshold = thresholdAmounts(j);
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
        if contains(filePaths{i}, 'RETEST')
            deviationPercentages(loc, j*2) = deviations.percentage;
        else
            deviationPercentages(loc, (j*2)-1) = deviations.percentage;
            if j == length(thresholdAmounts)
                loc = loc + 1;
            end
        end
    end
end

outputTable = table(participantNames, deviationPercentages)

% [r, LB, UB, F, df1, df2, p] = ICC(M, type, alpha, r0);

resultsICC = zeros(length(thresholdAmounts), 2);
resultsICC(:,1) = thresholdAmounts;
for i = 1:size(deviationPercentages, 2)/2
    resultsICC(i,2) = ICC(deviationPercentages(:,(i*2)-1:i*2), '1-1', 0.05);
end

resultsICC

%% Weight deviation Percentages based on recording lengths - Test Retest

clear

% Load Data
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        testData{cellIndex, 1} = extractBefore(filePaths{cellIndex}, '.mat');
        testData{cellIndex, 2} = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
        deviationData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).deviations.time;
        deviationData{cellIndex, 2} = load(append(fileRoot, filePaths{cellIndex})).deviations.percentage;
    end
catch
    testData{1} = load(filePaths).testDataFinal.X;
end

% Scale time and percentage by weight
totalNumberSamples = sum(cellfun(@(x) size(x, 2), testData(:,2)));
weightForEachRecording = num2cell(cellfun(@(x) size(x, 2)/totalNumberSamples, testData(:,2)));
timeDeviationForEachRecording = cellfun(@(x, y) x.*y, deviationData(:,1), weightForEachRecording);
percentDeviationForEachRecording = cellfun(@(x, y) x.*y, deviationData(:,2), weightForEachRecording);

% Organize into test-retest
participantIDs = strings(size(testData, 1), 1);
organizedTestData = cell(size(testData, 1)/2, 4);
row = 1;
nameCol = 1;
timeCol = 1;
percentCol = 1;
for i = 1:size(testData, 1)
    nameSplit = split(testData{i,1}, '_');
    if contains(testData{i, 1}, 'RETEST')
        timeCol = 2;
        percentCol = 4;
    else
        timeCol = 1;
        percentCol = 3;
    end
    if i == 1
        participantIDs(row) = nameSplit{2};
    elseif sum(cellfun(@(x) contains(x, nameSplit{2}), participantIDs(:,1))) == 0 && i ~= 1
        row = row + 1;
        participantIDs(row) = nameSplit{2};
    end
    organizedTestData{row, timeCol} = timeDeviationForEachRecording(i,1);
    organizedTestData{row, percentCol} = percentDeviationForEachRecording(i,1);
end

[r, LB, UB,F, df1, df2, p] = ICC(cell2mat(organizedTestData(:,3:4)), '1-1', 0.05)

%% Weight deviation Percentages based on recording lengths - IXT v BNC

% Load Data
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        testData{cellIndex} = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
        deviationData{cellIndex} = load(append(fileRoot, filePaths{cellIndex})).deviations.percentage;
    end
catch
    testData{1} = load(filePaths).testDataFinal.X;
end


totalNumberSamples = sum(cellfun(@(x) size(x, 1), testData));
weightForEachRecording = num2cell(cellfun(@(x) size(x, 1)/totalNumberSamples, testData));
percentDeviationForEachRecording = cellfun(@(x, y) x.*y, deviationData, weightForEachRecording)';

%% Downsampling to 1 sec for histograms

% Load Data
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

closestUpperSquareRoot = ceil(sqrt(size(filePaths, 2)));

fps = 120;
numSecs = 1;
groupByFPS = fps * numSecs;
groupedData = cell(flip(size(filePaths)));
figure()
for cellIndex = 1:size(filePaths,2)
    testData = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
    inRange = 1;
    windowStartLoc = 1;
    groupedPlaceholder = zeros(ceil(size(testData, 1)/groupByFPS), 1);
    loc = 1;
    while inRange == 1
        windowEndLoc = windowStartLoc + groupByFPS-1;
        if windowEndLoc < size(testData, 1)
            % Window end in range, group full window
            groupedPlaceholder(loc) = mean(testData(windowStartLoc:windowStartLoc+groupByFPS));
            windowStartLoc = windowEndLoc;
            loc = loc + 1;
        else
            % Window end out of range, group up to end
            groupedPlaceholder(loc) = mean(testData(windowStartLoc:size(testData, 1)));
            inRange = 0;
        end
    end
    groupedData(cellIndex) = {groupedPlaceholder};
    subplot(closestUpperSquareRoot, closestUpperSquareRoot, cellIndex)
    histogram(groupedPlaceholder, 'BinWidth', 2)
    xlim([-45 45])
    ylim([0 3000])
    title(extractBefore(filePaths{cellIndex}, '.mat'), "Interpreter","none")
end

%% Create everage traces for each group and time point
clear

% Load Data - Only IXT or BNC, not both at same time
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

testData = cell(flip(size(filePaths)));
% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        testData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).testDataFinal.X;
    end
catch
    testData{1} = load(filePaths).testDataFinal.X;
end

dummy = nan(max(cellfun(@max, cellfun(@size, testData, 'UniformOutput', false))), size(testData, 1));
for i = 1:size(testData, 1)
    dummy(1:length(testData{i, 1}), i) = testData{i, 1};
end

figure()
plot(linspace(0, 90, size(dummy, 1)), mean(dummy, 2, 'omitnan'));
yline(0, 'k')
ylim([-15 15])
xlabel('Time (min)')
ylabel('<-OS Trope   Deviation(PD)   OD Trope->')
figTitle = input('Input title of figure: ', 's');
title(figTitle)

%% 

plot(downsample(testDataCentered.rightEye.X, 120), 'r')
hold on
plot(downsample(testDataCentered.leftEye.X, 120), 'g')


%% Assessing Detrending limits

%% Create everage traces for each group and time point
clear

% Load Data - Only IXT or BNC, not both at same time
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

testData = cell(size(filePaths, 2), 3);
% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        testData{cellIndex, 1} = load(append(fileRoot, filePaths{cellIndex})).testDataFiltered.rightEye.X;
        testData{cellIndex, 2} = load(append(fileRoot, filePaths{cellIndex})).testDataFiltered.leftEye.X;
        testData{cellIndex, 3} = load(append(fileRoot, filePaths{cellIndex})).testDataFiltered.time;
    end
catch
    testData{1} = load(filePaths).testDataFinal.X;
end

rightBetas = cellfun(@(x,y) y\x, testData(:,1), testData(:,3));
leftBetas = cellfun(@(x,y) y\x, testData(:,2), testData(:,3));
results = [mean(rightBetas), std(rightBetas) max(rightBetas) min(rightBetas); mean(leftBetas), std(leftBetas) max(leftBetas) min(leftBetas)]

allData = table(filePaths', rightBetas, leftBetas, isoutlier(rightBetas), isoutlier(leftBetas));
justOutliers = allData(any([allData.Var4(:) == 1 allData.Var5(:) == 1], 2), :);

%% How to detrend only true detrends
% Example
figure()
names = fieldnames(testDataFiltered);
for name = 1:numel(names)
    if names(name) == "time"
        testDataFiltered.time = testDataFiltered.time;
        continue;
    elseif names(name) == "fps"
        continue;
    else
        fit = polyfit(testDataFiltered.time, testDataFiltered.(names{name}).X, 1);
        detrendLine = polyval(fit, testDataFiltered.time);
        dummy.(names{name}) = testDataFiltered.(names{name}).X - detrendLine;
    end
    if name == 1
        subplot(3, 1, 1)
        plot(testDataFiltered.time, testDataFiltered.rightEye.X, 'r')
        hold on
        plot(testDataFiltered.time, detrend(testDataFiltered.rightEye.X), 'c')
        plot(testDataFiltered.time, detrendLine, 'g--')
        plot(testDataFiltered.time, testDataFiltered.rightEye.X - detrendLine, 'm')
        legend('Raw', 'detrend()', 'Calculated Detrend Line', 'Manual Detrend')
        title('Right Eye')
    else
        subplot(3, 1, 2)
        plot(testDataFiltered.time, testDataFiltered.leftEye.X, 'r')
        hold on
        plot(testDataFiltered.time, detrend(testDataFiltered.leftEye.X), 'c')
        plot(testDataFiltered.time, detrendLine, 'g--')
        plot(testDataFiltered.time, testDataFiltered.leftEye.X - detrendLine, 'm')
        legend('Raw', 'detrend()', 'Calculated Detrend Line', 'Manual Detrend')
        title('Left Eye')
    end
end
subplot(3,1,3)
plot(testDataFiltered.time, dummy.rightEye, 'Color', [0.6350 0.0780 0.1840, 0.25])
hold on
plot(testDataFiltered.time, dummy.leftEye, 'Color', [0.4660 0.6740 0.1880, 0.25])
plot(testDataFiltered.time, abs(dummy.rightEye) -  abs(dummy.leftEye), 'Color', [0.9290 0.6940 0.1250, 0.25])


%% Pull all data and look at linear fit characteristics
clear

% Load Data - Only IXT or BNC, not both at same time
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

fitCoeffs = zeros(size(filePaths, 2), 4);


if ~iscell(filePaths)
    disp(filePaths)
else
    for cellIndex = 1:size(filePaths, 2)
        rightEye = load(append(fileRoot, filePaths{cellIndex})).testDataFiltered.rightEye.X;
        leftEye = load(append(fileRoot, filePaths{cellIndex})).testDataFiltered.leftEye.X;
        time = load(append(fileRoot, filePaths{cellIndex})).testDataFiltered.time;

        rightFit = polyfit(time, rightEye, 1);
        rightLine = polyval(rightFit, time);
    
    
        leftFit = polyfit(time, leftEye, 1);
        leftLine = polyval(leftFit, time);
    
        fitCoeffs(cellIndex,:) = [rightFit, leftFit]
    
%         h = figure();
%         subplot(3, 1, 1)
%         plot(time, rightEye, 'r')
%         hold on
%         plot(time, rightLine, 'g--')
%         plot(time, rightEye-rightLine, 'b')
%         legend('Raw', 'Detrend Line', 'Detrended')
%         title('Right Eye')
%         
%         subplot(3, 1, 2)
%         plot(time, leftEye, 'r')
%         hold on
%         plot(time, leftLine, 'g--')
%         plot(time, leftEye-leftLine, 'b')
%         legend('Raw', 'Detrend Line', 'Detrended')
%         title('Left Eye')
%     
%         subplot(3, 1, 3)
%         plot(time, abs(rightEye-rightLine) - abs(leftEye-leftLine))
%         title('left-right')
%         uiwait(h)
        clear rightEye rightFit rightLine leftEye leftFit leftLine time h
    end
end



isDetrended = zeros(size(fitCoeffs, 1), 2);
for i = 1:size(fitCoeffs, 1)
    for j = 1:2
        if abs(fitCoeffs(i, (2*j)-1)) > 0.005
            isDetrended(i,j) = 1;
        else 
            if abs(fitCoeffs(i, (2*j))) < 12
                isDetrended(i,j) = 1;
            else
                isDetrended(i,j) = 0;
            end
        end
    end
end
output = table(filePaths', fitCoeffs(:, 1:2), isDetrended(:,1),  fitCoeffs(:, 3:4), isDetrended(:,2));
justOutliers = output(any([output.Var3(:) == 0 output.Var5(:) == 0], 2), :);



%%
files = output(any([abs(output.fitCoeffs(:,2))>10 abs(output.fitCoeffs(:,2))>10], 2), :);

for i = 1:size(files,1)
    rightEye = load(append(fileRoot, files.Var1{i})).testDataFiltered.rightEye.X;
    leftEye = load(append(fileRoot, files.Var1{i})).testDataFiltered.leftEye.X;
    time = load(append(fileRoot, files.Var1{i})).testDataFiltered.time;

    rightFit = polyfit(time, rightEye, 1);
    rightLine = polyval(rightFit, time);


    leftFit = polyfit(time, leftEye, 1);
    leftLine = polyval(leftFit, time);

    h = figure();
    subplot(3, 1, 1)
    plot(time, rightEye, 'r')
    hold on
    plot(time, rightLine, 'g--')
    plot(time, rightEye-rightLine, 'b')
    legend('Raw', 'Detrend Line', 'Detrended')
    title('Right Eye')
    
    subplot(3, 1, 2)
    plot(time, leftEye, 'r')
    hold on
    plot(time, leftLine, 'g--')
    plot(time, leftEye-leftLine, 'b')
    legend('Raw', 'Detrend Line', 'Detrended')
    title('Left Eye')

    subplot(3, 1, 3)
    plot(time, abs(rightEye-rightLine) - abs(leftEye-leftLine), 'b')
    yline(10, 'r--')
    yline(-10, 'r--')
    yline(0, 'k')
    title('left-right')

    sgtitle(files.Var1{i},'interpreter', 'none') 

    clear rightEye rightFit rightLine leftEye leftFit leftLine time h
end

%% Trying to better understand ICC values and why they're changing
% MSW = column
% MSR = rows
% load and split data
load("Test Retest Data 03Dec2024.mat");
BNC_Percentages = outputTable.deviationPercentages(outputTable.isControl == 1, :);
IXT_Percentages = outputTable.deviationPercentages(outputTable.isControl == 0, :);

% BNC
[n, k] = size(BNC_Percentages);
MSR = var(mean(BNC_Percentages, 2)) * k;
MSW = sum(var(BNC_Percentages,0, 2)) / n;

r = (MSR - MSW) / (MSR + (k-1)*MSW);

% BNC
[n, k] = size(BNCsubtractedFrom100);
MSR = var(mean(BNCsubtractedFrom100, 2)) * k;
MSW = sum(var(BNCsubtractedFrom100,0, 2)) / n;

r = (MSR - MSW) / (MSR + (k-1)*MSW);

% IXT 
[n, k] = size(IXT_Percentages);
MSR = var(mean(IXT_Percentages, 2)) * k;
MSW = sum(var(IXT_Percentages,0, 2)) / n;

r = (MSR - MSW) / (MSR + (k-1)*MSW);

%Basically because so many are below 0 it means that they are really
%vulnerable to changes  

%% Adjust diff cutoff

rawData = testDataCalibrated.rightEye.X;
radius = testDataCalibrated.rightEye.Radius;
found = testDataCalibrated.rightEye.Found;
time = testDataCalibrated.time;

% rawData = testDataCalibrated.leftEye.X;
% radius = testDataCalibrated.leftEye.Radius;
% found = testDataCalibrated.leftEye.Found;
% time = testDataCalibrated.time;

figure()
subplot(2, 2, 1)
title('Calibrated')
plot(time, rawData)


subplot(2, 2, 2)
title('Diff')
plot(abs([0; diff(rawData)]))
yline(15)

% Find Outliers, where rawData >45, radius not found, or eye not found
uf = (radius==0 | ~found | abs([0; diff(rawData)])>15);
uf = logical(uf);

dummy = rawData;
dummy(uf) = NaN;
fs = testDataCalibrated.fps;
seconds = 5;
if isempty(uf)
        % Do nothing
elseif uf(1) == 1
    dummy(1) = median(dummy, 'omitnan');
end
dummy = fillmissing(dummy, 'movmedian', seconds*fs);


subplot(2, 2, 3)
title('After diff')
plot(dummy)

 % Low Pass Filter, cutoff of 5 Hz
[b, a] = butter(4, 5/ceil(fs/2), "low");
dummy = filtfilt(b, a, dummy);

% Moving median to smooth signal, windowsize based on seconds of data
dummy = movmedian(dummy, seconds*fs, 1,'Endpoints', 'shrink');

subplot(2, 2, 4)
title('fully filtered')
plot(dummy)


%% Find shortest file
clear

% Load Data - Only IXT or BNC, not both at same time
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");


times = zeros(length(filePaths), 2);
for i = 1:length(filePaths)
    data = load(append(fileRoot, filePaths{i})).testDataFinal;
    times(i, 1) = max(data.time);
    times(i, 2) = size(data.time, 1);
end
min(times)

%% Clip to this

testData = cell(size(filePaths, 2)/2, 2);
row = 1;

for i = 1:length(filePaths)
    filePaths{i}
    data = load(append(fileRoot, filePaths{i})).testDataFinal;
    fps = data.fps;

    if max(data.time) > 5400
        alignment = data.X(1:data.fps*1800);
    else
        alignment = data.X;
    end

    if contains(filePaths{i}, 'RETEST')
        col = 2;
    else 
        col = 1;
    end

    testData{row, col} = alignment;
    if mod(i, 2) == 0
        row = row + 1;
    end
end

choppedDeviations = cellfun(@(x) getDeviations(x, 10, 124), testData, 'UniformOutput', false);

%%
devTime = zeros(size(choppedDeviations));
for i = 1:size(choppedDeviations, 1)
    for j = 1:size(choppedDeviations, 2)
        if isnan(choppedDeviations{i, j}(1))
            devTime(i,j) = 0;
        else
            devTime(i,j) = (choppedDeviations{i, j}(2)-choppedDeviations{i, j}(1))/1800;
        end
    end
end

[r, ~,~,~,~,~, p] = ICC(devTime, '1-1', 0.05)

dt1 = (zeros(size(devTime))+100) - devTime;
% IXT 
[n, k] = size(devTime);
MSR = var(mean(devTime, 2)) * k;
MSW = sum(var(devTime,0, 2)) / n;

r = (MSR - MSW) / (MSR + (k-1)*MSW);
%% 












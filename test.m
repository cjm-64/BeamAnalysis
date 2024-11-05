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
files = uigetfile('Data\Final\*.mat', "MultiSelect","on");
allData = zeros(ceil(size(files, 2)/2), 3);
loc = 1;
for i = 1:length(files)
    disp(files{i})
    load(append('Data\Final\', files{i}))

    threshold = 10;
    deviations = calculateDeviations(testDataFinal, threshold);
    if ~isnan(deviations.X.startAndEnds(1,1)) 
        deviations.time = sum(deviations.X.lengths(:,2));
        deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100;
        deviations.maxSize = max(deviations.X.magnitude(:,1));
        deviations.meanSize = mean(deviations.X.magnitude(:,1));
        deviations.medianSize = median(deviations.X.magnitude(:,1))
    else
        deviations.time = 0;
        deviations.percentage = 0;
        deviations.maxSize = 0;
        deviations.meanSize = 0;
        deviations.medianSize = 0;
        disp ("No Deviations")
    end
    if mod(i,2) == 0
        allData(loc, 2) = deviations.percentage;
        loc = loc + 1;
    else
        allData(loc, 1) = deviations.percentage;
    end

end
[r, LB, UB,F, df1, df2, p] = ICC(allData(:,1:2), '1-1', 0.05)




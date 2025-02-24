
load('Data\Final\BEAM_NJIT005_TEST.mat')
c1 = testDataFinal.X;
load('Data\Final\BEAM_NJIT005_RETEST.mat')
c2 = testDataFinal.X;
load('Data\Final\BEAM_SALUS001_TEST.mat')
p1 = testDataFinal.X;
load('Data\Final\BEAM_SALUS001_RETEST.mat')
p2 = testDataFinal.X;
clearvars -except c1 c2 p1 p2

allData = {c1,c2,p1,p2};
map = brewermap(4,'Set1');

%%
figure()
plot(linspace(0, 90, length(c1)), c1)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
title('Control Recording 1')
xlabel('Time (min)')
ylabel('<-OS Trope   Deviation(PD)   OD Trope->')
saveas(gcf, 'Control Recording 1.png')

figure()
plot(linspace(0, 90, length(c2)), c2)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
title('Control Recording 2')
xlabel('Time (min)')
ylabel('<-OS Trope   Deviation(PD)   OD Trope->')
saveas(gcf, 'Control Recording 2.png')

figure()
plot(linspace(0, 90, length(p1)), p1)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
title('IXT Recording 1')
xlabel('Time (min)')
ylabel('<-OS Trope   Deviation(PD)   OD Trope->')
saveas(gcf, 'Patient Recording 1.png')

figure()
plot(linspace(0, 90, length(p2)), p2)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
title('IXT Recording 2')
xlabel('Time (min)')
ylabel('<-OS Trope   Deviation(PD)   OD Trope->')
saveas(gcf, 'Patient Recording 2.png')


%%


figure()
histogram(c1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(1,:))
hold on
histogram(c2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
histogram(p1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(3,:))
histogram(p2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(4,:))
hold off
xlabel('Prism Diopters')
ylabel('Frame Count')
histogramTitle('Histogram of deviation over time')
legend('c1', 'c2', 'p1', 'p2')

%%
yLimits = [0 3*10^5];
xLimits = [-45 45];
figure()
histogram(c1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
xlim(xLimits)
ylim(yLimits)
title('Control 1')
xlabel('Deviation (PD)')
ylabel('Count')
% saveas(gcf, 'HistogramControl1.png')

figure()
histogram(p1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(1,:))
xlim(xLimits)
ylim(yLimits)
title('Patient 1')
xlabel('Deviation (PD)')
ylabel('Count')
% saveas(gcf, 'HistogramPatient1.png')

figure()
histogram(c2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
xlim(xLimits)
ylim(yLimits)
title('Control 2')
xlabel('Deviation (PD)')
ylabel('Count')
% saveas(gcf, 'HistogramControl2.png')

figure()
histogram(p2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor',  map(1,:))
xlim(xLimits)
ylim(yLimits)
title('Patient 2')
xlabel('Deviation (PD)')
ylabel('Count')
% saveas(gcf, 'HistogramPatient2.png')

%%
figure()
h1 = histfit(c1, ceil(length(unique(round(c1)))/2));
set(h1(1), 'facecolor', 'b');
set(h1(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Control Recording 1')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramControl1.png')

figure()
h2 = histfit(p1, ceil(length(unique(round(p1)))/2));
set(h2(1), 'facecolor', 'r');
set(h2(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Patient Recording 1')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramPatient1.png')

figure()
h3 = histfit(c2, ceil(length(unique(round(c2)))/2));
set(h3(1), 'facecolor', 'b');
set(h3(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Control Recording 2')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramControl2.png')

figure()
h4 = histfit(p2, ceil(length(unique(round(p2)))/2));
set(h4(1), 'facecolor', 'r');
set(h4(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Patient Recording 2')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramPatient2.png')

%%
fitdist(c1,  'Normal')
fitdist(c2,  'Normal')
fitdist(p1,  'Normal')
fitdist(p2,  'Normal')


%% Group  every second
groupedData = {};
fps = 120;
numSecs = 1;
groupByFPS = fps * numSecs;
for dataSetNum = 1:size(allData,2)
    dataSet = allData{dataSetNum};
    inRange = 1;
    windowStartLoc = 1;
    groupedPlaceholder = zeros(ceil(size(dataSet, 1)/groupByFPS), 1);
    loc = 1;
    while inRange == 1
        windowEndLoc = windowStartLoc + groupByFPS-1;
        if windowEndLoc < size(dataSet, 1)
            % Window end in range, group full window
            groupedPlaceholder(loc) = mean(dataSet(windowStartLoc:windowStartLoc+groupByFPS));
            windowStartLoc = windowEndLoc;
            loc = loc + 1;
        else
            % Window end out of range, group up to end
            groupedPlaceholder(loc) = mean(dataSet(windowStartLoc:size(dataSet, 1)));
            inRange = 0;
        end
    end
    groupedData(dataSetNum) = {groupedPlaceholder};
end

figure()
subplot(2, 2, 1)
plot(groupedData{1})
yline(10)
yline(-10)
yline(0)
ylim([-50 50])
title('C1')
subplot(2, 2, 2)
plot(groupedData{3})
yline(10)
yline(-10)
yline(0)
ylim([-50 50])
title('P1')
subplot(2, 2, 3)
plot(groupedData{2})
yline(10)
yline(-10)
yline(0)
ylim([-50 50])
title('C2')
subplot(2, 2, 4)
plot(groupedData{4})
yline(10)
yline(-10)
yline(0)
ylim([-50 50])
title('P2')


%%
for groupedDataNum = 1:4
    if groupedDataNum == 1
        histogramTitle = 'Control Recording 1';
        histogramColor = map(2,:);
    elseif groupedDataNum == 2
        histogramTitle = 'Control Recording 2';
        histogramColor = map(2,:);
    elseif groupedDataNum == 3
        histogramTitle = 'IXT Recording 1';
        histogramColor = map(1,:);
    else
        histogramTitle = 'IXT Recording 2';
        histogramColor = map(1,:);
    end

    figure()
    histogram(groupedData{groupedDataNum}, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', histogramColor)
    xlim([-45 45])
    ylim([0 3500])
    xlabel('<-OS Trope      Deviation(PD)       OD Trope->')
    ylabel('Time (s)')
    title(histogramTitle)
    saveas(gcf, append(histogramTitle,' Histogram.png'))
end

%%
inRange = 1;
windowStartLoc = 1;
groupedPlaceholder = zeros(ceil(size(c1, 1)/120), 1);
loc = 1;
while inRange == 1
    windowEndLoc = windowStartLoc + 119;
    if windowEndLoc < size(c1, 1)
        % Window end in range, group full window
        groupedPlaceholder(loc) = median(c1(windowStartLoc:windowStartLoc+120));
        windowStartLoc = windowEndLoc;
        loc = loc + 1;
    else
        % Window end out of range, group up to end
        groupedPlaceholder(loc) = median(c1(windowStartLoc:size(c1, 1)));
        inRange = 0;
    end
end

figure()
histogram(c1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))

figure()
histogram(groupedPlaceholder, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))

%% Test v Retest

% Load Data
[filePaths, fileRoot] = uigetfile('Data\Final\*.mat', "MultiSelect","on");

fps = 120;
numSecs = 1;
groupByFPS = fps * numSecs;
groupedData = cell(size(filePaths, 2)/2, 2);
participantIDs = strings(size(filePaths, 2), 1);
row = 1;

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
    nameSplit = split(filePaths{cellIndex}, '_');
    if contains(filePaths{cellIndex}, 'RETEST')
        col = 2;
    else
        col = 1;
    end
    if cellIndex == 1
        participantIDs(row) = nameSplit{2};
    elseif sum(cellfun(@(x) contains(x, nameSplit{2}), participantIDs(:,1))) == 0 && cellIndex ~= 1
        row = row + 1;
        participantIDs(row) = nameSplit{2};
    end
    groupedData(row, col) = {groupedPlaceholder};
end

for i = 1:size(groupedData, 2)
    figure()
    data = [];
    for j = 1:size(groupedData, 1)
        data = [data; groupedData{j, i}];
    end
    histogram(data, BinWidth=2)
    xlim([-45, 45])
    ylim([0, 35000])
    if i == 1
        title('Test')
    else
        title('Retest')
    end
end

%% 
% groupNames = categorical(["BNC Test" "BNC Retest" "IXT Test" "IXT Retest"]);
groupNames = categorical(["BNC" "IXT"]);
groupData = [mean([BNC_WeightedData{:,3}])*size(BNC_WeightedData, 1) mean([BNC_WeightedData{:,4}])*size(BNC_WeightedData, 1); mean([IXT_WeightedData{:,3}])*size(IXT_WeightedData, 1) mean([IXT_WeightedData{:,4}])*size(IXT_WeightedData, 1)];

bar(1:2, groupData)
set(gca, 'XTickLabel', groupNames(1:2))
legend('Test', 'Retest', Location='northwest')















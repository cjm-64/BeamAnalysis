
load('Data\Final\BEAM_NJIT003_OUT.mat')
c1 = testDataFinal.X;
load('Data\Final\BEAM_NJIT005_OUT.mat')
c2 = testDataFinal.X;
load('Data\Final\BEAM_SALUS003_BASE.mat')
p1 = testDataFinal.X;
load('Data\Final\BEAM_SALUS002_BASE.mat')
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
histogramTitle('Control 1')
xlabel('Time (min)')
ylabel('Deviation (PD)')
saveas(gcf, 'Control1.png')

figure()
plot(linspace(0, 90, length(c2)), c2)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
histogramTitle('Control 2')
xlabel('Time (min)')
ylabel('Deviation (PD)')
saveas(gcf, 'Control2.png')

figure()
plot(linspace(0, 90, length(p1)), p1)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
histogramTitle('Patient 1')
xlabel('Time (min)')
ylabel('Deviation (PD)')
saveas(gcf, 'Patient1.png')

figure()
plot(linspace(0, 90, length(p2)), p2)
yline(0, 'k')
yline(10, 'r--')
yline(-10, 'r--')
xlim([0 90])
ylim([-50 50])
histogramTitle('Patient 2')
xlabel('Time (min)')
ylabel('Deviation (PD)')
saveas(gcf, 'Patient2.png')


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
figure()
histogram(c1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Control 1')
xlabel('Deviation (PD)')
ylabel('Count')
saveas(gcf, 'HistogramControl1.png')

figure()
histogram(p1, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(1,:))
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Patient 1')
xlabel('Deviation (PD)')
ylabel('Count')
saveas(gcf, 'HistogramPatient1.png')

figure()
histogram(c2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Control 2')
xlabel('Deviation (PD)')
ylabel('Count')
saveas(gcf, 'HistogramControl2.png')

figure()
histogram(p2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor',  map(1,:))
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Patient 2')
xlabel('Deviation (PD)')
ylabel('Count')
saveas(gcf, 'HistogramPatient2.png')

%%
figure()
h1 = histfit(c1, ceil(length(unique(round(c1)))/2));
set(h1(1), 'facecolor', 'b');
set(h1(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Control 1')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramControl1.png')

figure()
h2 = histfit(p1, ceil(length(unique(round(p1)))/2));
set(h2(1), 'facecolor', 'r');
set(h2(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Patient 1')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramPatient1.png')

figure()
h3 = histfit(c2, ceil(length(unique(round(c2)))/2));
set(h3(1), 'facecolor', 'b');
set(h3(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Control 2')
ylabel('Count')
xlabel('Deviation (PD)')
saveas(gcf, 'FittedHistogramControl2.png')

figure()
h4 = histfit(p2, ceil(length(unique(round(p2)))/2));
set(h4(1), 'facecolor', 'r');
set(h4(2), 'color', 'k');
xlim([-45 45])
ylim([0 4*10^5])
histogramTitle('Patient 2')
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
for dataSetNum = 1:size(allData,2)
    dataSet = allData{dataSetNum};
    inRange = 1;
    windowStartLoc = 1;
    groupedPlaceholder = zeros(ceil(size(dataSet, 1)/120), 1);
    loc = 1;
    while inRange == 1
        windowEndLoc = windowStartLoc + 119;
        if windowEndLoc < size(dataSet, 1)
            % Window end in range, group full window
            groupedPlaceholder(loc) = median(dataSet(windowStartLoc:windowStartLoc+120));
            windowStartLoc = windowEndLoc;
            loc = loc + 1;
        else
            % Window end out of range, group up to end
            groupedPlaceholder(loc) = median(dataSet(windowStartLoc:size(dataSet, 1)));
            inRange = 0;
        end
    end
    groupedData(dataSetNum) = {groupedPlaceholder};
end

%%
for groupedDataNum = 1:4
    if groupedDataNum == 1
        histogramTitle = 'Control 1';
        histogramColor = map(2,:);
    elseif groupedDataNum == 2
        histogramTitle = 'Control 2';
        histogramColor = map(2,:);
    elseif groupedDataNum == 3
        histogramTitle = 'Patient 1';
        histogramColor = map(1,:);
    else
        histogramTitle = 'Patient 2';
        histogramColor = map(1,:);
    end

    figure()
    histogram(groupedData{groupedDataNum}, 'BinWidth', 1, 'FaceAlpha', 0.5, 'FaceColor', histogramColor)
    xlim([-45 45])
    ylim([0 2*10e2])
    xlabel('Prism Diopter (PD)')
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



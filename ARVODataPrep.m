clear all; close all; clc

%% Load Data

opts = detectImportOptions('C:\Users\VNEL\Dropbox\BEAM\Conferences\ARVO 2025\BEAM ARVO Export 04-Dec-2024.csv');
opts = setvaropts(opts, 4, "FillValue", 2);
data = readtable('C:\Users\VNEL\Dropbox\BEAM\Conferences\ARVO 2025\BEAM ARVO Export 04-Dec-2024.csv', opts);

%% Scatter of BEAM vs Mean Distance Control Score
x = data.MeanDistanceControl;
y = data.percentages;

fit = polyfit(x, y, 1);
px = [min(x), max(x)];
py= polyval(fit, px);

scatter(x, y)
hold on
plot(px, py)

%% Scatter of OCS Before and After
before = mean([data.DistanceControlBeforeBEAM1 data.DistanceControlBeforeBEAM2], 2, 'omitnan');
beforeNan = find(isnan(before), 1) - 1;
x = before(1:beforeNan);
y = data.DistanceControlAfterBEAM(1:beforeNan);

fit = polyfit(x, y, 1);
px = [min(x), max(x)];
py= polyval(fit, px);

scatter(x, y)
hold on
plot(px, py)
axis([1 5 1 5])

%% Create the final data table

splitNames = split(data.Var1, '_');
justNames = splitNames(:,2);
participantIDs = cellfun(@(x) extractAfter(x, 'LUS'), justNames, 'UniformOutput', false);

ARVODataFinal = table(participantIDs, data.timepoint, data.percentages, data.BEAMofficeControlScore, data.DistanceControlBeforeBEAM1, data.DistanceControlBeforeBEAM2, data.DistanceControlAfterBEAM, data.MeanDistanceControlBeforeBEAM, data.MeanDistanceControl);
outputVariableNames = {'ID', 'Timepoint', 'Percent Deviated', 'BEAM_OCS', 'OCS_Distance_1', 'OCS_Distance_2', 'OCS_Distance_3', 'Mean_OCS_Before_BEAM', 'Mean_OCS_Total'};
ARVODataFinal.Properties.VariableNames = outputVariableNames;

%% Create figures
fileList = ["BEAM_SALUS001_TEST.mat", "BEAM_SALUS001_RETEST.mat", "BEAM_SALUS008_RETEST.mat", "BEAM_SALUS012_TEST.mat"]';
filePath = "C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final\";

figure()
for i = 1:size(fileList, 1)
    load(filePath+fileList(i));
    if i < 3
        if i == 1
            figTitle = "Participant 1 First Recording";
        else
            figTitle = "Participant 1 Second Recording";
        end
    else
        figTitle = "Participant " + string(i-1);
    end
    subplot(2, 2, i)
    plot(testDataFinal.time/60, testDataFinal.X,'b')
    hold on
    yline(0, 'k')
    yline(deviations.threshold, 'r--')
    yline(-1*deviations.threshold, 'r--')
    ylim([-50, 50])
    xlabel('Time (min)')
    ylabel('Prism Diopters (PD)')
    title(figTitle)
end
sgtitle('Variaiblity in IXT patient Recordings')








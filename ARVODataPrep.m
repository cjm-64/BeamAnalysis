clear all; close all; clc

%% Load Data
[fileName, filePath] = uigetfile('Data\*.csv');
opts = detectImportOptions(append(filePath, fileName));
opts = setvaropts(opts, 4, "FillValue", 2);
data = readtable(append(filePath, fileName), opts);

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

visitNum = strings(22, 1);
visitNum(1:2:22) = "Visit 2";
visitNum(2:2:22) = "Visit 1";
ARVODataFinal = table(visitNum, data.percentages, data.BEAMofficeControlScore, data.MeanDistanceControl);
outputVariableNames = {'Visit_Num', 'Percent_Deviated', 'BEAM_OCS', 'Mean_OCS_Total'};
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

%% Group by control score


BEAM_OCS_2 = ARVODataFinal(round(ARVODataFinal.Mean_OCS_Total) == 2, :);
BEAM_OCS_3 = ARVODataFinal(round(ARVODataFinal.Mean_OCS_Total) == 3, :);
BEAM_OCS_4 = ARVODataFinal(round(ARVODataFinal.Mean_OCS_Total) == 4, :);

groupedPercentDeviated = [mean(BEAM_OCS_2.Percent_Deviated) std(BEAM_OCS_2.Percent_Deviated);
    mean(BEAM_OCS_3.Percent_Deviated) std(BEAM_OCS_3.Percent_Deviated);
    mean(BEAM_OCS_4.Percent_Deviated) std(BEAM_OCS_4.Percent_Deviated)];

%% 

sum(data.BEAMofficeControlScore == round(data.MeanDistanceControl))/22











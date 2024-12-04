clear all; close all; clc

%% Load Data

opts = detectImportOptions('C:\Users\VNEL\Dropbox\BEAM\Conferences\ARVO 2025\BEAM ARVO Export 04-Dec-2024.csv');
opts = setvaropts(opts, 4, "FillValue", 2);
data = readtable('C:\Users\VNEL\Dropbox\BEAM\Conferences\ARVO 2025\BEAM ARVO Export 04-Dec-2024.csv', opts);

%% Scatter of BEAM vs Mean Distance Control Score

beforeNan = find(isnan(data.MeanDistanceControl), 1) - 1;
x = data.MeanDistanceControl(1:beforeNan);
y = data.BEAMofficeControlScore(1:beforeNan);

[fit, s] = polyfit(x, y, 1);
px = [min(x), max(x)];
[py, delta] = polyval(fit, px, s);
rsquared = 1-(sum((y-py).^2)/sum((y-mean(y)).^2));

scatter(x, y)
hold on
plot(px, py)
axis([1 5 1 5])

%% Scatter of OCS Before and After
before = mean([data.DistanceControlBeforeBEAM1 data.DistanceControlBeforeBEAM2], 2, 'omitnan');

scatter(before, data.DistanceControlAfterBEAM)
axis([1 5 1 5])
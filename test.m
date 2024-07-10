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
plot(testDataFiltered.time, testDataFiltered.rightEye.X, 'r')
hold on
plot(testDataFiltered.time, testDataFiltered.leftEye.X, 'b')
yline(10, 'g')
yline(-10, 'g')
yline(0, 'c')
title("Smoothed")
legend("Right Eye", "Left Eye")

subplot(2,1,2)
plot(testDataFinal.X, 'k')
hold on
plot(testDataFiltered.rightEye.X, 'r')
plot(testDataFiltered.leftEye.X, 'b')
yline(10, 'g')
yline(-10, 'g')
yline(0, 'c')



%% 

filterDummy = testDataCalibrated.rightEye.X;
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


%% 

x = testDataFiltered.time;
yRight = testDataFiltered.rightEye.X;
yLeft = testDataFiltered.leftEye.X;

b1Right = x\yRight;
yCalcRight1 = b1Right*x;

b1left = x\yLeft;
yCalcLeft1 = b1left*x;

newYRight = yRight - yCalcRight1;
newYleft = yLeft - yCalcLeft1;

figure()
subplot(2,2,1)
plot(x,yRight, 'r')
hold on
plot(x, yCalcRight1, 'b')
plot(x, newYRight, 'g')

subplot(2,2,2)
plot(x,yLeft, 'r')
hold on
plot(x, yCalcLeft1, 'b')
plot(x, newYleft, 'g')

subplot(2,2,3:4)
plot(x, yRight - yLeft, 'b')
hold on
plot(x,newYRight-newYleft, 'r')
yline(10, 'k')
yline(-10, 'k')
ylim([-15 15])












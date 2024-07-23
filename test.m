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


%% 

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

subplot(2,2,2)
plot(x,yLeft, 'r')
hold on
plot(x, yCalcLeft1, 'b')
plot(x, newYleft, 'g')
title('Left')

subplot(2,2,3:4)
plot(x, yRight - yLeft, 'b')
hold on
plot(x,newYRight-newYleft, 'r')
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
fig1 = figure();
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

fig1 = figure();
line1 = calibrationDataRaw.rightCal.fivePD.rightEye;
line2 = yline(0,'k');
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
% startXLine = xline(1, 'g');
% endXLine = xline(size(data(:,1), 1), 'm');
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














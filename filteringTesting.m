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
[b, a] = butter(4, 1/ceil(120/2), "low");
dummy = filtfilt(b, a, rawData);
dummy = movmedian(dummy, 5*120, 1,'Endpoints', 'shrink');
% plot(dummy)
plot(abs(dummy(:,1))-abs(dummy(:,2)))
hold on
yline(10, 'k')
yline(0, 'k')
yline(-10, 'k')
ylim([-50,50])

subtracted = abs(dummy(:,1))-abs(dummy(:,2));
fps = 120;
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
        groupedPlaceholder(loc) = mean(subtracted(windowStartLoc:windowStartLoc+groupByFPS));
        windowStartLoc = windowEndLoc;
        loc = loc + 1;
    else
        % Window end out of range, group up to end
        groupedPlaceholder(loc) = mean(subtracted(windowStartLoc:size(subtracted, 1)));
        inRange = 0;
    end
end
figure()
plot(linspace(0,5400, size(groupedPlaceholder, 1)), smooth(groupedPlaceholder))
yline(10, 'k')
yline(0, 'k')
yline(-10, 'k')
ylim([-50,50])

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



function returnPoint = medianReplace(segment)
    dataPoint = segment(round(length(segment)/2));
    
    if dataPoint > median(abs(segment)) + 5 || dataPoint < median(abs(segment)) - 5
        returnPoint = median(segment);

    else
        returnPoint = dataPoint;
    end
end























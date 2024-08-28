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


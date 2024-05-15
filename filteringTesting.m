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
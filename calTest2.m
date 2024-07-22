%% Load files
path = "Data/Coefficients";
files = dir(path);

numFiles = sum(contains({files.name}, "BEAM"));
rightcoeffs = zeros(numFiles, 1);
leftcoeffs = zeros(numFiles, 1);
names = strings(numFiles, 1);
rowNum = 1;
data = zeros(4, 6, 10);
for i = 1:size(files, 1)
    if contains(files(i).name, "BEAM")
        load(path+"/"+files(i).name)
        data (:,:,rowNum) = offsets;
        names(rowNum) = files(i).name;
        rowNum = rowNum + 1;
    end
    if rowNum == 14
        break
    end
end
%%
for i = 1:size(data,3)
    figure(1)
    subplot(2, 1, 1)
    plot(data(4,4:6, i), data(1,4:6,i))
    hold on
    title('Left')

    subplot(2, 1, 2)
    plot(data(4,:, i), data(1,:,i))
    hold on
    title('Left Full')

    figure(2)
    subplot(2, 1, 1)
    plot(data(4,1:3, i), data(2,1:3,i))
    hold on
    title('Right')
    

    subplot(2, 1, 2)
    plot(data(4,:, i), data(2,:,i))
    hold on
    title('Right Full')
end

%%
dummyRTRE = zeros(15, 3);
dummyLTRE = zeros(15, 3);
dummyRTLE = zeros(15, 3);
dummyLTLE = zeros(15, 3);
dummyRTRE(1,:) = data(4,1:3,1);
dummyLTRE(1,:) = data(4,4:6,1);
dummyRTLE(1,:) = data(4,1:3,1);
dummyLTLE(1,:) = data(4,4:6,1);

for i = 1:size(data,3)
    dummyRTRE(i+1, :) = data(2,1:3,i);
    dummyLTRE(i+1, :) = data(2,4:6,i);
    dummyRTLE(i+1, :) = data(1,1:3,i);
    dummyLTLE(i+1, :) = data(1,4:6,i);
end

allDummy = [dummyRTRE, dummyLTRE, dummyRTLE, dummyLTLE];

regressionRTRE = zeros(size(data,3), 2);
regressionLTRE = zeros(size(data,3), 2);
regressionRTLE = zeros(size(data,3), 2);
regressionLTLE = zeros(size(data,3), 2);
for i = 2:size(dummyRTRE, 1)
    regressionRTRE(i-1,:) = polyfit(dummyRTRE(1,:), dummyRTRE(i,:), 1);
    regressionLTRE(i-1,:) = polyfit(dummyLTRE(1,:), dummyLTRE(i,:), 1);
    regressionRTLE(i-1,:) = polyfit(dummyRTLE(1,:), dummyRTLE(i,:), 1);
    regressionLTLE(i-1,:) = polyfit(dummyLTLE(1,:), dummyLTLE(i,:), 1);
end

allRegression = [regressionRTRE, regressionLTRE, regressionRTLE, regressionLTLE];

%%
yLeftTarget = 5:0.1:15;
yRightTarget = -15:0.1:-5;
for i = 1:1
    figure()
    title(num2str(i))

    yCalc = allRegression(i,1)*yRightTarget + allRegression(i,2);
    subplot(2, 2, 1)
    plot(dummyRTRE(1,1:3), dummyRTRE(i,1:3))
    hold on
    plot(yRightTarget, yCalc)
    legend('Raw', 'Regression')
    title('Right Target Right Eye')

    yCalc = allRegression(i,3)*yLeftTarget + allRegression(i,4);
    subplot(2, 2, 2)
    plot(dummyLTRE(1,1:3), dummyLTRE(i,1:3))
    hold on
    plot(yLeftTarget, yCalc)
    legend('Raw', 'Regression')
    title('Left Target Right Eye')

    yCalc = allRegression(i,5)*yRightTarget + allRegression(i,6);
    subplot(2, 2, 3)
    plot(dummyRTLE(1,1:3), dummyRTLE(i,1:3))
    hold on
    plot(yRightTarget, yCalc)
    legend('Raw', 'Regression')
    title('Right Target Left Eye')

    yCalc = allRegression(i,7)*yLeftTarget + allRegression(i,8);
    subplot(2, 2, 4)
    plot(dummyLTLE(1,1:3), dummyLTLE(i,1:3))
    hold on
    plot(yLeftTarget, yCalc)
    legend('Raw', 'Regression')
    title('Left Target Left Eye')
end

%%
for i = 1:size(test, 1)
    yCalc = yLeftTarget*test(i,1) + test(i,2);
    
    figure()
    plot(dummyRightTarget(i,1:3), dummyRightTarget(i,4:6))
    hold on
    plot(yLeftTarget, yCalc)
    title(names(i), Interpreter="none")
end

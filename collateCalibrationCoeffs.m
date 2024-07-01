clear all; close all; clc

%% Load files
path = "Data/Coefficients";
files = dir(path);
rightcoeffs = zeros(11, 1);
leftcoeffs = zeros(11, 1);
names = strings(11, 1);
rowNum = 1;
for i = 1:size(files, 1)
    if contains(files(i).name, "BEAM")
        load(path+"/"+files(i).name)
        rightcoeffs(rowNum) = calibrationCoeffs.rightEye;
        leftcoeffs(rowNum) = calibrationCoeffs.leftEye;
        names(rowNum) = files(i).name;
        rowNum = rowNum + 1;
    end
end
output = table(names, rightcoeffs, leftcoeffs)

%% 
sprintf('Right: %f ± %f', mean(output.rightcoeffs),  std(output.rightcoeffs))
sprintf('Right Max: %f      Right Min: %f', mean(output.rightcoeffs)+2*std(output.rightcoeffs),  mean(output.rightcoeffs)-2*std(output.rightcoeffs))
sprintf('Left: %f ± %f', mean(output.leftcoeffs),  std(output.leftcoeffs))
sprintf('Left Max: %f      Right Left: %f', mean(output.leftcoeffs)+2*std(output.leftcoeffs),  mean(output.leftcoeffs)-2*std(output.leftcoeffs))


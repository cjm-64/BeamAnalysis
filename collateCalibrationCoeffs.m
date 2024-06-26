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
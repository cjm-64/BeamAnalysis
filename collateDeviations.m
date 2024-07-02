clear all; close all; clc;


%% Load files
path = "Data/Final";
files = dir(path);

numFiles = sum(contains({files.name}, "BEAM"));
time = zeros(numFiles, 1);
maxMag = zeros(numFiles, 1);
meanMag = zeros(numFiles, 1);
medMag = zeros(numFiles, 1);
names = strings(numFiles, 1);
rowNum = 1;

for i = 1:size(files, 1)
    if contains(files(i).name, "BEAM")
        load(path+"/"+files(i).name)
        
        % Locate Deviations
        threshold = 10;
        deviations = calculateDeviations(testDataFinal, threshold);
        if ~isnan(deviations.X.startAndEnds(1,1)) 
            deviations.time = sum(deviations.X.lengths(:,2));
            deviations.percentage = (deviations.time/max(testDataFinal.time))*100;
            deviations.maxSize = max(deviations.X.magnitude(:,1));
            deviations.meanSize = mean(deviations.X.magnitude(:,1));
            deviations.medianSize = median(deviations.X.magnitude(:,1))
        else
            deviations.time = 0;
            deviations.percentage = 0;
            deviations.maxSize = 0;
            deviations.meanSize = 0;
            deviations.medianSize = 0;
            disp ("No Deviations")
        end
        
        save(strcat('Data/Metrics/', fileName, '.mat'), "threshold", "deviations")

        % Save all data to one file
        save(strcat('Data/Final/', fileName, '.mat'), '-regexp', '^(?!(importedData|threshold)$).')

        time(rowNum) = deviations.time;
        maxMag(rowNum) = deviations.maxSize;
        meanMag(rowNum) = deviations.meanSize;
        medMag(rowNum) = deviations.medianSize;
        names(rowNum) = fileName;
        rowNum = rowNum + 1;
    end
end

output = table(names, time, maxMag, meanMag, medMag)


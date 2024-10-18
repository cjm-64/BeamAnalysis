load('C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final\BEAM_NJIT003_TEST.mat');
c1 = testDataFinal.X;
load('C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final\BEAM_NJIT003_RETEST.mat');
c2 = testDataFinal.X;

load('C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final\BEAM_SALUS002_TEST.mat');
p1 = testDataFinal.X;
load('C:\Users\VNEL\Documents\GitHub\BeamAnalysis\Data\Final\BEAM_SALUS002_RETEST.mat');
p2 = testDataFinal.X;
clearvars -except c1 c2 p1 p2

subplot(2, 2, 1)
semilogy(abs(c1))
title('Control Test')
subplot(2, 2, 2)
semilogy(abs(p1))
title('Patient Test')
subplot(2, 2, 3)
semilogy(abs(c2))
title('Control Retest')
subplot(2, 2, 4)
semilogy(abs(p2))
title('Patient Retest')

%%
sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
writeRowLocation = 1;
output = strings(50,2);
for i = 1:length(fileList)
    loadedFileName = fileList(i).name;
    if contains(loadedFileName, 'BEAM')
        load(append(sourceDirectory,'\', fileList(i).name))
        disp(loadedFileName);
    else
        continue;
    end
    output(i,:) = [fileList(i).name string(mean(testDataFinal.X))];

end

%% Locate Deviations
sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
fileList = fileList(3:end);

threshold = 5;
for i = 1:length(fileList)
    loadedFileName = fileList(i).name;
    load(append(sourceDirectory,'\', fileList(i).name))
    disp(loadedFileName);
    deviations = calculateDeviations(testDataFinal, threshold);
    if ~isnan(deviations.X.startAndEnds(1,1)) 
        deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100;
    else
        deviations.percentage = 0;
        disp ("No Deviations")
    end
    output(i,:) = [fileList(i).name string(deviations.percentage)];
    
end

%% Prep For Export - Test-Retest
sourceDirectory = uigetdir('Data\');
fileList = dir(sourceDirectory);
splitFileNames = split(cellfun(@string, {fileList(3:end).name}'), "_");

longitudinalParticipants = strings(2, 1);
partLoc = 1;
inRange = 1;
i = 1;
while inRange == 1
    if i > size(splitFileNames, 1)
        inRange = 0;
        break;
    end

    if sum(strcmp(splitFileNames(i,2), splitFileNames(:,2))) > 1
        % This participant has both files
        longitudinalParticipants(partLoc, 1) = join(splitFileNames(i, 1:2), '_');
        partLoc = partLoc + 1;
        i = i + 2;
    else
        % This participant has one file - do nothing
        i = i + 1;
    end
end

deviationPercentages = zeros(size(longitudinalParticipants, 1), 2);
threshold = 10;

writeColLocation = 1;
fileNameSuffixes = unique(splitFileNames(:,3));
for i = 1:length(longitudinalParticipants)
    for j = 1:size(fileNameSuffixes,1)
        loadedFileName = join([longitudinalParticipants(i) fileNameSuffixes(j)], '_');
        load(append(sourceDirectory,'\', loadedFileName));
        disp(loadedFileName);

        if contains(loadedFileName, 'RETEST')
            writeColLocation = 2;
        else
            writeColLocation = 1;
        end
    
        deviations = calculateDeviations(testDataFinal, threshold);
        if ~isnan(deviations.X.startAndEnds(1,1)) 
            deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100
        else
            deviations.percentage = 0
            disp ("No Deviations")
        end
    
        deviationPercentages(i,writeColLocation) = deviations.percentage;
    end    
end
output = table(longitudinalParticipants, deviationPercentages);
writetable(output, 'test.csv');









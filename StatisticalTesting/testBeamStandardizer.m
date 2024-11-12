clear

% Load Data
filePaths = uigetfile("MultiSelect","on");

% Load Data into Cell Array
try
    for cellIndex = 1:size(filePaths,2)
        cellData{cellIndex} = load(filePaths{cellIndex}).testDataFinal.X;
    end
catch
    cellData{1} = load(filePaths).testDataFinal.X;
end

% Calculate Subsample Average and STDEVs
perCellAverage = cellfun(@mean, cellData);
perCellSize = cellfun(@length, cellData);
perCellStDev = cellfun(@std, cellData);

% Calculate Group Level Behaviors
masterSamplePoints = sum(perCellSize);
masterWeights = perCellSize/masterSamplePoints;

% Apply Weights for Summation
masterAverage = sum(perCellAverage.*masterWeights);
masterStDev = sqrt(sum(perCellStDev.^2 ./ size(filePaths,2)));

% Run the Scores
sampleZScores = cellfun(@(x) createZScore(x, masterAverage, masterStDev), cellData,'UniformOutput', false);

% Stack 
colStackScores = nan(max(perCellSize),size(sampleZScores,2));
for fileInput = 1:size(sampleZScores,2)
    colStackScores(1:size(sampleZScores{fileInput}',1),fileInput) = sampleZScores{fileInput}';
end

n = size(colStackScores, 2);
a = [skewness(colStackScores(:,2:2:n)); skewness(colStackScores(:,1:2:n)); kurtosis(colStackScores(:,1:2:n)); kurtosis(colStackScores(:,2:2:n))]
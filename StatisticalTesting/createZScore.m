% Create Z Scores Based on Given Data Set with Master Average and Master
% Deviation
function zScoreCell = createZScore(cellDataSet, sampleAverage, sampleDeviation)
    zScoreCell = nan(1,length(cellDataSet));
    for indexValue = 1:length(cellDataSet)
        zScoreCell(1,indexValue) = (cellDataSet(indexValue) - sampleAverage) / sampleDeviation;
    end
end
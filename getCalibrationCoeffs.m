function calibrationCoeffs = getCalibrationCoeffs(calDataRaw)
    temp = calDataRaw;
    PD = [5 10 15];
    calDataMeans = mean(calibrationFilter(temp),1);
    calDataSubtracted = zeros(length(calDataMeans)/2,1);
    
    for i = 1:length(calDataMeans)/2
        calDataSubtracted(i) = calDataMeans(i) - calDataMeans(i+length(calDataMeans)/2);
    end
    
    calDataDivPD = zeros(length(calDataSubtracted),1);
    for i = 1:length(PD)
        calDataDivPD(i) = calDataSubtracted(i)/(PD(i)*2);
    end
    calibrationCoeffs = calDataDivPD;
end
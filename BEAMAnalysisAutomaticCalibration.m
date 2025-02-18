function BEAMAnalysisAutomaticCalibration(fileName)
    %% Import Data
    importedData = importdata(fileName);
    fileName = extractBefore(fileName, strfind(fileName, '_17'));

    %% Split into calibraiton data and test data then save
    [calibrationDataRaw, testDataRaw] = splitBEAMData(importedData);
    
    % Save to preproccesed folder
    save(strcat('Data/Preprocessed/', fileName, '.mat'), "calibrationDataRaw", "testDataRaw")
    
    %% Get calibration coeffs and save
    
    calibrationCoeffs = getCalibrationCoeffs(calibrationDataRaw);
    
    save(strcat('Data/Coefficients/', fileName, '.mat'), "calibrationCoeffs")
    
    %% Center Data
    testDataCentered = centerData(testDataRaw, calibrationCoeffs);
    
%     %% Apply Calibration
%     testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);
% 
%     testDataDetrended = detrendBEAMData(testDataCalibrated)
%     
%     %% Filter Data
%     testDataFiltered = filterBEAMData(testDataDetrended);
    
    %% Check Calibration and Centering, then Detrend Data
    close all
    [testDataCalibrated, testDataDetrended,testDataFiltered, calibrationCoeffs] = manualCalibrationBEAM(testDataCentered, calibrationCoeffs);
    
    %% Save Processed Data
    save(strcat('Data/Processed/', fileName, '.mat'), "testDataCentered", "testDataCalibrated", "testDataFiltered", "testDataDetrended")
    
    
    %% Subtract Left from Right
    testDataFinal = getFinalData(testDataDetrended);
    
    %% Subracted Data
    save(strcat('Data/Subracted/', fileName, '.mat'), "testDataFinal")
    
    %% Locate Deviations
    threshold = 10;
    deviations = calculateDeviations(testDataFinal, threshold);
    if (deviations.X.startAndEnds(1,1)) ~= 0
        deviations.time = sum(deviations.X.lengths(:,2));
        deviations.percentage = (deviations.time/max(testDataFinal.time))*100;
        deviations.maxSize = max(deviations.X.magnitude(:,1));
        deviations.meanSize = mean(deviations.X.magnitude(:,1));
        deviations.medianSize = median(deviations.X.magnitude(:,1))
        deviations.number = deviations.X.number;
    else
        deviations.time = 0;
        deviations.percentage = 0;
        deviations.maxSize = 0;
        deviations.meanSize = 0;
        deviations.medianSize = 0;
        deviations.number = 0;
        disp ("No Deviations")
    end
    
    save(strcat('Data/Metrics/', fileName, '.mat'), "threshold", "deviations")
        
    %% Save all data to one file
    save(strcat('Data/Final/', fileName, '.mat'), '-regexp', '^(?!(importedData|threshold)$).')
end









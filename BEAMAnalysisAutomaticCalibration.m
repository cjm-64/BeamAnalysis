function BEAMAnalysisAutomaticCalibration(fileName)
    %% Import Data
    importedData = importdata(fileName);
    fileName = extractBefore(fileName, strfind(fileName, '_17'));

    %% Split into calibraiton data and test data then save
    [calibrationDataRaw, testDataRaw] = splitBEAMData(importedData);
    
    % Save to preproccesed folder
    save(strcat('Data/Preprocessed/', fileName, '.mat'), "calibrationDataRaw", "testDataRaw")
    
    %% Get calibration coeffs and save
    offsets = zeros(5,6);
    [calibrationCoeffs, offsets] = getCalibrationCoeffs(calibrationDataRaw, offsets, 1);
    
    save(strcat('Data/Coefficients/', fileName, '.mat'), "calibrationCoeffs", "offsets")
    
    %% Center Data
    testDataCentered = centerData(testDataRaw);
    
    %% Apply Calibration
    testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);
    
    %% Filter Data
    testDataFiltered = filterBEAMData(testDataCalibrated);
    
    %% Check Calibration and Centering, then Detrend Data
    close all
    [testDataDetrended, calibrationCoeffs] = manualCalibrationBEAM(testDataCentered, calibrationCoeffs);
    
    %% Save Processed Data
    save(strcat('Data/Processed/', fileName, '.mat'), "testDataCentered", "testDataCalibrated", "testDataFiltered", "testDataDetrended")
    
    
    %% Subtract Left from Right
    testDataFinal = getFinalData(testDataDetrended);
    
    %% Subracted Data
    save(strcat('Data/Subracted/', fileName, '.mat'), "testDataFinal")
    
    %% Locate Deviations
    threshold = 10;
    deviations = calculateDeviations(testDataFinal, threshold);
    if ~isnan(deviations.X.startAndEnds(1,1)) 
        deviations.time = sum(deviations.X.lengths(:,2));
        deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100;
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
        
    %% Save all data to one file
    save(strcat('Data/Final/', fileName, '.mat'), '-regexp', '^(?!(importedData|threshold)$).')
end









function [calibrationDataRaw, testDataRaw] = splitBEAMData(rawData, fileName)
    
    numericData = table2array(rawData(:,2:6));

    %% Find where to split
    [headers, headerLocs] = getHeaders(rawData.Header);
    headerLocs(length(headerLocs) + 1) = size(numericData, 1);

    %% Split into calibraiton data and test data
    % Data Organization [RightCal_5PD_RightEye_x, RightCal_5PD_LeftEye_x, R10Rx, R10Lx, R15Rx, R15Lx, L5Rx, L5Lx, L10Rx, L10Lx, L15Rx, L15Lx]
    calibrationDataRaw = getCalData(numericData, headerLocs);
    
    % Data Organization [RightEyeX LeftEyeX]
    testDataRaw = getTestData(numericData, headerLocs(7), headerLocs(8));
    testDataRaw.time = getTime(headers, headerLocs(8)-(headerLocs(7)-1));

    %% Save to preproccesed folder
    save(strcat('Data/Preprocessed/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "calibrationDataRaw", "testDataRaw")
    

end
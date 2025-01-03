function [calibrationDataRaw, testDataRaw] = splitBEAMData(rawData)
    
%     numericData = table2array(rawData(:,2:size(rawData,2)));
    numericData = rawData.data;
    headerCol = rawData.textdata(:,1);
    %% Find where to split
    [headers, headerLocs] = getHeaders(rawData.textdata(:,1));
    headerLocs(length(headerLocs) + 1) = size(numericData, 1);

    %% Split into calibraiton data and test data
    % Data Organization [RightCal_5PD_RightEye_x, RightCal_5PD_LeftEye_x, R10Rx, R10Lx, R15Rx, R15Lx, L5Rx, L5Lx, L10Rx, L10Lx, L15Rx, L15Lx]
    calibrationDataRaw = getCalData(numericData, headerLocs);
    
    % Data Organization [RightEyeX LeftEyeX]
    testDataRaw = getTestData(numericData, headerLocs(7), headerLocs(8));
    testDataRaw.time = getTime(headers, headerLocs(8)-(headerLocs(7)-1));
    testDataRaw.fps = round(length(testDataRaw.time)/(max(testDataRaw.time)));

    %% Remove first and last 2 minutes
%     testDataRaw = clipRawData(testDataRaw);
    
    %%
    disp("Go split")

end
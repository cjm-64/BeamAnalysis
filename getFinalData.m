function testDataFinal = getFinalData(testDataCalibrated, fileName)
   
    directions = fieldnames(testDataCalibrated.rightEye);
    for dir = 1:numel(directions)
        testDataFinal.(directions{dir}) = testDataCalibrated.rightEye.(directions{dir}) + testDataCalibrated.leftEye.(directions{dir});
    end
    testDataFinal.time = testDataCalibrated.time;


    %% Save to processed folder
    save(strcat('Data/Processed/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "testDataFinal")
end
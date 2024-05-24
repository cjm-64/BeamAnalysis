function testDataFinal = getFinalData(testDataCalibrated, fileName)
   
    directions = fieldnames(testDataCalibrated.rightEye);
    for dir = 1:numel(directions)        
        if any(strcmp(directions(dir), ["Radius", "Found"]))
            continue;
        else
            testDataFinal.(directions{dir}) = testDataCalibrated.rightEye.(directions{dir}) + testDataCalibrated.leftEye.(directions{dir});
        end
    end
    testDataFinal.time = testDataCalibrated.time;
    testDataFinal.fps = round(length(testDataFinal.time)/(90*60));


    %% Save to processed folder
    save(strcat('Data/Processed/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "testDataFinal")
end

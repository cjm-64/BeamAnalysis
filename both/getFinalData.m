function testDataFinal = getFinalData(testDataCalibrated)
   
    directions = fieldnames(testDataCalibrated.rightEye);
    for dir = 1:numel(directions)        
        if any(strcmp(directions(dir), ["Radius", "Found"]))
            continue;
        else
            testDataFinal.(directions{dir}) = abs(abs(testDataCalibrated.rightEye.(directions{dir})) - abs(testDataCalibrated.leftEye.(directions{dir})));
        end
    end
    testDataFinal.time = testDataCalibrated.time;
    testDataFinal.fps = round(length(testDataFinal.time)/(max(testDataCalibrated.time)));
    
end

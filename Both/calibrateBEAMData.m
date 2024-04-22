function testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs, fileName)
    
    names = fieldnames(testDataCentered);
    for name = 1:numel(names)
        disp(name)
        if names(name) == "time"
            testDataCalibrated.time = testDataCentered.time;
            continue;
        else
            directions = fieldnames(testDataCentered.(names{name}));
            for dir = 1:numel(directions)
                disp(dir)
                testDataCalibrated.(names{name}).(directions{dir}) = testDataCentered.(names{name}).(directions{dir})./calibrationCoeffs.(names{name});
            end
        end
    end

    
    %% Save to filtered folder
    save(strcat('Data/Calibrated/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "testDataCentered")

end
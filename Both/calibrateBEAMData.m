function testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs)
    
    names = fieldnames(testDataCentered);
    for name = 1:numel(names)
        if names(name) == "time"
            testDataCalibrated.time = testDataCentered.time;
        else
            directions = fieldnames(testDataCentered.(names{name}));
            for dir = 1:numel(directions)
                testDataCalibrated.(names{name}).(directions{dir}) = testDataCentered.(names{name}).(directions{dir})./calibrationCoeffs.(names{name});
            end
        end
    end


end
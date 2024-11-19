function testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs)
    
    names = fieldnames(testDataCentered);
    for name = 1:numel(names)
        if names(name) == "time" || names(name) == "fps"
            testDataCalibrated.(names{name}) = testDataCentered.(names{name});
        else
            directions = fieldnames(testDataCentered.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    testDataCalibrated.(names{name}).(directions{dir}) = testDataCentered.(names{name}).(directions{dir});
                else
                    testDataCalibrated.(names{name}).(directions{dir}) = testDataCentered.(names{name}).(directions{dir})./calibrationCoeffs.(names{name}).value;
                end                
            end
        end
    end
    disp("Go calibrated")

end
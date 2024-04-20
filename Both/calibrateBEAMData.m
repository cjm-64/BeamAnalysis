function testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs)
    
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
                part1 = testDataCentered.(names{name}).(directions{dir});
                part2 = calibrationCoeffs.(names{name});
                testDataCalibrated.(names{name}).(directions{dir}) = testDataCentered.(names{name}).(directions{dir})./calibrationCoeffs.(names{name});
            end
        end
    end


end
function testDataFiltered = filterBEAMData(testDataCalibrated)
        
    %% Filter test data
    names = fieldnames(testDataCalibrated);
    for name = 1:numel(names)
        if names(name) == "time"|| names(name) == "fps"
            testDataFiltered.(names{name}) = testDataCalibrated.(names{name});
        else
            directions = fieldnames(testDataCalibrated.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    testDataFiltered.(names{name}).(directions{dir}) = testDataCalibrated.(names{name}).(directions{dir});
                else
                    testDataFiltered.(names{name}).(directions{dir}) = filterBEAMTestData(testDataCalibrated.(names{name}).(directions{dir}), testDataCalibrated.(names{name}).Radius, testDataCalibrated.(names{name}).Found, testDataCalibrated.fps, 5);
                end
            end
        end
    end
    disp("Go filtered")
end
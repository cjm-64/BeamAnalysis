function [calibrationDataFiltered, testDataFiltered] = filterBEAMData(calibrationDataRaw, testDataRaw)
    calibrationDataFiltered = filterBEAMCalData(calibrationDataRaw);
    
    names = fieldnames(testDataRaw);
    for name = 1:numel(names)
        if names(name) == "time"
            testDataFiltered.time = testDataRaw.time;
        else
            testDataFiltered.(names{name}) = filterBEAMTestData(testDataRaw.(names{name}), 35);
        end
    end
end
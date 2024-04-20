function [calibrationDataFiltered, testDataFiltered] = filterBEAMData(calibrationDataRaw, testDataRaw, fileName)
    
    %% Filter calibration Data
    calibrationDataFiltered = filterBEAMCalData(calibrationDataRaw);
    
    %% Filter test data
    names = fieldnames(testDataRaw);
    for name = 1:numel(names)
        if names(name) == "time"
            testDataFiltered.time = testDataRaw.time;
        else
            directions = fieldnames(testDataRaw.(names{name}));
            for dir = 1:numel(directions)
                testDataFiltered.(names{name}).(directions{dir}) = filterBEAMTestData(testDataRaw.(names{name}).(directions{dir}), 35);
            end
        end
    end
    
    %% Save to filtered folder
    save(strcat('Data/Filtered/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "calibrationDataFiltered", "testDataFiltered")

end
function testDataFiltered = filterBEAMData(testDataCalibrated, fileName)
        
    %% Filter test data
    names = fieldnames(testDataCalibrated);
    for name = 1:numel(names)
        if names(name) == "time"
            testDataFiltered.time = testDataCalibrated.time;
        else
            directions = fieldnames(testDataCalibrated.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    testDataFiltered.(names{name}).(directions{dir}) = testDataCalibrated.(names{name}).(directions{dir});
                else
                    testDataFiltered.(names{name}).(directions{dir}) = filterBEAMTestData(testDataCalibrated.(names{name}).(directions{dir}), testDataCalibrated.(names{name}).Radius, testDataCalibrated.(names{name}).Found, 2);
                    
%                     figure()
%                     plot(testDataCalibrated.(names{name}).(directions{dir}), 'r')
%                     hold on
%                     plot(testDataFiltered.(names{name}).(directions{dir}), 'b')
%                     title(strcat(names(name), directions(dir)))
%                     legend('Raw', 'Filtered')
                end
            end
        end
    end
    
    %% Save to filtered folder
    save(strcat('Data/Filtered/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "testDataFiltered")

end
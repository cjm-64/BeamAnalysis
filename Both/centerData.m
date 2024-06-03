function testDataCentered = centerData(testDataRaw, fileName)
   
    %% Center test data
    names = fieldnames(testDataRaw);
    for name = 1:numel(names)
        if names(name) == "time"
            testDataCentered.time = testDataRaw.time;
        else
            directions = fieldnames(testDataRaw.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    testDataCentered.(names{name}).(directions{dir}) = testDataRaw.(names{name}).(directions{dir});
                else
                    testDataCentered.(names{name}).(directions{dir}) = testDataRaw.(names{name}).(directions{dir}) - trimmean(testDataRaw.(names{name}).(directions{dir}), 65);
                end                
            end
        end
    end
    
end

%     centeredDataOld = [filteredData(:,1)-mean(filteredData(1:701,1)), filteredData(:,2)-mean(filteredData(1:701,2))];
%     centeredData = filteredData-trimmean(filteredData,65);
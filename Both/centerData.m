function testDataCentered = centerData(testDataFiltered)
   
    %% Center test data
    names = fieldnames(testDataFiltered);
    for name = 1:numel(names)
        if names(name) == "time"
            testDataCentered.time = testDataFiltered.time;
        else
            directions = fieldnames(testDataFiltered.(names{name}));
            for dir = 1:numel(directions)
                testDataCentered.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir}) - trimmean(testDataFiltered.(names{name}).(directions{dir}), 65);
            end
        end
    end

    
end

%     centeredDataOld = [filteredData(:,1)-mean(filteredData(1:701,1)), filteredData(:,2)-mean(filteredData(1:701,2))];
%     centeredData = filteredData-trimmean(filteredData,65);
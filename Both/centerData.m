function testDataCentered = centerData(testDataRaw, calibrationCoeffs)
   
    %% Center test data
    names = fieldnames(testDataRaw);
    for name = 1:numel(names)
        if names(name) == "time" || names(name) == "fps"
            testDataCentered.(names{name}) = testDataRaw.(names{name});
        else
            directions = fieldnames(testDataRaw.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    % These values do not get centered
                    testDataCentered.(names{name}).(directions{dir}) = testDataRaw.(names{name}).(directions{dir});
                elseif directions(dir) == "X" && calibrationCoeffs.(names{name}).isValid
                    % If the calibration for that eye was valid we can
                    % subtract out the calculated centered position
                    testDataCentered.(names{name}).(directions{dir}) = testDataRaw.(names{name}).(directions{dir}) - calibrationCoeffs.(names{name}).offset;
                else
                    % If the calibration was not valid, subtract out the
                    % median of the dataset
                    testDataCentered.(names{name}).(directions{dir}) = testDataRaw.(names{name}).(directions{dir}) - median(testDataRaw.(names{name}).(directions{dir}));
                end                
            end
        end
    end
    disp("Go centered")
    
end

% centeredDataOld = [filteredData(:,1)-mean(filteredData(1:701,1)), filteredData(:,2)-mean(filteredData(1:701,2))];
% centeredData = filteredData-trimmean(filteredData,65);
% testDataCentered.(names{name}).(directions{dir}) = testDataRaw.(names{name}).(directions{dir}) - trimmean(testDataRaw.(names{name}).(directions{dir}), 65);
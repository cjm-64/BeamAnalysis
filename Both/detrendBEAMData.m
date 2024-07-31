function testDataDetrended = detrendBEAMData(testDataFiltered)
        
    %% Filter test data
    names = fieldnames(testDataFiltered);
    for name = 1:numel(names)
        if names(name) == "time"|| names(name) == "fps"
            testDataDetrended.(names{name}) = testDataFiltered.(names{name});
        else
            directions = fieldnames(testDataFiltered.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir});
                else                
                    beta = testDataFiltered.time\testDataFiltered.(names{name}).(directions{dir});
                    detrendLine = beta*testDataFiltered.time;
                    testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir}) - detrendLine;                
                end
            end
        end
    end
    disp("Go detrend")
end
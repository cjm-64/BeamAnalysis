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
                    fit = polyfit(testDataFiltered.time, testDataFiltered.(names{name}).(directions{dir}), 1);
                    if abs(fit(1)) > 0.005
                        % if slope is high then we need to detrend it
                        testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir}) - polyval(fit, testDataFiltered.time);
                    else
                        if abs(fit(2)) < 12
                            % low slope & low intercept means it is flat
                            % and around 0 and can be detrended
                            testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir}) - polyval(fit, testDataFiltered.time);
                        else
                            warning(append('testDataFiltered.',names{name},'.',directions{dir},' detrend out of limits, detrend not performed'))
                            testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir});
                        end
                    end
                end
            end
        end
    end
    disp("Go detrend")
end




%% Old method below in case it needs to be referenced
% beta = testDataFiltered.time\testDataFiltered.(names{name}).(directions{dir})
% if abs(beta) > 0.0070
%     % Detrend is an outlier, don't detrend as it can
%     % cause issues. Limited was determined
%     % experimentally by calculating beta of all files
%     % then looking at mean += 3*stdev
%     warning(append('testDataFiltered.',names{name},'.',directions{dir},' detrend out of limits, detrend not performed'))
%     testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir});
% else
%     detrendLine = beta*testDataFiltered.time;
%     testDataDetrended.(names{name}).(directions{dir}) = testDataFiltered.(names{name}).(directions{dir}) - detrendLine;    
% end
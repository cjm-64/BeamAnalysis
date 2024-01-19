function [headers, headerLocations] = getHeaders(headerArray)
    temp = headerArray;
    dummyNames = strings(7,1);
    dummyLocations = zeros(7,1);
    location = 1;
    for i = 1:length(temp)
        if ~strcmp(temp(i), " ")
            dummyNames(location) = temp(i);
            dummyLocations(location) = i;
            location = location + 1;
        end
    end
    headers = dummyNames;
    headerLocations = dummyLocations;
end

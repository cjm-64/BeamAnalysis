function [headerNames, headerLocations] = getHeaders(headerArray)
    emptyCells = cellfun(@isempty,headerArray(2:end));
    headerLocations = find(~emptyCells)+1;
    headerNames = cellfun(@string, headerArray(headerLocations));
end
%     temp = headerArray;
%     dummyNames = strings(7,1);
%     dummyLocations = zeros(7,1);
%     location = 1;
%     for i = 1:length(temp)
%         if ~strcmp(temp(i), " ")
%             dummyNames(location) = temp(i);
%             dummyLocations(location) = i;
%             location = location + 1;
%         end
%     end
%     headers = dummyNames;
%     headerLocations = dummyLocations;
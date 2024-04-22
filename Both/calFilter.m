function filteredData = calFilter(rawData)
    rawData(isoutlier(rawData, 1)) = median(rawData);
    filteredData = rawData;
end
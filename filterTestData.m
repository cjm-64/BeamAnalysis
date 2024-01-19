function filteredData = filterTestData(rawData, windowSize)
    dummy = movmedian(rawData, windowSize, 1,'Endpoints', 'shrink');
    [b, a] = butter(3, 1/35);
    filteredData = filtfilt(b, a, dummy);
end
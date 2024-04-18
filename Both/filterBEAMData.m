function filteredData = filterBEAMData(rawData, windowSize)
    %prefiltering to remove gross noise
    dummy = movmedian(rawData, windowSize, 1,'Endpoints', 'shrink');
    [b, a] = butter(3, 1/35);
    dummy = filtfilt(b, a, dummy);
%     filteredData = dummy;

    % Identify and remove outliers
    dummy(isoutlier(dummy, 1)) = NaN;
    
    % Replace NaNs with interpolated data
    filteredData = fillmissing(dummy,'linear', 1);
end

function filteredData = filterBEAMTestData(rawData, radius, found, seconds)
    
%     figure()
%     subplot(4, 1, 1)
%     plot(rawData)

    
    % Find Outliers, where rawData >45, radius not found, or eye not found
    uf = (abs(rawData)>45 | radius==0 | ~found);
    uf = logical(uf);
    
    % Replace Outliers with Median Right Eye
    dummy = rawData;
    dummy(uf) = NaN;
    dummy = fillmissing(dummy, 'previous');
%     subplot(4, 1, 2)
%     plot(dummy)

    % Filter
    
%     [b, a] = butter(5, 2/35);
%     dummy = filtfilt(b, a, dummy);

    dummy = lowpass(dummy, 2, 71);
%     subplot(4, 1, 3)
%     plot(dummy)
    dummy = movmedian(dummy, seconds*71, 1,'Endpoints', 'shrink');
%     subplot(4, 1, 4)
%     plot(dummy)

    filteredData = dummy;

    


end


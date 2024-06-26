function filteredData = filterBEAMTestData(rawData, radius, found, fs, seconds)
    
    % Find Outliers, where rawData >45, radius not found, or eye not found
    uf = (abs(rawData)>45 | radius==0 | ~found);
    uf = logical(uf);
    
    % Replace Outliers with previous 
    dummy = rawData;
    dummy(uf) = NaN;
    dummy = fillmissing(dummy, 'previous');
    
    % Low Pass Filter, cutoff of 5 Hz
    dummy = lowpass(dummy, 5, fs);

    % Moving median to smooth signal, windowsize based on seconds of data
    dummy = movmedian(dummy, seconds*fs, 1,'Endpoints', 'shrink');


    filteredData = dummy;

    


end


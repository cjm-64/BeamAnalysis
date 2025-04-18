function filteredData = filterBEAMTestData(rawData, radius, found, fs, seconds)
    
    % Find Outliers, where rawData >45, radius not found, or eye not found
%     uf = (radius==0 | ~found | abs([0; diff(rawData)])>15);
    uf = (abs(rawData) > 60 | radius==0 | ~found | abs([0; diff([0; diff(rawData)])])>5);
    uf = logical(uf);
    
    % Replace Outliers with previous 
    dummy = rawData;
    dummy(uf) = NaN;
    if isempty(uf)
        % Do nothing
    elseif uf(1) == 1
        dummy(1) = median(dummy, 'omitnan');
    end
    dummy = fillmissing(dummy, 'previous');
    
    % Low Pass Filter, cutoff of 5 Hz
    [b, a] = butter(4, 5/ceil(fs/2), "low");
    dummy = filtfilt(b, a, dummy);

    % Moving median to smooth signal, windowsize based on seconds of data
    dummy = movmedian(dummy, seconds*fs, 1,'Endpoints', 'shrink');


    filteredData = dummy;

    


end


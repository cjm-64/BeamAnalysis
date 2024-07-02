function deviations = getDeviations(data, threshold, fps)
    deviationCount = 1;
    isDeviated = false;
    deviations = NaN(2,1);
    frames2sec = 3*fps;
    for i = 1:size(data, 1)
        % Data is deviated (above threshold)
        if data(i) > threshold
            % Is data already deviated 
            if isDeviated 
                % Is the next datapoint deviated
                % If not end index val recorded 
                if i == size(data, 1) || ~(data(i+1) > threshold) 
                    deviations(2, deviationCount) = i;
                    deviationCount = deviationCount + 1;
                    isDeviated = false;
                    if (deviations(2, deviationCount-1) - deviations(1, deviationCount-1) < frames2sec)
                        deviationCount = deviationCount - 1;
                        deviations(:, deviationCount) = NaN;
                    end
                end
            % First instance of deviation (start)
            else
                % Start/End case where only 1 frame is deviated
                if i == size(data, 1) || ~(data(i+1) > threshold)                    
                    deviations(1, deviationCount) = i;
                    deviations(2, deviationCount) = i;
                    deviationCount = deviationCount + 1;
                % Start case
                else
                    deviations(1, deviationCount) = i;
                    isDeviated = true;                    
                end
            end
        end
    end
    if size(deviations, 2) > 1 && isnan(deviations(1, size(deviations, 2)))
        deviations = deviations(:, 1:size(deviations, 2)-1);
    end
end

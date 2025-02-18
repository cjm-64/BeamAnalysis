function deviations = getDeviations(data, threshold, fps, seconds)
    deviationCount = 1;
    isDeviated = false;
    deviations = zeros(2,1);
    frames2sec = seconds*fps;
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
                        % Is the deviation < 10 seconds
                        deviationCount = deviationCount - 1;
                        deviations(:, deviationCount) = 0;
                    end
                end
            % First instance of deviation (start)
            else
                % Start/End case where only 1 frame is deviated
                % Do not include deviation
                if i == size(data, 1) || ~(data(i+1) > threshold)
                    isDeviated = false;                
                % Start case
                else
                    deviations(1, deviationCount) = i;
                    isDeviated = true;                    
                end
            end
        end
    end
    if size(deviations, 2) > 1 && deviations(1, size(deviations, 2)) == 0
        deviations = deviations(:, 1:size(deviations, 2)-1);
    end
end

function calibrationLimits = CoG_getCalibrationLimits(calibrationRaw)
    
    calibrationLimits = zeros(2,size(calibrationRaw, 2));

    fig1 = figure();
    line1 = plot(calibrationRaw(:,1));
    startXLine = xline(1, 'g');
    endXLine = xline(size(calibrationRaw(:,1), 1), 'm');
    for i = 1:size(calibrationRaw, 2)
    
        lineLocation = 1;
        startAndEndLocations = [1 93];
        button = 0;
    
        set(line1, 'YData', calibrationRaw(:,i))
        while button <= 2
            drawnow
            [x, y, button] = ginput(1);
            [breakflag, lineLocation, startAndEndLocations] = CoG_buttonPressed(x, button, lineLocation, startAndEndLocations, startXLine, endXLine);
            breakflag
            button
            if breakflag == true
                breakflag = false;
                break;
            end
        end
        set(startXLine, 'Value', 1)
        set(endXLine, 'Value', size(calibrationRaw(:,1), 1))
        calibrationLimits(:,i) = startAndEndLocations;
    end
    close 1
    
    calibrationLimits(1,:) = ceil(calibrationLimits(1,:));
    calibrationLimits(2,:) = floor(calibrationLimits(2,:));
end

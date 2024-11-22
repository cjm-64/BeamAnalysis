function [testDataDetrended, xLines, calibrationCoeffs] = manualCenteringBEAM(testDataDetrended, xLines, calibrationCoeffs)
    data = [testDataDetrended.rightEye.X, testDataDetrended.leftEye.X, zeros(size(testDataDetrended.rightEye.X, 1), 1)];
    

    if ~ishandle(1)
        close all
        set(0, 'units', 'pixels')
        screenSizePixel = get(0,'screensize');
        centeringFigure = figure("Position",[screenSizePixel(3)/2 + 2 42 ...
            screenSizePixel(3)/2 - 2 screenSizePixel(4)-126]);
    else
        clf
    end

    while ishandle(1)   
        data(:,3) = abs(data(:,1)) - abs(data(:,2));    

        subplot(3, 1, 1)
        totalPlotData = plot(data(:,3));
        totalZeroLine = yline(0,'k');
        title('Right - Left')
        
        subplot(3, 1, 2)
%         rightEyeData = plot(abs(data(:,1)));
        rightEyeData = plot(data(:,1));
        rightZeroLine = yline(0,'k');
        rightEyeStartLine = xline(xLines(1, 1), 'g');
        rightEyeEndLine = xline(xLines(1, 2), 'm');
        title('Right')
        
        subplot(3, 1, 3)
%         leftEyeData = plot(abs(data(:,2)));
        leftEyeData = plot(data(:,2));
        leftZeroLine = yline(0,'k');
        leftEyeStartLine = xline(xLines(2, 1), 'g');
        leftEyeEndLine = xline(xLines(2, 2), 'm');
        title('Left')        
        
        [x, ~, button] = ginput(1);        
        if button == 2
            % Break if middle mouse clicked
            break;
        else
            if contains(gca().Title.String, '-')
                % do nothing
            else
                if contains(gca().Title.String, 'Right')
                    xLines(1,:) = setCenterWindowBoundaries(x, xLines(1,:), button);
                    calibrationCoeffs.rightEye.manualOffset = mean(data(round(xLines(1,1)):round(xLines(1,2)),1));
                    data(:,1) = data(:,1) - calibrationCoeffs.rightEye.manualOffset;
                else
                    xLines(2,:) = setCenterWindowBoundaries(x, xLines(2,:), button);
                    calibrationCoeffs.leftEye.manualOffset = mean(data(round(xLines(2,1)):round(xLines(2,2)),2));
                    data(:,2) = data(:,2) - calibrationCoeffs.leftEye.manualOffset;
                end
            end            
        end    
    end
    
    testDataDetrended.rightEye.X = data(:,1);
    testDataDetrended.leftEye.X = data(:,2);
end


function [testDataFiltered, xLines] = manualCenteringBEAM(testDataFiltered, xLines)
    data = [testDataFiltered.rightEye.X, testDataFiltered.leftEye.X];
    

    if ~ishandle(1)
        close all
        centeringFigure = figure("Position",[1722 42 1718 1314]);
    else
        clf
    end

    while ishandle(1)
        data(:,1) = data(:,1) - mean(data(round(xLines(1,1)):round(xLines(1,2)),1));
        data(:,2) = data(:,2) - mean(data(round(xLines(2,1)):round(xLines(2,2)),2));
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
                else
                    xLines(2,:) = setCenterWindowBoundaries(x, xLines(2,:), button);
                end
            end
        end
    
    end
    
    testDataFiltered.rightEye.X = data(:,1);
    testDataFiltered.leftEye.X = data(:,2);
%     close(1)
end


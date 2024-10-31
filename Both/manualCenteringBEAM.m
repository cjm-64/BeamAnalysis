function testDataFiltered = manualCenteringBEAM(testDataFiltered)
    data = [testDataFiltered.rightEye.X, testDataFiltered.leftEye.X];
    xLines = [1, size(data(:,1), 1); 1, size(data(:,2), 1)];

    close all
    fig1 = figure("Position",[1722 42 1718 1314]);
    while ishandle(1)
        data(:,3) = abs(data(:,1)) - abs(data(:,2));
        subplot(3, 1, 1)
        totalPlotData = plot(data(:,3));
        totalZeroLine = yline(0,'k');
        title('Right - Left')
        
        subplot(3, 1, 2)
        rightEyeData = plot(data(:,1));
        rightZeroLine = yline(0,'k');
        rightEyeStartLine = xline(xLines(1, 1), 'g');
        rightEyeEndLine = xline(xLines(1, 2), 'm');
        title('Right')
        
        subplot(3, 1, 3)
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
    
        data(:,1) = data(:,1) - mean(data(xLines(1,1):xLines(1,2),1));
        data(:,2) = data(:,2) - mean(data(xLines(2,1):xLines(2,2),2));
    
    end
    
    testDataFiltered.rightEye.X = data(:,1);
    testDataFiltered.leftEye.X = data(:,2);
    close(1)
end


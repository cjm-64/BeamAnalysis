function [testDataDetrended, calibrationCoeffs] = manualCalibrationBEAM(testDataCentered, calibrationCoeffs)
    
    set(0, 'units', 'pixels')
    screenSizePixel = get(0,'screensize');
    
    close all
    calibrationFigure = figure("Position",[screenSizePixel(3)/2 + 2 42 ...
        screenSizePixel(3)/2 - 2 screenSizePixel(4)-126]);
    
    xLines = [1, size(testDataCentered.rightEye.X, 1); 1, size(testDataCentered.leftEye.X, 1)];

    while ishandle(1)
        clf
%         testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);
%         testDataFiltered = filterBEAMData(testDataCalibrated);
%         testDataDetrended = detrendBEAMData(testDataFiltered);
        [testDataDetrended, xLines] = manualCenteringBEAM(detrendBEAMData(filterBEAMData(calibrateBEAMData(testDataCentered, calibrationCoeffs))), xLines, calibrationCoeffs);
%         [testDataDetrended, xLines] = manualCenteringBEAM(testDataDetrended, xLines, calibrationCoeffs);

        calibrationCoeffs.rightEye.value
        calibrationCoeffs.leftEye.value
    
        subplot(2,1,1)
        plot(abs(testDataDetrended.rightEye.X), 'r')
        hold on
        plot(abs(testDataDetrended.leftEye.X), 'g')
        yline(0,'k')
        legend('Right', 'Left')
        hold off
        
        subplot(2, 1, 2)
        plot(abs(testDataDetrended.rightEye.X) - abs(testDataDetrended.leftEye.X))
        yline(10, '--r')
        yline(-10, '--r')
        yline(0, 'k')
        ylim([-50,50])
    
        rCoeff = input("Right eye coeff: ");
        if ~isempty(rCoeff)
            calibrationCoeffs.rightEye.value = rCoeff;
        end
    
        lCoeff = input("Left eye coeff: ");
        if ~isempty(lCoeff)
            calibrationCoeffs.leftEye.value = lCoeff;
        end
        clear rCoeff lCoeff;
    
    end
end

%         [testDataDetrended, xLines] = manualCenteringBEAM(detrendBEAMData(testDataFiltered), xLines);

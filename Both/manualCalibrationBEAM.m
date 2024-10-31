function [testDataCentered, testDataCalibrated, testDataFiltered, calibrationCoeffs] = manualCalibrationBEAM(testDataCentered, calibrationCoeffs)
    figure("Position",[1722 42 1718 1314])
    
    while ishandle(1)
        calibrationCoeffs
    
        clf
        testDataCalibrated = calibrateBEAMData(testDataCentered, calibrationCoeffs);
        testDataFiltered = filterBEAMData(testDataCalibrated); 
        testDataDetrended = detrendBEAMData(testDataFiltered);
%         testDataFinal = getFinalData(testDataDetrended);
%     
%         threshold = 10;
%         deviations = calculateDeviations(testDataFinal, threshold);
%         if ~isnan(deviations.X.startAndEnds(1,1)) 
%             deviations.percentage = (sum(deviations.X.lengths(:,2))/max(testDataFinal.time))*100;
%             deviations.meanSize = mean(deviations.X.magnitude(:,1));
%             deviations.medianSize = median(deviations.X.magnitude(:,1))
%         else
%             deviations.percentage = 0;
%             deviations.meanSize = 0;
%             deviations.medianSize = 0;
%             disp ("No Deviations")
%         end
%         
        subplot(2,1,1)
        plot(abs(testDataDetrended.rightEye.X), 'r')
        hold on
        plot(abs(testDataDetrended.leftEye.X), 'g')
        yline(0,'k')
        legend('Right', 'Left')
        
        subplot(2, 1, 2)
        plot(abs(testDataDetrended.rightEye.X) - abs(testDataDetrended.leftEye.X))
        yline(10, '--r')
        yline(-10, '--r')
        yline(0, 'k')
        ylim([-50,50])

        rCoeff = input("Right eye coeff: ");
        if ~isempty(rCoeff)
            calibrationCoeffs.rightEye = rCoeff;
        end

        lCoeff = input("Left eye coeff: ");
        if ~isempty(lCoeff)
            calibrationCoeffs.leftEye = lCoeff;
        end
        clear rCoeff lCoeff;
    end

end
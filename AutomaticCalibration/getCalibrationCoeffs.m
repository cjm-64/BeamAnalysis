function [calibrationCoeffs, offsets] = getCalibrationCoeffs(calibrationDataRaw,offsets, fileNum)
    
    %% Filter calibration Data
    calibrationDataFiltered = filterBEAMCalData(calibrationDataRaw);

    %% Calculate Coeffs
    PD = [5 10 15];
    rightCoeffs = zeros(3, 1);
    leftCoeffs = zeros(3, 1);
    
    rotationAmounts = fieldnames(calibrationDataFiltered.rightCal);
    for amt = 1:numel(rotationAmounts)
        eyes = fieldnames(calibrationDataFiltered.rightCal.(rotationAmounts{amt}));
        for eye = 1:numel(eyes)
            right = mean(calibrationDataFiltered.rightCal.(rotationAmounts{amt}).(eyes{eye}).X);
            left = mean(calibrationDataFiltered.leftCal.(rotationAmounts{amt}).(eyes{eye}).X);
            subtracted = right - left;
            target = PD(amt)*2;
            if eye == 1
                rightCoeffs(amt) = subtracted/target;
            else
                leftCoeffs(amt) = subtracted/target;
            end
        end
    end

    if mean(abs(rightCoeffs)) < 0.5 || mean(abs(rightCoeffs)) > 0.9
        warning('Right eye out of bounds')
        if mean(abs(leftCoeffs)) > 0.5 && mean(abs(leftCoeffs)) < 0.9
            calibrationCoeffs.rightEye = mean(abs(leftCoeffs));
        else
            if mean(abs(rightCoeffs)) < 0.5
                calibrationCoeffs.rightEye = 0.5;
            else
                calibrationCoeffs.rightEye = 0.9;
            end
        end
    else
        calibrationCoeffs.rightEye = mean(abs(rightCoeffs));
    end

    if mean(abs(leftCoeffs)) < 0.5 || mean(abs(leftCoeffs)) > 0.9
        warning('Left eye out of bounds')
        if mean(abs(rightCoeffs)) > 0.5 && mean(abs(rightCoeffs)) < 0.9
            calibrationCoeffs.leftEye = mean(abs(rightCoeffs));
        else
            if mean(abs(rightCoeffs)) < 0.5
                calibrationCoeffs.leftEye = 0.5;
            else
                calibrationCoeffs.leftEye = 0.9;
            end
        end
    else
        calibrationCoeffs.leftEye = mean(abs(leftCoeffs));
    end

    offsets = calibrationTests(calibrationDataRaw, calibrationDataFiltered, offsets, fileNum);

    plotRawVSFiltered_cal(calibrationDataRaw, calibrationDataFiltered)

end

    % sides = fieldnames(calibrationDataFiltered);
    % for side = 1:numel(sides)
    %     rotationAmounts = fieldnames(calibrationDataFiltered.(sides{side}));
    %     for amt = 1:numel(rotationAmounts)
    %         right = mean(calibrationDataFiltered.(sides{side}).(rotationAmounts{amt}).rightEye.X);
    %         left = mean(calibrationDataFiltered.(sides{side}).(rotationAmounts{amt}).leftEye.X);
    %         subtracted = right - left;
    %         target = PD(amt)*2;
    %         coeff = subtracted/target;
    %         disp([right;left;subtracted;target;coeff])
    %     end
    % end


% function calibrationCoeffs = getCalibrationCoeffs(calDataRaw)
%     temp = calDataRaw;
%     PD = [5 10 15];
%     calDataMeans = mean(calibrationFilter(temp),1);
%     calDataSubtracted = zeros(length(calDataMeans)/2,1);
% 
%     for i = 1:length(calDataMeans)/2
%         calDataSubtracted(i) = calDataMeans(i) - calDataMeans(i+length(calDataMeans)/2);
%     end
% 
%     calDataDivPD = zeros(length(calDataSubtracted),1);
%     for i = 1:length(PD)
%         calDataDivPD(i) = calDataSubtracted(i)/(PD(i)*2);
%     end
%     calibrationCoeffs = calDataDivPD;
% end
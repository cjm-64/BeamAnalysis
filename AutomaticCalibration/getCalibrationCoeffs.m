function calibrationCoeffs = getCalibrationCoeffs(calibrationDataFiltered, fileName)
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
    calibrationCoeffs.rightEye = mean(abs(rightCoeffs));
    calibrationCoeffs.leftEye = mean(abs(leftCoeffs));

    %% Save to filtered folder
    save(strcat('Data/Coefficients/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "calibrationCoeffs")

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
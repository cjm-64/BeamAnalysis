function calibrationCoeffs = getCalibrationCoeffs(calibrationDataFiltered)
    PD = [5 10 15];
    
    sides = fieldnames(calibrationDataFiltered);
    for side = 1:numel(sides)
        rotationAmounts = fieldnames(calibrationDataFiltered.(sides{side}));
        for amt = 1:numel(rotationAmounts)
            directions = fieldnames(calibrationDataFiltered.(sides{side}).(rotationAmounts{amt}).rightEye);
            for dir = 1:numel(directions)
                right = mean(calibrationDataFiltered.(sides{side}).(rotationAmounts{amt}).rightEye.(directions{dir}));
                left = mean(calibrationDataFiltered.(sides{side}).(rotationAmounts{amt}).leftEye.(directions{dir}));
                subtracted =  right - left;
                divBy = (PD(amt)*2)
                coeff = subtracted/divBy;
                calibrationCoeffs.(sides{side}).(rotationAmounts{amt}).(directions{dir}) = subtracted/(PD(amt)*2);
            end
        end
    end

end


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
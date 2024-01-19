function coefficients = CoG_getCalibrationCoeffs(limits, rawData)
    coeffArray = zeros(1, 3);
    PDs = [5 10 15];
    for i = 1:(size(limits, 2)/2)
        coeffArray(:,i) = (mean(rawData(limits(1,i):limits(2,i),i)) - mean(rawData(limits(1,i+3):limits(2,i+3),i+3)))/(PDs(i)*2);
    end

    coefficients = abs(coeffArray);
end
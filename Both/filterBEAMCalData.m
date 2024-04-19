function calibrationDataFiltered = filterBEAMCalData(calibrationDataRaw)

    calSides = fieldnames(calibrationDataRaw);
    for side = 1:numel(calSides)
        calMags = fieldnames(calibrationDataRaw.(calSides{side}));
        for mag = 1:numel(calMags)
            calEyes = fieldnames(calibrationDataRaw.(calSides{side}).(calMags{mag}));
            for eye = 1:numel(calEyes)
                calAxes = fieldnames(calibrationDataRaw.(calSides{side}).(calMags{mag}).(calEyes{eye}));
                for axis = 1:numel(calAxes)
                    calibrationDataFiltered.(calSides{side}).(calMags{mag}).(calEyes{eye}).(calAxes{axis}) = calFilter(calibrationDataRaw.(calSides{side}).(calMags{mag}).(calEyes{eye}).(calAxes{axis}));
                end
            end
        end
    end


end
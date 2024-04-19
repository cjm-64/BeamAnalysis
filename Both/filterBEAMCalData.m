function calibrationDataFiltered = filterBEAMCalData(calibrationDataRaw)

    calSides = fieldnames(calibrationDataRaw);
    for side = 1:numel(calSides)
        calMags = fieldnames(calibrationDataRaw.(calSides{side}));
        for mag = 1:numel(calMags)
            calEyes = fieldnames(calibrationDataRaw.(calSides{1}).(calMags{mag}));
            for eye = 1:numel(calEyes)
                calAxes = fieldnames(calibrationDataRaw.(calSides{1}).(calMags{1}).(calEyes{eye}));
                for axis = 1:numel(calAxes)
                    calibrationDataFiltered.(calSides{side}).(calMags{mag}).(calEyes{eye}).(calAxes{axis}) = filterBEAMData(calibrationDataRaw.(calSides{side}).(calMags{mag}).(calEyes{eye}).(calAxes{axis}), 35);
                end
            end
        end
    end


end
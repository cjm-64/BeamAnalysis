function plotRawVSFiltered_cal(calibrationDataRaw, calibrationDataFiltered)
    
    calSides = fieldnames(calibrationDataRaw);
    for side = 1:numel(calSides)
        calMags = fieldnames(calibrationDataRaw.(calSides{side}));
        for mag = 1:numel(calMags)
            calEyes = fieldnames(calibrationDataRaw.(calSides{side}).(calMags{mag}));
            for eye = 1:numel(calEyes)
                disp({calSides{side}; calMags{mag}; calEyes{eye}});
                figure()
                plot(calibrationDataRaw.(calSides{side}).(calMags{mag}).(calEyes{eye}).X)
                hold on
                plot(calibrationDataFiltered.(calSides{side}).(calMags{mag}).(calEyes{eye}).X)
                xlabel('Samples')
                ylabel('Pixel')
                title([calSides{side}, ' ', calMags{mag}, ' ', calEyes{eye}])
            end
        end
    end
end
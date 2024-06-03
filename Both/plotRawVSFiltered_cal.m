function plotRawVSFiltered_cal(calibrationDataRaw, calibrationDataFiltered)
    
    plotLoc = 1;
    figure()
    calSides = fieldnames(calibrationDataRaw);
    for side = 1:numel(calSides)
        calMags = fieldnames(calibrationDataRaw.(calSides{side}));
        for mag = 1:numel(calMags)
            calEyes = fieldnames(calibrationDataRaw.(calSides{side}).(calMags{mag}));
            for eye = 1:numel(calEyes)
                subplot(6, 2, plotLoc)
                plot(calibrationDataRaw.(calSides{side}).(calMags{mag}).(calEyes{eye}).X, 'r')
                hold on
                plot(calibrationDataFiltered.(calSides{side}).(calMags{mag}).(calEyes{eye}).X, 'b')
                xlabel('Samples')
                ylabel('Pixel')
                title([calSides{side}, ' ', calMags{mag}, ' ', calEyes{eye}])
                legend('raw', 'filtered')
                plotLoc = plotLoc + 1;
            end
        end
    end
end

function plotCalVSFiltered(raw, filtered)
    
    calSides = fieldnames(raw);
    for side = 1:numel(calSides)
        calMags = fieldnames(raw.(calSides{side}));
        for mag = 1:numel(calMags)
            calEyes = fieldnames(raw.(calSides{side}).(calMags{mag}));
            for eye = 1:numel(calEyes)
                disp({calSides{side}; calMags{mag}; calEyes{eye}})
                figure()
                plot(raw.(calSides{side}).(calMags{mag}).(calEyes{eye}).X)
                hold on
                plot(filtered.(calSides{side}).(calMags{mag}).(calEyes{eye}).X)
            end
        end
    end
end
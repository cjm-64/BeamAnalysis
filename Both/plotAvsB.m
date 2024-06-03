function plotAvsB(firstInput, firstInputName, secondInput, secondInputName)
    
    names = fieldnames(firstInput);
    plotLoc = 1;
    figure()
    for name = 1:numel(names)
        if names(name) == "time"
            continue
        else
            directions = fieldnames(firstInput.(names{name}));
            for dir = 1:numel(directions)
                if directions(dir) == "Radius" || directions(dir) == "Found"
                    continue
                else
                    subplot(2, 2, plotLoc)
                    plot(firstInput.time, firstInput.(names{name}).(directions{dir}), 'r')
                    hold on
                    plot(secondInput.time, secondInput.(names{name}).(directions{dir}), 'b')
                    title([names{name}, ' ', directions{dir}])
                    xlabel('Time (s)')
                    ylabel('Pixel')
                    legend(firstInputName, secondInputName)
                    plotLoc = plotLoc + 1;
                end
            end
            
            
        end
    end
end

function plotTypeVSType_Test(firstInput, secondInput)
    
    names = fieldnames(firstInput);
    plotLoc = 1;
    figure()
    for name = 1:numel(names)
        if names(name) == "time"
            continue
        else
            directions = fieldnames(firstInput.(names{name}));
            for dir = 1:numel(directions)
                subplot(2, 2, plotLoc)
                plot(firstInput.time, firstInput.(names{name}).(directions{dir}), 'r')
                hold on
                plot(secondInput.time, secondInput.(names{name}).(directions{dir}), 'b')
                title([names{name}, ' ', directions{dir}])
                xlabel('Time (s)')
                ylabel('Pixel')
                legend('First Input', 'Second Input')
                plotLoc = plotLoc + 1;
            end
            
            
        end
    end
end

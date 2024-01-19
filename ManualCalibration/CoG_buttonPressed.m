function [breakflag, lineLocation, startAndEndLocations] = CoG_buttonPressed(x, button, lineLocation, startAndEndLocations, startXLine, endXLine)
    breakflag = false;
    if button == 1
        set(startXLine, 'Value', x)
        [startAndEndLocations, lineLocation] = CoG_saveData(x, lineLocation, startAndEndLocations);
    elseif button == 3
        set(endXLine, 'Value', x)
        [startAndEndLocations, lineLocation] = CoG_saveData(x, lineLocation, startAndEndLocations);
    else
        % Does nothing
    end    
end

function [startAndEndLocations, lineLocation] = CoG_saveData(x, lineLocation, startAndEndLocations)
    startAndEndLocations(lineLocation) = x;
    if lineLocation == 1
        lineLocation = 2;
    else
        lineLocation = 1;
    end
end

function calibrationSplit = getCalData(allData, headerLocations)

    calSide = ["rightCal", "leftCal"];
    calMagnitude = ["fivePD", "tenPD", "fifteenPD"];
    calEye = ["rightEye","leftEye"];
    calAxis = ["X", "Y"];
    
    headerTracker = 1;
    col = 1;
    for side = 1:length(calSide)
        for mag = 1:length(calMagnitude)
            for eye = 1:length(calEye)
                for axis = 1:length(calAxis)
                    calibrationSplit.(calSide{side}).(calMagnitude{mag}).(calEye{eye}).(calAxis{axis}) = allData(headerLocations(headerTracker):headerLocations(headerTracker) + min(diff(headerLocations))-1, col);
                    col= col + 1;
                end
            end
            col = 1;
            headerTracker = headerTracker + 1;
        end
    end
end
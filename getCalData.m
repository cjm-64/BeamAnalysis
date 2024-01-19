function calibrationSplit = getCalData(allData, colNum, headerLocations)
    temp = allData;
    dummy = zeros(min(diff(headerLocations)), colNum);
    columnCount = 1;
    for i = 1:colNum
        dummy(:,[columnCount columnCount+1]) = temp(headerLocations(i):headerLocations(i) + min(diff(headerLocations))-1,[1 3]);
        columnCount = columnCount + 2;
    end
    calibrationSplit = dummy;
end
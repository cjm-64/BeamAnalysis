function filteredCalData = calibrationFilter(rawCalData)
    temp = rawCalData;
    for colIndex = 1:size(temp, 2)    
        colMeans = mean(temp(:,colIndex));
        colSTD = std(temp(:,colIndex));
        for rowIndex = 1:size(temp, 1)
            if rawCalData(rowIndex, colIndex) > colMeans+colSTD || rawCalData(rowIndex, colIndex) < colMeans-colSTD
                temp(rowIndex, colIndex) = colMeans; 
            end
        end
    end
    filteredCalData = temp;
end


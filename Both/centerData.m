function centeredData = centerData(filteredData)
    dummy = [filteredData(:,1)-mean(filteredData(1:701,1)), filteredData(:,2)-mean(filteredData(1:701,2))];
    centeredData = dummy;
end

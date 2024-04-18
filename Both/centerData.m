function centeredData = centerData(filteredData)
%     centeredDataOld = [filteredData(:,1)-mean(filteredData(1:701,1)), filteredData(:,2)-mean(filteredData(1:701,2))];
    centeredData = filteredData-trimmean(filteredData,65);
end

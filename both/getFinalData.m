function testDataFinal = getFinalData(testDataFiltered)
   
    directions = fieldnames(testDataFiltered.rightEye);
    for dir = 1:numel(directions)        
        if any(strcmp(directions(dir), ["Radius", "Found"]))
            continue;
        else
            testDataFinal.(directions{dir}) = abs(testDataFiltered.rightEye.(directions{dir})) - abs(testDataFiltered.leftEye.(directions{dir}));
        end
    end
    testDataFinal.time = testDataFiltered.time;
    testDataFinal.fps = round(length(testDataFinal.time)/(max(testDataFiltered.time)));
    
end

function testDataFinal = getFinalData(testDataFiltered)
   
    directions = fieldnames(testDataFiltered.rightEye);
    for dir = 1:numel(directions)        
        if any(strcmp(directions(dir), ["Radius", "Found"]))
            continue;
        else
            % Subtrat left from right
            testDataFinal.(directions{dir}) = abs(testDataFiltered.rightEye.(directions{dir})) - abs(testDataFiltered.leftEye.(directions{dir}));
%             testDataFinal.(directions{dir}) = testDataFiltered.rightEye.(directions{dir}) - testDataFiltered.leftEye.(directions{dir});

% 
%             %linear detrend of result
%             beta = testDataFiltered.time\testDataFinal.(directions{dir});
%             detrendLine = beta*testDataFiltered.time;
%             testDataFinal.(directions{dir}) = testDataFinal.(directions{dir}) - detrendLine; 
% 
%             % Recenter in event of shift
%             testDataFinal.(directions{dir}) = testDataFinal.(directions{dir}) - mean(testDataFinal.(directions{dir}));
        end
    end
    testDataFinal.time = testDataFiltered.time;
    testDataFinal.fps = round(length(testDataFinal.time)/(max(testDataFiltered.time)));
    
end

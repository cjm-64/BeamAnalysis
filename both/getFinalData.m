function testDataFinal = getFinalData(testDataDetrended)
   
    directions = fieldnames(testDataDetrended.rightEye);
    for dir = 1:numel(directions)        
        if any(strcmp(directions(dir), ["Radius", "Found"]))
            continue;
        else
            % Subtrat left from right
            testDataFinal.(directions{dir}) = abs(testDataDetrended.rightEye.(directions{dir})) - abs(testDataDetrended.leftEye.(directions{dir}));
            % testDataFinal.(directions{dir}) = testDataDetrended.rightEye.(directions{dir}) - testDataDetrended.leftEye.(directions{dir});

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
    testDataFinal.time = testDataDetrended.time;
    testDataFinal.fps = round(length(testDataFinal.time)/(max(testDataDetrended.time)));
    
end

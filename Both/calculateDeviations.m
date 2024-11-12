function deviations = calculateDeviations(testDataFinal, threshold)
    
    directions = fieldnames(testDataFinal);
    testBool = true;
    for dir = 1:numel(directions)
        if any(strcmp(directions(dir), ["time", "fps", "Y"]))
            continue;
        else
            deviations.(directions{dir}).startAndEnds = getDeviations(abs(testDataFinal.(directions{dir})), threshold, testDataFinal.fps)';
            if ~isnan(deviations.(directions{dir}).startAndEnds(1,1))                
                deviations.(directions{dir}).lengths = getDeviationLengths(deviations.(directions{dir}).startAndEnds, testDataFinal.fps);
                deviations.(directions{dir}).magnitude = getDeviationMagnitudes(abs(testDataFinal.(directions{dir})), deviations.(directions{dir}).startAndEnds);
                deviations.(directions{dir}).number = size(deviations.(directions{dir}).startAndEnds(:,:), 1);
            else
                testBool = false;
            end
        end
    end
    deviations.threshold = threshold;
    deviations.Found = testBool;
    
end

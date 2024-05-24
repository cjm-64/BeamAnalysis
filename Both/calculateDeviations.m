function deviations = calculateDeviations(testDataFinal, threshold, fileName)
    
    directions = fieldnames(testDataFinal);
    testBool = true;
    for dir = 1:numel(directions)
        if any(strcmp(directions(dir), ["time", "fps", "Y"]))
            continue;
        else
            deviations.(directions{dir}).startAndEnds = getDeviations(testDataFinal.(directions{dir}), threshold)';
            if ~isnan(deviations.(directions{dir}).startAndEnds)                
                deviations.(directions{dir}).lengths = getDeviationLengths(deviations.(directions{dir}).startAndEnds, testDataFinal.fps);
                deviations.(directions{dir}).magnitude = getDeviationMagnitudes(testDataFinal.(directions{dir}), deviations.(directions{dir}).startAndEnds);
            else
                testBool = false;
            end
        end
    end
    deviations.threshold = threshold;
    deviations.Found = testBool;

    %% Save to metrics folder
    save(strcat('Data/Metrics/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "testDataFinal")
end

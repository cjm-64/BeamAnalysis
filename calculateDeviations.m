function deviations = calculateDeviations(testDataFinal, threshold, fileName)
    
    directions = fieldnames(testDataFinal);
    for dir = 1:numel(directions)
        if any(strcmp(directions(dir), ["time", "fps"]))
            continue;
        else
            deviations.(directions{dir}).startAndEnds = getDeviations(testDataFinal.(directions{dir}), threshold)';
            deviations.(directions{dir}).lengths = getDeviationLengths(deviations.(directions{dir}).startAndEnds, testDataFinal.fps);
            deviations.(directions{dir}).magnitude = getDeviationMagnitudes(testDataFinal.(directions{dir}), deviations.(directions{dir}).startAndEnds);
        end
    end

    %% Save to metrics folder
    save(strcat('Data/Metrics/', extractBefore(fileName, strfind(fileName, '.')), '.mat'), "testDataFinal")
end
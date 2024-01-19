function magnitudes = getDeviationMagnitudes(data, deviations)
    magnitudes = zeros(size(deviations, 1), 2);
    
    for i = 1:size(deviations, 1)
        [magnitudes(i, 1), magnitudes(i, 2)] = max(data(deviations(i,1):deviations(i,2)));
        magnitudes(i, 2) = magnitudes(i, 2) + deviations(i,1);
    end
end

function deviationLengths = getDeviationLengths(deviations)
    deviationLengths = zeros(size(deviations, 1), 2);
    for i = 1:size(deviations, 1)
        deviationLengths(i, 1) = deviations(i,2) - deviations(i,1);
    end
    deviationLengths(deviationLengths(:,1) == 0) = 1;
    deviationLengths(:, 2) = deviationLengths(:,1)*(1/71);
end

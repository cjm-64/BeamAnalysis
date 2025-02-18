function deviationLengths = getDeviationLengths(deviations, fps)
    deviationLengths = zeros(size(deviations, 1), 2);
%     for i = 1:size(deviations, 1)
%         deviationLengths(i, 1) = deviations(i,2) - deviations(i,1);
%     end
    deviationLengths(:,1) = deviations(:,2) - deviations(:,1);
    deviationLengths(:, 2) = deviationLengths(:,1)*(1./fps);
%     deviationLengths(deviationLengths(:,2)<5, :) = [];
end


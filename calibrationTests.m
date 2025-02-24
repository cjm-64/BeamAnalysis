function offsets = calibrationTests(calibrationDataRaw, calibrationDataFiltered, offsets)
    offsets(5, :) = [-15:5:-5, 5:5:15];
    figure()
    
    
    % 15 Right Eye
    subplot(6, 3, 7)
    plot(calibrationDataRaw.rightCal.fifteenPD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.rightCal.fifteenPD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Right Cal Fifteen Right Eye')
    
    subplot(6, 3, 8)
    plot(calibrationDataRaw.leftCal.fifteenPD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fifteenPD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Left Cal Fifteen Right Eye')
    
    subplot(6, 3, 9)
    plot(calibrationDataRaw.leftCal.fifteenPD.rightEye.X - calibrationDataRaw.rightCal.fifteenPD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fifteenPD.rightEye.X - calibrationDataFiltered.rightCal.fifteenPD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Fifteen Right Eye')
    
    offsets(1,1) = mean(calibrationDataFiltered.leftCal.fifteenPD.rightEye.X);
    offsets(2,1) = mean(calibrationDataFiltered.rightCal.fifteenPD.rightEye.X);
    
    
    
    % 10 Right Eye
    subplot(6, 3, 4)
    plot(calibrationDataRaw.rightCal.tenPD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.rightCal.tenPD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Right Cal Ten Right Eye')
    
    subplot(6, 3, 5)
    plot(calibrationDataRaw.leftCal.tenPD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.tenPD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Left Cal Ten Right Eye')
    
    subplot(6, 3, 6)
    plot(calibrationDataRaw.leftCal.tenPD.rightEye.X - calibrationDataRaw.rightCal.tenPD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.tenPD.rightEye.X - calibrationDataFiltered.rightCal.tenPD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Ten Right Eye')
    
    offsets(1,2) = mean(calibrationDataFiltered.leftCal.tenPD.rightEye.X);
    offsets(2,2) = mean(calibrationDataFiltered.rightCal.tenPD.rightEye.X);
    
    % 5 Right Eye
    subplot(6, 3, 1)
    plot(calibrationDataRaw.rightCal.fivePD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.rightCal.fivePD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Right Cal Five Right Eye')
    
    subplot(6, 3, 2)
    plot(calibrationDataRaw.leftCal.fivePD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fivePD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Left Cal Five Right Eye')
    
    subplot(6, 3, 3)
    plot(calibrationDataRaw.leftCal.fivePD.rightEye.X - calibrationDataRaw.rightCal.fivePD.rightEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fivePD.rightEye.X - calibrationDataFiltered.rightCal.fivePD.rightEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Five Right Eye')
    
    offsets(1,3) = mean(calibrationDataFiltered.leftCal.fivePD.rightEye.X);
    offsets(2,3) = mean(calibrationDataFiltered.rightCal.fivePD.rightEye.X);
    
    % 5 Left Eye
    subplot(6, 3, 10)
    plot(calibrationDataRaw.rightCal.fivePD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.rightCal.fivePD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Right Cal Five Left Eye')
    
    subplot(6, 3, 11)
    plot(calibrationDataRaw.leftCal.fivePD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fivePD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Left Cal Five Left Eye')
    
    subplot(6, 3, 12)
    plot(calibrationDataRaw.leftCal.fivePD.leftEye.X - calibrationDataRaw.rightCal.fivePD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fivePD.leftEye.X - calibrationDataFiltered.rightCal.fivePD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Five Left Eye')
    
    offsets(1,4) = mean(calibrationDataFiltered.leftCal.fivePD.leftEye.X);
    offsets(2,4) = mean(calibrationDataFiltered.rightCal.fivePD.leftEye.X);
    
    
    % 10 Left Eye
    subplot(6, 3, 13)
    plot(calibrationDataRaw.rightCal.tenPD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.rightCal.tenPD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Right Cal Ten Left Eye')
    
    subplot(6, 3, 14)
    plot(calibrationDataRaw.leftCal.tenPD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.tenPD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Left Cal Ten Left Eye')
    
    subplot(6, 3, 15)
    plot(calibrationDataRaw.leftCal.tenPD.leftEye.X - calibrationDataRaw.rightCal.tenPD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.tenPD.leftEye.X - calibrationDataFiltered.rightCal.tenPD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Ten Left Eye')
    
    offsets(1,5) = mean(calibrationDataFiltered.leftCal.tenPD.leftEye.X);
    offsets(2,5) = mean(calibrationDataFiltered.rightCal.tenPD.leftEye.X);
    
    % 15 Left Eye
    subplot(6, 3, 16)
    plot(calibrationDataRaw.rightCal.fifteenPD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.rightCal.fifteenPD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Right Cal Fifteen Left Eye')
    
    subplot(6, 3, 17)
    plot(calibrationDataRaw.leftCal.fifteenPD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fifteenPD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Left Cal Fifteen Left Eye')
    
    subplot(6, 3, 18)
    plot(calibrationDataRaw.leftCal.fifteenPD.leftEye.X - calibrationDataRaw.rightCal.fifteenPD.leftEye.X, 'r')
    hold on
    plot(calibrationDataFiltered.leftCal.fifteenPD.leftEye.X - calibrationDataFiltered.rightCal.fifteenPD.leftEye.X, 'b')
    xlabel('Samples')
    ylabel('Pixel')
    legend('raw', 'filtered')
    title('Fifteen Left Eye')
    
    offsets(1,6) = mean(calibrationDataFiltered.leftCal.fifteenPD.leftEye.X);
    offsets(2,6) = mean(calibrationDataFiltered.rightCal.fifteenPD.leftEye.X);

    offsets(3,:) = offsets(1,:) - offsets(2,:);
    offsets(4, :) = mean(offsets(1:2, :), 1);
end

%%
% figure()
% plot(offsets(4,:,:), offsets(1:2,:,:))
% 
% figure()
% plot(offsets(4,:, :), offsets(3,:,:))








function plotBEAMProcessingSteps(testDataRaw, testDataFiltered, testDataCentered, testDataCalibrated)
    
    figure()
    subplot(2, 2, 1)
    plot(testDataRaw.time, testDataRaw.rightEye.X, 'r')
    hold on
    plot(testDataRaw.time, testDataRaw.leftEye.X, 'b')
    title("Raw Data")
    legend("Right Eye", "Left Eye")
    
    subplot(2,2,2)
    plot(testDataCentered.time, testDataCentered.rightEye.X, 'r')
    hold on
    plot(testDataCentered.time, testDataCentered.leftEye.X, 'b')
    title("Centered")
    legend("Right Eye", "Left Eye")
    
    subplot(2,2,3)
    plot(testDataCalibrated.time, testDataCalibrated.rightEye.X, 'r')
    hold on
    plot(testDataCalibrated.time, testDataCalibrated.leftEye.X, 'b')
    title("Calibrated")
    legend("Right Eye", "Left Eye")
    
    subplot (2,2,4)
    plot(testDataFiltered.time, testDataFiltered.rightEye.X, 'r')
    hold on
    plot(testDataFiltered.time, testDataFiltered.leftEye.X, 'b')
    title("Smoothed")
    legend("Right Eye", "Left Eye")

end
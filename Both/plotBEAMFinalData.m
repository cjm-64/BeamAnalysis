function plotBEAMFinalData(testDataFinal, deviations)
    figure()
    plot(testDataFinal.time, testDataFinal.X,'b')
    hold on
    yline(deviations.threshold, 'r--')
    plot(testDataFinal.time(deviations.X.startAndEnds(:,1)), testDataFinal.X(deviations.X.startAndEnds(:,1)), 'g*')
    plot(testDataFinal.time(deviations.X.startAndEnds(:,2)), testDataFinal.X(deviations.X.startAndEnds(:,2)), 'm*')
    plot(testDataFinal.time(deviations.X.magnitude(:,2)), deviations.X.magnitude(:,1),'k*')
    yline(deviations.threshold, 'k')
    xlabel('time (s)')
    ylabel('prism diopters')
    title('Short recording of IXT patient with deviations')
    legend('Deviation Amount','Threshold','Deviation Onset', 'Deviation End', 'Max deviation', 'Location','northwest')

    figure()
    histogram(testDataFinal.X, 'BinWidth', 5, 'FaceColor', 'c')
    xlabel('Prism Diopters')
    ylabel('Frame Count')
    title('Histogram of deviation over time')

end
function plotBEAMFinalData(testDataFinal, deviations)
    minutes  = linspace(0, max(testDataFinal.time)/60, size(testDataFinal.time, 1));
    figure()
    plot(minutes, testDataFinal.X,'b')
    hold on
    yline(deviations.threshold, 'r--')    
    if deviations.Found
        plot(minutes(deviations.X.startAndEnds(:,1)), testDataFinal.X(deviations.X.startAndEnds(:,1)), 'g*')
        plot(minutes(deviations.X.startAndEnds(:,2)), testDataFinal.X(deviations.X.startAndEnds(:,2)), 'm*')
        plot(minutes(deviations.X.magnitude(:,2)), deviations.X.magnitude(:,1),'k*')
        legend('Deviation Amount','Threshold','Deviation Onset', 'Deviation End', 'Max deviation', 'Location','northwest')
    end
    ylim([0 45])
    xlabel('time (min)')
    ylabel('prism diopters')
    title('Short recording of IXT patient with deviations')

    figure()
    h = histogram(testDataFinal.X, 'BinWidth', 2, 'FaceColor', 'c');
    xlabel('Prism Diopters')
    ylabel('Frame Count')
    title('Histogram of deviation over time')

end
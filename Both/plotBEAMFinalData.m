function plotBEAMFinalData(testDataFinal, deviations, fileName)
    minutes  = linspace(0, max(testDataFinal.time)/60, size(testDataFinal.time, 1));
    figure()
    plot(minutes, testDataFinal.X,'b')
    hold on 
    yline(deviations.threshold, 'r--')
    yline(-1*deviations.threshold, 'r--')   
    yline(0, 'k')    
    if deviations.Found
        plot(minutes(deviations.X.startAndEnds(:,1)), testDataFinal.X(deviations.X.startAndEnds(:,1)), 'g*')
        plot(minutes(deviations.X.startAndEnds(:,2)), testDataFinal.X(deviations.X.startAndEnds(:,2)), 'm*')
        plot(minutes(deviations.X.magnitude(:,2)), testDataFinal.X(deviations.X.magnitude(:,2)),'k*')
        legend('Eye Alignment','Upper Threshold','Lower Threshold','Zero','Deviation Onset', 'Deviation End', 'Max deviation', 'Location','northwest')
    else
        legend('Eye Alignment','Upper Threshold','Lower Threshold','Zero','Location','northwest')
    end
    ylim([-45 45])
    xlabel('time (min)')
    ylabel('prism diopters')
    title(fileName, 'Interpreter','none')

    figure()
    h = histogram(testDataFinal.X, 'BinWidth', 2, 'FaceColor', 'c');
    xlabel('Prism Diopters')
    ylabel('Frame Count')
    title('Histogram of deviation over time')

end
figure()
h = histogram(testDataFinal.X, 'BinWidth', 5, 'FaceColor', 'c');
[N, edges] = histcounts(testDataFinal.X, 30);
for i = 1:size(edges, 2)-1
    centers(i) = mean(edges(i:i+1));
end

figure()
plot(centers, N)
[H, pVal, SW] = swtest(N, 0.05);

%% Find where to split the bimodal distribution

% Find the mean and StD of everythin less than threshold
thresh = 15;
a = abs(testDataFinal.X);
a = a(a<thresh);

belowThreshMean = mean(a);
belowThreshMeanStD = std(a);
split = belowThreshMean + 2*belowThreshMeanStD;

hold on
xline(split)
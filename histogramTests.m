map = brewermap(4,'Set1');

figure()
histogram(c3, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(1,:))
hold on
histogram(c4, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
histogram(p2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(3,:))
histogram(p3, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(4,:))
hold off
xlabel('Prism Diopters')
ylabel('Frame Count')
title('Histogram of deviation over time')
legend('c1', 'c2', 'p2', 'p3')

%%
figure()
subplot(2, 2, 1)
histogram(c3, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(1,:))
xlim([-45 45])
ylim([0 3*10^5])

subplot(2, 2, 2)
histogram(p2, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
xlim([-45 45])
ylim([0 3*10^5])

subplot(2, 2, 3)
histogram(c4, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(1,:))
xlim([-45 45])
ylim([0 3*10^5])

subplot(2, 2, 4)
histogram(p3, 'BinWidth', 2, 'FaceAlpha', 0.5, 'FaceColor', map(2,:))
xlim([-45 45])
ylim([0 3*10^5])

%%
figure()
ax1 = subplot(2, 2, 1);
histfit(ax1, c1, length(unique(round(c1))))
xlim([-45 45])
ylim([0 3*10^5])

ax2 = subplot(2, 2, 2);
histfit(ax2, p1, length(unique(round(p1))))
xlim([-45 45])
ylim([0 3*10^5])

ax3 = subplot(2, 2, 3);
histfit(ax3, c2, length(unique(round(c2))))
xlim([-45 45])
ylim([0 3*10^5])

ax4 = subplot(2, 2, 4);
histfit(ax4, p2, length(unique(round(p2))))
xlim([-45 45])
ylim([0 3*10^5])










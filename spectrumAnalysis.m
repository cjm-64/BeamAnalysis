fftRaw = fft(testDataRaw.rightEye.X);
fftFiltered = fft(testDataFiltered.rightEye.X);
Fs = 71;
L = size(testDataRaw.time,1);

figure()
plot(Fs/L*(0:L-1), abs(fftRaw), 'r')
hold on
plot(Fs/L*(0:L-1), abs(fftFiltered), 'b')
ylim([0 2500])
xlim([0 60*pi])

figure()
subplot(2, 2, 1)
plot(testDataCentered.rightEye.X, 'r')
hold on
plot(testDataFiltered.rightEye.X, 'k')
title('Right Eye X')
subplot(2, 2, 2)
plot(testDataCentered.rightEye.Y, 'r')
hold on
plot(testDataFiltered.rightEye.Y, 'k')
title('Right Eye Y')
subplot(2, 2, 3)
plot(testDataCentered.leftEye.X, 'r')
hold on
plot(testDataFiltered.leftEye.X, 'k')
title('Left Eye X')
subplot(2, 2, 4)
plot(testDataCentered.leftEye.Y, 'r')
hold on
plot(testDataFiltered.leftEye.Y, 'k')
title('Left Eye Y')
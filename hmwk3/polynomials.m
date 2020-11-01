clear all; close all; clc

% xspan
deltax = 0.001;
x = [1.920: deltax: 2.080];

% polynomials
p1 = x.^9 - 18*x.^8 + 144*x.^7 - 672*x.^6 + 2016*x.^5 - 4032*x.^4 + 5376*x.^3 - 4608*x.^2 + 2304*x - 512;
p2 = (x-2).^9;

% plots
figure(1);
plot(x, p1);
title('Plot of x^9 - 18*x^8 + 144*x^7 - 672*x^6 + 2016*x^5 - 4032*x^4 + 5376*x^3 - 4608*x^2 + 2304*x - 512');
xlabel('x'); ylabel('p(x)');
xlim([1.920 2.080]);

figure(2);
plot(x, p2);
title('Plot of (x-2)^9');
xlabel('x'); ylabel('p(x)');
xlim([1.920 2.080]);

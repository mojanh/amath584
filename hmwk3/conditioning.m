clear all; close all; clc

% part a
m1 = 40; n1 = 30; % m > n
cond_numbers = [];

for i1 = 1:100
    A1 = randn(m1,n1);
    cond_numbers(i1) = cond(A1);
    m1 = m1 + 1;
    n1 = n1 + 1;
end

figure(1);
plot(cond_numbers);
title('Plot of Condition Numbers with Increasing Matrix Dimensions');
xlabel('Iterations of Increasing Matrix Size'); ylabel('Condition Number');

% part b & c 
m = 7;
A_regular = randn(m,m);

A_copy = A_regular;
A_copy(:,end) = A_copy(:,1);

A_copy_with_noise = A_copy;
A_copy_with_noise(:,end) = A_copy_with_noise(:,end) + (0.01*rand(m,1));

det_a = det(A_regular);
det_b = det(A_copy);
det_c = det(A_copy_with_noise);

cond_a = cond(A_regular);
cond_b = cond(A_copy);
cond_c = cond(A_copy_with_noise);

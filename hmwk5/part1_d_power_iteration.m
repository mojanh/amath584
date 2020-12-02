% clear the environment
clear all; close all; clc
warning('off')

% PART I d)
% Generating non-symmetric matrix
m = 10;
A = rand(m,m);
[eigenvec, eigenval] = eigs(A,m);
true_eigenval = sort(diag(eigenval)); % sorted 10x1 matrix of growth truth eigenvalues

% Power Iteration Method
true_max_eigenvalue = max(true_eigenval);
v_curr = zeros(m,1); v_curr(1) = 1;  % initial eigenvector

for k = 1:20
	w = A*v_curr;
	v_curr=w/norm(w); % normalize

	lambda(k) = v_curr'*A*v_curr; % Rayleigh Quotient
	error(k) = abs(true_max_eigenvalue - lambda(k));
end

figure(1); plot(error); xlim([1 20]); ylabel('absolute error'); xlabel('iterations'); 
title('Error of Power Iteration Max Eigenvalue by Iteration');

% checking to make sure answer is right
if ismembertol(lambda(20), true_max_eigenvalue, 10^-5) % check if max eigenvalue was found
    part_b_check = 'True';
end

% plot eigenvalues on complex plane
real_true = real(true_eigenval); imag_true = imag(true_eigenval); % true max eigenvalue
real_pi = real(lambda(20)); imag_pi = imag(lambda(20)); % power iteration max eigenvalue

figure(2);
plot(real_true,imag_true,'bo'); xlabel('real part'); ylabel('imaginary part');
title('Plotting growth truth eigenvalues on complex plane');

figure(3);
plot(real_pi,imag_pi,'bo'); xlabel('real part'); ylabel('imaginary part');
title('Plotting max eigenvalue from power iteration method on complex plane');

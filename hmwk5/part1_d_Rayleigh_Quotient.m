% clear the environment
clear all; close all; clc
warning('off')

% PART I d)
% Generating non-symmetric matrix
m = 10;
A = rand(m,m);
[eigenvec, eigenval] = eigs(A,m);
true_eigenval = sort(diag(eigenval)); % sorted 10x1 matrix of growth truth eigenvalues

% Rayleigh Quotient Method
rq_eigenval = []; rq_eigenvec = [];
eigenvec_guess = zeros(m,1); eigenvec_guess(1) = 0.002; % inital eigenvector

for i = 1:5000 % iterating through different initial eigenvectors
    v_rq(:,1) = eigenvec_guess;
    lambda_rq(1) = v_rq(:,1)'*A*v_rq(:,1); % Rayleigh quotient
    rq_error = []; rq_error(1) = abs(true_eigenval(length(rq_eigenval)+1) - lambda_rq(1));

    for k = 2:100  % iterating Rayleigh quotients for a single initial eigenvector
        w = (A - lambda_rq(k-1)*eye(m,m))\(v_rq(:,k-1)); % solve (A-mu*I)w = v^(k-1)
        v_rq(:,k) = w/norm(w); % normalize
        lambda_rq(k) = v_rq(:,k)'*A*v_rq(:,k); % Rayleigh quotient
        rq_error(k) = abs(true_eigenval(length(rq_eigenval)+1) - lambda_rq(k));
    end
    
    if ~ismembertol(lambda_rq(k), rq_eigenval, 10^-5)
        rq_eigenval(length(rq_eigenval)+1) = lambda_rq(k); % add eigenvalue if not already added
        rq_eigenvec(:,length(rq_eigenval)) = v_rq(:,20);
        
        % plot error
        figure(length(rq_eigenval)); plot(rq_error); xlim([1 100]); ylabel('absolute error'); xlabel('iterations'); 
        title('Error of Rayleigh Quotient Iteration Method by Iteration - Eigenvalue Number: ' + string(length(rq_eigenval)));
    end
    
    if length(rq_eigenval) == m
        break
    end
    
    eigenvec_guess(1) = eigenvec_guess(1) + 0.001; % increment initial guess
end

% plot eigenvalues on complex plane
real_true = real(true_eigenval); imag_true = imag(true_eigenval); % true max eigenvalue
real_pi = real(rq_eigenval); imag_pi = imag(rq_eigenval); % Rayleigh Quotient max eigenvalue

figure(11);
plot(real_true,imag_true,'bo'); xlabel('real part'); ylabel('imaginary part');
title('Plotting growth truth eigenvalues on complex plane');

figure(12);
plot(real_pi,imag_pi,'bo'); xlabel('real part'); ylabel('imaginary part');
title('Plotting max eigenvalue from Rayleigh Quotient iteration method on complex plane');

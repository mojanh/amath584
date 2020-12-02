% clear the environment
clear all; close all; clc
warning('off')

% PART I 
% a) Generating a symmetric matrix

% creating symmetrix mxm matrix
m = 10;
A_rand = rand(m,m);
A = A_rand*A_rand';
[eigenvec, eigenval] = eigs(A,m);
true_eigenval = sort(diag(eigenval)); % sorted 10x1 matrix of ground truth eigenvalues

% b) Power Iteration Method
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

% c) Rayleigh Quotient Method
rq_eigenval = []; rq_eigenvec = [];
eigenvec_guess = zeros(m,1); eigenvec_guess(1) = 0.002; % inital eigenvector

for i = 1:5000 % iterating through different initial eigenvectors
    v_rq(:,1) = eigenvec_guess;
    lambda_rq(1) = v_rq(:,1)'*A*v_rq(:,1); % Rayleigh quotient
    rq_error = []; rq_error(1) = abs(true_eigenval(length(rq_eigenval)+1) - lambda_rq(1));

    for k = 2:20  % iterating Rayleigh quotients for a single initial eigenvector
        w = (A - lambda_rq(k-1)*eye(m,m))\(v_rq(:,k-1)); % solve (A-mu*I)w = v^(k-1)
        v_rq(:,k) = w/norm(w); % normalize
        lambda_rq(k) = v_rq(:,k)'*A*v_rq(:,k); % Rayleigh quotient
        rq_error(k) = abs(true_eigenval(length(rq_eigenval)+1) - lambda_rq(k));
    end
    
    if ~ismembertol(lambda_rq(k), rq_eigenval, 10^-5)
        rq_eigenval(length(rq_eigenval)+1) = lambda_rq(k); % add eigenvalue if not already added
        rq_eigenvec(:,length(rq_eigenval)) = v_rq(:,20);
        
        % plot error
        figure(length(rq_eigenval)); plot(rq_error); xlim([1 20]); ylabel('absolute error'); xlabel('iterations'); 
        title('Error of Rayleigh Quotient Iteration Method by Iteration - Eigenvalue Number: ' + string(length(rq_eigenval)));
    end
    
    if length(rq_eigenval) == m
        break
    end
    
    eigenvec_guess(1) = eigenvec_guess(1) + 0.001; % increment initial guess
end

% checking to make sure answer is right
part_c_check = 0;
for i = 1:10
    if ismembertol(rq_eigenval(i), true_eigenval, 10^-5) % check if eigenvalue was found
        part_c_check = part_c_check + 1;
    end
end
num_correct_eigenvalues_part_c = part_c_check;

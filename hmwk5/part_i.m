% clear the environment
clear all; close all; clc

% PART I 
% a) 

m = 10;

% creating symmetrix mxm matrix
A_rand = rand(m,m);
A_triu = triu(A_rand);
A_tril = A_triu.' - diag(diag(A_triu));
A = A_tril + A_triu;

[eigenvec, eigenval] = eigs(A,m);

% b) 
true_eigenvalue = max(diag(eigenval));
v_curr = ones(m,1);

% power iteration method
for k = 1:20
	w = A*v_curr;
	v_curr=w/norm(w);

	lambda(k) = v_curr'*A*v_curr;
    power_eigenvalue = max(lambda);
    error(k) = abs(true_eigenvalue - power_eigenvalue);
end

plot(error); xlim([1 20]); ylabel('error'); xlabel('iterations'); 
title('Error of Power Iteration Max Eigenvalue by Iteration');

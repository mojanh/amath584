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

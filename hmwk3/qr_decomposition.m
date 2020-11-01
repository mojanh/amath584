
clear all; close all; clc

% Construct Matrices
m = 30;
A_well = randn(m,m);

A_ill = A_well;
A_ill(:,end) = A_ill(:,1);
A_ill(:,end-1) = A_ill(:,2);

% Calculate condition number
cond_a = cond(A_well);
cond_b = cond(A_ill);

% QR decompositions

% Matlab Version
[Q_well_matlab, R_well_matlab] = qr(A_well);
[Q_ill_matlab, R_ill_matlab] = qr(A_ill);

well_cond_matlab = Q_well_matlab*R_well_matlab;
ill_cond_matlab = Q_ill_matlab*R_ill_matlab;
sum_diff_matlab_well = sum(sum(abs(A_well - well_cond_matlab)));
sum_diff_matlab_ill = sum(sum(abs(A_ill - ill_cond_matlab)));

% In-class QRfactor Version
[Q_well_factor, R_well_factor] = qrfactor(A_well);
[Q_ill_factor, R_ill_factor] = qrfactor(A_ill);

well_cond_qrfactor = Q_well_factor*R_well_factor;
ill_cond_qrfactor = Q_ill_factor*R_ill_factor;
sum_diff_qrfactor_well = sum(sum(abs(A_well - well_cond_qrfactor)));
sum_diff_qrfactor_ill = sum(sum(abs(A_ill - ill_cond_qrfactor)));

% Gram Schmidt Version
[Q_well_gs, R_well_gs] = gramschmidt(A_well);
[Q_ill_gs, R_ill_gs] = gramschmidt(A_ill);

well_cond_gramschmidt = Q_well_gs*R_well_gs;
ill_cond_gramschmidt = Q_ill_gs*R_ill_gs;
sum_diff_gramschmidt_well = sum(sum(abs(A_well - well_cond_gramschmidt)));
sum_diff_gramschmidt_ill = sum(sum(abs(A_ill - ill_cond_gramschmidt)));

% QR Gram-Schmidt 
function [Q,R] = gramschmidt(A)
    [~,n] = size(A);
    R = zeros(n);
    
    R(1,1) = norm(A(:,1));
    Q(:,1) = A(:,1)/R(1,1);
    
    for i=2:n
        R(1:i-1,i)=Q(:,1:i-1)'*A(:,i);
        Q(:,i)=A(:,i)-Q(:,1:i-1)*R(1:i-1,i);
        R(i,i)=norm(Q(:,i));
        Q(:,i)=Q(:,i)/R(i,i);
    end
end

% QR function from class
function [Q,R] = qrfactor(A)

    [m,n] = size(A);
    Q=eye(m);
    
    for k = 1:n
        % Find the HH reflector
        z = A(k:m,k);
        v = [ -sign(z(1))*norm(z) - z(1); -z(2:end) ];
        v = v / sqrt(v'*v);   % remoce v'*v in den

        % Apply the HH reflection to each column of A and Q
        for j = 1:n
            A(k:m,j) = A(k:m,j) - v*( 2*(v'*A(k:m,j)) );
        end
        for j = 1:m
            Q(k:m,j) = Q(k:m,j) - v*( 2*(v'*Q(k:m,j)) );
        end

    end

    Q = Q';
    R = triu(A);  % exact triangularity
end

% clear the environment
clear all; close all; clc

% declare A matrix - for testing 
A = [2 1 1 0; 4 3 3 1; 8 7 9 5; 6 7 9 8];

[L,U,P] = LU_decomposition(A);
[L_verify,U_verify,P_verify] = lu(A);

% testing correctness of new function 
if (P == P_verify) & (round(L,4) == round(L_verify,4)) & (round(U,4) == round(U_verify,4))
    test = 'correct';
else
    test = 'incorrect';
end

function [L,U,P] = LU_decomposition(A)
    % initialize return variables
    U = A; L = eye(size(A)); P = L;
    
    for i=1:size(A)-1
        [~,max_ind_row] = max(abs(U(i:size(A),i)));
        max_ind_row = max_ind_row+(i-1);
        
        % condition to check that factorization is complete
        if max_ind_row ~= i
            % swap rows
            old_row = U(i,:);
            new_row = U(max_ind_row,:);
            U(i,:)= new_row;
            U(max_ind_row,:)= old_row;
            
            old_row = P(i,:);
            new_row = P(max_ind_row,:);
            P(i,:)= new_row;
            P(max_ind_row,:)= old_row;
            
            if i ~= 1
                old_row = L(i,1:i-1);
                new_row = L(max_ind_row,1:i-1);
                L(i,1:i-1) = new_row;
                L(max_ind_row,1:i-1) = old_row;
            end
        end
        
        for j = i+1:size(A)
            L(j,i)=U(j,i)/U(i,i);
            U(j,:)=U(j,:)-L(j,i)*U(i,:);
        end
    end
end

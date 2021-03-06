% clear the environment
clear all; close all; clc

% datastructure to hold images: 38 people, 64 images per person
cropped_images = [];  % dimensions will be 32256 x 2432 for (192 x 168 pixels) by (39 people x 64 images/person)
image_index = 1;

% looping through 38 subjects
for a = 1:39 
    
    % getting folder name
    if a < 10 folder = strcat('~/Desktop/CroppedYale/yaleB0',num2str(a));
    else folder = strcat('~/Desktop/CroppedYale/yaleB',num2str(a));
    end
    
    % matching all images in folder
    file_names = dir(fullfile(folder, 'yaleB*'));
    
    % looping through 64 images 
    for k = 1:numel(file_names)
        file = fullfile(folder,file_names(k).name);
        im = imread(file);
        cropped_images(:,image_index)=im(:);
        image_index = image_index + 1;
    end
end

% Power iteration method
A = corr(cropped_images); % correlation matrix
A(isinf(A)|isnan(A)) = 0;
[eigenvec, eigenval] = eigs(A,2432);
true_eigenval = sort(diag(eigenval)); % sorted matrix of ground truth eigenvalues

v_curr = zeros(2432,1); v_curr(1) = 1;  % initial eigenvector

for k = 1:100
    w = A*v_curr;
    v_curr=w/norm(w); % normalize
    lambda(k) = v_curr'*A*v_curr; % Rayleigh Quotient
end

% SVD
[U,S,V]=svd(A,'econ');

% resulting max eigenvalue and corresponding eigenvector
poweriteration_max_eigenvalue = lambda(100);
poweriteration_max_eigenvector = v_curr;

% plot results
figure(1); plot(U(:,1));
title('Plot of leading order mode from SVD'); 

figure(2); plot(poweriteration_max_eigenvector);
title('Plot of eigenvector for largest eigenvalue from power iteration method');

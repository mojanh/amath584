clear the environment
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

% SVD
[U,S,V]=svd(cropped_images,'econ');

% Randomized Sampling method to reconstruct SVD
k = 1000;
omega = randn(2432,k);
Y = cropped_images*omega;
[Q,R] = qr(Y,0);

B = Q'*cropped_images;
[U_tilde, S_tilde, V_tilde] = svd(B,'econ');
U_recon = Q*U_tilde;
S_recon = Q*S_tilde;

figure(1);
plot(U(:,1),'k');
title('Leading order true SVD mode');

figure(2);
plot(U_recon(:,1),'k:');
title('Leading order reconstructed SVD mode');

figure(3);
plot(U(:,2),'k');
title('Second order true SVD mode');

figure(4);
plot(U_recon(:,2),'k:');
title('Second order reconstructed SVD mode');

figure(5);
plot(U(:,3),'k');
title('Third order true SVD mode');

figure(6);
plot(U_recon(:,3),'k:');
title('Third order reconstructed SVD mode');

figure(7);
plot(diag(S)/sum(diag(S)),'ko','Linewidth',[2]); xlabel('singular values'); ylabel('\sigma');
title('True SVD singular values');

figure(8);
plot(diag(S_recon)/sum(diag(S_recon)),'ko','Linewidth',[2]); xlabel('singular values'); ylabel('\sigma');
title('Reconstructed SVD singular values');

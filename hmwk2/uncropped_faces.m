% clear the environment
clear all; close all; clc

% datastructure to hold images: 38 people, 64 images per person
cropped_images = [];  % dimensions will be 32256 x 2432 for (192 x 168 pixels) by (39 people x 64 images/person)
image_index = 1;

% looping through 64 images
for a = 1:64                         
    folder = '~/Desktop/yalefaces_uncropped/yalefaces';
    subfolder = dir(fullfile(folder, 'subject*'));
    
    file = fullfile(folder,subfolder(a).name);
    im = imread(file);
    cropped_images(:,a)=im(:);
end

% displaying first nine columns (one image per column)
figure(1);
for j=1:9
    subplot(3,3,j);
	imshow(uint8(reshape(cropped_images(:,j),243,320)));
end

% SVD
[U,S,V]=svd(cropped_images,'econ');

% plot of singular values
figure(2);
plot(diag(S),'ko','Linewidth',[2]);
set(gca,'Fontsize',[14],'Xlim',[0,64]); xlabel('singular values'); ylabel('\sigma');
title('Plot of Singular Values, Diagonal Values of S Matrix');

% display eigenfaces
figure(3);
for j=1:16
    subplot(4,4,j);
    imagesc(reshape(U(:,j),243,320)); colormap(gray); set(gca,'xtick',[],'ytick',[])
end

% the average face
figure(4); avg_face = mean(cropped_images,2); imagesc(reshape(avg_face,243,320)); colormap(gray); set(gca,'xtick',[],'ytick',[]);

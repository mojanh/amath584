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

% displaying first nine columns (one image per column)
figure(1);
for j=1:9
    subplot(3,3,j);
	imshow(uint8(reshape(cropped_images(:,j),192,168)));
end

% SVD
[U,S,V]=svd(cropped_images,'econ');

% plot of singular values
figure(2);
plot(diag(S),'ko','Linewidth',[2]);
set(gca,'Fontsize',[14],'Xlim',[0,64]); xlabel('singular values'); ylabel('\sigma');

% display eigenfaces
figure(3);
for j=1:16
    subplot(4,4,j);
    imagesc(reshape(U(:,j),192,168)); colormap(gray); set(gca,'xtick',[],'ytick',[])
end

% the average face
figure(4); avg_face = mean(cropped_images,2); imagesc(reshape(avg_face,192,168)); colormap(gray); set(gca,'xtick',[],'ytick',[]);

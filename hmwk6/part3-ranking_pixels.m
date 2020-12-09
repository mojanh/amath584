% clear the environment
clear all; close all; clc;

% load in the data and store in data structures
raw_data = load('mnist.mat');

train_images = raw_data.trainX; % (60000,784) matrix
train_labels = raw_data.trainY'; % (1,60000) matrix
test_images = raw_data.testX; % (10000,784) matrix
test_labels = raw_data.testY; % (1,10000) matrix

% transform of labels data
train_labels_vec = convert_labels(train_labels);
test_labels_vec = convert_labels(test_labels');

% display error for top n pixels
figure(1);
[model_2,~,~,~] = cross_validate(5,0.5,"ridge",train_labels_vec,train_labels,double(train_images),test_labels,test_labels_vec,double(test_images'));

single_column_model = model_2(:,1);
sorted_values = sort(abs(single_column_model), 'descend');
 
% loop through each pixel
for j=1:784
    model = model_2;
    model(abs(model)<sorted_values(j)) = [0];
    
    predictions = model'*double(test_images');
    [~, predictions] = max(predictions);
    predictions(predictions == 10) = 0;
    error(j,:) = sum(predictions==test_labels);
end

% plot pareto front
plot(1:784,error);
title('Error Compared to Number of Pixels Used');
xlabel('Number of Pixels Used for Model');
ylabel('Count of Correctly Labelled Data (out of 10,000)');

%subplot(4,1,m),bar(single_column); xlabel('pixel number'); ylabel('loading value'); % bar plot of loadings
%subplot(4,3,9+m), hist(single_column,20); xlabel('loading value'); ylabel('number of pixels'); % histogram of loadings


% function that returns a cross validated model
function [model,predictions,error,error_count] = cross_validate(k,parameter,model_type,train_labels_vec,train_labels,train_images,test_labels,test_labels_vec,test_images)
    matrix_size = size(train_labels_vec);
    single_fold_size = matrix_size(2)./k;  % size of training set for single fold
    
    for i=1:k
        lower_bound = ((i-1)*single_fold_size)+1;
        upper_bound = single_fold_size*i;
        
        % filtering training set to single fold size
        single_fold_labels = train_labels_vec(:,lower_bound:upper_bound);
        single_fold_images = train_images(lower_bound:upper_bound,:);
        
        if model_type=="backslash"
            models(:,:,i) = single_fold_images\single_fold_labels'; 
        elseif model_type=="pinv"
            models(:,:,i) = pinv(single_fold_images)*single_fold_labels'; 
        elseif model_type=="lasso"
            % looping over columns of B
            for g=1:10
                modelx(:,g) = lasso(single_fold_images,single_fold_labels(g,:),'Lambda',parameter); 
            end
            models(:,:,i) = modelx;
        elseif model_type=="ridge"
            % looping over columns of B
            for g=1:10
                modelx(:,g) = ridge(single_fold_labels(g,:)',single_fold_images(:,2:end),parameter,0);
            end
            models(:,:,i) = modelx;
        end    
    end
    
    % taking average model from k folds
    model = mean(models,3);
    predictions = model'*test_images;
    [~, predictions] = max(predictions); % selecting index of max value 
    predictions(predictions == 10) = 0;  % replacing 10 digit with 0
    
    error = norm(double(test_labels) - predictions)/norm(double(test_labels)); % calculating l2 norm error
    error_count = sum(predictions==test_labels); % counting number of correct digits
end

% function to convert labels to 'categorical' column vectors
function labels_vec = convert_labels(labels)

    labels_size = size(labels);
    labels_vec = zeros(10,labels_size(1));   % column vector of zeros
    
    for i=1:labels_size(1)
        if labels(i,:) == 0
            labels_vec(10,i) = 1;           % store 0 in 10th index
        else
            labels_vec(labels(i,:),i) = 1;  % store anything but 0s in index=value of label
        end
    end

end 

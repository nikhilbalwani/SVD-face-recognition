clc
clear all;
close all;

D = 'subjects';
S = dir(fullfile(D,'*.centerlight')); % pattern to match filenames.\

figure;

title('Images');

A = [];

for k = 1:numel(S)
    F = fullfile(D, S(k).name);
    I = imread(F);
    subplot(ceil(sqrt(size(S,1))), ceil(sqrt(size(S,1))), k);
    imshow(I);
    I=imresize(I, 0.4);
    I = I';
    vector = im2double(I(:));
    A = [A vector];
end

[eig_vectors, eig_values] = eig(A' * A);

[U, sig, V] = svd(A);

coord = [];

for i = 1:size(A, 2)
    stacked_image = A(:, i);
    
    % Coordinates of image i in the space of U
    coordinates = stacked_image' * U;
    coord = [coord; coordinates];
end

% Testing an image from the dataset

F = fullfile('subjects', 'subject10.centerlight');
I = imread(F);

I = imresize(I, 0.4);
I = I';
image_vector = im2double(I(:));

% Calculating the coordinates for test image
test_coordinates = image_vector' * U;

min = 10^10;
min_idx = 0;

for i = 1:size(A, 2)
    check_coordinates = coord(i, :);
    euclidean_dist = sum((check_coordinates - test_coordinates) .^ 2);
    
    if euclidean_dist < min
        min = euclidean_dist;
        min_idx = i;
    end
end

% The output should be subject 10 since 10th subject was chosen

disp('The closest image is subject number');
disp(min_idx);
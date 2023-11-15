clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                RESIZER SCRIPT                      %
%            TESTED ON: 03/04/2023                   %
%            Muhammad Sadaqat Janjua                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Specify the parent directory containing the 'images' and 'masks' directories
parent_dir = 'C:\Users\muham\Pictures\nex\kvid\';

% Create a new directory to store the resized images
resized_images_dir = fullfile(parent_dir, 'resized_images');
mkdir(resized_images_dir);

% Create a new directory to store the resized masks
resized_masks_dir = fullfile(parent_dir, 'resized_masks');
mkdir(resized_masks_dir);

% Specify the target size for the resized images and masks
target_size = [320 320];

% Loop through each image in the 'images' directory
image_dir = fullfile(parent_dir, 'images');
image_files = dir(fullfile(image_dir, '*.jpg'));
for i = 1:numel(image_files)
    % Load the image
    image_path = fullfile(image_dir, image_files(i).name);
    image = imread(image_path);
    
    % Resize the image
    resized_image = imresize(image, target_size);
    
    % Save the resized image to the new directory
    resized_image_path = fullfile(resized_images_dir, image_files(i).name);
    imwrite(resized_image, resized_image_path);
    
    % Find the corresponding mask in the 'masks' directory
    mask_dir = fullfile(parent_dir, 'masks_converted');
    mask_files = dir(fullfile(mask_dir, '*.png'));
    mask_index = find(contains({mask_files.name}, extractBefore(image_files(i).name, ".") + ".png"));
    if ~isempty(mask_index)
        % Load the mask
        mask_path = fullfile(mask_dir, mask_files(mask_index).name);
        mask = imread(mask_path);
        
        % Resize the mask
        resized_mask = imresize(mask, target_size);
        
        % Save the resized mask to the new directory
        resized_mask_path = fullfile(resized_masks_dir, mask_files(mask_index).name);
        imwrite(resized_mask, resized_mask_path);
    end
end

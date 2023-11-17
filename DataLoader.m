classdef DataLoader
    methods(Static)
        function [images, masks] = loadDataset(datasetPath)
            % Load images and corresponding masks/labels from the datasetPath
            % Assume images and masks are stored appropriately in the dataset
            
            % Example code to load images and masks
            imageDir = fullfile(datasetPath, 'images');
            maskDir = fullfile(datasetPath, 'masks');
            
            imageFiles = dir(fullfile(imageDir, '*.png')); % Update the file extension as needed
            maskFiles = dir(fullfile(maskDir, '*.png')); % Update the file extension as needed
            
            numImages = numel(imageFiles);
            images = cell(1, numImages);
            masks = cell(1, numImages);
            
            for i = 1:numImages
                imagePath = fullfile(imageDir, imageFiles(i).name);
                maskPath = fullfile(maskDir, maskFiles(i).name);
                
                % Read images and masks
                images{i} = imread(imagePath);
                masks{i} = imread(maskPath);
            end
        end
        
        function preprocessedData = preprocessData(images, masks)
            % Perform preprocessing on the loaded images and masks
            % Apply necessary preprocessing steps (e.g., resizing, normalization)
            
            % Example: Resize images and masks to a fixed size
            imageSize = [256, 256]; % Update to your desired image size
            
            numImages = numel(images);
            preprocessedData = cell(1, numImages);
            
            for i = 1:numImages
                % Resize images
                resizedImage = imresize(images{i}, imageSize);
                
                % Resize masks (if required)
                resizedMask = imresize(masks{i}, imageSize, 'Method', 'nearest');
                
                % Perform any other preprocessing steps
                
                % Store preprocessed data
                preprocessedData{i} = struct('Image', resizedImage, 'Mask', resizedMask);
            end
        end
        
        % Add other data augmentation methods or specific preprocessing functions if needed
    end
end

% Load the trained model
load('trainedRSSNet.mat'); % Load the trained model file

% Load and preprocess the validation/test dataset using DataLoader
valDatasetPath = 'path_to_validation_or_test_dataset_folder';
[valImages, valMasks] = DataLoader.loadDataset(valDatasetPath);
valPreprocessedData = DataLoader.preprocessData(valImages, valMasks);

% Convert data to a format suitable for evaluation (you might need a different format)
imdsVal = imageDatastore({valPreprocessedData.Image});
pxdsVal = pixelLabelDatastore({valPreprocessedData.Mask});

% Perform segmentation using the trained model
predictedMasks = semanticseg(imdsVal, net); % Segment images using the trained model

% Calculate evaluation metrics (Dice coefficient, mIoU, etc.)
metrics = evaluateSegmentation(pxdsVal, predictedMasks);

% Display or save evaluation results
disp('Evaluation Metrics:');
disp(metrics);

% Load the full RSSNet model
load('trainedRSSNet.mat'); % Load the trained model file

% Load and preprocess the validation/test dataset using DataLoader
valDatasetPath = 'path_to_validation_or_test_dataset_folder';
[valImages, valMasks] = DataLoader.loadDataset(valDatasetPath);
valPreprocessedData = DataLoader.preprocessData(valImages, valMasks);

% Convert data to a format suitable for evaluation (you might need a different format)
imdsVal = imageDatastore({valPreprocessedData.Image});
pxdsVal = pixelLabelDatastore({valPreprocessedData.Mask});

% Perform segmentation using the full RSSNet model
fullModelPredictions = semanticseg(imdsVal, net); % Segment images using the full model

% Calculate evaluation metrics for the full model
fullModelMetrics = evaluateSegmentation(pxdsVal, fullModelPredictions);

% Perform ablation by removing or modifying specific components and evaluating the impact
% Example: Removing ASPP from the model
modifiedNet = removeLayers(net, 'asppDepthConcat', 'avgPool', 'convFinal', 'softmax', 'output');
modifiedPredictions = semanticseg(imdsVal, modifiedNet); % Segment images using the modified model

% Calculate evaluation metrics for the modified model
modifiedModelMetrics = evaluateSegmentation(pxdsVal, modifiedPredictions);

% Display or compare the evaluation metrics for the full and modified models
disp('Full Model Evaluation Metrics:');
disp(fullModelMetrics);

disp('Modified Model Evaluation Metrics:');
disp(modifiedModelMetrics);

% Calculate and display the performance difference between the full and modified models
performanceDifference = fullModelMetrics.MetricName - modifiedModelMetrics.MetricName;
disp('Performance Difference:');
disp(performanceDifference);

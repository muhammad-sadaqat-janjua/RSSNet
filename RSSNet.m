clc
clear
dataSetDir = fullfile('C://Users/muham/Pictures/nex/kvid/');


%%
imageDir = fullfile(dataSetDir,'resized_images/');
labelDir = fullfile(dataSetDir,'resized_masks/');

%%
%imageiSize = [320 320];
%augmenter = imageDataAugmenter(imageiSize);
%imds = imageDatastore(imageDir);
%augimds = augmentedImageDatastore(imageiSize,imds);

imds = imageDatastore(imageDir);

%%
classNames = ["instrument","background"];
labelIDs   = [255 0];

%%
%Create a pixelLabelDatastore object to store the ground truth pixel labels for the training images.

pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);

%%
%Create the U-Net network.

imageSize = [320 320 3];
numClasses = 2;
lgraph = unetLayers(imageSize, numClasses)

%%
%Create a datastore for training the network.

ds = combine(imds,pxds);


%%
%Set training options.

options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',20, ...
    'Verbose',1, ...
    'MiniBatchSize', 2, ...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu'); 
    %'VerboseFrequency',10);

%%
% Train the network.

net = trainNetwork(ds,lgraph,options)

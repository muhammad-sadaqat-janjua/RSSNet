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
function net = RSSNet(inputSize, numClasses)
    layers = [
        imageInputLayer(inputSize, 'Name', 'input')
        
        % Convolutional layers
        convolution2dLayer(3, 64, 'Padding', 'same', 'Name', 'conv1')
        reluLayer('Name', 'relu1')
        convolution2dLayer(3, 64, 'Padding', 'same', 'Name', 'conv2')
        reluLayer('Name', 'relu2')
        % Add more convolutional layers as needed
        
        % Atrous Spatial Pyramid Pooling (ASPP)
        asppConv1 = convolution2dLayer(3, 128, 'Padding', 'same', 'Name', 'asppConv1')
        asppConv2 = convolution2dLayer(3, 128, 'Padding', 'same', 'Name', 'asppConv2')
        asppConv3 = convolution2dLayer(3, 128, 'Padding', 'same', 'Name', 'asppConv3')
        asppConv4 = convolution2dLayer(3, 128, 'Padding', 'same', 'Name', 'asppConv4')
        
        % Combine ASPP output
        depthConcatenationLayer(4, 'Name', 'asppDepthConcat')
        
        % Average Pooling
        averagePooling2dLayer('Name', 'avgPool')
        
        % Final convolutional layers and softmax
        convolution2dLayer(3, numClasses, 'Padding', 'same', 'Name', 'convFinal')
        softmaxLayer('Name', 'softmax')
        pixelClassificationLayer('Name', 'output')
    ];

    % Create and connect the layers
    net = layerGraph(layers);

    % Connect ASPP layers
    net = connectLayers(net, 'relu2', 'asppConv1');
    net = connectLayers(net, 'relu2', 'asppConv2');
    net = connectLayers(net, 'relu2', 'asppConv3');
    net = connectLayers(net, 'relu2', 'asppConv4');

    % Connect ASPP outputs
    net = connectLayers(net, 'asppConv1', 'asppDepthConcat/in1');
    net = connectLayers(net, 'asppConv2', 'asppDepthConcat/in2');
    net = connectLayers(net, 'asppConv3', 'asppDepthConcat/in3');
    net = connectLayers(net, 'asppConv4', 'asppDepthConcat/in4');

    % Connect layers for final output
    net = connectLayers(net, 'asppDepthConcat', 'avgPool');
    net = connectLayers(net, 'avgPool', 'convFinal');
    net = connectLayers(net, 'convFinal', 'softmax');
    net = connectLayers(net, 'softmax', 'output');
end


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

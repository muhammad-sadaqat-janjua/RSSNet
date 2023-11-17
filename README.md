# RSSNet
A modified version of U-Net specifically fine-tuned for robotic surgical tool segmentation with Atrous Spatial Pyramid Pooling module.

**Instructions**
- Replace the images/mask path with the dataset parent folders.
- Resize images/mask to the same resolution (if required by your dataset).
- Requires GPU Encoder.

**Steps for Implementation**

**- RSSNet.m:**
- Define the neural network layers, including ASPP, average pooling, and convolutional layers with multiscale kernels. Use MATLAB's Deep Learning Toolbox or custom layer definitions.

**DataLoader.m:**
- Implement functions to load dataset images and annotations, perform preprocessing (such as normalization or resizing), and create data augmentation techniques if needed.

**TrainRSSNet.m:**
- Use DataLoader.m to load training data.
- Define training parameters (epochs, batch size, learning rate, etc.).
- Train the RSSNet model using MATLAB's built-in training functions or custom training loops. Save the trained model weights.

**EvaluateRSSNet.m:**
- Load the trained model weights.
- Load validation or test datasets using DataLoader.m.
- Perform segmentation on these datasets using the trained RSSNet model.
- Compute evaluation metrics like Dice coefficient and mIoU.

**AblationStudy.m:**
- Modify the RSSNet architecture by removing or altering specific components (ASPP, average pooling, etc.) to analyze their impact on segmentation accuracy.
- Run experiments and record performance metrics for comparison.

After creating these files, organize them within a directory structure.

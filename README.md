# PCANet-for-LIF-classification
Matlab code for paper “PCANet A Common Solution for Laser-Induced Fluorescence Spectral Classification”

## Requirements
- Matlab

## Usage
**Step 0** Program description

 - `demo.m` is a sample program
 - `LoadData.m` is a subprogram for importing data.
 - `PCANet_train.m` is a subprogram trained for PCANet
 - `PCA_FilterBank.m` is a subprogram of the PCANet filter
 - `PCANet_FeaExt.m` A is a subprogram for PCANet feature extraction
 - `PCA_output.m` is a subprogram of PCANet output
 - `HashingHist.m` is a subprogram for hash and histogram processing

**Step 1** Modify code
**Step 1.1** Modify `demo.m`

```matlab
%% Input
ImgSizeh = 52;     % high of the input image
ImgSizew = 70;     % width of the input image
ImgFormat = 'gray';	% 'color' or 'gray'

%% Parameters
PCANet.NumStages = 2;           % Number of stages
PCANet.PatchSize = [3 3];       % Filter size  e.g., 3, 5, 7
PCANet.NumFilters = [8 8];      % Number of filters
PCANet.HistBlockSize = [10 10]; % Histogram Block size
PCANet.BlkOverLapRatio = 0;     % Block overlap ratios
```

**Step 1.2** Modify `LoadData.m` 
```matlab
%% Data location
rt_img_dir='..\matconvnet\examples\SizeData\70-52\baijiu\oritraindata';   % Test set directory
rt_img_dir1='..\matconvnet\examples\SizeData\70-52\baijiu\oritestdata';   % Training set directory

%% Format of the training image
frames=dir(fullfile(rt_img_dir,subname,'*.png'));       % Format of the training set picture
trainweed=imresize(trainweed,[52 70]);                % Size of the training set picture H×W

%% Format of the test image
frames1=dir(fullfile(rt_img_dir1,subname1,'*.png'));    % Format of the test set picture
testweed=imresize(testweed,[52 70]);                  % Size of the test set picture H×W
```

**Step 3** Output description

 - PCANet_TrnTime：PCANet training time
 - LinearSVM_TrnTime：Linear SVM training time
 - ErRate：Testing error rate
 - Averaged_TimeperTest：Average testing time per test sample

**Step 4** Training visualization
**Step 4.1** Visualization of PCA filters

 `V.mat` PCANet filters
 
 **Step 4.2** Visualization of extracted features
 
 `PCANet_FeaExt.m`  [f BlkIdx] = HashingHist(PCANet,ImgIdx,OutImg);
 

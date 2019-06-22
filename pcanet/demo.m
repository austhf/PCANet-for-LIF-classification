%% ==== PCANet Demo =======
% Matlab code for paper "PCANet A Common Solution for Laser-Induced Fluorescence Spectral Classification"

%% ========================

clc;
clear;
close all; 
addpath('./Utils');
addpath('./Liblinear');
% addpath('./data');

ImgSizeh = 52; 
ImgSizew = 70; 
% ImgSize = 28;
ImgFormat = 'gray'; %'color' or 'gray'
% ImgFormat = 'color'; %'color' or 'gray'

%% Loading data
fprintf('\n ====== Load Data ======= \n')
tic
[TrnData,TestData,TrnLabels,TestLabels] = LoadData();
TrnData1 = TrnData;
TestData1 = TestData;
toc
% ===========================================================
nTestImg = length(TestLabels);
nTrnImg = length(TrnLabels);

%% PCANet parameters

PCANet.NumStages = 2;
PCANet.PatchSize = [3 3];   % e.g., 3, 5, 7
PCANet.NumFilters = [8 8];
% PCANet.NumFilters = 12;
PCANet.HistBlockSize = [10 10]; 
PCANet.BlkOverLapRatio = 0;
fprintf('\n ====== PCANet Parameters ======= \n')
PCANet

%% PCANet Training
fprintf('\n ====== PCANet Training ======= \n')
TrnData_ImgCell = mat2imgcell(TrnData1,ImgSizeh,ImgSizew,ImgFormat); % convert columns in TrnData to cells 

tic;
[ftrain V BlkIdx] = PCANet_train(TrnData_ImgCell,PCANet,0); % BlkIdx serves the purpose of learning block-wise DR projection matrix; e.g., WPCA
PCANet_TrnTime = toc;
% clear TrnData_ImgCell; 

fprintf('Extracting training image feature...');
TrnData_ImgCell = mat2imgcell(TrnData,ImgSizeh,ImgSizew,ImgFormat);
% clear TrnData; 
[ftrain BlkIdx] = PCANet_FeaExt(TrnData_ImgCell,V,PCANet);

% clear TrnData_ImgCell; 

fprintf('\n ====== Training Linear SVM Classifier ======= \n')
tic;
models = train(TrnLabels, ftrain', '-s 1 -q'); % we use linear SVM classifier (C = 1), calling libsvm library
LinearSVM_TrnTime = toc;
% clear ftrain; 

%% PCANet Feature Extraction and Testing 
TestData_ImgCell = mat2imgcell(TestData,ImgSizeh,ImgSizew,ImgFormat); % convert columns in TestData to cells 
% clear TestData; 

fprintf('\n ====== PCANet Testing ======= \n')

nCorrRecog = 0;
RecHistory = zeros(nTestImg,1);

tic; 
for idx = 1:1:nTestImg
    
    ftest = PCANet_FeaExt(TestData_ImgCell(idx),V,PCANet); % extract a test feature using trained PCANet model 

    [xLabel_est, accuracy, decision_values] = predict(TestLabels(idx),...
        sparse(ftest'), models, '-q'); % label predictoin by libsvm
   
    if xLabel_est == TestLabels(idx)
        RecHistory(idx) = 1;
        nCorrRecog = nCorrRecog + 1;
    end
    
    if 0==mod(idx,nTestImg/100); 
        fprintf('Accuracy up to %d tests is %.2f%%; taking %.2f secs per testing sample on average. \n',...
            [idx 100*nCorrRecog/idx toc/idx]); 
    end 
%     TestData_ImgCell{idx} = [];  
end

Averaged_TimeperTest = toc/nTestImg;
Accuracy = nCorrRecog/nTestImg; 
ErRate = 1 - Accuracy;

%% Results display
fprintf('\n ===== Results of PCANet, followed by a linear SVM classifier =====');
fprintf('\n     PCANet training time: %.2f secs.', PCANet_TrnTime);
fprintf('\n     Linear SVM training time: %.2f secs.', LinearSVM_TrnTime);
fprintf('\n     Testing error rate: %.2f%%', 100*ErRate);
fprintf('\n     Average testing time %.2f secs per test sample. \n\n',Averaged_TimeperTest);
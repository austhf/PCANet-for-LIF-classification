function [Train_DATA,Test_DATA,Train_Label,Test_Label] = LoadData()
rt_img_dir='..\matconvnet\examples\SizeData\70-52\baijiu\oritraindata';
rt_img_dir1='..\matconvnet\examples\SizeData\70-52\baijiu\oritestdata';
subfolders = dir(rt_img_dir);
subfolders1 = dir(rt_img_dir1);
display('load samples');
Train_DATA=[];
Train_Label=[];
Test_DATA=[];
Test_Label=[];
for ii=3:length(subfolders)
    ii
    subname=subfolders(ii).name;
    fprintf(subname);
    frames=dir(fullfile(rt_img_dir,subname,'*.png'));
    c_num=length(frames);
    for jj=1:c_num
        imgpath=fullfile(rt_img_dir,subname,frames(jj).name);
        trainweed=imread(imgpath);
        trainweed=imresize(trainweed,[52,70]);
        trainweed=im2double(trainweed);
        Train_DATA=[Train_DATA,trainweed(:)];
        Train_Label=[Train_Label;ii-2];
    end
    subname1=subfolders1(ii).name;
      fprintf(subname1);
    frames1=dir(fullfile(rt_img_dir1,subname1,'*.png'));
    c_num1=length(frames1);
	for kk=1:c_num1
        imgpath1=fullfile(rt_img_dir1,subname1,frames1(kk).name);
        testweed=imread(imgpath1);
        testweed=imresize(testweed,[52,70]);
        testweed=im2double(testweed);
		Test_DATA=[Test_DATA,testweed(:)];
        Test_Label=[Test_Label;ii-2];
	end
end
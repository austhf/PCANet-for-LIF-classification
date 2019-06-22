function im = im2col_general(varargin)%im2col_general是将图像分割成多个patchsize.

NumInput = length(varargin);
InImg = varargin{1};
patchsize12 = varargin{2}; 

z = size(InImg,3);
im = cell(z,1);
if NumInput == 2
    for i = 1:z
        im{i} = im2colstep(InImg(:,:,i),patchsize12)';
        %分割图像时，每两个之间间隔为[1 1];
        %size(InImg(:,:,i))=[n1 n2 1],patchsize12=[p1 p2];
        %则经过im2colstep(InImg(:,:,i),patchsize12)后，
        %size（image{i}）=[p1*p2 (n1-p1+1)*(n2-p2+1)].
    end
else
    for i = 1:z
        im{i} = im2colstep(InImg(:,:,i),patchsize12,varargin{3})';%分割图像时，每两个之间间隔为varargin{3}
    end 
end
im = [im{:}]';%im{:}=[im{1},im{2},im{3}];
    
        
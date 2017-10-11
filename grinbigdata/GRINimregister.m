%% GRINimregister

% IMAGES PROCESSING STEPS ALREADY PERFORMED
% smoothimg
% cropimg
% IMG = imresize(IMG, 1/5 , 'bilinear');
% reshapeData
% alignCSframes
% timepointMeans

% save('IM.mat','IM','-v6')

%% PURGE RAM
clc; close all; clear

cd '/Users/bradleymonk/Documents/MATLAB/myToolbox/LAB/grin/grindata/GRIN_COMPRESSED';

[str,maxsize] = computer;
if strcmp(str,'MACI64')
    [SYSRAM.pso,SYSRAM.ps] = system('ps -caxm -orss,comm');
    [SYSRAM.vmo,SYSRAM.vm] = system('vm_stat');
    [TXTmatch,TXTnon] = strsplit(SYSRAM.ps,{'[0-9]+\S '},...
    'CollapseDelimiters',true,'DelimiterType','RegularExpression');
    RAM = sum(str2num([TXTnon{1,:}])') /1024/1024;
end
if strcmp(str,'MACI64') && RAM > 7
    disp(' '); disp('Purging RAM'); 
    system('sudo purge'); 
end
clear


%% GET PATHS TO GRIN DATA MAT FILES
clc; close all; clear

datafilepath = uigetdir;
regexpStr = '((\S)+(\.mat+))';
allfileinfo = dir(datafilepath);
allfilenames = {allfileinfo.name};
r = regexp(allfilenames,regexpStr);                        
datafiles = allfilenames(~cellfun('isempty',r));      
datafiles = reshape(datafiles,size(datafiles,2),[]);
datapaths = fullfile(datafilepath,datafiles);
disp(' '); fprintf('   %s \r',  datafiles{:} ); disp(' ')
disp(' '); fprintf('   %s \r',  datapaths{:} ); disp(' ')
clearvars -except datapaths datafiles




%% IMPORT DATASETS INTO CELL STRUCT

% IMPORT DATASETS
DATA = {};

for nn = 1:size(datapaths,1)

    DATA{nn} = load(datapaths{nn});

end






%% NORMALIZE GREEN - RED CHANNEL STACKS


for nn = 1:size(DATA,2)

    IM = DATA{nn}.IMGC - DATA{nn}.IMRC;

    DATA{nn}.IMG = IM;
end

clearvars -except DATA






%% SAVE GREEN CHANNEL IMAGES INTO IM

IM = zeros(size(DATA{1}.IMG,1),size(DATA{1}.IMG,2),size(DATA,2));

for mm = 1:size(DATA,2)

    I = DATA{mm}.IMG;
    IM(:,:,mm) = mean(mean(I,4),3);

end


clearvars -except datapaths datafiles DATA IM



%% PREVIEW IMAGE STACK

fh1=figure('Units','normalized','OuterPosition',[.1 .1 .4 .6],'Color','w','MenuBar','none');
hax1 = axes('Position',[.05 .05 .9 .9],'Color','none');

ph1 = imagesc(IM(:,:,1)); pause(1)

for nn = 1:size(IM,3)
    fprintf('Stack: % .0f \n',nn)
    ph1.CData = IM(:,:,nn);
    pause(.5)
end


clearvars -except datapaths datafiles DATA IM
% clearvars -except datapaths datafiles DATA IM AlignVals IMGG IMGA IMA


%% SHOW MONTAGE OF IMAGES

% imaqmontage(data, 'Parent', a);

close all
fh1=figure('Units','normalized','OuterPosition',[.05 .06 .9 .9],'Color','w','MenuBar','none');
hax1 = axes('Position',[.05 .05 .9 .9],'Color','none'); %hold on;

clc
disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
disp('CLOSE WINDOW WHEN READY TO CONTINUE')
disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
disp(' ')

% montage(I) displays all the frames of a multiframe image array I in a 
% single image object. I can be a sequence of binary, grayscale, or 
% truecolor images. A binary or grayscale image sequence must be an 
% M-by-N-by-1-by-K array. A truecolor image sequence must be an 
% M-by-N-by-3-by-K array.

I = mat2gray(reshape(IM,40,40,1,[]));

montage(I,'Parent',hax1, 'Size', [NaN 5],...
         'DisplayRange',[(min(I(:))-(max(I(:)) - min(I(:)))/8)  max(I(:))])
uiwait


clc; disp('CHOOSE TWO ALIGNMENT LANDMARKS'); disp(' ')






%% GET ALIGNMENT VALUES
close all;

AlignVals.P1x = zeros(size(IM,3),1);
AlignVals.P1y = zeros(size(IM,3),1);
AlignVals.P2x = zeros(size(IM,3),1);
AlignVals.P2y = zeros(size(IM,3),1);


for nn = 1:size(IM,3)

I = IM(:,:,nn);

close all;

fhIMA=figure('Units','normalized','OuterPosition',[.1 .1 .6 .8],'Color','w','MenuBar','none');
haxIMA = axes('Position',[.05 .05 .9 .9],'Color','none','XTick',[],'YTick',[]);

axes(haxIMA)
% phG = imagesc(I,'Parent',haxIMA,'CDataMapping','scaled');
phG = imshowpair(IM(:,:,1), I,'Scaling','joint');

[cmax, cmaxi] = max(I(:));
[cmin, cmini] = min(I(:));
cmax = cmax - abs(cmax/12);
cmin = cmin + abs(cmin/12);
haxIMA.CLim = [cmin cmax];


% SELECT TWO ROI POINTS
hAP1 = impoint;
hAP2 = impoint;

AP1pos = hAP1.getPosition;
AP2pos = hAP2.getPosition;

imellipse(haxIMA, [AP1pos-2 4 4]); pause(.1);
imellipse(haxIMA, [AP2pos-2 4 4]); pause(.1);

pause(.5);
close(fhIMA)


fprintf('ALIGNMENT POINTS \n');
fprintf('P1(X,Y): \t    %.2f \t    %.2f \n',AP1pos);
fprintf('P2(X,Y): \t    %.2f \t    %.2f \n',AP2pos);


AlignVals.P1x(nn) = AP1pos(1);
AlignVals.P1y(nn) = AP1pos(2);
AlignVals.P2x(nn) = AP2pos(1);
AlignVals.P2y(nn) = AP2pos(2);

end


clearvars -except datapaths datafiles DATA IM AlignVals





%% USE ALIGNMENT VALUES FOR TRANSLATION


MASTER1x = AlignVals.P1x(1);
MASTER1y = AlignVals.P1y(1);
MASTER2x = AlignVals.P2x(1);
MASTER2y = AlignVals.P2y(1);

IMx = AlignVals.P1x;
IMy = AlignVals.P1y;

% tX = IMx - MASTER1x;
% tY = IMy - MASTER1y;

tX = MASTER1x - IMx;
tY = MASTER1y - IMy;



IMGG={};
for mm = 1:size(DATA,2)
    IMGG{mm} = DATA{mm}.IMGC;
end


IMGA={};
for i = 1:size(IM,3)

    I = IMGG{i};

    IMGA{i} = imtranslate(I,[tX(i), tY(i)],'FillValues',mean(I(:)),'OutputView','same');

end


clearvars -except datapaths datafiles DATA IM AlignVals IMGG IMGA





%% SAVE ALIGNED GREEN CHANNEL IMAGES INTO IMA

IMA = zeros(size(IMGA{1},1),size(IMGA{1},2),size(IMGA,2));

for mm = 1:size(IMA,3)

    I = IMGA{mm};
    IMA(:,:,mm) = mean(mean(I,4),3);

end


clearvars -except datapaths datafiles DATA IM AlignVals IMGG IMGA IMA





%% CROP TRANSLATED STACKS

I = IMA(3:32,5:35,:);

close all
fh1=figure('Units','normalized','OuterPosition',[.1 .1 .4 .6],'Color','w','MenuBar','none');
hax1 = axes('Position',[.05 .05 .9 .9],'Color','none');

ph1 = imagesc(I(:,:,1)); pause(1)


for nn = 1:7

    ph1.CData = I(:,:,nn);
    pause(1)

end


%% Write to TIFF file
%{.

% imagesc(I(:,:,1))

I = mat2gray(IMA);
imwrite(I(:,:,1), 'stack.tif'); % tif compression is lossless by default
for k = 1:size(I,3)
    imwrite(I(:,:,k), 'stack.tif', 'writemode', 'append');
end



numrows = size(IMA,1);
numcols = size(IMA,2);
alpha = 255*ones([numrows numcols], 'uint8');
data = cat(3,IMA,alpha);


t = Tiff('myfile.tif','w');
tagstruct.ImageLength = size(IMA,1)
tagstruct.ImageWidth = size(IMA,2)
% tagstruct.Photometric = Tiff.Photometric.RGB
tagstruct.BitsPerSample = 8
tagstruct.SamplesPerPixel = size(IMA,3)
tagstruct.RowsPerStrip = size(IMA,1)
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky
tagstruct.Software = 'MATLAB'
t.setTag(tagstruct)

width = t.getTag('ImageWidth');
height = t.getTag('RowsPerStrip');
numSamples = t.getTag('SamplesPerPixel');
stripData = zeros(height,width,numSamples,'uint8');

t.writeEncodedStrip(1, stripData);

t.write(data);
t.close();
%}

%% PREVIEW TRANSLATED IMAGE STACK
close all

fh1=figure('Units','normalized','OuterPosition',[.1 .1 .4 .6],'Color','w','MenuBar','none');
hax1 = axes('Position',[.05 .05 .9 .9],'Color','none');

ph1 = imagesc(IMA(:,:,1)); pause(1)

im={};
for nn = 1:size(IMA,3)
    fprintf('Stack: % .0f \n',nn)
    ph1.CData = IMA(:,:,nn);

    pause(.5)
    frame = getframe(1);
    im{nn} = frame2im(frame);
    pause(.5)
end

% clearvars -except datapaths datafiles DATA IM AlignVals IMGG IMGA IMA im



%% SAVE STACK PREVIEW AS ANIMATED GIF

filename = 'testAnimated.gif'; % Specify the output file name
for idx = 1:size(im,2)
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',1);
    end
end


clearvars -except datapaths datafiles DATA IM AlignVals IMGG IMGA IMA im





%% DISPLAY IMAGE GRADIENTS IN XYZ DIRECTIONS

I = mat2gray(reshape(IM,40,40,1,[]));

[Gx, Gy, Gz] = imgradientxyz(IM);

close all
fh1=figure('Units','normalized','OuterPosition',[.05 .06 .9 .9],'Color','w','MenuBar','none');
hax1 = axes('Position',[.05 .05 .9 .9],'Color','none'); %hold on;

montage(reshape(Gx,size(IM,1),size(IM,2),1,size(IM,3)),...
        'Parent',hax1, 'Size', [NaN 5], 'DisplayRange',[])

fh2=figure('Units','normalized','OuterPosition',[.05 .06 .9 .9],'Color','w','MenuBar','none');
hax2 = axes('Position',[.05 .05 .9 .9],'Color','none'); %hold on;

montage(reshape(Gy,size(IM,1),size(IM,2),1,size(IM,3)),...
        'Parent',hax2, 'Size', [NaN 5], 'DisplayRange',[])

fh3=figure('Units','normalized','OuterPosition',[.05 .06 .9 .9],'Color','w','MenuBar','none');
hax3 = axes('Position',[.05 .05 .9 .9],'Color','none'); %hold on;

montage(reshape(Gz,size(IM,1),size(IM,2),1,size(IM,3)),...
        'Parent',hax3, 'Size', [NaN 5], 'DisplayRange',[])


%%
% close all
% fh1=figure('Units','normalized','OuterPosition',[.05 .1 .9 .6],'Color','w','MenuBar','none');
% hax1 = axes('Position',[.05 .05 .45 .9],'Color','none'); %hold on;
% hax2 = axes('Position',[.52 .05 .45 .9],'Color','none'); %hold on;
% 
% axes(hax1)
% ih1 = imagesc(I(:,:,1));
% 
% axes(hax2)
% ih2 = imagesc(I(:,:,3));
% 
% CL1 = hax1.CLim
% CL2 = hax2.CLim
% 
% hax1.CLim = [min([CL1 CL2])     max([CL1 CL2])  ]
% hax2.CLim = [min([CL1 CL2])     max([CL1 CL2])  ]

function [] = matfiji(IMG, GRINstruct, XLSdata, LICK, varargin)

% web('http://bigwww.epfl.ch/sage/soft/mij/')
% web('http://imagej.net/Miji')


msgbox('UNDER CONSTRUCTION. COME BACK SOON!');
return

[str,maxsize,endian] = computer;


if strcmp(str,'PCWIN') || strcmp(str,'PCWIN64')
    
    javaaddpath 'C:\Program Files\MATLAB\R2014b\java\jar\mij.jar'
    javaaddpath 'C:\Program Files\MATLAB\R2014b\java\jar\ij.jar'
    MIJ.start('E:\Program Files (x86)\ImageJ')
    MIJ.setupExt('E:\Program Files (x86)\ImageJ');


    % strr1=strcat('open=[Y:\\ShareData\\LABMEETINGS\\Steve\\GRIN lens data\\RM\\*.tif] starting=1 increment=1 scale=100 file=Ch2 or=[] sort');
    % MIJ.run('Image Sequence...', strr1); %works!! will generate tif stack in imageJ

    MIJ.createImage('result', IMG, true);
    
end


if strcmp(str,'MACI64')
    
    
    addpath('/Applications/Fiji.app/scripts');
    addpath '/Applications/Fiji.app/plugins';
    javaaddpath '/Applications/Fiji.app/plugins';
    javaaddpath '/Applications/MATLAB_R2014b.app/java/jar/mij.jar';
    javaaddpath '/Applications/MATLAB_R2014b.app/java/jar/ij.jar';
    MIJ.start('/Applications/Fiji');
    % MIJ.setupExt('/Applications/Fiji');
    
    strr1=strcat('open=[/Users/bradleymonk/Documents/MATLAB/myToolbox/LAB/grin/gcdata/gc33_111715g.tif]');
    MIJ.run('Image Sequence...', strr1); %works!! will generate tif stack in imageJ
    
    MIJ.createImage('result', IMG, true);
    
    
    MIJ.exit
    
end


    
    
%     fhij=figure('Units','normalized','OuterPosition',[.02 .4 .2 .3],'Color','w');
%     annotation(fhij,'textbox',[0.05 0.05 0.9 0.9],...
%     'String',{'Close this window when done working with FIJI'},...
%     'FontSize',18,'FontName','Helvetica','FitBoxToText','off');
%     
%     uiwait
%     MIJ.exit
    
    
    


end





%%




















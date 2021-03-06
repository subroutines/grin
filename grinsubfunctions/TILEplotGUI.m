function TILEplotGUI(axdat, GRINstruct, XLSdata, LICK, varargin)
% disableButtons; pause(.02);

global GhaxGRIN GimgsliderYAH GimgsliderYBH GimgsliderXAH GimgsliderXBH
global slideValYA slideValYB slideValXA slideValXB
slideValYA = 0.15;
slideValYB = -0.15;
slideValXA = 100;
slideValXB = 0;
global GupdateGraphH Gcheckbox1H Gcheckbox2H Gcheckbox3H Gcheckbox4H
global Gcheckbox5H Gcheckbox6H Gcheckbox7H GhaxLCK GhaxBG


global CSUSvals toglick
CSUSvals = unique(GRINstruct.csus);
toglick = 0;


%% -------- MAIN FIGURE WINDOW --------   
% close(graphguih)
% mainguih.CurrentCharacter = '+';
graphguih = figure('Units', 'normalized','Position', [.02 .1 .85 .65], 'BusyAction',...
    'cancel', 'Name', 'mainguih', 'Tag', 'graphguih','MenuBar', 'none'); 



maxY = max(max(max([axdat(3:end).YData])));
minY = min(min(min([axdat(3:end).YData])));
rmaxY = round(maxY,3);
rminY = round(minY,3);



GhaxBG = axes('Parent', graphguih, 'NextPlot', 'replacechildren',...
    'Position', [0.05 0.08 0.55 0.85],'XColor','none','YColor','none',...
    'Color','none','YAxisLocation','right','YTickLabel','none','XTickLabel',' ',...
    'XLimMode', 'manual','YLimMode', 'manual');
    GhaxBG.YLim = [1 500];
    GhaxBG.XLim = [1 500];
    colormap(bone)
    hold on;


GhaxLCK = axes('Parent', graphguih, 'NextPlot', 'replacechildren',...
    'Position', [0.05 0.08 0.55 0.85],'XColor','none','YColor','none',...
    'Color','none','YAxisLocation','right','YTickLabel','none','XTickLabel',' ',...
    'YLimMode', 'manual');
    GhaxLCK.YLim = [0 130];
    hold on

GhaxGRIN = axes('Parent', graphguih, 'NextPlot', 'replacechildren',...
    'Position', [0.05 0.08 0.55 0.85],'Color','none',...
    'XLimMode', 'manual','YLimMode', 'manual');

    if rmaxY > .150
        GhaxGRIN.YLim = [-.15 rmaxY];
    else
        GhaxGRIN.YLim = [-.15 .15];
    end
    GhaxGRIN.XLim = [1 numel([axdat(3).YData])];


GimgsliderYAH = uicontrol('Parent', graphguih, 'Units', 'normalized','Style','slider',...
	'Max',1,'Min',0,'Value',.15,'SliderStep',[0.01 0.10],...
	'Position', [-.01 0.62 0.03 0.30], 'Callback', @GimgsliderYA);

GimgsliderYBH = uicontrol('Parent', graphguih, 'Units', 'normalized','Style','slider',...
	'Max',0,'Min',-1,'Value',-.15,'SliderStep',[0.01 0.10],...
	'Position', [-.01 0.08 0.03 0.30], 'Callback', @GimgsliderYB);

GimgsliderXAH = uicontrol('Parent', graphguih, 'Units', 'normalized','Style','slider',...
	'Max',200,'Min',0,'Value',100,'SliderStep',[0.01 0.10],...
	'Position', [0.40 0.01 0.20 0.03], 'Callback', @GimgsliderXA);

GimgsliderXBH = uicontrol('Parent', graphguih, 'Units', 'normalized','Style','slider',...
	'Max',200,'Min',0,'Value',1,'SliderStep',[0.01 0.10],...
	'Position', [0.05 0.01 0.20 0.03], 'Callback', @GimgsliderXB);


%----------------------------------------------------
%           IMAGE PROCESSING PANEL
%----------------------------------------------------

tabgp = uitabgroup(graphguih,'Position',[0.61 0.02 0.38 0.95]);
btabs = uitab(tabgp,'Title','Graphics Options');
dtabs = uitab(tabgp,'Title','Data View');


GIPpanelH = uipanel('Parent', btabs,'Title','Graph Options','FontSize',10,...
    'BackgroundColor',[.95 .95 .95],...
    'Position', [0.02 0.25 0.45 0.73]); % 'Visible', 'Off',


plotLickDataH = uicontrol('Parent', GIPpanelH, 'Units', 'normalized', ...
    'Position', [.05 0.88 .90 .10], 'FontSize', 13, 'String', 'Plot Lick Data',...
    'Callback', @plotLickData, 'Enable','on');

chva = 1;

if size(CSUSvals,1) > 0
Gcheckbox1H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.71 .90 .05] ,'String',CSUSvals(1), 'Value',1,'Callback',{@plot_callback,1});
end
if size(CSUSvals,1) > 1
Gcheckbox2H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.61 .90 .05] ,'String',CSUSvals(2), 'Value',chva,'Callback',{@plot_callback,2});
end
if size(CSUSvals,1) > 2
Gcheckbox3H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.51 .90 .05] ,'String',CSUSvals(3), 'Value',chva,'Callback',{@plot_callback,3});
end
if size(CSUSvals,1) > 3
Gcheckbox4H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.41 .90 .05] ,'String',CSUSvals(4), 'Value',chva,'Callback',{@plot_callback,4});
end
if size(CSUSvals,1) > 4 
Gcheckbox5H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.31 .90 .05] ,'String',CSUSvals(5), 'Value',chva,'Callback',{@plot_callback,5});
end
if size(CSUSvals,1) > 5
Gcheckbox6H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.21 .90 .05] ,'String',CSUSvals(6), 'Value',chva,'Callback',{@plot_callback,6});
end
if size(CSUSvals,1) > 6
Gcheckbox7H = uicontrol('Parent', GIPpanelH,'Style','checkbox','Units','normalized',...
    'Position', [.05 0.11 .90 .05] ,'String',CSUSvals(7), 'Value',chva,'Callback',{@plot_callback,7});
end



%%              
%----------------------------------------------------
%    CUSTOM FUNCTIONS PANEL
%----------------------------------------------------
GcustomfunpanelH = uipanel('Parent', btabs,'Title','Custom Code & Data Exploration','FontSize',10,...
    'BackgroundColor',[.95 .95 .95],...
    'Position', [0.50 0.64 0.45 0.34]); % 'Visible', 'Off',
              
GrunCustomAH = uicontrol('Parent', GcustomfunpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.73 0.95 0.20], 'FontSize', 13, 'String', 'Custom Function A',...
    'Callback', @GrunCustomA, 'Enable','off');

GrunCustomBH = uicontrol('Parent', GcustomfunpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.50 0.95 0.20], 'FontSize', 13, 'String', 'Custom Function B',...
    'Callback', @GrunCustomB, 'Enable','off');

GrunCustomCH = uicontrol('Parent', GcustomfunpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.26 0.95 0.20], 'FontSize', 13, 'String', 'Custom Function C',...
    'Callback', @GrunCustomC, 'Enable','off');

GrunCustomDH = uicontrol('Parent', GcustomfunpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.03 0.95 0.20], 'FontSize', 13, 'String', 'Custom Function D',...
    'Callback', @GrunCustomD, 'Enable','off');





%----------------------------------------------------
%    DATA EXPLORATION & API PANEL
%----------------------------------------------------
GexplorepanelH = uipanel('Parent', btabs,'Title','Data Exploration & API','FontSize',10,...
    'BackgroundColor',[.95 .95 .95],...
    'Position', [0.50 0.25 0.45 0.34]); % 'Visible', 'Off',
              
GopenImageJH = uicontrol('Parent', GexplorepanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.73 0.95 0.20], 'FontSize', 13, 'String', 'Open stack in ImageJ ',...
    'Callback', @GopenImageJ, 'Enable','off');

GexploreAH = uicontrol('Parent', GexplorepanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.50 0.95 0.20], 'FontSize', 13, 'String', 'Explore Data A',...
    'Callback', @GexploreA, 'Enable','off');

GexploreBH = uicontrol('Parent', GexplorepanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.26 0.95 0.20], 'FontSize', 13, 'String', 'Explore Data B',...
    'Callback', @GexploreB, 'Enable','off');

GresetwsH = uicontrol('Parent', GexplorepanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.03 0.95 0.20], 'FontSize', 13, 'String', 'Reset Toolbox',...
    'Callback', @Gresetws);



%----------------------------------------------------
%    SAVE AND EXPORT DATA
%----------------------------------------------------
GexportpanelH = uipanel('Parent', btabs,'Title','I/O','FontSize',10,...
    'BackgroundColor',[.95 .95 .95],...
    'Position', [0.50 0.02 0.45 0.20]); % 'Visible', 'Off',
              
GexportvarsH = uicontrol('Parent', GexportpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.65 0.95 0.28], 'FontSize', 13, 'String', 'Export Vars to Workspace ',...
    'Callback', @Gexportvars, 'Enable','off');

GsavedatasetH = uicontrol('Parent', GexportpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.34 0.95 0.28], 'FontSize', 13, 'String', 'Save Dataset',...
    'Callback', @Gsavedataset, 'Enable','off');

GloadmatdataH = uicontrol('Parent', GexportpanelH, 'Units', 'normalized', ...
    'Position', [0.03 0.03 0.95 0.28], 'FontSize', 13, 'String', 'Load .mat Dataset',...
    'Callback', @Gloadmatdata, 'Enable','off');



%----------------------------------------------------
%        IMAGE SIDER CALLBACK
%----------------------------------------------------
function GimgsliderYA(hObject, eventdata)
slideValYA = GimgsliderYAH.Value;
GhaxGRIN.YLim = [slideValYB slideValYA];
end

function GimgsliderYB(hObject, eventdata)
slideValYB = GimgsliderYBH.Value;
GhaxGRIN.YLim = [slideValYB slideValYA];
end


function GimgsliderXA(hObject, eventdata)
slideValXA = GimgsliderXAH.Value;
GhaxGRIN.XLim = [slideValXB slideValXA];
end

function GimgsliderXB(hObject, eventdata)
slideValXB = GimgsliderXBH.Value;
GhaxGRIN.XLim = [slideValXB slideValXA];
end


%----------------------------------------------------
%        UPDATE GRAPH CALLBACK
%----------------------------------------------------
function GupdateGraph(boxidselecth, eventdata)

    return

    if Gcheckbox1H.Value
        smoothimg
    end
    
    if Gcheckbox2H.Value
        cropimg
    end
    
    if Gcheckbox3H.Value
        imgblocks
    end

    if Gcheckbox4H.Value
        reshapeData
    end

    if Gcheckbox5H.Value
        alignCSframes
    end

    if Gcheckbox6H.Value
        dFoverF
    end

    if Gcheckbox7H.Value
        timepointMeans
    end

     
end











%----------------------------------------------------
%        CREATE DATA TABLE
%----------------------------------------------------

XDat = [axdat(3:end).XData];
YDat = [axdat(3:end).YData];

XDat = fliplr(reshape(XDat,[],(size(axdat,1)-2)));
YDat = fliplr(reshape(YDat,[],(size(axdat,1)-2)));

tablesize = size(YDat);
colnames = CSUSvals;
colfmt = repmat({'numeric'},1,length(colnames));
coledit = zeros(1,length(colnames))>1;
colwdt = repmat({100},1,length(colnames));




htable = uitable('Parent', dtabs,'Units', 'normalized',...
                 'Position', [0.02 0.02 0.95 0.95],...
                 'Data',  YDat,... 
                 'ColumnName', colnames,...
                 'ColumnFormat', colfmt,...
                 'ColumnWidth', colwdt,...
                 'ColumnEditable', coledit,...
                 'ToolTipString',...
                 'Select cells to highlight them on the plot',...
                 'CellSelectionCallback', {@select_callback});






%----------------------------------------------------
%    PLOT DOT MARKERS AND MAKE THEM INVISIBLE
%----------------------------------------------------
hmkrs = plot(GhaxGRIN, YDat, 'LineStyle', 'none',...
                    'Marker', '.',...
                    'MarkerSize',45);
                

leg1 = legend(hmkrs,unique(GRINstruct.csus));
	set(leg1, 'Location','NorthWest', 'Color', [1 1 1],'FontSize',12,'Box','off');
    set(leg1, 'Position', leg1.Position .* [1 .94 1 1.4])                
                
set(hmkrs,'Visible','off','HandleVisibility', 'off')                
                
                
%----------------------------------------------------
%    PLOT CS ON / OFF POINTS
%----------------------------------------------------                
    csonoffx = [axdat(1:2).XData];
    csonoffy = [axdat(1:2).YData];
    csonoffx = reshape(csonoffx,[],2);
    csonoffy = reshape(csonoffy,[],2);                
                
plot(GhaxGRIN, csonoffx, csonoffy, 'Color',[.5 .5 .5],'HandleVisibility', 'off');                





%------------------------------------------------------------------------------
%        MAIN FUNCTION PROCESSES
%------------------------------------------------------------------------------

    tv1 = axdat;
    
    tv2 = [tv1(3:end).XData];
    tv3 = [tv1(3:end).YData];
    
    tv2 = fliplr(reshape(tv2,[],(size(tv1,1)-2)));
    tv3 = fliplr(reshape(tv3,[],(size(tv1,1)-2)));
    
    tv4 = [tv1(1:2).XData];
    tv5 = [tv1(1:2).YData];
    
    tv4 = reshape(tv4,[],2);
    tv5 = reshape(tv5,[],2);
        
    CSUSvals = unique(GRINstruct.csus);

    hp = plot(GhaxGRIN, tv2, tv3 , 'LineWidth',2);
    
    pause(1)
    
                            
%----------------------------------------------------
%        MAKE LINE PLOT OF DATA FROM COLUMN 1
%----------------------------------------------------

axdata = hp;
for cc = 1:size(axdata,1)

    colorz{cc} = axdata(cc).Color;
    % colors = {'b','m','r','y','c','k'}; % Use consistent color for lines
end

    set(hp,'Visible','off','HandleVisibility', 'off')
    


GhaxGRIN.NextPlot = 'Add';

for nn = 1:size(htable.Data,2)
    
	plot(GhaxGRIN, htable.Data(:,nn),...
        'DisplayName', htable.ColumnName{nn}, 'Color', colorz{nn}, 'LineWidth',2);

end

%     plot(GhaxGRIN, htable.Data(:,nn),...
%           'DisplayName', htable.ColumnName{1}, 'Color', colorz{nn}, 'LineWidth',2);


%----------------------------------------------------
%     CALLBACK FUNCTIONS FOR UPDATING PLOT
%----------------------------------------------------
    function plot_callback(hObject, eventdata, column)

        % htable.ColumnName{column}

    if (hObject.Value)
        
        GhaxGRIN.NextPlot = 'Add';

        plot(GhaxGRIN, htable.Data(:,column),...
            'DisplayName', htable.ColumnName{column},...
            'Color', colorz{column}, 'LineWidth',2);
    else
        delete(findobj(GhaxGRIN, 'DisplayName', htable.ColumnName{column}))
    end
    end


    function select_callback(hObject, eventdata)
        
        set(hmkrs, 'Visible', 'off') % turn them off to begin
        
        sel = eventdata.Indices;
                                
        selcols = unique(sel(:,2));
        table = hObject.Data;
        
        for idx = 1:numel(selcols)
            col = selcols(idx);
            xvals = sel(:,1);
            xvals(sel(:,2) ~= col) = [];
            
            if col <= size(table,2)
                yvals = table(xvals, col)';
                % Create Z-vals = 1 in order to plot markers above lines
                zvals = col*ones(size(xvals));
                % Plot markers for xvals and yvals using a line object
                hmkrs(col).Visible = 'on';
                hmkrs(col).XData = xvals;
                hmkrs(col).YData = yvals;
                hmkrs(col).ZData = zvals;
            end
            
        end
    end









%------------------------------------------------------------------------------
%        PLOT LICKING DATA
%------------------------------------------------------------------------------
function plotLickData(hObject, eventdata)
    
	if toglick == 1
        if isvalid(GhaxLCK)
            delete(GhaxLCK.Children)
            %delete(LhaxGRIN)
            delete(GhaxBG.Children)
            %delete(GhaxLCK)
            
            
        end
        
        toglick = 0;
        return
	end
    toglick = 1;
    
%     lickfigh = figure('Units', 'normalized','Position', [.02 .05 .50 .32], 'BusyAction',...
%     'cancel', 'Name', 'lickfigh', 'Tag', 'lickfigh','MenuBar', 'none'); 
% 
%     LhaxGRIN = axes('Parent', lickfigh, 'NextPlot', 'replacechildren',...
%     'Position', [0.05 0.05 0.9 0.9],'Color','none'); hold on;
% 
%     LhaxGRIN.ColorOrderIndex = 1;
%     
% hpLick = plot(LhaxGRIN, LICK' , ':', 'LineWidth',2,'HandleVisibility', 'off');
%     
%     
%     legLick = legend(hpLick,XLSdata.CSUSvals);
% 	set(legLick, 'Location','NorthWest', 'Color', [1 1 1],'FontSize',12,'Box','off');
%     set(legLick, 'Position', legLick.Position .* [1 .94 1 1.4])      
    
    %-----------------------------------
    %    PLOT LICK DATA
    %-----------------------------------
    axes(GhaxLCK); hold on;
    GhaxLCK.ColorOrderIndex = 1;
    plot(GhaxLCK, LICK' , ':', 'LineWidth',3);
    
    
    
    %-----------------------------------
    %    PLOT CS ON/OFF LINES
    %-----------------------------------
    CSonsetFrame = round(XLSdata.CSonsetDelay .* XLSdata.framesPerSec);
    CSoffsetFrame = round((XLSdata.CSonsetDelay+XLSdata.CS_length) .* XLSdata.framesPerSec);
    line([CSonsetFrame CSonsetFrame],GhaxLCK.YLim,...
    'Color',[.52 .52 .52],'Parent',GhaxLCK,'LineWidth',2)
    line([CSoffsetFrame CSoffsetFrame],GhaxLCK.YLim,...
    'Color',[.5 .5 .5],'Parent',GhaxLCK,'LineWidth',2)
    pause(.02)
    
    
    % toggleGridOverlay()
    axes(GhaxBG);
    bg = ones(500);
    bg(1) = 0;
    imagesc(bg,'Parent',GhaxBG,'CDataMapping','scaled','AlphaData',0.7)
    % GhaxLCK.Color = [.3 .3 .3];
    
    axes(GhaxLCK);
    pause(.2)
    
    
    
   
end











end

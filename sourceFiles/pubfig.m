classdef pubfig < handle
% PUBFIG - class for Publication-Quality-Figures in MATLAB
% Class representing matlab figures with publication layout.
% Grabs excisting matlab figure class and creates pubfig class
% figures with publication layout properties (see list).
% Layout properties are displayed and can be easily adapted by user.
%
% Author: Thomas Beauduin, The University of Tokyo, 2017

%% CLASS PROPERTIES
% Public Properties
properties (Dependent = true)
    % 1. Figure Properties
    FigDim
    % 2. Axis Properties
    AxisBox, AxisWidth, AxisColor
    Grid, MinorGrid
    XTick, XTickLabel, YTick, YTickLabel
    ZTick, ZTickLabel, TickDir, MinorTick
    % 3. Font Properties
    FontName, FontSize, Interpreter
    % 4. Line Properties
    LineWidth, LineStyle, MarkerSize
    %. 5. Legend Properties
    LegendBox, LegendLoc, LegendPos, LegendOrient
    
end

% Private Properties
properties(Hidden, SetAccess = private)
    hfig                        % figure handle
    haxis                       % axis handle
    hleg                        % illustration handle
    htext                       % annotation handle
    hplot                       % chart handle
    hline, nrofl                % primitive line handle
    htitle, hxlabel             % label handle
    hylabel, hzlabel
end

%% MAIN FUNCTION
methods
    function cls = pubfig(varargin)

    cls.hfig = varargin{1};
    if nargin > 1, options = load(varargin{2});
    else           options = load('figDefaultProperties.mat');
    end
    
    if verLessThan('matlab','8.4')  % before 2014b
        hAllAxis = findobj(cls.hfig,'type','axes');
        cls.hleg = findobj(hAllAxis,'tag','legend');
        cls.haxis = setdiff(hAllAxis,cls.hleg);
        hAllText = findobj(cls.hfig,'Type','Text');
        cls.htext = setdiff(hAllText,cls.hleg);
    else                            % after 2014b
        cls.haxis = findobj(cls.hfig,'type','axes');
        cls.hleg = findobj(cls.hfig,'type','legend');
        cls.htext = findobj(cls.hfig,'Type','Text');
    end
    
    for k=1:length(cls.haxis)   % axis data handles
        cls.hplot = [cls.hplot; get(cls.haxis(k), 'Children')];
        cls.hline = [cls.hline; findobj(cls.haxis(k),'Type','Line')];
        cls.nrofl(k) = length(findobj(cls.haxis(k),'Type','Line'));
        cls.htitle(k) = get(cls.haxis(k), 'Title');
        cls.hxlabel(k) = get(cls.haxis(k), 'XLabel');
        cls.hylabel(k) = get(cls.haxis(k), 'YLabel');
        cls.hzlabel(k) = get(cls.haxis(k), 'ZLabel');
    end
    
    % set properties
    pn_vec = properties(cls);
    fn_vec = fieldnames(options);
    for i=1:length(fn_vec)
        for j=1:length(pn_vec)
            if strcmp(fn_vec{i},pn_vec{j})
                cls.(fn_vec{i}) = options.(fn_vec{i});
            end
        end
    end
    end
end

methods
    %% FIGURE PROPERTIES
    function set.FigDim(cls, value)
        set(cls.hfig,'Units', 'centimeters');
        set(0,'Units','centimeters');
        monitor = get(0,'MonitorPositions');
        pos = [monitor(1,3)/2-value(1)/2, monitor(1,4)/2-value(2)*2/3];
        set(cls.hfig,'Position', [pos(1) pos(2) value(1) value(2)]);
        set(gcf,'color', [1, 1, 1]);
    end
    function value = get.FigDim(cls)
        pos = get(cls.haxis, 'Position'); 
        value(1) = pos(3); value(2) = pos(4);
    end
    
    
    %% AXIS PROPERTIES
    % Axis Containment Box
    function set.AxisBox(cls, AxisBox)
        if iscell(AxisBox) ~= 1, AxisBoxCell{1} = AxisBox;
        else AxisBoxCell = AxisBox;
        end
        for k=1:length(cls.haxis)
            if k > size(AxisBoxCell,1); AxisBoxCell{k} = AxisBoxCell{end}; end
            set(cls.haxis(k), 'Box', AxisBoxCell{k});
        end
    end
    function AxisBox = get.AxisBox(cls)
        AxisBox = get(cls.haxis(1), 'Box'); 
    end
    
    % Axis Line Width
    function set.AxisWidth(cls, AxisWidth)
        if iscell(AxisWidth) ~= 1, AxisWidthCell{1} = AxisWidth;
        else AxisWidthCell = AxisWidth;
        end
        for k=1:length(cls.haxis)
            if k > size(AxisWidth,1); AxisWidthCell{k} = AxisWidthCell{end}; end
            set(cls.haxis(k), 'LineWidth', AxisWidthCell{k});
        end
    end
    function AxisWidth = get.AxisWidth(cls)
        AxisWidth = get(cls.haxis(1), 'LineWidth');
    end
    
    % Axis Color
    function set.AxisColor(cls, AxisColor)
        if ~iscell(AxisColor), AxisColorCell{1} = AxisColor;
        else AxisColorCell = AxisColor;
        end
        for k=1:length(cls.haxis)
            if k > size(AxisColor,1); 
                AxisColorCell{k} = AxisColorCell{end}; 
            end
            set(cls.haxis(k), 'XColor', AxisColorCell{k});
            set(cls.haxis(k), 'YColor', AxisColorCell{k});
            set(cls.haxis(k), 'ZColor', AxisColorCell{k});
        end
    end
    function AxisColor = get.AxisColor(cls)
        AxisColor = get(cls.haxis(1), 'Color');
    end
    
    % Axis Grid (all)
    function set.Grid(cls, Grid)
        if iscell(Grid)~=1, GridCell{1} = Grid;
        else                GridCell    = Grid;
        end
        for k=1:length(cls.haxis)
            if k > size(GridCell,1)
                GridCell{k} = GridCell{end};
            end
            set(cls.haxis(k), 'XGrid', GridCell{k});
            set(cls.haxis(k), 'YGrid', GridCell{k});
            set(cls.haxis(k), 'ZGrid', GridCell{k});
        end
    end
    function Grid = get.Grid(cls)
        XGrid = get(cls.haxis(1),'XGrid');
        YGrid = get(cls.haxis(1),'YGrid');
        ZGrid = get(cls.haxis(1),'ZGrid');
        if strcmp(XGrid,'on') || strcmp(YGrid,'on') || strcmp(ZGrid,'on')
             Grid = 'on';
        else Grid = 'off';
        end
    end
    
    % Axis Minor Grid (all)
    function set.MinorGrid(cls, MinorGrid)
        if iscell(MinorGrid)~=1, MinorGridCell{1} = MinorGrid;
        else                     MinorGridCell    = MinorGrid;
        end
        for k=1:length(cls.haxis)
            if k > size(MinorGridCell,1)
                MinorGridCell{k} = MinorGridCell{end}; 
            end
            set(cls.haxis(k), 'XMinorGrid', MinorGridCell{k});
            set(cls.haxis(k), 'YMinorGrid', MinorGridCell{k});
            set(cls.haxis(k), 'ZMinorGrid', MinorGridCell{k});
        end
    end
    function MinorGrid = get.MinorGrid(cls)
        XMinorGrid = get(cls.haxis(1),'XMinorGrid'); 
        YMinorGrid = get(cls.haxis(1),'YMinorGrid');
        ZMinorGrid = get(cls.haxis(1),'ZMinorGrid');
        if strcmp(XMinorGrid,'on') || ...
           strcmp(YMinorGrid,'on') || ...
           strcmp(ZMinorGrid,'on'), MinorGrid = 'on';
        else                        MinorGrid = 'off';
        end
    end
    
    % Axis Tick Direction
    function set.TickDir(cls,TickDir)
        set(cls.haxis, 'TickDir',TickDir);
    end
    function TickDir = get.TickDir(cls)
        TickDir = get(cls.haxis(1),'TickDir'); 
    end
    
    % Axis all Dimensions Minor Tick
    function set.MinorTick(cls,MinorTick)
        set(cls.haxis, 'XMinorTick', MinorTick);
        set(cls.haxis, 'YMinorTick', MinorTick);
        set(cls.haxis, 'ZMinorTick', MinorTick);
    end
    function MinorTick = get.MinorTick(cls)
        XMinorTick = get(cls.haxis(1), 'XMinorTick'); 
        YMinorTick = get(cls.haxis(1), 'YMinorTick');
        ZMinorTick = get(cls.haxis(1), 'ZMinorTick');
        if strcmp(XMinorTick,'on') || ...
           strcmp(YMinorTick,'on') || ...
           strcmp(ZMinorTick, 'on'), MinorTick = 'on';
        else                         MinorTick = 'off';
        end
    end

    % Axis X Ticks Values and Label
    function set.XTick(cls, XTick)
        for k=1:length(cls.haxis)
            if ~ischar(XTick{k})
                set(cls.haxis(k),'XTick',XTick{k});
            else
                if strcmp('deg',XTick{k})
                    set(cls.haxis(k),'XTick',[-360,-270,-180,-90,-45,0,45,90,180,270,360]);
                end
            end
        end
    end
    function XTick = get.XTick(cls)
        XTick = get(cls.haxis, 'XTick'); 
    end
    function set.XTickLabel(cls, XTickLabel)
        for k=1:length(cls.haxis)
            set(cls.haxis(k),'XTickLabel',XTickLabel{k});
        end
    end
    function XTickLabel = get.XTickLabel(cls)
        XTickLabel=get(cls.haxis,'XTickLabel'); 
    end
    
    % Axis Y Ticks Values and Label
    function set.YTick(cls, YTick)
        for k=1:length(cls.haxis)
            if ~ischar(YTick{k})
                set(cls.haxis(k),'YTick',YTick{k});
            else
                if strcmp('deg',YTick{k})||strcmp('rad',YTick{k})
                    set(cls.haxis(k),'YTick',[-360,-270,-180,-90,0,90,180,270,360]);
                    %cls.YTickLabel=YTick;
                end
            end
        end
    end
    function YTick = get.YTick(cls)
        YTick = get(cls.haxis, 'YTick'); 
    end
    function set.YTickLabel(cls,YTickLabel)
        for k=1:length(cls.haxis)
            set(cls.haxis(k),'YTickLabel',YTickLabel{k});
            if strcmp('rad',YTickLabel{k})
                %set(cls.haxis(k),'YTickLabel',{'$-\pi$','0','$\pi$','$\frac{1}{2}$'});
                %['$-2\pi$','$-\frac{3}{2}\pi$','$-\pi$','$-\frac{1}{2}\pi$','$0$'...
                %,'$\frac{1}{2}\pi$']);
                % add a function to get latex interpreter in tick label
                % reuse code of fomat_ticks for single axis
                %format_ticks(gca,{'1','2'},{'$1$','$2\frac{1}{2}$','$9\frac{1}{2}$'});
            end
        end
    end
    function YTickLabel = get.YTickLabel(cls)
        YTickLabel=get(cls.haxis,'YTickLabel'); 
    end

    % Axis Z Ticks Values and Label
    function set.ZTick(cls, ZTick)
        for k=1:length(cls.haxis)
            set(cls.haxis(k),'ZTick',ZTick{k});
        end
    end
    function ZTick = get.ZTick(cls)
        ZTick = get(cls.haxis, 'ZTick'); 
    end
    function set.ZTickLabel(cls, ZTickLabel)
        for k=1:length(cls.haxis)
            set(cls.haxis(k),'ZTickLabel',ZTickLabel{k});
        end
    end
    function ZTickLabel = get.ZTickLabel(cls)
        ZTickLabel=get(cls.haxis,'ZTickLabel'); 
    end
    
    
    %% FONT PROPERTIES
    % Font Type
    function set.FontName(cls, FontName)
        set(cls.hleg,'FontName', FontName);
        for k=1:length(cls.haxis)
            set(cls.htitle(k) , 'FontName', FontName);
            set(cls.hxlabel(k), 'FontName', FontName);
            set(cls.hylabel(k), 'FontName', FontName);
            set(cls.hzlabel(k), 'FontName', FontName);
            set(cls.haxis(k)  , 'FontName', FontName);
        end
        set(cls.htext,'FontName', FontName);
    end
    function FontName = get.FontName(cls)
        FontName = get(cls.haxis(1),'FontName'); 
    end
    
    % Font size (pt)
    function set.FontSize(cls, FontSize)
        set(cls.hleg,'FontSize',FontSize);
        for k=1:length(cls.haxis)
            set(cls.htitle(k) , 'FontSize', FontSize+1,'FontWeight','bold');
            set(cls.hxlabel(k), 'FontSize', FontSize);
            set(cls.hylabel(k), 'FontSize', FontSize);
            set(cls.hzlabel(k), 'FontSize', FontSize);
            set(cls.haxis(k)  , 'FontSize', FontSize-1);
        end
        set(cls.htext,'FontSize',FontSize);
    end
    function FontSize = get.FontSize(cls)
        FontSize = get(cls.hxlabel(1),'FontSize'); 
    end
    
    % String interpreterer
    function set.Interpreter(cls, Interpreter)
        lc1=get(cls.hleg,'string');     %hleg string is cell
        for k=1:length(lc1)
            lc2=lc1{k};                 %multi-axis = multi-cell
            if iscell(lc2)
                for j=1:length(lc2)
                    if ~isempty(strfind(lc2{j},'$'))
                            set(cls.hleg,'Interpreter','latex'); break
                    else    set(cls.hleg,'Interpreter',Interpreter);
                    end
                end
            else
                if ~isempty(strfind(lc2,'$'))
                        set(cls.hleg,'Interpreter','latex'); break
                else    set(cls.hleg,'Interpreter',Interpreter);
                end
            end
        end
        for k=1:length(cls.haxis)
            title=get(cls.htitle(k),'string');
            for j=1:size(title,1)
                if ~isempty(strfind(title(j,:),'$'))
                        set(cls.htitle(k), 'Interpreter','latex');
                else    set(cls.htitle(k), 'Interpreter',Interpreter);
                end
            end
            if ~isempty(strfind(get(cls.hxlabel(k),'string'),'$'))
                    set(cls.hxlabel(k), 'Interpreter','latex');
            else    set(cls.hxlabel(k), 'Interpreter',Interpreter);
            end
            if ~isempty(strfind(get(cls.hylabel(k),'string'),'$'))
                    set(cls.hylabel(k), 'Interpreter','latex');
            else    set(cls.hylabel(k), 'Interpreter',Interpreter);
            end
            if ~isempty(strfind(get(cls.hzlabel(k),'string'),'$'))
                    set(cls.hzlabel(k), 'Interpreter','latex');
            else    set(cls.hzlabel(k), 'Interpreter',Interpreter);
            end
        end
        for k=1:length(cls.htext)
            if ~isempty(strfind(get(cls.htext(k),'string'),'$'))
                    set(cls.htext(k), 'Interpreter','latex');
            else    set(cls.htext(k), 'Interpreter',Interpreter);
            end
        end
    end
    function Interpreter = get.Interpreter(cls)
        Interpreter = get(cls.hleg(1),'Interpreter'); 
    end

        
    %% LINE PROPERTIES
    % Line Drawing Width
    function set.LineWidth(cls,LineWidth)
        tmp = 0;
        for m=1:length(cls.haxis)
            if m > size(LineWidth,1); LineWidth(m,:)=LineWidth(end,:); end
            for n=1:cls.nrofl(m)
                if n > size(LineWidth,2); LineWidth(m,n)=LineWidth(m,end); end
                set(cls.hline(tmp+n), 'LineWidth' ,LineWidth(m,n));
            end
            tmp=tmp+n;
        end
    end
    function LineWidth = get.LineWidth(cls)
        tmp = 0;
        for m=1:length(cls.haxis)
            if cls.nrofl~=0
                for n=1:cls.nrofl(m)
                    LineWidth(m,n) = get(cls.hline(tmp+n),'LineWidth');
                end
                tmp=tmp+n;
            end
        end
    end
    
    % Line Type
    function set.LineStyle(cls,LineStyle)
        tmp = 0;
        for m=1:length(cls.haxis)
            if m > size(LineStyle,1); LineStyle(m,:)=LineStyle(end,:); end
            for n=1:cls.nrofl(m)
                if n > size(LineStyle,2); LineStyle(m,n)=LineStyle(m,end); end
                set(cls.hline(tmp+n), 'LineStyle' ,LineStyle(m,n));
            end
            tmp=tmp+n;
        end
        cls.LineStyle = LineStyle;
        % extension necessary: char <> double, typing '-.' will result 
        % in LineStyle(1)='-' and '.'
    end
    function LineStyle = get.LineStyle(cls)
        tmp = 0;
        for m=1:length(cls.haxis)
            if cls.nrofl~=0
                for n=1:cls.nrofl(m)
                    LineStyle(m,n) = get(cls.hline(tmp+n),'LineStyle');
                end
                tmp=tmp+n;
            end
        end
    end

    % MarkerSize
    function set.MarkerSize(cls,MarkerSize)
        tmp = 0;
        for m=1:length(cls.haxis)
            if m > size(MarkerSize,1); MarkerSize(m,:)=MarkerSize(end,:); end
            for n=1:cls.nrofl(m)
                if n > size(MarkerSize,2); MarkerSize(m,n)=MarkerSize(m,end); end
                set(cls.hline(tmp+n), 'MarkerSize' ,MarkerSize(m,n));
            end
            tmp=tmp+n;
        end
        %cls.MarkerSize = MarkerSize;
    end
    function MarkerSize = get.MarkerSize(cls)
        tmp = 0;
        for m=1:length(cls.haxis)
            if cls.nrofl~=0
                for n=1:cls.nrofl(m)
                    MarkerSize(m,n) = get(cls.hline(tmp+n),'MarkerSize');
                end
                tmp=tmp+n;
            end
        end
    end
    
    %% LEGEND PROPERTIES
    % Legend Box line
    function set.LegendBox(cls, LegendBox)
        if ~isempty(cls.hleg)
            set(cls.hleg, 'Box', LegendBox);
        end
    end
    function LegendBox = get.LegendBox(cls), LegendBox = [];
        if ~isempty(cls.hleg), LegendBox = get(cls.hleg, 'Box'); end
    end
    
    % Legend Location
    function set.LegendLoc(cls, LegendLoc)
        if ~isempty(cls.hleg)
            if iscell(LegendLoc)
                for k=1:length(cls.hleg)
                    set(cls.hleg(k), 'location', LegendLoc{length(cls.hleg)+1-k});
                end
            else
                set(cls.hleg, 'location', LegendLoc);
            end
        end
    end
    function LegendLoc = get.LegendLoc(cls), LegendLoc = [];
        if ~isempty(cls.hleg), LegendLoc = get(cls.hleg, 'location'); end
    end
    
    % Legend Position in figure
    function set.LegendPos(cls, LegendPos)
        if ~isempty(cls.hleg)
            set(cls.hleg, 'position', LegendPos);
        end
    end
    function LegendPos = get.LegendPos(cls), LegendPos = [];
        if ~isempty(cls.hleg), LegendPos = get(cls.hleg, 'position'); end
    end
    
    % Legend Orientation
    function set.LegendOrient(cls, LegendOrient)
        if ~isempty(cls.hleg)
            set(cls.hleg, 'Orientation', LegendOrient);
            set(cls.hleg,'FontSize', cls.FontSize);
        end
    end
    function LegendOrient = get.LegendOrient(cls), LegendOrient = [];
        if ~isempty(cls.hleg), LegendOrient = get(cls.hleg, 'Orientation'); end
    end
     
end


end

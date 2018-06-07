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
    Dimension, Position
    % 2. Axis Properties
    AxisBox, AxisWidth, AxisColor
    Grid, XGrid, YGrid, ZGrid, MinorGrid
    Tick, XTick, YTick, ZTick, MinorTick, TickDir
    TickLabel, XTickLabel, YTickLabel, ZTickLabel
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
    function obj = pubfig(varargin)

    obj.hfig = varargin{1};
    if nargin > 1, options = load(varargin{2});
    else,          options = load('figDefaultProperties.mat');
    end
    
    if verLessThan('matlab','8.4')  % before 2014b
        hAllAxis = findobj(obj.hfig,'type','axes');
        obj.hleg = findobj(hAllAxis,'tag','legend');
        obj.haxis = setdiff(hAllAxis,obj.hleg);
        hAllText = findobj(obj.hfig,'Type','Text');
        obj.htext = setdiff(hAllText,obj.hleg);
    else                            % after 2014b
        obj.haxis = findobj(obj.hfig,'type','axes');
        obj.hleg = findobj(obj.hfig,'type','legend');
        obj.htext = findobj(obj.hfig,'Type','Text');
    end
    
    for k=1:length(obj.haxis)   % axis data handles
        obj.hplot = [obj.hplot; get(obj.haxis(k), 'Children')];
        obj.hline = [obj.hline; findobj(obj.haxis(k),'Type','Line')];
        obj.nrofl(k) = length(findobj(obj.haxis(k),'Type','Line'));
        obj.htitle(k) = get(obj.haxis(k), 'Title');
        obj.hxlabel(k) = get(obj.haxis(k), 'XLabel');
        obj.hylabel(k) = get(obj.haxis(k), 'YLabel');
        obj.hzlabel(k) = get(obj.haxis(k), 'ZLabel');
    end
    
    % set properties
    pn_vec = properties(obj);
    fn_vec = fieldnames(options);
    for i=1:length(fn_vec)
        for j=1:length(pn_vec)
            if strcmp(fn_vec{i},pn_vec{j})
                obj.(fn_vec{i}) = options.(fn_vec{i});
            end
        end
    end
    end
end

methods
    %% FIGURE PROPERTIES
    % figure dimensions
    function set.Dimension(obj, value)
        if length(value) == 2
            set(obj.hfig,'Units', 'centimeters');
            pos = get(obj.hfig, 'Position');
            pos(1:2) = pos(1:2)-(value-pos(3:4));
            set(obj.hfig,'Position', [pos(1) pos(2) value(1) value(2)]);
            set(gcf,'color',[1 1 1]);
        elseif strcmp(value,'f') || strcmp(value,'full') %full-screen
            set(0,'Units','centimeters');
            monitor = get(0,'MonitorPositions');
            set(obj.hfig,'Position', [0 0 monitor(3) monitor(4)]);
        end
    end
    function value = get.Dimension(obj)
        pos = get(obj.hfig, 'Position'); 
        value(1) = pos(3); value(2) = pos(4);
    end
    
    % figure position
    function set.Position(obj, value)
        if length(value) == 1           %tile figures
            set(0,'Units','centimeters');
            monitor = get(0,'MonitorPositions');
            pos = [(value-1)*obj.Dimension(1) monitor(4)-obj.Dimension(2)-2.2];
            while pos(1)+obj.Dimension(1) > monitor(3)
                pos(2) = pos(2) - obj.Dimension(2)-2.2;
                pos(1) = pos(1) - floor(monitor(3)/obj.Dimension(1))*obj.Dimension(1);
                if pos(2) < 0, pos(2) = monitor(4)-obj.Dimension(2)-2.2; end
            end
            set(obj.hfig,'Position', [pos(1) pos(2) obj.Dimension(1) obj.Dimension(2)]);
        elseif length(value) == 2       %re-position
            set(obj.hfig,'Position', [value(1) value(2) obj.Dimension(1) obj.Dimension(2)]);

% SNAPPING: position to left/right or northeast/... -> change position & dimension
%         elseif strcmp(value,'e') || strcmp(value,'east') ... %snap right/east
%                || strcmp(value,'r') || strcmp(value,'right')
%            %
%         elseif strcmp(value,'w') || strcmp(value,'west') ... %snap right/east
%                || strcmp(value,'l') || strcmp(value,'left')
        end
    end
    function value = get.Position(obj)
        pos = get(obj.hfig, 'Position'); 
        value(1) = pos(1); value(2) = pos(2);
    end
        
    %% AXIS PROPERTIES
    % Axis Containment Box
    function set.AxisBox(obj, AxisBox)
        if iscell(AxisBox) ~= 1, AxisBoxCell{1} = AxisBox;
        else AxisBoxCell = AxisBox;
        end
        for k=1:length(obj.haxis)
            if k > size(AxisBoxCell,1); AxisBoxCell{k} = AxisBoxCell{end}; end
            set(obj.haxis(k), 'Box', AxisBoxCell{k});
        end
    end
    function AxisBox = get.AxisBox(obj)
        AxisBox = get(obj.haxis(1), 'Box'); 
    end
    
    % Axis Line Width
    function set.AxisWidth(obj, AxisWidth)
        if iscell(AxisWidth) ~= 1, AxisWidthCell{1} = AxisWidth;
        else AxisWidthCell = AxisWidth;
        end
        for k=1:length(obj.haxis)
            if k > size(AxisWidth,1); AxisWidthCell{k} = AxisWidthCell{end}; end
            set(obj.haxis(k), 'LineWidth', AxisWidthCell{k});
        end
    end
    function AxisWidth = get.AxisWidth(obj)
        AxisWidth = get(obj.haxis(1), 'LineWidth');
    end
    
    % Axis Color
    function set.AxisColor(obj, AxisColor)
        if ~iscell(AxisColor), AxisColorCell{1} = AxisColor;
        else AxisColorCell = AxisColor;
        end
        for k=1:length(obj.haxis)
            if k > size(AxisColor,1)
                AxisColorCell{k} = AxisColorCell{end}; 
            end
            set(obj.haxis(k), 'XColor', AxisColorCell{k});
            set(obj.haxis(k), 'YColor', AxisColorCell{k});
            set(obj.haxis(k), 'ZColor', AxisColorCell{k});
        end
    end
    function AxisColor = get.AxisColor(obj)
        AxisColor = get(obj.haxis(1), 'Color');
    end
    
    % Axis Grid (all)
    function set.Grid(obj, Grid)
        if iscell(Grid)~=1, GridCell{1} = Grid;
        else                GridCell    = Grid;
        end
        for k=1:length(obj.haxis)
            if k > size(GridCell,1)
                GridCell{k} = GridCell{end};
            end
            set(obj.haxis(k), 'XGrid', GridCell{k});
            set(obj.haxis(k), 'YGrid', GridCell{k});
            set(obj.haxis(k), 'ZGrid', GridCell{k});
        end
    end
    function Grid = get.Grid(obj)
        XGrid = get(obj.haxis(1),'XGrid');
        YGrid = get(obj.haxis(1),'YGrid');
        ZGrid = get(obj.haxis(1),'ZGrid');
        if strcmp(XGrid,'on') || strcmp(YGrid,'on') || strcmp(ZGrid,'on')
             Grid = 'on';
        else Grid = 'off';
        end
    end
    
    % Axis Minor Grid (all)
    function set.MinorGrid(obj, MinorGrid)
        if iscell(MinorGrid)~=1, MinorGridCell{1} = MinorGrid;
        else                     MinorGridCell    = MinorGrid;
        end
        for k=1:length(obj.haxis)
            if k > size(MinorGridCell,1)
                MinorGridCell{k} = MinorGridCell{end}; 
            end
            set(obj.haxis(k), 'XMinorGrid', MinorGridCell{k});
            set(obj.haxis(k), 'YMinorGrid', MinorGridCell{k});
            set(obj.haxis(k), 'ZMinorGrid', MinorGridCell{k});
        end
    end
    function MinorGrid = get.MinorGrid(obj)
        XMinorGrid = get(obj.haxis(1),'XMinorGrid'); 
        YMinorGrid = get(obj.haxis(1),'YMinorGrid');
        ZMinorGrid = get(obj.haxis(1),'ZMinorGrid');
        if strcmp(XMinorGrid,'on') || ...
           strcmp(YMinorGrid,'on') || ...
           strcmp(ZMinorGrid,'on'), MinorGrid = 'on';
        else                        MinorGrid = 'off';
        end
    end
    
    % Axis Tick Direction
    function set.TickDir(obj,TickDir)
        set(obj.haxis, 'TickDir',TickDir);
    end
    function TickDir = get.TickDir(obj)
        TickDir = get(obj.haxis(1),'TickDir'); 
    end
    
    % Axis all Dimensions Minor Tick
    function set.MinorTick(obj,MinorTick)
        set(obj.haxis, 'XMinorTick', MinorTick);
        set(obj.haxis, 'YMinorTick', MinorTick);
        set(obj.haxis, 'ZMinorTick', MinorTick);
    end
    function MinorTick = get.MinorTick(obj)
        XMinorTick = get(obj.haxis(1), 'XMinorTick'); 
        YMinorTick = get(obj.haxis(1), 'YMinorTick');
        ZMinorTick = get(obj.haxis(1), 'ZMinorTick');
        if strcmp(XMinorTick,'on') || ...
           strcmp(YMinorTick,'on') || ...
           strcmp(ZMinorTick, 'on'), MinorTick = 'on';
        else                         MinorTick = 'off';
        end
    end

    % Axis X Ticks Values and Label
    function set.XTick(obj, XTick)
        for k=1:length(obj.haxis)
            if ~ischar(XTick{k})
                set(obj.haxis(k),'XTick',XTick{k});
            else
                if strcmp('deg',XTick{k})
                    set(obj.haxis(k),'XTick',[-360,-270,-180,-90,-45,0,45,90,180,270,360]);
                end
            end
        end
    end
    function XTick = get.XTick(obj)
        XTick = get(obj.haxis, 'XTick'); 
    end
    function set.XTickLabel(obj, XTickLabel)
        for k=1:length(obj.haxis)
            set(obj.haxis(k),'XTickLabel',XTickLabel{k});
        end
    end
    function XTickLabel = get.XTickLabel(obj)
        XTickLabel=get(obj.haxis,'XTickLabel'); 
    end
    
    % Axis Y Ticks Values and Label
    function set.YTick(obj, YTick)
        for k=1:length(obj.haxis)
            if ~ischar(YTick{k})
                set(obj.haxis(k),'YTick',YTick{k});
            else
                if strcmp('deg',YTick{k})||strcmp('rad',YTick{k})
                    set(obj.haxis(k),'YTick',[-360,-270,-180,-90,0,90,180,270,360]);
                    %obj.YTickLabel=YTick;
                end
            end
        end
    end
    function YTick = get.YTick(obj)
        YTick = get(obj.haxis, 'YTick'); 
    end
    function set.YTickLabel(obj,YTickLabel)
        for k=1:length(obj.haxis)
            set(obj.haxis(k),'YTickLabel',YTickLabel{k});
            if strcmp('rad',YTickLabel{k})
                %set(obj.haxis(k),'YTickLabel',{'$-\pi$','0','$\pi$','$\frac{1}{2}$'});
                %['$-2\pi$','$-\frac{3}{2}\pi$','$-\pi$','$-\frac{1}{2}\pi$','$0$'...
                %,'$\frac{1}{2}\pi$']);
                % add a function to get latex interpreter in tick label
                % reuse code of fomat_ticks for single axis
                %format_ticks(gca,{'1','2'},{'$1$','$2\frac{1}{2}$','$9\frac{1}{2}$'});
            end
        end
    end
    function YTickLabel = get.YTickLabel(obj)
        YTickLabel=get(obj.haxis,'YTickLabel'); 
    end

    % Axis Z Ticks Values and Label
    function set.ZTick(obj, ZTick)
        for k=1:length(obj.haxis)
            set(obj.haxis(k),'ZTick',ZTick{k});
        end
    end
    function ZTick = get.ZTick(obj)
        ZTick = get(obj.haxis, 'ZTick'); 
    end
    function set.ZTickLabel(obj, ZTickLabel)
        for k=1:length(obj.haxis)
            set(obj.haxis(k),'ZTickLabel',ZTickLabel{k});
        end
    end
    function ZTickLabel = get.ZTickLabel(obj)
        ZTickLabel=get(obj.haxis,'ZTickLabel'); 
    end
    
    
    %% FONT PROPERTIES
    % Font Type
    function set.FontName(obj, FontName)
        set(obj.hleg,'FontName', FontName);
        for k=1:length(obj.haxis)
            set(obj.htitle(k) , 'FontName', FontName);
            set(obj.hxlabel(k), 'FontName', FontName);
            set(obj.hylabel(k), 'FontName', FontName);
            set(obj.hzlabel(k), 'FontName', FontName);
            set(obj.haxis(k)  , 'FontName', FontName);
        end
        set(obj.htext,'FontName', FontName);
    end
    function FontName = get.FontName(obj)
        FontName = get(obj.haxis(1),'FontName'); 
    end
    
    % Font size (pt)
    function set.FontSize(obj, FontSize)
        set(obj.hleg,'FontSize',FontSize);
        for k=1:length(obj.haxis)
            set(obj.htitle(k) , 'FontSize', FontSize+1,'FontWeight','bold');
            set(obj.hxlabel(k), 'FontSize', FontSize);
            set(obj.hylabel(k), 'FontSize', FontSize);
            set(obj.hzlabel(k), 'FontSize', FontSize);
            set(obj.haxis(k)  , 'FontSize', FontSize-1);
        end
        set(obj.htext,'FontSize',FontSize);
    end
    function FontSize = get.FontSize(obj)
        FontSize = get(obj.hxlabel(1),'FontSize'); 
    end
    
    % String interpreterer
    function set.Interpreter(obj, Interpreter)
        lc1=get(obj.hleg,'string');     %hleg string is cell
        for k=1:length(lc1)
            lc2=lc1{k};                 %multi-axis = multi-cell
            if iscell(lc2)
                for j=1:length(lc2)
                    if ~isempty(strfind(lc2{j},'$'))
                            set(obj.hleg,'Interpreter','latex'); break
                    else    set(obj.hleg,'Interpreter',Interpreter);
                    end
                end
            else
                if ~isempty(strfind(lc2,'$'))
                        set(obj.hleg,'Interpreter','latex'); break
                else    set(obj.hleg,'Interpreter',Interpreter);
                end
            end
        end
        for k=1:length(obj.haxis)
            title=get(obj.htitle(k),'string');
            for j=1:size(title,1)
                if ~isempty(strfind(title(j,:),'$'))
                        set(obj.htitle(k), 'Interpreter','latex');
                else    set(obj.htitle(k), 'Interpreter',Interpreter);
                end
            end
            if ~isempty(strfind(get(obj.hxlabel(k),'string'),'$'))
                    set(obj.hxlabel(k), 'Interpreter','latex');
            else    set(obj.hxlabel(k), 'Interpreter',Interpreter);
            end
            if ~isempty(strfind(get(obj.hylabel(k),'string'),'$'))
                    set(obj.hylabel(k), 'Interpreter','latex');
            else    set(obj.hylabel(k), 'Interpreter',Interpreter);
            end
            if ~isempty(strfind(get(obj.hzlabel(k),'string'),'$'))
                    set(obj.hzlabel(k), 'Interpreter','latex');
            else    set(obj.hzlabel(k), 'Interpreter',Interpreter);
            end
        end
        for k=1:length(obj.htext)
            if ~isempty(strfind(get(obj.htext(k),'string'),'$'))
                    set(obj.htext(k), 'Interpreter','latex');
            else    set(obj.htext(k), 'Interpreter',Interpreter);
            end
        end
    end
    function Interpreter = get.Interpreter(obj)
        Interpreter = get(obj.hleg(1),'Interpreter'); 
    end

        
    %% LINE PROPERTIES
    % Line Drawing Width
    function set.LineWidth(obj,LineWidth)
        tmp = 0;
        for m=1:length(obj.haxis)
            if m > size(LineWidth,1); LineWidth(m,:)=LineWidth(end,:); end
            for n=1:obj.nrofl(m)
                if n > size(LineWidth,2); LineWidth(m,n)=LineWidth(m,end); end
                set(obj.hline(tmp+n), 'LineWidth' ,LineWidth(m,n));
            end
            tmp=tmp+n;
        end
    end
    function LineWidth = get.LineWidth(obj)
        tmp = 0;
        for m=1:length(obj.haxis)
            if obj.nrofl~=0
                for n=1:obj.nrofl(m)
                    LineWidth(m,n) = get(obj.hline(tmp+n),'LineWidth');
                end
                tmp=tmp+n;
            end
        end
    end
    
    % Line Type
    function set.LineStyle(obj,LineStyle)
        tmp = 0;
        for m=1:length(obj.haxis)
            if m > size(LineStyle,1); LineStyle(m,:)=LineStyle(end,:); end
            for n=1:obj.nrofl(m)
                if n > size(LineStyle,2); LineStyle(m,n)=LineStyle(m,end); end
                set(obj.hline(tmp+n), 'LineStyle' ,LineStyle(m,n));
            end
            tmp=tmp+n;
        end
        obj.LineStyle = LineStyle;
        % extension necessary: char <> double, typing '-.' will result 
        % in LineStyle(1)='-' and '.'
    end
    function LineStyle = get.LineStyle(obj)
        tmp = 0;
        for m=1:length(obj.haxis)
            if obj.nrofl~=0
                for n=1:obj.nrofl(m)
                    LineStyle(m,n) = get(obj.hline(tmp+n),'LineStyle');
                end
                tmp=tmp+n;
            end
        end
    end

    % MarkerSize
    function set.MarkerSize(obj,MarkerSize)
        tmp = 0;
        for m=1:length(obj.haxis)
            if m > size(MarkerSize,1); MarkerSize(m,:)=MarkerSize(end,:); end
            for n=1:obj.nrofl(m)
                if n > size(MarkerSize,2); MarkerSize(m,n)=MarkerSize(m,end); end
                set(obj.hline(tmp+n), 'MarkerSize' ,MarkerSize(m,n));
            end
            tmp=tmp+n;
        end
        %obj.MarkerSize = MarkerSize;
    end
    function MarkerSize = get.MarkerSize(obj)
        tmp = 0;
        for m=1:length(obj.haxis)
            if obj.nrofl~=0
                for n=1:obj.nrofl(m)
                    MarkerSize(m,n) = get(obj.hline(tmp+n),'MarkerSize');
                end
                tmp=tmp+n;
            end
        end
    end
    
    %% LEGEND PROPERTIES
    % Legend Box line
    function set.LegendBox(obj, LegendBox)
        if ~isempty(obj.hleg)
            set(obj.hleg, 'Box', LegendBox);
        end
    end
    function LegendBox = get.LegendBox(obj), LegendBox = [];
        if ~isempty(obj.hleg), LegendBox = get(obj.hleg, 'Box'); end
    end
    
    % Legend Location
    function set.LegendLoc(obj, LegendLoc)
        if ~isempty(obj.hleg)
            if iscell(LegendLoc)
                for k=1:length(obj.hleg)
                    set(obj.hleg(k), 'location', LegendLoc{length(obj.hleg)+1-k});
                end
            else
                set(obj.hleg, 'location', LegendLoc);
            end
        end
    end
    function LegendLoc = get.LegendLoc(obj), LegendLoc = [];
        if ~isempty(obj.hleg)
            for k=1:length(obj.hleg)
                LegendLoc{length(obj.hleg)+1-k,1} = get(obj.hleg(k), 'location');
            end
        end
    end
    
    % Legend Position in figure
    function set.LegendPos(obj, value)
        if ~isempty(obj.hleg)
            if iscell(value)
                for k=1:length(obj.hleg)
                    set(obj.hleg(k), 'position', value{length(obj.hleg)+1-k});
                end
            else
                set(obj.hleg, 'location', value);
            end
        end
    end
    function LegendPos = get.LegendPos(obj), LegendPos = [];
        if ~isempty(obj.hleg)
            for k=1:length(obj.hleg)
                LegendPos{length(obj.hleg)+1-k,1} = get(obj.hleg(k), 'position'); 
            end
        end
    end
    
    % Legend Orientation
    function set.LegendOrient(obj, LegendOrient)
        if ~isempty(obj.hleg)
            set(obj.hleg, 'Orientation', LegendOrient);
            set(obj.hleg,'FontSize', obj.FontSize);
        end
    end
    function LegendOrient = get.LegendOrient(obj), LegendOrient = [];
        if ~isempty(obj.hleg), LegendOrient = get(obj.hleg, 'Orientation'); end
    end
     
end


end

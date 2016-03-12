classdef pubfig < handle
% PUBFIG - class for Publication-Quality-Figures in MATLAB
% Class representing matlab figures with publication layout.
% Grabs excisting matlab figure class and creates pubfig class
% figures with publication layout properties (see list).
% Layout properties are displayed and can be easily adapted by user.
% It can also export figures as publication quality image files. 
% Currently, export tools for following formats are supported: 
% Vector: EPS, PDF, EMF
% Raster: PNG, BMP
%
% Author: Thomas Beauduin, The University of Tokyo, 2016

% Version: 1.0
% additional work:
%   * align multiplot axis labels
%   * LineStyle settings
%   * Latex Ticks
%   * support for markers
%   * grid style and width

% Default Properties
methods (Hidden, Access = private)
    function setDefaultProperties(fig)
        fig.FigDim          = [20 14];
        fig.FontSize        = 14;
        fig.FontName        = 'Times New Roman';
        fig.Interpreter     = 'latex';
        fig.LineWidth       = 2.2;
        fig.AxisBox         = 'on';
        fig.LegendBox       = 'on';
        fig.LegendLoc       = 'best';
        fig.LegendOrient    = 'vertical';
        fig.XMinorGrid      = 'off';
        fig.YMinorGrid      = 'off';
        fig.ZMinorGrid      = 'off';
        fig.XGrid           = 'on';
        fig.YGrid           = 'on';
        fig.ZGrid           = 'on';
        fig.XMinorTick      = 'on';
        fig.YMinorTick      = 'on';
        fig.ZMinorTick      = 'on';
        fig.TickDir         = 'in';
    end
end

% Public Properties
properties (Dependent = true)
    FigDim, AxisBox
    XTick, XTickLabel
    YTick, YTickLabel
    ZTick, ZTickLabel
    XMinorTick, YMinorTick, ZMinorTick, TickDir
    FontName, FontSize, Interpreter
    LineWidth, LineStyle
    LegendBox, LegendLoc, LegendPos, LegendOrient
    XGrid, XMinorGrid
    YGrid, YMinorGrid
    ZGrid, ZMinorGrid
end
    
% Private Properties
properties(Hidden, SetAccess = private)
    hfig,                       % figure obj
    haxis, nrofa                % axis obj
    hleg                        % illustration obj
    htext, nroft                % annotation obj
    hplot, nrofp                % chart obj
    hline, nrofl                % primitive line obj
    htitle, hxlabel             % label obj
    hylabel, hzlabel
end
    
methods
    function cls = pubfig(hfig)
    cls.hfig = hfig;
    if ~using_hg2(hfig)     % before 2014b
        hAllAxis = findobj(cls.hfig,'type','axes');
        cls.hleg = findobj(hAllAxis,'tag','legend');
        cls.haxis = setdiff(hAllAxis,cls.hleg);
        hAllText = findobj(cls.hfig,'Type','Text');
        cls.htext = setdiff(hAllText,cls.hleg);
    else                    % after 2014b
        cls.haxis = findobj(cls.hfig,'type','axes');
        cls.hleg = findobj(cls.hfig,'type','legend');
        cls.htext = findobj(cls.hfig,'Type','Text');
    end
    cls.nrofa = length(cls.haxis);
    cls.nroft = length(cls.htext);
    
    for k=1:cls.nrofa       % axis data objects
        cls.hplot = [cls.hplot;get(cls.haxis(k), 'Children')];
        cls.nrofp(k) = length( get(cls.haxis(k), 'Children'));
        cls.hline = [cls.hline;findobj(cls.haxis(k),'Type','Line')];
        cls.nrofl(k) = length( findobj(cls.haxis(k),'Type','Line'));
        cls.htitle(k) = get(cls.haxis(k), 'Title');
        cls.hxlabel(k) = get(cls.haxis(k), 'XLabel');
        cls.hylabel(k) = get(cls.haxis(k), 'YLabel');
        cls.hzlabel(k) = get(cls.haxis(k), 'ZLabel');
    end
    
    % set properties
    cls.setDefaultProperties()
    end
end

methods
    % SET
    function set.FigDim(cls, value)
        set(cls.hfig,'Units', 'centimeters');
        set(0,'Units','centimeters');
        monitorSize = get(0,'MonitorPositions');
        pos = [monitorSize(3)/2-value(1)/2, monitorSize(4)/2-value(2)*2/3];
        set(cls.hfig,'Position', [pos(1) pos(2) value(1) value(2)]);
        set(gcf,'color', [1, 1, 1]);
    end
    function set.FontName(cls, FontName)
             set(cls.haxis, 'FontName', FontName);
        end      
    function set.FontSize(cls, FontSize)
        set(cls.hleg,'FontSize',FontSize);
        for k=1:cls.nrofa
            set(cls.htitle(k) , 'FontSize', FontSize+1);
            set(cls.hxlabel(k), 'FontSize', FontSize);
            set(cls.hylabel(k), 'FontSize', FontSize);
            set(cls.hzlabel(k), 'FontSize', FontSize);
            set(cls.haxis(k)  , 'FontSize', FontSize-1);
        end
        set(cls.htext,'FontSize',FontSize);
    end
    function set.Interpreter(cls, Interpreter)
        set(cls.hleg, 'Interpreter',Interpreter);
        for k=1:cls.nrofa
            set(cls.htitle(k), 'Interpreter',Interpreter);
            set(cls.hxlabel(k),'Interpreter',Interpreter);
            set(cls.hylabel(k),'Interpreter',Interpreter);
            set(cls.hzlabel(k),'Interpreter',Interpreter);
        end
        set(cls.htext, 'Interpreter',Interpreter);
    end
    function set.AxisBox(cls, AxisBox)
        if iscell(AxisBox)~=1, AxisBoxCell{1}=AxisBox;
        else AxisBoxCell = AxisBox;
        end
        for k=1:cls.nrofa
            if k > size(AxisBoxCell,1); AxisBoxCell{k}=AxisBoxCell{end}; end
            set(cls.haxis(k), 'Box', AxisBoxCell{k});
        end
    end
    function set.XTick(cls, XTick)
        try
            for k=1:cls.nrofa
                set(cls.haxis(k),'XTick',XTick{k});
            end
        catch
        end
    end
    function set.YTick(cls, YTick)
        for k=1:cls.nrofa
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
    function set.ZTick(cls, ZTick)
        for k=1:cls.nrofa
            set(cls.haxis(k),'ZTick',ZTick{k});
        end
    end
    function set.XTickLabel(cls, XTickLabel)
        for k=1:cls.nrofa
            set(cls.haxis(k),'XTickLabel',XTickLabel{k});
        end
    end
    function set.YTickLabel(cls,YTickLabel)
        for k=1:cls.nrofa
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
    function set.ZTickLabel(cls, ZTickLabel)
        for k=1:cls.nrofa
            set(cls.haxis(k),'ZTickLabel',ZTickLabel{k});
        end
    end
    function set.XMinorTick(cls,XMinorTick)
        set(cls.haxis,'XMinorTick',XMinorTick);
    end
    function set.YMinorTick(cls, YMinorTick)
        set(cls.haxis, 'YMinorTick' , YMinorTick);
    end
    function set.ZMinorTick(cls, ZMinorTick)
        set(cls.haxis, 'ZMinorTick',ZMinorTick);
    end
    function set.TickDir(cls,TickDir)
        set(cls.haxis, 'TickDir',TickDir);
    end
    function set.LineWidth(cls,LineWidth)
        tmp = 0;
        for m=1:cls.nrofa
            if m > size(LineWidth,1); LineWidth(m,:)=LineWidth(end,:); end
            for n=1:cls.nrofl(m)
                if n > size(LineWidth,2); LineWidth(m,n)=LineWidth(m,end); end
                set(cls.hline(tmp+n), 'LineWidth' ,LineWidth(m,n));
            end
            tmp=tmp+n;
        end
    end
    function set.LineStyle(cls,LineStyle)
        tmp = 0;
        for m=1:cls.nrofa
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
    function set.LegendBox(cls, LegendBox)
            if ~isempty(cls.hleg)
                set(cls.hleg, 'Box', LegendBox);
            end
    end
    function set.LegendLoc(cls, LegendLoc)
        if ~isempty(cls.hleg)
            set(cls.hleg, 'location', LegendLoc);
        end
    end
    function set.LegendPos(cls, LegendPos)
        if ~isempty(cls.hleg)
            set(cls.hleg, 'position', LegendPos);
        end
    end
    function set.LegendOrient(cls, LegendOrient)
        if ~isempty(cls.hleg)
            set(cls.hleg, 'Orientation', LegendOrient);
            set(cls.hleg,'FontSize',cls.FontSize);
        end
    end
    
    function set.XGrid(cls, XGrid)
        if iscell(XGrid)~=1,    XGridCell{1}=XGrid;
        else                    XGridCell   =XGrid;
        end
        for k=1:cls.nrofa
            if k > size(XGridCell,1); XGridCell{k}=XGridCell{end}; end
            set(cls.haxis(k), 'XGrid',XGridCell{k});
        end
    end             
    function set.YGrid(cls, YGrid)
        if iscell(YGrid)~=1,    YGridCell{1}=YGrid;
        else                    YGridCell   =YGrid;
        end
        for k=1:cls.nrofa
            if k > size(YGridCell,1); YGridCell{k}=YGridCell{end}; end
            set(cls.haxis(k), 'YGrid',YGridCell{k});
        end
    end
    function set.ZGrid(cls, ZGrid)
        if iscell(ZGrid)~=1,    ZGridCell{1}=ZGrid;
        else                    ZGridCell   =ZGrid;
        end
        for k=1:cls.nrofa
            if k > size(ZGridCell,1); ZGridCell{k}=ZGridCell{end}; end
            set(cls.haxis(k), 'ZGrid',ZGridCell{k});
        end
    end
    
    function set.XMinorGrid(cls, XMinorGrid)
        if iscell(XMinorGrid)~=1,   XMinorGridCell{1}=XMinorGrid;
        else                        XMinorGridCell   =XMinorGrid;
        end
        for k=1:cls.nrofa
            if k > size(XMinorGridCell,1); XMinorGridCell{k}=XMinorGridCell{end}; end
            set(cls.haxis(k), 'XMinorGrid',XMinorGridCell{k});
        end
    end
    function set.YMinorGrid(cls, YMinorGrid)
        if iscell(YMinorGrid)~=1,   YMinorGridCell{1}=YMinorGrid;
        else                        YMinorGridCell   =YMinorGrid;
        end
        for k=1:cls.nrofa
            if k > size(YMinorGridCell,1); YMinorGridCell{k}=YMinorGridCell{end}; end
            set(cls.haxis(k), 'YMinorGrid',YMinorGridCell{k});
        end         
    end
    function set.ZMinorGrid(cls, ZMinorGrid)
        if iscell(ZMinorGrid)~=1,   ZMinorGridCell{1}=ZMinorGrid;
        else                        ZMinorGridCell   =ZMinorGrid;
        end
        for k=1:cls.nrofa
            if k > size(ZMinorGridCell,1); ZMinorGridCell{k}=ZMinorGridCell{end}; end
            set(cls.haxis(k), 'ZMinorGrid',ZMinorGridCell{k});
        end           
    end
    
    %%%%%%
    % GET:
    %%%%%%
    function value = get.FigDim(cls)
        pos=get(cls.haxis, 'Position'); 
        value(1)=pos(3); value(2)=pos(4);
    end
    function AxisBox = get.AxisBox(cls), AxisBox = get(cls.haxis(1), 'Box'); end
    function XTick = get.XTick(cls), XTick = get(cls.haxis, 'XTick'); end
    function YTick = get.YTick(cls), YTick = get(cls.haxis, 'YTick'); end
    function ZTick = get.ZTick(cls), ZTick = get(cls.haxis, 'ZTick'); end
    function XTickLabel = get.XTickLabel(cls),XTickLabel=get(cls.haxis,'XTickLabel'); end
    function YTickLabel = get.YTickLabel(cls),YTickLabel=get(cls.haxis,'YTickLabel'); end
    function ZTickLabel = get.ZTickLabel(cls),ZTickLabel=get(cls.haxis,'ZTickLabel'); end
    function XMinorTick = get.XMinorTick(cls),XMinorTick=get(cls.haxis(1),'XMinorTick'); end
    function YMinorTick = get.YMinorTick(cls),YMinorTick=get(cls.haxis(1),'YMinorTick'); end
    function ZMinorTick = get.ZMinorTick(cls),ZMinorTick=get(cls.haxis(1),'ZMinorTick'); end
    function TickDir = get.TickDir(cls),TickDir = get(cls.haxis(1),'TickDir'); end
    function FontSize = get.FontSize(cls), FontSize = get(cls.hxlabel(1),'FontSize'); end
    function FontName = get.FontName(cls), FontName = get(cls.haxis(1),'FontName'); end
    function Interpreter = get.Interpreter(cls), Interpreter = get(cls.haxis(1),'Interpreter'); end
    function LineWidth = get.LineWidth(cls), LineWidth = cls.LineWidth; end
    function XGrid = get.XGrid(cls), XGrid = get(cls.haxis(1),'XGrid'); end
    function YGrid = get.YGrid(cls), YGrid = get(cls.haxis(1),'YGrid'); end
    function ZGrid = get.ZGrid(cls), ZGrid = get(cls.haxis(1),'ZGrid'); end
    function XMinorGrid = get.XMinorGrid(cls), XMinorGrid = get(cls.haxis(1),'XMinorGrid'); end
    function YMinorGrid = get.YMinorGrid(cls), YMinorGrid = get(cls.haxis(1),'YMinorGrid'); end    
    function ZMinorGrid = get.ZMinorGrid(cls), ZMinorGrid = get(cls.haxis(1),'ZMinorGrid'); end
    function LegendBox = get.LegendBox(cls), LegendBox = [];
            if ~isempty(cls.hleg), LegendBox = get(cls.hleg, 'Box'); end
    end
    function LegendLoc = get.LegendLoc(cls), LegendLoc = [];
        if ~isempty(cls.hleg), LegendLoc = get(cls.hleg, 'location'); end
    end
    function LegendPos = get.LegendPos(cls), LegendPos = [];
        if ~isempty(cls.hleg), LegendPos = get(cls.hleg, 'position'); end
    end
    function LegendOrient = get.LegendOrient(cls), LegendOrient = [];
        if ~isempty(cls.hleg), LegendOrient = get(cls.hleg, 'Orientation'); end
    end
    function LineStyle = get.LineStyle(cls)
        tmp = 0;
        for m=1:cls.nrofa
            if cls.nrofl~=0
                for n=1:cls.nrofl(m)
                    LineStyle(m,n) = get(cls.hline(tmp+n),'LineStyle');
                end
                tmp=tmp+n;
            end
        end
    end
end
end

%EXTENSION for subplot axis alignment
% xpos = -18 % (find this out from get(yl,'pos') on the desired label x-location)
% yl=ylabel('Label Here')
% pos=get(yl,'Pos')
% set(yl,'Pos',[xpos pos(2) pos(3)])
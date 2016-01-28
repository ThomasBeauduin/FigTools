function [pathstr] = figpublish(S)
%FIGPUBLISH format figure for publication.
%
% S      : struct with diplay parameters
% Method : set fig, axis, legend & plot par
% Author : Thomas Beauduin, KULeuven
%          PMA division, 20 December 2013
%%%%%
% SET FIG
width = 20; height = 14;
set(gcf,'Units', 'centimeters');
set(gcf,'PaperUnits', 'centimeters');
set(gcf,'Position', [10 7 width height]);
set(gcf,'PaperPosition',[0.01*width 0.01*height width height]);
set(gcf,'Papersize',[width*(1-0.075) height*(1-0.01)]);
set(gcf,'InvertHardcopy','on');
set(gcf,'color', [1, 1, 1]);
set(gcf,'InvertHardCopy', 'off');
set(gcf,'PaperPositionMode', 'auto');

% SET AXIS
FontSize = 14;
for m=1:size(S.Haxis,2)
    if isfield(S,'Xlabel') == 1
    xlabel(S.Haxis(m),S.Xlabel(m),'FontSize',FontSize,'Interpreter','latex');
    end
    if isfield(S,'Ylabel') == 1
    ylabel(S.Haxis(m),S.Ylabel(m),'FontSize',FontSize,'Interpreter','latex');
    end
    if isfield(S,'Tlabel') == 1
    title(S.Haxis(m),S.Tlabel(m),'FontSize',FontSize+1,'Interpreter','latex');
    end
    if isfield(S,'Xlim') == 1
        xlim(S.Haxis(m),[S.Xlim{m,1}, S.Xlim{m,2}]);
    end
    if isfield(S,'Ylim') == 1
        ylim(S.Haxis(m),[S.Ylim{m,1}, S.Ylim{m,2}]);
    end
    if isfield(S,'Xtik') == 1
        set(S.Haxis(m),'XTick',[S.Xtik{m,:}]);
    end
    if isfield(S,'Ytik') == 1
        set(S.Haxis(m),'YTick',[S.Ytik{m,:}]);
    end
    set(S.Haxis(m),'FontSize',FontSize-1);
    grid(S.Haxis(m),'on');
end

% SET LEGEND
if isfield(S,'Llabel') == 1
    for l=1:size(S.Llabel,1)
        L=legend(S.Haxis(l),S.Llabel(l,:),'Interpreter','latex'); %,
        if isfield(S,'Lloc') == 1
            set(L,'Location',S.Lloc);
        else
            set(L,'Location','best');
        end
        if isfield(S,'Lpos') == 1
            set(L,'Position',S.Lpos);
        end
        if isfield(S,'Lorient') == 1
            set(L,'Orientation',S.Lorient);
        end
    end
end

% SET PLOT
for m=1:size(S.Hplot,1)
    for p=1:size(S.Hplot,2)
        set(S.Hplot(m,p),'LineWidth', 2.2);
    end
end

% SAVE
Fres = 500;
if strcmp(S.Oname,'')~=1
    print(gcf,S.Oname,'-dpdf',sprintf('-r%d',Fres));
    %mlf2pdf(S.Hfig);
    print(gcf,S.Oname,'-dmeta',sprintf('-r%d',Fres));
end
pathstr = fullfile(cd,S.Oname);
end
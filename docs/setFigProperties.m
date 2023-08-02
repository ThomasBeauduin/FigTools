% make new properties .mat file

% PLEASE ADD YOUR CUSTOM .MAT FILE TO YOUR OWN PATH !!!
% EVERTIME YOU SYNC GITHUB YOU WILL LOSE THESE SETTINGS.


%% PUBFIG
S.Dimension       = [8,6]; % [width,height]
S.Position        = [0,0];
S.FontSize        = 10;
S.FontName        = 'Times New Roman';
S.Interpreter     = 'latex';
S.LineWidth       = 0.4;
S.AxisBox         = 'on';
S.AxisWidth       = 0.4;
S.LegendBox       = 'on';
S.LegendLoc       = 'best';
S.LegendOrient    = 'vertical';
S.Grid            = 'off';
S.MinorGrid       = 'off';
S.MinorTick       = 'on';
S.TickDir         = 'in';
S.AxisColor       = [0,0,0];
S.MarkerSize      = 4;

%% EXPFIG
S.folder         = [];
S.name           = 'exout';
S.renderer       = 0; % 0:default, 1:OpenGL, 2:ZBuffer, 3:Painters
S.magnify        = 1.00;
S.padding        = 0.01;

S.crop           = true;
S.grey           = false;
S.transparent    = false;

S.fig            = true;
S.pdf            = true;
S.eps            = false;
S.emf            = false;
S.png            = false;
S.bmp            = false;
S.tex            = false;

save('figDefaultProperties','-struct','S');
% make new properties .mat file

% PLEASE ADD YOUR CUSTOM .MAT FILE TO YOUR OWN PATH !!!
% EVERTIME YOU SYNC GITHUB YOU WILL LOSE THESE SETTINGS.


%% PUBFIG
S.Dimension       = [20 14];
S.Position        = [1,1];
S.FontSize        = 14;
S.FontName        = 'Times New Roman';
S.Interpreter     = 'latex';
S.LineWidth       = 2.2;
S.AxisBox         = 'on';
S.AxisWidth       = 1.0;
S.LegendBox       = 'on';
S.LegendLoc       = 'best';
S.LegendOrient    = 'vertical';
S.Grid            = 'on';
S.MinorGrid       = 'off';
S.MinorTick       = 'on';
S.TickDir         = 'in';
S.AxisColor       = [0 0 0];
S.MarkerSize      = 18;

%% EXPFIG
S.folder         = [];
S.name           = 'exout';
S.crop           = true;
S.renderer       = 0; % 0:default, 1:OpenGL, 2:ZBuffer, 3:Painters
S.pdf            = false;
S.eps            = false;
S.png            = false;
S.bmp            = false;
S.emf            = false;
S.fig            = true;
S.grey           = false;
S.padding        = 0.01;
S.magnify        = 2;
S.transparent    = false;

save('figDefaultProperties','-struct','S');
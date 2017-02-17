% make new properties .mat file

%% PUBFIG
S.FigDim          = [20 14];
S.FontSize        = 14;
S.FontName        = 'Times New Roman';
S.Interpreter     = 'latex';
S.LineWidth       = 2.2;
S.AxisBox         = 'on';
S.AxisWidth       = 1.0;
S.LegendBox       = 'on';
S.LegendLoc       = 'northeast';
S.LegendOrient    = 'vertical';
S.Grid            = 'on';
S.MinorGrid       = 'off';
S.MinorTick       = 'on';
S.TickDir         = 'in';
S.AxisColor      = [0 0 0];

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
S.grey           = true;
S.padding        = 0.01;
S.magnify        = 2;
S.transparent    = false;

save('prop','-struct','S');

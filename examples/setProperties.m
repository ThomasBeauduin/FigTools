% make new properties .mat file

%% PUBFIG
pfig.FigDim          = [20 14];
pfig.FontSize        = 14;
pfig.FontName        = 'Times New Roman';
pfig.Interpreter     = 'latex';
pfig.LineWidth       = 2.2;
pfig.AxisBox         = 'on';
pfig.AxisWidth       = 1.0;
pfig.LegendBox       = 'on';
pfig.LegendLoc       = 'northeast';
pfig.LegendOrient    = 'vertical';
pfig.Grid            = 'on';
pfig.MinorGrid       = 'off';
pfig.MinorTick       = 'on';
pfig.TickDir         = 'in';

%% EXPFIG
pfig.folder         = [];
pfig.name           = 'expfig_out';
pfig.crop           = true;
pfig.renderer       = 0; % 0:default, 1:OpenGL, 2:ZBuffer, 3:Painters
pfig.pdf            = false;
pfig.eps            = false;
pfig.png            = false;
pfig.bmp            = false;
pfig.emf            = false;
pfig.fig            = true;
pfig.grey           = false;
pfig.padding        = 0.1;
pfig.magnify        = 2;
pfig.transparent    = false;

save('prop','-struct','pfig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Publication-Quality-Figures:
% ----------------------------
% Descr.:   examples of publication figure creation
%           to demonstrate toolbox use and features.
% Figure:   Mathworks-plot-gallery-team source code.
% Author:   Thomas Beauduin, University of Tokyo, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;

%% Example 1: basic plot
x = 0:pi/1000:2*pi; y = sin(x);

hfig=figure; 
plot(x,y);
    title('sin wave')
    ylabel('position [mm]')
    xlabel('time [s]')
    legend('$y=sin(x)$')
hfig=pubfig(hfig)
expfig('figs\ex1_basicPlot','-pdf','-png','-bmp','-eps',hfig);

%% Example 2: bode plot
load('data\ex2_bodePlot.mat');

fig=figure;
subplot(211); 
    semilogx(freq,dbFRF,'b',freq,20*log10(abs(ssFRF)),'r');
    title('Mass Dependency') 
    ylabel('magnitude [dB]')
    legend('$\frac{sin(x)}{y}$','fit')
    xlim([20,250]), ylim([-100,-20])
subplot(212);
    semilogx(freq,phFRF+20,'b',freq,angle(ssFRF)*180/pi-360,'r');
    xlabel('frequency [Hz]')
    ylabel('phase [deg]')
    xlim([20,250]), ylim([-360,-90])
hfig=pubfig(fig)
    hfig.YTick={'','deg'};
    hfig.XMinorGrid='on';
expfig('figs\ex2_bodePlot','-pdf',hfig);

%% Example 3: DoublePlot
x = 0:pi/1000:2*pi; y = sin(x); y2 = cos(x.^2);

hfig=figure; 
haxis=plotyy(x,y,x,y2);
    title('test')
    ylabel(haxis(1),'$sin(x)$')
    ylabel(haxis(2),'$sin(x^2)$')
    xlabel('time [s]')
hfig=pubfig(hfig)
expfig('figs\ex3_DoublePlot','-pdf',hfig);

%% Example 4: Scatter
load seamount x y z

hfig=figure; 
scatter(x, y, 10, z, 'filled')
    title('Undersea Elevation')
    xlabel('Longitude')
    ylabel('Latitude')
    colorbar
hfig=pubfig(hfig)
expfig('figs\ex4_scatter','-pdf',hfig);

%% Example 5: Multi-Axis
t=linspace(0,2*pi); t(1)=eps; y=sin(t);

hfig=figure;
handaxes1 = axes('Position', [0.12 0.12 0.8 0.8]);
plot(t, y)
    xlabel('t')
    ylabel('$sin(t)$')
handaxes2 = axes('Position', [0.6 0.6 0.2 0.2]);
plot(t, y.^2, 'r')
    xlabel('t')
    ylabel('$sin(t)^2$')
handaxes3 = axes('Position', [0.25 0.25 0.2 0.2]);
plot(t, y.^3,'k')
    xlabel('t')
    ylabel('$sin(t)^3$')
hfig=pubfig(hfig);
    hfig.AxisBox='off';
    hfig.XGrid='off'; 
    hfig.YGrid='off';
expfig('figs\ex5_multiaxis','-pdf',hfig);

%% Example 6: Latex equations
for i=1:12, fib(i) = (((1+sqrt(5))/2)^i - ((1-sqrt(5))/2)^i)/sqrt(5); end

hfig=figure; plot(1:12, fib, 'k^-')
    title('Fibonacci Numbers from 1-12')
    xlabel('n')
    ylabel('$F_n$')
    eqtext = '$F_n={1 \over \sqrt{5}}';
    eqtext = [eqtext '\left[\left({1+\sqrt{5}\over 2}\right)^n -'];
    eqtext = [eqtext '\left({1-\sqrt{5}\over 2}\right)^n\right]$'];
    text(0.5, 125, eqtext)
hfig=pubfig(hfig)
    hfig.XGrid='off';    
    hfig.YGrid='off';
expfig('figs\ex6_latexEq','-pdf',hfig);

%% Example 7: Subplots
fm=20e3; fc=100e3; 
tstep=100e-9; tmax=200e-6; t=0:tstep:tmax;
xam = (1 + cos(2*pi*fm*t)).*cos(2*pi*fc*t);
T = 1e-6; N = 200; nT = 0:T:N*T;
xn = (1 + cos(2*pi*fm*nT)).*cos(2*pi*fc*nT);

hfig=figure; 
subplot(2,2,[1 3]);
    stem(nT,xn,'filled')
    xlabel('t [s]')
    ylabel('x[n]')
    title('sampled every millisec')
subplot(222)
    plot(t, xam)
    axis([0 200e-6 -2 2])
    xlabel('t [s]')
    ylabel('$x_{am}(t)$')
    title('AM Modulated Signal')
subplot(224)
    plot(nT, xn)
    xlabel('t [s]')
    ylabel('$x_{zoh}(t)$')
    title('Reconstruction')
hfig=pubfig(hfig)
    hfig.LineWidth=[0.5;2.2;2.2];
expfig('figs\ex7_subPlot','-pdf',hfig);

%% Example 8: high complexity
load data\ex8_complex xfit yfit xdata_m ydata_m ydata_s xVdata ...
                      yVdata xmodel ymodel ymodelL ymodelU

hfig=figure;
hFit = line(xfit,yfit,'Color',[0 0 .5]); hold on
errorbar(xdata_m,ydata_m,ydata_s,'LineStyle','none','Marker','.',...
        'Marker','o','MarkerSize',6,'MarkerEdgeColor',[.2 .2 .2],...
        'MarkerFaceColor',[.7 .7 .7],'Color',[.3 .3 .3]);
line(xVdata,yVdata,'LineStyle','none','Marker','.','Marker', 'o',...
        'MarkerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',...
        [.75 .75 1]);
line(xmodel, ymodel,'Color','r','LineStyle','--');
line(xmodel,ymodelL,'LineStyle','-.','Color',[0 .5 0]);
line(xmodel,ymodelU,'LineStyle','-.','Color',[0 .5 0]); hold off
    title('\textbf{Publication Quality Graphics}');
    xlabel('Length (m)');
    ylabel('Mass (kg)');
    legend('Data ($\mu \pm \sigma)$', 'Fit $(Cx^3)$', ...
           'Validation Data', 'Model $(Cx^3)$', '$95\% CI$');
hfig=pubfig(hfig)
    hfig.XMinorGrid='off'; hfig.YMinorGrid='off';
    hfig.LegendLoc='northwest';
    hfig.AxisBox = 'off';
    hfig.TickDir = 'out';
    hfig.XMinorTick = 'on';
    hfig.YMinorTick = 'on';
    hfig.YGrid = 'on';
    hfig.YTick = {(0:500:2500)};
expfig('figs\ex8_complex','-pdf',hfig);

%% Example 9: 3d plot
load data\ex9_3dplot masscharge time spectra

hfig=figure; plot3(masscharge,time,spectra)
    box on
    view(26, 42)
    axis([500 900 0 22 0 4e8])
    xlabel('Mass/Charge (M/Z)')
    ylabel('Time')
    zlabel('Ion Spectra')
    title('Extracted Spectra Subset')
hfig=pubfig(hfig);
expfig('figs\ex9_plot3d','-pdf',hfig);

%% Example 10: linetext
load data\ex10_linePlot points x y

hfig=figure;
plot(points(:,1),points(:,2),':ok'), hold on
plot(x, y), axis([.5 7 -.8 1.8])
    title('Convex-Hull Property')
    xlabel('x')
    ylabel('y')
    xt = points(3,1) - 0.05;
    yt = points(3,2) - 0.1;
    text(xt, yt, 'Point 3')

    xt = points(4,1) - 0.05;
    yt = points(4,2) + 0.1;
    text(xt, yt, 'Point 4')

    xt = points(5,1) + 0.15;
    yt = points(5,2) - 0.05;
    text(6.1,.5, 'Point 5')
hfig=pubfig(hfig)
expfig('figs\ex10_linePlot','-pdf',hfig);

%% Example 11: Surface-Contour plot
y = -10:0.5:10; x = -10:0.5:10;
[X, Y] = meshgrid(x, y);
Z = sin(sqrt(X.^2+Y.^2))./sqrt(X.^2+Y.^2);

hfig=figure;
surfc(X, Y, Z)
    view(-38, 18)
    title('Normal Response')
    xlabel('x')
    ylabel('y')
    zlabel('z')
hfig=pubfig(hfig);
expfig('figs\ex11_surface','-pdf',hfig);

%% Example 12: combine
load data\ex12_fitting x y yfit

hfig=figure;
scatter(x, y, 'k')
line(x, yfit, 'Color', 'k', 'LineStyle', '-')
line(x, yfit + 0.3, 'Color', 'r', 'LineStyle', '--')
line(x, yfit - 0.3, 'Color', 'r', 'LineStyle', '--')
    legend('Data', 'Fit', 'Lower/Upper Bounds')
    xlabel('Time')
    ylabel('Noisy Data')
hfig=pubfig(hfig);
expfig('figs\ex12_fitting','-pdf','-p0.2',hfig);
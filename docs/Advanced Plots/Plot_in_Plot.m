%%
% This is an example of how to create an inset plot within another plot in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/axes.html |axes|> function in the MATLAB documentation.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2012-2014 The MathWorks, Inc.

% Create data
t = linspace(0,2*pi);
t(1) = eps;
y = sin(t);

% Place axes at (0.1,0.1) with width and height of 0.8
figure
handaxes1 = axes('Position', [0.12 0.12 0.8 0.8]); 

% Main plot
plot(t, y)
xlabel('t')
ylabel('sin(t)')
set(handaxes1, 'Box', 'off')

% Adjust XY label font
handxlabel1 = get(gca, 'XLabel');
set(handxlabel1, 'FontSize', 16, 'FontWeight', 'bold')
handylabel1 = get(gca, 'ylabel');
set(handylabel1, 'FontSize', 16, 'FontWeight', 'bold')

% Place second set of axes on same plot
handaxes2 = axes('Position', [0.6 0.6 0.2 0.2]);
fill(t, y.^2, 'g')
set(handaxes2, 'Box', 'off')
xlabel('t')
ylabel('(sin(t))^2')

% Adjust XY label font
set(get(handaxes2, 'XLabel'), 'FontName', 'Times')
set(get(handaxes2, 'YLabel'), 'FontName', 'Times')

% Add another set of axes
handaxes3 = axes('Position', [0.25 0.25 0.2 0.2]);
plot(t, y.^3)
set(handaxes3, 'Box','off')
xlabel('t')
ylabel('(sin(t))^3')

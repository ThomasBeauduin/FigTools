%%
% This is an example of how to create an line plot from a function in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/fplot.html |fplot|> function in the MATLAB documentation.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2017 The MathWorks, Inc.

% Create a function plot of y = x^3 over the domain of [-2 2].
% Plot with a thick red line.
fplot(@(x) x.^3, [-2 2], 'r', 'LineWidth',2) 

% Add labels and title
xlabel('x')
ylabel('y')
title('y = x^3')

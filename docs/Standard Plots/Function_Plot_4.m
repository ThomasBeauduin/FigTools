%%
% This is an example of how to create an line plot from a parametric function in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/fplot.html |fplot|> function in the MATLAB documentation.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2017 The MathWorks, Inc.

% Create a parametric function plot x(t) = sin(2*t), y(t) = sin(3*t)
x = @(t) sin(2*t);
y = @(t) sin(3*t);
fplot(x,y)

% Add labels and title
xlabel('x')
ylabel('y')
title('x(t) = sin(2*t), y(t) = sin(3*t)')

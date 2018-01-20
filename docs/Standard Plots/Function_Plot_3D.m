%%
% This is an example of how to create a 3D line plot from a function in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/fplot3.html |fplot3|> function in the MATLAB documentation. This function is available in R2016a or newer.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2017 The MathWorks, Inc.

% Check version
if verLessThan('matlab','9.0')
    error(['fplot3 is available in R2016a or newer. ', ...
        'For older releases, use ezplot3 instead.'])
end

% Create the plot using the parametric functions
% x = cos(t), y = sin(t), and z = sin(5*t) for -pi < t < pi
figure
fplot3(@cos, @sin, @(t) sin(5*t), [-pi pi])

% Add labels and title
xlabel('x')
ylabel('y')
zlabel('z')
title('x = cos(t), y = sin(t), z = sin(5*t)')

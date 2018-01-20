%%
% This is an example of how to create an line plot from a function in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/fimplicit.html |fimplicit|> function in the MATLAB documentation. This function is available in R2016b or newer.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2017 The MathWorks, Inc.

% Check version
if verLessThan('matlab','9.1')
    error(['fimplicit is available in R2016b or newer. ', ...
        'For older releases, use ezplot instead.'])
end

% Create a series of lines for the function f(x,y) = y^2 - x^2 + c
figure
fimplicit(@(x,y) y.^2 - x.^2 + 4, [-3 3 -3 3])
hold on
fimplicit(@(x,y) y.^2 - x.^2 + 2, [-3 3 -3 3])
fimplicit(@(x,y) y.^2 - x.^2, [-3 3 -3 3])
fimplicit(@(x,y) y.^2 - x.^2 - 2, [-3 3 -3 3])
fimplicit(@(x,y) y.^2 - x.^2 - 4, [-3 3 -3 3])
hold off

grid on

legend('c = -4','c = -2','c = 0','c = 2','c = 4')

% Add title
title('y^2 - x^2 - c = 0 for c = [-4 -2 0 2 4]')

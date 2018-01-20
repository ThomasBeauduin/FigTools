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

% Create the plot using the lemniscate function f(x,y) = (x^2 + y^2)^2 - x^2 + y^2
figure
fimplicit(@(x,y) (x.^2 + y.^2).^2 - x.^2 + y.^2, [-1.1 1.1 -1.1 1.1])

% Adjust the colormap to plot the function in blue
colormap([0 0 1])

% Add a multi-line title
title({'Lemniscate Function', '(x^2 + y^2)^2 - x^2 + y^2'})

%%
% This is an example of how to create an line plot with markers in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/plot.html |plot|> function in the MATLAB documentation.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2012-2014 The MathWorks, Inc.

% Load Morse data
load MDdata dissimilarities dist1 dist2 dist3

% Plot the first set of data in blue
figure
plot(dissimilarities, dist1, 'bo')
hold on

% Plot the second set of data in red
plot(dissimilarities, dist2, 'r+')

% Plot the third set of data in green
plot(dissimilarities, dist3, 'g^')

% Add title and axis labels
title('Morse Signal Analysis')
xlabel('Dissimilarities')
ylabel('Distances')

% Add a legend
legend({'Stress', 'Sammon Mapping', 'Squared Stress'}, ...
    'Location', 'NorthWest')

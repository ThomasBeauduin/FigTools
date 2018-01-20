%%
% This is an example of how to create an x-axis semilog plot in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/semilogx.html |semilogx|> function in the MATLAB documentation.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2012-2014 The MathWorks, Inc.

% Load the response data
load responseData frequency magnitude

% Create an x-axis semilog plot using the semilogx function
figure
semilogx(frequency, magnitude)

% Set the axis limits and turn on the grid
axis([min(frequency) max(frequency) -6.5 6.5])
grid on

% Add title and axis labels
title('Magnitude Response (dB)')
xlabel('Frequency (kHz)')
ylabel('Magnitude (dB)')

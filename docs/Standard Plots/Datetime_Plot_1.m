%%
% This is an example of how to create a datetime plot in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/datetime.html |datetime|> function and the <http://www.mathworks.com/help/matlab/ref/axes-properties.html#prop_XAxis |XAxis|> property in the MATLAB documentation. This function is available in R2016b or newer.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2017 The MathWorks, Inc.

% Check version
if verLessThan('matlab','9.1')
    error('heatmap is available in R2016b or newer.')
end

% Load bike ride summary data
load RideSummary byDate

% Plot the mean bike ride duration versus date
plot(byDate.Date, byDate.MeanDuration)

% Change limits and date format
limits = [datetime(2012,7,1) datetime(2012,8,31)];
xlim(limits)
ax = gca;
ax.XAxis.TickLabelFormat = 'MMMM dd';
ax.XAxis.TickLabelRotation = 40;

% Add labels and title
xlabel('Date')
ylabel('Mean Ride Duration')
title('Mean Ride Duration between July and August 2012')

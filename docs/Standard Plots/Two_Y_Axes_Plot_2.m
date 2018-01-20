%%
% This is an example of how to create a plot with two y axes in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/yyaxis.html |yyaxis|> function in the MATLAB documentation. This function is available in R2016a or newer.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2017 The MathWorks, Inc.

% Check version
if verLessThan('matlab','9.0')
    error(['yyaxis is available in R2016a or newer. ', ...
        'For older releases, use plotyy instead.'])
end

% Create the data for the plots
TBdata = [1990 4889 16.4; 1991 5273 17.4; 1992 5382 17.4; 1993 5173 16.5;
          1994 4860 15.4; 1995 4675 14.7; 1996 4313 13.5; 1997 4059 12.5;
          1998 3855 11.7; 1999 3608 10.8; 2000 3297  9.7; 2001 3332  9.6;
          2002 3169  9.0; 2003 3227  9.0; 2004 2989  8.2; 2005 2903  7.9;
          2006 2779  7.4; 2007 2725  7.2];

years = TBdata(:,1);
cases = TBdata(:,2);
rate  = TBdata(:,3);

% Create a plot with 2 y axes using the yyaxis function
% Create a bar chart for cases on the left axes
figure
yyaxis left
bar(years, cases, 'FaceColor', [0.8 0.8 0.8])
ylabel('Cases')

% Create a line plot for infection rate on the right axes
yyaxis right
plot(years, rate, 'LineWidth', 2);
ylabel('Infection rate in cases per thousand')

% Add title and x axis label
title('Tuberculosis Cases: 1991-2007')
xlabel('Years')

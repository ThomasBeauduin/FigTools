%%
% This is an example of how to create two overlapping waves in 3 dimension in MATLAB&#174;.
% 
% Read about the <http://www.mathworks.com/help/matlab/ref/quiver3.html |quiver3|> and <http://www.mathworks.com/help/matlab/ref/fill3.html |fill3|> functions in the MATLAB documentation.
%
% For more examples, go to <http://www.mathworks.com/discovery/gallery.html MATLAB Plot Gallery>
%
% Copyright 2012-2014 The MathWorks, Inc.

% Create some x data
x = linspace(0, 4*pi, 30);  

% Create two waves to plot
y = sin(x);              
z = sin(x-pi);           

% Plot the first wave in red and fill with color
u = zeros(size(x));
figure
fill3(x, y, u, 'r', 'EdgeColor', 'r', 'FaceAlpha', 0.5)
hold on

% Add arrows for the first wave                      
quiver3(x, u, u, u, y, u, 0, 'r')     
 
% Plot the first wave in blue and fill with color
fill3(x, u, z, 'b', 'EdgeColor', 'b', 'FaceAlpha', 0.5)  

% Add the arrows for the second wave
quiver3(x, u, u, u, u, z, 0, 'b')  
                     
% Use equal axis scaling 
view(-49,28)
axis square
daspect([1 1 1])
xlim([0 13])
ylim([-1 1])
zlim([-1 1])

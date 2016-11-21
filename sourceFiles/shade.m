function [ha hb hc] = shade(x, y1, y2, varargin)

% SHADEDPLOT draws two lines on a plot and shades the area between those
% lines.
%
% SHADEDPLOT(x, y1, y2)
%   All of the arguments are vectors of the same length, and each y-vector is
%   horizontal (i.e. size(y1) = [1  N]). Vector x contains the x-axis values,
%   and y1:y2 contain the y-axis values.
%
%   Plot y1 and y2 vs x, then shade the area between those two
%   lines. Highlight the edges of that band with lines.
%
%   SHADEDPLOT(x, y1, y2, areacolor, linecolor)
%   The arguments areacolor and linecolor allow the user to set the color
%   of the shaded area and the boundary lines. These arguments must be
%   either text values (see the help for the PLOT function) or a
%   3-element vector with the color values in RGB (see the help for
%   COLORMAP).
%
%   [HA HB HC = SHADEDPLOT(x, y1, y2) returns three handles to the calling
%   function. HA is a vector of handles to areaseries objects (HA(2) is the
%   shaded area), HB is the handle to the first line (x vs y1), and HC is
%   the handle to the second line (x vs y2).
%%%%%

if y1 == 0, y1 = zeros(length(x),1); end
if y2 == 0, y2 = zeros(length(x),1); end
y1 = y1(:); y2 = y2(:); x = x(:);
y = [y1, (y2-y1)];

ha = area(x, y);
set(ha(1), 'FaceColor', 'none') % this makes the bottom area invisible
set(ha, 'LineStyle', 'none')

% plot the line edges
hold on 
hb = plot(x, y1, 'LineWidth', 1);
hc = plot(x, y2, 'LineWidth', 1);
hold off

% set the line and area colors if they are specified
switch length(varargin)
    case 0
        set(ha(2), 'FaceColor', [0.7,0.7,1])
        set(hb, 'Color', [1,1,1])
        set(hc, 'Color', [1,1,1])
    case 1
        set(ha(2), 'FaceColor', varargin{1})
        set(hb, 'Color', [1,1,1])
        set(hc, 'Color', [1,1,1])
    case 2
        set(ha(2), 'FaceColor', varargin{1})
        set(hb, 'Color', varargin{2})
        set(hc, 'Color', varargin{2})
    otherwise
end

% put the grid on top of the colored area
set(gca, 'Layer', 'top')
grid on

% output handles
ha = ha(2);
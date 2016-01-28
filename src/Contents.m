% Source folder contents
% Publication-Quality-Figures Toolbox
% Version 1.0 (R2013a) Jan-2016 
% 
% Step 1: Create Figures
%       magnifyOnFig  - Magnification plot of 2d-lines in figure.
%
% Step 2: Publish Figures
%       pubfig        - Class for publication figure objects.
%       formatTicks   - Ticks formating of figures x/y labels.
%
% Step 3: Export Figures
%       expfig        - Export function for mat/pub figure objects.
%       print2array   - Exports a figure to an image array/bitmap image.
%       print2eps     - Prints figures to eps with improved line styles.
%       eps2pdf       - Convert eps file to pdf format using ghostscript.
%       pdf2eps       - Convert pdf file to eps format using pdftops.
%       mlf2pdf       - Pdflatex export of matlab figures using matlabfrag.
%       ghostscript   - Calls local GhostScript executable with input command.
%       pdftops       - Calls local pdftops executable with input command.
%       matlabfrag    - Exports a matlab figure to .eps file and .tex file.
%
% Auxiliary
%       crop_borders  - Crop the borders of an image or stack of images.
%       user_string   - Get/set a user specific string for output.
%       using_hg2     - Determine if hg2 graphics engine used (2014b).
%
% Author: Thomas Beauduin
% Copyright (c) GSFS, University of Tokyo, Japan
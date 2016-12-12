FigTools
========

Publication-Quality-Figures Matlab Toolbox.

# Overview
Generating and exporting matlab figures for academic publication is a
troublesome and time consuming task with a whole range of bug-prone
<code>set</code> and <code>get</code> functions for the tiny - 
but non-neglectable - details of figures in academic papers.
Firstly, this matlab toolbox aims to automate these visual tasks for a broad 
range of figure types and styles. This includes the options to modify the 
publication relevant aspects of axis, grids, linewidths, ... with minimal 
effort and coding-lines.

Secondely, this matlab toolbox aims to automate figure exporting for 
inclusion in latex-based scientific publications. This includes embedding
font, setting colorspace and getting the right file type and resolution.

The toolbox is based on the concept of a natural three-step approach
to figure creation:

1. **Generate:** generate plotting and graphical data (matfig-obj).
2. **Publish:** publication layout & visual fine-tuning (pubfig-obj).
3. **Export:** export creation as-on-screen to bitmap/vector (expfig-obj).

# Description

The different steps in figure creation are described in this section.
For detailed examples refer to the example folder based on matlab graphical gallery.
Don't hesitate to post issues!

## Generate Figure

Conventional matlab-figure coding, well known by the users and compact
approach to graphical data generation.

## Publish Figure

Automate the default calls for visual embellishment of the figure
by calling the <code>pubfig</code> class with your own default visual settings.
The <code>pubfig</code> class provides a simple and elegant object oriented 
programming interface for manipulating publication figures.

## Export Figure

The goal is to export a plot from screen to document, just the way you see it!

# Technical Details

Detailed explation regarding the graphical objects in matlab and how to
manipulate them, following mathworks pages give a usefull overview:
http://www.mathworks.com/help/matlab/graphics-objects.html
http://www.mathworks.com/help/matlab/graphics-object-properties.html

Note: the toolbox was created and tested for typical eletrical and mechanical
engineering graphics; some research fields may have very different publication
figure requirements.

# To Do list

[] bodefig: generate level code for nice bode plots
[] flex legend: more options to legend styles
[] align subplot axis
[] seperate default propoerties
[] include pzmap from ohnishi
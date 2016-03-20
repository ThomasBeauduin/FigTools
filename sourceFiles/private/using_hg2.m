function tf = using_hg2(fig)
%USING_HG2 - Determine if the HG2 graphics engine is used.
%
%   tf = using_hg2(fig)
%   fig - handle to the figure in question.
%   tf - boolean, HG2 graphics engine used or not
%

    persistent tf_cached
    if isempty(tf_cached)
        try
            if nargin < 1,  fig = figure('visible','off');  end
            oldWarn = warning('off','MATLAB:graphicsversion:GraphicsVersionRemoval');
            try
                % This generates a [supressed] warning in R2015b:
                tf = ~graphicsversion(fig, 'handlegraphics');
            catch
                tf = verLessThan('matlab','8.4');  % =R2014b
            end
            warning(oldWarn);
        catch
            tf = false;
        end
        if nargin < 1,  delete(fig);  end
        tf_cached = tf;
    else
        tf = tf_cached;
    end
end

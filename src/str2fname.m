function str = str2fname(val)
%str2fname - replace '.', '-', etc to 'o', 'm' 
%            to save a string as a folder/file name

str = num2str(val);

str = strrep(str, '.', 'o');
str = strrep(str, ',', '_');
str = strrep(str, '=', '');
str = strrep(str, ' ', '_');
str = strrep(str, '-', 'm');
str = strrep(str, '\', '');
str = strrep(str, '$', '');
str = strrep(str, 'e+', 'e');
str = strrep(str, '00', '0');
str = strrep(str, '(', '_');
str = strrep(str, ')', '');
str = strrep(str, '{', '');
str = strrep(str, '}', '');

end
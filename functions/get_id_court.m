function id = get_id_court(str)

str = fliplr(str);
dot_index = min(strfind(str,'.'));
space_index = min(strfind(str,' '));
id = fliplr(str(dot_index+1:space_index-1));
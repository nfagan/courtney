function str = find_exp_code(str)

str = str(5:end);

tf = isstrprop(str, 'digit');
rows = 1:length(tf);
find_first = min(rows(tf));

if find_first >= 2;
    str = str(1:find_first-1);
else
    str = [];
end

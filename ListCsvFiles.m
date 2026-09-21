function names = ListCsvFiles(folderPath)
if ~isfolder(folderPath), names = {}; return; end
d = dir(fullfile(folderPath,'*.csv'));
names = {d.name};
if isempty(names), names = {}; end
end

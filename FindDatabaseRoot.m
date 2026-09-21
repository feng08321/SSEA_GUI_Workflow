function databaseRoot = FindDatabaseRoot()
candidate1 = fullfile(pwd, 'Database');
candidate2 = fullfile(pwd, '..', 'Database');
if isfolder(candidate1), databaseRoot = candidate1; return; end
if isfolder(candidate2), databaseRoot = candidate2; return; end
selected = uigetdir(pwd, 'Please select SSEA Database folder');
if isequal(selected,0), error('SSEA:DatabaseNotSelected','Database folder was not selected.'); end
databaseRoot = selected;
end

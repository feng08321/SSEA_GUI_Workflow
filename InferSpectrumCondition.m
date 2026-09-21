function info = InferSpectrumCondition(referenceFile, testFile)
[~, refName, ~] = fileparts(referenceFile);
[~, testName, ~] = fileparts(testFile);
name = [refName '_' testName];

info = struct();
info.Mode = 'Unknown';
info.Condition = 'Unknown';
info.ConditionNumber = NaN;
info.Label = 'Unknown';

if contains(upper(name), 'GHI')
    info.Mode = 'GHI';
elseif contains(upper(name), 'DNI')
    info.Mode = 'DNI';
end

tok = regexp(name, 'Cond(\d+)', 'tokens', 'once');
if ~isempty(tok)
    info.ConditionNumber = str2double(tok{1});
    info.Condition = sprintf('Cond%02d', info.ConditionNumber);
end

if strcmp(info.Mode,'Unknown') && strcmp(info.Condition,'Unknown')
    info.Label = 'User-defined';
elseif strcmp(info.Condition,'Unknown')
    info.Label = info.Mode;
else
    info.Label = [info.Mode '-' info.Condition];
end
end

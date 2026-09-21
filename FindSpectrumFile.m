function filePath = FindSpectrumFile(databaseRoot, modeName, roleName, condNum)
% Find spectrum file by mode, role, and condition.
spectrumFolder = fullfile(databaseRoot,'Spectrum');
pattern = sprintf('*%s*%s*Cond%02d*.csv', upper(modeName), roleName, condNum);
d = dir(fullfile(spectrumFolder, pattern));
if isempty(d)
    pattern = sprintf('*%s*%s*Cond%d*.csv', upper(modeName), roleName, condNum);
    d = dir(fullfile(spectrumFolder, pattern));
end
if isempty(d)
    error('SSEA:SpectrumNotFound','Cannot find %s %s Cond%02d spectrum.', modeName, roleName, condNum);
end
filePath = fullfile(spectrumFolder, d(1).name);
end

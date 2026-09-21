function BatchResult = RunBatchCurrentConfig(config, databaseRoot)
% Run GHI/DNI Cond01-Cond09 using current sensor/component/band config.
modes = {'GHI','DNI'};
rows = {};
resultList = {};
n = 0;

for im = 1:numel(modes)
    modeName = modes{im};
    for cond = 1:9
        cfg = config;
        cfg.referenceSpectrumFile = FindSpectrumFile(databaseRoot, modeName, 'Reference', cond);
        cfg.testSpectrumFile      = FindSpectrumFile(databaseRoot, modeName, 'Test', cond);
        R = CalculateSpectralError(cfg);
        n = n + 1;
        [~, refName, ext1] = fileparts(cfg.referenceSpectrumFile);
        [~, testName, ext2] = fileparts(cfg.testSpectrumFile);
        rows(n,:) = {modeName, cond, [refName ext1], [testName ext2], R.CSSE_percent, R.Error_ratio_percent, R.PositiveArea, R.NegativeArea, R.CancellationRatio}; %#ok<AGROW>
        resultList{n} = R; %#ok<AGROW>
    end
end

T = cell2table(rows, 'VariableNames', {'Mode','Condition','ReferenceFile','TestFile','CSSE_percent','RatioError_percent','PositiveArea','NegativeArea','CancellationRatio'});

summaryRows = {};
for im = 1:numel(modes)
    modeName = modes{im};
    idx = strcmp(T.Mode, modeName);
    values = T.CSSE_percent(idx);
    absValues = abs(values);
    [maxAbs, localIdx] = max(absValues);
    conds = T.Condition(idx);
    summaryRows(im,:) = {modeName, maxAbs, mean(absValues), conds(localIdx), values(localIdx)}; %#ok<AGROW>
end
Summary = cell2table(summaryRows, 'VariableNames', {'Mode','MaxAbsCSSE_percent','MeanAbsCSSE_percent','WorstCondition','WorstCSSE_percent'});

BatchResult = struct();
BatchResult.Table = T;
BatchResult.Summary = Summary;
BatchResult.ResultList = resultList;
BatchResult.BaseConfig = config;
end

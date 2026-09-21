function ExportBatchResult(BatchResult, outputFolder, baseName)
if nargin < 3
    baseName = ['SSEA_Batch_' datestr(now,'yyyymmdd_HHMMSS')];
end
if ~isfolder(outputFolder), mkdir(outputFolder); end
writetable(BatchResult.Table, fullfile(outputFolder, [baseName '_table.csv']));
writetable(BatchResult.Summary, fullfile(outputFolder, [baseName '_summary.csv']));
save(fullfile(outputFolder, [baseName '.mat']), 'BatchResult');
end

function ExportBandContributionResult(BandResult10, BandResult100, outputFolder, baseName)
% ExportBandContributionResult Export band contribution tables and summaries.
if nargin < 4 || isempty(baseName)
    baseName = ['SSEA_BandContribution_' datestr(now,'yyyymmdd_HHMMSS')];
end
if ~isfolder(outputFolder), mkdir(outputFolder); end

writetable(BandResult10.Table, fullfile(outputFolder, [baseName '_10nm_table.csv']));
writetable(BandResult10.Summary, fullfile(outputFolder, [baseName '_10nm_summary.csv']));

writetable(BandResult100.Table, fullfile(outputFolder, [baseName '_100nm_table.csv']));
writetable(BandResult100.Summary, fullfile(outputFolder, [baseName '_100nm_summary.csv']));

save(fullfile(outputFolder, [baseName '.mat']), 'BandResult10', 'BandResult100');
end

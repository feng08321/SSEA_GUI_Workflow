function ExportSpectralErrorResult(Result, outputFolder, baseName)
if nargin<3, baseName='SSEA_Result'; end
if ~isfolder(outputFolder), mkdir(outputFolder); end
T=table(Result.lambda_nm,Result.Eref,Result.Etest,Result.Eref_norm,Result.Etest_norm,Result.Rsys,Result.Rnorm,Result.Contribution,Result.CumulativeContribution, ...
'VariableNames',{'wavelength_nm','Eref','Etest','Eref_norm','Etest_norm','Rsys','Rnorm','Contribution','CumulativeContribution'});
writetable(T,fullfile(outputFolder,[baseName '_curves.csv']));
S=table(Result.CSSE,Result.CSSE_percent,Result.Error_ratio,Result.Error_ratio_percent,Result.PositiveArea,Result.NegativeArea,Result.CancellationRatio, ...
'VariableNames',{'CSSE','CSSE_percent','Error_ratio','Error_ratio_percent','PositiveArea','NegativeArea','CancellationRatio'});
writetable(S,fullfile(outputFolder,[baseName '_summary.csv']));
end

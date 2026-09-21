function Result = CalculateSpectralError(config)
lambda_grid=MakeWavelengthGrid(config.lambdaStart_nm,config.lambdaEnd_nm,config.step_nm);
refPrepared=PrepareSpectralFunction(config.referenceSpectrumFile,lambda_grid,'none',0);
testPrepared=PrepareSpectralFunction(config.testSpectrumFile,lambda_grid,'none',0);
Eref=refPrepared.value; Etest=testPrepared.value;
if isempty(config.detectorFile)
    detectorPrepared=[]; Rsys=ones(size(lambda_grid));
else
    detectorPrepared=PrepareSpectralFunction(config.detectorFile,lambda_grid,config.detectorTransform,0);
    Rsys=detectorPrepared.value;
end
componentPrepared={};
if isfield(config,'componentFiles')
for k=1:numel(config.componentFiles)
    f=config.componentFiles{k}; if isempty(f), continue; end
    if isfield(config,'componentTransforms') && numel(config.componentTransforms)>=k, tfm=config.componentTransforms{k}; else, tfm='none'; end
    cp=PrepareSpectralFunction(f,lambda_grid,tfm,0);
    componentPrepared{end+1}=cp; %#ok<AGROW>
    Rsys=Rsys.*cp.value;
end
end
if config.useNormalizedR, Rnorm=NormalizeVectorMax(Rsys); else, Rnorm=Rsys; end
Eref_norm=NormalizeSpectrumByIntegral(lambda_grid,Eref);
Etest_norm=NormalizeSpectrumByIntegral(lambda_grid,Etest);
cont=CalculateContribution(lambda_grid,Rnorm,Eref_norm,Etest_norm);
Error_ratio=trapz(lambda_grid,Rnorm.*Etest_norm)/trapz(lambda_grid,Rnorm.*Eref_norm)-1;
Result.config=config; Result.lambda_nm=lambda_grid; Result.Prepared.reference=refPrepared; Result.Prepared.test=testPrepared;
Result.Prepared.detector=detectorPrepared; Result.Prepared.components=componentPrepared;
Result.Eref=Eref; Result.Etest=Etest; Result.Eref_norm=Eref_norm; Result.Etest_norm=Etest_norm;
Result.Rsys=Rsys; Result.Rnorm=Rnorm; Result.Contribution=cont.Contribution; Result.CumulativeContribution=cont.CumulativeContribution;
Result.CSSE=cont.CSSE; Result.CSSE_percent=cont.CSSE_percent; Result.Error_ratio=Error_ratio; Result.Error_ratio_percent=Error_ratio*100;
Result.PositiveArea=cont.PositiveArea; Result.NegativeArea=cont.NegativeArea; Result.CancellationRatio=cont.CancellationRatio;
end

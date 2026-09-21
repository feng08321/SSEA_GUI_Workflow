function prepared = PrepareSpectralFunction(filename, lambda_grid, transformType, fillValue)
if nargin<3 || isempty(transformType), transformType='none'; end
if nargin<4, fillValue=0; end
raw=LoadSpectralFunction(filename);
transformed=ApplySpectralTransform(raw.raw_value, transformType);
raw.value=transformed;
interpValue=InterpolateSpectralFunction(raw,lambda_grid,fillValue);
qc.hasNaN_prepared=any(isnan(interpValue));
qc.prepared_min=min(interpValue); qc.prepared_max=max(interpValue);
qc.wavelength_min_nm=min(raw.wavelength_nm); qc.wavelength_max_nm=max(raw.wavelength_nm);
qc.hasNegative_prepared=any(interpValue<0); qc.hasAboveOne_prepared=any(interpValue>1);
prepared.filename=filename; prepared.raw_wavelength_nm=raw.wavelength_nm; prepared.raw_value=raw.raw_value;
prepared.transformed_value=transformed; prepared.lambda_nm=lambda_grid(:); prepared.value=interpValue(:);
prepared.transformType=transformType; prepared.qc=qc;
end

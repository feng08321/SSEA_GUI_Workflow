function y = InterpolateSpectralFunction(data, lambda_grid, fillValue)
if nargin<3, fillValue=0; end
y=interp1(data.wavelength_nm(:),data.value(:),lambda_grid(:),'linear',fillValue);
y=y(:);
end

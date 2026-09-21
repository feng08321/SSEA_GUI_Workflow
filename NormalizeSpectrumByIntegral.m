function Enorm = NormalizeSpectrumByIntegral(lambda_grid,E)
I=trapz(lambda_grid(:),E(:));
if I==0||~isfinite(I), error('SSEA:ZeroSpectrumIntegral','Spectrum integral is zero or invalid.'); end
Enorm=E(:)./I;
end

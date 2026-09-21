function y = ApplySpectralTransform(x, transformType)
if nargin<2 || isempty(transformType), transformType='none'; end
x=x(:);
switch lower(strtrim(transformType))
    case {'none','direct','value'}, y=x;
    case {'percent_to_ratio','transmittance_percent_to_ratio','response_percent_to_ratio'}, y=x./100;
    case {'reflectance_to_absorptance','one_minus_value'}, y=1-x;
    case {'reflectance_percent_to_absorptance','one_minus_percent'}, y=1-x./100;
    case {'absorptance_percent_to_ratio'}, y=x./100;
    otherwise, error('SSEA:UnknownTransform','Unknown transformType: %s',transformType);
end
end

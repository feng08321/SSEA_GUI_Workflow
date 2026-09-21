function lambda_grid = MakeWavelengthGrid(lambda_start_nm, lambda_end_nm, step_nm)
if lambda_end_nm<=lambda_start_nm, error('SSEA:InvalidWavelengthRange','lambda_end_nm must be larger than lambda_start_nm.'); end
lambda_grid=(lambda_start_nm:step_nm:lambda_end_nm).';
end

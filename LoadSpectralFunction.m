function data = LoadSpectralFunction(filename)
if ~isfile(filename), error('SSEA:FileNotFound','File not found: %s',filename); end
opts = detectImportOptions(filename);
T = readtable(filename,opts);
if width(T)<2, error('SSEA:InvalidCSV','CSV must contain at least two columns.'); end
wl=T{:,1}; val=T{:,2};
valid=isfinite(wl)&isfinite(val); wl=wl(valid); val=val(valid);
[wl,idx]=sort(wl); val=val(idx);
[wlu,~,ic]=unique(wl);
if numel(wlu)<numel(wl), val=accumarray(ic,val,[],@mean); wl=wlu; end
data.filename=filename; data.wavelength_nm=wl(:); data.raw_value=val(:); data.value=val(:);
end

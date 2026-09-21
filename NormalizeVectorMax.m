function yn = NormalizeVectorMax(y)
y=y(:); m=max(abs(y));
if isempty(m)||m==0||~isfinite(m), yn=y; else, yn=y./m; end
end

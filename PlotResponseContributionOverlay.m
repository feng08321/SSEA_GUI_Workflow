function PlotResponseContributionOverlay(Result, ax)
% Single-axis normalized system response + signed normalized contribution.
lambda = Result.lambda_nm(:);
R = Result.Rnorm(:);
C = Result.Contribution(:);

cla(ax);
hold(ax,'on');

Cscale = max(abs(C));
if isempty(Cscale) || ~isfinite(Cscale) || Cscale == 0
    Cn = C;
else
    Cn = C ./ Cscale;
end

Cp = Cn; Cp(Cp < 0) = NaN;
Cnneg = Cn; Cnneg(Cnneg > 0) = NaN;

plot(ax, lambda, R, 'LineWidth', 1.2, 'DisplayName','Rnorm');
plot(ax, lambda, Cp, 'LineWidth', 1.0, 'DisplayName','Contribution + norm');
plot(ax, lambda, Cnneg, 'LineWidth', 1.0, 'DisplayName','Contribution - norm');

hold(ax,'off');
grid(ax,'on');
xlabel(ax,'Wavelength (nm)');
ylabel(ax,'Normalized value');
ylim(ax,[-1.05 1.05]);
title(ax,'System response and normalized contribution');
legend(ax,'Location','best');
end

function OpenBandContributionFigures(BandResult10, BandResult100, Result)
if nargin >= 3 && ~isempty(Result)
    figure('Name','SSEA - Response and Contribution Overlay');
    ax = axes;
    PlotResponseContributionOverlay(Result, ax);
end

figure('Name','SSEA Band Contribution - 10 nm');
ax = axes;
PlotBandContribution(BandResult10, ax);

figure('Name','SSEA Band Contribution - 100 nm');
ax = axes;
PlotBandContribution(BandResult100, ax);
end

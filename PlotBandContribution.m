function PlotBandContribution(BandResult, ax)
T = BandResult.Table;
cla(ax);
hold(ax,'on');

pos = T.ContributionIntegral;
pos(pos < 0) = NaN;
neg = T.ContributionIntegral;
neg(neg > 0) = NaN;

bar(ax, T.BandCenter_nm, pos, 1.0, 'DisplayName','Positive');
bar(ax, T.BandCenter_nm, neg, 1.0, 'DisplayName','Negative');

hold(ax,'off');
grid(ax,'on');
xlabel(ax,'Band center wavelength (nm)');
ylabel(ax,'Band-integrated contribution');
title(ax, sprintf('Band Contribution, %g nm, %s', BandResult.BinWidth_nm, BandResult.Mode));
legend(ax,'Location','best');
end

function PlotBatchResult(BatchResult, axLine, axBar)
T = BatchResult.Table;
modes = unique(T.Mode,'stable');

cla(axLine); hold(axLine,'on');
for i = 1:numel(modes)
    idx = strcmp(T.Mode,modes{i});
    plot(axLine, T.Condition(idx), T.CSSE_percent(idx), '-o', 'DisplayName', modes{i}, 'LineWidth', 1.1);
end
hold(axLine,'off');
grid(axLine,'on');
xlabel(axLine,'Condition');
ylabel(axLine,'CSSE (%)');
title(axLine,'Batch CSSE sequence');
legend(axLine,'Location','best');

cla(axBar);
S = BatchResult.Summary;
bar(axBar, S.MaxAbsCSSE_percent);
axBar.XTick = 1:height(S);
axBar.XTickLabel = S.Mode;
xlabel(axBar,'Irradiance mode');
ylabel(axBar,'Max |CSSE| (%)');
title(axBar,'Worst-case CSSE');
grid(axBar,'on');
end

function OpenBatchFigures(BatchResult)
T = BatchResult.Table;
modes = unique(T.Mode,'stable');

figure('Name','SSEA Batch - CSSE Sequence');
hold on;
for i = 1:numel(modes)
    idx = strcmp(T.Mode,modes{i});
    plot(T.Condition(idx), T.CSSE_percent(idx), '-o', 'DisplayName', modes{i}, 'LineWidth', 1.2);
end
hold off; grid on;
xlabel('Condition'); ylabel('CSSE (%)');
title('Batch CSSE Sequence');
legend('Location','best');

figure('Name','SSEA Batch - Worst Case CSSE');
S = BatchResult.Summary;
bar(S.MaxAbsCSSE_percent);
ax = gca;
ax.XTick = 1:height(S);
ax.XTickLabel = S.Mode;
xlabel('Irradiance mode');
ylabel('Max |CSSE| (%)');
title('Worst-case CSSE');
grid on;

figure('Name','SSEA Batch - Ratio Error Sequence');
hold on;
for i = 1:numel(modes)
    idx = strcmp(T.Mode,modes{i});
    plot(T.Condition(idx), T.RatioError_percent(idx), '-o', 'DisplayName', modes{i}, 'LineWidth', 1.2);
end
hold off; grid on;
xlabel('Condition'); ylabel('Ratio-based error (%)');
title('Batch Ratio-based Error Sequence');
legend('Location','best');
end

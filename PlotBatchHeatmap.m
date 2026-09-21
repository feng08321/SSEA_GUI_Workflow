function PlotBatchHeatmap(BatchResult, ax)
T = BatchResult.Table;
modes = unique(T.Mode,'stable');
condList = unique(T.Condition,'stable');
M = NaN(numel(modes), numel(condList));
for i = 1:numel(modes)
    for j = 1:numel(condList)
        idx = strcmp(T.Mode,modes{i}) & T.Condition == condList(j);
        if any(idx)
            M(i,j) = T.CSSE_percent(find(idx,1));
        end
    end
end
cla(ax);
imagesc(ax, condList, 1:numel(modes), M);
colorbar(ax);
yticks(ax,1:numel(modes));
yticklabels(ax,modes);
xlabel(ax,'Condition');
ylabel(ax,'Mode');
title(ax,'CSSE heatmap (%)');
grid(ax,'on');
try
    for i = 1:numel(modes)
        for j = 1:numel(condList)
            if isfinite(M(i,j))
                text(ax, condList(j), i, sprintf('%.3g',M(i,j)), ...
                    'HorizontalAlignment','center','Color','w','FontSize',8);
            end
        end
    end
catch
end
end

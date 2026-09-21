function T2 = MakeBatchSummaryTable(BatchResult)
T = BatchResult.Table;
Label = strcat(T.Mode, "-", compose("Cond%02d", T.Condition));
T2 = table(Label, T.Mode, T.Condition, T.CSSE_percent, T.RatioError_percent, ...
    'VariableNames', {'Label','Mode','Condition','CSSE_percent','RatioError_percent'});
end

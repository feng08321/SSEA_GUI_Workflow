function ResetAxesClean(ax)
% ResetAxesClean Clear axes, including possible yyaxis residue.
try
    yyaxis(ax,'left'); cla(ax);
    yyaxis(ax,'right'); cla(ax);
    yyaxis(ax,'left');
catch
    cla(ax);
end
ax.XLimMode='auto';
ax.YLimMode='auto';
ax.XScale='linear';
ax.YScale='linear';
grid(ax,'on');
end

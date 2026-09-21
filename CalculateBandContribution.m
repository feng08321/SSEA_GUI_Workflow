function BandResult = CalculateBandContribution(Result, binWidth_nm, mode)
% CalculateBandContribution
% Coarse-grain the contribution function into wavelength bins.
%
% mode:
%   'fixed'   : non-overlapping bins
%   'sliding' : sliding window with one wavelength-grid step
%
% Output table fields:
%   BandStart_nm, BandEnd_nm, BandCenter_nm
%   ContributionIntegral, PositiveContribution,
%   NegativeContribution, AbsContribution

if nargin < 2 || isempty(binWidth_nm)
    binWidth_nm = 10;
end
if nargin < 3 || isempty(mode)
    mode = 'fixed';
end

lambda = Result.lambda_nm(:);
C = Result.Contribution(:);

lambdaMin = min(lambda);
lambdaMax = max(lambda);

if strcmpi(mode,'sliding')
    if numel(lambda) > 1
        step_nm = median(diff(lambda));
        if ~isfinite(step_nm) || step_nm <= 0
            step_nm = 1;
        end
    else
        step_nm = 1;
    end
    starts = (lambdaMin:step_nm:(lambdaMax-binWidth_nm)).';
else
    starts = (lambdaMin:binWidth_nm:(lambdaMax-binWidth_nm)).';
end

n = numel(starts);
BandStart_nm = zeros(n,1);
BandEnd_nm = zeros(n,1);
BandCenter_nm = zeros(n,1);
ContributionIntegral = zeros(n,1);
PositiveContribution = zeros(n,1);
NegativeContribution = zeros(n,1);
AbsContribution = zeros(n,1);

for i = 1:n
    a = starts(i);
    b = a + binWidth_nm;
    idx = lambda >= a & lambda <= b;
    BandStart_nm(i) = a;
    BandEnd_nm(i) = b;
    BandCenter_nm(i) = (a+b)/2;

    if nnz(idx) < 2
        ContributionIntegral(i) = NaN;
        PositiveContribution(i) = NaN;
        NegativeContribution(i) = NaN;
        AbsContribution(i) = NaN;
        continue;
    end

    lam_i = lambda(idx);
    C_i = C(idx);

    Cp = C_i; Cp(Cp < 0) = 0;
    Cn = C_i; Cn(Cn > 0) = 0;

    ContributionIntegral(i) = trapz(lam_i, C_i);
    PositiveContribution(i) = trapz(lam_i, Cp);
    NegativeContribution(i) = trapz(lam_i, Cn);
    AbsContribution(i) = trapz(lam_i, abs(C_i));
end

T = table(BandStart_nm, BandEnd_nm, BandCenter_nm, ContributionIntegral, ...
    PositiveContribution, NegativeContribution, AbsContribution);

validPos = PositiveContribution; validPos(~isfinite(validPos)) = -Inf;
validNeg = NegativeContribution; validNeg(~isfinite(validNeg)) = Inf;
validAbs = AbsContribution; validAbs(~isfinite(validAbs)) = -Inf;

[~, ipos] = max(validPos);
[~, ineg] = min(validNeg);
[~, iabs] = max(validAbs);

Summary = table();
Summary.BinWidth_nm = binWidth_nm;
Summary.Mode = string(mode);
Summary.TotalContribution = trapz(lambda, C);
Summary.SumBandContribution = sum(ContributionIntegral(isfinite(ContributionIntegral)));
Summary.MaxPositiveBandCenter_nm = BandCenter_nm(ipos);
Summary.MaxPositiveContribution = PositiveContribution(ipos);
Summary.MaxNegativeBandCenter_nm = BandCenter_nm(ineg);
Summary.MaxNegativeContribution = NegativeContribution(ineg);
Summary.MaxAbsBandCenter_nm = BandCenter_nm(iabs);
Summary.MaxAbsContribution = AbsContribution(iabs);

BandResult = struct();
BandResult.Table = T;
BandResult.Summary = Summary;
BandResult.BinWidth_nm = binWidth_nm;
BandResult.Mode = mode;
BandResult.SourceResult = Result;
end

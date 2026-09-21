function out = CalculateContribution(lambda_grid,Rnorm,Eref_norm,Etest_norm)
C=Rnorm(:).*(Etest_norm(:)-Eref_norm(:));
Ccum=cumtrapz(lambda_grid(:),C);
pos=C; pos(pos<0)=0; neg=C; neg(neg>0)=0;
Apos=trapz(lambda_grid(:),pos); Aneg=trapz(lambda_grid(:),neg); CSSE=trapz(lambda_grid(:),C);
denom=abs(Apos)+abs(Aneg);
if denom>0, CR=1-abs(CSSE)/denom; else, CR=NaN; end
out.Contribution=C; out.CumulativeContribution=Ccum; out.CSSE=CSSE; out.CSSE_percent=CSSE*100;
out.PositiveArea=Apos; out.NegativeArea=Aneg; out.CancellationRatio=CR;
end

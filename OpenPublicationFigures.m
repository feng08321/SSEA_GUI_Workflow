function OpenPublicationFigures(Result)
lambda = Result.lambda_nm;
figure('Name','SSEA - Spectra'); plot(lambda,Result.Eref,'DisplayName','Reference','LineWidth',1.2); hold on; plot(lambda,Result.Etest,'DisplayName','Test','LineWidth',1.2); grid on; xlabel('Wavelength (nm)'); ylabel('Irradiance (W m^{-2} nm^{-1})'); title('Reference and Test Spectra'); legend('Location','best');
figure('Name','SSEA - System Response'); plot(lambda,Result.Rnorm,'DisplayName','R_{norm}','LineWidth',1.2); grid on; xlabel('Wavelength (nm)'); ylabel('Normalized response'); title('System Spectral Response'); legend('Location','best');
figure('Name','SSEA - Contribution Function'); plot(lambda,Result.Contribution,'DisplayName','Contribution','LineWidth',1.2); grid on; xlabel('Wavelength (nm)'); ylabel('Contribution'); title(sprintf('Contribution Function, CSSE = %.4f%%',Result.CSSE_percent)); legend('Location','best');
figure('Name','SSEA - Cumulative Contribution'); plot(lambda,Result.CumulativeContribution,'DisplayName','Cumulative contribution','LineWidth',1.2); grid on; xlabel('Wavelength (nm)'); ylabel('Cumulative contribution'); title('Cumulative Contribution'); legend('Location','best');
end

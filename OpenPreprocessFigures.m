function OpenPreprocessFigures(PreparedReview)
% OpenPreprocessFigures Open editable MATLAB figures for preprocessing review.

lambda = PreparedReview.lambda_nm;

figure('Name','SSEA Preprocess - Prepared Spectra');
plot(lambda, PreparedReview.Eref, 'DisplayName','Reference','LineWidth',1.2); hold on;
plot(lambda, PreparedReview.Etest, 'DisplayName','Test','LineWidth',1.2);
grid on; xlabel('Wavelength (nm)'); ylabel('Irradiance');
title('Prepared Spectra'); legend('Location','best');

figure('Name','SSEA Preprocess - Detector / Absorber');
if ~isempty(PreparedReview.detector)
    d = PreparedReview.detector;
    plot(d.raw_wavelength_nm, d.raw_value, 'o-', 'DisplayName','Raw'); hold on;
    plot(d.raw_wavelength_nm, d.transformed_value, 's-', 'DisplayName','Transformed');
    plot(d.lambda_nm, d.value, '-', 'DisplayName','Prepared');
    grid on; xlabel('Wavelength (nm)'); ylabel('Value');
    title('Detector / Absorber Preprocessing'); legend('Location','best');
else
    plot(lambda, ones(size(lambda)), 'DisplayName','Ideal response');
    grid on; xlabel('Wavelength (nm)'); ylabel('Value');
    title('No Detector: Ideal Response'); legend('Location','best');
end

figure('Name','SSEA Preprocess - Component Curves');
hold on;
if isfield(PreparedReview,'components') && ~isempty(PreparedReview.components)
    for k = 1:numel(PreparedReview.components)
        cp = PreparedReview.components{k};
        [~, nm, ext] = fileparts(cp.filename);
        plot(cp.lambda_nm, cp.value, 'DisplayName', ['C' num2str(k) ' ' nm ext], 'LineWidth',1.1);
    end
else
    plot(lambda, ones(size(lambda)), 'DisplayName','No component');
end
hold off; grid on; xlabel('Wavelength (nm)'); ylabel('Transmission / factor');
title('Component Transmission Curves'); legend('Location','best','Interpreter','none');

figure('Name','SSEA Preprocess - Final System Response');
plot(lambda, PreparedReview.Rsys, 'DisplayName','Rsys','LineWidth',1.2); hold on;
plot(lambda, PreparedReview.Rnorm, 'DisplayName','Rnorm','LineWidth',1.2);
grid on; xlabel('Wavelength (nm)'); ylabel('Response / normalized');
title('Final System Response'); legend('Location','best');
end

function SSEA_GUI_Workflow_v1_0_beta()
% SSEA workflow-style GUI v0.4
% Supports detector/absorber + up to 4 serial components.

app=struct(); app.Result=[]; app.InputAccepted=false; app.DatabaseRoot='';

app.Fig=uifigure('Name','SSEA Workflow GUI v1.0-beta3','Position',[40 30 1480 860]);

g=uigridlayout(app.Fig,[3 3]);
g.RowHeight={64,36,'1x'};
g.ColumnWidth={330,'1x',280};
g.Padding=[8 8 8 8];
g.RowSpacing=8; g.ColumnSpacing=8;

top=uigridlayout(g,[1 14]);
top.Layout.Row=1; top.Layout.Column=[1 3];
top.ColumnWidth={88,78,92,78,90,78,86,86,88,88,82,82,76,'1x',70};
top.Padding=[0 0 0 0];

app.btnDB=uibutton(top,'Text','1 Select DB','FontWeight','bold','ButtonPushedFcn',@onSelectDatabase);
app.btnRefresh=uibutton(top,'Text','2 Refresh','ButtonPushedFcn',@onRefreshLists);
app.btnPre=uibutton(top,'Text','3 Preprocess','FontWeight','bold','ButtonPushedFcn',@onRunPreprocess);
app.btnAccept=uibutton(top,'Text','4 Accept','FontWeight','bold','ButtonPushedFcn',@onAcceptInput);
app.btnCalc=uibutton(top,'Text','5 Calculate','FontWeight','bold','ButtonPushedFcn',@onRunCalculation);
app.btnExport=uibutton(top,'Text','6 Export','ButtonPushedFcn',@onExportResult);
app.ddOpenType=uidropdown(top,'Items',{'Preprocess','Calculate','Batch','Band'},'Value','Calculate');
app.btnOpenSelected=uibutton(top,'Text','Open','ButtonPushedFcn',@onOpenSelectedFigures);
app.btnBatch=uibutton(top,'Text','Batch 18','FontWeight','bold','ButtonPushedFcn',@onRunBatch);
app.btnBand=uibutton(top,'Text','Band Contrib','FontWeight','bold','ButtonPushedFcn',@onBandContribution);

app.btnReset=uibutton(top,'Text','Reset','ButtonPushedFcn',@onReset);
app.lblStatus=uilabel(top,'Text','Status: Ready','HorizontalAlignment','left');
uibutton(top,'Text','Close','ButtonPushedFcn',@(~,~)close(app.Fig));

stepPanel=uipanel(g,'Title','Workflow State');
stepPanel.Layout.Row=2; stepPanel.Layout.Column=[1 3];
sg=uigridlayout(stepPanel,[1 6]); sg.ColumnWidth={'1x','1x','1x','1x','1x','1x'};
app.stepDB=uilabel(sg,'Text','① Database','HorizontalAlignment','center','FontWeight','bold');
app.stepInput=uilabel(sg,'Text','② Input','HorizontalAlignment','center');
app.stepPre=uilabel(sg,'Text','③ Preprocess','HorizontalAlignment','center');
app.stepAccept=uilabel(sg,'Text','④ Accept','HorizontalAlignment','center');
app.stepCalc=uilabel(sg,'Text','⑤ Calculation','HorizontalAlignment','center');
app.stepExport=uilabel(sg,'Text','⑥ Export','HorizontalAlignment','center');

leftPanel=uipanel(g,'Title','Input Panel');
leftPanel.Layout.Row=3; leftPanel.Layout.Column=1;
left=uigridlayout(leftPanel,[31 3]);
left.RowHeight=repmat({24},1,31);
left.ColumnWidth={92,'1x',105};

uilabel(left,'Text','Database','FontWeight','bold'); app.edDB=uieditfield(left,'text','Editable','off'); app.edDB.Layout.Column=[2 3];

uilabel(left,'Text','Reference'); app.ddRef=uidropdown(left,'Items',{},'ValueChangedFcn',@onInputChanged); app.ddRef.Layout.Column=[2 3];
uilabel(left,'Text','Test'); app.ddTest=uidropdown(left,'Items',{},'ValueChangedFcn',@onInputChanged); app.ddTest.Layout.Column=[2 3];

uilabel(left,'Text','Detector','FontWeight','bold'); uilabel(left,'Text','File'); uilabel(left,'Text','Transform');
uilabel(left,'Text','Absorber'); app.ddDetector=uidropdown(left,'Items',{'<none>'},'ValueChangedFcn',@onInputChanged);
app.ddTransform=uidropdown(left,'Items',{'none','percent_to_ratio','reflectance_to_absorptance','reflectance_percent_to_absorptance','absorptance_percent_to_ratio','transmittance_percent_to_ratio'},'ValueChangedFcn',@onInputChanged);
app.ddTransform.Value='reflectance_percent_to_absorptance';

uilabel(left,'Text','Components','FontWeight','bold'); uilabel(left,'Text','File'); uilabel(left,'Text','Transform');
app.compDrop={}; app.compTransform={};
for ii=1:4
    uilabel(left,'Text',['Comp ' num2str(ii)]);
    app.compDrop{ii}=uidropdown(left,'Items',{'<none>'},'ValueChangedFcn',@onInputChanged);
    app.compTransform{ii}=uidropdown(left,'Items',app.ddTransform.Items,'ValueChangedFcn',@onInputChanged);
    app.compTransform{ii}.Value='none';
end

uilabel(left,'Text','Band','FontWeight','bold'); uilabel(left,'Text',''); uilabel(left,'Text','');
uilabel(left,'Text','Preset'); app.ddPreset=uidropdown(left,'Items',{'Broadband 280-4000','PAR 400-700','UVR 280-400','UVA 315-400','UVB 280-315','Custom'},'ValueChangedFcn',@onPresetChanged); app.ddPreset.Layout.Column=[2 3];
uilabel(left,'Text','lambda start'); app.edStart=uieditfield(left,'numeric','Value',280,'ValueChangedFcn',@onInputChanged); app.edStart.Layout.Column=[2 3];
uilabel(left,'Text','lambda end'); app.edEnd=uieditfield(left,'numeric','Value',4000,'ValueChangedFcn',@onInputChanged); app.edEnd.Layout.Column=[2 3];
uilabel(left,'Text','Step'); app.edStep=uieditfield(left,'numeric','Value',1,'ValueChangedFcn',@onInputChanged); app.edStep.Layout.Column=[2 3];
uilabel(left,'Text','Normalize R'); app.cbNorm=uicheckbox(left,'Value',true,'Text','','ValueChangedFcn',@onInputChanged); app.cbNorm.Layout.Column=[2 3];
uilabel(left,'Text','Y scale'); app.ddYScale=uidropdown(left,'Items',{'linear','log'},'Value','log'); app.ddYScale.Layout.Column=[2 3];
uilabel(left,'Text','Export MAT'); app.cbExportMat=uicheckbox(left,'Value',true,'Text',''); app.cbExportMat.Layout.Column=[2 3];

centerPanel=uipanel(g,'Title','Display Panel');
centerPanel.Layout.Row=3; centerPanel.Layout.Column=2;
centerOuterGrid = uigridlayout(centerPanel,[1 1]);
centerOuterGrid.RowHeight={'1x'};
centerOuterGrid.ColumnWidth={'1x'};
centerOuterGrid.Padding=[2 2 2 2];
app.displayTabs = uitabgroup(centerOuterGrid);

app.tabPre = uitab(app.displayTabs,'Title','Preprocess');
preGrid=uigridlayout(app.tabPre,[2 2]); preGrid.RowHeight={'1x','1x'}; preGrid.ColumnWidth={'1x','1x'};
app.axPre1=uiaxes(preGrid); app.axPre1.Layout.Row=1; app.axPre1.Layout.Column=1; title(app.axPre1,'Prepared spectra'); grid(app.axPre1,'on');
app.axPre2=uiaxes(preGrid); app.axPre2.Layout.Row=1; app.axPre2.Layout.Column=2; title(app.axPre2,'Detector / absorber preprocessing'); grid(app.axPre2,'on');
app.axPre3=uiaxes(preGrid); app.axPre3.Layout.Row=2; app.axPre3.Layout.Column=1; title(app.axPre3,'Component transmission curves'); grid(app.axPre3,'on');
app.axPre4=uiaxes(preGrid); app.axPre4.Layout.Row=2; app.axPre4.Layout.Column=2; title(app.axPre4,'Final system response / cumulative'); grid(app.axPre4,'on');

app.tabCalc = uitab(app.displayTabs,'Title','Calculate');
calcGrid=uigridlayout(app.tabCalc,[2 2]); calcGrid.RowHeight={'1x','1x'}; calcGrid.ColumnWidth={'1x','1x'};
app.axCalc1=uiaxes(calcGrid); app.axCalc1.Layout.Row=1; app.axCalc1.Layout.Column=1; title(app.axCalc1,'Prepared spectra'); grid(app.axCalc1,'on');
app.axCalc2=uiaxes(calcGrid); app.axCalc2.Layout.Row=1; app.axCalc2.Layout.Column=2; title(app.axCalc2,'System response & contribution'); grid(app.axCalc2,'on');
app.axCalc3=uiaxes(calcGrid); app.axCalc3.Layout.Row=2; app.axCalc3.Layout.Column=1; title(app.axCalc3,'Contribution Function'); grid(app.axCalc3,'on');
app.axCalc4=uiaxes(calcGrid); app.axCalc4.Layout.Row=2; app.axCalc4.Layout.Column=2; title(app.axCalc4,'Cumulative contribution'); grid(app.axCalc4,'on');

app.tabBatch = uitab(app.displayTabs,'Title','Batch');
batchGrid=uigridlayout(app.tabBatch,[2 2]); batchGrid.RowHeight={'1x','1x'}; batchGrid.ColumnWidth={'1x','1x'};
app.axBatch1=uiaxes(batchGrid); app.axBatch1.Layout.Row=1; app.axBatch1.Layout.Column=[1 2]; title(app.axBatch1,'Batch CSSE sequence'); grid(app.axBatch1,'on');
app.axBatch2=uiaxes(batchGrid); app.axBatch2.Layout.Row=2; app.axBatch2.Layout.Column=1; title(app.axBatch2,'Worst-case CSSE'); grid(app.axBatch2,'on');
app.tblBatchMain=uitable(batchGrid); app.tblBatchMain.Layout.Row=2; app.tblBatchMain.Layout.Column=2;
app.tblBatchMain.ColumnName={'Label','CSSE %','Ratio %'}; app.tblBatchMain.Data={};

app.tabBand = uitab(app.displayTabs,'Title','Band Contribution');
bandGrid=uigridlayout(app.tabBand,[2 2]); bandGrid.RowHeight={'1x','1x'}; bandGrid.ColumnWidth={'1x','1x'};
app.axBand1=uiaxes(bandGrid); app.axBand1.Layout.Row=1; app.axBand1.Layout.Column=[1 2]; title(app.axBand1,'System response & contribution'); grid(app.axBand1,'on');
app.axBand2=uiaxes(bandGrid); app.axBand2.Layout.Row=2; app.axBand2.Layout.Column=1; title(app.axBand2,'Band Contribution, 10 nm'); grid(app.axBand2,'on');
app.axBand3=uiaxes(bandGrid); app.axBand3.Layout.Row=2; app.axBand3.Layout.Column=2; title(app.axBand3,'Band Contribution, 100 nm'); grid(app.axBand3,'on');

app.ax1=app.axPre1; app.ax2=app.axPre2; app.ax3=app.axPre3; app.ax4=app.axPre4;

rightPanel=uipanel(g,'Title','Analysis Panel');
rightPanel.Layout.Row=3; rightPanel.Layout.Column=3;
rightOuterGrid = uigridlayout(rightPanel,[1 1]);
rightOuterGrid.RowHeight={'1x'};
rightOuterGrid.ColumnWidth={'1x'};
rightOuterGrid.Padding=[2 2 2 2];
app.summaryTabs = uitabgroup(rightOuterGrid);

app.tabSummary = uitab(app.summaryTabs,'Title','Summary');
rg=uigridlayout(app.tabSummary,[24 2]); rg.RowHeight=repmat({22},1,24); rg.ColumnWidth={112,'1x'};

uilabel(rg,'Text','Current Analysis','FontWeight','bold'); uilabel(rg,'Text','');
uilabel(rg,'Text','Mode'); app.lblAnalysisMode=uilabel(rg,'Text','Idle');
uilabel(rg,'Text','Spectrum'); app.lblSpectrumMode=uilabel(rg,'Text','-');
uilabel(rg,'Text','Condition'); app.lblCondition=uilabel(rg,'Text','-');
uilabel(rg,'Text','Input Accepted'); app.lblAccepted=uilabel(rg,'Text','No');

uilabel(rg,'Text','Current Metrics','FontWeight','bold'); uilabel(rg,'Text','');
uilabel(rg,'Text','CSSE (%)'); app.edCSSE=uieditfield(rg,'numeric','Editable','off');
uilabel(rg,'Text','Ratio Error (%)'); app.edRatio=uieditfield(rg,'numeric','Editable','off');
uilabel(rg,'Text','Positive Area'); app.edPos=uieditfield(rg,'numeric','Editable','off');
uilabel(rg,'Text','Negative Area'); app.edNeg=uieditfield(rg,'numeric','Editable','off');
uilabel(rg,'Text','Cancellation'); app.edCR=uieditfield(rg,'numeric','Editable','off');

uilabel(rg,'Text','Batch Summary','FontWeight','bold'); uilabel(rg,'Text','');
uilabel(rg,'Text','Worst GHI'); app.lblWorstGHI=uilabel(rg,'Text','-');
uilabel(rg,'Text','Worst DNI'); app.lblWorstDNI=uilabel(rg,'Text','-');

uilabel(rg,'Text','Band Summary','FontWeight','bold'); uilabel(rg,'Text','');
uilabel(rg,'Text','10 nm Positive'); app.lblBandPos=uilabel(rg,'Text','-');
uilabel(rg,'Text','10 nm Negative'); app.lblBandNeg=uilabel(rg,'Text','-');

uilabel(rg,'Text','Last Export'); app.lblExport=uilabel(rg,'Text','');

app.tabBatchTable = uitab(app.summaryTabs,'Title','Batch Table');
btg=uigridlayout(app.tabBatchTable,[1 1]);
app.tblBatch=uitable(btg);
app.tblBatch.ColumnName={'Label','CSSE %','Ratio %'}; app.tblBatch.Data={};

app.tabBandTable = uitab(app.summaryTabs,'Title','Band Table');
bdg=uigridlayout(app.tabBandTable,[2 1]); bdg.RowHeight={'1x','1x'};
app.tblBand10=uitable(bdg); app.tblBand10.Layout.Row=1;
app.tblBand100=uitable(bdg); app.tblBand100.Layout.Row=2;

app.tabLog = uitab(app.summaryTabs,'Title','Log');
lg=uigridlayout(app.tabLog,[1 1]);
app.txtLog=uitextarea(lg,'Editable','off');

try
    app.DatabaseRoot=FindDatabaseRoot(); app.edDB.Value=app.DatabaseRoot; refreshLists(); setStep('Input'); logmsg('Database loaded.');
catch ME
    logmsg(['Database not selected: ' ME.message]); setStep('Database');
end

    function disableBusy(tf)
        buttons = [app.btnDB app.btnRefresh app.btnPre app.btnAccept app.btnCalc app.btnExport app.btnOpenSelected app.btnBatch app.btnBand app.btnReset];
        for bb = buttons
            if tf, bb.Enable='off'; else, bb.Enable='on'; end
        end
        drawnow limitrate;
    end

    function onSelectDatabase(~,~)
        folder=uigetdir(pwd,'Select SSEA Database folder'); if isequal(folder,0), return; end
        app.DatabaseRoot=folder; app.edDB.Value=folder; refreshLists(); resetAcceptance(); setStep('Input'); logmsg('Database selected.');
    end

    function onRefreshLists(~,~)
        refreshLists(); resetAcceptance(); setStep('Input'); logmsg('File lists refreshed.');
    end

    function refreshLists()
        if isempty(app.DatabaseRoot)||~isfolder(app.DatabaseRoot), return; end
        spectra=ListCsvFiles(fullfile(app.DatabaseRoot,'Spectrum')); if isempty(spectra), spectra={'<none>'}; end
        app.ddRef.Items=spectra; app.ddTest.Items=spectra;
        det=[ListCsvFiles(fullfile(app.DatabaseRoot,'Detector')), ListCsvFiles(fullfile(app.DatabaseRoot,'Coating'))];
        if isempty(det), det={'<none>'}; else, det=['<none>',det]; end
        app.ddDetector.Items=det;
        comp=[ListCsvFiles(fullfile(app.DatabaseRoot,'Filter')),ListCsvFiles(fullfile(app.DatabaseRoot,'Diffuser')),ListCsvFiles(fullfile(app.DatabaseRoot,'Window'))];
        if isempty(comp), comp={'<none>'}; else, comp=['<none>',comp]; end
        for ii=1:4
            app.compDrop{ii}.Items=comp;
        end
    end

    function onPresetChanged(~,~)
        switch app.ddPreset.Value
            case 'Broadband 280-4000', app.edStart.Value=280; app.edEnd.Value=4000;
            case 'PAR 400-700', app.edStart.Value=400; app.edEnd.Value=700;
            case 'UVR 280-400', app.edStart.Value=280; app.edEnd.Value=400;
            case 'UVA 315-400', app.edStart.Value=315; app.edEnd.Value=400;
            case 'UVB 280-315', app.edStart.Value=280; app.edEnd.Value=315;
        end
        resetAcceptance();
    end

    function onInputChanged(~,~), resetAcceptance(); end

    function onRunPreprocess(~,~)
        disableBusy(true);
        try
            cfg=buildConfig(); lambda=MakeWavelengthGrid(cfg.lambdaStart_nm,cfg.lambdaEnd_nm,cfg.step_nm);
            ref=PrepareSpectralFunction(cfg.referenceSpectrumFile,lambda,'none',0);
            test=PrepareSpectralFunction(cfg.testSpectrumFile,lambda,'none',0);

            clearAllDisplayAxes();
        if isfield(app,'tblBatch'), app.tblBatch.Data={}; end
        if isfield(app,'tblBatchMain'), app.tblBatchMain.Data={}; end
        if isfield(app,'tblBand10'), app.tblBand10.Data={}; end
        if isfield(app,'tblBand100'), app.tblBand100.Data={}; end
            if isfield(app,'tabPre'), app.displayTabs.SelectedTab = app.tabPre; end
            app.ax1=app.axPre1; app.ax2=app.axPre2; app.ax3=app.axPre3; app.ax4=app.axPre4;
            ResetAxesClean(app.ax1); ResetAxesClean(app.ax2); ResetAxesClean(app.ax3); ResetAxesClean(app.ax4);
            set([app.ax1 app.ax2 app.ax3 app.ax4],'Visible','on');

            plot(app.ax1,ref.lambda_nm,ref.value,'DisplayName','Reference','LineWidth',1.0); hold(app.ax1,'on');
            plot(app.ax1,test.lambda_nm,test.value,'DisplayName','Test','LineWidth',1.0); hold(app.ax1,'off');
            xlabel(app.ax1,'Wavelength (nm)'); ylabel(app.ax1,'Irradiance'); title(app.ax1,'Prepared spectra'); legend(app.ax1,'Location','best'); grid(app.ax1,'on');

            if ~isempty(cfg.detectorFile)
                det=PrepareSpectralFunction(cfg.detectorFile,lambda,cfg.detectorTransform,0);
                if strcmp(app.ddYScale.Value,'log')
                    semilogy(app.ax2,det.raw_wavelength_nm,max(det.raw_value,eps),'o-','DisplayName','Raw'); hold(app.ax2,'on');
                    semilogy(app.ax2,det.raw_wavelength_nm,max(det.transformed_value,eps),'s-','DisplayName','Transformed');
                    semilogy(app.ax2,det.lambda_nm,max(det.value,eps),'-','DisplayName','Prepared');
                else
                    plot(app.ax2,det.raw_wavelength_nm,det.raw_value,'o-','DisplayName','Raw'); hold(app.ax2,'on');
                    plot(app.ax2,det.raw_wavelength_nm,det.transformed_value,'s-','DisplayName','Transformed');
                    plot(app.ax2,det.lambda_nm,det.value,'-','DisplayName','Prepared');
                end
                hold(app.ax2,'off'); xlabel(app.ax2,'Wavelength (nm)'); ylabel(app.ax2,'Value');
                title(app.ax2,'Detector / absorber preprocessing'); legend(app.ax2,'Location','best'); grid(app.ax2,'on');
                Rsys=det.value;
                app.lblAnalysisMode.Text='Preprocess'; if det.qc.hasNaN_prepared||det.qc.hasNegative_prepared, app.lblAnalysisMode.Text='Preprocess WARN'; end
            else
                Rsys=ones(size(lambda));
                plot(app.ax2,lambda,Rsys,'DisplayName','Ideal'); xlabel(app.ax2,'Wavelength (nm)'); ylabel(app.ax2,'Value'); title(app.ax2,'No detector: ideal response'); grid(app.ax2,'on');
                app.lblAnalysisMode.Text='Preprocess';
            end

            cla(app.ax3); hold(app.ax3,'on');
            hasComponent=false;
            preparedComponents={};
            for kk=1:numel(cfg.componentFiles)
                cp=PrepareSpectralFunction(cfg.componentFiles{kk},lambda,cfg.componentTransforms{kk},0);
                preparedComponents{end+1}=cp; %#ok<AGROW>
                Rsys=Rsys.*cp.value;
                [~,nm,ext]=fileparts(cfg.componentFiles{kk});
                lab=['C' num2str(kk) ' ' nm ext];
                plot(app.ax3,lambda,cp.value,'DisplayName',lab,'LineWidth',1.0);
                hasComponent=true;
            end
            if hasComponent
                hold(app.ax3,'off'); xlabel(app.ax3,'Wavelength (nm)'); ylabel(app.ax3,'Transmission / factor'); title(app.ax3,'Component transmission curves'); legend(app.ax3,'Location','best','Interpreter','none'); grid(app.ax3,'on');
            else
                plot(app.ax3,lambda,ones(size(lambda)),'DisplayName','No component: factor=1'); hold(app.ax3,'off'); xlabel(app.ax3,'Wavelength (nm)'); ylabel(app.ax3,'Factor'); title(app.ax3,'No component'); legend(app.ax3,'Location','best'); grid(app.ax3,'on');
            end

            Rnorm=NormalizeVectorMax(Rsys);
            plot(app.ax4,lambda,Rsys,'DisplayName','Rsys'); hold(app.ax4,'on');
            plot(app.ax4,lambda,Rnorm,'DisplayName','Rnorm');
            hold(app.ax4,'off'); xlabel(app.ax4,'Wavelength (nm)'); ylabel(app.ax4,'Response / normalized'); title(app.ax4,'Final system response'); legend(app.ax4,'Location','best'); grid(app.ax4,'on');

            % Save preprocessing review data for editable figures.
            app.PreparedReview = struct();
            app.PreparedReview.lambda_nm = lambda;
            app.PreparedReview.Eref = ref.value;
            app.PreparedReview.Etest = test.value;
            if exist('det','var'), app.PreparedReview.detector = det; else, app.PreparedReview.detector = []; end
            app.PreparedReview.components = {};
            if exist('preparedComponents','var')
                app.PreparedReview.components = preparedComponents;
            end
            app.PreparedReview.Rsys = Rsys;
            app.PreparedReview.Rnorm = Rnorm;

            app.InputAccepted=false; app.lblAccepted.Text='No'; app.Result=[]; app.lblAnalysisMode.Text='Preprocess'; app.lblSpectrumMode.Text='-'; app.lblCondition.Text='-'; setStep('Preprocess'); logmsg('Preprocessing finished. Review spectra, components, and final system response.');
        catch ME
            app.lblAnalysisMode.Text='FAIL'; setStep('Input'); logmsg(['Preprocess error: ' ME.message]); uialert(app.Fig,ME.message,'Preprocess Error');
        end
        disableBusy(false);
        figure(app.Fig);
    end

    function onAcceptInput(~,~)
        app.InputAccepted=true; app.lblAccepted.Text='Yes'; setStep('Accept'); logmsg('Input accepted.');
    end

    function onRunCalculation(~,~)
        if ~app.InputAccepted, uialert(app.Fig,'Please run preprocessing and click Accept Input before calculation.','Input not accepted'); return; end
        disableBusy(true);
        try
            cfg=buildConfig(); app.Result=CalculateSpectralError(cfg); R=app.Result;
            if isfield(app,'tabCalc'), app.displayTabs.SelectedTab = app.tabCalc; end
            app.ax1=app.axCalc1; app.ax2=app.axCalc2; app.ax3=app.axCalc3; app.ax4=app.axCalc4;
            ResetAxesClean(app.ax1); ResetAxesClean(app.ax2); ResetAxesClean(app.ax3); ResetAxesClean(app.ax4);
            plot(app.ax1,R.lambda_nm,R.Eref,'DisplayName','Reference','LineWidth',1.0); hold(app.ax1,'on'); plot(app.ax1,R.lambda_nm,R.Etest,'DisplayName','Test','LineWidth',1.0); hold(app.ax1,'off'); xlabel(app.ax1,'Wavelength (nm)'); ylabel(app.ax1,'Irradiance'); title(app.ax1,'Prepared spectra'); legend(app.ax1,'Location','best'); grid(app.ax1,'on');
            PlotResponseContributionOverlay(R, app.ax2);
            cla(app.ax3); plot(app.ax3,R.lambda_nm,R.Contribution,'DisplayName','Contribution','LineWidth',1.0); xlabel(app.ax3,'Wavelength (nm)'); ylabel(app.ax3,'Contribution'); title(app.ax3,sprintf('Contribution Function, CSSE = %.4f%%',R.CSSE_percent)); grid(app.ax3,'on');
            cla(app.ax4); plot(app.ax4,R.lambda_nm,R.CumulativeContribution,'DisplayName','Cumulative','LineWidth',1.1); xlabel(app.ax4,'Wavelength (nm)'); ylabel(app.ax4,'Cumulative contribution'); title(app.ax4,'Cumulative contribution'); grid(app.ax4,'on');
            app.edCSSE.Value=R.CSSE_percent; app.edRatio.Value=R.Error_ratio_percent; app.edPos.Value=R.PositiveArea; app.edNeg.Value=R.NegativeArea; app.edCR.Value=R.CancellationRatio;

            info = InferSpectrumCondition(R.config.referenceSpectrumFile, R.config.testSpectrumFile);
            app.lblAnalysisMode.Text='Single Calculation';
            app.lblSpectrumMode.Text=info.Mode;
            app.lblCondition.Text=info.Condition;
            title(app.ax1,['Prepared spectra (' info.Label ')']);
            title(app.ax2,['System response & contribution (' info.Label ')']);
            title(app.ax3,sprintf('Contribution Function (%s), CSSE = %.4f%%',info.Label,R.CSSE_percent));
            title(app.ax4,['Cumulative contribution (' info.Label ')']);

            setStep('Calculation'); logmsg(['Calculation finished: ' info.Label]);
        catch ME
            logmsg(['Calculation error: ' ME.message]); uialert(app.Fig,ME.message,'Calculation Error');
        end
        disableBusy(false);
        figure(app.Fig);
    end

    function onExportResult(~,~)
        if isempty(app.Result), uialert(app.Fig,'No result to export.','Export'); return; end
        out=uigetdir(pwd,'Select output folder'); if isequal(out,0), return; end
        baseName=['SSEA_Result_' datestr(now,'yyyymmdd_HHMMSS')];
        ExportSpectralErrorResult(app.Result,out,baseName);
        if app.cbExportMat.Value
            Result=app.Result; Config=app.Result.config; PreparedData=app.Result.Prepared; %#ok<NASGU>
            save(fullfile(out,[baseName '.mat']),'Result','Config','PreparedData');
        end
        app.lblExport.Text=out; setStep('Export'); logmsg(['Result exported to: ' out]);
        figure(app.Fig);
    end

    function onOpenFigures(varargin)
        if isempty(app.Result), uialert(app.Fig,'No result available. Run calculation first.','Open Figures'); return; end
        OpenPublicationFigures(app.Result);
        logmsg('Editable MATLAB figures opened.');
    end


    function onRunBatch(~,~)
        if ~app.InputAccepted
            uialert(app.Fig,'Please run preprocessing and click Accept Input before batch analysis.','Input not accepted');
            return;
        end
        disableBusy(true);
        try
            cfg=buildConfig();
            BatchResult=RunBatchCurrentConfig(cfg, app.DatabaseRoot);
            app.BatchResult=BatchResult;
            if isfield(app,'tabBatch'), app.displayTabs.SelectedTab = app.tabBatch; end
            ResetAxesClean(app.axBatch1); ResetAxesClean(app.axBatch2);
            PlotBatchResult(BatchResult, app.axBatch1, app.axBatch2);
            S=BatchResult.Summary;
            app.lblAnalysisMode.Text='Batch18';
            app.lblSpectrumMode.Text='GHI + DNI';
            app.lblCondition.Text='Cond01-Cond09';
            idxG = find(strcmp(S.Mode,'GHI'),1);
            idxD = find(strcmp(S.Mode,'DNI'),1);
            if ~isempty(idxG)
                app.lblWorstGHI.Text=sprintf('Cond%02d, %.4f%%', S.WorstCondition(idxG), S.MaxAbsCSSE_percent(idxG));
            end
            if ~isempty(idxD)
                app.lblWorstDNI.Text=sprintf('Cond%02d, %.4f%%', S.WorstCondition(idxD), S.MaxAbsCSSE_percent(idxD));
            end
            Tb=MakeBatchSummaryTable(BatchResult);
            batchData=[cellstr(Tb.Label), num2cell(Tb.CSSE_percent), num2cell(Tb.RatioError_percent)];
            app.tblBatch.Data=batchData;
            if isfield(app,'tblBatchMain'), if isfield(app,'tblBatchMain'), app.tblBatchMain.Data=batchData; end end
            msg=sprintf('Batch finished. %s max=%.4f%%, %s max=%.4f%%.', S.Mode{1}, S.MaxAbsCSSE_percent(1), S.Mode{2}, S.MaxAbsCSSE_percent(2));
            logmsg(msg);
            out=fullfile(pwd,'Result');
            baseName=['SSEA_Batch_' datestr(now,'yyyymmdd_HHMMSS')];
            ExportBatchResult(BatchResult,out,baseName);
            app.lblExport.Text=out;
            setStep('Calculation');
        catch ME
            logmsg(['Batch error: ' ME.message]);
            uialert(app.Fig,ME.message,'Batch Error');
        end
        disableBusy(false);
        figure(app.Fig);
    end



    function onOpenSelectedFigures(~,~)
        switch app.ddOpenType.Value
            case 'Preprocess'
                onOpenPreprocessFigures();
            case 'Calculate'
                onOpenFigures();
            case 'Batch'
                onOpenBatchFigures();
            case 'Band'
                onOpenBandContributionFigures();
        end
    end

    function onOpenPreprocessFigures(varargin)
        if ~isfield(app,'PreparedReview') || isempty(app.PreparedReview)
            uialert(app.Fig,'No preprocessing review available. Run Preprocess first.','Open Preprocess Figures');
            return;
        end
        OpenPreprocessFigures(app.PreparedReview);
        logmsg('Editable preprocessing figures opened.');
    end

    function onOpenBatchFigures(varargin)
        if ~isfield(app,'BatchResult') || isempty(app.BatchResult)
            uialert(app.Fig,'No batch result available. Run Batch 18 first.','Open Batch Figures');
            return;
        end
        OpenBatchFigures(app.BatchResult);
        logmsg('Editable batch figures opened.');
    end


    function onBandContribution(~,~)
        if isempty(app.Result)
            uialert(app.Fig,'No calculation result available. Run Calculate first.','Band Contribution');
            return;
        end
        disableBusy(true);
        try
            app.BandResult10 = CalculateBandContribution(app.Result, 10, 'fixed');
            app.BandResult100 = CalculateBandContribution(app.Result, 100, 'fixed');

            if isfield(app,'tabBand'), app.displayTabs.SelectedTab = app.tabBand; end
            ResetAxesClean(app.axBand1); ResetAxesClean(app.axBand2); ResetAxesClean(app.axBand3);
            PlotResponseContributionOverlay(app.Result, app.axBand1);
            PlotBandContribution(app.BandResult10, app.axBand2);
            PlotBandContribution(app.BandResult100, app.axBand3);
            if isfield(app,'tblBand10'), app.tblBand10.Data=app.BandResult10.Table; end
            if isfield(app,'tblBand100'), app.tblBand100.Data=app.BandResult100.Table; end

            out=fullfile(pwd,'Result');
            baseName=['SSEA_BandContribution_' datestr(now,'yyyymmdd_HHMMSS')];
            ExportBandContributionResult(app.BandResult10, app.BandResult100, out, baseName);
            app.lblExport.Text=out;

            S10 = app.BandResult10.Summary;
            app.lblAnalysisMode.Text='Band Contribution';
            app.lblBandPos.Text=sprintf('%.1f nm, %.4g', S10.MaxPositiveBandCenter_nm, S10.MaxPositiveContribution);
            app.lblBandNeg.Text=sprintf('%.1f nm, %.4g', S10.MaxNegativeBandCenter_nm, S10.MaxNegativeContribution);
            msg=sprintf('Band contribution finished. 10nm max positive @ %.1f nm, max negative @ %.1f nm.', ...
                S10.MaxPositiveBandCenter_nm, S10.MaxNegativeBandCenter_nm);
            logmsg(msg);
        catch ME
            logmsg(['Band contribution error: ' ME.message]);
            uialert(app.Fig,ME.message,'Band Contribution Error');
        end
        disableBusy(false);
        figure(app.Fig);
    end

    function onOpenBandContributionFigures(varargin)
        if ~isfield(app,'BandResult10') || isempty(app.BandResult10)
            uialert(app.Fig,'No band contribution result available. Run Band Contrib first.','Open Band Contribution Figures');
            return;
        end
        OpenBandContributionFigures(app.BandResult10, app.BandResult100, app.Result);
        logmsg('Editable band contribution figures opened.');
    end

    function clearAllDisplayAxes()
        axNames = {'axPre1','axPre2','axPre3','axPre4','axCalc1','axCalc2','axCalc3','axCalc4','axBatch1','axBatch2','axBand1','axBand2','axBand3','ax1','ax2','ax3','ax4'};
        for ii = 1:numel(axNames)
            nm = axNames{ii};
            if isfield(app,nm) && isvalid(app.(nm))
                ResetAxesClean(app.(nm));
            end
        end
    end

    function onReset(~,~)
        app.Result=[]; app.PreparedReview=[]; app.BatchResult=[]; app.BandResult10=[]; app.BandResult100=[]; resetAcceptance(); app.lblAnalysisMode.Text='Idle'; setStep('Input');
        app.edCSSE.Value=0; app.edRatio.Value=0; app.edPos.Value=0; app.edNeg.Value=0; app.edCR.Value=0;
        app.lblAnalysisMode.Text='Idle'; app.lblSpectrumMode.Text='-'; app.lblCondition.Text='-';
        app.lblWorstGHI.Text='-'; app.lblWorstDNI.Text='-'; app.lblBandPos.Text='-'; app.lblBandNeg.Text='-';
        app.tblBatch.Data={};
        clearAllDisplayAxes();
        if isfield(app,'tblBatch'), app.tblBatch.Data={}; end
        if isfield(app,'tblBatchMain'), app.tblBatchMain.Data={}; end
        if isfield(app,'tblBand10'), app.tblBand10.Data={}; end
        if isfield(app,'tblBand100'), app.tblBand100.Data={}; end
        title(app.ax1,'Prepared spectra'); title(app.ax2,'Detector / absorber preprocessing'); title(app.ax3,'Component transmission curves'); title(app.ax4,'Final system response / cumulative');
        logmsg('Reset finished.');
    end

    function cfg=buildConfig()
        if isempty(app.DatabaseRoot)||~isfolder(app.DatabaseRoot), error('Database folder is invalid.'); end
        if strcmp(app.ddRef.Value,'<none>')||strcmp(app.ddTest.Value,'<none>'), error('Reference/Test spectrum not selected.'); end
        cfg=struct(); cfg.referenceSpectrumFile=fullfile(app.DatabaseRoot,'Spectrum',app.ddRef.Value); cfg.testSpectrumFile=fullfile(app.DatabaseRoot,'Spectrum',app.ddTest.Value);
        detName=app.ddDetector.Value;
        if strcmp(detName,'<none>'), cfg.detectorFile='';
        else
            p1=fullfile(app.DatabaseRoot,'Detector',detName); p2=fullfile(app.DatabaseRoot,'Coating',detName);
            if isfile(p1), cfg.detectorFile=p1; elseif isfile(p2), cfg.detectorFile=p2; else, error('Detector/coating file not found.'); end
        end
        cfg.detectorTransform=app.ddTransform.Value;
        cfg.componentFiles={}; cfg.componentTransforms={};
        for kk=1:4
            compName=app.compDrop{kk}.Value;
            if strcmp(compName,'<none>'), continue; end
            folders={'Filter','Diffuser','Window'}; found='';
            for ii=1:numel(folders)
                pp=fullfile(app.DatabaseRoot,folders{ii},compName); if isfile(pp), found=pp; break; end
            end
            if isempty(found), error(['Component file not found: ' compName]); end
            cfg.componentFiles{end+1}=found; %#ok<AGROW>
            cfg.componentTransforms{end+1}=app.compTransform{kk}.Value; %#ok<AGROW>
        end
        cfg.lambdaStart_nm=app.edStart.Value; cfg.lambdaEnd_nm=app.edEnd.Value; cfg.step_nm=app.edStep.Value; cfg.useNormalizedR=app.cbNorm.Value;
    end

    function resetAcceptance()
        app.InputAccepted=false; app.lblAccepted.Text='No';
    end

    function setStep(stepName)
        app.lblStep.Text=stepName;
        labs={app.stepDB,app.stepInput,app.stepPre,app.stepAccept,app.stepCalc,app.stepExport};
        texts={'① Database','② Input','③ Preprocess','④ Accept','⑤ Calculation','⑥ Export'};
        for ii=1:numel(labs), labs{ii}.FontWeight='normal'; labs{ii}.Text=texts{ii}; end
        switch stepName
            case 'Database', app.stepDB.FontWeight='bold'; app.stepDB.Text='▶ ① Database';
            case 'Input', app.stepInput.FontWeight='bold'; app.stepInput.Text='▶ ② Input';
            case 'Preprocess', app.stepPre.FontWeight='bold'; app.stepPre.Text='▶ ③ Preprocess';
            case 'Accept', app.stepAccept.FontWeight='bold'; app.stepAccept.Text='▶ ④ Accept';
            case 'Calculation', app.stepCalc.FontWeight='bold'; app.stepCalc.Text='▶ ⑤ Calculation';
            case 'Export', app.stepExport.FontWeight='bold'; app.stepExport.Text='▶ ⑥ Export';
        end
    end

    function logmsg(msg)
        ts=datestr(now,'HH:MM:SS'); old=app.txtLog.Value; if ischar(old), old={old}; end
        app.txtLog.Value=[{[ts '  ' msg]}; old(:)]; app.lblStatus.Text=['Status: ' msg];
        drawnow limitrate;
    end
end

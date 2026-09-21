# SSEA GUI Workflow

**Companion software for ISO 24871-6** — clear-sky spectral error test method based on ISO 9060.

A MATLAB GUI application for evaluating the clear-sky spectral error of solar radiation measurement instruments, following the ISO 24871-6 test method based on ISO 9060.

## Features

- Six-step workflow: Select DB → Refresh → Preprocess → Accept → Calculate → Export
- Spectral response-chain modeling for a detector / absorber plus up to 4 cascaded components
- Spectral Error calculation, Batch processing, and Band Contribution analysis
- Display Panel with tabbed plots: Preprocess / Calculate / Batch / Band Contribution
- Analysis Panel with Summary / Batch Table / Band Table / Log
- Results exportable to CSV / MAT, with publication-quality figure output

## Usage

- Environment: MATLAB (requires `uifigure`; R2020b or later recommended)
- Entry point: run `Run_GUI_v1_0_beta10` in MATLAB

```matlab
Run_GUI_v1_0_beta10
```

## Database Structure

| Directory | Contents |
|---|---|
| `Database/Spectrum` | Reference / test solar spectra (CSV) |
| `Database/Example` | ISO 24871 DNI / GHI example spectra |
| `Database/Detector` | Detector spectral responsivity data |
| `Database/Coating` | Coating spectral data |
| `Database/Window` | Window material spectral data |
| `Database/Metadata` | Metadata (JSON) for each data file |

## Changelog

### v1.0-beta10 (current)
- Fixed the residual right-side yyaxis in the Preprocess top-right plot: the transform-validation plot no longer calls ResetAxesClean (which triggered yyaxis); it now clears the axes directly and draws with a single linear axis
- The top-right plot now shows Raw reflectance / 100, Converted absorptance, and Prepared response
- Calculation logic unchanged

### v1.0-beta9
- Fixed the v1.0-beta8 Preprocess error "unrecognized field OutputFolder"; debug export now uses `app.outputFolder`, falling back to a local `Result` folder when absent

### v1.0-beta8
- Preprocess top-right plot changed to Detector / absorber transform validation: Raw reflectance / 100, Converted absorptance = 1 − R/100, Prepared response
- Summary tab adds a Transform Check section (Raw / Converted / Prepared min-max)
- Preprocess stage auto-exports debug files (`Result/Debug_DetectorTransform_*.csv/txt`)

### v1.0-beta7
- Fixed the Detector / absorber preprocessing plot display logic; when the raw-data transform involves percent, the Raw curve is plotted as raw/100 (display only)
- Calculation unchanged: `reflectance_percent_to_absorptance` still converts as 1 − R/100

### v1.0-beta6
- Preprocess plots now also rebuild the uiaxes before drawing, avoiding stale yyaxis residue
- Unified the embedded-plot refresh logic across Preprocess / Calculate / Batch / Band stages

### v1.0-beta5
- Fixed GUI plot colors and stale yyaxis residue; the Batch page bottom-right view changed to a CSSE heatmap

### v1.0-beta4
- Fixed a MATLAB syntax error at v1.0-beta3 line 383 (a single-line `if` form not accepted by MATLAB R2022a)

### v1.0-beta3
- Display Panel tabs (Preprocess / Calculate / Batch / Band Contribution) now render correctly
- Analysis Panel tabs (Summary / Batch Table / Band Table / Log) are pinned to the top and fill the right panel
- Automatic switch to the corresponding Display tab at each workflow stage
- Batch / Band plots use dedicated axes; fixed the axBatch1 / axBand1 field errors
- ResetAxesClean is called before plotting at each stage, reducing stale plots and yyaxis residue

### v1.0-beta2
- Fixed tab container positioning, Analysis Panel top display, and Reset field errors

### v1.0-beta
- Display Panel converted to tabs: Preprocess / Calculate / Batch / Band Contribution
- Analysis Panel converted to tabs: Summary / Batch Table / Band Table / Log
- System response and Contribution changed to single-axis normalized overlays
- Reset uses ResetAxesClean, avoiding yyaxis residue
- Batch and Band plots no longer overlap

> Earlier iterations (v0.4 – v0.9) are not included in this repository.

## License

Distributed under the [MIT License](LICENSE).

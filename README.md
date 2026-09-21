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
- Entry point: run `Run_GUI_v1_0_beta3` in MATLAB

```matlab
Run_GUI_v1_0_beta3
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

### v1.0-beta3 (current)
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

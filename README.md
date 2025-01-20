# 3D Mineral Estimation

This repository contains a series of codes for the 3D estimation of mineral reservoirs. The workflows and scripts provided aim to support geophysical data processing, inversion modeling, and visualization for mineral exploration and resource estimation. The repository includes Jupyter Notebooks, MATLAB scripts, and other utilities that cover tasks such as magnetic inversion, array design, and data prediction.

## Repository Structure

Below is a brief description of the files and folders included in this repository:

### Jupyter Notebooks
- **1-magnetic-inversion-raglan-reproduce.ipynb**: Notebook for reproducing magnetic inversion results based on the Raglan dataset.
- **2-linear-inversion-app.ipynb**: Linear inversion application for geophysical data.
- **3-magnetic-inversion-raglan-lp.ipynb**: Magnetic inversion using Lp-norm regularization.

### MATLAB Scripts
- **Arraydesign.m**: Script for designing geophysical survey arrays.
- **Arraydesign2Res2DINV.m**: Array design tailored for 2D resistivity inversion.
- **Arraydesign2Res2DINV_v20231204_EW.m**: East-West configuration for 2D resistivity array design.
- **Arraydesign2Res2DINV_v20231204_SN.m**: North-South configuration for 2D resistivity array design.
- **Arraydesign2Res2DINV_v20231204_SNandEW.m**: Combined North-South and East-West configuration for 2D resistivity array design.
- **Arraydesign3D.m**: Array design script for 3D geophysical surveys.
- **IPRS3D.m**: 3D inversion parameter reconstruction script.
- **XYDensityplot.m**: Script for creating density plots in the XY plane.
- **MN2XY_v20231206.m**: Conversion utility for coordinate transformations.

### Data Processing Utilities
- **PredictionPrepar.m**: Prepares data for prediction modeling.
- **digitize2.m**: Digitization tool for geophysical data.
- **dis4z.m**: Depth-specific data processing utility.
- **importfile_cudepth.m**: Script to import and process depth data.
- **roughVolume.m**: Volume calculation for rough surfaces.
- **scatter_kde.m**: Kernel density estimation for scatter plots.

### Additional Files
- **MAG_GR 3D**: Directory for managing magnetic and gravity data in 3D models.

## Getting Started

### Prerequisites
- MATLAB for running `.m` scripts.
- Python (with Jupyter Notebook) for `.ipynb` files.
- Required libraries: NumPy, SciPy, Matplotlib, Pandas (for Python).

### Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/VTeknik/3D-Mineral-estimation.git

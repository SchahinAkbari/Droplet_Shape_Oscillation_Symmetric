README – Inviscid Axisymmetric Droplet Shape Oscillations Simulation Post-Processing
Author: Schahin Akbari
Chair of Fluid Dynamics, TU Darmstadt
Date: Dec 16, 2025

1. Directory Structure

The `Post_Processing` folder has the following main structure:
- Animation/
- Data/
- Energy_and_Volume_Plots/
- Plots/

2. Folder Descriptions

- Animation/
  Contains the code to generate a 3D animation of the droplet with curvature.
  It accesses the `Data` folder, where the droplet radius is explicitly defined.

- Data/
  Contains two subfolders:

  a) Energy_Volume_Area_Center_Of_Mass/
     Stores values for:
     - Energy error
     - Volume error
     - Relative north pole position
     - Droplet surface area

  b) Vector_Storages/
     Stores all coefficients at all time points, organized by the respective initial deformation modes.
     - The naming convention follows: `<cutoff_degree>_<excited_mode>_<amplitude>`.
     - Each part is separated by an underscore `_`.

- Energy_and_Volume_Plots/
  Contains post-processing routines to generate images from the simulation data.
  The main MATLAB file for this is: `Vol_Ener_Sym_Num_Post_Processing.m`.

- Plots/
  This directory is used to create and store all plots. It contains the following subfolders:

  1) Code/
     Required to save MATLAB figures as `.eps` files.

  2) Figure/
     Contains MATLAB-generated figures (Code at Plots/Matlab_Generated_Figure) using data from `Data/Energy_Volume_Area_Center_Of_Mass`.

  3) Manually_Generated_Figure/
     Manually created images are stored here.

  4) Matlab_Generated_Figure/
     Contains the MATLAB code used to generate each figure.

3. Contact

For questions or support, please contact:

akbari@fdy.tu-darmstadt.de

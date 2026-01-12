README – Inviscid Axisymmetric Droplet Shape Oscillations Simulation Pre-Processing
Author: Schahin Akbari
Chair of Fluid Dynamics, TU Darmstadt
Date: Dec 16, 2025

1. Directory Structure

The `Pre_Processing` folder contains a subfolder named `Main_Simulation_Files`, which is organized as follows:

- Main/
  Contains the primary solver for simulating inviscid axisymmetric droplet shape oscillations.
  Filename: Main_Maple_XX_BDFX_V.txt

- Restart/
  Contains the same solver, but instead of using initial conditions, it resumes the simulation from the last saved time step.

2. Solver Configuration

Main Solver (Main_Maple_XX_BDFX_V.txt)

- Initial Conditions:
  Set in lines 24–27 of the file.

- Time Step:
  Set in lines 28 of the file.

Restart Solver

- Does not use initial conditions. Instead, it takes input from the last saved time step.
- Input lines: 21–22

3. Running the Solver

Use the following command to run Maple 2024 from the command line:

/c/Program\ Files/Maple\ 2024/bin.X86_64_WINDOWS/cmaple.exe < Main_Maple_XX_BDFX_V.txt

Make sure Maple 2024 is installed and the path matches your system configuration.

4. Contact

For questions or support, please contact:

akbari@fdy.tu-darmstadt.de

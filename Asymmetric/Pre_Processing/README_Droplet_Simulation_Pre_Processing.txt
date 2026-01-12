README – Inviscid Non-Axisymmetric Droplet Shape Oscillations Simulation Pre-Processing
Author: Schahin Akbari
Chair of Fluid Dynamics, TU Darmstadt
Date: August 20, 2025

1. Directory Structure

The `Numerical` folder organized as follows:

- Main/
  Contains the primary solver for simulating inviscid axisymmetric droplet shape oscillations.
  Filename: Start.m --> Main_A.m

- Restart/
  Contains the same solver, but instead of using initial conditions, it resumes the simulation from the last saved time step.
  Filename: Restart_A.m 
  
The `Analytical_Pluemacher_et_al_2020` folder contains the Methode of Pluemacher et. al (2020). 
The solver is writen in Matlab and is based on the Poincaré expansion method up to second order.
  
  
2. Solver Configuration

Solver (Start.m)

- Solver needs 2 Inputs (CutoffDegree n and the Amplitude).

In Row 4 the Initial Deformation Mode is set. 

Restart Solver (Restart_A.m)

- Does not use initial conditions. Instead, it takes input from the last saved time step.

Make sure MATLAB 2024 is installed.

4. Contact

For questions or support, please contact:

akbari@fdy.tu-darmstadt.de

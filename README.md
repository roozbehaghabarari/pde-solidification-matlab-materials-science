# pde-solidification-matlab-materials-science
<<<<<<< HEAD
This repository contains a MATLAB implementation of a numerical model to simulate heat transfer and isothermal solidification in a steel ingot using partial differential equations (PDEs). The model applies an explicit finite difference scheme to solve the transient heat conduction equation with phase change.

## Overview

The objective of this project is to study the thermal behavior and solidification dynamics of a steel ingot using a 2D PDE-based approach. The simulation incorporates thermophysical properties, boundary and initial conditions, and a fixed mold temperature to replicate realistic cooling scenarios. The outputs include temperature distributions, isotherms, and solid fraction evolution over time at specific locations within the ingot.
The simulation is fully implemented in MATLAB using a single, well-structured script.

## Repository Structure

pde-matlab-code/        → MATLAB script implementing the PDE-based simulation  
pde-matlab-outputs/     → Output figures, plots, and temperature data  
DOCUMENT.pdf            → Detailed report explaining the methodology, equations, and results  

The MATLAB script in the pde-matlab-code/ folder is extensively commented and follows the mathematical formulation of the model. The pde-matlab-outputs/ folder contains visual outputs such as isotherm plots and graphs of solid fraction over time.

## Physical and Numerical Model

    Geometry: 2D transverse cross-section of a steel ingot

    PDE: Transient heat conduction with latent heat during solidification

    Method: Finite difference method (explicit scheme only)

    Grid: 80 × 80 uniform square mesh

    Boundary condition: Fixed temperature at the ingot/mold interface

    Initial condition: Uniform molten steel at 1535 °C

    Melting temperature: 1500 °C

    Thermophysical properties: Based on references; distinct heat capacities used for solid and liquid phases

## Key Simulation Features

    Time step selected based on the Fourier number (0.1) to ensure stability (theoretical limit: 0.375)

    Evaluation of temperature and solid fraction at:

        x = y = 0.1905 m (center of the ingot quarter)

        x = y = 0.381 m (center of the ingot)

    Visualization of isotherms and solidification fronts over time

## Documentation

A comprehensive report (DOCUMENT.pdf) is included, detailing:

    Mathematical formulation of the PDE model

    Numerical method and stability considerations

    Simulation parameters and assumptions

    Analysis and interpretation of results

## Author

This project was developed by Roozbeh Aghabarari during Spring 2024.

## Acknowledgements

The thermophysical data and modeling methods are based on established materials science references and academic literature in heat transfer and solidification. Special thanks to Dr. Rouhollah Tavakoli for his mentorship and support.

## Contact

    Email: ro.aghabarari@gmail.com

    Website: www.roozbehaghabarari.com

## License

This repository is intended for academic and educational use. Please cite the author if you use or adapt this work.

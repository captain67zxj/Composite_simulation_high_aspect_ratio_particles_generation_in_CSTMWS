# Composite_simulation_high_aspect_ratio_particles_generation_in_CSTMWS

This repo. contians codes used in:
    X.Zhu, A.J.Fairbanks, T.D.Crawford, A.L.Garner, Modelling effective electromagnetic properties of composites containing barium strontium titanate and/or nickel zinc ferrite inclusions from 1-4 GHz, Compos. Sci. Technol. 214 (2021) 108978. https://doi.org/10.1016/j.compscitech.2021.108978.

The first part is to generate the coordinates and Euler angles of non-overlapping ellipsoids with random orientations for a specified volume fraction and aspect ratio in a 3D rectangle object using the Matlab code from:
    M.A.Tschopp, 3-D synthetic microstructure generation with ellipsoid particles, Tech. Report, Weapons Mater. Res. Dir. US Army Res. Lab. Aberdeen Proving Ground, United States. (n.d.). https://apps.dtic.mil/sti/citations/AD1017883.
Note that the rotation matrix was changed in the modifed code.

The second part is to generate the ellipsoids using the coordinates and Euler angles generated from Matlab using Macros in CST Microwave Studio (CST MWS). 

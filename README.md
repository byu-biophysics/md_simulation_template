# MD Simulation Template

## Scripts
- `sub.sh` --> This script is the main submission script. You will need to modify certain things in the file highlighted with TODO comments before you can submit depending on your initial structure and the type of simulation you are running (if you are going to be adding external forces, etc). This should be run with sbatch.
- `cont.sh` --> This script is to restart any simulation that times out before you can get the desired simulation duration. It will continue the simulation where it left off. You will have to make slight modifications mentioned in the script if you are or aren't using external forces. This should be run with sbatch.
- `out.sh` --> This script uses the completed trajectory and pdb file to create an output pdb and trajectory excluding everything but the proteins, so the size is much more manageable. Just run this using source or ./out.sh

## Parameter Files
- `ions.mdp` --> This defines how the ions will be added to neutralize the system charge, and shouldn't need to be modified.
- `em.mdp` --> This defines the energy minimization run, you can alter this based on what your system needs.
- `eq.mdp` --> This defines the equilibration run, you can alter this based on what your system needs.
- `md.mdp` --> This defines the md run, you will need to alter this specifically if you are going to add external forces via constant velocity or acceleration

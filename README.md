# BrainWavesToolbox

The Brain Waves Toolbox for fMRI data is based on the approach by Gu et al. 2021 (Cerebral Cortex) and accompanying code.


It allows to extract the first components of delay profiles around peaks of global signal, and use them to investigate the propagations of "waves" of activity in the brain.


Before using it, replace the paths to the folders at the top of BWToolboxGUI.m

BWT uses fieldtrip and inpaintnan.

You will also need the FT_Filter_mulch2.m function shared by Gu et al. 2021.


The input folder should contain the data of all subjects, sessions and tasks, named after BIDS convention (.dtseries.nii files; you can replace the suffix in the .m files).


The "Run SVD" button extracts the main components and saves the first five.

The "Run BW" button does the analysis of the waves using the entered gradient file (e.g. the output from SVD step).


Any comments or bug reports can be sent to makimarttunen.veronica@gmail.com

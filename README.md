# BrainWavesToolbox

The **Brain Waves Toolbox** for fMRI data is based on the approach by Gu et al. 2021 (Cerebral Cortex, Brain activity fluctuations propagate as waves traversing the cortical hierarchy) and accompanying code (https://github.com/YamengGu/the-cross-hierarchy-propagation).


It allows to extract the first components of delay profiles around peaks of fMRI global signal, and use them to investigate the propagations of waves of activity in the brain.


Before using it, replace the paths to the folders at the top of BWToolboxGUI.m

BWT uses fieldtrip and inpaintnan.


The input folder should contain the data of all subjects, sessions and tasks, named after BIDS convention (.dtseries.nii files; you can replace the suffix in the .m files).

Run by calling the BWToolboxGUI function in the MATLAB command window.

The "Run SVD" button extracts the main components and saves the first five.

The "Run BW" button does the analysis of the waves using the entered gradient file (e.g. the output from SVD step).

This code is provided 'as is' and without warranties. If you use this tool, please cite the authors of the original code as well as:

Mäki-Marttunen V, Nieuwenhuis ST. Neuromodulatory influences on propagation of traveling waves along the unimodal-transmodal gradient. Cereb Cortex. 2025 Jul 1;35(7):bhaf183. doi: 10.1093/cercor/bhaf183. Erratum in: Cereb Cortex. 2025 Aug 1;35(8):bhaf236. doi: 10.1093/cercor/bhaf236.

Any comments or bug reports can be sent to makimarttunen.veronica@gmail.com

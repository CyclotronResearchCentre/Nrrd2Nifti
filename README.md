# Nrrd2Nifti
Some functions to convert images in NRRD format into Nifti format.

This is written to handle the data from the ["MS lesion segmentation 08" challenge](http://www.ia.unc.edu/MSseg/index.html): they are available in NRRD format but I want them into Nifti format. For a nice and complete description of the NRRD format, see [this place](http://teem.sourceforge.net/nrrd/index.html) and for Nifti there is [this one](http://nifti.nimh.nih.gov/). 

Obviously I have not started from scratch! The reader function for the NRRD that are available [here](https://github.com/jefferislab/MatlabSupport/tree/master/nrrdio) and I am relying on [SPM12](http://www.fil.ion.ucl.ac.uk/spm/software/spm12/) routines for the creation of the Nifti file. The rest is just wrapping around the existing functions...
